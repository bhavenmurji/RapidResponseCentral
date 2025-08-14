# FamMED Central - Question Bank Integration Guide

## Overview

This guide details how to integrate the existing AAFP question bank (3,092 items) into the FamMED Central application.

## 📦 Content Inventory

### Current Assets
- **2,128 AAFP Articles** in markdown format
- **598 ITE Questions** (2022-2024) with answers and explanations
- **366 CME Flashcards** with detailed content
- **100% Cross-referenced** relationships between content

### File Locations
```
/Users/bhavenmurji/My Drive/Shared Ignite/QtoAAFP/
├── Articles/           # 2,128 AAFP articles
│   ├── 2022/
│   ├── 2023/
│   ├── 2024/
│   └── 2025/
└── Test Bank/         # 964 total questions
    ├── ITE/           # 598 ITE questions
    └── Flashcards/    # 366 CME flashcards
```

## 🔄 Data Migration Process

### Phase 1: Data Extraction

#### 1.1 Parse Markdown Files

```python
import os
import yaml
import json
from pathlib import Path

class QuestionBankExtractor:
    def __init__(self, base_path):
        self.base_path = Path(base_path)
        self.questions = []
        self.articles = []
        self.cross_references = []
    
    def extract_questions(self):
        """Extract all questions from markdown files"""
        question_dir = self.base_path / "Test Bank"
        
        for md_file in question_dir.rglob("*.md"):
            with open(md_file, 'r') as f:
                content = f.read()
                
                # Parse YAML frontmatter
                if content.startswith('---'):
                    _, fm, body = content.split('---', 2)
                    metadata = yaml.safe_load(fm)
                    
                    question = {
                        'legacy_id': metadata.get('id'),
                        'type': metadata.get('type'),
                        'year': metadata.get('year'),
                        'number': metadata.get('number'),
                        'answer': metadata.get('answer'),
                        'topics': metadata.get('topics', []),
                        'content': body.strip()
                    }
                    
                    # Extract question text and choices
                    question.update(self.parse_question_body(body))
                    
                    # Extract cross-references
                    if 'related_articles' in metadata:
                        for article in metadata['related_articles']:
                            self.cross_references.append({
                                'question_id': question['legacy_id'],
                                'article_path': article['path'],
                                'relevance_score': article['similarity']
                            })
                    
                    self.questions.append(question)
        
        return self.questions
    
    def parse_question_body(self, body):
        """Parse question text, choices, and explanation"""
        lines = body.split('\n')
        
        question_text = []
        choices = {}
        explanation = []
        references = []
        
        section = 'question'
        
        for line in lines:
            if line.startswith('## Question'):
                section = 'question'
            elif line.startswith('## Answer Choices'):
                section = 'choices'
            elif line.startswith('## Correct Answer'):
                section = 'answer'
            elif line.startswith('## Explanation'):
                section = 'explanation'
            elif line.startswith('## References'):
                section = 'references'
            elif section == 'question' and line.strip():
                question_text.append(line)
            elif section == 'choices' and line.strip():
                if line.startswith(('A)', 'B)', 'C)', 'D)', 'E)')):
                    choice_letter = line[0]
                    choice_text = line[3:].strip()
                    choices[choice_letter] = choice_text
            elif section == 'explanation' and line.strip():
                explanation.append(line)
            elif section == 'references' and line.strip():
                references.append(line.strip('- '))
        
        return {
            'question_text': '\n'.join(question_text),
            'choices': choices,
            'explanation': '\n'.join(explanation),
            'references': references
        }
    
    def extract_articles(self):
        """Extract all articles from markdown files"""
        article_dir = self.base_path / "Articles"
        
        for md_file in article_dir.rglob("*.md"):
            with open(md_file, 'r') as f:
                content = f.read()
                
                if content.startswith('---'):
                    _, fm, body = content.split('---', 2)
                    metadata = yaml.safe_load(fm)
                    
                    article = {
                        'file_path': str(md_file.relative_to(self.base_path)),
                        'title': metadata.get('title'),
                        'authors': metadata.get('authors', []),
                        'publication_date': metadata.get('publication_date'),
                        'doi': metadata.get('doi'),
                        'pmid': metadata.get('pmid'),
                        'evidence_level': metadata.get('evidence_level'),
                        'clinical_significance': metadata.get('clinical_significance'),
                        'keywords': metadata.get('keywords', []),
                        'content': body.strip()
                    }
                    
                    self.articles.append(article)
        
        return self.articles
    
    def export_to_json(self, output_dir):
        """Export extracted data to JSON for import"""
        output_path = Path(output_dir)
        output_path.mkdir(exist_ok=True)
        
        # Export questions
        with open(output_path / 'questions.json', 'w') as f:
            json.dump(self.questions, f, indent=2)
        
        # Export articles
        with open(output_path / 'articles.json', 'w') as f:
            json.dump(self.articles, f, indent=2)
        
        # Export cross-references
        with open(output_path / 'cross_references.json', 'w') as f:
            json.dump(self.cross_references, f, indent=2)
        
        print(f"Exported {len(self.questions)} questions")
        print(f"Exported {len(self.articles)} articles")
        print(f"Exported {len(self.cross_references)} cross-references")

# Usage
extractor = QuestionBankExtractor('/Users/bhavenmurji/My Drive/Shared Ignite/QtoAAFP')
extractor.extract_questions()
extractor.extract_articles()
extractor.export_to_json('./export')
```

### Phase 2: Database Import

#### 2.1 Database Schema Setup

```sql
-- Create database
CREATE DATABASE fammed_central;

-- Create tables (see ARCHITECTURE.md for complete schema)
CREATE TABLE questions (...);
CREATE TABLE articles (...);
CREATE TABLE question_article_links (...);

-- Create indexes for performance
CREATE INDEX idx_questions_legacy ON questions(legacy_id);
CREATE INDEX idx_articles_title ON articles(title);
CREATE INDEX idx_links_question ON question_article_links(question_id);
```

#### 2.2 Import Script

```javascript
// Node.js import script using Prisma
const { PrismaClient } = require('@prisma/client');
const fs = require('fs').promises;
const path = require('path');

const prisma = new PrismaClient();

async function importQuestions() {
  const data = await fs.readFile('./export/questions.json', 'utf8');
  const questions = JSON.parse(data);
  
  console.log(`Importing ${questions.length} questions...`);
  
  for (const q of questions) {
    try {
      await prisma.question.create({
        data: {
          legacy_id: q.legacy_id,
          type: q.type,
          year: q.year,
          number: q.number,
          text: q.question_text,
          choices: q.choices,
          answer: q.answer,
          explanation: q.explanation,
          topics: q.topics,
          references: q.references
        }
      });
    } catch (error) {
      console.error(`Error importing question ${q.legacy_id}:`, error);
    }
  }
  
  console.log('Questions import complete');
}

async function importArticles() {
  const data = await fs.readFile('./export/articles.json', 'utf8');
  const articles = JSON.parse(data);
  
  console.log(`Importing ${articles.length} articles...`);
  
  for (const a of articles) {
    try {
      await prisma.article.create({
        data: {
          title: a.title,
          authors: a.authors,
          publication_date: a.publication_date ? new Date(a.publication_date) : null,
          content: a.content,
          doi: a.doi,
          pmid: a.pmid,
          evidence_level: a.evidence_level,
          clinical_significance: a.clinical_significance,
          keywords: a.keywords,
          file_path: a.file_path
        }
      });
    } catch (error) {
      console.error(`Error importing article ${a.title}:`, error);
    }
  }
  
  console.log('Articles import complete');
}

async function importCrossReferences() {
  const data = await fs.readFile('./export/cross_references.json', 'utf8');
  const refs = JSON.parse(data);
  
  console.log(`Importing ${refs.length} cross-references...`);
  
  for (const ref of refs) {
    try {
      // Find question by legacy_id
      const question = await prisma.question.findUnique({
        where: { legacy_id: ref.question_id }
      });
      
      // Find article by file_path
      const article = await prisma.article.findFirst({
        where: { file_path: ref.article_path }
      });
      
      if (question && article) {
        await prisma.questionArticleLink.create({
          data: {
            question_id: question.id,
            article_id: article.id,
            relevance_score: ref.relevance_score
          }
        });
      }
    } catch (error) {
      console.error(`Error importing reference:`, error);
    }
  }
  
  console.log('Cross-references import complete');
}

async function runImport() {
  try {
    await importQuestions();
    await importArticles();
    await importCrossReferences();
    
    // Verify import
    const questionCount = await prisma.question.count();
    const articleCount = await prisma.article.count();
    const linkCount = await prisma.questionArticleLink.count();
    
    console.log(`
Import Summary:
- Questions: ${questionCount}
- Articles: ${articleCount}
- Cross-references: ${linkCount}
    `);
  } catch (error) {
    console.error('Import failed:', error);
  } finally {
    await prisma.$disconnect();
  }
}

runImport();
```

### Phase 3: Search Index Setup

#### 3.1 Elasticsearch Configuration

```javascript
// Setup Elasticsearch indexes
const { Client } = require('@elastic/elasticsearch');

const client = new Client({ 
  node: 'http://localhost:9200' 
});

async function createIndexes() {
  // Create question index with medical analyzer
  await client.indices.create({
    index: 'questions',
    body: {
      settings: {
        analysis: {
          analyzer: {
            medical_analyzer: {
              type: 'custom',
              tokenizer: 'standard',
              filter: ['lowercase', 'medical_synonyms', 'stop']
            }
          },
          filter: {
            medical_synonyms: {
              type: 'synonym',
              synonyms: [
                'mi,myocardial infarction,heart attack',
                'dm,diabetes mellitus,diabetes',
                'htn,hypertension,high blood pressure',
                'cad,coronary artery disease',
                'copd,chronic obstructive pulmonary disease'
              ]
            }
          }
        }
      },
      mappings: {
        properties: {
          id: { type: 'keyword' },
          legacy_id: { type: 'keyword' },
          text: { 
            type: 'text',
            analyzer: 'medical_analyzer'
          },
          explanation: { 
            type: 'text',
            analyzer: 'medical_analyzer'
          },
          topics: { type: 'keyword' },
          year: { type: 'integer' },
          type: { type: 'keyword' }
        }
      }
    }
  });
  
  // Create article index
  await client.indices.create({
    index: 'articles',
    body: {
      settings: {
        analysis: {
          analyzer: {
            medical_analyzer: {
              type: 'custom',
              tokenizer: 'standard',
              filter: ['lowercase', 'medical_synonyms', 'stop']
            }
          }
        }
      },
      mappings: {
        properties: {
          id: { type: 'keyword' },
          title: { 
            type: 'text',
            analyzer: 'medical_analyzer'
          },
          content: { 
            type: 'text',
            analyzer: 'medical_analyzer'
          },
          authors: { type: 'keyword' },
          keywords: { type: 'keyword' },
          evidence_level: { type: 'keyword' },
          publication_date: { type: 'date' }
        }
      }
    }
  });
  
  console.log('Elasticsearch indexes created');
}

// Index data from database
async function indexData() {
  const questions = await prisma.question.findMany();
  const articles = await prisma.article.findMany();
  
  // Bulk index questions
  const questionOps = questions.flatMap(q => [
    { index: { _index: 'questions', _id: q.id } },
    {
      id: q.id,
      legacy_id: q.legacy_id,
      text: q.text,
      explanation: q.explanation,
      topics: q.topics,
      year: q.year,
      type: q.type
    }
  ]);
  
  await client.bulk({ body: questionOps });
  
  // Bulk index articles
  const articleOps = articles.flatMap(a => [
    { index: { _index: 'articles', _id: a.id } },
    {
      id: a.id,
      title: a.title,
      content: a.content,
      authors: a.authors,
      keywords: a.keywords,
      evidence_level: a.evidence_level,
      publication_date: a.publication_date
    }
  ]);
  
  await client.bulk({ body: articleOps });
  
  console.log(`Indexed ${questions.length} questions and ${articles.length} articles`);
}
```

## 🔌 API Integration

### Connect to Backend Services

```typescript
// services/questionBankService.ts
import { PrismaClient } from '@prisma/client';
import { Client as ElasticClient } from '@elastic/elasticsearch';
import { Redis } from 'ioredis';

export class QuestionBankService {
  private prisma: PrismaClient;
  private elastic: ElasticClient;
  private redis: Redis;
  
  constructor() {
    this.prisma = new PrismaClient();
    this.elastic = new ElasticClient({ 
      node: process.env.ELASTICSEARCH_URL 
    });
    this.redis = new Redis(process.env.REDIS_URL);
  }
  
  async getRandomQuestion(filters?: QuestionFilters) {
    // Check cache first
    const cacheKey = `random:${JSON.stringify(filters)}`;
    const cached = await this.redis.get(cacheKey);
    if (cached) return JSON.parse(cached);
    
    // Build query
    const where: any = {};
    if (filters?.type) where.type = filters.type;
    if (filters?.year) where.year = filters.year;
    if (filters?.topics) where.topics = { hasSome: filters.topics };
    
    // Get random question
    const count = await this.prisma.question.count({ where });
    const skip = Math.floor(Math.random() * count);
    
    const question = await this.prisma.question.findFirst({
      where,
      skip,
      include: {
        questionArticleLinks: {
          include: {
            article: {
              select: {
                id: true,
                title: true
              }
            }
          }
        }
      }
    });
    
    // Cache for 5 minutes
    await this.redis.setex(cacheKey, 300, JSON.stringify(question));
    
    return question;
  }
  
  async searchQuestions(query: string, options?: SearchOptions) {
    const { body } = await this.elastic.search({
      index: 'questions',
      body: {
        query: {
          multi_match: {
            query,
            fields: ['text^2', 'explanation', 'topics'],
            type: 'best_fields',
            fuzziness: 'AUTO'
          }
        },
        size: options?.limit || 20,
        from: options?.offset || 0
      }
    });
    
    const ids = body.hits.hits.map(hit => hit._id);
    
    // Fetch full data from database
    const questions = await this.prisma.question.findMany({
      where: { id: { in: ids } },
      include: {
        questionArticleLinks: {
          include: {
            article: {
              select: {
                id: true,
                title: true,
                relevance_score: true
              }
            }
          },
          orderBy: {
            relevance_score: 'desc'
          },
          take: 3
        }
      }
    });
    
    return {
      total: body.hits.total.value,
      results: questions
    };
  }
}
```

## 📱 Mobile App Integration

### React Native Implementation

```typescript
// screens/StudyScreen.tsx
import React, { useState, useEffect } from 'react';
import { View, Text, TouchableOpacity, ScrollView } from 'react-native';
import { useDispatch, useSelector } from 'react-redux';
import { api } from '../services/api';

export const StudyScreen: React.FC = () => {
  const [question, setQuestion] = useState(null);
  const [selectedAnswer, setSelectedAnswer] = useState(null);
  const [showExplanation, setShowExplanation] = useState(false);
  
  useEffect(() => {
    loadQuestion();
  }, []);
  
  const loadQuestion = async () => {
    try {
      const data = await api.questions.getRandom({
        type: 'ITE',
        exclude_answered: true
      });
      setQuestion(data);
      setSelectedAnswer(null);
      setShowExplanation(false);
    } catch (error) {
      console.error('Failed to load question:', error);
    }
  };
  
  const submitAnswer = async () => {
    if (!selectedAnswer) return;
    
    try {
      const result = await api.questions.submitAnswer(question.id, {
        answer: selectedAnswer,
        time_spent: 60 // Track time
      });
      
      setShowExplanation(true);
      
      // Update local progress
      dispatch(updateProgress({
        questionsAnswered: 1,
        correct: result.correct ? 1 : 0
      }));
    } catch (error) {
      console.error('Failed to submit answer:', error);
    }
  };
  
  return (
    <ScrollView>
      {question && (
        <>
          <Text style={styles.questionText}>
            {question.text}
          </Text>
          
          {Object.entries(question.choices).map(([key, value]) => (
            <TouchableOpacity
              key={key}
              style={[
                styles.choice,
                selectedAnswer === key && styles.selectedChoice,
                showExplanation && key === question.answer && styles.correctChoice,
                showExplanation && selectedAnswer === key && key !== question.answer && styles.incorrectChoice
              ]}
              onPress={() => !showExplanation && setSelectedAnswer(key)}
            >
              <Text>{key}) {value}</Text>
            </TouchableOpacity>
          ))}
          
          {!showExplanation ? (
            <TouchableOpacity 
              style={styles.submitButton}
              onPress={submitAnswer}
            >
              <Text>Submit Answer</Text>
            </TouchableOpacity>
          ) : (
            <>
              <View style={styles.explanation}>
                <Text style={styles.explanationTitle}>Explanation</Text>
                <Text>{question.explanation}</Text>
              </View>
              
              {question.related_articles && (
                <View style={styles.relatedArticles}>
                  <Text style={styles.sectionTitle}>Related Articles</Text>
                  {question.related_articles.map(article => (
                    <TouchableOpacity key={article.id}>
                      <Text>{article.title}</Text>
                    </TouchableOpacity>
                  ))}
                </View>
              )}
              
              <TouchableOpacity 
                style={styles.nextButton}
                onPress={loadQuestion}
              >
                <Text>Next Question</Text>
              </TouchableOpacity>
            </>
          )}
        </>
      )}
    </ScrollView>
  );
};
```

## 🔄 Sync Strategy

### Offline-First Architecture

```typescript
// services/syncService.ts
export class SyncService {
  async syncOfflineData() {
    const pendingData = await this.getOfflineQueue();
    
    if (pendingData.length === 0) return;
    
    try {
      // Upload offline data
      const response = await api.sync.upload({
        device_id: getDeviceId(),
        last_sync: getLastSyncTime(),
        data: pendingData
      });
      
      // Clear uploaded data from queue
      await this.clearSyncedData(response.processed);
      
      // Update last sync time
      await this.updateLastSyncTime(response.server_time);
      
    } catch (error) {
      console.error('Sync failed:', error);
      // Retry later
    }
  }
  
  async downloadUpdates() {
    const lastSync = getLastSyncTime();
    
    try {
      const updates = await api.sync.download({
        last_sync: lastSync,
        types: ['questions', 'articles']
      });
      
      // Apply updates to local database
      await this.applyUpdates(updates);
      
      // Update sync token
      await this.updateSyncToken(updates.sync_token);
      
    } catch (error) {
      console.error('Download failed:', error);
    }
  }
}
```

## 📊 Analytics Integration

### Track Study Progress

```typescript
// services/analyticsService.ts
export class AnalyticsService {
  trackQuestionAnswered(question: Question, answer: string, correct: boolean) {
    // Send to analytics platform
    analytics.track('Question Answered', {
      question_id: question.id,
      question_type: question.type,
      topics: question.topics,
      answer_given: answer,
      correct: correct,
      time_spent: getTimeSpent()
    });
    
    // Update local progress
    this.updateLocalProgress({
      total_answered: +1,
      correct_answers: correct ? +1 : 0,
      topic_progress: {
        [question.topics[0]]: {
          attempted: +1,
          correct: correct ? +1 : 0
        }
      }
    });
  }
  
  getStudyRecommendations() {
    const progress = this.getLocalProgress();
    
    // Identify weak areas
    const weakTopics = Object.entries(progress.topic_progress)
      .filter(([topic, stats]) => stats.accuracy < 0.6)
      .map(([topic]) => topic);
    
    // Generate recommendations
    return {
      focus_topics: weakTopics,
      daily_goal: this.calculateDailyGoal(progress),
      suggested_questions: this.getSuggestedQuestions(weakTopics)
    };
  }
}
```

## ✅ Integration Checklist

### Pre-Integration
- [ ] Backup existing markdown files
- [ ] Set up development database
- [ ] Configure Elasticsearch
- [ ] Set up Redis cache
- [ ] Prepare API endpoints

### Data Migration
- [ ] Extract questions from markdown
- [ ] Extract articles from markdown
- [ ] Parse cross-references
- [ ] Import to database
- [ ] Create search indexes
- [ ] Verify data integrity

### API Development
- [ ] Implement question endpoints
- [ ] Implement article endpoints
- [ ] Implement search functionality
- [ ] Add progress tracking
- [ ] Set up caching layer

### Mobile Integration
- [ ] Create study screens
- [ ] Implement offline storage
- [ ] Add sync functionality
- [ ] Integrate analytics
- [ ] Test on iOS/Android

### Testing & Validation
- [ ] Unit tests for services
- [ ] Integration tests for API
- [ ] E2E tests for app flows
- [ ] Performance testing
- [ ] Security audit

### Deployment
- [ ] Deploy database
- [ ] Deploy API services
- [ ] Deploy search infrastructure
- [ ] Release mobile apps
- [ ] Monitor performance

## 🚨 Common Issues & Solutions

### Issue: Slow search performance
**Solution**: Optimize Elasticsearch mappings, add more replicas, implement caching

### Issue: Sync conflicts
**Solution**: Implement conflict resolution strategy, use server timestamp as source of truth

### Issue: Large content loading slowly
**Solution**: Implement pagination, lazy loading, and content compression

### Issue: Offline mode data loss
**Solution**: Implement robust queue system with SQLite, periodic auto-sync

---

*Integration Guide Version: 1.0*
*Last Updated: August 2025*