# Rapid Response Central - Where Seconds Save Lives

When code blue alarms pierce through the 3 AM silence, family medicine residents face medicine's most brutal truth: in emergencies, knowledge without instant access equals death. Rapid Response Central transforms this reality, delivering Virtua Voorhees Hospital's critical care protocols through an interface designed for the split-second decisions that separate life from loss.

This isn't another medical reference drowning residents in academic abstractions. This is emergency medicine's first AI-native lifeline—built by physicians who've felt the crushing weight of responsibility when patients crash, for residents standing in those same shoes today.

## The Emergency Medicine Reality Check

Modern medical education creates a cruel paradox: residents train on complex EHR systems optimized for billing while patients die waiting for life-saving interventions buried in digital bureaucracy. When cardiac arrest strikes at 3 AM, UpToDate's comprehensive articles become academic luxury. AAFP guidelines transform into cruel irrelevance. What residents need isn't more information—it's the right information, instantly, precisely when death hovers in the room.

Rapid Response Central shatters this paradigm with bold, crystal-clear interfaces inspired by SmartDr's emergency-optimized design and Virtua's MyEOP system, reimagined through the lens of mobile-first, AI-enhanced emergency medicine.

## Seven Revolutionary Modules - Complete Emergency Ecosystem

### 1. Emergencies 🚨
- **Code Blue (ACLS)** - Advanced Cardiac Life Support protocols
- **Code Stroke** - Stroke response and treatment algorithms
- **Code STEMI** - ST-Elevation MI management
- **RSI & Advanced Airway** - Rapid Sequence Intubation protocols
- **Shock & ECMO** - Shock management and ECMO protocols

### 2. Rapid Response Team (RRT) 🔴
- Sepsis management
- Respiratory distress
- Cardiac monitoring
- Neurological assessment
- Hypotension management
- Acute kidney injury
- Electrolyte imbalances
- Oxygenation protocols
- Pain crisis management
- Rapid deterioration response

### 3. Clinical Decision Support (Calls) 🟡
- Acute heart failure management
- Hypertensive emergencies
- Diabetic emergencies (DKA, Hypoglycemia)
- Respiratory conditions (Asthma, COPD, Pneumothorax)
- GI emergencies (Bleeding, Obstruction)
- Pain management and palliative care
- End-of-life care protocols

### 4. Laboratory Value Management 🧪
- Comprehensive management algorithms for:
  - Electrolyte abnormalities
  - Hematologic issues
  - Renal failure
  - Hepatic encephalopathy
  - ABG analysis
  - Acid-base disorders
  - Ventilator adjustments

### 5. Medical Calculators 📊
- Evidence-based clinical calculators
- Risk stratification tools
- Dosing calculators
- Scoring systems (NIHSS, CHADS-VASc, qSOFA, etc.)

### 6. MEData Chat 💬 - AI-Powered Clinical Intelligence
**HIPAA-Compliant Clinical Assistant:**
- Powered by Meditron 70B with Virtua-specific protocol knowledge
- Instant answers to complex clinical questions with evidence citations
- Drug interaction checking with contraindication alerts
- Dosing calculations with weight-based recommendations

### 7. FamMED Central Study Module 📚 - Comprehensive Learning Platform
**Test Module - UWorld-Style Excellence:**
- Topic-organized question bank with detailed explanations
- Review mode with spaced repetition algorithms
- Exam mode with ABFM-style timing and scoring
- Performance analytics with weakness identification

## Technical Architecture

### Project Structure
```
RapidResponseCentral/
├── RapidResponseCentral.xcworkspace/    # Open this in Xcode
├── RapidResponseCentral.xcodeproj/      # App shell project
├── RapidResponseCentral/                # App target (minimal)
│   ├── Assets.xcassets/                 # App icon and assets
│   └── RapidResponseCentralApp.swift    # App entry point
├── RapidResponseCentralPackage/         # Main feature module (SPM)
│   ├── Package.swift                    # Package configuration
│   └── Sources/
│       └── RapidResponseCentralFeature/
│           ├── Models/                  # Data models and structures
│           ├── Services/                # Protocol services
│           ├── Views/                   # SwiftUI views
│           └── DesignSystem/            # UI components and themes
├── Assets/                              # Documentation vault and resources
│   └── RapidResponseCentralDocumentationVault/
│       └── Protocols/                   # Medical protocol documentation
└── Config/                              # Build configurations
    ├── Shared.xcconfig
    ├── Debug.xcconfig
    ├── Release.xcconfig
    └── RapidResponseCentral.entitlements
```

### Key Technologies
- **Platform**: iOS 18.0+
- **Language**: Swift 6.0
- **UI Framework**: SwiftUI
- **Architecture**: Modular design with Swift Package Manager
- **Concurrency**: Swift 6 Concurrency with @MainActor
- **Thread Safety**: Full Sendable conformance

### Core Services
- `EmergencyProtocolService` - Emergency protocol management
- `RRTProtocolService` - Rapid Response Team protocols
- `CallsProtocolService` - Clinical decision support
- `LabsProtocolService` - Laboratory value algorithms
- `ProtocolService` - Main coordinator service

## Development

### Requirements
- Xcode 16.0+
- iOS 18.0+ SDK
- macOS 14.0+ (for development)

### Building the Project

```bash
# Build for iOS Simulator
xcodebuild -scheme RapidResponseCentral \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro Max' \
  -configuration Debug build

# Clean build
xcodebuild -scheme RapidResponseCentral \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro Max' \
  clean build
```

### Running Tests

```bash
# Run all tests
xcodebuild test -scheme RapidResponseCentral \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro Max'

# Run specific test
xcodebuild test -scheme RapidResponseCentral \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro Max' \
  -only-testing:RapidResponseCentralFeatureTests/TestClassName/testMethodName
```

### Running in Simulator

```bash
# Boot simulator and install app
xcrun simctl boot "iPhone 16 Pro Max" 2>/dev/null || true
open -a Simulator

# Build and install
xcodebuild -scheme RapidResponseCentral \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro Max' \
  -configuration Debug build

# Install to booted simulator
xcrun simctl install booted \
  ~/Library/Developer/Xcode/DerivedData/RapidResponseCentral-*/Build/Products/Debug-iphonesimulator/RapidResponseCentral.app

# Launch app
xcrun simctl launch booted com.rapidresponsecentral.app
```

## Public API Requirements

Types exposed to the app target need `public` access:
```swift
public struct NewView: View {
    public init() {}
    
    public var body: some View {
        // Your view code
    }
}
```

## Revolutionary UI/UX Architecture: 50/50 Split Design

### Cognitive Balance for Emergency Decision-Making

The interface creates perfect cognitive equilibrium with a 50/50 split optimized for emergency decision-making:

**Top Panel (50% height): Dynamic Information Display**
- Three-card horizontal scroll system with smooth 250ms transitions
- **Card 0 (Dynamic)**: Context-sensitive content updating based on algorithm selection
- **Card 1 (Static Assessment)**: Causes, differential diagnosis, and history guidance
- **Card 2 (Static Actions)**: Physical exam details, medications, and contraindications

**Bottom Panel (50% height): Interactive Algorithm Decision Tree**
- Vertically scrollable flowcharts mirroring clinical decision pathways
- Touch-optimized nodes (60x60pt minimum) with color-coded urgency paths
- Active node highlighting with bidirectional sync to top panel cards
- Progress tracking with timestamp documentation

### Emergency-Optimized Design
- **High-contrast fonts** readable in low-light conditions
- **Color-coded severity indicators** (red: urgent, yellow: caution, green: stable)
- **Haptic feedback** for critical selections
- **Voice control capability** for hands-free operation

### Performance Specifications
- Sub-50ms node response times
- 60fps smooth scrolling maintained
- Complete offline functionality
- <2 second app launch to usable interface

## Documentation

The complete medical protocol documentation is maintained in the `Assets/RapidResponseCentralDocumentationVault/` directory, organized by protocol type:
- Emergency protocols
- RRT protocols
- Clinical decision support
- Laboratory management
- Medical calculators

## AI Assistant Configuration

This project includes configuration files for AI coding assistants:
- **Claude Code**: `CLAUDE.md` - Build commands and architecture overview
- **CLAUDE.local.md**: Personal project instructions (not committed to repo)

These files help AI assistants understand the project structure and development workflow.

## Version History

- **v2.2.0** - Added RRT Service & Anaphylaxis protocol
- **v2.1.4** - Fixed UI layout and unique protocol icons
- **v2.1.3** - Enhanced flowchart visualization
- **v2.1.0** - Major protocol implementation updates

## Contributing

This is a medical application that requires clinical accuracy. All protocol implementations must be reviewed by qualified medical professionals before deployment.

## License

Proprietary - All rights reserved

## Contact

For development inquiries or access requests, please contact the development team.

## Important Notice

This application is designed as a reference tool for qualified healthcare professionals. It is not a substitute for clinical judgment, professional training, or institutional protocols. Always follow your institution's specific protocols and guidelines.

---

**Bundle ID**: com.rapidresponsecentral.app  
**Minimum iOS Version**: 18.0  
**Primary Development Target**: iPhone 16 Pro Max  
**Generated with**: [XcodeBuildMCP](https://github.com/cameroncooke/XcodeBuildMCP)