# Altered Mental Status – RRT Protocol with Virtua Voorhees Addenda

**Primary Guideline:** American Academy of Neurology (AAN) Practice Guidelines for Evaluation of Cognitive Impairment and Dementia
**Official Source:** https://www.aan.com/Guidelines/
**Supporting Guidelines:**
- Emergency Neurological Life Support (ENLS) 2025 Guidelines
- American Delirium Society Clinical Practice Guidelines 2023
- Society for Academic Emergency Medicine (SAEM) Altered Mental Status Guidelines

## ENHANCED MERMAID FLOWCHART ALGORITHM

~~~mermaid
graph TD
    A["AMS Recognition<br/>Assess ABCs + GCS"] --> B["Immediate Stabilization<br/>Glucose + Vitals + O2"]
    
    B --> C{"Blood Glucose<br/><60 or >400 mg/dL?"}
    
    C -->|YES| D["Treat Glucose Emergency<br/>D50 or Insulin Protocol"]
    C -->|NO| E["Focused History<br/>+ Neurologic Exam"]
    
    D --> E
    E --> F{"Focal Neurologic<br/>Deficits Present?"}
    
    F -->|YES| G["Stroke Protocol<br/>Code Stroke Activation"]
    F -->|NO| H{"Fever or<br/>Meningeal Signs?"}
    
    G --> I["CT Head STAT<br/>Neurology Consult"]
    H -->|YES| J["CNS Infection Workup<br/>Empiric Antibiotics"]
    H -->|NO| K{"Recent Drug/Toxin<br/>Exposure History?"}
    
    I --> L["Advanced Stroke Care<br/>Consider Intervention"]
    J --> M["Lumbar Puncture<br/>(after CT if no ICP)"]
    K -->|YES| N["Empiric Reversal<br/>Naloxone/Flumazenil"]
    K -->|NO| O["Metabolic Workup<br/>Comprehensive Labs"]
    
    M --> P["Meningitis/Encephalitis<br/>Treatment Protocol"]
    N --> Q{"Response to<br/>Reversal Agents?"}
    O --> R{"Metabolic Cause<br/>Identified?"}
    
    Q -->|YES| S["Continue Antidote<br/>Monitor Recovery"]
    Q -->|NO| T["Expanded Differential<br/>Advanced Testing"]
    R -->|YES| U["Treat Specific<br/>Metabolic Disorder"]
    R -->|NO| T
    
    L --> V["ICU/Stroke Unit<br/>Specialized Care"]
    P --> V
    S --> W["Monitor Recovery<br/>Disposition Planning"]
    T --> X["MRI/EEG/LP<br/>Specialist Consult"]
    U --> W
    
    X --> Y["Neurology/Psychiatry<br/>Advanced Evaluation"]
    W --> Z["Disposition Based<br/>on Underlying Cause"]
    V --> Z
    Y --> Z
    
    style A fill:#ffcccc
    style B fill:#ffe6cc
    style G fill:#fff2cc
    style J fill:#ccffcc
    style N fill:#e6ccff
    style V fill:#ccffee
~~~

## STREAMLINED DYNAMIC CARD SYSTEM

### Card 0 – AMS Recognition & Initial Assessment (Node A → B)
┌─────────────────────────────────────────┐
│ 🧠 ALTERED MENTAL STATUS RRT            │
├─────────────────────────────────────────┤
│ 📊 Recognition criteria:                │
│ • Acute change from baseline           │
│ • Altered consciousness/awareness       │
│ • Confusion, disorientation            │
│ • Abnormal behavior patterns           │
│                                         │
│ 🚨 ABC Assessment (Priority #1):        │
│ • Airway: Protect if GCS ≤8           │
│ • Breathing: Assess respiratory status │
│ • Circulation: Check perfusion/BP      │
│ • Disability: GCS calculation          │
│                                         │
│ 📈 Glasgow Coma Scale:                  │
│ • Eye opening (1-4)                    │
│ • Verbal response (1-5)                │
│ • Motor response (1-6)                 │
│ • Total score /15                      │
│                                         │
│ [Next: Immediate stabilization ▶]      │
└─────────────────────────────────────────┘

### Card 1 – Immediate Stabilization (Node B → C)
┌─────────────────────────────────────────┐
│ 🚀 IMMEDIATE STABILIZATION PROTOCOL     │
├─────────────────────────────────────────┤
│ 🍬 Glucose assessment (STAT):           │
│ • Fingerstick glucose immediately      │
│ • Critical: <60 or >400 mg/dL          │
│ • Don't delay for lab confirmation     │
│                                         │
│ 📊 Vital signs assessment:              │
│ • Temperature (fever = infection?)     │
│ • Blood pressure (HTN emergency?)      │
│ • Pulse oximetry (hypoxia?)            │
│ • Respiratory rate (CO2 retention?)    │
│                                         │
│ 💨 Oxygen support:                      │
│ • Apply if SpO2 <94%                   │
│ • Consider airway protection if needed │
│ • IV access establishment              │
│                                         │
│ [Next: Glucose emergency check ▶]      │
│                                         │
│ [◀ Previous: Recognition]              │
└─────────────────────────────────────────┘

### Card 2A – Glucose Emergency Treatment (Node D → E)
┌─────────────────────────────────────────┐
│ 🍯 GLUCOSE EMERGENCY MANAGEMENT          │
├─────────────────────────────────────────┤
│ 🔽 Hypoglycemia (<60 mg/dL):            │
│ • D50: 25-50mL IV bolus                │
│ • Thiamine 100mg IV (before glucose!)  │
│ • Repeat glucose in 15 minutes         │
│ • Continuous glucose monitoring        │
│                                         │
│ 🔺 Severe hyperglycemia (>400 mg/dL):   │
│ • Normal saline 1-2L bolus             │
│ • Regular insulin 0.1 units/kg/hr      │
│ • Check ketones and ABG               │
│ • Electrolyte monitoring q2h           │
│                                         │
│ 💊 Thiamine protocol (alcohol risk):    │
│ • Always give before glucose           │
│ • Prevents Wernicke encephalopathy     │
│ • 100mg IV push                        │
│                                         │
│ [Next: Focused neurologic exam ▶]      │
│                                         │
│ [◀ Previous: Stabilization]            │
└─────────────────────────────────────────┘

### Card 3 – Focused History & Neurologic Exam (Node E → F)
┌─────────────────────────────────────────┐
│ 🩺 NEUROLOGIC EXAMINATION               │
├─────────────────────────────────────────┤
│ 📝 Essential history (from witnesses):  │
│ • Baseline mental status               │
│ • Time course of change                │
│ • Recent medications/changes            │
│ • Substance use history                │
│ • Recent illness/procedures            │
│                                         │
│ 🔍 Focused neurologic exam:             │
│ • Mental status: Orientation, attention│
│ • Cranial nerves: Pupils, eye movements│
│ • Motor: Strength, tone, reflexes      │
│ • Sensory: Response to stimulation     │
│ • Coordination: Finger-to-nose         │
│                                         │
│ 📊 Key assessments:                     │
│ • FAST-ED stroke screen                │
│ • Meningeal signs (neck stiffness)     │
│ • Signs of increased ICP               │
│                                         │
│ [Next: Focal deficit assessment ▶]     │
│                                         │
│ [◀ Previous: Glucose Treatment]        │
└─────────────────────────────────────────┘

### Card 4A – Stroke Protocol Activation (Node G → I)
┌─────────────────────────────────────────┐
│ 🚨 STROKE PROTOCOL ACTIVATION           │
├─────────────────────────────────────────┤
│ 🎯 Focal neurologic findings present:   │
│ • Unilateral weakness                  │
│ • Facial droop                         │
│ • Speech abnormalities                 │
│ • Visual field defects                 │
│ • Gaze deviation                       │
│                                         │
│ 📞 Immediate actions:                   │
│ • Code Stroke activation               │
│ • Sevaro Teleneurology: 856-247-3098   │
│ • CT head STAT (within 25 minutes)     │
│ • NPO status                           │
│                                         │
│ ⏱️ Time targets:                        │
│ • Door-to-CT: <25 minutes              │
│ • Door-to-needle: <60 minutes          │
│ • NIHSS assessment                     │
│                                         │
│ [Next: Advanced stroke care ▶]         │
│                                         │
│ [◀ Previous: Neurologic Exam]          │
└─────────────────────────────────────────┘

### Card 4B – CNS Infection Evaluation (Node J → M)
┌─────────────────────────────────────────┐
│ 🦠 CNS INFECTION ASSESSMENT             │
├─────────────────────────────────────────┤
│ 🌡️ Fever + AMS indicators:              │
│ • Temperature >38°C (100.4°F)          │
│ • Neck stiffness (nuchal rigidity)     │
│ • Photophobia                          │
│ • Headache with AMS                    │
│                                         │
│ 💊 Empiric antibiotic therapy:          │
│ • Don't delay for lumbar puncture!     │
│ • Age <50: Ceftriaxone 2g IV q12h      │
│            + Vancomycin 15-20mg/kg     │
│ • Age ≥50: Add Ampicillin 2g IV q4h    │
│ • HSV risk: Add Acyclovir 10mg/kg q8h  │
│                                         │
│ 💊 Dexamethasone protocol:              │
│ • 0.15mg/kg IV q6h × 4 days            │
│ • Give before or with first antibiotic │
│                                         │
│ [Next: Lumbar puncture evaluation ▶]   │
│                                         │
│ [◀ Previous: Neurologic Exam]          │
└─────────────────────────────────────────┘

### Card 4C – Toxicologic Assessment (Node K → N)
┌─────────────────────────────────────────┐
│ ☠️ TOXICOLOGIC CAUSE EVALUATION         │
├─────────────────────────────────────────┤
│ 🔍 High-risk medication/substance history:│
│ • Opioid medications or illicit use    │
│ • Benzodiazepine medications           │
│ • Alcohol use disorder                 │
│ • New psychiatric medications          │
│ • Recent anesthesia/procedures         │
│                                         │
│ 🔬 Clinical toxidromes:                 │
│ • Opioids: Pinpoint pupils, ↓RR       │
│ • Anticholinergic: Dry, flushed, dilated│
│ • Cholinergic: SLUDGE symptoms         │
│ • Sympathomimetic: Agitation, ↑HR/BP   │
│                                         │
│ 📊 Laboratory studies:                  │
│ • Comprehensive toxicology screen       │
│ • Acetaminophen and salicylate levels  │
│ • Ethanol level                        │
│                                         │
│ [Next: Empiric reversal agents ▶]      │
│                                         │
│ [◀ Previous: Neurologic Exam]          │
└─────────────────────────────────────────┘

### Card 5A – Advanced Stroke Care (Node L → V)
┌─────────────────────────────────────────┐
│ 🧠 ADVANCED STROKE MANAGEMENT           │
├─────────────────────────────────────────┤
│ 📸 CT head interpretation:              │
│ • Rule out intracranial hemorrhage     │
│ • Early ischemic changes               │
│ • Mass effect or midline shift         │
│                                         │
│ 🎯 Treatment considerations:             │
│ • IV thrombolysis (TNK preferred)      │
│ • Mechanical thrombectomy evaluation   │
│ • Blood pressure management           │
│ • Antiplatelet therapy timing         │
│                                         │
│ 📞 Specialist coordination:             │
│ • Neurology consultation              │
│ • Interventional neuroradiology       │
│ • Intensive care unit                 │
│                                         │
│ ✅ STROKE PROTOCOL ACTIVE              │
│                                         │
│ [◀ Previous: Stroke Activation]        │
└─────────────────────────────────────────┘

### Card 5B – Lumbar Puncture Protocol (Node M → P)
┌─────────────────────────────────────────┐
│ 💉 LUMBAR PUNCTURE EVALUATION           │
├─────────────────────────────────────────┤
│ ✅ LP indications:                      │
│ • Suspected meningitis/encephalitis     │
│ • Subarachnoid hemorrhage (CT negative) │
│ • Fever + AMS without clear source     │
│                                         │
│ 🚫 LP contraindications:                │
│ • Signs of increased ICP               │
│ • Coagulopathy (INR >1.5, plt <50K)    │
│ • Infection at puncture site           │
│ • Hemodynamic instability              │
│                                         │
│ 📊 CSF analysis priorities:             │
│ • Cell count with differential         │
│ • Glucose and protein                  │
│ • Bacterial culture and gram stain     │
│ • HSV PCR, cryptococcal antigen        │
│                                         │
│ [Next: Meningitis treatment ▶]         │
│                                         │
│ [◀ Previous: CNS Infection]            │
└─────────────────────────────────────────┘

### Card 6A – Empiric Reversal Agents (Node N → Q)
┌─────────────────────────────────────────┐
│ 🔄 EMPIRIC ANTIDOTE ADMINISTRATION      │
├─────────────────────────────────────────┤
│ 💊 Naloxone (opioid reversal):          │
│ • Dose: 0.4-2mg IV/IM/IN               │
│ • Start low to avoid withdrawal        │
│ • Duration: 30-90 minutes              │
│ • May need repeat dosing               │
│                                         │
│ 💊 Flumazenil (benzodiazepine reversal): │
│ • Dose: 0.2mg IV over 30 seconds       │
│ • Max: 1mg total dose                  │
│ • ⚠️ CAUTION: Seizure risk in chronic users│
│                                         │
│ 💊 Thiamine (always give):               │
│ • 100mg IV before any glucose          │
│ • Prevents Wernicke encephalopathy     │
│ • Especially important with alcohol    │
│                                         │
│ [Next: Response assessment ▶]          │
│                                         │
│ [◀ Previous: Toxicologic Assessment]   │
└─────────────────────────────────────────┘

### Card 6B – Metabolic Workup (Node O → R)
┌─────────────────────────────────────────┐
│ 🧪 COMPREHENSIVE METABOLIC EVALUATION   │
├─────────────────────────────────────────┤
│ 📊 Essential laboratory studies:        │
│ • Complete metabolic panel             │
│ • Liver function tests                 │
│ • Ammonia level                        │
│ • Thyroid function (TSH, free T4)      │
│ • Vitamin B12 and folate               │
│                                         │
│ 🔬 Additional tests if indicated:       │
│ • Arterial blood gas                   │
│ • Magnesium and phosphorus             │
│ • Cortisol (random or stimulation)     │
│ • Urinalysis and culture               │
│                                         │
│ 🎯 Common metabolic causes:             │
│ • Hyponatremia (<120 mEq/L)            │
│ • Severe renal failure (uremia)        │
│ • Hepatic encephalopathy (↑NH3)        │
│ • Thyroid disorders                    │
│                                         │
│ [Next: Specific treatment ▶]           │
│                                         │
│ [◀ Previous: Neurologic Exam]          │
└─────────────────────────────────────────┘

### Card 7A – Meningitis Treatment Protocol (Node P → V)
┌─────────────────────────────────────────┐
│ 🦠 MENINGITIS/ENCEPHALITIS TREATMENT    │
├─────────────────────────────────────────┤
│ 💊 Antimicrobial therapy:               │
│ • Continue empiric antibiotics started │
│ • Adjust based on CSF results          │
│ • Duration: 7-21 days depending on organism│
│                                         │
│ 💊 Anti-inflammatory therapy:           │
│ • Dexamethasone: Continue if started   │
│ • Reduces complications in bacterial   │
│ • Not indicated for viral meningitis   │
│                                         │
│ 🏥 Supportive care:                     │
│ • ICU monitoring if severe             │
│ • Seizure precautions                  │
│ • ICP monitoring if indicated          │
│ • Isolation as appropriate             │
│                                         │
│ ✅ CNS INFECTION PROTOCOL ACTIVE       │
│                                         │
│ [◀ Previous: Lumbar Puncture]          │
└─────────────────────────────────────────┘

### Card 7B – Antidote Response Assessment (Node Q)
┌─────────────────────────────────────────┐
│ 📊 REVERSAL AGENT RESPONSE              │
├─────────────────────────────────────────┤
│ ✅ Positive response indicators:         │
│ • Improved level of consciousness      │
│ • Better GCS score                     │
│ • Normalized vital signs               │
│ • Appropriate responses                │
│                                         │
│ ⚠️ Partial/no response indicators:       │
│ • Minimal improvement                  │
│ • Mixed clinical picture               │
│ • Other causes likely                  │
│                                         │
│ ❓ Adequate response to reversal?       │
│                                         │
│ 🔘 YES → Continue monitoring & support │
│ 🔘 NO → Expanded differential workup   │
│                                         │
│ 💡 Consider:                            │
│ • Multiple ingestions                  │
│ • Delayed absorption                   │
│ • Structural brain pathology           │
│                                         │
│ [◀ Previous] [Next: Based on Selection ▶]│
└─────────────────────────────────────────┘

### Card 8A – Specific Metabolic Treatment (Node U → W)
┌─────────────────────────────────────────┐
│ 🎯 METABOLIC DISORDER TREATMENT          │
├─────────────────────────────────────────┤
│ 🧂 Hyponatremia correction:             │
│ • Rate: 6-8 mEq/L per 24 hours         │
│ • 3% saline if severe symptoms         │
│ • Monitor closely for CPM              │
│                                         │
│ 🫘 Hepatic encephalopathy:               │
│ • Lactulose 30mL PO q2h until BM      │
│ • Rifaximin 550mg PO BID               │
│ • Protein restriction contraindicated  │
│                                         │
│ 🦋 Thyroid emergencies:                  │
│ • Myxedema coma: T4 + T3 + steroids    │
│ • Thyroid storm: Methimazole + beta-blockers│
│                                         │
│ [Next: Monitor recovery ▶]             │
│                                         │
│ [◀ Previous: Metabolic Workup]          │
└─────────────────────────────────────────┘

### Card 8B – Expanded Differential Testing (Node T → X)
┌─────────────────────────────────────────┐
│ 🔬 ADVANCED DIAGNOSTIC EVALUATION       │
├─────────────────────────────────────────┤
│ 🧠 Advanced neuroimaging:               │
│ • MRI brain with and without contrast  │
│ • MR angiography if vascular suspected │
│ • CT perfusion if stroke possible      │
│                                         │
│ ⚡ Electroencephalogram (EEG):           │
│ • Rule out non-convulsive seizures     │
│ • Continuous monitoring if indicated   │
│ • Metabolic encephalopathy patterns    │
│                                         │
│ 💉 Additional lumbar puncture:          │
│ • If CNS infection still suspected     │
│ • Autoimmune/paraneoplastic workup     │
│ • Cytology if malignancy suspected     │
│                                         │
│ [Next: Specialist consultation ▶]      │
│                                         │
│ [◀ Previous: Response Assessment]      │
└─────────────────────────────────────────┘

### Card 9A – Recovery Monitoring (Node W → Z)
┌─────────────────────────────────────────┐
│ 📈 RECOVERY MONITORING & SUPPORT        │
├─────────────────────────────────────────┤
│ 📊 Progress indicators:                 │
│ • Improving GCS score                  │
│ • Return to baseline orientation       │
│ • Stable vital signs                   │
│ • Resolved metabolic abnormalities     │
│                                         │
│ 🔄 Ongoing management:                  │
│ • Continue specific treatments         │
│ • Monitor for complications            │
│ • Prevent further episodes             │
│                                         │
│ 📋 Discharge planning:                  │
│ • Medication reconciliation            │
│ • Follow-up appointments               │
│ • Family education                     │
│ • Safety precautions                   │
│                                         │
│ [Next: Disposition planning ▶]         │
│                                         │
│ [◀ Previous: Specific Treatment]       │
└─────────────────────────────────────────┘

### Card 9B – Specialist Consultation (Node Y → Z)
┌─────────────────────────────────────────┐
│ 👨‍⚕️ SPECIALIST CONSULTATION              │
├─────────────────────────────────────────┤
│ 🧠 Neurology consultation:              │
│ • Complex altered mental status        │
│ • Seizure evaluation                   │
│ • Encephalitis management              │
│                                         │
│ 🧠 Psychiatry consultation:             │
│ • Conversion disorder                  │
│ • Psychotic episodes                   │
│ • Catatonia                            │
│                                         │
│ 🔬 Additional specialists:              │
│ • Endocrinology (metabolic causes)     │
│ • Infectious disease (CNS infections)  │
│ • Toxicology (complex poisonings)      │
│                                         │
│ [Next: Disposition planning ▶]         │
│                                         │
│ [◀ Previous: Advanced Testing]         │
└─────────────────────────────────────────┘

### Card 10 – Disposition Planning (Node Z - Final)
┌─────────────────────────────────────────┐
│ 🏥 DISPOSITION & FOLLOW-UP PLANNING     │
├─────────────────────────────────────────┤
│ 📍 Disposition options:                 │
│                                         │
│ 🔴 ICU admission:                       │
│ • GCS <9 or declining                  │
│ • Hemodynamic instability             │
│ • Requiring intensive monitoring       │
│ • Post-stroke intervention             │
│                                         │
│ 🟡 Telemetry/Step-down:                 │
│ • Stable but requires monitoring       │
│ • Medication titration needed          │
│ • Cardiac arrhythmia risk              │
│                                         │
│ 🟢 Medical floor:                       │
│ • Stable, identified cause             │
│ • Minimal ongoing intervention         │
│ • Social/family support needed         │
│                                         │
│ 📋 Follow-up coordination:              │
│ • Neurology: 1-2 weeks if indicated    │
│ • Primary care: Within 1 week          │
│ • Specialist referrals as needed       │
│                                         │
│ ✅ AMS PROTOCOL COMPLETE               │
│                                         │
│ [◀ Previous: Treatment Pathways]       │
└─────────────────────────────────────────┘

## VIRTUA VOORHEES ALTERED MENTAL STATUS ADDENDA

### **Enhanced RRT Response Program:**
- **Rapid Response Team:** Immediate multidisciplinary activation including critical care, neurology access
- **Point-of-Care Testing:** Bedside glucose, ABG, and basic metabolic panels available
- **Stroke Integration:** Seamless transition to Code Stroke protocol with teleneurology support
- **Quality Metrics:** Time to glucose check, GCS documentation, appropriate workup completion

### **Neurologic Assessment Optimization:**
**Glasgow Coma Scale Integration:**
- **Digital scoring:** Automated calculation with trend monitoring
- **Baseline comparison:** Electronic record integration for change documentation
- **Alert thresholds:** Automatic notification for significant changes (≥2 point drop)

**Stroke Protocol Integration:**
- **FAST-ED screening:** Incorporated into initial RRT assessment
- **Code Stroke activation:** Direct communication with Sevaro Teleneurology (856-247-3098)
- **Time-critical imaging:** STAT CT head within 25 minutes of recognition

### **Advanced Diagnostic Capabilities:**
**Laboratory Services:**
- **Point-of-care glucose:** Available on all RRT carts
- **STAT laboratory:** Comprehensive metabolic panel results within 60 minutes
- **Toxicology screening:** Comprehensive panel including newer synthetic drugs

**Imaging Integration:**
- **CT head:** Available 24/7 with immediate interpretation
- **MRI brain:** Urgent studies available with neurologist consultation
- **EEG monitoring:** Continuous monitoring capability for seizure evaluation

### **Pharmacologic Intervention Protocols:**
**Empiric Treatment Guidelines:**
- **Thiamine administration:** 100mg IV before any glucose administration
- **Naloxone protocol:** Weight-based dosing with graduated titration
- **Antibiotic timing:** Empiric therapy within 60 minutes of CNS infection suspicion

**Reversal Agent Safety:**
- **Flumazenil cautions:** Detailed screening for chronic benzodiazepine use
- **Naloxone monitoring:** Observation for withdrawal symptoms and re-sedation
- **Antidote availability:** Emergency antidotes readily available in pharmacy

### **Delirium Assessment Integration:**
**CAM-ICU Protocol:**
- **Structured assessment:** Standardized tool for delirium screening
- **Risk factor identification:** Medication review, infection screening
- **Non-pharmacologic interventions:** Sleep hygiene, reorientation, mobility

**Delirium Prevention:**
- **Medication review:** Identify and minimize deliriogenic medications
- **Environmental modifications:** Noise reduction, lighting optimization
- **Family involvement:** Encourage familiar face presence

### **Stroke Network Integration:**
**Sevaro Teleneurology Partnership:**
- **24/7 availability:** 856-247-3098 with <45 second response time
- **Video consultation:** Real-time neurologic assessment capability
- **Decision support:** Thrombolysis and thrombectomy recommendations

**Transfer Protocols:**
- **Advanced stroke centers:** Direct transfer arrangements for interventional therapy
- **Mobile stroke units:** Coordination with regional mobile stroke response
- **Quality tracking:** Door-to-needle and transfer times monitoring

### **CNS Infection Management:**
**Antibiotic Stewardship:**
- **Empiric protocols:** Age and risk-factor based antibiotic selection
- **Steroid timing:** Dexamethasone administration with or before first antibiotic dose
- **Culture optimization:** CSF, blood, and urine cultures before antimicrobials

**Lumbar Puncture Safety:**
- **Contraindication screening:** Automated checklist for safety assessment
- **Coagulation monitoring:** INR and platelet count verification
- **Post-procedure monitoring:** Standardized observation protocol

### **Metabolic Emergency Protocols:**
**Glucose Management:**
- **Hypoglycemia protocol:** D50 administration with thiamine pretreatment
- **DKA/HHS recognition:** Automated screening for ketoacidosis
- **Continuous monitoring:** Glucose trend analysis with alert parameters

**Electrolyte Correction:**
- **Hyponatremia management:** Careful correction rate monitoring (6-8 mEq/L/24h)
- **Critical value alerts:** Automated notification for life-threatening abnormalities
- **Specialist consultation:** Endocrinology availability for complex cases

### **Quality Improvement Integration:**
**Performance Metrics:**
- **Recognition time:** Goal <5 minutes from RRT activation to AMS assessment
- **Glucose check:** Goal <3 minutes from patient contact
- **Stroke activation:** Goal <15 minutes for appropriate candidates
- **Antibiotic administration:** Goal <60 minutes for suspected CNS infection

**Documentation Standards:**
- **Baseline comparison:** Electronic health record integration for mental status changes
- **Timeline documentation:** Precise timing of symptom onset and progression
- **Response tracking:** Medication administration and clinical response documentation

### **Family Communication Protocol:**
- **Information gathering:** Structured interview for baseline function and recent changes
- **Progress updates:** Regular communication regarding evaluation and treatment
- **Discharge planning:** Family education on ongoing care needs and follow-up requirements

## REFERENCE GUIDELINES
- **2023 American Academy of Neurology Practice Guidelines for Cognitive Assessment**
- **2025 Emergency Neurological Life Support (ENLS) Altered Mental Status Guidelines**
- **2023 American Delirium Society Clinical Practice Guidelines**
- **Virtua Health System Altered Mental Status Protocol v2025**

**This comprehensive protocol integrates current evidence-based approaches to altered mental status evaluation with rapid diagnostic capabilities, stroke network integration, and advanced therapeutic interventions optimized for the Virtua Voorhees clinical environment.**
