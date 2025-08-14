# Bradycardia – RRT Protocol with Virtua Voorhees Addenda

**Primary Guideline:** American Heart Association (AHA) Advanced Cardiovascular Life Support (ACLS) 2020 Guidelines (Current through 2025)
**Official Source:** https://cpr.heart.org/en/resuscitation-science/cpr-and-ecc-guidelines/adult-advanced-cardiovascular-life-support
**Supporting Guidelines:**
- 2018 AHA/ACC/HRS Guideline on the Evaluation and Management of Patients with Bradycardia
- 2025 ACLS Algorithm Updates

## ENHANCED MERMAID FLOWCHART ALGORITHM

~~~mermaid
graph TD
    A["Bradycardia Recognition<br/>HR <60 bpm + Symptoms"] --> B{"Patient<br/>Symptomatic?"}
    
    B -->|NO| C["Monitor & Observe<br/>Treat Underlying Causes"]
    B -->|YES| D["Initial Stabilization<br/>O2, IV, Monitor, 12-lead ECG"]
    
    D --> E{"Bradycardia<br/>Type?"}
    
    E -->|"Sinus Brady/1st Degree"| F["Atropine 1mg IV<br/>Repeat q3-5min (max 3mg)"]
    E -->|"2nd Degree Type II/3rd Degree"| G["Transcutaneous Pacing<br/>Immediate Setup"]
    
    F --> H{"Adequate<br/>Response?"}
    
    H -->|YES| I["Continue Monitoring<br/>Treat Underlying Cause"]
    H -->|NO| J["Chronotropic Support<br/>Dopamine 5-20 mcg/kg/min"]
    
    J --> K["Transcutaneous Pacing<br/>If Not Already Done"]
    G --> K
    
    K --> L{"Pacing<br/>Effective?"}
    
    L -->|YES| M["Optimize Settings<br/>Provide Sedation"]
    L -->|NO| N["Transvenous Pacing<br/>Cardiology Consult"]
    
    M --> O["Permanent Pacemaker<br/>Evaluation"]
    N --> O
    
    O --> P["Disposition<br/>ICU/Telemetry"]
    C --> P
    I --> P
    
    style A fill:#ffcccc
    style D fill:#ffe6cc
    style F fill:#fff2cc
    style G fill:#ccffcc
    style K fill:#e6ccff
    style P fill:#ccffee
~~~

## STREAMLINED DYNAMIC CARD SYSTEM

### Card 0 – Bradycardia Recognition & Assessment (Node A → B)
┌─────────────────────────────────────────┐
│ 🚨 BRADYCARDIA RRT ACTIVATION            │
├─────────────────────────────────────────┤
│ 📊 Recognition criteria:                │
│ • Heart rate <60 bpm (typically <50)   │
│ • Associated symptoms present           │
│ • Hemodynamic compromise               │
│                                         │
│ 🩺 Immediate assessment:                │
│ • Mental status changes                │
│ • Hypotension/signs of shock           │
│ • Ischemic chest discomfort            │
│ • Acute heart failure symptoms         │
│ • Syncope or near-syncope              │
│                                         │
│ ⏱️ Time of onset: Document precisely    │
│ Duration: Note progression pattern      │
│                                         │
│ ❓ Patient symptomatic?                 │
│                                         │
│ 🔘 YES → Immediate intervention        │
│ 🔘 NO → Monitor and observe            │
│                                         │
│ [Next: Based on Selection ▶]            │
└─────────────────────────────────────────┘

### Card 1A – Initial Stabilization (Node D → E)
┌─────────────────────────────────────────┐
│ 🔧 INITIAL STABILIZATION PROTOCOL       │
├─────────────────────────────────────────┤
│ 🚀 Immediate actions:                   │
│ • High-flow oxygen if hypoxic          │
│ • Large-bore IV access × 2             │
│ • Continuous cardiac monitoring        │
│ • 12-lead ECG (don't delay therapy)    │
│                                         │
│ 📊 Essential monitoring:                │
│ • Blood pressure, pulse oximetry       │
│ • Continuous ECG rhythm strip          │
│ • Consider arterial line if unstable   │
│                                         │
│ 🔍 Investigate underlying causes:       │
│ • H's & T's assessment                 │
│ • Medication review                    │
│ • Electrolyte abnormalities           │
│                                         │
│ [Next: Bradycardia classification ▶]   │
│                                         │
│ [◀ Previous: Recognition]              │
└─────────────────────────────────────────┘

### Card 1B – Monitor & Observe (Node C - Final)
┌─────────────────────────────────────────┐
│ 👁️ ASYMPTOMATIC MONITORING              │
├─────────────────────────────────────────┤
│ 📈 Continuous surveillance:             │
│ • Telemetry monitoring                 │
│ • Vital signs q15min initially         │
│ • Watch for symptom development        │
│                                         │
│ 🔍 Underlying cause evaluation:         │
│ • Medication-induced bradycardia       │
│ • Metabolic causes (hypothyroidism)    │
│ • Cardiac pathology assessment         │
│                                         │
│ ⚠️ Escalation triggers:                 │
│ • Development of symptoms              │
│ • HR <40 bpm                          │
│ • Pauses >3 seconds                    │
│                                         │
│ ✅ MONITORING PROTOCOL ACTIVE          │
│                                         │
│ [◀ Previous: Recognition]              │
└─────────────────────────────────────────┘

### Card 2A – Bradycardia Classification (Node E)
┌─────────────────────────────────────────┐
│ 🔍 BRADYCARDIA TYPE CLASSIFICATION      │
├─────────────────────────────────────────┤
│ 📊 ECG analysis:                        │
│                                         │
│ 🔵 Sinus bradycardia:                   │
│ • Normal P-QRS relationship            │
│ • PR interval normal/prolonged         │
│                                         │
│ 🟡 First-degree AV block:               │
│ • PR interval >200ms, constant         │
│ • 1:1 P-QRS conduction                 │
│                                         │
│ 🟠 Second-degree AV block:              │
│ • Type I (Wenckebach): Progressive PR  │
│ • Type II: Fixed PR, dropped QRS       │
│                                         │
│ 🔴 Third-degree AV block:               │
│ • Complete AV dissociation             │
│ • Independent P and QRS rates          │
│                                         │
│ ❓ Block type classification?           │
│                                         │
│ 🔘 SINUS/1ST DEGREE → Atropine trial   │
│ 🔘 HIGH-GRADE BLOCK → Immediate pacing │
│                                         │
│ [◀ Previous] [Next: Based on Selection ▶]│
└─────────────────────────────────────────┘

### Card 3A – Atropine Administration (Node F → H)
┌─────────────────────────────────────────┐
│ 💉 ATROPINE ADMINISTRATION              │
├─────────────────────────────────────────┤
│ 💊 Updated 2025 dosing protocol:        │
│ • First dose: 1mg IV bolus              │
│ • Repeat: 1mg q3-5min                   │
│ • Maximum total: 3mg                    │
│                                         │
│ ⚙️ Mechanism of action:                  │
│ • Blocks vagal tone                     │
│ • Increases SA node firing rate         │
│ • Improves AV conduction                │
│                                         │
│ ⚠️ Limitations:                         │
│ • Less effective in 3rd degree block   │
│ • Ineffective in heart transplant      │
│ • May worsen Type II block (rare)       │
│                                         │
│ 📊 Monitor response:                     │
│ • HR improvement >60 bpm               │
│ • BP stabilization                     │
│ • Symptom resolution                   │
│                                         │
│ [Next: Response assessment ▶]          │
│                                         │
│ [◀ Previous: Classification]           │
└─────────────────────────────────────────┘

### Card 3B – Immediate Pacing Setup (Node G → K)
┌─────────────────────────────────────────┐
│ ⚡ TRANSCUTANEOUS PACING SETUP          │
├─────────────────────────────────────────┤
│ 🚨 High-risk indications:               │
│ • 2nd degree Type II AV block           │
│ • 3rd degree (complete) AV block        │
│ • Wide QRS escape rhythm                │
│ • Pauses >3 seconds                     │
│                                         │
│ 🔧 Pacing pad placement:                │
│ • Anterior-posterior preferred         │
│ • Anterior-lateral alternative         │
│ • Clean/dry skin, clip hair if needed  │
│                                         │
│ ⚙️ Initial settings:                    │
│ • Rate: 80 ppm                         │
│ • Output: Start 30mA, increase by 10mA │
│ • Mode: Demand (synchronous)            │
│                                         │
│ [Next: Pacing effectiveness ▶]         │
│                                         │
│ [◀ Previous: Classification]           │
└─────────────────────────────────────────┘

### Card 4A – Chronotropic Support (Node J → K)
┌─────────────────────────────────────────┐
│ 💊 CHRONOTROPIC INFUSION THERAPY        │
├─────────────────────────────────────────┤
│ 🎯 Updated 2025 dosing:                 │
│                                         │
│ 💉 Dopamine (preferred):                │
│ • Dose: 5-20 mcg/kg/min IV infusion     │
│ • Start: 5 mcg/kg/min                   │
│ • Titrate to effect                     │
│                                         │
│ 💉 Epinephrine (alternative):           │
│ • Dose: 2-10 mcg/min IV infusion        │
│ • Start: 2 mcg/min                      │
│ • Potent chronotropic effect           │
│                                         │
│ 📊 Monitoring parameters:               │
│ • HR response (target >60 bpm)         │
│ • BP improvement                       │
│ • Watch for arrhythmias                │
│                                         │
│ [Next: Transcutaneous pacing ▶]        │
│                                         │
│ [◀ Previous: Atropine Response]        │
└─────────────────────────────────────────┘

### Card 5A – Pacing Effectiveness (Node L)
┌─────────────────────────────────────────┐
│ 📊 PACING EFFECTIVENESS ASSESSMENT      │
├─────────────────────────────────────────┤
│ ✅ Success indicators:                  │
│ • Electrical capture (pacing spikes    │
│   followed by QRS)                     │
│ • Mechanical capture (palpable pulse)  │
│ • Hemodynamic improvement              │
│                                         │
│ 🔧 Troubleshooting failed pacing:      │
│ • Increase output (max 200mA)          │
│ • Reposition pads                      │
│ • Check connections                     │
│ • Consider lead displacement           │
│                                         │
│ 😌 Patient comfort measures:            │
│ • Sedation: Fentanyl 25-50mcg         │
│ • Anxiolysis: Midazolam 1-2mg          │
│ • Explain procedure to patient         │
│                                         │
│ ❓ Pacing effective?                    │
│                                         │
│ 🔘 YES → Optimize settings & sedate    │
│ 🔘 NO → Transvenous pacing needed     │
│                                         │
│ [◀ Previous] [Next: Based on Selection ▶]│
└─────────────────────────────────────────┘

### Card 6A – Pacing Optimization (Node M → O)
┌─────────────────────────────────────────┐
│ 🔧 PACING OPTIMIZATION                  │
├─────────────────────────────────────────┤
│ ⚙️ Settings optimization:               │
│ • Threshold testing q4-6h               │
│ • Set output 2× threshold              │
│ • Rate: 60-80 ppm (patient comfort)    │
│                                         │
│ 💊 Sedation protocol:                   │
│ • Assess pain level (0-10 scale)       │
│ • Titrate analgesics as needed         │
│ • Monitor respiratory status           │
│                                         │
│ 📊 Continuous monitoring:               │
│ • Capture confirmation                 │
│ • Hemodynamic stability                │
│ • Skin integrity at pad sites          │
│                                         │
│ [Next: Permanent pacemaker eval ▶]     │
│                                         │
│ [◀ Previous: Pacing Effectiveness]     │
└─────────────────────────────────────────┘

### Card 6B – Transvenous Pacing (Node N → O)
┌─────────────────────────────────────────┐
│ 🏥 TRANSVENOUS PACING CONSULTATION      │
├─────────────────────────────────────────┤
│ 📞 Cardiology consultation:             │
│ • Transfer Center: 856-886-5111        │
│ • Electrophysiology if available       │
│ • Prepare for procedure                │
│                                         │
│ 🎯 Indications for transvenous:         │
│ • Failed transcutaneous pacing         │
│ • High-grade AV blocks                 │
│ • Bridge to permanent device           │
│ • Extended pacing requirement          │
│                                         │
│ 🛠️ Procedure preparation:               │
│ • Central venous access                │
│ • Fluoroscopy availability             │
│ • Pacing catheter system               │
│                                         │
│ [Next: Permanent pacemaker eval ▶]     │
│                                         │
│ [◀ Previous: Pacing Effectiveness]     │
└─────────────────────────────────────────┘

### Card 7 – Permanent Pacemaker Evaluation (Node O → P)
┌─────────────────────────────────────────┐
│ 🔋 PERMANENT PACEMAKER EVALUATION       │
├─────────────────────────────────────────┤
│ 📋 Pacemaker indications:               │
│ • Symptomatic bradycardia              │
│ • High-grade AV blocks                 │
│ • Sinus node dysfunction               │
│ • Chronotropic incompetence            │
│                                         │
│ 🏥 Evaluation process:                  │
│ • Electrophysiology consultation       │
│ • Echo to assess LV function           │
│ • Consider CRT if indicated            │
│                                         │
│ ⏱️ Timing considerations:               │
│ • Urgent: Complete heart block         │
│ • Semi-urgent: Type II AV block        │
│ • Elective: Symptomatic sinus brady    │
│                                         │
│ 📚 Patient education:                   │
│ • Device function explanation          │
│ • Activity restrictions                │
│ • Follow-up requirements               │
│                                         │
│ [Next: Disposition planning ▶]         │
│                                         │
│ [◀ Previous: Pacing Management]        │
└─────────────────────────────────────────┘

### Card 8 – Disposition Planning (Node P - Final)
┌─────────────────────────────────────────┐
│ 🏥 DISPOSITION & FOLLOW-UP              │
├─────────────────────────────────────────┤
│ 📍 Disposition options:                 │
│                                         │
│ 🔴 ICU admission:                       │
│ • Unstable bradycardia                 │
│ • Active pacing requirements           │
│ • Hemodynamic instability              │
│                                         │
│ 🟡 Telemetry unit:                      │
│ • Stable bradycardia                   │
│ • Pacemaker evaluation pending         │
│ • Medication titration needed          │
│                                         │
│ 🟢 Medical floor:                       │
│ • Asymptomatic bradycardia             │
│ • Stable after intervention            │
│ • Low-risk rhythms                     │
│                                         │
│ 📋 Follow-up coordination:              │
│ • Cardiology: 1-2 weeks                │
│ • Primary care: 1 week                 │
│ • Device clinic if pacemaker           │
│                                         │
│ ✅ DISPOSITION PROTOCOL COMPLETE       │
│                                         │
│ [◀ Previous: Pacemaker Evaluation]     │
└─────────────────────────────────────────┘

## VIRTUA VOORHEES BRADYCARDIA ADDENDA

### **Enhanced RRT Response:**
- **Rapid Response Team:** Immediate bedside assessment within 15 minutes
- **Equipment Availability:** Transcutaneous pacing pads on all RRT carts
- **Pharmacy Support:** Pre-mixed atropine and dopamine infusions available
- **Quality Metrics:** Door-to-atropine time, pacing success rates, patient outcomes

### **Updated 2025 ACLS Guidelines Integration:**
**Atropine Dosing Changes:**
- **First dose:** Increased from 0.5mg to 1mg IV bolus
- **Repeat dosing:** 1mg every 3-5 minutes (not 0.5mg)
- **Maximum total:** 3mg (unchanged)

**Dopamine Infusion Updates:**
- **Dosing range:** 5-20 mcg/kg/min (updated from 2-20 mcg/kg/min)
- **Starting dose:** 5 mcg/kg/min for chronotropic effect
- **Maximum:** 20 mcg/kg/min with careful monitoring

### **Advanced Monitoring Capabilities:**
- **Continuous telemetry:** Real-time rhythm analysis
- **POCUS integration:** IVC assessment for volume status
- **Arterial line placement:** For unstable patients requiring vasopressors
- **Central venous access:** When transvenous pacing anticipated

### **Cardiology Integration:**
**24/7 Availability:**
- **Interventional cardiology:** For emergency pacemaker placement
- **Electrophysiology:** Specialized arrhythmia management
- **Transfer Center:** 856-886-5111 for consultation and transfer

**Pacemaker Program:**
- **Temporary pacing:** Available in ED and ICU
- **Permanent device placement:** Within 24-48 hours for appropriate candidates
- **Device clinic:** Follow-up and optimization

### **H's and T's Assessment for Bradycardia:**
**Hypoxia:** Airway management, supplemental oxygen
**Hydrogen ions (Acidosis):** ABG analysis, bicarbonate if severe
**Hypovolemia:** Fluid resuscitation, bleeding assessment
**Hypo/Hyperkalemia:** Electrolyte correction protocols
**Hypothermia:** Rewarming strategies
**Toxins:** Antidote administration (calcium, glucagon)
**Tamponade:** Echocardiogram, pericardiocentesis
**Tension pneumothorax:** Chest decompression
**Thrombosis:** PE/MI evaluation and treatment
**Tablets (drugs):** Beta-blockers, calcium channel blockers, digoxin

### **Special Population Considerations:**
**Elderly Patients:**
- Higher baseline bradycardia tolerance
- Medication-induced causes common
- Careful sedation dosing for pacing

**Post-Cardiac Surgery:**
- Temporary epicardial wires available
- Electrolyte management critical
- Early EP consultation

**Heart Transplant Recipients:**
- Atropine ineffective (denervated heart)
- Direct chronotropic agents preferred
- Specialized cardiology consultation

### **Quality Improvement Metrics:**
- **Recognition time:** <5 minutes from RRT activation
- **Atropine administration:** <15 minutes from assessment
- **Pacing setup:** <30 minutes for high-risk blocks
- **Cardiology consultation:** <60 minutes for complex cases

## REFERENCE GUIDELINES
- **2020 AHA Guidelines for CPR and Emergency Cardiovascular Care**
- **2018 AHA/ACC/HRS Guideline on Bradycardia and Cardiac Conduction Delay**
- **2025 ACLS Algorithm Updates**
- **Virtua Health System Bradycardia Protocol v2025**

**This protocol reflects current evidence-based ACLS guidelines with 2025 updates, optimized for rapid recognition and appropriate intervention of symptomatic bradycardia in the Virtua Voorhees RRT setting.**
