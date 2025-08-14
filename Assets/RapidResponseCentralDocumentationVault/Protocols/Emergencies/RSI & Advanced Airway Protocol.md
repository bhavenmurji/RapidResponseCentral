# RSI & Advanced Airway Protocol with Virtua Voorhees Addenda

**Primary Guideline:** Difficult Airway Society (DAS) 2015 Guidelines for Management of Unanticipated Difficult Intubation in Adults
**Official Source:** https://das.uk.com/guidelines/das-intubation-guidelines
**Supporting Guidelines:** 
- American Society of Anesthesiologists (ASA) 2022 Practice Guidelines for Management of the Difficult Airway
- Emergency Medicine Airway Management Guidelines 2024

## ENHANCED MERMAID FLOWCHART ALGORITHM

~~~mermaid
graph TD
    A["Decision to Intubate<br/>Assess Airway Difficulty"] --> B{"Difficult Airway<br/>Predicted?"}
    
    B -->|NO| C["Standard RSI Pathway<br/>7 P's Protocol"]
    B -->|YES| D["Difficult Airway Algorithm<br/>Call for Help"]
    
    C --> E["Preoxygenation<br/>3-5 min 100% O2"]
    D --> F["Consider Awake<br/>Intubation"]
    
    E --> G["Position Patient<br/>Sniffing/Ramped"]
    F --> H{"Awake Technique<br/>Indicated?"}
    
    G --> I["Pretreatment<br/>If Indicated"]
    H -->|YES| J["Topical Anesthesia<br/>Sedation"]
    H -->|NO| K["Video Laryngoscopy<br/>Preparation"]
    
    I --> L["Induction Agent<br/>Weight-Based"]
    J --> M["Awake Fiberoptic<br/>Technique"]
    K --> L
    
    L --> N["Paralytic Agent<br/>Rocuronium/Sux"]
    M --> O{"Successful<br/>Placement?"}
    
    N --> P["Wait 45-60 seconds<br/>Optimal Conditions"]
    O -->|YES| Q["Confirm with ETCO2<br/>Secure ETT"]
    
    P --> R["First Attempt<br/>Best Visualization"]
    O -->|NO| S["Surgical Airway<br/>Cannot Intubate/Ventilate"]
    
    R --> T{"Successful<br/>Intubation?"}
    
    T -->|YES| Q
    T -->|NO| U{"SpO2 >90%<br/>Adequate Oxygenation?"}
    
    U -->|YES| V["Second Attempt<br/>Different Technique"]
    U -->|NO| W["BVM Ventilation<br/>Recover Oxygenation"]
    
    V --> X{"Second Attempt<br/>Successful?"}
    W --> Y["LMA Rescue Device<br/>Supraglottic Airway"]
    
    X -->|YES| Q
    X -->|NO| Y
    
    Y --> Z{"Adequate<br/>Ventilation?"}
    
    Z -->|YES| AA["Stabilize Patient<br/>Plan Next Steps"]
    Z -->|NO| S
    
    Q --> BB["Post-Intubation<br/>Management"]
    AA --> BB
    
    BB --> CC["Sedation & Analgesia<br/>Ventilator Settings"]
    
    style A fill:#ffcccc
    style C fill:#ffe6cc
    style L fill:#fff2cc
    style Q fill:#ccffcc
    style S fill:#ffaaaa
    style BB fill:#e6ccff
~~~

## STREAMLINED DYNAMIC CARD SYSTEM

### Card 0 – Intubation Decision & Assessment (Node A → B)
┌─────────────────────────────────────────┐
│ 🫁 RAPID SEQUENCE INTUBATION            │
├─────────────────────────────────────────┤
│ 🚨 RSI Indications:                     │
│ • Failure to protect airway (GCS ≤8)   │
│ • Failure to oxygenate (SpO2 <90%)     │
│ • Failure to ventilate (PaCO2 >50)     │
│ • Expected clinical deterioration      │
│                                         │
│ 🔍 LEMON Assessment:                    │
│ • Look externally (trauma, obesity)    │
│ • Evaluate 3-3-2 rule                  │
│ • Mallampati classification            │
│ • Obstruction/Obesity                  │
│ • Neck mobility                        │
│                                         │
│ ❓ Difficult airway predicted?          │
│                                         │
│ 🔘 YES → Difficult airway algorithm    │
│ 🔘 NO → Standard RSI pathway           │
│                                         │
│ [Next: Based on Selection ▶]            │
└─────────────────────────────────────────┘

### Card 1A – Standard RSI Protocol (Node C → E)
┌─────────────────────────────────────────┐
│ 📋 STANDARD RSI - 7 P's PROTOCOL        │
├─────────────────────────────────────────┤
│ ✅ Preparation:                         │
│ • Equipment check completed            │
│ • Team roles assigned                  │
│ • Backup plan established              │
│                                         │
│ 🫁 Preoxygenation:                      │
│ • 100% O2 for 3-5 minutes             │
│ • Target SpO2 >95%                     │
│ • Apneic oxygenation ready             │
│                                         │
│ 💊 Pretreatment (if indicated):         │
│ • Fentanyl 3 mcg/kg (sympathetic)     │
│ • Lidocaine 1.5 mg/kg (↑ICP)          │
│                                         │
│ [Next: Patient positioning ▶]          │
│                                         │
│ [◀ Previous: Initial Assessment]       │
└─────────────────────────────────────────┘

### Card 1B – Difficult Airway Algorithm (Node D → F)
┌─────────────────────────────────────────┐
│ ⚠️ DIFFICULT AIRWAY PROTOCOL            │
├─────────────────────────────────────────┤
│ 📞 Call for help immediately:           │
│ • Anesthesia: ext. 5555                │
│ • ENT backup: ext. 6666                │
│ • Extra nursing support                │
│                                         │
│ 🛠️ Additional equipment:                │
│ • Video laryngoscope ready             │
│ • Fiberoptic bronchoscope              │
│ • Surgical airway kit                  │
│ • Multiple rescue devices              │
│                                         │
│ 🎯 Strategy decision:                   │
│ • Awake vs asleep technique            │
│ • Topical anesthesia preparation       │
│                                         │
│ [Next: Awake intubation assessment ▶]  │
│                                         │
│ [◀ Previous: Initial Assessment]       │
└─────────────────────────────────────────┘

### Card 2A – Patient Positioning (Node G → I)
┌─────────────────────────────────────────┐
│ 🛏️ PATIENT POSITIONING                  │
├─────────────────────────────────────────┤
│ 🎯 Optimal positioning:                 │
│ • Sniffing position (standard)         │
│ • Ramp position (obese patients)       │
│ • C-spine precautions if indicated     │
│                                         │
│ 📏 Position verification:               │
│ • Ear-to-sternal notch alignment       │
│ • Improve laryngeal view               │
│ • External manipulation ready          │
│                                         │
│ [Next: Pretreatment consideration ▶]   │
│                                         │
│ [◀ Previous: RSI Protocol]             │
└─────────────────────────────────────────┘

### Card 2B – Awake Intubation Assessment (Node H)
┌─────────────────────────────────────────┐
│ 🧠 AWAKE INTUBATION DECISION            │
├─────────────────────────────────────────┤
│ 🎯 Indications for awake technique:     │
│ • Severe airway distortion             │
│ • Limited mouth opening <2cm           │
│ • Suspected airway obstruction         │
│ • C-spine instability with difficulty  │
│                                         │
│ 💊 Preparation requirements:            │
│ • Topical anesthesia (lidocaine)       │
│ • Conscious sedation (dexmedetomidine) │
│ • Antisialagogue (glycopyrrolate)      │
│                                         │
│ ❓ Proceed with awake technique?        │
│                                         │
│ 🔘 YES → Topical anesthesia prep       │
│ 🔘 NO → Standard induction sequence    │
│                                         │
│ [◀ Previous] [Next: Based on Selection ▶]│
└─────────────────────────────────────────┘

### Card 3A – Pretreatment (Node I → L)
┌─────────────────────────────────────────┐
│ 💊 PRETREATMENT MEDICATIONS             │
├─────────────────────────────────────────┤
│ ⏱️ Give 3 minutes before induction:     │
│                                         │
│ 🫀 Fentanyl 3 mcg/kg:                   │
│ • Blunts sympathetic response          │
│ • Reduces BP/HR surge                  │
│                                         │
│ 🧠 Lidocaine 1.5 mg/kg:                 │
│ • May decrease ICP                     │
│ • Controversial benefit                │
│                                         │
│ 👶 Atropine 0.02 mg/kg:                 │
│ • Pediatric patients <1 year only      │
│ • Prevents bradycardia                 │
│                                         │
│ [Next: Induction agent selection ▶]    │
│                                         │
│ [◀ Previous: Patient Positioning]      │
└─────────────────────────────────────────┘

### Card 3B – Topical Anesthesia (Node J → M)
┌─────────────────────────────────────────┐
│ 🩺 AWAKE INTUBATION PREPARATION         │
├─────────────────────────────────────────┤
│ 💊 Topical anesthesia:                  │
│ • Lidocaine 4% spray/nebulizer         │
│ • Benzocaine 20% spray (avoid)         │
│ • Cocaine 4% (if available)            │
│                                         │
│ 😴 Sedation options:                    │
│ • Dexmedetomidine 0.5-1 mcg/kg        │
│ • Remifentanil 0.05-0.1 mcg/kg/min    │
│ • Ketamine 0.25-0.5 mg/kg             │
│                                         │
│ 🧬 Antisialagogue:                      │
│ • Glycopyrrolate 0.2 mg IV             │
│                                         │
│ [Next: Awake fiberoptic technique ▶]   │
│                                         │
│ [◀ Previous: Awake Assessment]         │
└─────────────────────────────────────────┘

### Card 4A – Induction Agent (Node L → N)
┌─────────────────────────────────────────┐
│ 💉 INDUCTION AGENT SELECTION            │
├─────────────────────────────────────────┤
│ 🎯 Agent selection by scenario:         │
│                                         │
│ 💓 Etomidate 0.3 mg/kg:                 │
│ • Hemodynamically stable patients      │
│ • Maintains BP and cardiac output      │
│                                         │
│ 🫁 Ketamine 1-2 mg/kg:                  │
│ • Shock, hypotension                   │
│ • Asthma, bronchospasm                 │
│                                         │
│ 🧠 Propofol 1-2 mg/kg:                  │
│ • Status epilepticus                   │
│ • Increased ICP                        │
│                                         │
│ [Next: Paralytic administration ▶]     │
│                                         │
│ [◀ Previous: Pretreatment]             │
└─────────────────────────────────────────┘

### Card 4B – Awake Fiberoptic (Node M → O)
┌─────────────────────────────────────────┐
│ 🔬 AWAKE FIBEROPTIC INTUBATION          │
├─────────────────────────────────────────┤
│ 🛠️ Equipment setup:                     │
│ • Flexible fiberoptic bronchoscope     │
│ • ETT loaded over scope                │
│ • Suction ready                       │
│                                         │
│ 📋 Technique steps:                     │
│ • Patient sitting upright             │
│ • Nasal or oral approach               │
│ • Visualize vocal cords                │
│ • Pass ETT over scope                  │
│                                         │
│ ⚠️ Failure plan:                        │
│ • Surgical airway immediately ready   │
│ • Cannot ventilate = emergency cric    │
│                                         │
│ [Next: Placement confirmation ▶]       │
│                                         │
│ [◀ Previous: Topical Anesthesia]       │
└─────────────────────────────────────────┘

### Card 5A – Paralytic Administration (Node N → P)
┌─────────────────────────────────────────┐
│ 💪 PARALYTIC AGENT ADMINISTRATION       │
├─────────────────────────────────────────┤
│ 🎯 Agent selection:                     │
│                                         │
│ ⚡ Rocuronium 1.2 mg/kg (preferred):    │
│ • Reversible with sugammadex           │
│ • No contraindications                 │
│ • Onset 45-60 seconds                  │
│                                         │
│ ⚡ Succinylcholine 1.5 mg/kg:           │
│ • Faster onset (30-45 seconds)        │
│ • Contraindications: hyperkalemia,     │
│   burns >48h, crush injury             │
│                                         │
│ ⏱️ Wait for optimal conditions:         │
│ • Allow full paralysis onset          │
│ • No spontaneous movement              │
│                                         │
│ [Next: First intubation attempt ▶]     │
│                                         │
│ [◀ Previous: Induction Agent]          │
└─────────────────────────────────────────┘

### Card 6A – First Intubation Attempt (Node R → T)
┌─────────────────────────────────────────┐
│ 🎯 FIRST INTUBATION ATTEMPT             │
├─────────────────────────────────────────┤
│ 📺 Video laryngoscopy preferred:        │
│ • Better visualization                 │
│ • Teaching opportunity                 │
│ • Record for quality review            │
│                                         │
│ 🔧 Optimization techniques:             │
│ • External laryngeal manipulation      │
│ • Bougie if poor view                  │
│ • Sellick maneuver (controversial)     │
│                                         │
│ ⏱️ Time limits:                         │
│ • Maximum 30 seconds per attempt       │
│ • Stop if SpO2 drops                   │
│                                         │
│ [Next: Success assessment ▶]           │
│                                         │
│ [◀ Previous: Paralytic Administration] │
└─────────────────────────────────────────┘

### Card 7A – Placement Confirmation (Node Q → BB)
┌─────────────────────────────────────────┐
│ ✅ INTUBATION CONFIRMATION              │
├─────────────────────────────────────────┤
│ 🥇 Gold standard confirmation:          │
│ • Continuous ETCO2 waveform            │
│ • Should be present immediately        │
│                                         │
│ 🩺 Secondary confirmation:              │
│ • Bilateral breath sounds              │
│ • Symmetric chest rise                 │
│ • Fogging of ETT                       │
│                                         │
│ 🔒 Secure ETT:                          │
│ • Note depth at lip/teeth (21-23cm)   │
│ • Secure with tape/device              │
│ • C-spine collar if indicated          │
│                                         │
│ [Next: Post-intubation management ▶]   │
│                                         │
│ [◀ Previous: Successful Attempt]       │
└─────────────────────────────────────────┘

### Card 7B – Failed Attempt Protocol (Node U)
┌─────────────────────────────────────────┐
│ ⚠️ FAILED INTUBATION PROTOCOL           │
├─────────────────────────────────────────┤
│ 📊 Assess patient status:               │
│ • Check SpO2 and vital signs           │
│ • Evaluate ventilation ability         │
│                                         │
│ ❓ SpO2 >90% and stable?                │
│                                         │
│ 🔘 YES → Second attempt strategy:       │
│   • Different operator                 │
│   • Different technique               │
│   • Video laryngoscopy if not used    │
│                                         │
│ 🔘 NO → Rescue ventilation:            │
│   • Bag-mask ventilation              │
│   • Consider LMA rescue device        │
│                                         │
│ [◀ Previous] [Next: Based on Selection ▶]│
└─────────────────────────────────────────┘

### Card 8A – Second Attempt Strategy (Node V → X)
┌─────────────────────────────────────────┐
│ 🔄 SECOND INTUBATION ATTEMPT            │
├─────────────────────────────────────────┤
│ 🛠️ Modify technique:                    │
│ • Change to video laryngoscopy         │
│ • Different blade size/type            │
│ • External manipulation                │
│ • Bougie-first technique               │
│                                         │
│ 👨‍⚕️ Consider operator change:            │
│ • Most experienced available           │
│ • Fresh perspective                    │
│                                         │
│ ⏱️ Time and safety limits:              │
│ • Maximum 30 seconds                   │
│ • Stop if deterioration               │
│                                         │
│ [Next: Second attempt result ▶]        │
│                                         │
│ [◀ Previous: Failed Attempt]           │
└─────────────────────────────────────────┘

### Card 8B – Rescue Ventilation (Node W → Y)
┌─────────────────────────────────────────┐
│ 🆘 RESCUE VENTILATION PROTOCOL          │
├─────────────────────────────────────────┤
│ 🫁 Bag-mask ventilation:                │
│ • Two-person technique preferred       │
│ • Optimize mask seal                   │
│ • Jaw thrust maneuver                  │
│                                         │
│ 📈 If BVM inadequate:                   │
│ • LMA or i-gel insertion               │
│ • Supraglottic airway rescue          │
│                                         │
│ ⚠️ Cannot ventilate scenario:           │
│ • Prepare for surgical airway         │
│ • Call for help immediately           │
│                                         │
│ [Next: LMA rescue device ▶]           │
│                                         │
│ [◀ Previous: Failed Attempt]           │
└─────────────────────────────────────────┘

### Card 9A – LMA Rescue (Node Y → Z)
┌─────────────────────────────────────────┐
│ 🛟 LMA RESCUE DEVICE                    │
├─────────────────────────────────────────┤
│ 🎯 Device options:                      │
│ • LMA Supreme (recommended)            │
│ • i-gel supraglottic airway           │
│ • LMA ProSeal                         │
│                                         │
│ 📋 Insertion technique:                 │
│ • Deflate cuff completely             │
│ • Insert blindly along hard palate    │
│ • Inflate cuff when seated             │
│                                         │
│ ✅ Success indicators:                  │
│ • ETCO2 waveform present               │
│ • Adequate chest rise                 │
│ • Acceptable ventilation              │
│                                         │
│ [Next: Adequacy assessment ▶]         │
│                                         │
│ [◀ Previous: Rescue Ventilation]       │
└─────────────────────────────────────────┘

### Card 9B – Surgical Airway (Node S - Final)
┌─────────────────────────────────────────┐
│ 🔪 EMERGENCY SURGICAL AIRWAY            │
├─────────────────────────────────────────┤
│ 🚨 Cannot intubate, cannot ventilate:   │
│ • Last resort intervention             │
│ • Time critical - minutes matter      │
│                                         │
│ 🔧 Cricothyrotomy procedure:            │
│ • Palpate cricothyroid membrane        │
│ • Scalpel-bougie-tube technique        │
│ • Size 6.0 cuffed ETT or Shiley       │
│                                         │
│ 📞 Call for surgical backup:            │
│ • ENT: ext. 6666                       │
│ • General Surgery if unavailable      │
│                                         │
│ ✅ SURGICAL AIRWAY ESTABLISHED         │
│                                         │
│ [◀ Previous: LMA Rescue Failed]        │
└─────────────────────────────────────────┘

### Card 10 – Post-Intubation Management (Node BB → CC)
┌─────────────────────────────────────────┐
│ 🏥 POST-INTUBATION MANAGEMENT           │
├─────────────────────────────────────────┤
│ 💊 Sedation and analgesia:              │
│ • Propofol 5-80 mcg/kg/min             │
│ • Fentanyl 25-200 mcg/hr               │
│ • Midazolam 1-10 mg/hr                 │
│                                         │
│ 🫁 Ventilator settings:                 │
│ • Tidal volume: 6-8 mL/kg IBW          │
│ • PEEP: 5 cmH2O                        │
│ • Rate: 12-20 based on pH/CO2          │
│ • FiO2: Titrate to SpO2 92-98%         │
│                                         │
│ 📸 Confirm placement:                   │
│ • Chest X-ray                          │
│ • ETT position verification            │
│                                         │
│ ✅ POST-INTUBATION PROTOCOL COMPLETE   │
│                                         │
│ [◀ Previous: Placement Confirmation]   │
└─────────────────────────────────────────┘

## VIRTUA VOORHEES AIRWAY MANAGEMENT ADDENDA

### **Enhanced Airway Program:**
- **Expert Backup:** Anesthesia team available 24/7 via ext. 5555
- **Surgical Support:** ENT/General Surgery backup via ext. 6666
- **Equipment Standards:** Video laryngoscopy first-line approach
- **Training Program:** Monthly difficult airway simulation sessions

### **Medication Protocols - Virtua Specific:**
**Weight-Based Dosing Calculator:**
- **Etomidate:** 0.3 mg/kg (hemodynamically stable patients)
- **Ketamine:** 1-2 mg/kg (shock, asthma, bronchospasm)
- **Propofol:** 1-2 mg/kg (status epilepticus, increased ICP)
- **Rocuronium:** 1.2 mg/kg (preferred, reversible with sugammadex)
- **Succinylcholine:** 1.5 mg/kg (faster onset, multiple contraindications)

**Post-Intubation Sedation:**
- **Propofol infusion:** 5-80 mcg/kg/min titrated to sedation goal
- **Fentanyl infusion:** 25-200 mcg/hr for analgesia
- **Midazolam alternative:** 1-10 mg/hr if propofol contraindicated

### **Equipment Checklist - Always Available:**
- **Primary:** Video laryngoscope (preferred first choice)
- **Backup:** Direct laryngoscope with multiple blade sizes
- **Rescue devices:** LMA Supreme, i-gel, Combitube
- **Surgical:** Cricothyrotomy kit readily accessible
- **Confirmation:** Continuous waveform capnography mandatory

### **Quality Improvement Metrics:**
- **First-pass success rate:** Target >85% for emergency department
- **Complications tracking:** Esophageal intubation, aspiration, dental trauma
- **Time to successful intubation:** Goal <5 minutes from decision
- **Video review program:** Monthly analysis of difficult cases

### **Difficult Airway Predictors (LEMON Assessment):**
**Look externally:**
- Facial trauma, burns, obesity, beard
- Previous surgical scars, radiation changes

**Evaluate 3-3-2 rule:**
- 3 fingers mouth opening (>3cm)
- 3 fingers hyomental distance (>6cm)  
- 2 fingers thyromental distance (>4cm)

**Mallampati classification:**
- Class I: Soft palate, uvula, pillars visible
- Class II: Soft palate, uvula visible
- Class III: Soft palate, base of uvula visible
- Class IV: Only hard palate visible

**Obstruction/Obesity:**
- BMI >35, neck circumference >60cm (males), >55cm (females)
- Sleep apnea, snoring history

**Neck mobility:**
- Limited range of motion, C-spine injury
- Previous cervical surgery or arthritis

### **Emergency Contacts & Escalation:**
- **Anesthesia consult:** ext. 5555 (available 24/7)
- **ENT emergency:** ext. 6666 (surgical airway backup)
- **Critical care medicine:** For post-intubation management
- **Respiratory therapy:** Ventilator setup and optimization

## REFERENCE GUIDELINES
- **2015 Difficult Airway Society Guidelines**
- **2022 American Society of Anesthesiologists Practice Guidelines**
- **Emergency Medicine Airway Management Consensus Guidelines**
- **Virtua Health System Airway Protocol v2025**

**This protocol reflects current evidence-based airway management guidelines optimized for emergency rapid sequence intubation with comprehensive backup plans and post-intubation care at Virtua Voorhees.**
