# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Development Commands

### Primary Build Commands
```bash
# Build the app for iOS Simulator (iPhone 16 Pro Max)
xcodebuild -scheme RapidResponseCentral -destination 'platform=iOS Simulator,name=iPhone 16 Pro Max' -configuration Debug build

# Clean build
xcodebuild -scheme RapidResponseCentral -destination 'platform=iOS Simulator,name=iPhone 16 Pro Max' clean build

# Run the app in simulator
xcrun simctl boot "iPhone 16 Pro Max" 2>/dev/null || true
open -a Simulator
xcodebuild -scheme RapidResponseCentral -destination 'platform=iOS Simulator,name=iPhone 16 Pro Max' -configuration Debug build
xcrun simctl install booted ~/Library/Developer/Xcode/DerivedData/RapidResponseCentral-*/Build/Products/Debug-iphonesimulator/RapidResponseCentral.app
xcrun simctl launch booted com.rapidresponsecentral.app
```

### Test Commands
```bash
# Run all tests
xcodebuild test -scheme RapidResponseCentral -destination 'platform=iOS Simulator,name=iPhone 16 Pro Max'

# Run specific test
xcodebuild test -scheme RapidResponseCentral -destination 'platform=iOS Simulator,name=iPhone 16 Pro Max' -only-testing:RapidResponseCentralFeatureTests/[TestClassName]/[testMethodName]
```

## Architecture Overview

### Project Structure
This is a **modular iOS app** using Swift Package Manager for feature organization:

- **App Shell**: `RapidResponseCentral/` - Minimal app lifecycle, just launches the main feature
- **Feature Code**: `RapidResponseCentralPackage/Sources/RapidResponseCentralFeature/` - All business logic and UI
- **Configuration**: `Config/` - XCConfig files for build settings and entitlements

### Core Services Architecture

The app implements a **multi-service protocol system** for emergency medical response:

1. **EmergencyProtocolService** (`Services/EmergencyProtocolService.swift`)
   - Critical emergency protocols: Code Blue, Code Stroke, Code STEMI, RSI, Shock/ECMO, Anaphylaxis, Emergency Support
   - Used in Emergency tab

2. **RRTProtocolService** (`Services/RRTProtocolService.swift`)
   - Rapid Response Team protocols: Sepsis, Respiratory Distress, Cardiac Monitoring, Neurological Assessment, Hypotension, AKI, Electrolyte Imbalance, Oxygenation, Pain Crisis, Rapid Deterioration
   - Used in RRT tab

3. **CallsProtocolService** (`Services/CallsProtocolService.swift`)
   - Clinical decision support: Acute HF, Right HF, Hypertensive Emergency, DKA, Hypoglycemia, Adrenal Crisis, Pneumothorax, Respiratory Failure, Asthma, GI Bleeding, Bowel Obstruction, Antiemetic, Acute Pain, Opiate Conversion, EOL
   - Used in Calls tab

4. **LabsProtocolService** (`Services/LabsProtocolService.swift`)
   - Laboratory value management: Anemia, Coagulopathy, Thrombocytopenia, Hypernatremia, Hyponatremia, Hyperkalemia, Hypokalemia, Hypocalcemia, Hypercalcemia, Hypomagnesemia, Hypophosphatemia, Hyperglycemia, Hypoglycemia, Renal Failure, Hepatic Encephalopathy, ABG Analysis, Acid-Base, Ventilator Adjustment
   - Used in Labs tab

5. **ProtocolService** (`Services/ProtocolService.swift`)
   - Main coordinator that aggregates all protocol services
   - Provides unified access to all protocols

### Key Data Models

**Protocol Structure** (`Models/AlgorithmModels.swift`):
- `EmergencyProtocol`: Main protocol container with algorithm and cards
- `ProtocolAlgorithm`: Contains nodes for flowchart visualization
- `AlgorithmNode`: Individual decision/action nodes with NodeType enum
- `ProtocolCard`: Information cards with CardType (dynamic, assessment, actions)
- `ProtocolCategory`: Categorization with associated colors

**Important Enums**:
- `NodeType`: decision, assessment, intervention, medication, endpoint, **action** (recently added)
- `CardType`: dynamic, assessment, actions
- `ProtocolCategory`: cardiac, neurological, respiratory, trauma, infectious, allergic, **support** (recently added)

### View Architecture

**Main Navigation**:
- `ContentView`: Tab-based navigation (Emergency, RRT, Calls, Labs, Resources)
- `EmergencyHomeView`: Grid of emergency protocol cards
- `ProtocolDetailView`: Split view with flowchart (left) and info cards (right)
- `FlowchartView`: Interactive SMART DR-style medical flowchart

**Component Views**:
- `BoxiconView`: Icon system using SF Symbols as fallback for Boxicon icons
- `ProtocolTimerBanner`: Timer display for protocol execution
- `EventLogModal`: Activity logging during protocol use
- `VisualAidView`: Educational visual content display

### Critical Implementation Details

1. **Swift 6 Concurrency**: All services use `@MainActor` and are `ObservableObject`
2. **Sendable Conformance**: All models conform to `Sendable` for thread safety
3. **iOS 18 Target**: Minimum deployment target is iOS 18.0
4. **SF Symbols Fallback**: BoxiconView maps medical icons to SF Symbols

## Known Issues & Resolutions

### Switch Exhaustive Errors
When adding new enum cases (like `.action` to NodeType or `.support` to ProtocolCategory), you must update ALL switch statements:
- `ProtocolDetailView.swift`: Lines ~117, ~295, ~314
- `FlowchartView.swift`: Lines ~129, ~142, ~155

### App Icon
The app icon should be at `RapidResponseCentral/Assets.xcassets/AppIcon.appiconset/AppIcon-1024.png`
- Size must be exactly 1024x1024
- Use `sips -z 1024 1024 input.png --out AppIcon-1024.png` to resize

### Protocol Missing Issues
If protocols are missing, verify:
1. Service is properly initialized in `createEmergencyProtocols()` or equivalent
2. Protocol creation function exists and is called
3. No compilation errors in the service files

## UI/UX Design Standards

### Flowchart Components
All flowcharts in the application MUST use the Omnichart component library from Figma:
- **Figma Resource**: https://www.figma.com/design/scXBg49V2dzDQdJVUgKUE1/Omnichart---Customizable-UX-Flow-Chart--Community-
- **Applies to**: FlowchartView, ProtocolDetailView, and all algorithm visualization components
- **Hook Configured**: Automatic reminder when flowchart files are modified

### Documentation Vault
The authoritative documentation for all protocols is located at:
`/Users/bhavenmurji/Development/RapidResponseCentral/Assets/RapidResponseCentralDocumentationVault/`

**Protocol Documentation Files**:
- **Emergencies**: `Protocols/Emergencies.md` - Emergency tab protocols
- **RRT**: `Protocols/RRTs.md` - Rapid Response Team protocols
- **Calls**: `Protocols/Calls.md` - Clinical decision support protocols
- **Labs**: `Protocols/Labs.md` - Laboratory value management protocols
- **Calculators**: `Protocols/Calculators.md` - Medical calculator protocols
- **Main Documentation**: `Rapid Response Central.md` - Overall app documentation

### Emergency Support Card Requirements
The Emergency Support Card component has specific requirements:
- **Location**: Bottom of grid structure in its own panel
- **Interaction**: Left-to-right swipeable to reveal additional phone numbers
- **Initial Display**: RRT initial steps
- **Key Phone Numbers**:
  - ICU NP
  - Anesthesia
  - Sevaro
  - Transfer Center
- **Hook Configured**: Automatic validation reminder when EmergencySupportCard files are modified

## Development Workflow

### Adding New Protocols
1. Add creation function in appropriate service file
2. Add to the service's main creation array
3. Update any new enum cases in `AlgorithmModels.swift`
4. Fix all switch exhaustive errors
5. Rebuild and test

### Modifying UI Components
1. Most UI work happens in `Views/` directory
2. Remember to mark public types with `public` access modifier
3. Use `@MainActor` for UI-related classes
4. Test on iPhone 16 Pro Max simulator (primary target)

### Working with Services
1. Services are `@MainActor` and `ObservableObject`
2. Protocols are loaded synchronously in `init()`
3. Each service manages its own protocol domain
4. ProtocolService aggregates all services

## Version History Context
- v2.2.0: Added RRT Service & Anaphylaxis protocol
- v2.1.4: Fixed UI layout and protocol icons
- v2.1.3: Enhanced flowchart visualization
- Current: Working on Emergency Support protocol integration

## File Locations
- Main feature code: `RapidResponseCentralPackage/Sources/RapidResponseCentralFeature/`
- Services: `.../Services/` (EmergencyProtocolService, RRTProtocolService, etc.)
- Models: `.../Models/AlgorithmModels.swift`
- Views: `.../Views/` (Emergency/, Components/, Onboarding/, etc.)
- App Icon: `RapidResponseCentral/Assets.xcassets/AppIcon.appiconset/`