# Code Stroke – Acute Ischemic Stroke with Virtua Voorhees Addenda
## TNK-Optimized Protocol

**Primary Guideline:** American Heart Association/American Stroke Association (AHA/ASA) 2019 Guidelines for Early Management of Acute Ischemic Stroke
**Official Source:** https://www.ahajournals.org/doi/10.1161/STR.0000000000000211
**TNK FDA Approval:** March 2025 - First new stroke medication approved in nearly 30 years

## ENHANCED MERMAID FLOWCHART ALGORITHM

~~~mermaid
graph TD
    A["Code Stroke Activated<br/>NIHSS Assessment + Teleneurology"] --> B["CT Head STAT<br/>&lt;25 minutes"]
    
    B --> C{"Hemorrhage<br/>on CT?"}
    
    C -->|YES| D["Hemorrhagic Stroke Protocol<br/>Neurosurgery + BP Control + ICU"]
    C -->|NO| E{"LVO Screening<br/>NIHSS ≥6?"}
    
    E -->|YES| F["CTA Brain/Neck<br/>Thrombectomy Planning"]
    E -->|NO| G{"TNK Eligibility<br/>Assessment"}
    
    G -->|ELIGIBLE| H["TNK 0.25mg/kg bolus<br/>5 seconds"]
    G -->|NOT ELIGIBLE| I["Medical Management<br/>ASA + Standard Care"]
    
    F --> J["Stroke Unit Admission<br/>Post-Intervention Care"]
    H --> K["Post-TNK Monitoring<br/>Neuro Checks q15min"]
    I --> J
    
    K --> L{"EVT Candidate<br/>CTA Results?"}
    
    L -->|YES| M["Transfer for EVT<br/>6-24 hour window"]
    L -->|NO| J
    
    M --> J
    J --> N["Disposition Planning<br/>Rehab Assessment"]
    D --> O["ICU Management<br/>ICP Monitoring"]
    
    style A fill:#ffcccc
    style H fill:#fff2cc
    style J fill:#ccffcc
    style D fill:#ffaaaa
    style K fill:#e6ccff
~~~

## STREAMLINED DYNAMIC CARD SYSTEM - TNK OPTIMIZED

### Card 0 – Stroke Alert & NIHSS Assessment (Node A → B)
┌─────────────────────────────────────────┐
│ 🚨 CODE STROKE ACTIVATED                │
├─────────────────────────────────────────┤
│ ⏱️ Door-to-needle timer: <60 minutes    │
│ 🎯 TNK advantage: 5-second bolus        │
│                                         │
│ 📊 NIHSS Assessment required:           │
│ • Complete 11-item scale promptly       │
│ • Score 0-42 (higher = more severe)    │
│ • Mild (1-4), Moderate (5-15), Severe (16+)│
│                                         │
│ 📞 Sevaro Teleneurology: 856-247-3098   │
│ Response time: <45 seconds              │
│                                         │
│ ❓ NIHSS completed?                     │
│                                         │
│ 🔘 YES → CT imaging                     │
│ 🔘 NO → Complete assessment            │
│                                         │
│ [Next: Based on Selection ▶]            │
└─────────────────────────────────────────┘

### Card 1A – CT Imaging (Node C → D)
┌─────────────────────────────────────────┐
│ 🧠 CT HEAD - STAT IMAGING               │
├─────────────────────────────────────────┤
│ 🎯 Target: <25 minutes from arrival     │
│                                         │
│ 🔍 Evaluate for:                        │
│ • Intracranial hemorrhage (absolute CI) │
│ • Large hypodensity (>1/3 MCA territory)│
│ • Mass effect or midline shift          │
│ • Early signs of infarction             │
│                                         │
│ ❓ Hemorrhage on CT?                     │
│                                         │
│ 🔘 YES → Hemorrhagic stroke protocol    │
│ 🔘 NO → LVO screening                   │
│                                         │
│ [◀ Previous] [Next: Based on Selection ▶]│
└─────────────────────────────────────────┘

### Card 1B – Hemorrhagic Stroke (Node D - Final)
┌─────────────────────────────────────────┐
│ 🩸 HEMORRHAGIC STROKE MANAGEMENT        │
├─────────────────────────────────────────┤
│ 🚨 Immediate actions:                   │
│ • STAT neurosurgery consult            │
│ • BP management <160/90 (ICH)          │
│ • Reversal agents if on anticoagulants │
│ • ICP monitoring consideration          │
│ • AVOID all thrombolytics              │
│                                         │
│ 🏥 ICU management required              │
│                                         │
│ ✅ HEMORRHAGIC PROTOCOL ACTIVE         │
│                                         │
│ [◀ Previous: CT Imaging]               │
└─────────────────────────────────────────┘

### Card 2A – LVO Screening (Node E)
┌─────────────────────────────────────────┐
│ 🔍 LARGE VESSEL OCCLUSION SCREENING     │
├─────────────────────────────────────────┤
│ 🎯 High-risk indicators:                │
│ • NIHSS ≥6                             │
│ • Gaze deviation (NIHSS item 2 ≥1)     │
│ • Dense hemiparesis (NIHSS 5-6 ≥2)     │
│ • Aphasia (NIHSS item 9 ≥1)            │
│ • Neglect/extinction (NIHSS item 11 ≥1)│
│                                         │
│ 💡 TNK particularly effective for LVO   │
│                                         │
│ ❓ NIHSS ≥6 or LVO suspected?           │
│                                         │
│ 🔘 YES → Order CTA brain/neck          │
│ 🔘 NO → TNK eligibility assessment     │
│                                         │
│ [◀ Previous] [Next: Based on Selection ▶]│
└─────────────────────────────────────────┘

### Card 2B – TNK Eligibility (Node G)
┌─────────────────────────────────────────┐
│ 💉 TENECTEPLASE ELIGIBILITY             │
├─────────────────────────────────────────┤
│ ✅ Inclusion criteria:                  │
│ • Onset <4.5 hours (last known well)   │
│ • Age ≥18 years                        │
│ • Measurable neurologic deficit        │
│ • NIHSS potentially disabling (≥2)     │
│                                         │
│ ❌ Key exclusions:                      │
│ • Prior ICH, recent stroke <3mo        │
│ • BP >185/110 refractory to treatment  │
│ • Active bleeding, recent major surgery │
│ • INR >1.7, platelets <100,000        │
│ • Recent anticoagulation               │
│                                         │
│ ❓ TNK eligible?                        │
│                                         │
│ 🔘 YES → Administer TNK                │
│ 🔘 NO → Medical management             │
│                                         │
│ [◀ Previous] [Next: Based on Selection ▶]│
└─────────────────────────────────────────┘

### Card 3A – CTA & Thrombectomy Planning (Node F → Stroke Unit)
┌─────────────────────────────────────────┐
│ 🏥 CTA & MECHANICAL THROMBECTOMY        │
├─────────────────────────────────────────┤
│ 📸 CTA findings to evaluate:            │
│ • Large vessel occlusion confirmed     │
│ • ICA, M1/M2 MCA, basilar artery       │
│ • Collateral circulation assessment    │
│                                         │
│ 🎯 EVT + TNK bridging criteria:         │
│ • Pre-stroke mRS 0-2                   │
│ • ASPECTS score ≥6                     │
│ • Within 6-24 hour window              │
│                                         │
│ 💡 TNK preferred for bridging therapy   │
│                                         │
│ [Next: Stroke unit admission ▶]        │
│                                         │
│ [◀ Previous: LVO Screening]            │
└─────────────────────────────────────────┘

### Card 3B – TNK Administration (Node H → Post-TNK)
┌─────────────────────────────────────────┐
│ 💉 TENECTEPLASE ADMINISTRATION          │
├─────────────────────────────────────────┤
│ 💊 TNK Protocol (FDA-approved 2025):    │
│ • Dose: 0.25 mg/kg IV bolus (max 25mg) │
│ • Single 5-second bolus injection      │
│ • Dedicated IV line, flush after       │
│ • No infusion required (vs 60min alteplase)│
│                                         │
│ 🚫 Hold for 24 hours:                  │
│ • Anticoagulants, antiplatelets        │
│ • Avoid arterial punctures             │
│ • No NG tubes, foley catheters         │
│                                         │
│ ⚡ Advantages over alteplase:            │
│ • Faster administration                │
│ • No infusion delays                   │
│ • Better for transport/transfers        │
│                                         │
│ [Next: Post-TNK monitoring ▶]          │
│                                         │
│ [◀ Previous: TNK Eligibility]          │
└─────────────────────────────────────────┘

### Card 3C – Medical Management (Node I → Stroke Unit)
┌─────────────────────────────────────────┐
│ 💊 MEDICAL MANAGEMENT                   │
├─────────────────────────────────────────┤
│ 🎯 Standard stroke care:                │
│ • ASA 325mg (after 24h if TNK given)   │
│ • BP management <220/120 (no thrombolytics)│
│ • Glucose 140-180 mg/dL                │
│ • Temperature <38°C                     │
│ • DVT prophylaxis                      │
│                                         │
│ 📊 Monitor for:                         │
│ • Neurological deterioration           │
│ • Swallowing dysfunction               │
│ • Complications                        │
│                                         │
│ [Next: Stroke unit admission ▶]        │
│                                         │
│ [◀ Previous: TNK Eligibility]          │
└─────────────────────────────────────────┘

### Card 4A – Post-TNK Monitoring (Node K)
┌─────────────────────────────────────────┐
│ 👁️ POST-TENECTEPLASE MONITORING         │
├─────────────────────────────────────────┤
│ ⏱️ Neurologic checks (AHA protocol):    │
│ • Q15min × 2 hours                     │
│ • Q30min × 6 hours                     │
│ • Q1h × 16 hours                       │
│                                         │
│ 🚨 Alert criteria (same as alteplase):  │
│ • NIHSS increase ≥4 points             │
│ • New severe headache, N/V             │
│ • BP >180/105 refractory               │
│ • Signs of systemic bleeding           │
│                                         │
│ 💡 TNK benefits:                        │
│ • Lower bleeding risk vs alteplase      │
│ • No infusion to monitor/maintain      │
│                                         │
│ ❓ Neurologic deterioration?            │
│                                         │
│ 🔘 YES → STAT CT, hold antithrombotics │
│ 🔘 NO → Continue standard monitoring   │
│                                         │
│ [◀ Previous] [Next: Based on Selection ▶]│
└─────────────────────────────────────────┘

### Card 5 – Stroke Unit Admission (Node J)
┌─────────────────────────────────────────┐
│ 🏥 STROKE UNIT CARE                     │
├─────────────────────────────────────────┤
│ 📋 Acute management:                    │
│ • Dedicated stroke unit admission      │
│ • Swallow screening before PO          │
│ • Early mobilization (24-48h)          │
│ • Cardiac monitoring × 24h minimum     │
│                                         │
│ 💊 Secondary prevention (after 24h):    │
│ • Antiplatelet: ASA 81mg daily         │
│ • High-intensity statin: Atorvastatin 80mg│
│ • BP optimization per guidelines       │
│ • Diabetes management if present       │
│                                         │
│ 🔄 Rehabilitation assessments:          │
│ • PT evaluation and mobility           │
│ • OT for activities of daily living    │
│ • Speech therapy for dysphagia/aphasia │
│                                         │
│ ❓ EVT candidate?                       │
│                                         │
│ 🔘 YES → Transfer for thrombectomy     │
│ 🔘 NO → Continue stroke unit care      │
│                                         │
│ [◀ Previous] [Next: Based on Selection ▶]│
└─────────────────────────────────────────┘

### Card 6A – Transfer for EVT (Node M → Final)
┌─────────────────────────────────────────┐
│ 🚁 TRANSFER FOR ENDOVASCULAR THERAPY   │
├─────────────────────────────────────────┐
│ 🎯 EVT criteria confirmed:              │
│ • Large vessel occlusion on CTA        │
│ • Within treatment window (6-24h)      │
│ • Good functional status (mRS 0-2)     │
│ • ASPECTS ≥6                           │
│                                         │
│ 🚀 Expedited transfer:                  │
│ • Direct communication with EVT center │
│ • Continue medical management          │
│ • Monitor during transport             │
│                                         │
│ ✅ EVT TRANSFER PROTOCOL ACTIVE        │
│                                         │
│ [◀ Previous: Stroke Unit Care]         │
└─────────────────────────────────────────┘

### Card 6B – Disposition Planning (Node N - Final)
┌─────────────────────────────────────────┐
│ 📅 STROKE DISCHARGE PLANNING            │
├─────────────────────────────────────────┤
│ 🎯 Discharge criteria:                  │
│ • Neurologically stable ≥24 hours      │
│ • Safe swallow or alternative nutrition │
│ • Ambulation or appropriate equipment   │
│ • Secondary prevention medications      │
│                                         │
│ 🏠 Disposition options:                 │
│ • Home with outpatient therapy         │
│ • Home with home health services       │
│ • Acute rehabilitation facility        │
│ • Skilled nursing facility             │
│                                         │
│ 📋 Follow-up appointments:              │
│ • Neurology: 1-2 weeks                 │
│ • Primary care: 1 week                 │
│ • Rehabilitation services as needed    │
│                                         │
│ ✅ STROKE PROTOCOL
