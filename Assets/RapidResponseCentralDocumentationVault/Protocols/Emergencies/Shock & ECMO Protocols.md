# Shock & ECMO Protocols with Virtua Voorhees Addenda

**Primary Guideline:** Surviving Sepsis Campaign 2021 Guidelines for Management of Sepsis and Septic Shock
**Official Source:** https://www.survivingsepsis.org/guidelines/adult-patients
**Supporting Guidelines:**
- American Heart Association Scientific Statement on Cardiogenic Shock 2020
- Extracorporeal Life Support Organization (ELSO) Guidelines 2022

## ENHANCED MERMAID FLOWCHART ALGORITHM

~~~mermaid
graph TD
    A["Shock Recognition<br/>MAP <65 or Lactate >2"] --> B["Initial Stabilization<br/>O2, IV Access, Monitors"]
    
    B --> C["Fluid Resuscitation<br/>30 mL/kg Crystalloid Bolus"]
    
    C --> D{"Fluid<br/>Responsive?"}
    
    D -->|YES| E["Continue Fluids<br/>Reassess Response"]
    D -->|NO| F["Identify Shock Type<br/>Clinical + POCUS"]
    
    E --> G{"MAP ≥65<br/>Achieved?"}
    F --> G
    
    G -->|YES| H["Monitor & Treat<br/>Underlying Cause"]
    G -->|NO| I{"Shock Type<br/>Classification"}
    
    I -->|DISTRIBUTIVE| J["Norepinephrine<br/>Cultures + Antibiotics"]
    I -->|CARDIOGENIC| K["Inotropes + Consider<br/>Mechanical Support"]
    I -->|HYPOVOLEMIC| L["Blood Products<br/>Source Control"]
    I -->|OBSTRUCTIVE| M["Immediate Intervention<br/>Decompress/Anticoag"]
    
    J --> N{"Adequate<br/>Response?"}
    K --> O{"SCAI Shock<br/>Stage?"}
    L --> P{"Bleeding<br/>Controlled?"}
    M --> Q["Monitor Response<br/>to Intervention"]
    
    N -->|NO| R["Vasopressor Escalation<br/>Add Vasopressin/Epi"]
    O -->|"STAGE C-E"| S["ECMO Evaluation<br/>MCS Consideration"]
    P -->|NO| T["Surgical/IR Intervention<br/>Massive Transfusion"]
    P -->|YES| U["Continue Resuscitation<br/>Monitor Response"]
    Q --> U
    
    R --> V{"Refractory<br/>Shock?"}
    S --> W["Transfer Center<br/>Mobile ECMO Activation"]
    T --> U
    
    V -->|YES| W
    V -->|NO| U
    
    W --> X["Mobile ECMO Team<br/>Deployment"]
    X --> Y["ECMO Cannulation<br/>ICU Management"]
    
    style A fill:#ffcccc
    style B fill:#ffe6cc
    style J fill:#fff2cc
    style S fill:#ccffcc
    style W fill:#e6ccff
    style Y fill:#ccffee
~~~

## STREAMLINED DYNAMIC CARD SYSTEM

### Card 0 – Shock Recognition & Initial Stabilization (Node A → B)
┌─────────────────────────────────────────┐
│ 🚨 SHOCK PROTOCOL ACTIVATION            │
├─────────────────────────────────────────┤
│ 🎯 Recognition criteria:                │
│ • MAP <65 mmHg                         │
│ • Lactate >2 mmol/L                    │
│ • Signs of hypoperfusion               │
│ • Altered mental status                │
│                                         │
│ 🚀 Immediate actions (<5 minutes):      │
│ • High-flow oxygen                     │
│ • Large-bore IV access × 2             │
│ • Continuous monitoring                │
│ • Arterial line consideration          │
│                                         │
│ 📊 Essential labs:                      │
│ • Lactate, CBC, BMP                    │
│ • Blood cultures × 2 (before abx)      │
│ • ABG, PT/INR, troponin               │
│                                         │
│ [Next: Fluid resuscitation ▶]          │
└─────────────────────────────────────────┘

### Card 1A – Fluid Resuscitation (Node C → D)
┌─────────────────────────────────────────┐
│ 💧 FLUID RESUSCITATION PROTOCOL         │
├─────────────────────────────────────────┤
│ 🎯 Initial fluid challenge:             │
│ • 30 mL/kg crystalloid bolus           │
│ • Balanced crystalloids preferred      │
│ • Rapid infusion (<30 minutes)         │
│                                         │
│ 📊 Fluid responsiveness markers:        │
│ • Stroke volume variation >10%         │
│ • Passive leg raise test positive      │
│ • Pulse pressure variation >13%        │
│                                         │
│ ⚠️ Stop criteria:                       │
│ • Signs of fluid overload              │
│ • Pulmonary edema                      │
│ • No hemodynamic improvement           │
│                                         │
│ [Next: Response assessment ▶]          │
│                                         │
│ [◀ Previous: Shock Recognition]        │
└─────────────────────────────────────────┘

### Card 2A – Shock Type Classification (Node F → I)
┌─────────────────────────────────────────┐
│ 🔍 SHOCK TYPE IDENTIFICATION            │
├─────────────────────────────────────────┤
│ 🩺 Clinical assessment + POCUS:         │
│                                         │
│ 🔴 Distributive (↓SVR, ↑/nl CO):        │
│ • Septic: infection + organ dysfunction │
│ • Anaphylactic: allergen exposure      │
│ • Neurogenic: spinal injury T6+        │
│                                         │
│ 💙 Cardiogenic (↓CO, ↑SVR):             │
│ • Acute MI, mechanical complications   │
│ • Arrhythmias, cardiomyopathy          │
│                                         │
│ 🩸 Hypovolemic (↓CO, ↑SVR):             │
│ • Hemorrhagic vs non-hemorrhagic       │
│                                         │
│ 🫁 Obstructive (↓CO, variable SVR):     │
│ • Tension pneumo, PE, tamponade        │
│                                         │
│ [Next: Type-specific management ▶]     │
│                                         │
│ [◀ Previous: Fluid Response]           │
└─────────────────────────────────────────┘

### Card 3A – Distributive Shock Management (Node J → N)
┌─────────────────────────────────────────┐
│ 🔴 DISTRIBUTIVE SHOCK - SEPSIS          │
├─────────────────────────────────────────┤
│ 💊 Vasopressor therapy:                 │
│ • Norepinephrine: 0.05-3 mcg/kg/min   │
│ • Target MAP ≥65 mmHg                  │
│ • Central line preferred               │
│                                         │
│ 🦠 Infection control:                   │
│ • Blood cultures before antibiotics   │
│ • Broad-spectrum antibiotics <1 hour  │
│ • Source control evaluation           │
│                                         │
│ 📊 Monitoring parameters:               │
│ • Lactate clearance >10% in 2 hours   │
│ • ScvO2 >70% or SvO2 >65%             │
│ • Urine output >0.5 mL/kg/hr          │
│                                         │
│ [Next: Response evaluation ▶]          │
│                                         │
│ [◀ Previous: Shock Classification]     │
└─────────────────────────────────────────┘

### Card 3B – Cardiogenic Shock Management (Node K → O)
┌─────────────────────────────────────────┐
│ 💙 CARDIOGENIC SHOCK - SCAI STAGING     │
├─────────────────────────────────────────┤
│ 🎯 SCAI Shock Classification:           │
│ • Stage A: At risk                     │
│ • Stage B: Beginning                   │
│ • Stage C: Classic                     │
│ • Stage D: Deteriorating               │
│ • Stage E: Extremis                    │
│                                         │
│ 💊 Inotropic support:                   │
│ • Dobutamine: 2.5-20 mcg/kg/min       │
│ • Milrinone: 0.125-0.75 mcg/kg/min    │
│ • Avoid excessive preload reduction    │
│                                         │
│ 🛠️ Mechanical support consideration:    │
│ • IABP for Stage C shock               │
│ • Impella for Stage D-E               │
│ • VA-ECMO for refractory shock         │
│                                         │
│ [Next: SCAI stage assessment ▶]        │
│                                         │
│ [◀ Previous: Shock Classification]     │
└─────────────────────────────────────────┘

### Card 3C – Hypovolemic Shock Management (Node L → P)
┌─────────────────────────────────────────┐
│ 🩸 HYPOVOLEMIC SHOCK MANAGEMENT          │
├─────────────────────────────────────────┤
│ 🎯 Volume replacement:                  │
│ • Crystalloids for non-hemorrhagic     │
│ • Blood products for hemorrhagic       │
│ • Aim for Hgb >7 g/dL (>10 if cardiac)│
│                                         │
│ 🔍 Source identification:               │
│ • Physical examination                 │
│ • FAST exam for trauma                 │
│ • CT imaging as indicated              │
│                                         │
│ 🚨 Massive transfusion protocol:        │
│ • Activate if >4 units in 1 hour      │
│ • 1:1:1 ratio PRBC:FFP:platelets      │
│ • Consider tranexamic acid             │
│                                         │
│ [Next: Bleeding control assessment ▶]  │
│                                         │
│ [◀ Previous: Shock Classification]     │
└─────────────────────────────────────────┘

### Card 3D – Obstructive Shock Management (Node M → Q)
┌─────────────────────────────────────────┐
│ 🫁 OBSTRUCTIVE SHOCK INTERVENTIONS       │
├─────────────────────────────────────────┤
│ 🎯 Cause-specific interventions:        │
│                                         │
│ 💨 Tension pneumothorax:                │
│ • Immediate needle decompression       │
│ • Chest tube placement                 │
│                                         │
│ 🫀 Cardiac tamponade:                   │
│ • Emergent pericardiocentesis          │
│ • Surgical consultation               │
│                                         │
│ 🫁 Massive pulmonary embolism:          │
│ • Anticoagulation if no contraindications│
│ • Consider thrombolysis               │
│ • ECMO for refractory cases           │
│                                         │
│ [Next: Monitor intervention response ▶] │
│                                         │
│ [◀ Previous: Shock Classification]     │
└─────────────────────────────────────────┘

### Card 4A – Vasopressor Escalation (Node R → V)
┌─────────────────────────────────────────┐
│ 💉 VASOPRESSOR ESCALATION PROTOCOL      │
├─────────────────────────────────────────┤
│ 🔄 Escalation sequence:                 │
│                                         │
│ 1️⃣ Norepinephrine (first-line):        │
│ • Start: 0.05 mcg/kg/min              │
│ • Max: 3 mcg/kg/min                   │
│                                         │
│ 2️⃣ Vasopressin (add-on):               │
│ • Fixed dose: 0.03-0.04 units/min     │
│ • Do not titrate                      │
│                                         │
│ 3️⃣ Epinephrine (third-line):           │
│ • Start: 0.05 mcg/kg/min              │
│ • Max: 2 mcg/kg/min                   │
│                                         │
│ 📊 Monitoring:                          │
│ • Arterial line mandatory             │
│ • Lactate q2-4h                       │
│                                         │
│ [Next: Refractory shock assessment ▶]  │
│                                         │
│ [◀ Previous: Distributive Management]  │
└─────────────────────────────────────────┘

### Card 5A – ECMO Evaluation (Node S → W)
┌─────────────────────────────────────────┐
│ 🔬 ECMO CANDIDATE ASSESSMENT            │
├─────────────────────────────────────────┤
│ ✅ Inclusion criteria:                  │
│ • Age <75 years (relative)             │
│ • Refractory cardiogenic shock         │
│ • Potentially reversible cause         │
│ • Good baseline functional status      │
│                                         │
│ ❌ Exclusion criteria:                  │
│ • Unwitnessed cardiac arrest >10 min   │
│ • Irreversible end-stage disease       │
│ • Severe cognitive dysfunction         │
│ • Active malignancy with poor prognosis│
│                                         │
│ 📊 Current parameters to document:      │
│ • SCAI shock stage                     │
│ • Vasopressor requirements             │
│ • Lactate trend                       │
│ • Organ function                      │
│                                         │
│ [Next: Transfer center activation ▶]   │
│                                         │
│ [◀ Previous: Cardiogenic Management]   │
└─────────────────────────────────────────┘

### Card 6A – Mobile ECMO Activation (Node W → X)
┌─────────────────────────────────────────┐
│ 📞 MOBILE ECMO TEAM ACTIVATION          │
├─────────────────────────────────────────┤
│ 🚀 Transfer Center: 856-886-5111        │
│ Request: "Mobile ECMO consultation"     │
│                                         │
│ 📋 Information to provide:               │
│ • Patient age, weight, relevant history│
│ • Current shock state and interventions│
│ • Vasopressor/inotrope requirements    │
│ • Lactate and organ function           │
│                                         │
│ ⏱️ Expected response times:             │
│ • Phone consultation: <15 minutes      │
│ • Team mobilization: <60 minutes       │
│ • Arrival at bedside: varies by location│
│                                         │
│ 🛠️ Pre-arrival preparations:            │
│ • Continue aggressive support          │
│ • Obtain consent for ECMO              │
│ • Prepare for cannulation              │
│                                         │
│ [Next: ECMO team deployment ▶]         │
│                                         │
│ [◀ Previous: ECMO Evaluation]          │
└─────────────────────────────────────────┘

### Card 7A – ECMO Cannulation & Management (Node Y - Final)
┌─────────────────────────────────────────┐
│ 🏥 ECMO CANNULATION & ICU MANAGEMENT     │
├─────────────────────────────────────────┤
│ 🔧 Cannulation process:                 │
│ • Peripheral or central cannulation    │
│ • Real-time echocardiographic guidance │
│ • Heparin anticoagulation              │
│                                         │
│ 📊 ECMO parameters:                     │
│ • Blood flow: 60-80 mL/kg/min          │
│ • Sweep gas: 1-2 L/min initially       │
│ • Target SpO2 88-95%                   │
│                                         │
│ 🏥 ICU management priorities:           │
│ • Hemodynamic optimization             │
│ • Ventilator lung-protective strategy  │
│ • Anticoagulation monitoring           │
│ • Daily weaning assessments            │
│                                         │
│ 🎯 Recovery goals:                      │
│ • Myocardial recovery                  │
│ • Weaning from vasopressors            │
│ • Neurologic assessment                │
│                                         │
│ ✅ ECMO PROTOCOL ACTIVE                │
│                                         │
│ [◀ Previous: Mobile ECMO Activation]   │
└─────────────────────────────────────────┘

### Card 7B – Surgical Intervention (Node T - Final)
┌─────────────────────────────────────────┐
│ 🔪 SURGICAL/IR INTERVENTION             │
├─────────────────────────────────────────┤
│ 🚨 Indications for urgent intervention: │
│ • Uncontrolled hemorrhage               │
│ • Source control needed                │
│ • Anatomical abnormalities             │
│                                         │
│ 📞 Immediate consultations:             │
│ • General surgery                      │
│ • Interventional radiology             │
│ • Specialty services as needed         │
│                                         │
│ 🩸 Massive transfusion protocol:        │
│ • 1:1:1 ratio maintained               │
│ • Factor concentrates as needed        │
│ • Tranexamic acid consideration        │
│                                         │
│ ✅ HEMORRHAGE CONTROL PROTOCOL ACTIVE  │
│                                         │
│ [◀ Previous: Hypovolemic Management]   │
└─────────────────────────────────────────┘

### Card 7C – Continued Resuscitation (Node U - Final)
┌─────────────────────────────────────────┐
│ 🔄 CONTINUED RESUSCITATION & MONITORING  │
├─────────────────────────────────────────┤
│ 📊 Ongoing monitoring parameters:       │
│ • MAP ≥65 mmHg maintenance              │
│ • Lactate clearance >10% q2-4h         │
│ • Urine output ≥0.5 mL/kg/hr           │
│ • Central venous O2 saturation          │
│                                         │
│ 🎯 Resuscitation goals:                 │
│ • Hemodynamic stability               │
│ • Organ perfusion restoration         │
│ • Resolution of hyperlactatemia        │
│                                         │
│ 🔄 Reassessment intervals:              │
│ • Vitals q15min until stable           │
│ • Labs q2-4h initially                 │
│ • Clinical response evaluation         │
│                                         │
│ ✅ RESUSCITATION PROTOCOL ACTIVE       │
│                                         │
│ [◀ Previous: Management Pathways]      │
└─────────────────────────────────────────┘

## VIRTUA VOORHEES SHOCK & ECMO ADDENDA

### **Enhanced Shock Response Program:**
- **Rapid Response Team:** Multidisciplinary approach with critical care, cardiology, pharmacy
- **Point-of-Care Ultrasound:** RUSH protocol integration for shock evaluation
- **Quality Metrics:** Time to vasopressor initiation, lactate clearance, survival outcomes
- **Mobile ECMO Program:** 24/7 availability through Transfer Center coordination

### **Shock Type-Specific Protocols:**
**Septic Shock (Most Common):**
- **Hour-1 Bundle:** Blood cultures, antibiotics, lactate, fluid resuscitation
- **Norepinephrine preferred:** First-line vasopressor with central access
- **Source control:** Aggressive evaluation and intervention

**Cardiogenic Shock:**
- **SCAI Classification:** Standardized staging for management decisions
- **Mechanical Support:** IABP, Impella, VA-ECMO available
- **Early revascularization:** PCI or surgical intervention as indicated

**Advanced Hemodynamic Monitoring:**
- **Arterial lines:** Standard for vasopressor therapy
- **Central venous access:** Required for high-dose vasopressors
- **Pulmonary artery catheters:** Selected cases of cardiogenic shock
- **Lactate trending:** Serial measurements for resuscitation guidance

### **ECMO Program Specifications:**
**Mobile ECMO Capabilities:**
- **Response Time:** <60 minutes mobilization, variable transport time
- **Cannulation Options:** Peripheral (femoral-femoral) or central approach
- **Transport Capability:** Ground and air medical transport compatible
- **ICU Management:** Dedicated ECMO team with 24/7 coverage

**ECMO Indications:**
- **Cardiogenic Shock:** SCAI Stage D-E refractory to medical therapy
- **Cardiac Arrest:** Witnessed arrest with ROSC or ongoing CPR
- **Bridge Therapy:** To definitive intervention or recovery
- **Post-cardiotomy:** Following cardiac surgical procedures

### **Quality Improvement Integration:**
- **Shock Recognition Time:** Goal <15 minutes from presentation
- **Time to Vasopressors:** Goal <1 hour for distributive shock
- **Lactate Clearance:** >10% reduction in first 2 hours
- **ECMO Activation:** Decision within 2 hours of refractory shock

### **Medication Dosing - Weight-Based Calculations:**
```
VASOPRESSOR DOSING TABLE:  
┌─────────────────────────────────────────┐  
│ Norepinephrine (mcg/kg/min): │  
│ Start: 0.05 → Max: 3.0 │  
│ 70kg patient: 3.5-210 mcg/min │  
│ │  
│ Vasopressin (fixed dose): │  
│ 0.03-0.04 units/min (do not titrate) │  
│ │  
│ Epinephrine (mcg/kg/min): │  
│ Start: 0.05 → Max: 2.0 │  
│ 70kg patient: 3.5-140 mcg/min │  
│ │  
│ Dobutamine (mcg/kg/min): │  
│ Start: 2.5 → Max: 20 │  
│ 70kg patient: 175-1400 mcg/min │  
└─────────────────────────────────────────┘
```

### **Contact Information & Escalation:**
- **Transfer Center:** 856-886-5111 (Mobile ECMO activation)
- **Critical Care Attending:** Available 24/7 for consultation
- **Pharmacy:** Clinical pharmacist for dosing optimization
- **Laboratory:** STAT lactate results, blood gas analysis

### **Special Populations:**
**Pregnancy:**
- Modified hemodynamic targets
- Left lateral positioning
- Fetal monitoring considerations

**Elderly Patients:**
- ECMO candidacy evaluation
- Goals of care discussions
- Frailty assessment integration

**Pediatric Considerations:**
- Weight-based dosing protocols
- Pediatric ECMO team availability
- CHOP consultation if needed

## REFERENCE GUIDELINES
- **2021 Surviving Sepsis Campaign Guidelines**
- **2020 AHA Scientific Statement on Cardiogenic Shock**
- **2022 ELSO Guidelines for Adult ECMO**
- **Virtua Health System Shock Protocol v2025**

**This comprehensive protocol integrates current evidence-based shock management with advanced mechanical circulatory support capabilities, optimized for rapid recognition, aggressive intervention, and excellent patient outcomes at Virtua Voorhees.**
