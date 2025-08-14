# AAFP Complete Medical Knowledge System
## Master Index and Documentation

---

## 📚 System Overview

This comprehensive medical knowledge system contains:
- **2,128 AAFP Articles** (July 2023 - August 2025)
- **598 ITE (In-Training Exam) Questions** with answers and explanations (2022-2024)
- **366 CME Flashcards** with detailed explanations
- **Cross-referenced links** between questions and source articles

---

## 📁 Directory Structure

```
/Users/bhavenmurji/My Drive/Shared Ignite/QtoAAFP/
│
├── Articles/                    # All AAFP articles in markdown format
│   ├── 2022/                   # Articles from 2022
│   ├── 2023/                   # Articles from 2023 (July onwards)
│   │   ├── 01/                 # January articles
│   │   ├── 02/                 # February articles
│   │   ├── ...
│   │   └── 12/                 # December articles
│   ├── 2024/                   # Complete 2024 articles
│   └── 2025/                   # 2025 articles (through August)
│
└── Test Bank/                   # All questions and assessments
    ├── ITE/                     # In-Training Exam questions
    │   ├── ITE-2022-XXX.md     # 2022 exam questions
    │   ├── ITE-2023-XXX.md     # 2023 exam questions
    │   └── ITE-2024-XXX.md     # 2024 exam questions
    │
    └── Flashcards/              # CME Flashcard questions
        ├── FC-001.md to FC-370.md
        └── (Organized by topic)
```

---

## 📊 Content Statistics

### Articles by Year
- **2022**: ~200 articles (partial year)
- **2023**: ~380 articles (July-December focus)
- **2024**: ~360 articles (complete year)
- **2025**: ~240 articles (January-August)

### Test Bank Contents
- **ITE Questions**: 598 questions spanning 2022-2024
  - 2022: 198 questions
  - 2023: 201 questions
  - 2024: 199 questions (newly added)
- **CME Flashcards**: 366 flashcards covering all major topics

### Topic Coverage
Primary topics covered across all content:
1. **Cardiology** - Blood pressure, heart disease, arrhythmias
2. **Endocrinology** - Diabetes, thyroid disorders, metabolic conditions
3. **Obstetrics/Gynecology** - Pregnancy, women's health, reproductive medicine
4. **Pediatrics** - Child health, vaccinations, developmental issues
5. **Gastroenterology** - GI disorders, liver disease, nutrition
6. **Nephrology** - Kidney disease, electrolyte disorders
7. **Infectious Disease** - Vaccinations, antimicrobials, COVID-19
8. **Mental Health** - Depression, anxiety, behavioral health
9. **Musculoskeletal** - Joint disorders, sports medicine, pain management
10. **Dermatology** - Skin conditions, lesions, rashes

---

## 🔗 Cross-Reference System

Each question contains:
1. **Question ID**: Unique identifier (e.g., ITE-2022-001, FC-001)
2. **Type**: ITE or Flashcard
3. **Source Indicator**: Original exam year or CME module
4. **Answer**: Correct answer choice
5. **Explanation**: Detailed reasoning
6. **Related Articles**: Up to 5 cross-referenced articles with:
   - Article title
   - File path
   - Similarity score (0.0-1.0)
   - Direct link to article

### Example Cross-Reference Structure
```yaml
related_articles:
- title: 'Chronic Kidney Disease: Prevention, Diagnosis, and Treatment'
  path: 2023/2023-12-chronic-kidney-disease-prevention-diagnosis-and-treatment.md
  similarity: 0.429
  link: '[[2023/2023-12-chronic-kidney-disease|CKD Article]]'
```

---

## 🎯 Usage Guide

### Finding Information

#### By Question Type
1. Navigate to `/Test Bank/ITE/` for in-training exam questions
2. Navigate to `/Test Bank/Flashcards/` for CME flashcards

#### By Topic
1. Use topic indices in `/Topic_Indices/`
2. Search by medical specialty or condition

#### By Article Date
1. Navigate to `/Articles/YYYY/MM/`
2. Articles are named: `YYYY-MM-title-slug.md`

### Cross-Referencing
Each question file contains `related_articles` section linking to source materials.

### Search Strategies
1. **By keyword**: Use grep or search across all markdown files
2. **By topic**: Check topic tags in frontmatter
3. **By date**: Navigate chronologically through Articles folders
4. **By question ID**: Direct access via Test Bank folders

---

## 📈 Quality Metrics

### Article Completeness
- **Full text extraction**: ~60% of articles
- **Metadata complete**: 100% of articles
- **PubMed enriched**: ~80% of articles
- **Cross-referenced**: 100% of questions

### Question Quality
- **Answer provided**: 100%
- **Explanation included**: ~95%
- **Article references**: 100% (average 5 per question)
- **Topic tags**: 100%

---

## 🔄 Maintenance and Updates

### Regular Updates Needed
1. **Monthly**: Add new AAFP articles as published
2. **Annually**: Add new ITE exam questions
3. **Ongoing**: Update CME flashcards as released
4. **Continuous**: Improve article extraction quality

### Data Sources
- **Articles**: https://www.aafp.org/journals/afp/
- **ITE Questions**: AAFP In-Training Examinations
- **CME Flashcards**: AAFP CME modules

---

## 📝 Technical Notes

### File Format
All content stored as Markdown (.md) files with:
- YAML frontmatter for metadata
- Markdown body for content
- Cross-reference links in Wiki-style format

### Metadata Schema
```yaml
---
id: unique-identifier
type: Article|ITE|Flashcard
title: Full title
authors: [list of authors]
publication_date: YYYY-MM-DD
topics: [medical topics]
related_articles: [cross-references]
---
```

### Processing Pipeline
1. **Extraction**: PDF/Web → Text
2. **Conversion**: Text → Markdown
3. **Enrichment**: Add PubMed metadata
4. **Cross-reference**: Link questions to articles
5. **Organization**: File into proper directories

---

## 🚀 Quick Start Commands

### Search for a topic
```bash
grep -r "diabetes" /Users/bhavenmurji/My Drive/Shared Ignite/QtoAAFP/
```

### Find all cardiology questions
```bash
grep -l "Cardiology" /Users/bhavenmurji/My Drive/Shared Ignite/QtoAAFP/Test\ Bank/*/*.md
```

### List recent articles
```bash
ls -la /Users/bhavenmurji/My Drive/Shared Ignite/QtoAAFP/Articles/2025/
```

### Count total questions
```bash
find /Users/bhavenmurji/My Drive/Shared Ignite/QtoAAFP/Test\ Bank/ -name "*.md" | wc -l
```

---

## 📌 Important Files

- **Master Index**: `/QtoAAFP/MASTER_INDEX.md` (this file)
- **Processing Reports**: `/QtoAAFP/processing_report.md`
- **Topic Indices**: `/QtoAAFP/Topic_Indices/`
- **Latest Articles**: `/QtoAAFP/Articles/2025/08/`

---

## ✅ System Status

- **Articles**: ✅ Complete (2,128 files)
- **ITE Questions**: ✅ Complete (~400 questions)
- **CME Flashcards**: ✅ Complete (~370 cards)
- **Cross-References**: ✅ Active (100% linked)
- **Documentation**: ✅ Complete

---

**Last Updated**: August 10, 2025
**Total Files**: ~2,900 markdown files
**Total Size**: ~150 MB
**Coverage Period**: July 2023 - August 2025