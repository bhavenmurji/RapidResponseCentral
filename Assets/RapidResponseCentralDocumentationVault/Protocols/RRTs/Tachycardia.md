# Tachycardia – RRT Protocol with Virtua Voorhees Addenda

**Primary Guideline:** American Heart Association (AHA) Advanced Cardiovascular Life Support (ACLS) 2020 Guidelines (Current through 2025)
**Official Source:** https://cpr.heart.org/en/resuscitation-science/cpr-and-ecc-guidelines/adult-advanced-cardiovascular-life-support
**Supporting Guidelines:**
- 2019 AHA/ACC/HRS Guideline for the Management of Patients with Atrial Fibrillation
- 2017 AHA/ACC/HRS Guideline for the Management of Patients with Ventricular Arrhythmias

## ENHANCED MERMAID FLOWCHART ALGORITHM

~~~mermaid
graph TD
    A["Tachycardia Recognition<br/>HR >150 bpm + Symptoms"] --> B{"Patient<br/>Stable?"}
    
    B -->|UNSTABLE| C["Synchronized Cardioversion<br/>Sedate if Conscious"]
    B -->|STABLE| D["12-Lead ECG Analysis<br/>Identify Rhythm"]
    
    C --> E["Post-Cardioversion<br/>Monitor & Evaluate"]
    D --> F{"QRS Width<br/>Assessment?"}
    
    F -->|"NARROW <120ms"| G{"Rhythm<br/>Regularity?"}
    F -->|"WIDE ≥120ms"| H["Assume VT Until<br/>Proven Otherwise"]
    
    G -->|REGULAR| I["Vagal Maneuvers<br/>+ Adenosine 6-12mg"]
    G -->|IRREGULAR| J["Atrial Fibrillation<br/>Rate Control"]
    
    H --> K["Stable VT<br/>Antiarrhythmic Therapy"]
    
    I --> L{"SVT<br/>Converted?"}
    J --> M["Diltiazem/Metoprolol<br/>Target HR <110"]
    K --> N["Amiodarone 150mg<br/>or Procainamide"]
    
    L -->|YES| O["Monitor & Treat<br/>Underlying Cause"]
    L -->|NO| P["Beta-Blocker or<br/>Calcium Channel Blocker"]
    
    M --> Q["Consider Anticoagulation<br/>CHA2DS2-VASc Score"]
    N --> R["Assess Response<br/>& Stability"]
    P --> O
    
    E --> O
    O --> S["Disposition<br/>Telemetry/ICU"]
    Q --> S
    R --> S
    
    style A fill:#ffcccc
    style B fill:#ffe6cc
    style C fill:#ffaaaa
    style I fill:#fff2cc
    style J fill:#ccffcc
    style K fill:#e6ccff
    style S fill:#ccffee
~~~

## STREAMLINED DYNAMIC CARD SYSTEM

### Card 0 – Tachycardia Recognition & Stability Assessment (Node A → B)
┌─────────────────────────────────────────┐
│ 🚨 TACHYCARDIA RRT ACTIVATION            │
├─────────────────────────────────────────┤
│ 📊 Recognition criteria:                │
│ • Heart rate >150 bpm (sustained)      │
│ • Associated symptoms present           │
│ • Hemodynamic compromise possible       │
│                                         │
│ 🚨 Instability indicators (ANY = unstable):│
│ • Hypotension (SBP <90 mmHg)           │
│ • Altered mental status                │
│ • Signs of shock (poor perfusion)      │
│ • Ischemic chest discomfort            │
│ • Acute heart failure                  │
│                                         │
│ 🚀 Immediate actions:                   │
│ • 12-lead ECG                          │
│ • IV access × 2                        │
│ • Continuous monitoring                │
│ • Defibrillator at bedside             │
│                                         │
│ ❓ Patient hemodynamically stable?      │
│                                         │
│ 🔘 YES → Rhythm analysis               │
│ 🔘 NO → Immediate cardioversion        │
│                                         │
│ [Next: Based on Selection ▶]            │
└─────────────────────────────────────────┘

### Card 1A – Synchronized Cardioversion (Node C → E)
┌─────────────────────────────────────────┐
│ ⚡ SYNCHRONIZED CARDIOVERSION            │
├─────────────────────────────────────────┤
│ 🚨 Unstable tachycardia protocol:       │
│ • Immediate intervention required       │
│ • Do not delay for medication trials   │
│                                         │
│ 💊 Pre-cardioversion sedation:          │
│ • Midazolam 2-5mg IV if conscious      │
│ • Propofol 0.5-1mg/kg if available     │
│ • Maintain airway support              │
│                                         │
│ ⚡ Energy recommendations:               │
│ • Narrow regular: 50-100J              │
│ • Narrow irregular (A-fib): 120-200J   │
│ • Wide complex: 100J, then 150J, 200J  │
│                                         │
│ 🔧 Procedure checklist:                 │
│ • Sync mode ON                         │
│ • Proper pad placement                 │
│ • "Clear" before shock                 │
│                                         │
│ [Next: Post-cardioversion care ▶]      │
│                                         │
│ [◀ Previous: Stability Assessment]     │
└─────────────────────────────────────────┘

### Card 1B – Rhythm Analysis (Node D → F)
┌─────────────────────────────────────────┐
│ 📊 12-LEAD ECG RHYTHM ANALYSIS          │
├─────────────────────────────────────────┤
│ 🔍 Systematic approach:                 │
│ • Rate: >150 bpm confirmed             │
│ • Rhythm: Regular vs irregular          │
│ • QRS width: <120ms vs ≥120ms          │
│ • P waves: Present, absent, or abnormal│
│                                         │
│ 📋 Classification system:               │
│ • Narrow complex + regular = SVT       │
│ • Narrow complex + irregular = A-fib   │
│ • Wide complex = VT until proven otherwise│
│                                         │
│ ❓ QRS width measurement?               │
│                                         │
│ 🔘 NARROW (<120ms) → Assess regularity │
│ 🔘 WIDE (≥120ms) → Assume VT           │
│                                         │
│ [◀ Previous] [Next: Based on Selection ▶]│
└─────────────────────────────────────────┘

### Card 2A – SVT Management (Node I → L)
┌─────────────────────────────────────────┐
│ 🫀 SUPRAVENTRICULAR TACHYCARDIA         │
├─────────────────────────────────────────┤
│ 🎯 Narrow complex regular tachycardia:  │
│ • AVNRT (most common)                  │
│ • AVRT (accessory pathway)             │
│ • Atrial flutter with 2:1 conduction   │
│                                         │
│ 🤲 Vagal maneuvers (try first):        │
│ • Valsalva maneuver (15 seconds)       │
│ • Carotid sinus massage (if no bruit)  │
│ • Ice water immersion                  │
│                                         │
│ 💉 Adenosine protocol:                  │
│ • First dose: 6mg rapid IV push        │
│ • Second dose: 12mg if no response     │
│ • Third dose: 12mg if needed           │
│ • Give through large-bore peripheral IV│
│                                         │
│ ⚠️ Contraindications:                   │
│ • Known WPW with A-fib                 │
│ • Asthma (relative)                    │
│ • Heart transplant recipients          │
│                                         │
│ [Next: Conversion assessment ▶]        │
│                                         │
│ [◀ Previous: QRS Analysis]             │
└─────────────────────────────────────────┘

### Card 2B – Atrial Fibrillation Management (Node J → M)
┌─────────────────────────────────────────┐
│ 🫀 ATRIAL FIBRILLATION WITH RVR         │
├─────────────────────────────────────────┤
│ 🎯 Rate control strategy:               │
│ • Target: <110 bpm at rest             │
│ • Avoid aggressive rate control        │
│ • Monitor for conversion to NSR        │
│                                         │
│ 💊 First-line agents:                   │
│                                         │
│ 🔸 Diltiazem (preferred):               │
│ • Loading: 0.25mg/kg IV over 2 min     │
│ • Second dose: 0.35mg/kg if needed     │
│ • Infusion: 5-15mg/hr                  │
│                                         │
│ 🔸 Metoprolol:                          │
│ • 2.5-5mg IV every 5 minutes           │
│ • Maximum: 15mg total                  │
│ • Avoid in acute heart failure         │
│                                         │
│ 🔸 Amiodarone (low EF):                 │
│ • 150mg IV over 10 minutes             │
│ • Then 1mg/min × 6hr, then 0.5mg/min  │
│                                         │
│ [Next: Anticoagulation assessment ▶]   │
│                                         │
│ [◀ Previous: QRS Analysis]             │
└─────────────────────────────────────────┘

### Card 2C – Wide Complex Tachycardia (Node K → N)
┌─────────────────────────────────────────┐
│ ⚡ WIDE COMPLEX TACHYCARDIA (VT)        │
├─────────────────────────────────────────┤
│ 🚨 Assume VT until proven otherwise:    │
│ • Most wide complex tachycardia is VT  │
│ • Don't waste time on differential     │
│ • Treat aggressively                   │
│                                         │
│ 💊 Antiarrhythmic therapy:              │
│                                         │
│ 🔸 Amiodarone (first-line):             │
│ • 150mg IV over 10-20 minutes          │
│ • May repeat × 1 if needed             │
│ • Then maintenance infusion            │
│                                         │
│ 🔸 Procainamide (alternative):          │
│ • 20-50mg/min IV infusion              │
│ • Maximum: 17mg/kg total dose          │
│ • Monitor for hypotension              │
│                                         │
│ ⚠️ Avoid these in VT:                   │
│ • Adenosine                            │
│ • Calcium channel blockers             │
│ • Beta-blockers                        │
│                                         │
│ [Next: Response assessment ▶]          │
│                                         │
│ [◀ Previous: QRS Analysis]             │
└─────────────────────────────────────────┘

### Card 3A – SVT Conversion Assessment (Node L)
┌─────────────────────────────────────────┐
│ 🔄 SVT CONVERSION EVALUATION            │
├─────────────────────────────────────────┤
│ 📊 Success indicators:                  │
│ • Abrupt termination to sinus rhythm   │
│ • Heart rate <100 bpm                  │
│ • Symptom resolution                   │
│                                         │
│ 📈 Failure indicators:                  │
│ • Persistent tachycardia               │
│ • Rate unchanged after adenosine       │
│ • Continued symptoms                   │
│                                         │
│ ❓ SVT successfully converted?          │
│                                         │
│ 🔘 YES → Investigate underlying cause  │
│ 🔘 NO → Alternative rate control agents│
│                                         │
│ 💡 If unsuccessful:                     │
│ • Consider beta-blocker                │
│ • Consider calcium channel blocker     │
│ • Reassess for atrial flutter          │
│                                         │
│ [◀ Previous] [Next: Based on Selection ▶]│
└─────────────────────────────────────────┘

### Card 3B – Alternative Rate Control (Node P → O)
┌─────────────────────────────────────────┐
│ 💊 ALTERNATIVE RATE CONTROL             │
├─────────────────────────────────────────┤
│ 🔸 Metoprolol protocol:                 │
│ • 5mg IV every 5 minutes               │
│ • Maximum: 15mg total                  │
│ • Monitor BP and signs of CHF          │
│                                         │
│ 🔸 Diltiazem protocol:                  │
│ • 0.25mg/kg IV over 2 minutes          │
│ • May repeat 0.35mg/kg in 15 minutes   │
│ • Start infusion 5-15mg/hr             │
│                                         │
│ ⚠️ Contraindications:                   │
│ • Hypotension                          │
│ • Severe heart failure                 │
│ • Heart block                          │
│ • WPW syndrome                         │
│                                         │
│ [Next: Monitor response ▶]             │
│                                         │
│ [◀ Previous: SVT Conversion]           │
└─────────────────────────────────────────┘

### Card 4A – Anticoagulation Assessment (Node Q → S)
┌─────────────────────────────────────────┐
│ 🩸 ANTICOAGULATION EVALUATION           │
├─────────────────────────────────────────┤
│ 📊 CHA2DS2-VASc Score calculation:      │
│ • Congestive heart failure (1 pt)      │
│ • Hypertension (1 pt)                  │
│ • Age ≥75 years (2 pts)                │
│ • Diabetes mellitus (1 pt)             │
│ • Stroke/TIA history (2 pts)           │
│ • Vascular disease (1 pt)              │
│ • Age 65-74 years (1 pt)               │
│ • Sex category (female = 1 pt)         │
│                                         │
│ 🎯 Anticoagulation recommendations:     │
│ • Score 0 (males) or 1 (females): None │
│ • Score 1 (males): Consider            │
│ • Score ≥2: Recommended                │
│                                         │
│ 💊 Anticoagulation options:             │
│ • Warfarin (INR 2-3)                   │
│ • Direct oral anticoagulants (DOACs)   │
│ • Consider bleeding risk (HAS-BLED)    │
│                                         │
│ [Next: Disposition planning ▶]         │
│                                         │
│ [◀ Previous: A-fib Management]         │
└─────────────────────────────────────────┘

### Card 5A – VT Response Assessment (Node R → S)
┌─────────────────────────────────────────┐
│ 📊 VT TREATMENT RESPONSE                │
├─────────────────────────────────────────┤
│ ✅ Successful treatment indicators:      │
│ • Conversion to sinus rhythm           │
│ • Significant rate reduction           │
│ • Hemodynamic improvement              │
│ • Symptom resolution                   │
│                                         │
│ ⚠️ Treatment failure indicators:         │
│ • Persistent wide complex tachycardia  │
│ • Hemodynamic deterioration            │
│ • Recurrent episodes                   │
│                                         │
│ 🚨 If treatment fails:                  │
│ • Consider synchronized cardioversion  │
│ • Reassess stability                   │
│ • Alternative antiarrhythmic agents    │
│ • Cardiology consultation              │
│                                         │
│ [Next: Disposition planning ▶]         │
│                                         │
│ [◀ Previous: VT Management]            │
└─────────────────────────────────────────┘

### Card 6 – Underlying Cause Investigation (Node O → S)
┌─────────────────────────────────────────┐
│ 🔍 UNDERLYING CAUSE EVALUATION          │
├─────────────────────────────────────────┤
│ 🩺 Common precipitating factors:        │
│ • Acute coronary syndrome              │
│ • Electrolyte abnormalities            │
│ • Hyperthyroidism                      │
│ • Pulmonary embolism                   │
│ • Medication effects                   │
│                                         │
│ 📊 Diagnostic workup:                   │
│ • Basic metabolic panel                │
│ • Thyroid function tests               │
│ • Cardiac enzymes/troponins            │
│ • Chest X-ray                          │
│ • Echocardiogram if indicated          │
│                                         │
│ 💊 Address reversible causes:           │
│ • Correct electrolyte abnormalities    │
│ • Treat underlying conditions          │
│ • Adjust medications                   │
│                                         │
│ [Next: Disposition planning ▶]         │
│                                         │
│ [◀ Previous: Treatment Pathways]       │
└─────────────────────────────────────────┘

### Card 7 – Disposition & Monitoring (Node S - Final)
┌─────────────────────────────────────────┐
│ 🏥 DISPOSITION & FOLLOW-UP              │
├─────────────────────────────────────────┤
│ 📍 Disposition options:                 │
│                                         │
│ 🔴 ICU admission:                       │
│ • Unstable tachycardia requiring cardioversion│
│ • Antiarrhythmic infusions             │
│ • Hemodynamic monitoring needed        │
│                                         │
│ 🟡 Telemetry monitoring:                │
│ • Stable arrhythmias                   │
│ • New-onset atrial fibrillation        │
│ • Medication titration                 │
│                                         │
│ 🟢 Medical floor:                       │
│ • Well-controlled atrial fibrillation  │
│ • Converted SVT with known trigger     │
│ • Stable after treatment               │
│                                         │
│ 📋 Follow-up coordination:              │
│ • Cardiology: 1-2 weeks for new onset │
│ • Primary care: 1 week                 │
│ • Electrophysiology if recurrent       │
│                                         │
│ ✅ DISPOSITION PROTOCOL COMPLETE       │
│                                         │
│ [◀ Previous: Treatment Completion]     │
└─────────────────────────────────────────┘

## VIRTUA VOORHEES TACHYCARDIA ADDENDA

### **Enhanced RRT Response Program:**
- **Rapid Response Team:** Immediate multidisciplinary activation including critical care and cardiology
- **Equipment Availability:** Defibrillators with cardioversion capability on all RRT carts
- **Pharmacy Support:** Pre-drawn emergency medications (adenosine, diltiazem, amiodarone)
- **Quality Metrics:** Time to rhythm identification, cardioversion success rates, complications

### **Updated ACLS Integration:**
**Adenosine Administration Updates:**
- **Rapid push technique:** Give through most proximal port followed by immediate saline flush
- **Half-life awareness:** <10 seconds, effects seen within 15-30 seconds
- **Monitoring:** Continuous telemetry during administration

**Rate Control Optimization:**
- **Diltiazem preferred:** Better efficacy and safety profile than verapamil
- **Weight-based dosing:** 0.25mg/kg then 0.35mg/kg with infusion titration
- **Avoid in WPW:** Can accelerate ventricular response in pre-excited A-fib

### **Advanced Monitoring Capabilities:**
- **Continuous telemetry:** Real-time rhythm analysis with arrhythmia detection
- **12-lead ECG integration:** Automatic rhythm interpretation with alerts
- **Hemodynamic monitoring:** Blood pressure trending during rate control
- **Drug response tracking:** Medication effectiveness documentation

### **Cardiology Integration:**
**24/7 Availability:**
- **General cardiology:** For complex arrhythmia management
- **Electrophysiology:** For refractory cases and ablation candidates
- **Transfer Center:** 856-886-5111 for specialized interventions

**Anticoagulation Program:**
- **Pharmacy-driven protocols:** CHA2DS2-VASc and HAS-BLED score integration
- **DOAC preferred:** Unless contraindicated or patient preference
- **Bridging protocols:** For procedures in anticoagulated patients

### **Special Population Considerations:**
**Wolff-Parkinson-White Syndrome:**
- **Recognize pre-excitation:** Delta waves, short PR interval
- **Avoid AV nodal blockers:** Can precipitate VF in A-fib with WPW
- **Procainamide preferred:** For wide complex tachycardia in WPW

**Heart Failure Patients:**
- **Amiodarone preferred:** Rate and rhythm control with minimal negative inotropic effect
- **Avoid beta-blockers:** In acute decompensated heart failure
- **Digoxin consideration:** For rate control in chronic heart failure

**Post-Cardiac Surgery:**
- **Amiodarone first-line:** Due to high efficacy in post-operative A-fib
- **Electrolyte optimization:** Magnesium and potassium repletion
- **Temporary pacing:** Available for bradycardia post-cardioversion

### **Interactive Decision Support Tools:**
**Rate Control Calculator:**
- **Weight-based dosing:** Automatic calculation for diltiazem and metoprolol
- **Titration guidance:** Based on heart rate response and hemodynamics
- **Safety alerts:** For contraindications and drug interactions

**CHA2DS2-VASc Calculator:**
- **Automated scoring:** Based on patient history and demographics
- **Risk stratification:** Color-coded recommendations for anticoagulation
- **HAS-BLED integration:** Bleeding risk assessment

**Rhythm Analysis Aid:**
- **Differential diagnosis:** Step-by-step rhythm identification
- **Treatment recommendations:** Algorithm-based therapeutic suggestions
- **Consultation triggers:** Automatic alerts for complex cases

### **Quality Improvement Metrics:**
- **Recognition time:** Goal <5 minutes from RRT activation to rhythm identification
- **Adenosine administration:** Goal <10 minutes for appropriate SVT
- **Rate control:** Goal heart rate <110 bpm within 30 minutes
- **Cardioversion success:** >90% success rate for appropriate indications

### **Medication Safety Program:**
- **Double verification:** For all high-risk medications (adenosine, amiodarone)
- **Allergy checking:** Automated screening for drug allergies
- **Interaction alerts:** Real-time monitoring for drug-drug interactions
- **Dosing verification:** Weight-based calculations with pharmacist oversight

## REFERENCE GUIDELINES
- **2020 AHA Guidelines for CPR and Emergency Cardiovascular Care**
- **2019 AHA/ACC/HRS Guideline for the Management of Patients with Atrial Fibrillation**
- **2017 AHA/ACC/HRS Guideline for the Management of Patients with Ventricular Arrhythmias**
- **Virtua Health System Tachycardia Protocol v2025**

**This protocol reflects current evidence-based ACLS and arrhythmia management guidelines optimized for rapid recognition, appropriate intervention, and excellent patient outcomes in the Virtua Voorhees RRT setting.**
