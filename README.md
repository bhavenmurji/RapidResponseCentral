# Rapid Response Central

A comprehensive iOS application designed for healthcare professionals to quickly access critical emergency medical protocols and clinical decision support tools.

## Overview

Rapid Response Central provides instant access to emergency medical protocols, rapid response team guidelines, clinical decision algorithms, and laboratory value management tools. Built specifically for healthcare providers in critical care settings, this app ensures vital information is always at your fingertips when seconds count.

## Features

### 🚨 Emergency Protocols
- **Code Blue (ACLS)** - Advanced Cardiac Life Support protocols
- **Code Stroke** - Stroke response and treatment algorithms
- **Code STEMI** - ST-Elevation MI management
- **RSI & Advanced Airway** - Rapid Sequence Intubation protocols
- **Shock & ECMO** - Shock management and ECMO protocols
- **Anaphylaxis** - Severe allergic reaction management
- **Emergency Support** - Quick access to critical phone numbers and resources

### 🏥 Rapid Response Team (RRT) Protocols
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

### 📞 Clinical Decision Support (Calls)
- Acute heart failure management
- Hypertensive emergencies
- Diabetic emergencies (DKA, Hypoglycemia)
- Respiratory conditions (Asthma, COPD, Pneumothorax)
- GI emergencies (Bleeding, Obstruction)
- Pain management and palliative care
- End-of-life care protocols

### 🔬 Laboratory Value Management
- Comprehensive management algorithms for:
  - Electrolyte abnormalities
  - Hematologic issues
  - Renal failure
  - Hepatic encephalopathy
  - ABG analysis
  - Acid-base disorders
  - Ventilator adjustments

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

## UI/UX Design

### Flowchart Components
The app uses professional medical flowchart visualizations based on the Omnichart component library. All algorithm visualizations follow SMART DR-style medical flowchart conventions for clarity and consistency.

### Design Principles
- **Accessibility First**: Full support for VoiceOver and Dynamic Type
- **Dark Mode Support**: Optimized for low-light clinical environments
- **Performance**: Sub-3 second load times on all devices
- **Medical Icons**: Comprehensive healthicon library with SF Symbols fallback

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