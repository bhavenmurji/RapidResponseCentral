# Rapid Response Central - iOS Medical Reference App

## Project Overview
Rapid Response Central is a medical reference application designed for Family Medicine residents at Virtua Voorhees. It provides quick access to emergency protocols, clinical calculators, and educational resources.

## Key Features
1. **Emergency Protocols** - Quick access to hospital-specific protocols:
   - Sepsis Protocol
   - Code Stroke
   - Code STEMI
   - ECMO
   - CAUTI
   - ACLS Code Blue
   - Bradycardia
   - Tachycardia
   - Hypoxia
   - Hypotension
   - Heart Failure
   - Fever

2. **Clinical Calculators** - Essential medical calculators for rapid assessment

3. **FamMed Central** - Study module with ABFM ITE exam questions and CME content

4. **SmartDr-Style UI** - Clean, easy-to-follow interface optimized for quick reference

## Development Setup

### Project Location
```
/Users/bhavenmurji/Library/Mobile Documents/com~apple~CloudDocs/Development/RapidResponseCentralFresh/
```

### Architecture
- **App Shell**: Minimal wrapper in `RapidResponseCentral/`
- **Feature Code**: All business logic in `RapidResponseCentralPackage/Sources/RapidResponseCentralFeature/`
- **Resources**: Protocol content and assets in `Resources/`

### Directory Structure
```
RapidResponseCentralPackage/Sources/RapidResponseCentralFeature/
├── Models/         # Protocol data models
├── Views/          # SwiftUI views
├── Services/       # Data loading and business logic
├── Protocols/      # Protocol interfaces
└── Resources/      # JSON files, images, content
```

## Content Sources

### Protocol Text Content
Located in: `/Users/bhavenmurji/Library/Mobile Documents/com~apple~CloudDocs/Downloads/IGNITE/RapidResponseCentral/protocol_text_versions/`
- bradycardia_extracted.txt
- tachycardia_extracted.txt
- hypoxia_extracted.txt
- hypotension_extracted.txt
- heart_failure_extracted.txt
- fever_extracted.txt
- calculators_protocols.md

### UI References
- SmartDr screenshots (for UI style reference)
- myEOP screenshots (for Virtua-specific protocols)

## UI/UX Guidelines

### Design System
- Use SwiftUI native components
- Clean, medical-grade interface
- High contrast for emergency situations
- Large, tappable targets
- Clear typography hierarchy

### Navigation
- Tab-based navigation for main sections
- Quick access to emergency protocols
- Search functionality across all content
- Offline-first design

### Color Scheme
- Primary: System blue for navigation
- Emergency: System red for critical protocols
- Success: System green for completed steps
- Background: System background colors for light/dark mode

## Implementation Notes

### Data Management
- JSON-based protocol storage
- Offline-first with bundled content
- Version tracking for protocol updates
- Search indexing for quick access

### Performance
- Lazy loading for content
- Efficient search algorithms
- Minimal memory footprint
- Fast protocol access (< 1s)

### Testing
- Unit tests for calculators
- UI tests for critical paths
- Protocol content validation
- Accessibility testing

## Building & Running

### Using XcodeBuildMCP Tools

1. **Build for Simulator**:
```javascript
build_sim_name_ws({
    workspacePath: "/Users/bhavenmurji/Library/Mobile Documents/com~apple~CloudDocs/Development/RapidResponseCentralFresh/RapidResponseCentral.xcworkspace",
    scheme: "RapidResponseCentral",
    simulatorName: "iPhone 16 Pro Max"
})
```

2. **Build and Run**:
```javascript
build_run_sim_name_ws({
    workspacePath: "/Users/bhavenmurji/Library/Mobile Documents/com~apple~CloudDocs/Development/RapidResponseCentralFresh/RapidResponseCentral.xcworkspace",
    scheme: "RapidResponseCentral",
    simulatorName: "iPhone 16 Pro Max"
})
```

3. **Run Tests**:
```javascript
test_sim_name_ws({
    workspacePath: "/Users/bhavenmurji/Library/Mobile Documents/com~apple~CloudDocs/Development/RapidResponseCentralFresh/RapidResponseCentral.xcworkspace",
    scheme: "RapidResponseCentral",
    simulatorName: "iPhone 16 Pro Max"
})
```

## Next Steps

1. **Set up protocol data models** in `Models/`
2. **Create main navigation structure** in `Views/`
3. **Implement protocol loading service** in `Services/`
4. **Design protocol detail views** following SmartDr style
5. **Add search functionality** across all content
6. **Implement FamMed Central study module**
7. **Add clinical calculators**
8. **Test on various devices** including iPhone 16 Pro Max

## Important Notes

- All development should happen in the `RapidResponseCentralPackage`
- Use `@Observable` for data models, not ViewModels
- Follow Swift 6 concurrency patterns
- Ensure all UI is accessible with VoiceOver
- Test offline functionality thoroughly
- Keep protocol content up-to-date with hospital guidelines
