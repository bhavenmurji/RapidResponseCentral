# Chest Pain Evaluation – RRT Protocol with Virtua Voorhees Addenda

**Primary Guideline:** American Heart Association/American College of Cardiology (AHA/ACC) 2023 Guidelines for the Management of Patients with Non-ST-Elevation Acute Coronary Syndromes
**Official Source:** https://www.ahajournals.org/doi/10.1161/CIR.0000000000001204
**Supporting Guidelines:**
- 2023 ESC Guidelines for the Management of Acute Coronary Syndromes
- 2024 AHA/ACC Guideline for the Evaluation and Diagnosis of Chest Pain
- 2023 ESC Guidelines on the Diagnosis and Management of Acute Pulmonary Embolism

## ENHANCED MERMAID FLOWCHART ALGORITHM

~~~mermaid
graph TD
    A["Chest Pain Recognition<br/>RRT Activation"] --> B["ABC Assessment<br/>12-Lead ECG ≤10min"]
    
    B --> C{"STEMI<br/>Present?"}
    
    C -->|YES| D["Code STEMI Activation<br/>Transfer to STEMI Protocol"]
    C -->|NO| E["Risk Stratification<br/>HEART Score + Clinical"]
    
    D --> F["Primary PCI Pathway<br/>Door-to-Balloon <90min"]
    E --> G{"High-Risk<br/>Features?"}
    
    G -->|YES| H["Immediate Workup<br/>Serial Troponins + Imaging"]
    G -->|NO| I["Standard Evaluation<br/>Basic Workup"]
    
    H --> J{"Suspected<br/>Diagnosis?"}
    I --> K["Initial Troponin<br/>+ Basic Labs"]
    
    J -->|ACS| L["NSTEACS Protocol<br/>DAPT + Anticoagulation"]
    J -->|PE| M["Wells Score<br/>+ D-Dimer/CTA"]
    J -->|DISSECTION| N["CTA Chest/Abd<br/>Emergent Evaluation"]
    J -->|OTHER| O["Targeted Workup<br/>Based on Presentation"]
    
    K --> P{"Initial Troponin<br/>Elevated?"}
    
    L --> Q["Cardiology Consult<br/>Risk Stratification"]
    M --> R{"PE<br/>Confirmed?"}
    N --> S{"Dissection<br/>Type?"}
    O --> T["Alternative Diagnosis<br/>Management"]
    
    P -->|YES| L
    P -->|NO| U{"HEART Score<br/>≥4?"}
    
    Q --> V{"Invasive Strategy<br/>Indicated?"}
    R -->|YES| W["Anticoagulation<br/>Risk Stratify"]
    R -->|NO| X["Alternative Diagnosis<br/>Consider Other Causes"]
    S -->|"TYPE A"| Y["Emergency Surgery<br/>Immediate OR"]
    S -->|"TYPE B"| Z["Medical Management<br/>BP Control"]
    
    U -->|YES| AA["Serial Troponins<br/>Observation"]
    U -->|NO| BB["Low-Risk Discharge<br/>Outpatient Follow-up"]
    
    V -->|YES| CC["Cardiac Catheterization<br/>Early Invasive"]
    V -->|NO| DD["Conservative Management<br/>Stress Testing"]
    
    AA --> EE{"Serial Troponins<br/>Positive?"}
    EE -->|YES| L
    EE -->|NO| FF["Stress Test<br/>vs Discharge"]
    
    F --> GG["ICU/CCU Admission<br/>Post-PCI Care"]
    CC --> GG
    DD --> HH["Telemetry Admission<br/>Medical Management"]
    W --> HH
    Y --> II["ICU/Post-Op<br/>Surgical Recovery"]
    Z --> II
    BB --> JJ["Discharge Home<br/>PCP Follow-up"]
    FF --> JJ
    T --> KK["Disposition Based<br/>on Final Diagnosis"]
    X --> KK
    
    style A fill:#ffcccc
    style B fill:#ffe6cc
    style D fill:#ffaaaa
    style L fill:#fff2cc
    style Q fill:#ccffcc
    style Y fill:#ff6666
    style GG fill:#ccffee
~~~

## STREAMLINED DYNAMIC CARD SYSTEM

### Card 0 – Chest Pain Recognition & Initial Assessment (Node A → B)
┌─────────────────────────────────────────┐
│ 💔 CHEST PAIN RRT ACTIVATION            │
├─────────────────────────────────────────┤
│ 📊 Recognition criteria:                │
│ • Chest pain/discomfort                │
│ • Chest pressure/tightness             │
│ • Epigastric pain (ACS equivalent)      │
│ • Arm/jaw pain without chest pain      │
│ • Dyspnea with chest symptoms          │
│                                         │
│ 🚨 ABC Assessment (Priority #1):        │
│ • Airway: Patent and protected         │
│ • Breathing: Adequate ventilation      │
│ • Circulation: Perfusion assessment    │
│ • Disability: Neurologic status        │
│                                         │
│ ⚡ Time-critical actions:               │
│ • 12-lead ECG within 10 minutes        │
│ • IV access establishment              │
│ • Continuous cardiac monitoring        │
│ • Vital signs with bilateral BP        │
│                                         │
│ [Next: ECG interpretation ▶]           │
└─────────────────────────────────────────┘

### Card 1A – STEMI Protocol Activation (Node D → F)
┌─────────────────────────────────────────┐
│ 🚨 STEMI IDENTIFIED - CODE ACTIVATION    │
├─────────────────────────────────────────┤
│ 📊 STEMI criteria confirmed:            │
│ • ST-elevation ≥1mm in ≥2 contiguous leads│
│ • New LBBB with clinical correlation   │
│ • Posterior STEMI equivalent           │
│                                         │
│ 🔗 Protocol transition:                 │
│ • [TRANSFER TO CODE STEMI PROTOCOL]    │
│ • Activate cath lab team               │
│ • Transfer Center: 856-886-5111        │
│                                         │
│ 💊 Immediate medications:               │
│ • Aspirin 324mg chewed                 │
│ • Ticagrelor 180mg loading dose        │
│ • Heparin per STEMI protocol           │
│                                         │
│ ⏱️ Time targets:                        │
│ • Door-to-balloon <90 minutes          │
│ • STEMI protocol activation            │
│                                         │
│ ✅ CODE STEMI PROTOCOL ACTIVE          │
│                                         │
│ [◀ Previous: ECG Recognition]          │
└─────────────────────────────────────────┘

### Card 1B – Risk Stratification (Node E → G)
┌─────────────────────────────────────────┐
│ 📊 CHEST PAIN RISK STRATIFICATION       │
├─────────────────────────────────────────┤
│ 🎯 HEART Score calculation (2024 update):│
│ • History: Highly/moderately/low susp  │
│ • ECG: ST depression/LBBB/Normal       │
│ • Age: ≥65, 45-64, <45 years           │
│ • Risk factors: ≥3, 1-2, 0 factors     │
│ • Troponin: >3×, 1-3×, <1× normal     │
│                                         │
│ 🚨 High-risk features (any present):    │
│ • Hemodynamic instability             │
│ • Persistent symptoms >20 minutes      │
│ • Dynamic ECG changes                  │
│ • Known CAD with recent symptoms       │
│ • Diabetes + typical symptoms          │
│                                         │
│ 📋 Additional risk factors:             │
│ • Family history of early CAD         │
│ • Smoking, hypertension, dyslipidemia │
│ • Prior revascularization              │
│                                         │
│ [Next: Risk level determination ▶]     │
│                                         │
│ [◀ Previous: ECG Interpretation]       │
└─────────────────────────────────────────┘

### Card 2A – High-Risk Immediate Workup (Node H → J)
┌─────────────────────────────────────────┐
│ 🚨 HIGH-RISK IMMEDIATE EVALUATION       │
├─────────────────────────────────────────┤
│ 📊 STAT laboratory studies:             │
│ • High-sensitivity troponin I/T        │
│ • Complete blood count                 │
│ • Basic metabolic panel                │
│ • PT/INR, PTT                          │
│ • Lipid panel                          │
│                                         │
│ 📸 Immediate imaging:                   │
│ • Portable chest X-ray                │
│ • Consider bedside echocardiogram      │
│ • CT imaging if dissection suspected   │
│                                         │
│ 💊 Initial treatment:                   │
│ • Aspirin 324mg chewed if not given    │
│ • Nitroglycerin 0.4mg SL PRN pain      │
│ • Morphine 2-4mg IV PRN (Class IIb)    │
│                                         │
│ [Next: Suspected diagnosis ▶]          │
│                                         │
│ [◀ Previous: Risk Stratification]      │
└─────────────────────────────────────────┘

### Card 2B – Standard Evaluation (Node I → K)
┌─────────────────────────────────────────┐
│ 📋 STANDARD CHEST PAIN EVALUATION       │
├─────────────────────────────────────────┤
│ 📊 Basic laboratory studies:            │
│ • High-sensitivity troponin (baseline) │
│ • Complete blood count                 │
│ • Basic metabolic panel                │
│ • Consider D-dimer if PE risk          │
│                                         │
│ 📸 Basic imaging:                       │
│ • Portable chest X-ray                │
│ • Additional imaging based on suspicion│
│                                         │
│ 📝 Focused history elements:            │
│ • Pain character, duration, radiation  │
│ • Associated symptoms                  │
│ • Previous cardiac history             │
│ • Risk factors assessment              │
│                                         │
│ [Next: Initial troponin result ▶]      │
│                                         │
│ [◀ Previous: Risk Stratification]      │
└─────────────────────────────────────────┘

### Card 3A – NSTEACS Protocol (Node L → Q)
┌─────────────────────────────────────────┐
│ 💔 NON-ST ELEVATION ACS PROTOCOL        │
├─────────────────────────────────────────┤
│ 💊 Dual antiplatelet therapy (2023 update):│
│ • Aspirin 81mg daily (after loading)   │
│ • Ticagrelor 90mg BID (preferred)      │
│ • Or clopidogrel 75mg daily           │
│ • Or prasugrel 10mg daily (if PCI planned)│
│                                         │
│ 💊 Anticoagulation (choose one):        │
│ • UFH: 60 units/kg bolus → 12 units/kg/hr│
│ • Enoxaparin: 1mg/kg SC BID            │
│ • Fondaparinux: 2.5mg SC daily         │
│                                         │
│ 💊 Additional therapies:                │
│ • High-intensity statin (atorvastatin 80mg)│
│ • Beta-blocker (if no contraindications)│
│ • ACE inhibitor (if LV dysfunction)    │
│                                         │
│ [Next: Cardiology consultation ▶]      │
│                                         │
│ [◀ Previous: Suspected Diagnosis]      │
└─────────────────────────────────────────┘

### Card 3B – Pulmonary Embolism Evaluation (Node M → R)
┌─────────────────────────────────────────┐
│ 🫁 PULMONARY EMBOLISM ASSESSMENT        │
├─────────────────────────────────────────┤
│ 📊 Wells Score calculation (2023 update):│
│ • Clinical signs of DVT (3 points)     │
│ • PE most likely diagnosis (3 points)  │
│ • Heart rate >100 bpm (1.5 points)     │
│ • Immobilization/surgery (1.5 points)  │
│ • Previous PE/DVT (1.5 points)         │
│ • Hemoptysis (1 point)                 │
│ • Malignancy (1 point)                 │
│                                         │
│ 🔬 Diagnostic strategy:                 │
│ • Wells <2: D-dimer first              │
│ • Wells ≥2: Consider CTA chest         │
│ • Age-adjusted D-dimer (Age × 10 ng/mL)│
│                                         │
│ 📸 Imaging options:                     │
│ • CTPA (CT pulmonary angiogram)        │
│ • V/Q scan if contrast contraindicated │
│                                         │
│ [Next: PE confirmation ▶]              │
│                                         │
│ [◀ Previous: Suspected Diagnosis]      │
└─────────────────────────────────────────┘

### Card 3C – Aortic Dissection Evaluation (Node N → S)
┌─────────────────────────────────────────┐
│ 🩸 AORTIC DISSECTION ASSESSMENT         │
├─────────────────────────────────────────┤
│ 🚨 High-risk features:                  │
│ • Tearing/ripping chest/back pain      │
│ • Pulse deficit or BP differential >20mmHg│
│ • Acute aortic regurgitation murmur    │
│ • Mediastinal widening on CXR          │
│                                         │
│ 📸 Immediate imaging:                   │
│ • CTA chest/abdomen/pelvis with contrast│
│ • TEE if hemodynamically unstable      │
│ • Avoid delay for "rule-out" testing   │
│                                         │
│ 💊 Blood pressure management:           │
│ • Target SBP 100-120 mmHg              │
│ • Beta-blocker first (esmolol preferred)│
│ • Then vasodilator if needed           │
│ • AVOID anticoagulation               │
│                                         │
│ [Next: Type classification ▶]          │
│                                         │
│ [◀ Previous: Suspected Diagnosis]      │
└─────────────────────────────────────────┘

### Card 4A – Cardiology Consultation (Node Q → V)
┌─────────────────────────────────────────┐
│ 💼 CARDIOLOGY CONSULTATION              │
├─────────────────────────────────────────┤
│ 📞 Consultation timing:                 │
│ • STAT: Unstable ACS, cardiogenic shock│
│ • Urgent: NSTEMI, high-risk NSTEACS    │
│ • Routine: Stable angina evaluation    │
│                                         │
│ 📊 Risk stratification (GRACE 2.0 score):│
│ • Age, heart rate, systolic BP         │
│ • Creatinine, Killip class             │
│ • Cardiac arrest, ST deviation         │
│ • Elevated cardiac biomarkers          │
│                                         │
│ 🎯 Invasive strategy decision:          │
│ • Early invasive (<24h): High-risk     │
│ • Selective invasive: Intermediate-risk│
│ • Conservative: Low-risk, stable       │
│                                         │
│ [Next: Invasive strategy decision ▶]   │
│                                         │
│ [◀ Previous: NSTEACS Protocol]         │
└─────────────────────────────────────────┘

### Card 4B – PE Confirmation & Treatment (Node R)
┌─────────────────────────────────────────┐
│ ✅ PULMONARY EMBOLISM MANAGEMENT        │
├─────────────────────────────────────────┤
│ ❓ PE confirmed on imaging?             │
│                                         │
│ 🔘 YES → Anticoagulation protocol:     │
│ • UFH: 80 units/kg bolus → 18 units/kg/hr│
│ • Or LMWH: Enoxaparin 1mg/kg SC BID    │
│ • Or DOAC: Apixaban/rivaroxaban        │
│                                         │
│ 📊 Severity assessment:                 │
│ • Massive PE: Hemodynamic instability  │
│ • Submassive PE: RV strain without shock│
│ • Low-risk PE: No RV strain            │
│                                         │
│ 💊 Thrombolysis consideration:          │
│ • Massive PE with shock                │
│ • Selected submassive PE cases         │
│ • Alteplase 100mg IV over 2 hours      │
│                                         │
│ 🔘 NO → Alternative diagnosis workup   │
│                                         │
│ [◀ Previous] [Next: Based on Selection ▶]│
└─────────────────────────────────────────┘

### Card 4C – Dissection Type Classification (Node S)
┌─────────────────────────────────────────┐
│ 🩸 AORTIC DISSECTION TYPE CLASSIFICATION│
├─────────────────────────────────────────┤
│ 📊 Stanford Classification:             │
│                                         │
│ 🔴 Type A (Ascending aorta):            │
│ • Involves ascending aorta             │
│ • Surgical emergency                   │
│ • Mortality 1-2% per hour if untreated │
│                                         │
│ 🔵 Type B (Descending aorta):           │
│ • Does not involve ascending aorta     │
│ • Medical management preferred         │
│ • Surgery for complications           │
│                                         │
│ ❓ Dissection type identified?          │
│                                         │
│ 🔘 TYPE A → Emergency surgery          │
│ 🔘 TYPE B → Medical management         │
│                                         │
│ 📞 Immediate consultations:             │
│ • Cardiothoracic surgery (Type A)      │
│ • Vascular surgery (complicated Type B)│
│                                         │
│ [◀ Previous] [Next: Based on Selection ▶]│
└─────────────────────────────────────────┘

### Card 5A – Initial Troponin Evaluation (Node P)
┌─────────────────────────────────────────┐
│ 🧪 INITIAL TROPONIN INTERPRETATION      │
├─────────────────────────────────────────┤
│ 📊 High-sensitivity troponin (2024 update):│
│ • 99th percentile upper reference limit│
│ • Sex-specific cutoffs recommended     │
│ • Optimal sampling: 0 and 1-2 hours    │
│                                         │
│ ❓ Initial troponin elevated?           │
│                                         │
│ 🔘 YES → NSTEACS protocol activation:  │
│ • Treat as NSTEMI                      │
│ • Begin dual antiplatelet therapy      │
│ • Anticoagulation                      │
│ • Cardiology consultation              │
│                                         │
│ 🔘 NO → HEART score assessment:        │
│ • Calculate updated HEART score        │
│ • Determine observation vs discharge   │
│ • Serial troponins if indicated        │
│                                         │
│ [◀ Previous] [Next: Based on Selection ▶]│
└─────────────────────────────────────────┘

### Card 5B – HEART Score Decision (Node U)
┌─────────────────────────────────────────┐
│ 💔 HEART SCORE RISK STRATIFICATION      │
├─────────────────────────────────────────┤
│ 📊 HEART Score interpretation (2024):   │
│ • 0-3 points: Low risk (1.7% MACE)     │
│ • 4-6 points: Intermediate (12% MACE)  │
│ • 7-10 points: High risk (65% MACE)    │
│                                         │
│ ❓ HEART Score ≥4 points?               │
│                                         │
│ 🔘 YES → Serial troponins required:    │
│ • q6h × 2-3 sets minimum               │
│ • Admit for observation               │
│ • Consider stress testing              │
│                                         │
│ 🔘 NO → Low-risk discharge eligible:   │
│ • Single negative troponin sufficient │
│ • Discharge with cardiology follow-up │
│ • Return precautions provided          │
│                                         │
│ [◀ Previous] [Next: Based on Selection ▶]│
└─────────────────────────────────────────┘

### Card 6A – Early Invasive Strategy (Node CC → GG)
┌─────────────────────────────────────────┐
│ ⚡ EARLY INVASIVE CATHETERIZATION       │
├─────────────────────────────────────────┤
│ 🎯 Indications for early invasive (<24h):│
│ • Refractory ischemia                  │
│ • Recurrent ischemia with treatment    │
│ • High-risk troponin pattern           │
│ • Hemodynamic instability              │
│ • Sustained VT/VF                      │
│                                         │
│ 💊 Pre-catheterization optimization:    │
│ • Optimize DAPT (ticagrelor preferred) │
│ • Hold heparin 4-6h before procedure  │
│ • Continue statin therapy              │
│                                         │
│ 🏥 Post-procedure care:                 │
│ • ICU/CCU monitoring                   │
│ • Bleeding surveillance                │
│ • Medication reconciliation            │
│                                         │
│ [Next: ICU/CCU admission ▶]            │
│                                         │
│ [◀ Previous: Invasive Strategy Decision]│
└─────────────────────────────────────────┘

### Card 6B – Conservative Management (Node DD → HH)
┌─────────────────────────────────────────┐
│ 🛡️ CONSERVATIVE MEDICAL MANAGEMENT      │
├─────────────────────────────────────────┤
│ 💊 Optimal medical therapy:             │
│ • Continue DAPT regimen                │
│ • High-intensity statin                │
│ • Beta-blocker optimization            │
│ • ACE inhibitor if indicated           │
│                                         │
│ 📊 Risk stratification:                 │
│ • Stress testing (exercise or pharmacologic)│
│ • Echocardiogram for LV function       │
│ • Consider CTA coronaries if appropriate│
│                                         │
│ 📋 Discharge planning:                  │
│ • Medication education                 │
│ • Lifestyle modifications              │
│ • Cardiology follow-up in 1-2 weeks    │
│                                         │
│ [Next: Telemetry admission ▶]          │
│                                         │
│ [◀ Previous: Invasive Strategy Decision]│
└─────────────────────────────────────────┘

### Card 7A – Emergency Surgery (Node Y → II)
┌─────────────────────────────────────────┐
│ 🔪 EMERGENCY AORTIC SURGERY (TYPE A)    │
├─────────────────────────────────────────┤
│ 🚨 Immediate surgical consultation:     │
│ • Cardiothoracic surgery STAT          │
│ • Operating room preparation           │
│ • Anesthesia team activation           │
│                                         │
│ 💊 Pre-operative management:            │
│ • Continue blood pressure control      │
│ • Avoid anticoagulation               │
│ • Type and crossmatch 6+ units        │
│ • Central line and arterial line       │
│                                         │
│ ⏱️ Time-critical priorities:            │
│ • Surgery within 6 hours optimal       │
│ • Mortality increases with delay       │
│ • Operating room takes priority        │
│                                         │
│ [Next: ICU post-operative care ▶]      │
│                                         │
│ [◀ Previous: Type A Classification]    │
└─────────────────────────────────────────┘

### Card 7B – Serial Troponin Monitoring (Node AA → EE)
┌─────────────────────────────────────────┐
│ 📈 SERIAL TROPONIN MONITORING           │
├─────────────────────────────────────────┤
│ ⏱️ Sampling protocol (2024 guidelines):  │
│ • Baseline (0 hours)                   │
│ • 1-2 hours (high-sensitivity optimal) │
│ • 6 hours (if initial negative)        │
│ • Additional if symptoms recur          │
│                                         │
│ 📊 Interpretation criteria:             │
│ • Rising pattern: Suggests acute MI    │
│ • Falling pattern: Prior infarction    │
│ • Delta change: >20% considered significant│
│                                         │
│ 🔄 Monitoring during observation:       │
│ • Continuous telemetry                 │
│ • Symptom assessment q4h               │
│ • Vital signs per protocol             │
│                                         │
│ [Next: Final troponin decision ▶]      │
│                                         │
│ [◀ Previous: HEART Score Assessment]   │
└─────────────────────────────────────────┘

### Card 8A – Low-Risk Discharge (Node BB → JJ)
┌─────────────────────────────────────────┐
│ 🏠 LOW-RISK DISCHARGE PROTOCOL          │
├─────────────────────────────────────────┤
│ ✅ Discharge criteria met:              │
│ • HEART score <4                       │
│ • Negative troponin                    │
│ • Pain resolved or improved            │
│ • Stable vital signs                   │
│ • No high-risk features                │
│                                         │
│ 📋 Discharge medications:               │
│ • Aspirin 81mg daily                   │
│ • Consider statin if risk factors      │
│ • Nitroglycerin SL PRN (if indicated)  │
│                                         │
│ 📞 Follow-up arrangements:              │
│ • Primary care within 1 week           │
│ • Cardiology if recurrent symptoms     │
│ • Return precautions provided          │
│                                         │
│ 📚 Patient education:                   │
│ • When to seek emergency care          │
│ • Lifestyle modifications              │
│ • Medication compliance                │
│                                         │
│ ✅ DISCHARGE PROTOCOL COMPLETE         │
│                                         │
│ [◀ Previous: Risk Assessment]          │
└─────────────────────────────────────────┘

### Card 8B – Stress Testing Protocol (Node FF → JJ)
┌─────────────────────────────────────────┐
│ 🏃 STRESS TESTING EVALUATION            │
├─────────────────────────────────────────┤
│ 🎯 Stress test selection:               │
│ • Exercise ECG: Young, low-risk patients│
│ • Exercise echo: Intermediate risk      │
│ • Pharmacologic stress: Unable to exercise│
│ • Nuclear stress: Intermediate-high risk│
│                                         │
│ 📊 Timing considerations:               │
│ • Inpatient: Before discharge if stable│
│ • Outpatient: Within 72 hours         │
│ • Emergency: Within 6 hours if very low risk│
│                                         │
│ 📋 Pre-test optimization:               │
│ • Hold beta-blockers if exercise test  │
│ • Continue aspirin                     │
│ • NPO if pharmacologic stress          │
│                                         │
│ [Next: Discharge planning ▶]           │
│                                         │
│ [◀ Previous: Serial Troponin Result]   │
└─────────────────────────────────────────┘

### Card 9 – Disposition Planning (Nodes GG, HH, II, JJ, KK - Final)
┌─────────────────────────────────────────┐
│ 🏥 FINAL DISPOSITION & FOLLOW-UP        │
├─────────────────────────────────────────┤
│ 📍 Disposition options:                 │
│                                         │
│ 🔴 ICU/CCU admission:                   │
│ • Post-catheterization monitoring      │
│ • Hemodynamic instability             │
│ • Mechanical complications             │
│ • Post-surgical aortic dissection      │
│                                         │
│ 🟡 Telemetry admission:                 │
│ • NSTEACS medical management           │
│ • Serial troponin monitoring          │
│ • PE anticoagulation                   │
│ • Type B dissection monitoring         │
│                                         │
│ 🟢 Discharge home:                      │
│ • Low-risk chest pain                  │
│ • Negative cardiac workup              │
│ • Alternative diagnosis with treatment │
│                                         │
│ 📋 Follow-up coordination:              │
│ • Cardiology: 1-2 weeks for ACS        │
│ • Primary care: Within 1 week          │
│ • Specialist referrals as indicated    │
│                                         │
│ 📊 Quality metrics documentation:       │
│ • Door-to-ECG time                     │
│ • Appropriate DAPT initiation          │
│ • Risk stratification completion       │
│                                         │
│ ✅ CHEST PAIN PROTOCOL COMPLETE        │
│                                         │
│ [◀ Previous: Treatment Completion]     │
└─────────────────────────────────────────┘

## VIRTUA VOORHEES CHEST PAIN ADDENDA

### **Enhanced RRT Response Program:**
- **Rapid Response Team:** Immediate multidisciplinary activation including cardiology access
- **ECG Integration:** 12-lead capability on all RRT carts with immediate interpretation
- **Laboratory Integration:** High-sensitivity troponin available 24/7 with <60 minute turnaround
- **Quality Metrics:** Door-to-ECG times, appropriate risk stratification, DAPT initiation rates

### **Updated 2023-2024 Guidelines Integration:**
**AHA/ACC 2023 NSTEACS Guidelines:**
- **High-sensitivity troponin protocols:** 0/1h and 0/2h algorithms for rapid rule-out
- **HEART score validation:** Updated risk categories with 2024 meta-analysis data
- **P2Y12 inhibitor selection:** Ticagrelor preferred over clopidogrel for most patients
- **Early invasive strategy:** Refined criteria based on GRACE 2.0 score >140

**ESC 2023 Updates:**
- **0/1h algorithm:** For high-sensitivity troponin with validated cutoffs
- **EDACS pathway:** Emergency Department Assessment of Chest pain Score integration
- **RAPID-TnT protocol:** Ultra-early discharge for very low-risk patients

### **High-Sensitivity Troponin Integration:**
**Abbott ARCHITECT hs-cTnI (Virtua system):**
- **99th percentile:** Males 34.2 ng/L, Females 15.6 ng/L
- **Rule-out cutoff:** <5 ng/L at presentation
- **Rule-in cutoff:** >52 ng/L males, >16 ng/L females
- **Delta criteria:** >50% change in 1 hour or >20% change in 2-6 hours

**Clinical Decision Pathways:**
- **0/1h protocol:** Validated for patients presenting >2h after symptom onset
- **Serial sampling:** q6h × 3 for intermediate-risk patients
- **Peak timing:** Consider 12-24h sampling for late presenters

### **Point-of-Care Integration:**
**Bedside Echocardiography:**
- **Wall motion assessment:** Regional wall motion abnormalities
- **LV function:** Ejection fraction estimation
- **Complications:** Pericardial effusion, mechanical complications
- **RV strain:** Signs of pulmonary embolism

**POCUS Applications:**
- **IVC assessment:** Volume status in heart failure
- **Lung ultrasound:** B-lines for pulmonary edema
- **Aortic root:** Limited assessment for dissection

### **Advanced Risk Stratification:**
**HEART Score (2024 Validation):**
- **Score 0-3:** 6-week MACE 1.7% (safe discharge)
- **Score 4-6:** 6-week MACE 12% (observation/testing)
- **Score 7-10:** 6-week MACE 65% (invasive strategy)

**GRACE 2.0 Score Integration:**
- **In-hospital death risk:** <1%, 1-3%, >3%
- **6-month death/MI risk:** <3%, 3-8%, >8%
- **Invasive strategy:** Recommended if >140 points

### **Medication Protocols - Updated 2024:**
**Dual Antiplatelet Therapy:**
- **Aspirin:** 324mg loading, then 81mg daily
- **Ticagrelor:** 180mg loading, then 90mg BID (preferred)
- **Prasugrel:** 60mg loading, then 10mg daily (avoid if >75y, <60kg, prior stroke)
- **Clopidogrel:** 600mg loading, then 75mg daily (high bleeding risk)

**Anticoagulation Selection:**
- **UFH:** 60 units/kg bolus (max 4000), then 12 units/kg/h (max 1000)
- **Enoxaparin:** 1mg/kg SC BID (preferred if conservative strategy)
- **Fondaparinux:** 2.5mg SC daily (lowest bleeding risk)

### **Emergency Consultation Pathways:**
**Interventional Cardiology:**
- **STEMI:** Direct activation via Code STEMI protocol
- **High-risk NSTEACS:** <24h invasive strategy
- **Cardiogenic shock:** Emergency mechanical support

**Cardiothoracic Surgery:**
- **Type A dissection:** Emergency consultation within 30 minutes
- **Mechanical complications:** Papillary muscle rupture, VSD, free wall rupture
- **Refractory ischemia:** Emergency CABG consideration

### **Quality Improvement Metrics:**
**Process Measures:**
- **Door-to-ECG time:** Goal <10 minutes, target <5 minutes
- **Troponin turnaround:** Goal <60 minutes for high-sensitivity assays
- **DAPT initiation:** >95% for confirmed ACS within 24 hours
- **Risk stratification:** HEART score documentation >90%

**Outcome Measures:**
- **30-day MACE:** Death, MI, urgent revascularization
- **Discharge appropriateness:** Low-risk patients discharged <24h
- **Readmission rates:** 7-day and 30-day cardiac readmissions
- **Patient satisfaction:** ED/chest pain unit experience scores

### **Integration with Other Protocols:**
- **Code STEMI:** Seamless transition for ST-elevation cases
- **Shock Protocol:** For cardiogenic shock management
- **Atrial Fibrillation:** For rate control in RVR
- **Acute Heart Failure:** For decompensated CHF presentations

### **Special Population Considerations:**
**Diabetic Patients:**
- **Atypical presentations:** Higher index of suspicion
- **Silent ischemia:** Lower pain thresholds
- **Aggressive risk factor modification:** Statin and ACE inhibitor therapy

**Elderly Patients (>75 years):**
- **Bleeding risk assessment:** HAS-BLED score integration
- **Medication adjustments:** Reduced prasugrel dosing
- **Functional status:** Consider goals of care discussions

**Women:**
- **Atypical presentations:** Jaw pain, nausea, fatigue without chest pain
- **Microvascular disease:** Consider despite normal coronaries
- **Pregnancy considerations:** Avoid ACE inhibitors and statins

**Chronic Kidney Disease:**
- **Contrast nephropathy prevention:** Hydration protocols
- **Medication dosing:** Renally-adjusted anticoagulation
- **Troponin interpretation:** Baseline elevation considerations

### **Discharge Planning & Follow-up:**
**Medication Reconciliation:**
- **DAPT duration:** Minimum 12 months for ACS
- **Statin therapy:** High-intensity for secondary prevention
- **Beta-blocker optimization:** Titrate to heart rate 50-60 bpm
- **ACE inhibitor/ARB:** For LV dysfunction or diabetes

**Lifestyle Counseling:**
- **Smoking cessation:** Pharmacotherapy and counseling referrals
- **Cardiac rehabilitation:** Referral within 30 days
- **Dietary counseling:** Mediterranean diet recommendations
- **Exercise prescription:** Structured activity recommendations

## REFERENCE GUIDELINES
- **2023 AHA/ACC Guideline for the Management of Patients with Non-ST-Elevation Acute Coronary Syndromes**
- **2024 AHA/ACC Guideline for the Evaluation and Diagnosis of Chest Pain**
- **2023 ESC Guidelines for the Management of Acute Coronary Syndromes**
- **2023 ESC Guidelines on the Diagnosis and Management of Acute Pulmonary Embolism**
- **Virtua Health System Chest Pain Protocol v2025**

**This comprehensive protocol integrates the latest evidence-based chest pain evaluation with rapid diagnostic capabilities, advanced risk stratification, and seamless integration with cardiac interventional services optimized for excellent patient outcomes at Virtua Voorhees.**
