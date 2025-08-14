# Right Heart Failure – Enhanced RRT Protocol with Evidence-Based Integration

**Primary Guidelines:** 
- UpToDate Clinical Decision Support - Right Heart Failure Management 2025[1][2]
- 2024 Pulmonary Arterial Hypertension Treatment Guidelines[3]
- 2024 ESC Heart Failure Guidelines - Right Heart Focus
- Virtua Health System Advanced HF Protocol Integration

**Official Sources:** 
- UpToDate Right Heart Failure: Causes and Management[1]
- UpToDate Treatment and Prognosis of Pulmonary Arterial Hypertension[2]

## ENHANCED PATHOPHYSIOLOGY-DRIVEN MERMAID ALGORITHM

~~~mermaid
graph TD
    A["🫀 RHF Recognition<br/>Systemic Venous Congestion"] --> B["🚨 ABCs + Hemodynamic<br/>Assessment"]
    
    B --> C["📊 Immediate Stabilization<br/>O2 + Access + Monitoring"]
    
    C --> D{"💓 Hemodynamic<br/>Stability?"}
    
    D -->|UNSTABLE| E["🏥 ICU Transfer<br/>Invasive Monitoring"]
    D -->|STABLE| F["🔍 Systematic Etiology<br/>Assessment"]
    
    E --> G["📈 Swan-Ganz Catheter<br/>Hemodynamic Optimization"]
    F --> H{"🎯 Primary<br/>RHF Etiology?"}
    
    G --> I["💪 RV Support Triad<br/>Preload/Afterload/Contractility"]
    
    H -->|PAH GROUP 1| J["🫁 PAH-Specific Therapy<br/>Combination Approach"]
    H -->|LEFT HEART DISEASE| K["💔 Optimize LV Function<br/>GDMT + Volume"]
    H -->|PULMONARY DISEASE| L["🔬 Treat Lung Disease<br/>+ O2 Optimization"]
    H -->|CTEPH/PE| M["🩸 Anticoagulation<br/>+ Intervention"]
    H -->|RV INFARCTION| N["⚡ Maintain Preload<br/>+ Reperfusion"]
    H -->|CONGENITAL/VALVE| O["🔧 Structural Intervention<br/>Surgical Planning"]
    
    I --> P{"📊 Adequate RV<br/>Performance?"}
    J --> Q["🆕 Advanced PAH Rx<br/>Sotatercept Era"]
    K --> R["💊 SGLT2i + ARNI<br/>RV-Protective Therapy"]
    L --> S["🫁 Lung-Specific<br/>Management"]
    M --> T["🔄 Reperfusion vs<br/>Endarterectomy"]
    N --> U["🩸 Urgent Reperfusion<br/>+ RV Support"]
    O --> V["⚙️ Surgical/Transcatheter<br/>Intervention"]
    
    P -->|YES| W["📉 Wean Support<br/>Transition Strategy"]
    P -->|NO| X["⚙️ Mechanical Support<br/>RVAD/ECMO/Impella"]
    
    Q --> Y{"🎯 PAH Response<br/>Assessment?"}
    R --> Z["📊 HF Response<br/>Monitoring"]
    S --> Z
    T --> AA["🔬 Post-Intervention<br/>Assessment"]
    U --> AA
    V --> AA
    
    X --> BB["🔧 MCS Management<br/>Bridge Decisions"]
    
    Y -->|GOOD| CC["📈 Continue Therapy<br/>Long-term Management"]
    Y -->|POOR| DD["🆘 Advanced Options<br/>Transplant/Novel Rx"]
    Z --> EE["📋 Disposition<br/>Based on Response"]
    AA --> EE
    W --> EE
    
    BB --> FF{"🌉 Bridge to<br/>What?"}
    
    FF -->|RECOVERY| GG["🔄 Weaning Protocol<br/>Recovery Support"]
    FF -->|TRANSPLANT| HH["🫀 Transplant Evaluation<br/>Advanced HF Center"]
    FF -->|DESTINATION| II["🏠 Long-term MCS<br/>Palliative Focus"]
    
    CC --> JJ["🏠 Outpatient<br/>PAH Management"]
    DD --> KK["🏥 Advanced HF Center<br/>Experimental Therapies"]
    EE --> LL["📊 Appropriate Level<br/>of Care"]
    GG --> LL
    HH --> MM["🔬 Transplant<br/>Workup/Listing"]
    II --> NN["🤝 Palliative Care<br/>QOL Focus"]
    
    JJ --> OO["📋 Specialist<br/>Follow-up"]
    KK --> MM
    LL --> OO
    MM --> PP["🎯 Long-term<br/>Management Plan"]
    NN --> PP
    
    OO --> QQ["✅ RHF Protocol<br/>Complete"]
    PP --> QQ
    
    style A fill:#ffcccc
    style E fill:#ff6666
    style G fill:#ffaaaa
    style I fill:#fff2cc
    style X fill:#ff8888
    style BB fill:#ccffcc
    style DD fill:#e6ccff
    style QQ fill:#ccffee
~~~

## COMPREHENSIVE EVIDENCE-BASED CARD SYSTEM

### Card 0 – Advanced RHF Recognition (Node A → B)
┌─────────────────────────────────────────┐
│ 🫀 RIGHT HEART FAILURE RECOGNITION      │
├─────────────────────────────────────────┤
│ **📊 Clinical Definition[1]**:          │
│ • Symptoms and signs caused by RV dysfunction│
│ • Impaired ability to perfuse lungs at normal CVP│
│ • NOT synonymous with RV dysfunction alone│
│                                         │
│ **🔍 Recognition Criteria (Evidence-Based)[1]**:│
│ • **Signs**: JVP elevation, hepatomegaly, peripheral edema│
│ • **Symptoms**: Exertional dyspnea, fatigue, dizziness│
│ • **Hemodynamics**: Low CO, elevated CVP │
│ • **Imaging**: RV dysfunction on echo   │
│                                         │
│ **📋 RHF Clinical Syndrome Components[1]**:│
│ • **Volume overload**: Peripheral edema, ascites│
│ • **Low output**: Fatigue, exercise intolerance│
│ • **Organ congestion**: Hepatic, renal, GI│
│ • **Poor perfusion**: Cool extremities  │
│                                         │
│ **⚠️ Critical Recognition Points**:     │
│ • May occur without LV involvement     │
│ • Can be acute or chronic presentation │
│ • Often involves multiple etiologies   │
│ • High mortality if unrecognized       │
│                                         │
│ [Next: Hemodynamic assessment ▶]       │
└─────────────────────────────────────────┘

### Card 1 – Systematic Etiology Classification (Node F → H)
┌─────────────────────────────────────────┐
│ 🔍 COMPREHENSIVE RHF ETIOLOGY FRAMEWORK │
├─────────────────────────────────────────┤
│ **🫁 Group 1: Pulmonary Arterial Hypertension[1]**:│
│ • **Idiopathic PAH**: Most studied form │
│ • **Associated PAH**: CTD, CHD, drugs, toxins│
│ • **Heritable PAH**: BMPR2, other mutations│
│ • **Drug/toxin-induced**: Methamphetamines, appetite suppressants│
│                                         │
│ **💔 Group 2: Left Heart Disease[1]**:  │
│ • **HFrEF/HFmrEF**: LVEF ≤40-49%       │
│ • **HFpEF**: LVEF ≥50% (challenging diagnosis)│
│ • **Valvular disease**: Mitral/aortic stenosis/regurgitation│
│ • **Atrial myxoma**: Obstructive lesion │
│                                         │
│ **🫁 Group 3: Lung Disease/Hypoxemia[1]**:│
│ • **COPD**: Most common chronic cause   │
│ • **ILD**: Progressive pulmonary fibrosis│
│ • **OSA**: Underrecognized contributor  │
│ • **High-altitude exposure**: Chronic hypoxia│
│                                         │
│ **🩸 Group 4: CTEPH[1]**:               │
│ • **Chronic thromboembolic**: Post-PE sequelae│
│ • **Pulmonary artery sarcoma**: Rare malignancy│
│                                         │
│ **🔄 Group 5: Multifactorial[1]**:      │
│ • **Sarcoidosis**: Granulomatous disease│
│ • **Schistosomiasis**: Global health concern│
│ • **Complex congenital**: Multiple factors│
│                                         │
│ [Next: Etiology-specific management ▶] │
└─────────────────────────────────────────┘

### Card 2A – Advanced Hemodynamic Monitoring (Node G → I)
┌─────────────────────────────────────────┐
│ 📈 SWAN-GANZ CATHETER INTEGRATION       │
├─────────────────────────────────────────┤
│ **🎯 Indications for RHC[1]**:          │
│ • Hemodynamically unstable RHF         │
│ • Uncertain volume status              │
│ • Need for vasopressor/inotrope guidance│
│ • Differentiate pre vs post-capillary PH│
│                                         │
│ **📊 Key Hemodynamic Parameters[1]**:   │
│ • **RAP (CVP)**: Normal 2-8 mmHg       │
│ • **PAP**: Systolic/Diastolic/Mean     │
│ • **PCWP**: <15 mmHg (pre-capillary PH)│
│ • **Cardiac output**: Thermodilution/Fick│
│ • **PVR**: Calculate (mPAP-PCWP)/CO×80  │
│                                         │
│ **🎯 RHF-Specific Targets[1]**:         │
│ • RAP: 8-12 mmHg (avoid overdistension)│
│ • Cardiac index: >2.2 L/min/m²         │
│ • Mixed venous O2: >60%                 │
│ • PVR: <5 Wood units if treatable      │
│                                         │
│ **⚠️ Interpretation Challenges[1]**:    │
│ • Pericardial constraint effects       │
│ • Tricuspid regurgitation impact       │
│ • RV-LV interdependence                │
│ • Respiratory variation significance    │
│                                         │
│ [Next: RV support protocol ▶]          │
└─────────────────────────────────────────┘

### Card 2B – Comprehensive RV Support Triad (Node I → P)
┌─────────────────────────────────────────┐
│ 💪 EVIDENCE-BASED RV SUPPORT PROTOCOL   │
├─────────────────────────────────────────┤
│ **💧 Preload Optimization[1]**:         │
│ • **Volume assessment**: Clinical + hemodynamic│
│ • **Diuretic therapy**: If volume overloaded│
│   - Furosemide 20-80mg IV (start low)   │
│   - Monitor response (CVP, UOP, labs)   │
│ • **Volume repletion**: If underfilled  │
│   - 200-300mL NS boluses, assess response│
│                                         │
│ **🫁 Afterload Reduction[1]**:          │
│ • **Oxygenation**: Liberal O2 supplementation│
│ • **pH optimization**: Correct acidosis │
│ • **CO2 management**: Avoid hypercapnia │
│ • **Inhaled vasodilators**:             │
│   - Nitric oxide 10-40 ppm              │
│   - Inhaled epoprostenol 50ng/kg/min    │
│                                         │
│ **💪 Contractility Enhancement[1]**:    │
│ • **Milrinone**: 0.375-0.75 mcg/kg/min (preferred)│
│   - Inotrope + afterload reduction      │
│   - Monitor for hypotension             │
│ • **Dobutamine**: 2.5-10 mcg/kg/min     │
│   - Pure inotrope, less vasodilation    │
│ • **Vasopressor support**: Norepinephrine if hypotensive│
│                                         │
│ **📊 Monitoring Parameters[1]**:        │
│ • CVP response to interventions         │
│ • Cardiac output/index improvement      │
│ • Mixed venous O2 saturation            │
│ • End-organ function (renal, hepatic)   │
│                                         │
│ [Next: Response assessment ▶]          │
└─────────────────────────────────────────┘

### Card 3A – Advanced PAH Management (2025 Evidence)
┌─────────────────────────────────────────┐
│ 🫁 EVIDENCE-BASED PAH THERAPY (2025)    │
├─────────────────────────────────────────┤
│ **💊 Initial Combination Therapy[2]**:  │
│ • **ERA + PDE5i preferred**: Evidence-based│
│ • Ambrisentan 5-10mg + sildenafil 20mg TID│
│ • Alternative: Macitentan 10mg + tadalafil 40mg daily│
│ • **Avoid monotherapy**: In treatment-naive patients│
│                                         │
│ **🆕 Sotatercept Era (2024 Breakthrough)**:│
│ • **FDA approved March 2024**: Game-changer[2]│
│ • **Mechanism**: Activin signaling inhibitor│
│ • **Dosing**: 0.7mg/kg SC every 21 days│
│ • **Add-on therapy**: To dual/triple background│
│                                         │
│ **⚡ Acute Management[2]**:              │
│ • **Oxygen therapy**: Maintain SpO2 >90%│
│ • **Diuretics**: Gentle, avoid depletion│
│ • **Inhaled therapies**: NO, epoprostenol│
│ • **IV prostacyclins**: If refractory   │
│                                         │
│ **📊 Monitoring Response[2]**:          │
│ • **6-minute walk distance**: Functional capacity│
│ • **WHO functional class**: Clinical status│
│ • **BNP/NT-proBNP**: Prognostic marker  │
│ • **Echo parameters**: RV function assessment│
│                                         │
│ **🚫 Contraindicated[2]**:              │
│ • **Pulmonary vasodilators in Group 2 PH**│
│ • **Beta-blockers**: May worsen RV function│
│                                         │
│ [Next: PAH response evaluation ▶]      │
└─────────────────────────────────────────┘

### Card 3B – Left Heart Disease Optimization
┌─────────────────────────────────────────┐
│ 💔 LEFT HEART DISEASE RV PROTECTION     │
├─────────────────────────────────────────┤
│ **💊 GDMT with RV Focus[1]**:           │
│ • **ACE-I/ARB**: Reduce LV filling pressure│
│ • **Beta-blockers**: Carvedilol, metoprolol succinate│
│ • **MRA**: Spironolactone 25mg daily    │
│ • **SGLT2i**: Dapagliflozin 10mg (RV benefits)│
│                                         │
│ **🔄 Volume Management Principles[1]**:  │
│ • **Treat left HF**: Reduces RV afterload│
│ • **Gentle diuresis**: Avoid over-diuresis│
│ • **Monitor response**: BNP, functional status│
│ • **Avoid pulmonary vasodilators**: May worsen outcome│
│                                         │
│ **📊 Hemodynamic Goals[1]**:            │
│ • **PCWP**: <18 mmHg optimal           │
│ • **PA pressure**: Reduce with LV therapy│
│ • **Cardiac output**: Maintain with GDMT│
│                                         │
│ **⚠️ Special Considerations[1]**:       │
│ • **Combined PH**: Pre + post-capillary│
│ • **Pulmonary compliance**: May improve with LV therapy│
│ • **Avoid excessive afterload reduction**: May compromise perfusion│
│                                         │
│ [Next: Response monitoring ▶]          │
└─────────────────────────────────────────┘

### Card 3C – RV Infarction Management
┌─────────────────────────────────────────┐
│ 🩸 RIGHT VENTRICULAR INFARCTION         │
├─────────────────────────────────────────┤
│ **🎯 Key Management Principles[1]**:    │
│ • **Maintain preload**: Essential for RV filling│
│ • **Urgent reperfusion**: Primary PCI preferred│
│ • **Avoid nitrates**: Reduce preload dangerously│
│ • **Monitor for complications**: AV block, arrhythmias│
│                                         │
│ **💧 Volume Management[1]**:            │
│ • **IV fluid challenges**: 200-300mL NS aliquots│
│ • **Target CVP**: 15-18 mmHg (higher than typical)│
│ • **Avoid diuretics**: Unless overt volume overload│
│ • **Monitor response**: CO, BP, UOP    │
│                                         │
│ **⚡ Reperfusion Strategy[1]**:         │
│ • **Primary PCI**: Preferred approach   │
│ • **Target vessel**: Usually RCA       │
│ • **Thrombolysis**: If PCI unavailable │
│ • **Time-sensitive**: Early intervention crucial│
│                                         │
│ **💪 Hemodynamic Support[1]**:          │
│ • **Inotropes**: Dobutamine if low output│
│ • **Avoid vasodilators**: May reduce preload│
│ • **Temporary pacing**: If bradycardia/AV block│
│                                         │
│ [Next: Post-reperfusion care ▶]        │
└─────────────────────────────────────────┘

### Card 4A – Mechanical Circulatory Support (2025 Update)
┌─────────────────────────────────────────┐
│ ⚙️ ADVANCED MECHANICAL SUPPORT OPTIONS  │
├─────────────────────────────────────────┤
│ **🎯 MCS Indications (Evidence-Based)[1]**:│
│ • **Cardiogenic shock**: RV component   │
│ • **Refractory RV failure**: Despite optimal medical therapy│
│ • **Bridge strategies**: Recovery, transplant, decision│
│ • **Post-cardiotomy**: RV failure post-surgery│
│                                         │
│ **🔧 Device Selection Strategy[1]**:    │
│ • **Impella RP**: Percutaneous, up to 4L/min│
│   - Isolated RV failure                │
│   - Short-term support (<14 days)      │
│ • **CentriMag RVAD**: Surgical, durable│
│   - Longer support capability          │
│ • **VA-ECMO**: Biventricular failure    │
│   - Respiratory failure component      │
│ • **Total artificial heart**: End-stage│
│                                         │
│ **⏱️ Timing Considerations[1]**:        │
│ • **Early intervention**: Before irreversible damage│
│ • **Hemodynamic criteria**: CI <2.0, rising lactate│
│ • **End-organ function**: Preserve while possible│
│                                         │
│ **📞 Team Activation[1]**:              │
│ • **Shock team**: Immediate consultation│
│ • **Cardiac surgery**: Device implantation│
│ • **Perfusion services**: ECMO capability│
│ • **Advanced HF**: Long-term planning  │
│                                         │
│ [Next: MCS management ▶]               │
└─────────────────────────────────────────┘

### Card 4B – Advanced PAH Therapies (2025 Breakthrough)
┌─────────────────────────────────────────┐
│ 🆕 BREAKTHROUGH PAH THERAPIES (2025)    │
├─────────────────────────────────────────┤
│ **💊 Sotatercept Revolution[2]**:       │
│ • **Winrevair® (sotatercept-csrk)**     │
│ • **Mechanism**: Activin signaling inhibitor│
│ • **Clinical impact**: 84% reduction in death/transplant│
│ • **Dosing**: 0.7mg/kg SC every 21 days│
│ • **Add-on therapy**: To existing PAH medications│
│                                         │
│ **🔄 Refractory PAH Management[2]**:    │
│ • **IV epoprostenol**: Continuous infusion│
│   - Gold standard for severe PAH       │
│   - Requires central access, pumps     │
│ • **Inhaled treprostinil**: QID dosing  │
│ • **Selexipag**: Oral prostacyclin pathway│
│                                         │
│ **🫀 Advanced Interventions[2]**:       │
│ • **Balloon atrial septostomy**: Create R→L shunt│
│ • **Potts shunt**: Pulmonary-aortic anastomosis│
│ • **Lung transplantation**: Ultimate therapy│
│                                         │
│ **📊 Risk Stratification Tools[2]**:    │
│ • **REVEAL Risk Score**: Mortality prediction│
│ • **WHO Functional Class**: Symptom severity│
│ • **6MWD + BNP**: Combined prognostic value│
│                                         │
│ [Next: Long-term management ▶]         │
└─────────────────────────────────────────┘

### Card 5A – Bridge to Recovery vs Advanced Care
┌─────────────────────────────────────────┐
│ 🌉 BRIDGE DECISION FRAMEWORK            │
├─────────────────────────────────────────┤
│ **🔄 Bridge to Recovery Indicators[1]**: │
│ • **Reversible etiology**: PE, myocarditis, drug-induced│
│ • **Young age**: <50 years with good baseline│
│ • **Acute presentation**: Recent onset RHF│
│ • **Improving hemodynamics**: Response to therapy│
│                                         │
│ **🫀 Bridge to Advanced Therapy[1]**:    │
│ • **End-stage PAH**: Refractory to medical therapy│
│ • **Chronic RV dysfunction**: Irreversible damage│
│ • **Recurrent decompensation**: Frequent hospitalizations│
│ • **Transplant candidate**: Meeting criteria│
│                                         │
│ **⚖️ Decision Factors[1]**:             │
│ • **Underlying pathophysiology**: Reversible vs progressive│
│ • **Functional status**: Baseline quality of life│
│ • **Age and comorbidities**: Surgical risk assessment│
│ • **Social support**: Long-term care capability│
│                                         │
│ **🎯 Goals of Care Discussion[1]**:     │
│ • **Quality vs quantity**: Patient values alignment│
│ • **Functional goals**: Realistic expectations│
│ • **Family involvement**: Shared decision-making│
│                                         │
│ [Next: Appropriate disposition ▶]      │
└─────────────────────────────────────────┘

### Card 6 – Comprehensive Quality Metrics (Final)
┌─────────────────────────────────────────┐
│ 📊 RHF QUALITY MANAGEMENT & OUTCOMES    │
├─────────────────────────────────────────┤
│ **🎯 Process Excellence Metrics**:      │
│ • **Echo completion**: <2h from recognition (>90%)│
│ • **Etiology identification**: Within 4h (>85%)│
│ • **Swan-Ganz placement**: <4h if indicated (>80%)│
│ • **PAH specialist consultation**: Same day (>75%)│
│                                         │
│ **📈 Clinical Outcome Measures**:       │
│ • **30-day mortality**: <20% acute RHF  │
│ • **ICU length of stay**: <7 days median│
│ • **Readmission rate**: <25% at 30 days │
│ • **Functional improvement**: 6MWD >30m increase│
│                                         │
│ **🔧 MCS Quality Indicators**:          │
│ • **Appropriate MCS selection**: >90% concordance│
│ • **Time to MCS**: <6h for indicated cases│
│ • **MCS weaning success**: >60% bridge to recovery│
│ • **Complication rates**: <10% device-related│
│                                         │
│ **📋 PAH-Specific Metrics**:            │
│ • **Combination therapy initiation**: >80% appropriate patients│
│ • **Sotatercept access**: High-risk PAH patients│
│ • **WHO functional class improvement**: >70%│
│                                         │
│ **🔄 Continuous Improvement**:          │
│ • **Monthly case reviews**: Multidisciplinary│
│ • **Quarterly outcome analysis**: Benchmarking│
│ • **Annual protocol updates**: Evidence integration│
│                                         │
│ **📚 Team Education & Training**:       │
│ • **RHF recognition training**: All RRT members│
│ • **Hemodynamic interpretation**: Physician competency│
│ • **MCS decision-making**: Advanced HF training│
│                                         │
│ ✅ **ENHANCED RHF PROTOCOL COMPLETE**   │
│                                         │
│ [◀ Previous: All Treatment Pathways]   │
└─────────────────────────────────────────┘

## VIRTUA VOORHEES ENHANCED IMPLEMENTATION

### **Evidence-Based Integration (2025)**:
- **UpToDate Clinical Guidelines**: Comprehensive RHF management protocols[1][2]
- **Systematic Etiology Classification**: Five-group PH classification system
- **Advanced PAH Therapies**: Sotatercept integration for breakthrough management
- **Hemodynamic Monitoring**: Swan-Ganz catheter optimization protocols

### **Advanced Diagnostic Protocols**:
- **Point-of-Care Echocardiography**: RV function assessment within 2 hours
- **Hemodynamic Monitoring**: Swan-Ganz catheter for unstable patients
- **Advanced Imaging**: Cardiac MRI for complex cases, CT-PA for PE evaluation
- **Biomarker Integration**: BNP/NT-proBNP for risk stratification

### **Technology-Enhanced Care**:
- **Hemodynamic Calculators**: Automated PVR, cardiac output calculations
- **Risk Stratification Tools**: REVEAL score integration
- **MCS Decision Support**: Algorithm-driven device selection
- **Quality Dashboards**: Real-time metric tracking and benchmarking

### **Team-Based Excellence**:
- **Rapid Response Integration**: 24/7 advanced HF and PAH specialist availability
- **Multidisciplinary Rounds**: Daily team assessment with hemodynamic review
- **MCS Committee**: Device selection and management optimization
- **Outcomes Research**: Continuous quality improvement through data analysis

### **Patient-Centered Outcomes**:
- **Functional Improvement Focus**: 6-minute walk distance, WHO functional class
- **Quality of Life Emphasis**: Patient-reported outcome measures
- **Family Involvement**: Shared decision-making in complex cases
- **Long-term Follow-up**: Specialized RHF clinic development

## REFERENCE GUIDELINES & EVIDENCE BASE
- **UpToDate Right Heart Failure Management**: Comprehensive evidence-based protocols[1]
- **UpToDate PAH Treatment Guidelines**: Advanced therapy integration[2]
- **2024 PAH Breakthrough Therapies**: Sotatercept and novel agents
- **Virtua Health System RHF Protocol v2025**: Enhanced evidence integration

**This enhanced protocol represents the most comprehensive integration of evidence-based right heart failure management, incorporating the latest therapeutic advances, advanced hemodynamic monitoring, and technology-enhanced care delivery optimized for superior patient outcomes at Virtua Voorhees.**
