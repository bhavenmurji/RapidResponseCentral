# Shortness of Breath/Hypoxia – RRT Protocol with Virtua Voorhees Addenda

**Primary Guideline:** European Society of Intensive Care Medicine (ESICM) Guidelines on Acute Respiratory Distress Syndrome 2023
**Official Source:** https://pmc.ncbi.nlm.nih.gov/articles/PMC10354163/
**Supporting Guidelines:**
- BTS/NICE/SIGN Joint Guideline on Asthma: Diagnosis, Monitoring and Chronic Management 2024
- Global Initiative for Chronic Obstructive Lung Disease (GOLD) 2023 Report
- American Thoracic Society/European Respiratory Society Clinical Practice Guidelines for Acute Respiratory Failure 2017 (Updated 2023)

## ENHANCED MERMAID FLOWCHART ALGORITHM

~~~mermaid
graph TD
    A["Respiratory Distress<br/>RR >20, SpO2 <95%"] --> B["ABC Assessment<br/>O2 Therapy + Monitoring"]
    
    B --> C["Initial Stabilization<br/>High-Flow O2, IV Access"]
    
    C --> D{"Immediate<br/>Life Threat?"}
    
    D -->|YES| E["Advanced Airway<br/>RSI Protocol"]
    D -->|NO| F["Focused Assessment<br/>History + Physical"]
    
    E --> G["Mechanical Ventilation<br/>Lung-Protective Strategy"]
    F --> H{"Primary<br/>Etiology?"}
    
    H -->|OBSTRUCTIVE| I["Bronchodilator Therapy<br/>Corticosteroids"]
    H -->|CARDIAC| J["Diuretics + Preload<br/>Reduction"]
    H -->|PARENCHYMAL| K["HFNO vs NIV<br/>Supportive Care"]
    H -->|MIXED| L["Treat Dominant<br/>Component First"]
    
    I --> M{"COPD vs<br/>Asthma?"}
    J --> N{"Flash Pulmonary<br/>Edema?"}
    K --> O{"Type of<br/>Respiratory Failure?"}
    L --> P["Combined Therapy<br/>Monitor Response"]
    
    M -->|COPD| Q["LABA/LAMA + Steroids<br/>Consider NIV"]
    M -->|ASTHMA| R["High-Dose Bronchodilators<br/>Systemic Steroids"]
    N -->|YES| S["BiPAP + Aggressive<br/>Diuresis"]
    N -->|NO| T["Standard HF Management<br/>ACE-I + Diuretics"]
    
    O -->|"TYPE I"| U["HFNO ≥30L/min<br/>Treat Underlying Cause"]
    O -->|"TYPE II"| V["NIV/BiPAP<br/>Ventilatory Support"]
    
    Q --> W{"Adequate<br/>Response?"}
    R --> W
    S --> W
    T --> W
    U --> W
    V --> W
    P --> W
    
    W -->|YES| X["Continue Treatment<br/>Wean Support"]
    W -->|NO| Y["Escalate Care<br/>Consider Intubation"]
    
    X --> Z["Disposition<br/>Based on Stability"]
    Y --> AA["RSI Protocol<br/>ICU Management"]
    G --> AA
    
    AA --> BB["Mechanical Ventilation<br/>ARDS Protocol if Indicated"]
    
    style A fill:#ffcccc
    style B fill:#ffe6cc
    style E fill:#ffaaaa
    style I fill:#fff2cc
    style J fill:#ccffcc
    style K fill:#e6ccff
    style AA fill:#ccffee
~~~

## STREAMLINED DYNAMIC CARD SYSTEM

### Card 0 – Respiratory Distress Recognition & Initial Assessment (Node A → B)
┌─────────────────────────────────────────┐
│ 🫁 RESPIRATORY DISTRESS RRT ACTIVATION   │
├─────────────────────────────────────────┤
│ 📊 Recognition criteria:                │
│ • Respiratory rate >20/min             │
│ • SpO2 <95% on room air                │
│ • Accessory muscle use                 │
│ • Patient reporting dyspnea            │
│ • Altered mental status                │
│                                         │
│ 🚨 ABC Assessment (Priority #1):        │
│ • Airway: Patent, protect if altered   │
│ • Breathing: Work of breathing, pattern│
│ • Circulation: Perfusion, vital signs  │
│ • Disability: Mental status changes    │
│                                         │
│ 💨 Immediate oxygen therapy:            │
│ • Target SpO2: >92% (88-92% if COPD)   │
│ • Start with appropriate delivery method│
│ • Escalate based on response           │
│                                         │
│ [Next: Initial stabilization ▶]        │
└─────────────────────────────────────────┘

### Card 1 – Initial Stabilization (Node C → D)
┌─────────────────────────────────────────┐
│ 🚀 INITIAL STABILIZATION PROTOCOL       │
├─────────────────────────────────────────┤
│ 💨 Oxygen delivery optimization:        │
│ • Nasal cannula: 1-6L/min              │
│ • Simple mask: 5-10L/min               │
│ • Non-rebreather: 15L/min              │
│ • High-flow nasal cannula: 30-60L/min  │
│                                         │
│ 📊 Monitoring establishment:            │
│ • Continuous pulse oximetry            │
│ • Cardiac monitoring                   │
│ • Blood pressure monitoring            │
│ • IV access × 2                        │
│                                         │
│ 📋 Essential orders:                    │
│ • Portable chest X-ray                │
│ • Arterial blood gas                   │
│ • BNP or NT-proBNP                     │
│ • Complete blood count                 │
│                                         │
│ [Next: Life threat assessment ▶]       │
│                                         │
│ [◀ Previous: Recognition]              │
└─────────────────────────────────────────┘

### Card 2A – Advanced Airway Management (Node E → G)
┌─────────────────────────────────────────┐
│ 🚨 ADVANCED AIRWAY MANAGEMENT           │
├─────────────────────────────────────────┤
│ 🎯 Immediate intubation indications:    │
│ • Impending respiratory failure        │
│ • Altered mental status (GCS ≤8)       │
│ • Hemodynamic instability              │
│ • Failed non-invasive ventilation      │
│                                         │
│ 🔗 RSI Protocol activation:             │
│ • [LINK TO RSI PROTOCOL]               │
│ • Pre-oxygenation optimization         │
│ • Rapid sequence intubation            │
│ • Post-intubation sedation             │
│                                         │
│ 🫁 Lung-protective ventilation:         │
│ • Tidal volume: 6-8 mL/kg PBW          │
│ • Plateau pressure <30 cmH2O           │
│ • PEEP optimization                    │
│                                         │
│ [Next: Mechanical ventilation ▶]       │
│                                         │
│ [◀ Previous: Life Threat Assessment]   │
└─────────────────────────────────────────┘

### Card 2B – Focused Assessment (Node F → H)
┌─────────────────────────────────────────┐
│ 🩺 FOCUSED RESPIRATORY ASSESSMENT       │
├─────────────────────────────────────────┤
│ 📝 Essential history:                   │
│ • Onset: Acute vs chronic              │
│ • Triggers: Exertion, allergens        │
│ • Associated symptoms: Chest pain, fever│
│ • Past medical history: Asthma, COPD, HF│
│ • Medications: Recent changes           │
│                                         │
│ 🔍 Focused physical exam:               │
│ • Vital signs with respiratory rate    │
│ • Chest inspection and auscultation    │
│ • Cardiac examination (S3, murmurs)    │
│ • Extremity examination (edema, cyanosis)│
│                                         │
│ 📊 Point-of-care assessments:           │
│ • Pulse oximetry trending              │
│ • Peak flow if able                    │
│ • POCUS lung/cardiac if available      │
│                                         │
│ [Next: Etiology determination ▶]       │
│                                         │
│ [◀ Previous: Initial Stabilization]    │
└─────────────────────────────────────────┘

### Card 3A – Obstructive Disease Management (Node I → M)
┌─────────────────────────────────────────┐
│ 🌪️ OBSTRUCTIVE AIRWAY DISEASE           │
├─────────────────────────────────────────┤
│ 💊 Bronchodilator therapy:              │
│ • Albuterol 2.5-5mg nebulizer q20min   │
│ • Ipratropium 0.5mg neb with albuterol │
│ • Consider continuous albuterol if severe│
│                                         │
│ 💊 Corticosteroid therapy:              │
│ • Methylprednisolone 125mg IV q6h       │
│ • Or prednisolone 40-80mg PO daily     │
│ • Duration: 5-7 days typically         │
│                                         │
│ 💊 Adjunctive therapies:                │
│ • Magnesium sulfate 2g IV over 20min   │
│ • Consider heliox if available         │
│ • Avoid sedatives in acute setting     │
│                                         │
│ [Next: COPD vs Asthma classification ▶]│
│                                         │
│ [◀ Previous: Etiology Assessment]      │
└─────────────────────────────────────────┘

### Card 3B – Cardiac Etiology Management (Node J → N)
┌─────────────────────────────────────────┐
│ 💓 CARDIAC ETIOLOGY MANAGEMENT          │
├─────────────────────────────────────────┤
│ 💊 Diuretic therapy:                    │
│ • Furosemide 40mg IV (or 2× home dose) │
│ • May give 80-160mg IV for acute cases │
│ • Monitor electrolytes and renal function│
│                                         │
│ 💊 Preload reduction:                   │
│ • Nitroglycerin 0.4mg SL q5min × 3     │
│ • Or nitroglycerin 10-20 mcg/min IV    │
│ • Avoid if hypotensive                 │
│                                         │
│ 📊 Diagnostic workup:                   │
│ • BNP/NT-proBNP levels                 │
│ • Echocardiogram if available          │
│ • 12-lead ECG for ischemia             │
│                                         │
│ [Next: Flash pulmonary edema check ▶]  │
│                                         │
│ [◀ Previous: Etiology Assessment]      │
└─────────────────────────────────────────┘

### Card 3C – Parenchymal Disease Management (Node K → O)
┌─────────────────────────────────────────┐
│ 🫁 PARENCHYMAL LUNG DISEASE             │
├─────────────────────────────────────────┤
│ 🌊 High-flow nasal cannula (2023 update):│
│ • Flow rate: ≥30 L/min minimum          │
│ • FiO2: Start 60-80%, titrate to target│
│ • Temperature: 37°C for comfort        │
│ • Preferred over standard O2 therapy   │
│                                         │
│ 😷 Non-invasive ventilation option:     │
│ • Consider if HFNO inadequate          │
│ • BIPAP: IPAP 10-15, EPAP 5-8 cmH2O    │
│ • Monitor for intolerance              │
│                                         │
│ 💊 Supportive care:                     │
│ • Antibiotics if infection suspected   │
│ • Corticosteroids for specific conditions│
│ • Avoid excessive fluid administration │
│                                         │
│ [Next: Respiratory failure type ▶]     │
│                                         │
│ [◀ Previous: Etiology Assessment]      │
└─────────────────────────────────────────┘

### Card 4A – COPD Management (Node Q → W)
┌─────────────────────────────────────────┐
│ 🫁 COPD EXACERBATION (GOLD 2023)        │
├─────────────────────────────────────────┤
│ 💊 Updated bronchodilator protocol:     │
│ • LABA/LAMA combination preferred      │
│ • Albuterol/ipratropium 2.5/0.5mg neb │
│ • May use continuous nebulizers        │
│                                         │
│ 💊 Corticosteroid therapy (2023 update):│
│ • Prednisolone 40mg daily × 5 days     │
│ • Avoid longer courses                 │
│ • Consider blood eosinophils >300/μL   │
│                                         │
│ 😷 NIV consideration (Type II RF):       │
│ • pH 7.25-7.35 with hypercapnia       │
│ • BIPAP: IPAP 15-25, EPAP 4-8 cmH2O    │
│ • Reduces intubation risk significantly│
│                                         │
│ [Next: Response assessment ▶]          │
│                                         │
│ [◀ Previous: Obstructive Classification]│
└─────────────────────────────────────────┘

### Card 4B – Asthma Management (Node R → W)
┌─────────────────────────────────────────┐
│ 🌬️ ACUTE ASTHMA (BTS/NICE/SIGN 2024)   │
├─────────────────────────────────────────┤
│ 💊 High-dose bronchodilator therapy:    │
│ • Albuterol 2.5-5mg neb q20min × 3     │
│ • Add ipratropium 0.5mg to first 3 doses│
│ • Consider continuous albuterol if severe│
│                                         │
│ 💊 Systemic corticosteroids:            │
│ • Prednisolone 40-50mg PO daily        │
│ • Or hydrocortisone 200mg IV q6h       │
│ • Start early in treatment             │
│                                         │
│ 💊 Adjunctive therapies:                │
│ • Magnesium sulfate 2g IV over 20min   │
│ • Only for severe/life-threatening cases│
│ • Avoid unnecessary IV fluids          │
│                                         │
│ [Next: Response assessment ▶]          │
│                                         │
│ [◀ Previous: Obstructive Classification]│
└─────────────────────────────────────────┘

### Card 5A – Flash Pulmonary Edema (Node S → W)
┌─────────────────────────────────────────┐
│ 🌊 FLASH PULMONARY EDEMA MANAGEMENT     │
├─────────────────────────────────────────┤
│ 😷 BiPAP/CPAP (immediate):              │
│ • CPAP 10-15 cmH2O or BiPAP            │
│ • Reduces preload and afterload        │
│ • Improves oxygenation rapidly         │
│                                         │
│ 💊 Aggressive diuresis:                 │
│ • Furosemide 80-160mg IV bolus         │
│ • May repeat or use continuous infusion│
│ • Monitor for hypovolemia              │
│                                         │
│ 💊 Additional preload reduction:        │
│ • Nitroglycerin SL then IV infusion    │
│ • Consider morphine 2-4mg IV (cautiously)│
│ • Avoid ACE inhibitors acutely         │
│                                         │
│ [Next: Response assessment ▶]          │
│                                         │
│ [◀ Previous: Flash Edema Assessment]   │
└─────────────────────────────────────────┘

### Card 5B – Type I Respiratory Failure (Node U → W)
┌─────────────────────────────────────────┐
│ 🔴 TYPE I RESPIRATORY FAILURE (HYPOXEMIC)│
├─────────────────────────────────────────┤
│ 🌊 HFNC optimization (2023 guidelines):  │
│ • Flow rate: 30-60 L/min               │
│ • FiO2: Titrate to SpO2 target         │
│ • Preferred over conventional oxygen   │
│ • Monitor for clinical improvement     │
│                                         │
│ 🎯 Treat underlying causes:             │
│ • Pneumonia: Antibiotics              │
│ • PE: Anticoagulation                 │
│ • ARDS: Lung-protective strategies     │
│                                         │
│ 📊 Monitoring parameters:               │
│ • SpO2 target >92% (88-92% if COPD)    │
│ • Work of breathing assessment         │
│ • Mental status changes                │
│                                         │
│ [Next: Response assessment ▶]          │
│                                         │
│ [◀ Previous: RF Type Classification]   │
└─────────────────────────────────────────┘

### Card 5C – Type II Respiratory Failure (Node V → W)
┌─────────────────────────────────────────┐
│ 🔵 TYPE II RESPIRATORY FAILURE (HYPERCAPNIC)│
├─────────────────────────────────────────┤
│ 😷 NIV/BiPAP (2023 recommendations):    │
│ • IPAP: 15-25 cmH2O                    │
│ • EPAP: 4-8 cmH2O                      │
│ • Backup rate: 12-15/min               │
│ • FiO2: Titrate to target              │
│                                         │
│ 📊 Success indicators:                  │
│ • pH improvement >7.30                 │
│ • PaCO2 reduction                      │
│ • Reduced work of breathing            │
│                                         │
│ ⚠️ Failure indicators:                  │
│ • Worsening pH <7.25                   │
│ • Patient intolerance                  │
│ • Hemodynamic instability              │
│                                         │
│ [Next: Response assessment ▶]          │
│                                         │
│ [◀ Previous: RF Type Classification]   │
└─────────────────────────────────────────┘

### Card 6 – Treatment Response Assessment (Node W)
┌─────────────────────────────────────────┐
│ 📊 TREATMENT RESPONSE EVALUATION        │
├─────────────────────────────────────────┤
│ ✅ Positive response indicators:         │
│ • Improved SpO2 to target range        │
│ • Reduced respiratory rate             │
│ • Decreased work of breathing          │
│ • Improved mental status               │
│ • Stable or improved vital signs       │
│                                         │
│ ⚠️ Treatment failure indicators:         │
│ • Persistent hypoxemia                 │
│ • Worsening hypercapnia                │
│ • Increased work of breathing          │
│ • Hemodynamic deterioration            │
│                                         │
│ ❓ Adequate response to treatment?      │
│                                         │
│ 🔘 YES → Continue current therapy      │
│ 🔘 NO → Escalate to advanced support   │
│                                         │
│ [◀ Previous] [Next: Based on Selection ▶]│
└─────────────────────────────────────────┘

### Card 7A – Continued Treatment (Node X → Z)
┌─────────────────────────────────────────┐
│ ✅ SUCCESSFUL TREATMENT CONTINUATION     │
├─────────────────────────────────────────┤
│ 📈 Treatment optimization:              │
│ • Continue effective therapies         │
│ • Wean oxygen as tolerated             │
│ • Reduce respiratory support gradually │
│ • Monitor for rebound symptoms         │
│                                         │
│ 🔄 Ongoing assessment:                  │
│ • Vital signs q15-30min initially      │
│ • Pulse oximetry continuous            │
│ • Repeat ABG if indicated              │
│ • Chest X-ray follow-up                │
│                                         │
│ 📋 Discharge planning preparation:      │
│ • Medication reconciliation            │
│ • Follow-up appointments               │
│ • Patient education                    │
│                                         │
│ [Next: Disposition planning ▶]         │
│                                         │
│ [◀ Previous: Response Assessment]      │
└─────────────────────────────────────────┘

### Card 7B – Escalation of Care (Node Y → AA)
┌─────────────────────────────────────────┐
│ ⬆️ ESCALATION TO ADVANCED SUPPORT       │
├─────────────────────────────────────────┤
│ 🚨 Failed non-invasive management:      │
│ • Worsening respiratory status         │
│ • Unable to maintain oxygenation       │
│ • Patient exhaustion                   │
│ • Hemodynamic instability              │
│                                         │
│ 🔗 RSI Protocol preparation:            │
│ • [LINK TO RSI & ADVANCED AIRWAY]      │
│ • Pre-oxygenation optimization         │
│ • Medications prepared                 │
│ • Airway equipment ready               │
│                                         │
│ 🏥 ICU coordination:                    │
│ • Notify ICU team                      │
│ • Prepare for transfer                 │
│ • Continue support during preparation  │
│                                         │
│ [Next: Mechanical ventilation ▶]       │
│                                         │
│ [◀ Previous: Response Assessment]      │
└─────────────────────────────────────────┘

### Card 8A – Mechanical Ventilation (Node BB - Final)
┌─────────────────────────────────────────┐
│ 🫁 MECHANICAL VENTILATION & ICU CARE    │
├─────────────────────────────────────────┤
│ 🛡️ Lung-protective ventilation:         │
│ • Tidal volume: 6-8 mL/kg PBW          │
│ • Plateau pressure: <30 cmH2O          │
│ • PEEP optimization based on FiO2      │
│ • Driving pressure: <15 cmH2O          │
│                                         │
│ 📊 ARDS protocol if indicated:          │
│ • Berlin criteria assessment           │
│ • Prone positioning for severe cases   │
│ • Conservative fluid strategy          │
│ • Consider ECMO if refractory          │
│                                         │
│ 💊 Sedation and paralysis:              │
│ • Adequate sedation for comfort        │
│ • Minimize deep sedation               │
│ • Neuromuscular blockade if needed     │
│                                         │
│ 🎯 Weaning strategy:                    │
│ • Daily spontaneous breathing trials   │
│ • Minimize ventilator days             │
│ • Early mobility when appropriate      │
│                                         │
│ ✅ MECHANICAL VENTILATION ACTIVE       │
│                                         │
│ [◀ Previous: Advanced Support]         │
└─────────────────────────────────────────┘

### Card 8B – Disposition Planning (Node Z - Final)
┌─────────────────────────────────────────┐
│ 🏥 DISPOSITION & FOLLOW-UP PLANNING     │
├─────────────────────────────────────────┤
│ 📍 Disposition options:                 │
│                                         │
│ 🔴 ICU admission:                       │
│ • Mechanical ventilation required      │
│ • Hemodynamic instability             │
│ • Multiple organ dysfunction           │
│                                         │
│ 🟡 Telemetry/Step-down:                 │
│ • NIV/BiPAP requirements               │
│ • High oxygen needs                    │
│ • Frequent monitoring needed           │
│                                         │
│ 🟢 Medical floor:                       │
│ • Stable on supplemental oxygen        │
│ • Controlled symptoms                  │
│ • Low risk for deterioration           │
│                                         │
│ 🏠 Discharge considerations:             │
│ • Room air or low-flow oxygen          │
│ • Stable vital signs                   │
│ • Adequate social support              │
│                                         │
│ 📋 Follow-up coordination:              │
│ • Pulmonology: 1-2 weeks if indicated  │
│ • Primary care: Within 1 week          │
│ • Cardiology if cardiac etiology       │
│                                         │
│ ✅ DISPOSITION PROTOCOL COMPLETE       │
│                                         │
│ [◀ Previous: Continued Treatment]      │
└─────────────────────────────────────────┘

## VIRTUA VOORHEES RESPIRATORY DISTRESS ADDENDA

### **Enhanced RRT Response Program:**
- **Respiratory Therapy Integration:** 24/7 coverage with HFNC and NIV expertise
- **Advanced Equipment:** High-flow nasal cannula units on all floors
- **RSI Protocol Integration:** Seamless transition for failed non-invasive ventilation
- **Quality Metrics:** HFNC success rates, NIV failure rates, intubation avoidance

### **Updated 2023-2024 Guidelines Integration:**
**ESICM ARDS Guidelines 2023:**
- **HFNC preferred:** ≥30 L/min flow rate as first-line for acute respiratory failure[1][2]
- **NIV recommendations:** Conditional recommendation for select ARF conditions
- **Prone positioning:** Early implementation for moderate-severe ARDS
- **Conservative fluid strategy:** Recommended unless hemodynamic instability

**BTS/NICE/SIGN Asthma Guidelines 2024:**
- **Combination therapy:** ICS/formoterol preferred over SABA alone[51]
- **MART strategy:** Maintenance and reliever therapy for persistent symptoms
- **Early corticosteroids:** Systemic steroids within first hour of severe exacerbation
- **Magnesium sulfate:** Reserved for severe/life-threatening cases only

### **Advanced Respiratory Support:**
**High-Flow Nasal Cannula (Updated 2023):**
- **Flow rates:** 30-60 L/min (minimum 30 L/min per ESICM guidelines)
- **FiO2 delivery:** More precise than conventional oxygen therapy
- **Patient comfort:** Heated and humidified gas delivery
- **Efficacy:** Reduces work of breathing and improves oxygenation

**Non-Invasive Ventilation Optimization:**
- **BiPAP settings:** IPAP 15-25 cmH2O, EPAP 4-8 cmH2O for COPD
- **Success predictors:** pH >7.25, able to protect airway, cooperative patient
- **Failure criteria:** pH <7.25, hemodynamic instability, decreased consciousness

### **GOLD 2023 COPD Updates:**
**New Classification System:**
- **Group A:** Low symptoms, low exacerbation risk
- **Group B:** High symptoms, low exacerbation risk  
- **Group E:** High exacerbation risk (combines former C&D)[7][25]

**Treatment Modifications:**
- **LABA/LAMA preferred:** Initial therapy for Groups B and E
- **Eosinophil-guided:** ICS use when blood eosinophils ≥300/μL
- **Triple therapy:** LABA/LAMA/ICS for Group E with high eosinophils

### **Point-of-Care Ultrasound Integration:**
**Lung Ultrasound Applications:**
- **B-lines:** Pulmonary edema assessment
- **Consolidation:** Pneumonia diagnosis
- **Pleural effusion:** Identification and quantification
- **Pneumothorax:** Bedside diagnosis

**Cardiac Ultrasound:**
- **LV function:** Systolic function assessment
- **Right heart:** RV strain from PE or pulmonary hypertension
- **IVC assessment:** Volume status determination

### **Oxygen Delivery Hierarchy (2023 Evidence-Based):**
1. **Room air:** SpO2 >95% goal
2. **Nasal cannula:** 1-6 L/min
3. **Simple mask:** 5-10 L/min  
4. **Non-rebreather:** 15 L/min
5. **High-flow nasal cannula:** 30-60 L/min (preferred over conventional)
6. **Non-invasive ventilation:** BiPAP/CPAP
7. **Mechanical ventilation:** Lung-protective strategy

### **Quality Improvement Metrics:**
- **Recognition time:** Goal <5 minutes from RRT activation
- **HFNC initiation:** Goal <30 minutes for appropriate candidates
- **NIV success rate:** Target >80% for appropriate COPD exacerbations
- **Intubation avoidance:** Track successful non-invasive management

### **Medication Safety Updates:**
**Bronchodilator Optimization:**
- **Albuterol dosing:** 2.5-5mg nebulized, may repeat q20min × 3
- **Ipratropium addition:** 0.5mg with albuterol for first 3 doses
- **Continuous nebulizers:** For severe/life-threatening cases only

**Corticosteroid Protocols:**
- **Asthma:** Prednisolone 40-50mg daily × 5-7 days
- **COPD:** Prednisolone 40mg daily × 5 days (avoid longer courses)
- **IV option:** Hydrocortisone 200mg q6h or methylprednisolone 125mg q6h

### **Integration with Other Protocols:**
- **RSI Protocol:** Direct link for failed non-invasive ventilation
- **Shock Protocol:** For hemodynamically unstable patients
- **Code Blue:** For respiratory arrest scenarios
- **AKI Protocol:** For patients requiring aggressive diuresis

### **Special Population Considerations:**
**COPD Patients:**
- **Target SpO2:** 88-92% to avoid CO2 retention
- **NIV threshold:** pH 7.25-7.35 with hypercapnia
- **Steroid duration:** Limited to 5 days to minimize side effects

**Heart Failure Patients:**
- **Fluid restriction:** Careful monitoring of input/output
- **BiPAP benefits:** Reduces preload and afterload
- **Diuretic monitoring:** Watch for electrolyte imbalances

**Immunocompromised Patients:**
- **Early intervention:** Lower threshold for advanced support
- **Infection screening:** Comprehensive workup for opportunistic pathogens
- **Steroid caution:** Balance benefits vs immunosuppression risks

## REFERENCE GUIDELINES
- **2023 ESICM Guidelines on Acute Respiratory Distress Syndrome**
- **2024 BTS/NICE/SIGN Joint Guideline on Asthma: Diagnosis, Monitoring and Chronic Management**
- **2023 GOLD Report: Global Strategy for Diagnosis, Management and Prevention of COPD**
- **2017 ATS/ERS Clinical Practice Guidelines: Noninvasive Ventilation for Acute Respiratory Failure (Updated 2023)**
- **Virtua Health System Respiratory Distress Protocol v2025**

**This comprehensive protocol integrates the latest evidence-based respiratory failure management with advanced non-invasive support modalities, optimized for rapid recognition, appropriate escalation, and excellent patient outcomes at Virtua Voorhees.**
