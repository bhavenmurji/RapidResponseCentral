# Enhanced Acute Decompensated Heart Failure – RRT Protocol with HFpEF Integration

**Primary Guidelines:** 
- 2024 AHA/ACC/HFSA Heart Failure Guidelines with HFpEF Focus
- 2024 ESC Heart Failure Guidelines - HFpEF Update
- UpToDate Clinical Decision Support - HFpEF Management 2025

**Official Sources:** 
- https://www.sciencedirect.com/science/article/pii/S1443950625004597
- UpToDate HFpEF Treatment Guidelines 2025

## ENHANCED MERMAID FLOWCHART WITH HFpEF INTEGRATION

~~~mermaid
graph TD
    A["🫀 Acute HF Recognition<br/>Volume Overload + Symptoms"] --> B["📊 LVEF Assessment<br/>Echo/Prior Records"]
    
    B --> C{"💗 Ejection<br/>Fraction?"}
    
    C -->|"≤40%"| D["💔 HFrEF Protocol<br/>Standard GDMT"]
    C -->|"41-49%"| E["🔄 HFmrEF Protocol<br/>Treat as HFrEF"]
    C -->|"≥50%"| F["💝 HFpEF Protocol<br/>Specialized Management"]
    
    D --> G["🚨 ABC Assessment<br/>Hemodynamic Profiling"]
    E --> G
    F --> H["🔍 HFpEF Etiology<br/>Contributing Factors"]
    
    H --> I{"🎯 Primary<br/>HFpEF Cause?"}
    
    I -->|HYPERTENSIVE| J["🩺 HTN-Mediated<br/>BP Control Priority"]
    I -->|ISCHEMIC| K["🫀 CAD-Related<br/>Revascularization Consider"]
    I -->|RESTRICTIVE| L["🧬 Restrictive CM<br/>Specialized Workup"]
    I -->|HYPERTROPHIC| M["💪 HCM Management<br/>Gradient Assessment"]
    I -->|INFILTRATIVE| N["🔬 Infiltrative Disease<br/>Amyloid/Iron Studies"]
    I -->|HIGH-OUTPUT| O["⚡ High-Output HF<br/>Underlying Cause"]
    
    G --> P{"🌡️ Clinical<br/>Profile?"}
    
    P -->|"WARM & WET"| Q["💧 Standard Diuresis<br/>Volume Management"]
    P -->|"COLD & WET"| R["❄️ Inotropes + Gentle Diuresis<br/>Perfusion Priority"]
    P -->|"COLD & DRY"| S["🔍 Rule Out Other Causes<br/>Cautious Assessment"]
    P -->|"WARM & DRY"| T["✅ GDMT Optimization<br/>Prevention Focus"]
    
    J --> U["💊 Antihypertensive<br/>Optimization"]
    K --> V["🔄 Ischemia Management<br/>+ Volume Control"]
    L --> W["📋 Genetics/Biopsy<br/>Specialist Referral"]
    M --> X["⚖️ Obstruction Assessment<br/>Septal Intervention"]
    N --> Y["🧪 Biomarker Studies<br/>Targeted Therapy"]
    O --> Z["🔄 Treat Underlying<br/>High-Output State"]
    
    Q --> AA["📊 Diuretic Response<br/>Assessment"]
    R --> BB["💪 Perfusion Monitoring<br/>Inotrope Titration"]
    S --> CC["🔍 Differential Diagnosis<br/>Targeted Workup"]
    T --> DD["📈 NYHA Class<br/>Reassessment"]
    
    U --> EE["🎯 BP Target<br/><130/80 mmHg"]
    V --> EE
    W --> FF["🏥 Advanced HF Center<br/>Specialized Care"]
    X --> GG["🔧 Procedural Planning<br/>Septal Reduction"]
    Y --> HH["💉 Disease-Specific<br/>Treatment"]
    Z --> II["⚡ High-Output<br/>Resolution"]
    
    AA --> JJ{"💧 Volume<br/>Response?"}
    BB --> KK{"💪 Perfusion<br/>Improved?"}
    CC --> LL["🎯 Cause-Specific<br/>Management"]
    DD --> MM["📋 Symptom-Based<br/>Therapy"]
    
    JJ -->|YES| NN["✅ Continue Current<br/>Monitor Progress"]
    JJ -->|NO| OO["⬆️ Escalate Diuretics<br/>Combination Therapy"]
    KK -->|YES| NN
    KK -->|NO| PP["🚨 Advanced Support<br/>MCS Consideration"]
    
    LL --> MM
    MM --> QQ{"📈 NYHA Class<br/>II-III Symptoms?"}
    
    QQ -->|YES| RR["💊 HFpEF-Specific<br/>SGLT2i + MRA"]
    QQ -->|NO| SS["📊 Monitoring<br/>+ Prevention"]
    
    EE --> RR
    FF --> TT["🔬 Advanced Diagnostics<br/>+ Targeted Therapy"]
    GG --> TT
    HH --> TT
    II --> RR
    
    NN --> UU["📋 GDMT Optimization<br/>Based on EF"]
    OO --> VV["🏥 Intensive Management<br/>Refractory Volume"]
    PP --> WW["⚙️ MCS Evaluation<br/>Advanced Options"]
    
    RR --> XX["📊 HFpEF Response<br/>Assessment"]
    SS --> YY["🏠 Outpatient<br/>Management"]
    
    UU --> ZZ{"💗 EF-Based<br/>Therapy?"}
    
    ZZ -->|"HFrEF"| AAA["💊 4-Pillar Therapy<br/>ACE-I/ARB + BB + MRA + SGLT2i"]
    ZZ -->|"HFpEF"| XX
    
    XX --> BBB{"🎯 HFpEF Symptoms<br/>Controlled?"}
    
    BBB -->|YES| CCC["📈 Monitoring<br/>+ Optimization"]
    BBB -->|NO| DDD["⬆️ Additional Therapy<br/>GLP-1 + Advanced Options"]
    
    AAA --> EEE["📊 GDMT Monitoring<br/>+ Titration"]
    VV --> FFF["🏥 Advanced Diuretic<br/>Strategies"]
    WW --> GGG["⚙️ Bridge Decisions<br/>Recovery/Transplant/LVAD"]
    
    CCC --> HHH["🏠 Discharge Planning<br/>HFpEF-Specific Education"]
    DDD --> III["🔄 Multimodal Approach<br/>Specialist Coordination"]
    EEE --> JJJ["🏠 HFrEF Discharge<br/>Close Follow-up"]
    FFF --> KKK["📊 Intensive Monitoring<br/>Volume Management"]
    GGG --> LLL["🏥 Advanced HF Center<br/>MCS Management"]
    
    HHH --> MMM["✅ HFpEF Protocol<br/>Complete"]
    III --> MMM
    JJJ --> NNN["✅ HFrEF Protocol<br/>Complete"]
    YY --> MMM
    KKK --> OOO["📊 Reassess<br/>+ Transition"]
    LLL --> PPP["⚙️ Long-term<br/>MCS Management"]
    
    OOO --> MMM
    PPP --> QQQ["🏥 Final Disposition<br/>Based on Support Level"]
    
    style A fill:#ffcccc
    style F fill:#fff2cc
    style H fill:#ffe6cc
    style RR fill:#e8f5e8
    style XX fill:#f0f8ff
    style MMM fill:#ccffee
    style NNN fill:#ccffee
~~~

## COMPREHENSIVE HFpEF-INTEGRATED CARD SYSTEM

### Card 0 – Enhanced HF Recognition with EF Assessment (Node A → B)
┌─────────────────────────────────────────┐
│ 🫀 ACUTE HEART FAILURE WITH EF FOCUS    │
├─────────────────────────────────────────┤
│ 📊 **Immediate LVEF determination**:    │
│ •  Recent echo (within 12 months)       │
│ •  Point-of-care echo if available      │
│ •  Prior cardiac imaging                │
│ •  Clinical records review              │
│                                         │
│ 🎯 **EF-based initial classification**: │
│ •  **HFrEF (≤40%)**: Standard protocol  │
│ •  **HFmrEF (41-49%)**: Treat as HFrEF  │
│ •  **HFpEF (≥50%)**: Specialized approach│
│                                         │
│ 📋 **Recognition criteria (2025)**:     │
│ •  Acute/worsening dyspnea              │
│ •  Signs of volume overload             │
│ •  Known HF with decompensation         │
│ •  Chest pain with pulmonary edema      │
│                                         │
│ 🚨 **ABC priorities remain same**:      │
│ •  Airway: Assess for impending failure │
│ •  Breathing: O2 to maintain SpO2 >92%  │
│ •  Circulation: IV access, BP monitoring│
│                                         │
│ [Next: EF-specific pathway ▶]          │
└─────────────────────────────────────────┘

### Card 1A – Comprehensive HFpEF Etiology Assessment (Node H → I)
┌─────────────────────────────────────────┐
│ 🔍 HFpEF CONTRIBUTING FACTORS ANALYSIS  │
├─────────────────────────────────────────┤
│ **🩺 Primary Contributing Factors**: │
│ •  **Hypertension** (most common)       │
│ •  **Aging** (physiologic changes)      │
│ •  **Coronary heart disease**           │
│ •  **Diabetes mellitus**                │
│ •  **Sleep-disordered breathing**        │
│ •  **Chronic kidney disease**           │
│ •  **Obesity** (BMI ≥30)                │
│                                         │
│ **🧬 Cardiomyopathies with Preserved EF**:│
│ **Restrictive Cardiomyopathy:**         │
│ •  **Familial**: Sarcomeric mutations, TTR amyloidosis│
│ •  **Acquired**: AL amyloid, radiation, drugs│
│                                         │
│ **Hypertrophic Cardiomyopathy:**        │
│ •  **Familial**: Sarcomere gene mutations│
│ •  **Metabolic**: Fabry disease, glycogen storage│
│                                         │
│ **🫀 Structural Heart Disease**:        │
│ •  **Valvular stenosis/regurgitation**   │
│ •  **Pericardial disease** (constrictive)│
│ •  **High-output states**               │
│                                         │
│ [Next: Cause-specific management ▶]    │
└─────────────────────────────────────────┘

### Card 1B – Advanced HFpEF Differential Diagnosis
┌─────────────────────────────────────────┐
│ 🔬 COMPREHENSIVE HFpEF DIFFERENTIAL      │
├─────────────────────────────────────────┤
│ **🧪 Infiltrative Diseases**:           │
│ •  **Cardiac amyloidosis**: AL vs ATTR   │
│ •  **Iron overload**: Hereditary hemochromatosis│
│ •  **Fabry disease**: α-galactosidase deficiency│
│ •  **Glycogen storage disease**          │
│                                         │
│ **🔄 High-Output Heart Failure**:       │
│ •  **Hyperthyroidism**                  │
│ •  **Arteriovenous malformations**       │
│ •  **Severe anemia**                    │
│ •  **Pregnancy**                        │
│ •  **Paget's disease**                  │
│                                         │
│ **🫁 Right Heart Predominant**:         │
│ •  **Pulmonary hypertension**           │
│ •  **ARVC** (arrhythmogenic RV cardiomyopathy)│
│ •  **RV infarction**                    │
│                                         │
│ **⚙️ Obstructive Lesions**:             │
│ •  **Atrial myxoma**                    │
│ •  **Pulmonary vein stenosis**          │
│ •  **Supravalvular/subvalvular stenosis**│
│                                         │
│ **🔄 Pericardial Disease**:             │
│ •  **Cardiac tamponade**                │
│ •  **Constrictive pericarditis**        │
│ •  **Effusive-constrictive disease**    │
│                                         │
│ [Next: Targeted diagnostic workup ▶]   │
└─────────────────────────────────────────┘

### Card 2A – NYHA Classification Integration (Node DD → MM)
┌─────────────────────────────────────────┐
│ 📈 NYHA FUNCTIONAL CLASS ASSESSMENT     │
├─────────────────────────────────────────┤
│ **📊 NYHA Class I (Asymptomatic)**:     │
│ •  No limitations of physical activity   │
│ •  ≥7 metabolic equivalents capacity     │
│ •  **Management**: Prevention focus      │
│                                         │
│ **📊 NYHA Class II (Mild Symptoms)**:   │
│ •  Slight limitation of ordinary activity│
│ •  5-7 metabolic equivalents capacity    │
│ •  **Management**: Initiate HFpEF therapy│
│                                         │
│ **📊 NYHA Class III (Moderate)**:       │
│ •  Marked limitation of activity         │
│ •  2-5 metabolic equivalents capacity    │
│ •  **Management**: Optimize all therapies│
│                                         │
│ **📊 NYHA Class IV (Severe)**:          │
│ •  Unable to carry on physical activity  │
│ •  <2 metabolic equivalents capacity     │
│ •  **Management**: Advanced HF referral  │
│                                         │
│ **🎯 Metabolic Equivalent Examples**:   │
│ •  **7 METs**: Carry 24lb up 8 steps    │
│ •  **5 METs**: Sexual intercourse, gardening│
│ •  **2 METs**: Shower, make bed, dress   │
│                                         │
│ [Next: Symptom-based therapy ▶]        │
└─────────────────────────────────────────┘

### Card 2B – HFpEF-Specific Pharmacotherapy (Node RR → XX)
┌─────────────────────────────────────────┐
│ 💊 HFpEF-SPECIFIC MEDICATION PROTOCOL   │
├─────────────────────────────────────────┤
│ **🎯 SGLT2 Inhibitors (First-line)**[24][28]:│
│ •  **Dapagliflozin**: 10mg daily (fixed dose)│
│ •  **Empagliflozin**: 10mg daily (fixed dose)│
│ •  **Benefits**: ↓HF hospitalization, improved QOL│
│ •  **Evidence**: HR 0.74 for HF events[28] │
│ •  **Monitoring**: eGFR, volume status   │
│                                         │
│ **🧂 Mineralocorticoid Receptor Antagonists**[25]:│
│ •  **Spironolactone**: 12.5-25mg → 25-50mg daily│
│ •  **Eplerenone**: 25mg → 50mg daily     │
│ •  **Finerenone**: 20mg → 40mg daily     │
│ •  **Prerequisites**: K+ ≤4.7, eGFR ≥30  │
│ •  **Titration**: Double dose q4 weeks   │
│                                         │
│ **❓ Limited Evidence Therapies**[27]:   │
│ •  **Sacubitril/valsartan**: Consider if EF 50-60%│
│ •  **ACE-I/ARBs**: For HTN/DM indications│
│ •  **Beta-blockers**: For CAD/HTN/AF    │
│                                         │
│ **🚫 Ineffective in HFpEF**[22]**:      │
│ •  Nitrates (may ↓activity tolerance)    │
│ •  Phosphodiesterase-5 inhibitors       │
│ •  Digoxin (no benefit demonstrated)    │
│                                         │
│ [Next: Response assessment ▶]          │
└─────────────────────────────────────────┘

### Card 3A – Enhanced Loop Diuretic Dosing (Based on UpToDate Guidelines)
┌─────────────────────────────────────────┐
│ 💧 EVIDENCE-BASED LOOP DIURETIC DOSING  │
├─────────────────────────────────────────┤
│ **📊 Heart Failure Dosing (mg)**:       │
│                                         │
│ | Drug | Starting | Max Effective | Max Daily |│
│ |------|----------|---------------|-----------|│
│ |Furosemide|20 BID|80 TID|600|     │
│ |Bumetanide|0.5 BID|3 TID|10|      │
│ |Torsemide|10 daily|50 BID|200|    │
│                                         │
│ **🎯 Dosing Principles**:               │
│ •  **2.5× home dose** for IV conversion  │
│ •  **Diuretic-naive**: Start with lowest dose│
│ •  **Max effective dose**: Higher doses unlikely to improve diuresis│
│ •  **Bioavailability**: Torsemide >80%, Furosemide ~50%│
│                                         │
│ **⚠️ Special Populations**:             │
│ •  **CKD**: Higher starting doses needed │
│ •  **Cirrhosis**: Lower max daily doses  │
│ •  **Nephrotic syndrome**: Standard dosing│
│ •  **AKI**: Higher starting doses        │
│                                         │
│ [Next: Diuretic response monitoring ▶] │
└─────────────────────────────────────────┘

### Card 3B – HFrEF Four-Pillar Therapy (Node AAA → EEE)
┌─────────────────────────────────────────┐
│ 💊 HFrEF FOUR-PILLAR OPTIMIZATION       │
├─────────────────────────────────────────┤
│ **🏛️ Pillar 1: RAS Inhibition**:        │
│ **Preferred**: Sacubitril/valsartan     │
│ •  **Initial**: 24/26-49/51mg BID        │
│ •  **Target**: 97/103mg BID              │
│ •  **Alternative**: Lisinopril 2.5→40mg  │
│                                         │
│ **🏛️ Pillar 2: Beta-Blockers**:         │
│ **Preferred**: Carvedilol              │
│ •  **Initial**: 3.125mg BID             │
│ •  **Target**: 25mg BID (<85kg), 50mg BID (>85kg)│
│ •  **Alternative**: Metoprolol succinate │
│                                         │
│ **🏛️ Pillar 3: MRA**:                   │
│ **Preferred**: Spironolactone          │
│ •  **Initial**: 12.5-25mg daily         │
│ •  **Target**: 25-50mg daily            │
│ •  **Monitor**: K+, Cr q1-2 weeks initially│
│                                         │
│ **🏛️ Pillar 4: SGLT2 Inhibitors**:      │
│ **Preferred**: Dapagliflozin 10mg daily │
│ •  **Independent of DM status**          │
│ •  **Can start in hospital**            │
│ •  **Monitor**: Volume status, eGFR     │
│                                         │
│ [Next: GDMT monitoring ▶]              │
└─────────────────────────────────────────┘

### Card 4A – Secondary HFrEF Therapies
┌─────────────────────────────────────────┐
│ 💊 SECONDARY HFrEF PHARMACOTHERAPY      │
├─────────────────────────────────────────┤
│ **🔄 Isosorbide Dinitrate + Hydralazine**:│
│ •  **Initial**: 20mg/25mg TID            │
│ •  **Target**: 40mg/100mg TID            │
│ •  **Use**: Alternative to ARNI, additional therapy│
│ •  **Special**: Preferred in African Americans│
│                                         │
│ **⚡ Ivabradine**:                       │
│ •  **Initial**: 2.5-5mg BID             │
│ •  **Target**: 7.5mg BID                │
│ •  **Use**: HR ≥70 on max beta-blocker   │
│ •  **Requirement**: Sinus rhythm only    │
│                                         │
│ **🔬 Vericiguat** (Novel):              │
│ •  **Initial**: 2.5mg daily             │
│ •  **Target**: 10mg daily               │
│ •  **Use**: Persistent symptoms, rarely used│
│ •  **Mechanism**: sGC stimulator        │
│                                         │
│ **💊 Digoxin** (Limited Use):           │
│ •  **Initial**: 0.0625-0.25mg daily     │
│ •  **Target**: Serum level 0.5-0.8 ng/mL │
│ •  **Use**: Symptomatic improvement only │
│ •  **No mortality benefit**             │
│                                         │
│ [Next: Advanced therapy consideration ▶]│
└─────────────────────────────────────────┘

### Card 5A – Advanced HFpEF Management (Node DDD → III)
┌─────────────────────────────────────────┐
│ 🔄 ADVANCED HFpEF MULTIMODAL APPROACH   │
├─────────────────────────────────────────┤
│ **🏋️ GLP-1 Receptor Agonists** (Obesity BMI ≥30):│
│ •  **Semaglutide**: 0.25→2.4mg weekly SC │
│ •  **Tirzepatide**: 2.5→15mg weekly SC   │
│ •  **Benefits**: ↓weight, ↓HF hospitalization│
│ •  **Monitor**: GI side effects, hypoglycemia│
│                                         │
│ **📊 Device-Based Therapies**:          │
│ •  **CardioMEMS**: PA pressure monitoring │
│ •  **Interatrial shunt**: Limited evidence│
│ •  **CRT**: No benefit in HFpEF          │
│                                         │
│ **🔬 Specialized Interventions**:       │
│ •  **Cardiac rehabilitation**: Exercise training│
│ •  **Sleep apnea treatment**: CPAP/BiPAP │
│ •  **Dietary sodium restriction**: <2g/day│
│                                         │
│ **🎯 Comorbidity Management**:          │
│ •  **Optimal BP control**: <130/80 mmHg  │
│ •  **Diabetes management**: HbA1c <7%    │
│ •  **OSA screening**: High prevalence    │
│ •  **AF management**: Rate vs rhythm control│
│                                         │
│ [Next: Specialist coordination ▶]      │
└─────────────────────────────────────────┘

### Card 5B – Enhanced Discharge Planning (HFpEF-Specific)
┌─────────────────────────────────────────┐
│ 🏠 HFpEF-SPECIFIC DISCHARGE PLANNING    │
├─────────────────────────────────────────┤
│ ✅ **HFpEF Discharge Readiness**:       │
│ •  Volume status optimized              │
│ •  Comorbidities addressed (HTN, DM)    │
│ •  SGLT2i ± MRA initiated if appropriate │
│ •  Patient education completed          │
│                                         │
│ 📚 **HFpEF Patient Education**:         │
│ •  **Different from HFrEF**: Emphasize comorbidity management│
│ •  **Weight monitoring**: Daily weights  │
│ •  **Exercise importance**: Cardiac rehab referral│
│ •  **Symptom recognition**: Dyspnea patterns│
│                                         │
│ 💊 **HFpEF Medication Focus**:          │
│ •  **SGLT2i adherence**: Independent of diabetes│
│ •  **BP medications**: Optimal control   │
│ •  **Diuretic PRN**: For volume overload │
│ •  **Avoid ineffective drugs**: Nitrates, PDE5i│
│                                         │
│ 📞 **HFpEF Follow-up Strategy**:        │
│ •  **HF clinic**: 1-2 weeks             │
│ •  **Cardiology**: If complex           │
│ •  **Endocrinology**: If DM present     │
│ •  **Sleep medicine**: If OSA suspected  │
│                                         │
│ [Next: Long-term HFpEF management ▶]   │
└─────────────────────────────────────────┘

### Card 6 – Integrated Quality Metrics (Final)
┌─────────────────────────────────────────┐
│ 📊 COMPREHENSIVE HF QUALITY MANAGEMENT  │
├─────────────────────────────────────────┤
│ **🎯 EF-Specific Process Metrics**:     │
│ •  **LVEF documentation**: >95% of cases │
│ •  **HFrEF 4-pillar initiation**: >80%   │
│ •  **HFpEF SGLT2i consideration**: >90%  │
│ •  **Appropriate medication selection**: >95%│
│                                         │
│ **📈 HFpEF-Specific Outcomes**:         │
│ •  **30-day readmission**: <15%         │
│ •  **Comorbidity optimization**: HTN <130/80│
│ •  **Patient education completion**: >95%│
│ •  **Cardiac rehab referral**: >80%     │
│                                         │
│ **📊 HFrEF-Specific Outcomes**:         │
│ •  **GDMT optimization at discharge**: >75%│
│ •  **Beta-blocker continuation**: >90%   │
│ •  **ARNI vs ACE-I preference**: >60%    │
│                                         │
│ **🔄 Continuous Improvement**:          │
│ •  **Monthly EF-specific reviews**       │
│ •  **Quarterly outcome analysis**        │
│ •  **Annual guideline updates**         │
│                                         │
│ **📚 Staff Education**:                 │
│ •  **HFpEF vs HFrEF differences**       │
│ •  **New medication protocols**         │
│ •  **Quality metric awareness**         │
│                                         │
│ ✅ **COMPREHENSIVE HF PROTOCOL COMPLETE**│
│                                         │
│ [◀ Previous: All Treatment Pathways]   │
└─────────────────────────────────────────┘

## VIRTUA VOORHEES ENHANCED HF IMPLEMENTATION

### **HFpEF-Specific Evidence Integration (2025)**:
- **Preserved EF Recognition**: Systematic LVEF assessment with every acute HF presentation
- **Contributing Factor Analysis**: Comprehensive evaluation for hypertension, diabetes, obesity, sleep disorders
- **SGLT2 Inhibitor Priority**: First-line therapy for NYHA Class II-III HFpEF regardless of diabetes status[24][28]
- **Quality of Life Focus**: Emphasis on functional capacity improvement and symptom management

### **Advanced Diagnostic Protocols**:
- **Infiltrative Disease Screening**: Cardiac amyloidosis evaluation in appropriate patients
- **High-Output Assessment**: Thyroid function, anemia evaluation, AV malformation screening
- **Sleep Disorder Integration**: OSA screening given high prevalence in HFpEF
- **Metabolic Evaluation**: Comprehensive diabetes and obesity management

### **Technology Integration**:
- **Point-of-Care Echo**: Immediate LVEF assessment for treatment pathway selection
- **CardioMEMS Consideration**: Remote PA monitoring for selected HFpEF patients with recurrent admissions
- **Digital Health Tools**: Weight monitoring apps, medication adherence tracking
- **Telemedicine Integration**: Remote follow-up optimization for stable patients

### **Personalized Medicine Approach**:
- **Phenotype-Specific Treatment**: Hypertensive vs ischemic vs metabolic HFpEF management
- **Comorbidity-Driven Therapy**: Targeted treatment based on primary contributing factors
- **Functional Class-Based Intensity**: NYHA class-driven treatment aggressiveness
- **Patient-Centered Goals**: Quality of life and functional capacity prioritization

## REFERENCE GUIDELINES & EVIDENCE BASE
- **2024 AHA/ACC/HFSA Heart Failure Guidelines** - HFpEF Management Updates[22]
- **UpToDate Clinical Decision Support** - HFpEF Treatment Protocols 2025
- **ESC 2024 Heart Failure Guidelines** - Preserved EF Focus[24][25][28]
- **Virtua Health System Enhanced HF Protocol v2025** - EF-Integrated Management

**This comprehensive protocol represents the most advanced integration of EF-specific heart failure management, with particular emphasis on HFpEF recognition and treatment, while maintaining excellence in HFrEF care through evidence-based four-pillar therapy optimization for superior patient outcomes at Virtua Voorhees.**
