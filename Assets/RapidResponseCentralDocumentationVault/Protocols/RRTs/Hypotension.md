# Hypotension & Hemorrhage – RRT Protocol with Virtua Voorhees Addenda

**Primary Guideline:** American College of Surgeons Committee on Trauma (ACS-COT) Advanced Trauma Life Support (ATLS) 2022
**Official Source:** https://www.facs.org/quality-programs/trauma/atls/
**Supporting Guidelines:**
- European Society of Anaesthesiology and Intensive Care (ESAIC) Guidelines on Management of Severe Perioperative Bleeding 2023
- Society of Critical Care Medicine (SCCM) Surviving Sepsis Campaign 2021

## ENHANCED MERMAID FLOWCHART ALGORITHM

~~~mermaid
graph TD
    A["Hypotension Recognition<br/>MAP <65 or SBP <90"] --> B["Initial Stabilization<br/>IV Access + O2 + Monitors"]
    
    B --> C["Fluid Resuscitation<br/>30 mL/kg Crystalloid Bolus"]
    
    C --> D{"Signs of Active<br/>Hemorrhage?"}
    
    D -->|YES| E["Activate MTP<br/>Control Bleeding"]
    D -->|NO| F["Evaluate Non-hemorrhagic<br/>Shock Etiology"]
    
    E --> G["Blood Products<br/>1:1:1 Ratio"]
    F --> H{"Fluid<br/>Responsive?"}
    
    G --> I{"Bleeding<br/>Controlled?"}
    H -->|YES| J["Continue Fluids<br/>Monitor Response"]
    H -->|NO| K["Vasopressor Support<br/>Identify Shock Type"]
    
    I -->|NO| L["Surgical/IR Intervention<br/>Source Control"]
    I -->|YES| M["Coagulopathy Correction<br/>Hemostasis Optimization"]
    
    K --> N{"Shock Type<br/>Classification"}
    
    N -->|DISTRIBUTIVE| O["Antibiotics + Cultures<br/>Source Control"]
    N -->|CARDIOGENIC| P["Inotropes + Echo<br/>Consider MCS"]
    N -->|HYPOVOLEMIC| Q["Volume Replacement<br/>Source Identification"]
    N -->|OBSTRUCTIVE| R["Remove Obstruction<br/>Decompress/Anticoag"]
    
    L --> S["ICU Monitoring<br/>Ongoing Resuscitation"]
    M --> S
    O --> S
    P --> T["ECMO Evaluation<br/>Refractory Shock"]
    Q --> S
    R --> S
    J --> S
    
    T --> U["Mobile ECMO<br/>Transfer Center"]
    U --> V["ECMO Cannulation<br/>Advanced Support"]
    
    style A fill:#ffcccc
    style B fill:#ffe6cc
    style E fill:#fff2cc
    style G fill:#ccffcc
    style L fill:#ffaaaa
    style P fill:#e6ccff
    style S fill:#ccffee
~~~

## STREAMLINED DYNAMIC CARD SYSTEM

### Card 0 – Hypotension Recognition & Initial Stabilization (Node A → B)
┌─────────────────────────────────────────┐
│ 🚨 HYPOTENSION RRT ACTIVATION            │
├─────────────────────────────────────────┤
│ 📊 Recognition criteria:                │
│ • MAP <65 mmHg or SBP <90 mmHg         │
│ • Signs of hypoperfusion               │
│ • Shock index >1.0                     │
│ • Oliguria <0.5 mL/kg/hr               │
│                                         │
│ 🚀 Immediate actions (<5 minutes):      │
│ • High-flow oxygen if needed           │
│ • Large-bore IV access × 2 (≥18G)      │
│ • Continuous monitoring                │
│ • Baseline vital signs                 │
│                                         │
│ 📊 Essential labs:                      │
│ • CBC, BMP, lactate                    │
│ • PT/INR, PTT, fibrinogen              │
│ • Type & crossmatch                    │
│ • ABG if indicated                     │
│                                         │
│ [Next: Fluid resuscitation ▶]          │
└─────────────────────────────────────────┘

### Card 1A – Fluid Resuscitation (Node C → D)
┌─────────────────────────────────────────┐
│ 💧 INITIAL FLUID RESUSCITATION          │
├─────────────────────────────────────────┤
│ 🎯 Fluid challenge protocol:            │
│ • 30 mL/kg crystalloid bolus           │
│ • Balanced solutions preferred         │
│ • Warm fluids if available             │
│ • Rapid infusion (<30 minutes)         │
│                                         │
│ 📊 Response assessment markers:         │
│ • Blood pressure improvement           │
│ • Heart rate reduction                 │
│ • Improved mental status               │
│ • Increased urine output               │
│                                         │
│ ⚠️ Monitor for fluid overload:          │
│ • Pulmonary edema                      │
│ • JVD elevation                        │
│ • Decreased oxygen saturation          │
│                                         │
│ [Next: Hemorrhage assessment ▶]        │
│                                         │
│ [◀ Previous: Recognition]              │
└─────────────────────────────────────────┘

### Card 2A – Hemorrhage Assessment (Node D)
┌─────────────────────────────────────────┐
│ 🩸 ACTIVE HEMORRHAGE EVALUATION          │
├─────────────────────────────────────────┤
│ 🔍 Clinical signs of bleeding:          │
│ • Obvious external bleeding            │
│ • Hematemesis, melena, hematochezia    │
│ • Abdominal distension/rigidity        │
│ • Retroperitoneal hematoma signs       │
│                                         │
│ 📊 Laboratory indicators:               │
│ • Dropping hemoglobin trend            │
│ • Rising lactate levels                │
│ • Coagulopathy (↑PT/INR)               │
│                                         │
│ 🔬 Diagnostic tools:                    │
│ • FAST ultrasound examination          │
│ • Nasogastric tube if upper GI         │
│ • Recent procedure review              │
│ • Anticoagulation history              │
│                                         │
│ ❓ Active hemorrhage suspected?         │
│                                         │
│ 🔘 YES → Activate MTP                  │
│ 🔘 NO → Non-hemorrhagic evaluation     │
│                                         │
│ [◀ Previous] [Next: Based on Selection ▶]│
└─────────────────────────────────────────┘

### Card 3A – Massive Transfusion Protocol (Node E → G)
┌─────────────────────────────────────────┐
│ 🚨 MASSIVE TRANSFUSION ACTIVATION       │
├─────────────────────────────────────────┤
│ 📞 Blood bank activation:               │
│ • Call blood bank immediately          │
│ • Request MTP pack activation          │
│ • Rapid release of O-negative blood    │
│                                         │
│ 🩸 Initial bleeding control:            │
│ • Direct pressure to bleeding sites    │
│ • Tourniquet application if appropriate│
│ • Hemostatic agents as available       │
│                                         │
│ 💊 Pharmacologic interventions:         │
│ • Tranexamic acid 1g IV (if <3 hours)  │
│ • Calcium chloride 1g IV               │
│ • Consider factor concentrates         │
│                                         │
│ [Next: Blood product administration ▶] │
│                                         │
│ [◀ Previous: Hemorrhage Assessment]    │
└─────────────────────────────────────────┘

### Card 3B – Non-hemorrhagic Evaluation (Node F → H)
┌─────────────────────────────────────────┐
│ 🔍 NON-HEMORRHAGIC SHOCK ASSESSMENT     │
├─────────────────────────────────────────┤
│ 🩺 Clinical evaluation:                 │
│ • Temperature (sepsis screening)       │
│ • Heart sounds (murmurs, rubs)         │
│ • Lung examination (crackles, wheeze)  │
│ • Extremity perfusion assessment       │
│                                         │
│ 📊 Diagnostic workup:                   │
│ • 12-lead ECG (STEMI, arrhythmia)      │
│ • Chest X-ray (pneumothorax, edema)    │
│ • Echocardiogram (function, tamponade) │
│ • Lactate and base deficit             │
│                                         │
│ 🔬 Additional testing:                  │
│ • Blood cultures if febrile            │
│ • Urinalysis and culture               │
│ • D-dimer if PE suspected              │
│                                         │
│ [Next: Fluid responsiveness test ▶]    │
│                                         │
│ [◀ Previous: Hemorrhage Assessment]    │
└─────────────────────────────────────────┘

### Card 4A – Blood Product Administration (Node G → I)
┌─────────────────────────────────────────┐
│ 🩸 BLOOD PRODUCT RESUSCITATION          │
├─────────────────────────────────────────┤
│ 🎯 MTP ratios (1:1:1 preferred):        │
│ • PRBCs: Target Hgb >7 g/dL            │
│ • FFP: Correct coagulopathy (INR <1.5) │
│ • Platelets: Maintain >50,000/µL       │
│ • Cryoprecipitate: If fibrinogen <150  │
│                                         │
│ 📊 Monitoring parameters:               │
│ • Hemoglobin levels q30min             │
│ • Coagulation studies q1h              │
│ • Platelet count trending              │
│ • Fibrinogen levels                    │
│                                         │
│ ⚠️ Complications to monitor:            │
│ • Transfusion reactions                │
│ • Hypothermia from blood products      │
│ • Electrolyte abnormalities           │
│                                         │
│ [Next: Bleeding control assessment ▶]  │
│                                         │
│ [◀ Previous: MTP Activation]           │
└─────────────────────────────────────────┘

### Card 5A – Fluid Responsiveness Assessment (Node H)
┌─────────────────────────────────────────┐
│ 📊 FLUID RESPONSIVENESS EVALUATION      │
├─────────────────────────────────────────┤
│ 🎯 Response indicators:                 │
│ • SBP increase >10 mmHg                │
│ • HR decrease >10 bpm                  │
│ • Improved mental status               │
│ • Urine output >0.5 mL/kg/hr           │
│                                         │
│ 🔬 Advanced assessment:                 │
│ • Passive leg raise test               │
│ • IVC diameter on ultrasound           │
│ • Pulse pressure variation             │
│ • Stroke volume variation              │
│                                         │
│ ❓ Fluid responsive?                    │
│                                         │
│ 🔘 YES → Continue fluid resuscitation  │
│ 🔘 NO → Vasopressor support needed     │
│                                         │
│ [◀ Previous] [Next: Based on Selection ▶]│
└─────────────────────────────────────────┘

### Card 6A – Bleeding Control Assessment (Node I)
┌─────────────────────────────────────────┐
│ 🔄 BLEEDING CONTROL EVALUATION          │
├─────────────────────────────────────────┤
│ 📊 Success indicators:                  │
│ • Stable hemoglobin levels             │
│ • Decreased blood product requirements │
│ • Hemodynamic stabilization           │
│ • Reduced active bleeding signs        │
│                                         │
│ 🚨 Continued bleeding signs:            │
│ • Ongoing hemoglobin drop              │
│ • Persistent hypotension               │
│ • Increasing abdominal girth           │
│ • Fresh blood from wounds/orifices     │
│                                         │
│ ❓ Bleeding adequately controlled?      │
│                                         │
│ 🔘 YES → Coagulopathy correction       │
│ 🔘 NO → Surgical/IR intervention       │
│                                         │
│ [◀ Previous] [Next: Based on Selection ▶]│
└─────────────────────────────────────────┘

### Card 7A – Vasopressor Support (Node K → N)
┌─────────────────────────────────────────┐
│ 💊 VASOPRESSOR THERAPY                  │
├─────────────────────────────────────────┤
│ 🎯 First-line therapy:                  │
│ • Norepinephrine 0.05-3 mcg/kg/min     │
│ • Target MAP ≥65 mmHg                  │
│ • Central line preferred               │
│                                         │
│ 🔄 Escalation options:                  │
│ • Vasopressin 0.03-0.04 units/min      │
│ • Epinephrine 0.05-2 mcg/kg/min        │
│ • Dopamine 5-20 mcg/kg/min             │
│                                         │
│ 📊 Monitoring requirements:             │
│ • Arterial line placement              │
│ • Central venous access                │
│ • Continuous cardiac monitoring        │
│                                         │
│ [Next: Shock type classification ▶]    │
│                                         │
│ [◀ Previous: Fluid Response]           │
└─────────────────────────────────────────┘

### Card 8A – Surgical/IR Intervention (Node L → S)
┌─────────────────────────────────────────┐
│ 🔪 URGENT SURGICAL INTERVENTION         │
├─────────────────────────────────────────┤
│ 📞 Immediate consultations:             │
│ • General surgery                      │
│ • Interventional radiology             │
│ • Anesthesia for OR                    │
│ • Blood bank coordination              │
│                                         │
│ 🎯 Source control priorities:           │
│ • Damage control surgery               │
│ • Embolization procedures              │
│ • Endoscopic interventions             │
│ • Balloon tamponade devices            │
│                                         │
│ 🏥 Preparation requirements:            │
│ • OR availability assessment           │
│ • Anesthesia team activation           │
│ • Continue blood product support       │
│                                         │
│ [Next: ICU monitoring ▶]               │
│                                         │
│ [◀ Previous: Bleeding Control]         │
└─────────────────────────────────────────┘

### Card 8B – Shock Type Classification (Node N)
┌─────────────────────────────────────────┐
│ 🔍 SHOCK TYPE IDENTIFICATION            │
├─────────────────────────────────────────┤
│ 🦠 Distributive shock indicators:        │
│ • Fever or hypothermia                 │
│ • Infection source identified          │
│ • High cardiac output, low SVR         │
│ • Warm, vasodilated extremities        │
│                                         │
│ 💓 Cardiogenic shock indicators:         │
│ • Low cardiac output                   │
│ • Elevated JVD                         │
│ • Pulmonary edema                      │
│ • ECG changes suggesting MI            │
│                                         │
│ 🫁 Obstructive shock indicators:         │
│ • Sudden onset                        │
│ • Signs of PE, pneumothorax            │
│ • Beck's triad (tamponade)             │
│                                         │
│ ❓ Primary shock type identified?       │
│                                         │
│ 🔘 DISTRIBUTIVE → Antibiotic therapy   │
│ 🔘 CARDIOGENIC → Inotropic support     │
│ 🔘 OBSTRUCTIVE → Remove obstruction    │
│                                         │
│ [◀ Previous] [Next: Based on Selection ▶]│
└─────────────────────────────────────────┘

### Card 9A – Distributive Shock Management (Node O → S)
┌─────────────────────────────────────────┐
│ 🦠 DISTRIBUTIVE SHOCK TREATMENT          │
├─────────────────────────────────────────┤
│ 💊 Antimicrobial therapy:               │
│ • Broad-spectrum antibiotics <1 hour   │
│ • Culture-guided therapy when available│
│ • Source control evaluation            │
│                                         │
│ 🔍 Infection source control:            │
│ • Remove infected devices              │
│ • Drain abscesses                      │
│ • Debride necrotic tissue              │
│                                         │
│ 📊 Sepsis monitoring:                   │
│ • Lactate clearance >10% in 2 hours    │
│ • ScvO2 >70% goal                      │
│ • Procalcitonin trending               │
│                                         │
│ [Next: ICU monitoring ▶]               │
│                                         │
│ [◀ Previous: Shock Classification]     │
└─────────────────────────────────────────┘

### Card 9B – Cardiogenic Shock Management (Node P → T)
┌─────────────────────────────────────────┐
│ 💓 CARDIOGENIC SHOCK TREATMENT           │
├─────────────────────────────────────────┤
│ 💊 Inotropic support:                   │
│ • Dobutamine 2.5-20 mcg/kg/min         │
│ • Milrinone 0.125-0.75 mcg/kg/min      │
│ • Avoid excessive preload reduction    │
│                                         │
│ 🔬 Diagnostic evaluation:               │
│ • Echocardiogram (function, structure) │
│ • 12-lead ECG (STEMI evaluation)       │
│ • Coronary angiography if indicated    │
│                                         │
│ 🛠️ Mechanical support consideration:    │
│ • IABP for appropriate candidates       │
│ • Impella for severe LV dysfunction    │
│ • VA-ECMO for refractory shock         │
│                                         │
│ [Next: ECMO evaluation ▶]              │
│                                         │
│ [◀ Previous: Shock Classification]     │
└─────────────────────────────────────────┘

### Card 9C – Obstructive Shock Management (Node R → S)
┌─────────────────────────────────────────┐
│ 🫁 OBSTRUCTIVE SHOCK TREATMENT           │
├─────────────────────────────────────────┤
│ 🎯 Cause-specific interventions:        │
│                                         │
│ 💨 Tension pneumothorax:                │
│ • Immediate needle decompression       │
│ • Chest tube placement                 │
│                                         │
│ 🫀 Cardiac tamponade:                   │
│ • Emergent pericardiocentesis          │
│ • Surgical window if needed            │
│                                         │
│ 🫁 Massive pulmonary embolism:          │
│ • Anticoagulation if no bleeding       │
│ • Thrombolysis consideration           │
│ • Embolectomy evaluation               │
│                                         │
│ [Next: ICU monitoring ▶]               │
│                                         │
│ [◀ Previous: Shock Classification]     │
└─────────────────────────────────────────┘

### Card 10A – ECMO Evaluation (Node T → U)
┌─────────────────────────────────────────┐
│ 🔬 ECMO CANDIDATE ASSESSMENT            │
├─────────────────────────────────────────┤
│ ✅ Inclusion criteria:                  │
│ • Refractory cardiogenic shock         │
│ • Age <75 years (relative)             │
│ • Potentially reversible condition     │
│ • Good baseline functional status      │
│                                         │
│ ❌ Exclusion criteria:                  │
│ • Irreversible multiorgan failure      │
│ • Active malignancy with poor prognosis│
│ • Severe cognitive dysfunction         │
│ • Contraindication to anticoagulation  │
│                                         │
│ 📊 Current status documentation:        │
│ • Vasopressor requirements             │
│ • Cardiac function assessment          │
│ • Organ dysfunction evaluation         │
│                                         │
│ [Next: Mobile ECMO activation ▶]       │
│                                         │
│ [◀ Previous: Cardiogenic Management]   │
└─────────────────────────────────────────┘

### Card 11A – Mobile ECMO Activation (Node U → V)
┌─────────────────────────────────────────┐
│ 📞 MOBILE ECMO TEAM ACTIVATION          │
├─────────────────────────────────────────┤
│ 🚀 Transfer Center: 856-886-5111        │
│ Request: "Mobile ECMO consultation"     │
│                                         │
│ 📋 Information to provide:               │
│ • Patient demographics and history     │
│ • Current hemodynamic status           │
│ • Vasopressor/inotrope requirements    │
│ • Underlying cardiac condition         │
│                                         │
│ ⏱️ Response timeline:                   │
│ • Phone consultation: <15 minutes      │
│ • Team mobilization: <60 minutes       │
│ • Bedside arrival: variable by location│
│                                         │
│ 🛠️ Pre-arrival preparation:             │
│ • Continue maximal medical support     │
│ • Obtain ECMO consent                  │
│ • Prepare cannulation site             │
│                                         │
│ [Next: ECMO management ▶]              │
│                                         │
│ [◀ Previous: ECMO Evaluation]          │
└─────────────────────────────────────────┘

### Card 12A – ICU Monitoring & Support (Node S - Final)
┌─────────────────────────────────────────┐
│ 🏥 ICU MONITORING & ONGOING SUPPORT     │
├─────────────────────────────────────────┤
│ 📊 Hemodynamic monitoring:              │
│ • Arterial line for continuous BP      │
│ • Central venous pressure monitoring   │
│ • Cardiac output assessment            │
│ • Mixed venous oxygen saturation       │
│                                         │
│ 💊 Ongoing resuscitation goals:         │
│ • MAP ≥65 mmHg maintenance              │
│ • Urine output ≥0.5 mL/kg/hr           │
│ • Lactate clearance monitoring         │
│ • Hemoglobin >7 g/dL (>8 if cardiac)   │
│                                         │
│ 🔄 Reassessment intervals:              │
│ • Vital signs q15min until stable      │
│ • Laboratory studies q4-6h             │
│ • Fluid balance q8h                    │
│ • Daily goals reassessment             │
│                                         │
│ 🎯 Recovery planning:                   │
│ • Vasopressor weaning protocol         │
│ • Rehabilitation assessment            │
│ • Family communication                 │
│                                         │
│ ✅ ICU MONITORING PROTOCOL ACTIVE      │
│                                         │
│ [◀ Previous: Treatment Pathways]       │
└─────────────────────────────────────────┘

### Card 12B – ECMO Management (Node V - Final)
┌─────────────────────────────────────────┐
│ 🏥 ECMO CANNULATION & MANAGEMENT        │
├─────────────────────────────────────────┤
│ 🔧 Cannulation process:                 │
│ • Peripheral or central approach       │
│ • Ultrasound-guided vessel access      │
│ • Appropriate anticoagulation          │
│                                         │
│ ⚙️ ECMO parameters:                     │
│ • Blood flow: 60-80 mL/kg/min          │
│ • Sweep gas: 1-2 L/min initially       │
│ • Target oxygen saturation 88-95%      │
│                                         │
│ 📊 Monitoring requirements:             │
│ • Hemodynamic optimization             │
│ • Anticoagulation management           │
│ • Circuit monitoring and troubleshooting│
│ • Daily weaning assessments            │
│                                         │
│ 🎯 Recovery goals:                      │
│ • Myocardial recovery                  │
│ • Weaning from support                 │
│ • Neurologic preservation              │
│                                         │
│ ✅ ECMO PROTOCOL ACTIVE                │
│                                         │
│ [◀ Previous: Mobile ECMO Activation]   │
└─────────────────────────────────────────┘

## VIRTUA VOORHEES HYPOTENSION & HEMORRHAGE ADDENDA

### **Enhanced RRT Response Program:**
- **Rapid Response Team:** Immediate multidisciplinary activation including critical care, surgery, anesthesia
- **Point-of-Care Ultrasound:** FAST exam capability on all RRT carts
- **Blood Bank Integration:** 24/7 MTP activation with <30 minute product delivery
- **Quality Metrics:** Time to IV access, fluid administration, blood product delivery

### **Massive Transfusion Protocol:**
**Activation Criteria:**
- **Anticipated:** >4 units PRBCs in 1 hour
- **Clinical:** Shock index >1.0 with ongoing bleeding
- **Laboratory:** Hemoglobin drop >2 g/dL with hypotension

**Product Ratios (1:1:1 preferred):**
- **PRBCs:** 6 units per pack
- **FFP:** 6 units per pack  
- **Platelets:** 1 apheresis unit (equivalent to 6 random donor)
- **Cryoprecipitate:** 10 units if fibrinogen <150 mg/dL

### **Hemostatic Agent Protocol:**
**Tranexamic Acid:**
- **Dose:** 1g IV over 10 minutes, then 1g over 8 hours
- **Timing:** Within 3 hours of bleeding onset
- **Contraindications:** Active thromboembolic disease

**Factor Concentrates:**
- **Prothrombin Complex Concentrate:** 25-50 units/kg for warfarin reversal
- **Fibrinogen Concentrate:** 3-4g IV if available instead of cryoprecipitate

### **Shock Classification & Management:**
**Distributive Shock:**
- **Hour-1 Bundle:** Lactate, blood cultures, antibiotics, fluid resuscitation
- **Vasopressors:** Norepinephrine first-line, vasopressin as adjunct
- **Source Control:** Aggressive evaluation and intervention

**Cardiogenic Shock:**
- **Inotropic Support:** Dobutamine or milrinone based on hemodynamics
- **Mechanical Support:** IABP, Impella, VA-ECMO based on severity
- **Coronary Evaluation:** Emergent catheterization if STEMI

### **Advanced Monitoring Capabilities:**
- **Arterial Lines:** Standard for vasopressor therapy
- **Central Venous Access:** Required for high-dose vasopressors and CVP monitoring
- **POCUS Integration:** FAST, cardiac function, IVC assessment
- **Advanced Hemodynamics:** Cardiac output monitoring available

### **Mobile ECMO Program:**
**Activation Criteria:**
- **Refractory cardiogenic shock** despite maximal medical therapy
- **Cardiac arrest** with ongoing CPR or recent ROSC
- **Bridge to recovery** or definitive intervention
- **Age <75 years** with good functional status

**Response System:**
- **24/7 Availability:** Through Transfer Center coordination
- **Response Time:** <60 minutes mobilization, transport time variable
- **Cannulation Options:** Peripheral or central approach based on anatomy
- **Transport Capability:** Ground and air medical compatibility

### **Quality Improvement Metrics:**
- **RRT Response Time:** Goal <15 minutes from activation
- **Time to IV Access:** Goal <5 minutes from arrival
- **MTP Activation:** Goal <15 minutes from recognition
- **Blood Product Delivery:** Goal <30 minutes from activation
- **ECMO Consultation:** Goal <15 minutes phone, <60 minutes mobilization

### **Special Population Considerations:**
**Anticoagulated Patients:**
- **Warfarin:** PCC 25-50 units/kg + vitamin K 10mg IV
- **Direct Oral Anticoagulants:** Specific reversal agents when available
- **Heparin:** Protamine sulfate 1mg per 100 units heparin

**Pregnant Patients:**
- **Modified resuscitation:** Left lateral displacement
- **Blood product goals:** Higher hemoglobin targets (>8-10 g/dL)
- **Obstetric consultation:** Immediate for pregnancy-related bleeding

### **Integration with Other Protocols:**
- **GI Bleeding Protocol:** Seamless transition for upper/lower GI sources
- **Anemia Management:** Coordinated transfusion thresholds
- **Shock & ECMO Protocol:** Advanced circulatory support pathways

## REFERENCE GUIDELINES
- **2022 Advanced Trauma Life Support (ATLS) Guidelines**
- **2023 ESAIC Guidelines on Management of Severe Perioperative Bleeding**
- **2021 Surviving Sepsis Campaign Guidelines**
- **Virtua Health System Hypotension & Hemorrhage Protocol v2025**

**This protocol integrates current evidence-based approaches to hypotension and hemorrhage management with advanced resuscitation capabilities and mechanical circulatory support options optimized for the Virtua Voorhees clinical environment.**
