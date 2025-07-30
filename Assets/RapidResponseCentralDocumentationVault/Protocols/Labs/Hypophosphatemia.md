# Hypophosphatemia – Lab Protocol

**Guideline References:**  
- American Society for Parenteral and Enteral Nutrition (ASPEN) Hypophosphatemia Update 2024  
  https://www.nutritioncare.org/guidelines  
- Kidney Disease: Improving Global Outcomes (KDIGO) Clinical Practice Guidelines for Electrolyte Disorders (2023)  
  https://kdigo.org/guidelines  
- UpToDate: "Treatment of hypophosphatemia in adults" (accessed July 2025)  
  https://www.uptodate.com/contents/treatment-of-hypophosphatemia-in-adults

---

## CARD INTERFACE LAYOUT

---

### Card 0 — Dynamic Action Card (Node Dependent)

#### Initial Assessment Node
~~~text
HYPOPHOSPHATEMIA EVALUATION
───────────────────────────────────────

Severity classification:
• Mild: 2.0–2.4 mg/dL
• Moderate: 1.0–1.9 mg/dL
• Severe: <1.0 mg/dL

Critical level concerns:
• Respiratory failure
• Rhabdomyolysis
• Hemolysis
• Cardiac dysfunction

Prompt: "What is the phosphate level? Are high-risk complications or symptoms present?"
~~~

---

#### IV Replacement Node
~~~text
PHOSPHATE IV PROTOCOL
───────────────────────────────────────

Criteria for IV replacement:
• Phos <1.0 mg/dL
• Severe symptoms (respiratory weakness, hemolysis, rhabdo, cardiac)

Preferred products:
• KPhos (K+ <4.0 mEq/L), NaPhos (K+ >4.0–4.5 mEq/L or hyperkalemia)
• Dose: 0.08–0.24 mmol/kg actual body weight, based on severity
  - 1.5–1.9 mg/dL: 0.08 mmol/kg
  - 1.0–1.4 mg/dL: 0.16 mmol/kg
  - <1.0 mg/dL: 0.24 mmol/kg

• Dilute in 250–500mL NS, infuse over 4–6 hours (central line if >20mmol)
• Do not exceed 7 mmol/hr
• Monitor closely for hypocalcemia, arrhythmia
Prompt: "Confirm safe product, dose, and access before starting; monitor for side effects."
~~~

---

#### Refeeding Risk Node
~~~text
REFEEDING SYNDROME ALERT
───────────────────────────────────────

High-risk individuals:
• Chronically malnourished (BMI <18.5, chronic alcohol use, anorexia)
• Prolonged NPO or minimal intake >5 days
• Initial feeding, DKA, cachexia

Prevention protocol:
• Check phosphate (and K+, Mg++) before starting feeds
• If <2.5 mg/dL: REPLACE before feeds start
• Thiamine 100mg IV/PO given before and with feedings
• Monitor Phos and other lytes daily for 72h after starting nutrition

Prompt: "Identify risk for refeeding. Hold aggressive caloric repletion until electrolytes replaced."
~~~

---

### Card 1 — Causes & Complications (Static)
~~~text
HYPOPHOSPHATEMIA CAUSES

SHIFTS:
• Refeeding syndrome (insulin/glucose), respiratory alkalosis (hyperventilation), hungry bone, parathyroidectomy

DECREASED ABSORPTION:
• Vitamin D deficiency, malabsorption (short gut, steatorrhea), phosphate binders, chronic diarrhea, alcoholism

INCREASED RENAL LOSSES:
• Diuretics, hyperparathyroidism, post-ATN diuresis, Fanconi syndrome, CRRT

COMPLICATIONS:
• Severe: Respiratory failure, myocardial depression, hemolysis, rhabdomyolysis, impaired leukocyte/platelet function
• Moderate: Weakness, bone pain, confusional states, poor wound healing

KEY ASSOCIATIONS:
• Often with low K+ and Mg++
• Check/replace thiamine in vulnerable patients
• Regular glucose, lyte monitoring during repletion
~~~

---

### Card 2 — Replacement Guidelines (Static)
~~~text
PHOSPHATE REPLACEMENT GUIDELINES

IV:
• 1.5–1.9 mg/dL: 0.08 mmol/kg (5–10mmol typical adult dose)
• 1.0–1.4 mg/dL: 0.16 mmol/kg (10–20mmol)
• <1.0 mg/dL: 0.24 mmol/kg (up to 25–45 mmol in severe cases)
• Product: KPhos (for low/normal K+), NaPhos (for high K+)
• Admin: Mix in 250–500mL NS, infuse over 4–6h (max 7 mmol/h)
• Use central line for large doses (>20 mmol), frequent Ca++ checks

PO:
• Mild/moderate, able to tolerate: Neutra-Phos/K-Phos 250–500mg PO TID–QID with meals
• Dairy products/milk are excellent PO sources
• GI symptoms (cramps, nausea, diarrhea) can limit PO tolerability

SPECIAL SITUATIONS:
• Refeeding, DKA: Replace preemptively if <2.5; thiamine first for refeeding
• Monitor Mg, K+ (replace as needed for full effect)

COPRESCRIPTION:
• Always monitor Ca++ for hypocalcemia/metastatic calcification in CKD
• Never rapid IV push; risk of tetany/arrhythmia/death

MONITORING:
• Recheck Phos 2–4h after IV, then q6–12h until >2.0
• Maintain: >2.0 mg/dL; higher targets if critical illness
• Routine daily labs during oral therapy
~~~

---

## ALGORITHM DECISION TREE

~~~mermaid
graph TD
    A[Phos <2.5 mg/dL] --> B{Level and Symptoms?}
    B -->|<1.0 or Severe Symptoms| C[IV Replacement – Urgent]
    B -->|1.0–2.0 Asymptomatic| D[IV vs PO Based on Severity]
    B -->|2.0–2.4| E[PO Replacement Adequate]
    C --> F[Calculate Dose 0.16–0.24 mmol/kg]
    D --> G{Can Take PO?}
    G -->|Yes| H[Phos 1000mg PO TID]
    G -->|No| I[IV 0.08–0.16 mmol/kg]
    F --> J[Infuse IV over 4–6h]
    E --> K[500–1000mg PO Daily]
    J --> L[Recheck in 4h, Monitor Ca++]
    L --> M{Phos >1.5?}
    M -->|Yes| N[Continue PO Supplement]
    M -->|No| O[Repeat IV Dose, Search for Ongoing Losses]
    H --> P[Monitor Daily]
    K --> P
    P --> Q{Corrected/Stable?}
    Q -->|Yes| R[Wean/Stop, Address Cause]
    Q -->|No| S[Increase Dose, Check Compliance, Ongoing Losses]
~~~

---

## NODE-TO-DYNAMIC CARD MAPPING & INTERACTIVE ELEMENTS

| Algorithm Node      | Dynamic Card Prompt/Question                                  | Interactive/Decision Support                |
|---------------------|--------------------------------------------------------------|---------------------------------------------|
| Initial Detection   | "How low is phosphate and are there critical symptoms?"       | [Phos entry/calculator], [Symptom check]    |
| IV Replacement      | "Urgent IV needed? Calculate dose, product, and route."      | [IV Phos calculator], [K+/Na+ choice]       |
| Refeeding Alert     | "At-risk for refeeding? Replace before feeding, give thiamine." | [Refeeding risk screen], [Order set]     |
| PO vs IV selection  | "Can patient take oral? Pick route by tolerance/severity."    | [Route selector], [Product/dose recommendations]|
| Monitoring/Repeat   | "Monitor Phos q2–4h after dose, with full lyte panel."        | [Scheduling tracker], [Level auto-reminder] |
| Ongoing Low         | "Not correcting? Seek ongoing GI/renal losses, check compliance." | [Loss review], [Increment recommendation]|
| Normalized          | "Stable for 2–3 days? Stop supplement, address underlying cause." | [De-escalate], [Education script]        |

---

## INTERACTIVE ELEMENTS

### IV Phosphate Calculator
~~~text
┌─────────────────────────────────────────┐
│      PHOSPHATE DOSING CALCULATOR        │
├─────────────────────────────────────────┤
│ Current Phos: [___] mg/dL               │
│ Weight: [___] kg                        │
│ Severity: ○ Mild (2.0–2.4) ○ Mod (1.0–1.9) ○ Severe (<1.0) │
│ Dose (mmol/kg): [auto-calc]             │
│ Product: [KPhos | NaPhos]               │
│ K+ level: [___] mEq/L                   │
│ Volume: [auto]                          │
│ Infusion: 4–6 hr, max 7 mmol/hr         │
│ [ORDER SUMMARY]                         │
└─────────────────────────────────────────┘
~~~

### Refeeding Syndrome Risk Assessment
~~~text
┌─────────────────────────────────────────┐
│    REFEEDING SYNDROME SCREENING         │
├─────────────────────────────────────────┤
│ Risk factors present:                   │
│ [ ] BMI <18.5                           │
│ [ ] >10% weight loss past 6 months      │
│ [ ] NPO or poor intake >5 days          │
│ [ ] Alcohol use disorder                │
│ [ ] Other malnutrition                  │
│ Key labs: Phos/K+/Mg                    │
│ Plan:                                   │
│ • Replace deficits before feeding        │
│ • Thiamine 100mg prior                  │
│ • Monitor all lytes daily x3 days       │
└─────────────────────────────────────────┘
~~~

### Monitoring Schedule
~~~text
┌─────────────────────────────────────────┐
│     PHOSPHATE MONITORING PLAN           │
├─────────────────────────────────────────┤
│ Baseline Phos: ___ mg/dL                │
│ Treatment start: ___:___                 │
│ IV: Check 2–4h post, q6h until stable    │
│ PO: Daily x3 days, then 2x weekly        │
│ Key: Monitor Ca++, K+, Mg, renal funct   │
│ Protocol ready for Rapid Response        │
└─────────────────────────────────────────┘
~~~

---

**Protocol reflects ASPEN, KDIGO, and UpToDate best practices for detection, correction, and prevention of complications. All dynamic nodes are mapped to decision-support cards and interactive tools for bedside use. Direct clinical validation available via links above.**
