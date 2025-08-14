# FamMED Central API Documentation

## API Overview

RESTful API for FamMED Central study module integration with Rapid Response Central.

Base URL: `https://api.rapidresponsecentral.com/v1/fammed`

## 🔐 Authentication

All API requests require authentication using JWT tokens.

### Authentication Flow

```http
POST /auth/login
Content-Type: application/json

{
  "email": "resident@hospital.com",
  "password": "secure_password"
}

Response:
{
  "access_token": "eyJhbGciOiJIUzI1NiIs...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIs...",
  "expires_in": 3600,
  "user": {
    "id": "uuid",
    "email": "resident@hospital.com",
    "role": "resident",
    "program": "family_medicine"
  }
}
```

### Using Tokens

Include the access token in all subsequent requests:
```http
Authorization: Bearer eyJhbGciOiJIUzI1NiIs...
```

## 📚 Questions API

### Get Random Question

```http
GET /questions/random?type=ITE&year=2024&topic=cardiology

Response:
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "legacy_id": "ITE-2024-042",
  "type": "ITE",
  "year": 2024,
  "text": "A 65-year-old male presents with chest pain...",
  "choices": {
    "A": "Myocardial infarction",
    "B": "Pulmonary embolism",
    "C": "Aortic dissection",
    "D": "Pneumothorax",
    "E": "Costochondritis"
  },
  "topics": ["cardiology", "emergency_medicine"],
  "difficulty": "medium",
  "time_limit": 90
}
```

### Get Question by ID

```http
GET /questions/{id}

Response:
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "legacy_id": "ITE-2024-042",
  "type": "ITE",
  "year": 2024,
  "text": "A 65-year-old male presents with chest pain...",
  "choices": {
    "A": "Myocardial infarction",
    "B": "Pulmonary embolism",
    "C": "Aortic dissection",
    "D": "Pneumothorax",
    "E": "Costochondritis"
  },
  "answer": "A",
  "explanation": "The patient's presentation is classic for acute MI...",
  "references": [
    "AAFP Guidelines on Acute Coronary Syndrome",
    "2024 ACC/AHA Guidelines"
  ],
  "related_articles": [
    {
      "id": "article-uuid-1",
      "title": "Managing Acute Coronary Syndrome",
      "relevance_score": 0.95
    }
  ]
}
```

### Submit Answer

```http
POST /questions/{id}/answer
Content-Type: application/json

{
  "answer": "A",
  "time_spent": 45
}

Response:
{
  "correct": true,
  "correct_answer": "A",
  "explanation": "The patient's presentation is classic for acute MI...",
  "points_earned": 10,
  "streak_maintained": true,
  "related_articles": [
    {
      "id": "article-uuid-1",
      "title": "Managing Acute Coronary Syndrome",
      "relevance_score": 0.95
    }
  ]
}
```

### Search Questions

```http
GET /questions/search?q=diabetes&type=ITE&year=2024&limit=20&offset=0

Response:
{
  "total": 45,
  "results": [
    {
      "id": "uuid-1",
      "legacy_id": "ITE-2024-015",
      "text": "A patient with type 2 diabetes...",
      "type": "ITE",
      "year": 2024,
      "topics": ["endocrinology", "diabetes"],
      "match_score": 0.92
    }
  ],
  "facets": {
    "types": {
      "ITE": 38,
      "Flashcard": 7
    },
    "years": {
      "2024": 15,
      "2023": 20,
      "2022": 10
    },
    "topics": {
      "endocrinology": 45,
      "diabetes": 45,
      "pharmacology": 12
    }
  }
}
```

### Get Question Set

```http
POST /questions/set
Content-Type: application/json

{
  "count": 10,
  "filters": {
    "types": ["ITE"],
    "years": [2023, 2024],
    "topics": ["cardiology", "endocrinology"],
    "difficulty": ["medium", "hard"],
    "exclude_answered": true
  }
}

Response:
{
  "set_id": "set-uuid-123",
  "questions": [
    {
      "id": "uuid-1",
      "order": 1,
      "text": "Question text...",
      "choices": {...}
    }
  ],
  "total_time": 900,
  "created_at": "2025-08-10T10:00:00Z"
}
```

## 📖 Articles API

### Get Article

```http
GET /articles/{id}

Response:
{
  "id": "article-uuid-1",
  "title": "Management of Type 2 Diabetes in Primary Care",
  "authors": ["Smith J", "Jones M"],
  "publication_date": "2024-07-15",
  "abstract": "This article reviews current guidelines...",
  "content": "Full article content in markdown...",
  "evidence_level": "A",
  "clinical_significance": "High",
  "specialty": "Endocrinology",
  "keywords": ["diabetes", "primary care", "management"],
  "doi": "10.1234/aafp.2024.0123",
  "pmid": "37654321",
  "cme_credits": 1.5,
  "reading_time": 12,
  "related_questions": [
    {
      "id": "question-uuid-1",
      "legacy_id": "ITE-2024-015",
      "relevance": 0.89
    }
  ]
}
```

### Search Articles

```http
GET /articles/search?q=hypertension+elderly&specialty=cardiology&evidence_level=A&limit=10

Response:
{
  "total": 234,
  "results": [
    {
      "id": "article-uuid-1",
      "title": "Hypertension Management in Elderly Patients",
      "authors": ["Author A", "Author B"],
      "publication_date": "2024-06-01",
      "abstract": "Management strategies for...",
      "match_score": 0.94,
      "evidence_level": "A",
      "specialty": "Cardiology"
    }
  ],
  "facets": {
    "specialties": {
      "cardiology": 145,
      "geriatrics": 89
    },
    "evidence_levels": {
      "A": 45,
      "B": 123,
      "C": 66
    },
    "years": {
      "2024": 78,
      "2023": 156
    }
  }
}
```

### Get Related Articles

```http
GET /articles/related/{question_id}

Response:
{
  "question_id": "question-uuid-1",
  "articles": [
    {
      "id": "article-uuid-1",
      "title": "Recent Advances in Diabetes Care",
      "relevance_score": 0.92,
      "publication_date": "2024-05-15",
      "evidence_level": "A"
    },
    {
      "id": "article-uuid-2",
      "title": "Insulin Therapy Guidelines",
      "relevance_score": 0.87,
      "publication_date": "2024-03-20",
      "evidence_level": "B"
    }
  ]
}
```

### Bookmark Article

```http
POST /articles/{id}/bookmark
Content-Type: application/json

{
  "notes": "Important for upcoming exam"
}

Response:
{
  "bookmarked": true,
  "bookmark_id": "bookmark-uuid-1",
  "created_at": "2025-08-10T10:00:00Z"
}
```

## 📊 Progress API

### Get User Progress

```http
GET /progress/me

Response:
{
  "user_id": "user-uuid-1",
  "statistics": {
    "total_questions_answered": 456,
    "correct_answers": 342,
    "accuracy_rate": 0.75,
    "current_streak": 7,
    "longest_streak": 14,
    "study_time_total": 8640, // minutes
    "last_activity": "2025-08-10T09:30:00Z"
  },
  "topic_performance": {
    "cardiology": {
      "attempted": 45,
      "correct": 38,
      "accuracy": 0.84
    },
    "endocrinology": {
      "attempted": 52,
      "correct": 35,
      "accuracy": 0.67
    }
  },
  "question_types": {
    "ITE": {
      "attempted": 234,
      "correct": 178,
      "accuracy": 0.76
    },
    "Flashcard": {
      "attempted": 222,
      "correct": 164,
      "accuracy": 0.74
    }
  },
  "predicted_score": {
    "ITE_2025": 78,
    "confidence": 0.85
  }
}
```

### Get Study Sessions

```http
GET /progress/sessions?limit=10&offset=0

Response:
{
  "total": 45,
  "sessions": [
    {
      "id": "session-uuid-1",
      "started_at": "2025-08-10T08:00:00Z",
      "ended_at": "2025-08-10T08:45:00Z",
      "duration": 45,
      "questions_attempted": 20,
      "correct_answers": 16,
      "accuracy": 0.80,
      "topics_covered": ["cardiology", "endocrinology"],
      "performance_trend": "improving"
    }
  ]
}
```

### Get Learning Analytics

```http
GET /progress/analytics

Response:
{
  "strengths": [
    {
      "topic": "cardiology",
      "accuracy": 0.85,
      "confidence": "high"
    }
  ],
  "weaknesses": [
    {
      "topic": "nephrology",
      "accuracy": 0.45,
      "suggested_articles": [
        {
          "id": "article-uuid-1",
          "title": "Chronic Kidney Disease Management"
        }
      ]
    }
  ],
  "recommendations": {
    "daily_questions": 15,
    "focus_topics": ["nephrology", "dermatology"],
    "study_time": 45,
    "next_milestone": {
      "target": "80% accuracy",
      "questions_needed": 50,
      "estimated_days": 7
    }
  },
  "peer_comparison": {
    "rank": 12,
    "total_peers": 45,
    "percentile": 73,
    "average_accuracy": 0.72,
    "your_accuracy": 0.75
  }
}
```

### Record Study Session

```http
POST /progress/sessions
Content-Type: application/json

{
  "started_at": "2025-08-10T10:00:00Z",
  "ended_at": "2025-08-10T10:30:00Z",
  "question_results": [
    {
      "question_id": "uuid-1",
      "answer_given": "A",
      "correct": true,
      "time_spent": 45
    }
  ]
}

Response:
{
  "session_id": "session-uuid-2",
  "summary": {
    "duration": 30,
    "questions_attempted": 15,
    "correct_answers": 12,
    "accuracy": 0.80,
    "points_earned": 120,
    "achievements_unlocked": ["First Perfect Score"]
  }
}
```

## 🔍 Search API

### Universal Search

```http
GET /search?q=diabetes+management&types=question,article&limit=20

Response:
{
  "results": {
    "questions": [
      {
        "id": "uuid-1",
        "type": "question",
        "legacy_id": "ITE-2024-015",
        "text": "Diabetes management question...",
        "match_score": 0.92
      }
    ],
    "articles": [
      {
        "id": "uuid-2",
        "type": "article",
        "title": "Diabetes Management Guidelines",
        "match_score": 0.89
      }
    ]
  },
  "total_results": 156,
  "search_time_ms": 145
}
```

## 🎮 Gamification API

### Get Achievements

```http
GET /gamification/achievements

Response:
{
  "unlocked": [
    {
      "id": "streak-7",
      "name": "Week Warrior",
      "description": "7-day study streak",
      "unlocked_at": "2025-08-09T10:00:00Z",
      "points": 100
    }
  ],
  "in_progress": [
    {
      "id": "accuracy-80",
      "name": "Precision Master",
      "description": "Maintain 80% accuracy",
      "progress": 0.75,
      "target": 0.80
    }
  ],
  "locked": [
    {
      "id": "questions-1000",
      "name": "Question Champion",
      "description": "Answer 1000 questions",
      "progress": 0.456,
      "target": 1.0
    }
  ]
}
```

### Get Leaderboard

```http
GET /gamification/leaderboard?cohort=residency_2025&timeframe=week

Response:
{
  "timeframe": "week",
  "cohort": "residency_2025",
  "your_rank": 5,
  "total_participants": 45,
  "leaderboard": [
    {
      "rank": 1,
      "user_id": "user-uuid-1",
      "display_name": "John D.",
      "points": 450,
      "accuracy": 0.88,
      "questions_answered": 125
    }
  ]
}
```

## 🔄 Sync API

### Sync Offline Data

```http
POST /sync/upload
Content-Type: application/json

{
  "device_id": "device-uuid",
  "last_sync": "2025-08-09T10:00:00Z",
  "data": {
    "answered_questions": [...],
    "bookmarked_articles": [...],
    "study_sessions": [...]
  }
}

Response:
{
  "sync_id": "sync-uuid-1",
  "processed": {
    "questions": 45,
    "articles": 12,
    "sessions": 3
  },
  "conflicts": [],
  "server_time": "2025-08-10T10:30:00Z"
}
```

### Download Updates

```http
GET /sync/download?last_sync=2025-08-09T10:00:00Z&types=questions,articles

Response:
{
  "updates": {
    "questions": [
      {
        "id": "uuid-1",
        "action": "create",
        "data": {...}
      }
    ],
    "articles": [
      {
        "id": "uuid-2",
        "action": "update",
        "data": {...}
      }
    ]
  },
  "deleted": {
    "questions": [],
    "articles": ["uuid-3"]
  },
  "sync_token": "token-xyz",
  "server_time": "2025-08-10T10:30:00Z"
}
```

## 🛠️ Admin API

### Content Management

```http
POST /admin/questions
Content-Type: application/json
Authorization: Bearer {admin_token}

{
  "legacy_id": "ITE-2025-001",
  "type": "ITE",
  "year": 2025,
  "text": "New question text...",
  "choices": {...},
  "answer": "C",
  "explanation": "Detailed explanation...",
  "topics": ["cardiology"]
}

Response:
{
  "id": "uuid-new",
  "legacy_id": "ITE-2025-001",
  "created_at": "2025-08-10T10:30:00Z",
  "created_by": "admin-uuid"
}
```

### Usage Analytics

```http
GET /admin/analytics/usage?start_date=2025-08-01&end_date=2025-08-10

Response:
{
  "period": {
    "start": "2025-08-01",
    "end": "2025-08-10"
  },
  "metrics": {
    "daily_active_users": 456,
    "total_questions_answered": 12345,
    "average_session_duration": 32,
    "most_accessed_content": [
      {
        "type": "question",
        "id": "uuid-1",
        "access_count": 234
      }
    ]
  }
}
```

## 📝 Error Handling

### Error Response Format

```json
{
  "error": {
    "code": "RESOURCE_NOT_FOUND",
    "message": "Question not found",
    "details": {
      "resource_type": "question",
      "resource_id": "invalid-uuid"
    },
    "timestamp": "2025-08-10T10:30:00Z",
    "request_id": "req-uuid-123"
  }
}
```

### Common Error Codes

| Code | HTTP Status | Description |
|------|-------------|-------------|
| `UNAUTHORIZED` | 401 | Invalid or expired token |
| `FORBIDDEN` | 403 | Insufficient permissions |
| `RESOURCE_NOT_FOUND` | 404 | Resource does not exist |
| `VALIDATION_ERROR` | 400 | Invalid request parameters |
| `RATE_LIMIT_EXCEEDED` | 429 | Too many requests |
| `SERVER_ERROR` | 500 | Internal server error |

## 🔒 Rate Limiting

- **Standard tier**: 100 requests/minute
- **Premium tier**: 500 requests/minute
- **Bulk operations**: 10 requests/minute

Rate limit headers:
```http
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 45
X-RateLimit-Reset: 1628686800
```

## 📚 SDKs

### JavaScript/TypeScript

```typescript
import { FamMedClient } from '@rapidresponse/fammed-sdk';

const client = new FamMedClient({
  apiKey: 'your-api-key',
  baseUrl: 'https://api.rapidresponsecentral.com/v1/fammed'
});

// Get random question
const question = await client.questions.getRandom({
  type: 'ITE',
  year: 2024
});

// Submit answer
const result = await client.questions.submitAnswer(question.id, {
  answer: 'A',
  timeSpent: 45
});
```

### Swift (iOS)

```swift
import FamMedSDK

let client = FamMedClient(apiKey: "your-api-key")

// Get random question
client.questions.getRandom(type: .ITE, year: 2024) { result in
    switch result {
    case .success(let question):
        print(question.text)
    case .failure(let error):
        print(error)
    }
}
```

### Kotlin (Android)

```kotlin
import com.rapidresponse.fammed.FamMedClient

val client = FamMedClient("your-api-key")

// Get random question
client.questions.getRandom(
    type = QuestionType.ITE,
    year = 2024
) { question ->
    println(question.text)
}
```

---

*API Version: 1.0*
*Last Updated: August 2025*