# RapidResponseCentral - SPARC Architecture

## System Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    RapidResponseCentral App                      │
├─────────────────────────────────────────────────────────────────┤
│                         App Shell                                │
│                   (RapidResponseCentralApp)                      │
├─────────────────────────────────────────────────────────────────┤
│                    Swift Package Manager                         │
│                (RapidResponseCentralFeature)                     │
├──────────────────┬────────────────┬─────────────────────────────┤
│   Core Models    │  UI Components │    Services                 │
│                  │                │                              │
│ • Protocol       │ • MainTabView  │ • ProtocolService           │
│ • Emergency      │ • EmergencyView│ • EventLogger               │
│ • Calculator     │ • ProtocolFlow │ • SearchService             │
│ • StudyQuestion  │ • TimerView    │ • CalculatorEngine          │
│ • EventLog       │ • CardStack    │ • StudyService              │
│ • Contact        │ • LogModal     │ • ContactsService           │
└──────────────────┴────────────────┴─────────────────────────────┘
```

## Module Architecture

### 1. Core Data Layer

```swift
// Models/
├── Protocol.swift          // Emergency protocol data model
├── ProtocolNode.swift      // Decision tree nodes
├── ProtocolCard.swift      // Information cards
├── EventLog.swift          // Event tracking model
├── Calculator.swift        // Medical calculator definitions
├── StudyQuestion.swift     // ABFM exam questions
└── Contact.swift           // Emergency contacts

// Protocols/
├── ProtocolServiceProtocol.swift
├── EventLoggerProtocol.swift
└── SearchableProtocol.swift
```

### 2. Service Layer

```swift
// Services/
├── ProtocolService.swift       // Protocol data management
├── EventLogger.swift           // Event logging service
├── SearchService.swift         // Full-text search
├── CalculatorEngine.swift      // Calculator implementations
├── StudyService.swift          // Study module service
├── ContactsService.swift       // Contacts management
└── TimerService.swift          // Protocol timer management
```

### 3. UI Layer

```swift
// Views/
├── MainTabView.swift           // Root navigation
├── Emergency/
│   ├── EmergencyListView.swift
│   ├── ProtocolFlowView.swift  // 50/50 split UI
│   ├── ProtocolCardView.swift
│   └── AlgorithmNodeView.swift
├── Components/
│   ├── TimerBanner.swift
│   ├── EventLogModal.swift
│   ├── SearchBar.swift
│   └── ProtocolCard.swift
├── Calculators/
│   ├── CalculatorListView.swift
│   └── CalculatorDetailView.swift
└── Study/
    ├── StudyHomeView.swift
    └── QuestionView.swift
```

## Data Flow Architecture

```
User Action → View → Service → Model → View Update
     ↓                            ↓
EventLogger ← ← ← ← ← ← ← ← EventLog
```

## Key Design Patterns

### 1. Repository Pattern
- Services act as repositories for data access
- Abstracts data source (JSON, Database, Network)

### 2. Observer Pattern
- @Observable models for reactive updates
- SwiftUI automatic view updates

### 3. Command Pattern
- Event logging captures all user actions
- Supports undo/redo functionality

### 4. Strategy Pattern
- Calculator implementations use common protocol
- Swappable calculation algorithms

## Performance Architecture

### Memory Management
- Lazy loading of protocol content
- Image caching for protocol screenshots
- Automatic memory pressure handling

### Offline-First Design
- All protocols bundled in app
- Local event storage
- Network optional for updates

### Search Architecture
- Pre-indexed protocol content
- Fuzzy search with Levenshtein distance
- Search results cached in memory

## Security & Privacy

### Data Protection
- No patient data stored
- Event logs contain only protocol actions
- All data local to device

### HIPAA Compliance
- No PHI collection
- Audit trail for actions only
- Encrypted local storage

## Scalability Considerations

### Content Updates
- Version-tracked protocols
- Delta updates for content
- Backward compatibility

### Feature Extensions
- Plugin architecture for calculators
- Modular protocol system
- AI service abstraction layer

## Testing Architecture

### Unit Testing
- Calculator accuracy tests
- Protocol navigation tests
- Event logging verification

### UI Testing
- Emergency flow testing
- Accessibility verification
- Performance benchmarks

### Integration Testing
- End-to-end protocol scenarios
- Multi-module integration
- Data persistence tests