# MEDUCare (MVP 1): Rapid Response Central - Where Seconds Save Lives

When code blue alarms pierce through the 3 AM silence, family medicine residents face medicine's most brutal truth: in emergencies, knowledge without instant access equals death. Rapid Response Central transforms this reality, delivering Virtua Voorhees Hospital's critical care protocols through an interface designed for the split-second decisions that separate life from loss.

This isn't another medical reference drowning residents in academic abstractions. This is emergency medicine's first AI-native lifeline—built by physicians who've felt the crushing weight of responsibility when patients crash, for residents standing in those same shoes today.

## The Emergency Medicine Reality Check

Modern medical education creates a cruel paradox: residents train on complex EHR systems optimized for billing while patients die waiting for life-saving interventions buried in digital bureaucracy. When cardiac arrest strikes at 3 AM, UpToDate's comprehensive articles become academic luxury. AAFP guidelines transform into cruel irrelevance. What residents need isn't more information—it's the right information, instantly, precisely when death hovers in the room.

Rapid Response Central shatters this paradigm with bold, crystal-clear interfaces inspired by SmartDr's emergency-optimized design and Virtua's MyEOP system, reimagined through the lens of mobile-first, AI-enhanced emergency medicine.

# Simplified Clinical Decision Support App - Navigation Design

## Top Banner Design (Simplified)

```
┌─────────────────────────────────────────────────────────────────┐
│ Code Blue  -60s -30s -5s -1s  05:34 ▶️ 🔄 ⏱️ 📝  +1s +5s +30s +60s│
└─────────────────────────────────────────────────────────────────┘
```

### Top Banner Components:

**Left Side:**

- Active protocol name (dynamically updates)
- Location/room if applicable

**Right Side:**

- Timer display (MM:SS)
- `bx-play` / `bx-pause` - Start/Pause timer
- `bx-reset` - Reset to 00:00
- `bx-timer` - Lap (create blank event)
- `bx-list-ul` - View/Edit log

## Main Menu Example: Emergencies

### Emergencies Menu

```
┌─────────────────────────────────────────────────────────────────┐
│                         EMERGENCIES                              │
├─────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────┐ ┌─────────────────────┐                │
│ │      Code Blue      │ │    Code Stroke      │                │
│ │         🫀          │ │         🧠          │                │
│ └─────────────────────┘ └─────────────────────┘                │
│                                                                 │
│ ┌─────────────────────┐ ┌─────────────────────┐                │
│ │     Code STEMI      │ │         RSI         │                │
│ │         💔          │ │         🫁          │                │
│ └─────────────────────┘ └─────────────────────┘                │
│                                                                 │
│ ┌─────────────────────┐                                        │
│ │       Shock         │                                         |
│ │         ⚡           │                                         |
│ └─────────────────────┘                                         |
└─────────────────────────────────────────────────────────────────┘
```


## Bottom Navigation Design

```
┌─────────────────────────────────────────────────────────────────┐
│ ┌─────────┬────────┬────────┬────────┬────────┬────────┬────────┐ │
│ │ 🚨      │ 🔴     │ 🟡     │ 🧪     │ 📊     │ 💬     │ 📚     │ │
│ │ Emerg   │  RRT   │ Calls  │  Labs  │  Calc  │  Chat  │ Study  │ │
│ │ ━━━━━   │        │        │        │        │        │        │ │
│ └─────────┴────────┴────────┴────────┴────────┴────────┴────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

## First-Time User Onboarding
### Welcome Screen

```
┌─────────────────────────────────────────────────────────────────┐
│                    Welcome to                                   │
│             🚨 RAPID RESPONSE CENTRAL                           │
│                                                                 │
│     Your comprehensive clinical decision support tool           │
│                                                                 │
│ • Emergency protocols optimized for bedside use                │
│ • Evidence-based calculators and tools                         │
│ • Virtua Voorhees-specific guidelines                          │
│ • Study tools for medical education                            │
│                                                                 │
│                                                                 │
│                      [Get Started]                              │
└─────────────────────────────────────────────────────────────────┘
```

### Feature Tour Overlay

```
┌─────────────────────────────────────────────────────────────────┐
│                                                             [X] │
│  👆 TAP HERE FOR EMERGENCY PROTOCOLS                           │
│                                                                 │
│  The Emergencies tab contains life-saving protocols            │
│  like Code Blue, Stroke, and STEMI. These are                  │
│  optimized for rapid access during critical situations.        │
│                                                                 │
│                                                                 │
│                      [Next Tip] (1 of 5)                       │
└─────────────────────────────────────────────────────────────────┘
```



### Text Size Adjustment

```
┌─────────────────────────────────────────────────────────────────┐
│ TEXT SIZE                                                   [X] │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│ Small     [A-]                                                  │
│ Normal    [A] ●                                                 │
│ Large     [A+]                                                  │
│ X-Large   [A++]                                                 │
│                                                                 │
│ Preview:                                                        │
│ ┌─────────────────────────────────────────────────────────────┐ │
│ │ Epinephrine 1mg IV/IO                                       │ │
│ │ Give every 3-5 minutes during arrest                       │ │
│ └─────────────────────────────────────────────────────────────┘ │
│                                                                 │
│              [Cancel]             [Apply]                       │
└─────────────────────────────────────────────────────────────────┘
```



### 

### HIPAA Compliance Notice

```
┌─────────────────────────────────────────────────────────────────┐
│ DATA PRIVACY NOTICE                                         [X] │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│ This app is designed for clinical decision support only.        │
│                                                                 │
│ IMPORTANT:                                                      │
│ • Do not enter patient identifiers                             │
│ • Event logs contain only protocol actions                     │
│ • No data is stored on external servers                        │
│ • All data remains on your device                              │
│                                                                 │
│ For full privacy policy and HIPAA compliance                   │
│ information, visit: meddata.com/privacy                        │
│                                                                 │
│           [View Privacy Policy]        [I Understand]          │
└─────────────────────────────────────────────────────────────────┘
```
## Event Log Modal

```
┌─────────────────────────────────────────────────────────────────┐
│ EVENT LOG                                                    [X] │
├─────────────────────────────────────────────────────────────────┤
│ Protocol: Code Blue - Room 214                                  │
│ Duration: 05:34 (Active)                                        │
├─────────────────────────────────────────────────────────────────┤
│ Time     Event                                   ✏️    🗑️       │
│ ────────────────────────────────────────────────────────────── │
│ 00:00    Code Blue initiated                    [✏️]  [🗑️]     │
│ 00:45    ☑️ Shock delivered - 200J              [✏️]  [🗑️]     │
│ 01:30    ⏱️ Lap                                 [✏️]  [🗑️]     │
│ 02:00    → Moved to CPR node                    [✏️]  [🗑️]     │
│ 02:15    ☑️ Epinephrine 1mg given              [✏️]  [🗑️]     │
│ 03:00    📞 Sevaro called (856-363-0709)       [✏️]  [🗑️]     │
│ 04:12    💊 Second dose Epi 1mg                [✏️]  [🗑️]     │
│ 05:00    🧮 NIHSS Score: 18                    [✏️]  [🗑️]     │
│ 05:34    ⏱️ Lap                                 [✏️]  [🗑️]     │
│                                                                 │
│                   [Export Log]  [Clear All]                     │
└─────────────────────────────────────────────────────────────────┘
```

### Event Types & Icons:

- **Protocol start**: Default text
- **Checkbox action**: ☑️ (medication given, procedure done)
- **Lap marker**: ⏱️ (blank timestamp)
- **Node navigation**: → (algorithm progression)
- **Phone call**: 📞 (Sevaro, Transfer Center)
- **Medication**: 💊 (dose administered)
- **Calculator**: 🧮 (score calculated)
- **Custom note**: 📝 (manual entry)

## Edit Event Modal

```
┌─────────────────────────────────────────────────────────────────┐
│ EDIT EVENT                                                  [X] │
├─────────────────────────────────────────────────────────────────┤
│ Time: 02:15                                                     │
│                                                                 │
│ Event Type:                                                     │
│ ○ Medication  ● Procedure  ○ Phone Call  ○ Note               │
│                                                                 │
│ Description:                                                    │
│ [Epinephrine 1mg given                               ]         │
│                                                                 │
│ Additional Notes:                                               │
│ [IV push via central line                            ]         │
│ [                                                    ]         │
│                                                                 │
│              [Cancel]            [Save]                         │
└─────────────────────────────────────────────────────────────────┘
```


## Seven Revolutionary Modules - Complete Emergency Ecosystem

### 1. [[Emergencies]]
### 2. [[RRTs]]
### 3. [[Calls]]
### 4. [[Labs]]
### 5. [[Calculators]]

### 6. MEData Chat - AI-Powered Clinical Intelligence

**HIPAA-Compliant Clinical Assistant:**

- Powered by Meditron 70B with Virtua-specific protocol knowledge
- Instant answers to complex clinical questions with evidence citations
- Drug interaction checking with contraindication alerts
- Dosing calculations with weight-based recommendations

**Institutional Knowledge Integration:**

- Understands Virtua Voorhees specific protocols and contact numbers
- Antibiogram integration for targeted antibiotic recommendations
- Transfer center coordination and specialist contact information

**Future MEData Readiness:**

- Placeholder architecture for seamless MEData MMOM integration
- Conversation history and clinical context preservation
- Multi-modal capability preparation (voice, image, document analysis)

### 7. FamMED Central Study Module - Comprehensive Learning Platform

**Test Module - UWorld-Style Excellence:**

- Topic-organized question bank with detailed explanations
- Review mode with spaced repetition algorithms
- Exam mode with ABFM-style timing and scoring
- Performance analytics with weakness identification and improvement tracking

**Study Module - Advanced Spaced Repetition:**

- ANKI-style flashcards powered by FSRS algorithm
- Adaptive learning patterns based on individual performance
- Multimedia card support with images, ECGs, and audio
- Custom deck creation with peer sharing capabilities

**Read Module - Curated Evidence Base:**

- AAFP articles directly linked to question explanations
- Topic-based organization matching question bank structure
- Bookmarking and annotation tools for key concepts
- Offline reading with cross-device synchronization

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

### Universal Protocol Framework

**Gesture-Based Navigation:**

- Horizontal swipes for card transitions
- Vertical scrolling for algorithm navigation
- Pinch-to-zoom for algorithm overview
- One-handed operation optimization

**Emergency-Optimized Design:**

- High-contrast fonts readable in low-light conditions
- Color-coded severity indicators (red: urgent, yellow: caution, green: stable)
- Haptic feedback for critical selections
- Voice control capability for hands-free operation

**Performance Specifications:**

- Sub-50ms node response times
- 60fps smooth scrolling maintained
- Complete offline functionality
- <2 second app launch to usable interface
# Additional Required Modals for Clinical Decision Support App

## 1. Login Modal (For Chat & Study tabs)

```
┌─────────────────────────────────────────────────────────────────┐
│ FAM MED CENTRAL LOGIN                                       [X] │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│ Access Chat & Study Features                                    │
│                                                                 │
│ Email/Username:                                                 │
│ [_________________________________]                             │
│                                                                 │
│ Password:                                                       │
│ [_________________________________]                             │
│                                                                 │
│ ☐ Remember me                                                   │
│                                                                 │
│ [Forgot Password?]                                              │
│                                                                 │
│             [Cancel]              [Login]                       │
└─────────────────────────────────────────────────────────────────┘
```

## 2. Settings Modal

```
┌─────────────────────────────────────────────────────────────────┐
│ SETTINGS                                                    [X] │
├─────────────────────────────────────────────────────────────────┤
│ APPEARANCE                                                      │
│ Theme:        ○ Light  ● Dark  ○ Auto                         │
│ Text Size:    [A-] [A] [A+]                                   │
│                                                                 │
│ NOTIFICATIONS                                                   │
│ ☑ Timer alerts                                                  │
│ ☑ Medication reminders                                          │
│ ☐ Study reminders                                              │
│                                                                 │
│ DEFAULTS                                                        │
│ Hospital: [Virtua Voorhees        ▼]                           │
│ Department: [Emergency            ▼]                           │
│                                                                 │
│ DATA & PRIVACY                                                  │
│ [Export All Logs]  [Clear Cache]  [Privacy Policy]            │
│                                                                 │
│ ABOUT                                                          │
│ Version 2.0.1                                                  │
│ © 2024 MEData                                                  │
│                                                                 │
│                              [Done]                             │
└─────────────────────────────────────────────────────────────────┘
```

## 3. Protocol Info/Help Modal

```
┌─────────────────────────────────────────────────────────────────┐
│ PROTOCOL INFORMATION                                        [X] │
├─────────────────────────────────────────────────────────────────┤
│ Code Blue - Adult Cardiac Arrest                               │
│                                                                 │
│ Last Updated: January 2024                                      │
│ Source: AHA Guidelines 2020                                     │
│                                                                 │
│ QUICK TIPS:                                                    │
│ • High-quality CPR: 100-120/min, 2 inches                     │
│ • Minimize interruptions (<10 sec)                             │
│ • Rotate compressors every 2 minutes                           │
│ • Early defibrillation for VF/VT                              │
│                                                                 │
│ MEDICATIONS:                                                    │
│ • Epinephrine 1mg q3-5min                                     │
│ • Amiodarone 300mg → 150mg                                    │
│ • Lidocaine 1-1.5mg/kg                                        │
│                                                                 │
│ [View Full Protocol]           [Close]                         │
└─────────────────────────────────────────────────────────────────┘
```

## 4. Confirmation Dialogs

### Reset Timer Confirmation

```
┌─────────────────────────────────────────────────────────────────┐
│ RESET TIMER?                                                    │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│ This will reset the timer to 00:00.                           │
│ Event log will be preserved.                                   │
│                                                                 │
│ Current time: 05:34                                           │
│                                                                 │
│              [Cancel]          [Reset]                          │
└─────────────────────────────────────────────────────────────────┘
```

### Clear Log Confirmation

```
┌─────────────────────────────────────────────────────────────────┐
│ CLEAR ALL EVENTS?                                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│ ⚠️ This action cannot be undone.                               │
│                                                                 │
│ Delete all 9 logged events?                                    │
│                                                                 │
│              [Cancel]      [Clear All]                          │
└─────────────────────────────────────────────────────────────────┘
```

### Exit Protocol Confirmation

```
┌─────────────────────────────────────────────────────────────────┐
│ EXIT ACTIVE PROTOCOL?                                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│ Timer is still running (05:34).                                │
│                                                                 │
│ ○ Save log and exit                                           │
│ ○ Discard log and exit                                        │
│ ○ Continue protocol                                            │
│                                                                 │
│              [Cancel]        [Confirm]                          │
└─────────────────────────────────────────────────────────────────┘
```

##  Network Error Modal

```
┌─────────────────────────────────────────────────────────────────┐
│ CONNECTION ERROR                                                │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│ ⚠️ Unable to connect to server                                 │
│                                                                 │
│ Some features may be unavailable:                              │
│ • Chat (AI Assistant)                                          │
│ • Study materials                                              │
│ • Protocol updates                                             │
│                                                                 │
│ Core protocols remain available offline.                       │
│                                                                 │
│                              [OK]                               │
└─────────────────────────────────────────────────────────────────┘
```

##  Update Available Modal

```
┌─────────────────────────────────────────────────────────────────┐
│ UPDATE AVAILABLE                                                │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│ Version 2.1.0 is available                                     │
│                                                                 │
│ What's New:                                                    │
│ • Updated sepsis protocols                                     │
│ • New pediatric calculators                                    │
│ • Improved timer accuracy                                      │
│ • Bug fixes                                                    │
│                                                                 │
│        [Later]         [Update Now]                            │
└─────────────────────────────────────────────────────────────────┘
```

## Log Export Format Example

```
CODE BLUE EVENT LOG
Location: Room 214
Date: 2024-01-15
Duration: 05:34

TIME    EVENT
00:00   Code Blue initiated
00:45   ✓ Shock delivered - 200J
01:30   Lap marker
02:00   Algorithm: Moved to CPR node
02:15   ✓ Epinephrine 1mg given
03:00   Phone: Sevaro called (856-363-0709)
04:12   Medication: Second dose Epi 1mg
05:00   Calculator: NIHSS Score: 18
05:34   Lap marker

Exported: 2024-01-15 14:37:49
```

## Auto-Logging Rules

**Automatic Events Logged:**

1. Protocol selection/start
2. Node transitions in algorithm
3. Checkbox selections within protocols
4. Calculator completions with scores
5. Phone number taps (Sevaro, Transfer Center)
6. Medication dose selections

**Manual Events:**

1. Lap button (blank timestamp)
2. Custom notes via log interface
3. Edited events

## 8. Quick Add Note Modal

```
┌─────────────────────────────────────────────────────────────────┐
│ ADD NOTE                                                    [X] │
├─────────────────────────────────────────────────────────────────┤
│ Time: 05:34                                                     │
│                                                                 │
│ Quick Options:                                                  │
│ [ROSC] [No ROSC] [Family arrived] [Consultant called]         │
│                                                                 │
│ Custom Note:                                                    │
│ [_________________________________]                             │
│ [_________________________________]                             │
│                                                                 │
│              [Cancel]            [Add]                          │
└─────────────────────────────────────────────────────────────────┘
```

## 10. First-Time User Tutorial Modal

```
┌─────────────────────────────────────────────────────────────────┐
│ WELCOME TO CLINICAL DECISION SUPPORT                       [X] │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│                    [Visual Tutorial]                            │
│                                                                 │
│ Key Features:                                                   │
│ ✓ Real-time protocol guidance                                  │
│ ✓ Automatic event logging                                      │
│ ✓ Evidence-based calculators                                   │
│ ✓ Offline functionality                                        │
│                                                                 │
│ ☐ Don't show again                                            │
│                                                                 │
│         [Skip]        [Next Tip →]                             │
└─────────────────────────────────────────────────────────────────┘
```


### Clear Log Confirmation

```
┌─────────────────────────────────────────────────────────────────┐
│ CLEAR EVENT LOG?                                                │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│ This will permanently delete all logged events                  │
│ for this protocol session. This cannot be undone.              │
│                                                                 │
│ Consider exporting the log first.                               │
│                                                                 │
│              [Cancel]            [Clear Log]                    │
└─────────────────────────────────────────────────────────────────┘
```

### End Protocol Confirmation

```
┌─────────────────────────────────────────────────────────────────┐
│ END PROTOCOL SESSION?                                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│ Active session: Code Blue (05:34)                              │
│                                                                 │
│ Ending will stop all timers and finalize the event log.        │
│ You can export the log after ending.                           │
│                                                                 │
│              [Continue]          [End Session]                  │
└─────────────────────────────────────────────────────────────────┘
```


### Protocol Sync Status

```
┌─────────────────────────────────────────────────────────────────┐
│ SYNC STATUS                                                 [X] │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│ ☑ Core protocols: Up to date                                   │
│ ☑ Calculator formulas: Up to date                              │
│ ⚠ Contact directory: Syncing... (30%)                          │
│ ☐ Study content: Last sync 3 days ago                          │
│                                                                 │
│ [Force Sync All]                   [Close]                     │
└─────────────────────────────────────────────────────────────────┘
```

## 6. Error States & Offline Indicators

### Network Error

```
┌─────────────────────────────────────────────────────────────────┐
│ CONNECTION ERROR                                            [X] │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│ Unable to connect to MEData servers.                            │
│                                                                 │
│ • All core protocols available offline                         │
│ • Chat and Study features unavailable                          │
│ • Contact directory may be outdated                            │
│                                                                 │
│ Check your internet connection and try again.                  │
│                                                                 │
│              [Retry]              [Continue Offline]           │
└─────────────────────────────────────────────────────────────────┘
```

### Offline Mode Banner

```
┌─────────────────────────────────────────────────────────────────┐
│ 📴 OFFLINE MODE - Core protocols available                      │
└─────────────────────────────────────────────────────────────────┘
```

## 7. Contact Directory Modal

### Emergency Contacts

```
┌─────────────────────────────────────────────────────────────────┐
│ EMERGENCY CONTACTS                                          [X] │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│ VIRTUA VOORHEES HOSPITAL                                        │
│                                                                 │
│ 🚨 CODE TEAM                                                   │
│ Code Blue: Dial 99                          [📞 Call]         │
│ Stroke Alert: Dial 99                       [📞 Call]         │
│                                                                 │
│ 🩺 SPECIALIST CONSULTS                                         │
│ Sevaro Teleneurology: 856-247-3098         [📞 Call]         │
│ Transfer Center: 856-886-5111               [📞 Call]         │
│ Interventional Cards: Via Transfer Center   [📞 Call]         │
│                                                                 │
│ 🏥 DEPARTMENTS                                                 │
│ Emergency Department: 856-247-3575          [📞 Call]         │
│ ICU: 856-247-3401                          [📞 Call]         │
│ Pharmacy: 856-247-3200                     [📞 Call]         │
│                                                                 │
│                              [Close]                            │
└─────────────────────────────────────────────────────────────────┘
```

## 8. Calculator History Modal

### Calculation History

```
┌─────────────────────────────────────────────────────────────────┐
│ CALCULATOR HISTORY                                          [X] │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│ Recent Calculations:                                            │
│                                                                 │
│ 📊 NIHSS Score: 18 (severe)                                   │
│    Today 14:25 - Code Stroke                   [Recalculate]   │
│                                                                 │
│ 📊 CHADS-VASc: 4 (high risk)                                  │
│    Today 09:15 - A-fib patient                 [Recalculate]   │
│                                                                 │
│ 📊 Shock Index: 1.2 (moderate)                                │
│    Yesterday 16:30 - Hypotension               [Recalculate]   │
│                                                                 │
│ 📊 qSOFA: 2 (positive)                                        │
│    Yesterday 14:15 - Sepsis workup             [Recalculate]   │
│                                                                 │
│                      [Clear History]           [Export]        │
└─────────────────────────────────────────────────────────────────┘
```

## 9. Study Mode Components

### Question Bank Interface

```
┌─────────────────────────────────────────────────────────────────┐
│ QUESTION BANK                                               [X] │
├─────────────────────────────────────────────────────────────────┤
│ Question 1 of 10 - Cardiology                     Timer: 02:30  │
│                                                                 │
│ A 65-year-old man presents with chest pain. His ECG shows       │
│ ST elevation in leads II, III, and aVF. Which coronary          │
│ artery is most likely occluded?                                 │
│                                                                 │
│ A) Left anterior descending                                     │
│ B) Left circumflex                                              │
│ C) Right coronary artery                                        │
│ D) Left main coronary artery                                    │
│ E) Posterior descending artery                                  │
│                                                                 │
│ [Mark for Review]                                               │
│                                                                 │
│          [Previous]    [Submit]    [Next]                       │
└─────────────────────────────────────────────────────────────────┘
```

### Flashcard Interface

```
┌─────────────────────────────────────────────────────────────────┐
│ FLASHCARDS - Cardiology                                     [X] │
├─────────────────────────────────────────────────────────────────┤
│ Card 15 of 50                                    Due: 12 cards  │
│                                                                 │
│                          FRONT                                  │
│                                                                 │
│             What is the first-line treatment                    │
│             for stable angina?                                  │
│                                                                 │
│                                                                 │
│                                                                 │
│                      [Show Answer]                              │
│                                                                 │
│                                                                 │
│ Difficulty:   [Again]   [Hard]   [Good]   [Easy]              │
└─────────────────────────────────────────────────────────────────┘
```

## 10. Search/Filter Components

### Global Search

```
┌─────────────────────────────────────────────────────────────────┐
│ SEARCH PROTOCOLS                                            [X] │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│ [chest pain_____________________] 🔍                            │
│                                                                 │
│ RESULTS:                                                        │
│                                                                 │
│ 🔴 RRTs > Chest Pain Evaluation                               │
│    Acute coronary syndrome, risk stratification...             │
│                                                                 │
│ 🚨 Emergencies > Code STEMI                                   │
│    ST-elevation myocardial infarction protocol...              │
│                                                                 │
│ 🟡 Calls > Chest Pain (Non-Cardiac)                          │
│    GERD, musculoskeletal, anxiety causes...                   │
│                                                                 │
│ 📊 Calculators > HEART Score                                  │
│    Risk stratification for chest pain...                       │
│                                                                 │
│                              [Close]                            │
└─────────────────────────────────────────────────────────────────┘
```

##  Notification Banners

### Update Available

```
┌─────────────────────────────────────────────────────────────────┐
│ 📱 UPDATE AVAILABLE - Version 2.1.0                      [X]   │
│    New protocols added • Bug fixes • Improved performance       │
│                                      [Later] [Update Now]       │
└─────────────────────────────────────────────────────────────────┘
```

### New Content Available

```
┌─────────────────────────────────────────────────────────────────┐
│ 📚 NEW STUDY CONTENT - 25 Cardiology Questions Added     [X]   │
│    Updated question bank with latest board exam trends          │
│                                      [View] [Dismiss]           │
└─────────────────────────────────────────────────────────────────┘
```



## 🚀 Initial Setup Commands

bash

```bash
# Create the React Native project
npx react-native init ClinicalDecisionApp
cd ClinicalDecisionApp

# Install essential dependencies
npm install @react-navigation/native @react-navigation/bottom-tabs @react-navigation/stack
npm install react-native-screens react-native-safe-area-context
npm install @react-native-async-storage/async-storage
npm install react-native-vector-icons
npm install react-native-svg

# iOS specific setup
cd ios && pod install && cd ..

# Link vector icons for iOS
npx react-native-link react-native-vector-icons
```

## 📁 Project Structure

```
ClinicalDecisionApp/
├── src/
│   ├── data/
│   │   └── protocols.js        # All protocol data
│   ├── components/
│   │   ├── Timer.js           # Timer component
│   │   ├── ProtocolCard.js    # Reusable card
│   │   └── EventLog.js        # Log modal
│   ├── screens/
│   │   ├── EmergenciesScreen.js
│   │   ├── ProtocolScreen.js
│   │   └── ComingSoonScreen.js
│   └── navigation/
│       └── AppNavigator.js
└── App.js
```

## 💾 Data Storage Strategy (Simple Approach)

### 1. Bundle All Protocols with the App

javascript

```javascript
// src/data/protocols.js
export const protocols = {
  emergencies: {
    codeBlue: {
      id: 'code-blue',
      title: 'Code Blue',
      icon: 'heart',
      algorithm: {
        initialNode: 'assessment',
        nodes: {
          assessment: {
            title: 'Initial Assessment',
            content: 'Check pulse and breathing...',
            actions: ['Start CPR', 'Get AED'],
            next: ['cpr', 'shock']
          },
          // ... all other nodes
        }
      },
      cards: [
        // All the card content we created
      ]
    },
    // ... other emergency protocols
  },
  rrt: {
    // RRT protocols
  },
  // ... other categories
};
```

### 2. Simple Local Storage for Logs

javascript

```javascript
// src/utils/storage.js
import AsyncStorage from '@react-native-async-storage/async-storage';

export const saveEventLog = async (protocolId, events) => {
  try {
    const key = `log_${protocolId}_${Date.now()}`;
    await AsyncStorage.setItem(key, JSON.stringify(events));
  } catch (error) {
    console.error('Error saving log:', error);
  }
};

export const getAllLogs = async () => {
  try {
    const keys = await AsyncStorage.getAllKeys();
    const logKeys = keys.filter(key => key.startsWith('log_'));
    const logs = await AsyncStorage.multiGet(logKeys);
    return logs.map(([key, value]) => JSON.parse(value));
  } catch (error) {
    console.error('Error getting logs:', error);
    return [];
  }
};
```

## 🎨 Simple App Icon (Temporary)

javascript

```javascript
// For now, just use a boxicon as placeholder
// In your Info.plist, you can use a generated icon later
// Tools like https://appicon.co/ can generate all sizes from one image
```

## 🏗️ Basic App Implementation

### App.js

javascript

```javascript
import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import AppNavigator from './src/navigation/AppNavigator';

export default function App() {
  return (
    <NavigationContainer>
      <AppNavigator />
    </NavigationContainer>
  );
}
```

### AppNavigator.js

javascript

```javascript
import React from 'react';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import Icon from 'react-native-vector-icons/Ionicons';

import EmergenciesScreen from '../screens/EmergenciesScreen';
import ComingSoonScreen from '../screens/ComingSoonScreen';

const Tab = createBottomTabNavigator();

export default function AppNavigator() {
  return (
    <Tab.Navigator
      screenOptions={({ route }) => ({
        tabBarIcon: ({ focused, color, size }) => {
          let iconName;
          switch (route.name) {
            case 'Emergencies':
              iconName = 'alert-circle';
              break;
            case 'RRT':
              iconName = 'pulse';
              break;
            case 'Calls':
              iconName = 'call';
              break;
            case 'Labs':
              iconName = 'flask';
              break;
            case 'Calc':
              iconName = 'calculator';
              break;
            case 'Chat':
              iconName = 'chatbubbles';
              break;
            case 'Study':
              iconName = 'book';
              break;
          }
          return <Icon name={iconName} size={size} color={color} />;
        },
      })}
    >
      <Tab.Screen name="Emergencies" component={EmergenciesScreen} />
      <Tab.Screen name="RRT" component={ComingSoonScreen} />
      <Tab.Screen name="Calls" component={ComingSoonScreen} />
      <Tab.Screen name="Labs" component={ComingSoonScreen} />
      <Tab.Screen name="Calc" component={ComingSoonScreen} />
      <Tab.Screen name="Chat" component={ComingSoonScreen} />
      <Tab.Screen name="Study" component={ComingSoonScreen} />
    </Tab.Navigator>
  );
}
```

### ComingSoonScreen.js

javascript

```javascript
import React from 'react';
import { View, Text, StyleSheet } from 'react-native';

export default function ComingSoonScreen({ route }) {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>{route.name}</Text>
      <Text style={styles.subtitle}>Coming Soon!</Text>
      <Text style={styles.description}>
        This feature is under development and will be available in a future update.
      </Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 20,
  },
  title: {
    fontSize: 32,
    fontWeight: 'bold',
    marginBottom: 10,
  },
  subtitle: {
    fontSize: 24,
    color: '#666',
    marginBottom: 20,
  },
  description: {
    fontSize: 16,
    textAlign: 'center',
    color: '#888',
  },
});
```

## 🧠 For Meditron 7B Integration Later

javascript

```javascript
// src/services/aiService.js
// Placeholder for future Meditron integration
export const getMeditronResponse = async (query) => {
  // For now, return a placeholder
  return {
    response: "AI assistance coming soon",
    confidence: 0.0
  };
  
  // Future implementation:
  // const response = await fetch('YOUR_MEDITRON_ENDPOINT', {
  //   method: 'POST',
  //   headers: { 'Content-Type': 'application/json' },
  //   body: JSON.stringify({ query })
  // });
  // return response.json();
};
```

## 📱 Offline-First Approach

Everything works offline by default because:

1. **All protocols are bundled** in the app (no network needed)
2. **Event logs save locally** using AsyncStorage
3. **No external dependencies** for core functionality
4. **AI/Chat features** show "Coming Soon" when tapped

