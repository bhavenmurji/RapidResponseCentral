# Acute Pain Management – Clinical Call Protocol

**Guidelines Referenced:**  
American Pain Society Guidelines for the Management of Postoperative Pain 2016, American Society of Anesthesiologists Practice Guidelines for Acute Pain Management 2012, World Health Organization Analgesic Ladder 2019, Joint Commission Standards for Pain Assessment and Management 2023

**Official Sources:**  
https://www.americanpainsociety.org/guidelines/postoperative-pain-management  
https://pubs.asahq.org/anesthesiology/article/116/2/248/13395/Practice-Guidelines-for-Acute-Pain-Management-in  
https://www.who.int/medicines/areas/quality_safety/guide_on_pain/en/

## CARD INTERFACE LAYOUT

### Card 0 – Dynamic Action Card (Node Dependent)

**Initial Assessment Node:**

~~~
ACUTE PAIN EVALUATION
───────────────────────────────────────

🚨 PAIN CRISIS: Severe breakthrough pain requiring action
Current pain score: ___/10 at rest, ___/10 with movement

┌─────────────────────────────────┐
│     IMMEDIATE ASSESSMENT        │
│ ☑ Pain score documented         │ [0-10 scale both rest/movement]
│ ☑ PCA usage reviewed            │ [Utilization pattern analysis]
│ ☑ Vital signs obtained          │ [Signs of sympathetic response]
│ ☑ Current regimen assessed      │ [Efficacy evaluation]
│ ☐ Multimodal agents added       │ [Consider additions]
│ ☐ PCA settings optimized        │ [Dose/interval adjustment] 
│ ☐ Breakthrough pain covered     │ [PRN medications]
│                                │
│ PCA Usage Pattern Assessment    │
│ Functional Impact Evaluation    │
└─────────────────────────────────┘

VITAL SIGNS: BP ___/___, HR ___, RR ___, SpO2 ___%, T ___°C
Signs of inadequate control: Tachycardia, hypertension, diaphoresis

📞 PAIN SERVICE: ext. 5555 [CONSULT IF REFRACTORY]

⚠️ INADEQUATE CONTROL - Consider multimodal approach
~~~

**Multimodal Addition Node:**

~~~
INADEQUATE PCA CONTROL - MULTIMODAL PROTOCOL
───────────────────────────────────────

Current regimen inadequate for pain control
Pain persists despite maximum utilization

┌─────────────────────────────────┐
│     MULTIMODAL ADDITIONS        │
│ ☐ Ketorolac 15mg IV STAT        │ [Then q6h x 48h max]
│   Check: Cr, bleeding risk      │ [Monitor renal daily]
│ ☐ Acetaminophen 1g IV STAT      │ [Then q6h scheduled]
│   Max 4g/day (3g if hepatic)    │ [Switch PO when able]
│ ☐ Gabapentin 300mg PO TID       │ [Neuropathic component]
│   Titrate to effect/tolerance   │ [Monitor sedation]
│                                │
│ PCA OPTIMIZATION:               │
│ • Consider demand dose increase │
│ • Evaluate lockout interval    │
│ • Assess need for basal rate    │
└─────────────────────────────────┘

BREAKTHROUGH COVERAGE:
• Additional short-acting opioid PRN for severe episodes
• Nursing protocols for breakthrough pain >7/10

EXPECTED OUTCOME: 30-40% pain reduction with multimodal
TARGET: Functional pain <6/10 rest, <7/10 with movement
REASSESS: In 1-2 hours for effectiveness
~~~

**Opioid Rotation Node:**

~~~
OPIOID ROTATION INDICATED
───────────────────────────────────────

Failed adequate trial of current opioid
Consider incomplete cross-tolerance and individual variation

┌─────────────────────────────────┐
│     CONVERSION CALCULATION      │
│                                │
│ Step 1: Calculate total daily MME │
│ Step 2: Apply 75% safety factor │ 
│ Step 3: Convert to new opioid   │
│ Step 4: Set conservative PCA    │
│                                │
│ COMMON CONVERSIONS:             │
│ • Morphine 6mg IV = Hydromorphone 1mg IV │
│ • Morphine 3:1 = Oral to IV ratio │
│ • Always use 75% safety reduction │
│                                │
│ NEW PCA SETTINGS:               │
│ • Start with conservative demand │
│ • Standard lockout interval     │
│ • No basal rate initially      │
│ • Monitor closely first 2 hours │
└─────────────────────────────────┘

SAFETY PROTOCOL:
• Monitor sedation q15min x 2 hours initially
• Respiratory rate monitoring continuous
• Have naloxone 0.4mg available at bedside
• May need dose adjustment based on response

RATIONALE: Individual receptor polymorphisms, incomplete
cross-tolerance may improve efficacy with rotation
~~~

### Card 1 – Static Assessment/Pain Characteristics & Red Flags

~~~
PAIN CHARACTERISTICS & RED FLAG FEATURES

📊 ACUTE vs CHRONIC DIFFERENTIATION:
• Acute: <3 months, clear etiology, expected trajectory
• Chronic: >3 months, multiple factors, central sensitization

📅 POST-OPERATIVE EXPECTATIONS:
• Day 0-1: Severe (7-10/10)  • Day 2-3: Moderate (4-7/10)
• Day 4+: Steadily improving (<4/10)

🚨 RED FLAG FEATURES (Urgent evaluation):
• New neurologic deficits, bowel/bladder dysfunction
• Fever with spinal/back pain, night pain with weight loss
• Disproportionate pain to injury mechanism

🆘 PAIN EMERGENCIES (Immediate intervention):
• Compartment syndrome: 5 P's (Pain, Pallor, Paresthesias, Pulselessness, Paralysis)
• Cauda equina syndrome: Saddle anesthesia, retention
• Aortic dissection: Tearing chest/back pain
• Acute abdomen: Peritonitis, obstruction
• Necrotizing fasciitis: Severe pain, systemic toxicity

📝 ASSESSMENT TOOLS:
• Numeric Rating Scale (0-10), FACES Scale
• Behavioral indicators, functional impact assessment

⚡ NEUROPATHIC PAIN INDICATORS:
• Burning/shooting quality, allodynia, hyperalgesia
• Distribution following nerve/dermatome patterns
~~~

### Card 2 – Static Physical Exam/Medications & Conversions

~~~
ANALGESIC OPTIONS & CONVERSIONS

🔍 FOCUSED PAIN EXAMINATION:
• Inspection, palpation, range of motion, neurologic exam
• Functional assessment: Mobility, weight-bearing capacity

💊 NON-OPIOID ANALGESICS:
• Acetaminophen: 650-1000mg q6h (max 4g/day, 3g if risk)
• Ketorolac: 15-30mg IV/IM q6h (max 5 days total)
• NSAIDs: Check Cr first, avoid if GFR <60 or bleeding

💊 ADJUVANT MEDICATIONS:
• Gabapentin: 300mg TID → titrate to 900mg TID
• Pregabalin: 75mg BID → titrate to 150-300mg BID
• Duloxetine: 30-60mg daily (neuropathic pain)
• Cyclobenzaprine: 5-10mg TID (muscle relaxant)

💊 OPIOID CONVERSIONS (Morphine Milligram Equivalents):
• PO Morphine 30mg = IV Morphine 10mg = IV Hydromorphone 1.5mg
• PO Oxycodone 20mg = PO Hydromorphone 6mg
• Fentanyl patch 12mcg/hr = PO Morphine 30mg daily
• IV:PO Ratios: Morphine 1:3, Hydromorphone 1:4

💊 ADVANCED INTERVENTIONS:
• Ketamine: 0.1-0.5mg/kg/hr (NMDA antagonist)
• Lidocaine: 1-2mg/kg/hr (sodium channel blocker)
• Regional blocks: Nerve blocks, neuraxial techniques
• Topical agents: Lidocaine patches, capsaicin cream

🎛️ PCA OPTIMIZATION PARAMETERS:
• Demand dose: Start conservative, titrate to effect
• Lockout interval: 6-15 minutes typically
• Basal rate: Use cautiously, controversial
• 4-hour limits: Prevent overdose, monitor utilization

MONITORING: Pain scores q4h, sedation levels, respiratory rate, PCA utilization patterns, functional goals
~~~

## FLOWCHART (Algorithm Decision Tree)

~~~mermaid
graph TD
    A[Severe Acute Pain Recognition] --> B[Assess Current Pain Regimen]
    B --> C{Adequate Trial Given?}
    C -->|No| D[Optimize Current & Add Multimodal]
    C -->|Yes| E[Consider Opioid Rotation]
    D --> F[Scheduled Acetaminophen + NSAID if Appropriate]
    F --> G{Neuropathic Component?}
    G -->|Yes| H[Add Gabapentin or Pregabalin]
    G -->|No| I[Reassess in 1-2 hours]
    E --> J[Calculate MME & Use 75% for Safety]
    J --> K[Start New Opioid & Monitor Closely]
    I --> L{Pain Improved?}
    L -->|Yes| M[Continue Plan & Taper as Able]
    L -->|No| N[Regional Block & Pain Service Consult]
    K --> O{Rotation Effective?}
    O -->|Yes| M
    O -->|No| P[Adjust Dose or Try Another Agent]
    N --> Q[Ketamine/Lidocaine Infusion Options]
    P --> N
~~~

## INTERACTIVE ELEMENTS

### PCA Usage Analyzer

~~~
┌─────────────────────────────────────────┐
│         PCA USAGE ANALYSIS              │
├─────────────────────────────────────────┤
│ USAGE PATTERN EVALUATION:               │
│ • Attempt-to-delivery ratio assessment  │
│ • Frequency of lockout periods         │
│ • Total medication consumption tracking │
│ • Pain score correlation analysis       │
│                                         │
│ PATTERN INTERPRETATION:                 │
│ 🔴 MAXIMAL UTILIZATION                  │
│ • Frequent lockout encounters           │
│ • High attempt-to-delivery ratio        │
│ • Suggests inadequate control           │
│                                         │
│ 🟡 MODERATE UTILIZATION                 │
│ • Occasional lockouts                   │
│ • Variable usage pattern                │
│ • May benefit from optimization         │
│                                         │
│ 🟢 APPROPRIATE UTILIZATION              │
│ • Consistent effective doses            │
│ • Minimal lockout violations            │
│ • Good pain control achieved            │
│                                         │
│ OPTIMIZATION STRATEGIES:                │
│ • Increase demand dose if maximal use   │
│ • Decrease lockout interval             │
│ • Add multimodal adjuvants              │
│ • Consider basal rate for consistent pain│
└─────────────────────────────────────────┘
~~~

### Opioid Rotation Calculator

~~~
┌─────────────────────────────────────────┐
│      OPIOID ROTATION CALCULATOR         │
├─────────────────────────────────────────┤
│ CONVERSION METHODOLOGY:                 │
│ • Step 1: Calculate current total daily MME │
│ • Step 2: Apply 75% safety reduction factor │
│ • Step 3: Convert to new opioid equivalent │
│ • Step 4: Determine PCA parameters      │
│                                         │
│ COMMON CONVERSIONS:                     │
│ • Morphine 6mg IV = Hydromorphone 1mg IV │
│ • Morphine 3:1 = Oral to IV ratio       │
│ • Fentanyl 100mcg IV = Morphine 10mg IV │
│ • Always apply 75% safety reduction     │
│                                         │
│ SAFETY PROTOCOLS:                       │
│ ⚠️ Monitor sedation q15min x 2 hours     │
│ ⚠️ Respiratory monitoring continuous     │
│ ⚠️ Naloxone 0.4mg at bedside            │
│ ⚠️ May need dose adjustment based on response │
│                                         │
│ EXPECTED OUTCOMES:                      │
│ • 25-50% improvement in analgesia       │
│ • Reduced side effects profile          │
│ • Better functional outcomes            │
└─────────────────────────────────────────┘
~~~

### Multimodal Pain Regimen Builder

~~~
┌─────────────────────────────────────────┐
│    MULTIMODAL PAIN REGIMEN OPTIMIZER    │
├─────────────────────────────────────────┤
│ ASSESSMENT PARAMETERS:                  │
│ • Primary pain mechanism: Nociceptive/Neuropathic/Mixed │
│ • Current opioid effectiveness percentage │
│ • Contraindication screening completed   │
│                                         │
│ AVAILABLE ADJUVANTS:                    │
│                                         │
│ ACETAMINOPHEN PROTOCOL:                 │
│ • Expected benefit: +20% pain reduction │
│ • Dose: 1g q6h PO/IV (max 4g/day)      │
│ • Screen: Hepatic function, alcohol use │
│                                         │
│ NSAID PROTOCOL:                         │
│ • Expected benefit: +25% pain reduction │
│ • Ketorolac 15mg IV q6h (max 5 days)   │
│ • Screen: Renal function, bleeding risk │
│                                         │
│ NEUROPATHIC AGENTS:                     │
│ • Expected benefit: +15% pain reduction │
│ • Gabapentin 300mg TID or Pregabalin 75mg BID │
│ • Monitor: Sedation, dizziness          │
│                                         │
│ REGIONAL TECHNIQUES:                    │
│ • Expected benefit: +40% pain reduction │
│ • Nerve blocks, epidurals available     │
│ • Requires consultation                 │
│                                         │
│ PREDICTED OUTCOMES:                     │
│ • Full multimodal: 60-80% pain reduction │
│ • Functional goal: <4/10 for PT participation │
│ • Opioid sparing: 30-50% requirement reduction │
└─────────────────────────────────────────┘
~~~

## NODE-TO-DYNAMIC CARD PROMPT MAPPING (WITH INTERACTIVES)

| **Step (Node)**                    | **Dynamic Card Prompt/Question**                                                                 | **Interactive Components**                                        |
|-------------------------------------|--------------------------------------------------------------------------------------------------|-------------------------------------------------------------------|
| Severe Pain Recognition (A)         | "Severe acute pain identified (>7/10). Begin systematic pain assessment and management?"        | [Start Protocol], [Pain Scale], [Assessment Timer]               |
| Current Regimen Assessment (B)      | "Evaluate current pain management regimen. Has adequate trial been given?"                      | [Regimen Review], [Trial Adequacy], [PCA Analyzer]                |
| Adequate Trial Decision (C)         | "Current regimen trialed adequately? Consider duration, dosing, compliance factors?"           | [Trial Criteria], [Duration Check], [Compliance Assessment]       |
| Multimodal Optimization (D)         | "Inadequate trial identified. Add multimodal agents and optimize current therapy?"             | [Multimodal Menu], [Contraindication Screen], [Dose Calculator]   |
| Opioid Rotation Consideration (E)   | "Adequate trial completed but inadequate response. Consider opioid rotation?"                   | [Rotation Criteria], [Opioid Converter], [Safety Assessment]        |
| Non-Opioid Addition (F)             | "Add scheduled acetaminophen and NSAID if no contraindications present?"                       | [APAP Dosing], [NSAID Selection], [Renal Function Check]          |
| Neuropathic Assessment (G)          | "Assess for neuropathic pain component. Add gabapentinoid if indicated?"                       | [Neuropathic Screen], [Gabapentin Dosing], [Titration Schedule]   |
| Gabapentin Addition (H)             | "Neuropathic component identified. Start gabapentin 300mg TID with titration plan?"            | [Start Gabapentin], [Titration Guide], [Side Effect Monitor]      |
| Reassessment Point (I)              | "Reassess pain response in 1-2 hours. Document pain scores and functional improvement?"        | [Pain Reassessment], [Function Scale], [Response Tracker]         |
| MME Calculation (J)                 | "Calculate current MME and apply 75% safety factor for opioid rotation?"                       | [Opioid Converter], [Safety Factor], [Conversion Tables]            |
| New Opioid Initiation (K)           | "Start new opioid with close monitoring. Set conservative initial parameters?"                  | [New Opioid Setup], [Monitoring Protocol], [Safety Checks]        |
| Pain Improvement Assessment (L,O)   | "Evaluate pain improvement and functional capacity. Continue current plan?"                     | [Improvement Scale], [Function Assessment], [Plan Adjustment]      |
| Regional/Pain Service (N)           | "Pain remains refractory. Consider regional techniques or pain service consultation?"          | [Regional Options], [Pain Service Call], [Advanced Techniques]    |
| Dose Adjustment (P)                 | "Adjust current dose or try alternative opioid based on response and tolerability?"           | [Dose Titration], [Alternative Selection], [Tolerance Assessment]  |
| Advanced Options (Q)                | "Consider ketamine or lidocaine infusions for refractory pain management?"                     | [Ketamine Protocol], [Lidocaine Infusion], [ICU Consideration]    |

**Interactive Highlights:**  
- Real-time pain score tracking with trend analysis
- PCA utilization analyzer with pattern recognition
- Weight-based medication calculator with safety verification
- Multimodal regimen builder with contraindication screening
- Opioid rotation calculator with 75% safety factor application

## VIRTUA VOORHEES ACUTE PAIN MANAGEMENT ADDENDA

- **Pain Management Service:** 24/7 consultation available via Transfer Center 856-886-5111 for complex pain cases and interventional procedures
- **Regional Anesthesia Team:** Nerve blocks, epidurals, and advanced regional techniques with ultrasound guidance capabilities
- **Pharmacy Clinical Services:** Pain medication optimization, opioid conversion calculations, and multimodal protocol development
- **Quality Metrics:** Time to adequate pain control, multimodal utilization rates, patient satisfaction scores, opioid stewardship compliance

## REFERENCE (GUIDELINE & SOURCE)
American Pain Society. Guidelines for the Management of Postoperative Pain. 2016.  
https://www.americanpainsociety.org/guidelines/postoperative-pain-management

**Additional References:**  
American Society of Anesthesiologists. Practice Guidelines for Acute Pain Management in the Perioperative Setting. 2012.  
https://pubs.asahq.org/anesthesiology/article/116/2/248/13395/Practice-Guidelines-for-Acute-Pain-Management-in

World Health Organization. WHO Guidelines for the Pharmacological and Radiotherapeutic Management of Cancer Pain in Adults and Adolescents. 2019.  
https://www.who.int/medicines/areas/quality_safety/guide_on_pain/en/

Chou R, et al. Management of Postoperative Pain: A Clinical Practice Guideline From the American Pain Society. J Pain. 2016.  
https://www.jpain.org/article/S1526-5900(15)00995-5/fulltext

**All steps follow current evidence-based guidelines for acute pain management with integrated multimodal analgesia protocols, PCA optimization strategies, and safe opioid rotation calculations for optimal patient comfort and functional recovery.**
