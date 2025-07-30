# Hypomagnesemia – Lab Protocol

**Guideline References:**  
- American Society for Parenteral and Enteral Nutrition (ASPEN) Electrolyte Management Update 2024  
  https://www.nutritioncare.org/guidelines  
- American Society of Nephrology (ASN) “Electrolyte Disorders: Hypomagnesemia” (2024)  
  https://www.asn-online.org/guidelines  
- UpToDate: “Treatment of hypomagnesemia in adults” (accessed July 2025)  
  https://www.uptodate.com/contents/treatment-of-hypomagnesemia-in-adults

---

## CARD INTERFACE LAYOUT

---

### Card 0 — Dynamic Action Card (Node Dependent)

#### Initial Assessment Node
~~~text
HYPOMAGNESEMIA EVALUATION
───────────────────────────────────────

Severity classification:
• Mild: 1.5–1.7 mg/dL
• Moderate: 1.0–1.4 mg/dL
• Severe: <1.0 mg/dL

Assess for contributing/associated deficiencies:
☑ Check K+ (refractory hypoK is common)
☑ Check Ca2+ (parathyroid resistance)
☑ Check phosphate
☑ ECG for QT, arrhythmias, torsades

Prompt: "What is the Mg level and are there neuromuscular or cardiac symptoms?"
~~~

---

#### IV Replacement Node
~~~text
MAGNESIUM IV PROTOCOL
───────────────────────────────────────

For Mg <1.0 or any symptoms (tetany, seizures, arrhythmia):

Moderate (1.0–1.4 or symptomatic):
• 2g MgSO4 in 100mL NS over 1–2 hours
• Repeat q6h PRN (monitor for dose, cumulative 8–12g/24h max)

Severe/arrhythmic/torsades:
• Initial 2g IV given over 10–20 min (or IV push in cardiac arrest)
• Maintenance: 4–6g continuous over 24h (0.5–1g/hr)
• ICU: consider central for larger doses, especially with chronic diarrhea/fistula losses

Prompt: “Have concurrent K+, Ca2+ been checked and is urgent replacement underway?”
~~~

---

#### Refractory Replacement Node
~~~text
ADDRESSING REFRACTORY LOW MAGNESIUM
───────────────────────────────────────

If Mg remains low despite replacement:

• Check for ongoing GI losses (diarrhea, fistulas, malabsorption)
• Review medications: diuretics, PPIs, aminoglycosides, chemotherapy
• Assess for concurrent hypoK+ (replacement rarely effective until Mg >1.5)
• Increase total dose (up to 6–8g/day; split between IV/PO)
• Combine oral Mg (glycinate/citrate preferred) with IV for maintenance
• Consider amiloride if renal wasting (nephrotoxicity, rare Bartter/Gitelman)
Prompt: “Did you address all ongoing losses and co-replete K+ and Ca2+?”
~~~

---

### Card 1 — Causes & Clinical Features (Static)
~~~text
HYPOMAGNESEMIA OVERVIEW

GI LOSSES:
• Chronic diarrhea, laxative use (most common)
• Malabsorption, short gut, pancreatitis, PPI

RENAL LOSSES:
• Diuretics (loop > thiazide), amphotericin B, aminoglycosides, cisplatin
• Alcohol use/dependence
• Magnesium-losing tubulopathies (Gitelman/Bartter)

OTHER:
• Poor intake, refeeding after starvation, DKA, hungry bone syndrome, pregnancy

SYMPTOMS
Neuromuscular: tremor, hyperreflexia, tetany, seizures, paresthesias, cramps, positive Chvostek/Trousseau
Cardiac: torsades de pointes, wide QT, VT/VF, digitalis toxicity
Associations: refractory hypoK+/hypoCa2+, metabolic alkalosis
~~~

---

### Card 2 — Replacement Strategies (Static)
~~~text
MAGNESIUM REPLACEMENT PROTOCOLS

IV REPLACEMENT:
• MgSO4 (1g = 8 mEq):  
  - Mild: 1–2g IV daily or divided
  - Moderate: 2g q6h IV
  - Severe/symptoms: 2g bolus over 10–20min, then 4–6g IV/24h

Rate Limits:
• Bolus: 2g over 10–20min
• Maintenance: 0.5–1g/hr
• Usual max: 8–12g/24h (renal function considered)

Side Effects:
• Flushing, hypotension, bradycardia, loss of deep tendon reflexes (toxicity)

PO OPTIONS:
• Magnesium oxide: 400–800mg PO BID–TID (diarrhea common, poor absorption)
• Magnesium glycinate/citrate: 200–400mg BID (better tolerated)
• Magnesium chloride: sustained release

SPECIAL SITUATIONS:
• Torsades: 2g IV push over 1–2min
• Eclampsia: 4–6g IV load, then 1–2g/hr
• Severe asthma: 2g over 20min

MONITORING:
• Mg q6h if IV replacement/ICU, daily if stable/oral
• Reflexes and urine output
• Always check K+, Ca2+; replete Mg first in refractory cases

GOAL: 
• Mg >2.0 mg/dL or as needed for arrhythmias
~~~

---

## ALGORITHM DECISION TREE

~~~mermaid
graph TD
    A[Mg <1.8] --> B{Symptoms OR Mg <1.0?}
    B -->|Yes| C[2g MgSO4 IV replacement IV]
    B -->|No| D{Mg Level?}
    C --> E[Check and Replace K+ and Ca++]
    D -->|1.5–1.7| F[PO Mg 400mg BID]
    D -->|1.0–1.4| G[IV + PO Combination]
    E --> H{K+ Low?}
    H -->|Yes| I[Replace Both Simultaneously]
    H -->|No| J[Continue Mg Replacement]
    F --> K[Recheck Mg in 1 week]
    G --> L[2g IV daily + PO]
    I --> M[Mg corrects K+ deficit]
    J --> M
    M --> N{Mg >1.8 in 24h?}
    N -->|Yes| O[Switch to PO Maintenance]
    N -->|No| P[Increase Dose, Seek Ongoing Losses]
    P --> Q{Ongoing GI/Renal Losses?}
    Q -->|Yes| R[Higher daily dose, treat cause]
    Q -->|No| S[6–8g/day until repleted]
~~~

---

## NODE-TO-DYNAMIC CARD MAPPING & INTERACTIVE ELEMENTS

| Algorithm Node     | Dynamic Card Prompt/Question                            | Interactive Features                         |
|--------------------|--------------------------------------------------------|----------------------------------------------|
| Initial detection  | "Assess severity: any symptoms, Mg <1.0?"              | [Mg input/calculator], [Symptom checkboxes]  |
| IV replacement     | "Start 2g IV MgSO4 now. Rate, infusion type?"           | [Dosing guide], [Rate monitor], [Repeat button] |
| Refractory         | "Mg not improving—have all losses/deficiencies been addressed?" | [Co-replacement tool], [PO supplementation tool] |
| K+ or Ca++ low     | "Concurrent hypoK+ or hypoCa++? Replace together."     | [Concurrent correction widget], [Lab panel]  |
| Dose escalation    | "Consider higher (6–8g/day), chronic loss, PO addition."| [Dose calculation], [Monitoring log]         |
| After repletion    | "Switch to oral Mg for maintenance? Monitor labs weekly."| [PO selection], [Planner]                    |

---

## INTERACTIVE ELEMENTS

### Magnesium Deficit Calculator 
~~~text
┌─────────────────────────────────────────┐
│     MAGNESIUM DEFICIT ESTIMATOR         │
├─────────────────────────────────────────┤
│ Current Mg: [___] mg/dL                 │
│ Target: 2.0 mg/dL                       │
│ Deficit estimate (mild/mod/severe): ___ g|
│ Day 1: 4–6g (IV + PO)                   │
│ Day 2–3: 2–4g daily as needed           │
│ Maintenance: 400mg PO daily             │
│ Note: Only 50% retained if normal renal  │
└─────────────────────────────────────────┘
~~~

### IV Administration Guide 
~~~text
┌─────────────────────────────────────────┐
│    MAGNESIUM INFUSION CALCULATOR        │
├─────────────────────────────────────────┤
│ Indication:                             │
│ ○ Asymptomatic replacement              │
│ ○ Tetany/Arrhythmia                     │
│ Recommended:                            │
│ • 2g in 100mL NS over 1–2hr (standard)  │
│ • 2g in 50mL NS over 10–20min (urgent)  │
│ • 2g IV push over 1–2min (torsades)     │
│ Max maintenance: 1g/hr; total 8–12g/24h │
└─────────────────────────────────────────┘
~~~

### Concurrent Deficiency Tool
~~~text
┌─────────────────────────────────────────┐
│    ELECTROLYTE CO-REPLACEMENT           │
├─────────────────────────────────────────┤
│ Potassium: [___] mEq/L                  │
│ If <3.5, replete with Mg                │
│ Calcium: [___] mg/dL                    │
│ If <8.5, replete with Mg                │
│ Phosphate: [___] mg/dL                  │
│ Sequence: Mg FIRST > K+ simultaneously > Ca2+ with improvement │
└─────────────────────────────────────────┘
~~~

---

**Updated and validated using ASPEN, ASN, and latest UpToDate guidelines for electrolyte and critical care management. Each algorithm node is mapped to a concrete dynamic card with embedded interactive tools for Rapid Response Central. Direct external links above enable further validation and education.**
