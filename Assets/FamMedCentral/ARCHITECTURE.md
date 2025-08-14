# FamMED Central - Technical Architecture

## System Architecture Overview

FamMED Central is designed as a modular, scalable study platform integrated within the Rapid Response Central ecosystem.

## 🏗️ High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    Rapid Response Central App                   │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐        │
│  │  Emergency   │  │   FamMED     │  │  Calculator  │        │
│  │   Protocols  │  │   Central    │  │    Module    │        │
│  └──────────────┘  └──────────────┘  └──────────────┘        │
│         ↓                 ↓                   ↓                │
├─────────────────────────────────────────────────────────────────┤
│                     Core Services Layer                         │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐        │
│  │   Auth &     │  │   Content    │  │   Analytics  │        │
│  │   User Mgmt  │  │   Delivery   │  │    Engine    │        │
│  └──────────────┘  └──────────────┘  └──────────────┘        │
├─────────────────────────────────────────────────────────────────┤
│                      Data Layer                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐        │
│  │   Question   │  │   Article    │  │    User      │        │
│  │   Database   │  │   Database   │  │   Progress   │        │
│  └──────────────┘  └──────────────┘  └──────────────┘        │
└─────────────────────────────────────────────────────────────────┘
```

## 🔧 Component Details

### 1. Frontend Architecture

#### Technology Stack
- **Framework**: React Native (iOS/Android)
- **State Management**: Redux Toolkit with RTK Query
- **UI Components**: React Native Elements + Custom Components
- **Navigation**: React Navigation v6
- **Offline Storage**: AsyncStorage + SQLite

#### Key Frontend Modules

```javascript
// Module Structure
FamMedCentral/
├── components/
│   ├── Questions/
│   │   ├── QuestionCard.tsx
│   │   ├── AnswerChoice.tsx
│   │   └── ExplanationView.tsx
│   ├── Articles/
│   │   ├── ArticleReader.tsx
│   │   ├── ArticleSearch.tsx
│   │   └── ArticleBookmark.tsx
│   ├── Study/
│   │   ├── StudySession.tsx
│   │   ├── ProgressTracker.tsx
│   │   └── StudyStats.tsx
│   └── Common/
│       ├── SearchBar.tsx
│       ├── FilterPanel.tsx
│       └── LoadingStates.tsx
├── screens/
│   ├── DashboardScreen.tsx
│   ├── QuestionScreen.tsx
│   ├── ArticleScreen.tsx
│   └── ProgressScreen.tsx
├── services/
│   ├── questionService.ts
│   ├── articleService.ts
│   └── analyticsService.ts
└── store/
    ├── questionSlice.ts
    ├── progressSlice.ts
    └── userSlice.ts
```

### 2. Backend Architecture

#### Technology Stack
- **Runtime**: Node.js v18+
- **Framework**: Express.js with TypeScript
- **Database**: PostgreSQL 14+ with Redis cache
- **ORM**: Prisma
- **Search**: Elasticsearch
- **Queue**: Bull for background jobs

#### API Service Architecture

```typescript
// Core Service Interfaces
interface QuestionService {
  getQuestion(id: string): Promise<Question>
  getRandomQuestion(filters?: QuestionFilters): Promise<Question>
  searchQuestions(query: string): Promise<Question[]>
  submitAnswer(questionId: string, answer: string): Promise<AnswerResult>
}

interface ArticleService {
  getArticle(id: string): Promise<Article>
  searchArticles(query: string): Promise<Article[]>
  getRelatedArticles(questionId: string): Promise<Article[]>
  bookmarkArticle(articleId: string, userId: string): Promise<void>
}

interface ProgressService {
  getProgress(userId: string): Promise<UserProgress>
  updateProgress(userId: string, update: ProgressUpdate): Promise<void>
  getAnalytics(userId: string): Promise<Analytics>
  getLeaderboard(cohortId: string): Promise<Leaderboard>
}
```

### 3. Data Layer Architecture

#### Database Schema (PostgreSQL)

```sql
-- Core Tables
CREATE TABLE questions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    legacy_id VARCHAR(50) UNIQUE, -- ITE-2024-001
    type VARCHAR(20) NOT NULL, -- ITE, Flashcard
    year INTEGER,
    number INTEGER,
    text TEXT NOT NULL,
    choices JSONB NOT NULL,
    answer CHAR(1) NOT NULL,
    explanation TEXT,
    topics TEXT[],
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE articles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    authors TEXT[],
    publication_date DATE,
    content TEXT,
    evidence_level VARCHAR(10),
    clinical_significance VARCHAR(20),
    specialty VARCHAR(50),
    keywords TEXT[],
    doi VARCHAR(100),
    pmid VARCHAR(50),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE question_article_links (
    question_id UUID REFERENCES questions(id),
    article_id UUID REFERENCES articles(id),
    relevance_score DECIMAL(3,2),
    PRIMARY KEY (question_id, article_id)
);

CREATE TABLE user_progress (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    question_id UUID REFERENCES questions(id),
    answer_given CHAR(1),
    is_correct BOOLEAN,
    time_spent INTEGER, -- seconds
    answered_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE study_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    started_at TIMESTAMP DEFAULT NOW(),
    ended_at TIMESTAMP,
    questions_attempted INTEGER DEFAULT 0,
    correct_answers INTEGER DEFAULT 0,
    topics_covered TEXT[]
);

-- Indexes for performance
CREATE INDEX idx_questions_type ON questions(type);
CREATE INDEX idx_questions_year ON questions(year);
CREATE INDEX idx_articles_specialty ON articles(specialty);
CREATE INDEX idx_articles_publication ON articles(publication_date);
CREATE INDEX idx_progress_user ON user_progress(user_id);
CREATE INDEX idx_progress_question ON user_progress(question_id);
```

#### Redis Cache Structure

```javascript
// Cache Keys
cache:question:{id}           // Individual question
cache:article:{id}            // Individual article
cache:user:progress:{userId}  // User progress summary
cache:search:questions:{hash} // Search results cache
cache:search:articles:{hash}  // Search results cache
cache:leaderboard:{cohortId}  // Leaderboard cache

// Cache TTL
questions: 1 hour
articles: 1 hour
user_progress: 5 minutes
search_results: 15 minutes
leaderboard: 10 minutes
```

### 4. Search Architecture (Elasticsearch)

```json
// Question Index Mapping
{
  "mappings": {
    "properties": {
      "id": { "type": "keyword" },
      "text": { 
        "type": "text",
        "analyzer": "medical_analyzer"
      },
      "explanation": { 
        "type": "text",
        "analyzer": "medical_analyzer"
      },
      "topics": { "type": "keyword" },
      "year": { "type": "integer" },
      "type": { "type": "keyword" }
    }
  }
}

// Article Index Mapping
{
  "mappings": {
    "properties": {
      "id": { "type": "keyword" },
      "title": { 
        "type": "text",
        "analyzer": "medical_analyzer"
      },
      "content": { 
        "type": "text",
        "analyzer": "medical_analyzer"
      },
      "authors": { "type": "keyword" },
      "specialty": { "type": "keyword" },
      "keywords": { "type": "keyword" },
      "publication_date": { "type": "date" }
    }
  }
}
```

### 5. Integration Points

#### With Rapid Response Central

```typescript
// Shared Services
interface SharedAuthService {
  validateToken(token: string): Promise<User>
  refreshToken(refreshToken: string): Promise<TokenPair>
}

interface SharedAnalyticsService {
  trackEvent(event: AnalyticsEvent): void
  trackPageView(page: string): void
}

// Cross-Module Linking
interface CrossModuleLinks {
  linkProtocolToArticles(protocolId: string): Article[]
  linkCalculatorToQuestions(calculatorId: string): Question[]
  suggestStudyFromEmergency(emergencyType: string): StudyPlan
}
```

#### External Services

```yaml
PubMed API:
  purpose: Article metadata enrichment
  frequency: On-demand during import
  rate_limit: 3 requests/second

AAFP Content API:
  purpose: Article updates
  frequency: Daily sync
  authentication: OAuth 2.0

Analytics Platform:
  service: Google Analytics / Mixpanel
  events: User interactions, progress tracking
  
Crash Reporting:
  service: Sentry
  integration: Auto-capture errors
```

## 🚀 Deployment Architecture

### Container Architecture

```dockerfile
# Backend Service
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --production
COPY . .
EXPOSE 3000
CMD ["node", "dist/server.js"]
```

### Kubernetes Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: fammed-central-api
spec:
  replicas: 3
  selector:
    matchLabels:
      app: fammed-central-api
  template:
    metadata:
      labels:
        app: fammed-central-api
    spec:
      containers:
      - name: api
        image: fammed-central-api:latest
        ports:
        - containerPort: 3000
        env:
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: db-secret
              key: url
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
```

## 📊 Performance Requirements

### Response Times
- API Endpoints: < 200ms (p95)
- Search Queries: < 500ms (p95)
- Page Load: < 1 second
- Offline Sync: < 30 seconds

### Scalability
- Concurrent Users: 10,000+
- Questions Database: 10,000+ items
- Articles Database: 50,000+ items
- Daily Active Users: 5,000+

### Reliability
- Uptime: 99.9% (excluding maintenance)
- Data Durability: 99.999%
- Backup Frequency: Daily
- Recovery Time: < 1 hour

## 🔒 Security Architecture

### Authentication & Authorization
- JWT-based authentication
- Role-based access control (Student, Resident, Faculty)
- OAuth 2.0 for third-party integrations
- Biometric authentication support

### Data Security
- Encryption at rest (AES-256)
- Encryption in transit (TLS 1.3)
- PII data anonymization
- HIPAA compliance ready

### API Security
- Rate limiting per user/IP
- API key management
- Request signing for sensitive operations
- Input validation and sanitization

## 📈 Monitoring & Observability

### Metrics Collection
- Application metrics (Prometheus)
- Business metrics (Custom dashboard)
- Infrastructure metrics (CloudWatch/Datadog)

### Logging
- Centralized logging (ELK Stack)
- Structured logs (JSON format)
- Log retention: 30 days

### Alerting
- Performance degradation alerts
- Error rate threshold alerts
- Security incident alerts
- Business metric alerts

## 🔄 CI/CD Pipeline

```yaml
# GitHub Actions Workflow
name: Deploy FamMED Central
on:
  push:
    branches: [main]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - run: npm test
      - run: npm run lint
  
  build:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - run: docker build -t fammed-central .
      - run: docker push registry/fammed-central
  
  deploy:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - run: kubectl apply -f k8s/
      - run: kubectl rollout status deployment/fammed-central
```

## 🎯 Architecture Principles

1. **Modularity**: Loosely coupled services
2. **Scalability**: Horizontal scaling capability
3. **Resilience**: Graceful degradation
4. **Performance**: Optimized for mobile
5. **Security**: Defense in depth
6. **Maintainability**: Clean code architecture
7. **Observability**: Comprehensive monitoring

---

*Architecture Version: 1.0*
*Last Updated: August 2025*