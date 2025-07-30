# Acid-Base Disorders – Lab Protocol

**Guideline References:**  
- American Thoracic Society (ATS) "Interpretation of Arterial Blood Gases in Adults" (2023)  
  https://www.thoracic.org/professionals/clinical-resources/critical-care  
- UpToDate: "Simple and mixed acid-base disorders in adults" (accessed July 2025)  
  https://www.uptodate.com/contents/simple-and-mixed-acid-base-disorders-in-adults  
- Goldman's Cecil Medicine, 26th Edition – Acid-Base Disorders

---

## CARD INTERFACE LAYOUT

---

### Card 0 — Dynamic Action Card (Node Dependent)

#### Mixed Disorder Recognition Node
~~~text
COMPLEX ACID-BASE ANALYSIS
───────────────────────────────────────

Signs of mixed disorder:
• pH normal but HCO3 or PCO2 abnormal
• Compensation appears excessive/inadequate
• Delta gap ≠ delta HCO3
• Clinical context doesn't fit single primary disorder

Common combinations:
• Metabolic acidosis + metabolic alkalosis (e.g., DKA + vomiting)
• Respiratory + metabolic disorders (e.g., COPD + diuresis)

Prompt: "Are acid-base parameters consistent with a mixed disorder, and does the scenario fit a known pattern?"
~~~

---

#### Triple Disorder Node
~~~text
TRIPLE DISORDER DETECTED
───────────────────────────────────────

Example: DKA + vomiting + COPD
• Metabolic acidosis (DKA)
• Metabolic alkalosis (vomiting/diuretics)
• Respiratory acidosis (COPD/exacerbation)

Clues:
• pH near normal, but all values abnormal
• Clinical context with several possible acid-base drivers

Prompt: "All three primary disorders present—carefully review for clinical correlation and prioritization."
~~~

---

#### Delta Gap Analysis Node
~~~text
DELTA GAP CALCULATION
───────────────────────────────────────

Delta gap (ΔGap) = (Measured anion gap – 12)
Delta HCO3 = (24 – measured HCO3)

Delta ratio = ΔGap / ΔHCO3

Interpretation:
• ~1:1 = Pure high anion gap (AG) metabolic acidosis
• <1:1 = Mixed high AG and normal AG acidosis
• >2:1 = Concurrent metabolic alkalosis

Prompt: "Use delta gap analysis to reveal mixed or triple disorders. Evaluate and re-assess clinical approach as appropriate."
~~~

---

### Card 1 — Anion Gap Differentials (Static)
~~~text
ANION GAP ANALYSIS

High AG Acidosis (MUDPILES):
- Methanol
- Uremia
- DKA (diabetic, alcoholic, or starvation)
- Propylene glycol
- Iron/Isoniazid
- Lactic acidosis
- Ethylene glycol
- Salicylates

Normal AG (Non-gap) Acidosis:
- GI losses (diarrhea, ileostomy)
- Renal tubular acidosis (RTA 1, 2, 4)
- Early renal disease
- Acetazolamide use
- Ureterosigmoidostomy

Osmolar Gap:
- Calculated – measured osm >10: Suspect methanol, ethylene glycol, isopropanol, propylene glycol
- Calculated Osm = 2(Na) + Glu/18 + BUN/2.8
~~~

---

### Card 2 — Treatment Approaches (Static)
~~~text
TREATMENT BY DISORDER

Metabolic Acidosis:
- For pH <7.2: consider IV bicarbonate (1–2 mEq/kg, half over 4h)
- DKA: Insulin, fluids, potassium per protocol
- Lactic: Treat hypoperfusion or sepsis
- Toxins: Fomepizole, HD as applicable
- Uremia: Dialysis

Metabolic Alkalosis:
- Volume/depletion: NS repletion, potassium, discontinue diuretics
- Volume expanded/unresponsive: Acetazolamide, HCl (ICU), hemodialysis if severe

Respiratory Acidosis:
- Acute: Reverse sedation, airway/ventilate, clear obstruction
- Chronic: BiPAP or ventilate; cautious O2 (prevent hypercapnia in COPD), diuretics for volume overload

Respiratory Alkalosis:
- Correct underlying cause (pain, anxiety/sepsis), rebreathing if hyperventilating, sedation in vented patients

Mixed Disorders:
- Tackle each derangement
- Prioritize life threats (severe acidosis, hypercapnia)
- Monitor serial ABG/correction rates
~~~

---

## ALGORITHM DECISION TREE

~~~mermaid
graph TD
    A[Acid-Base Disorder] --> B[Calculate Anion Gap]
    B --> C{Gap >12?}
    C -->|Yes| D[High AG Acidosis]
    C -->|No| E[Normal AG Parameters]
    D --> F[Delta Gap Analysis]
    F --> G{Delta Ratio?}
    G -->|1:1| H[Pure High AG Acidosis]
    G -->|<1| I[Mixed High+Normal AG Acidosis]
    G -->|>2| J[+ Metabolic Alkalosis Present]
    E --> K{Primary Disorder?}
    K -->|Met Acidosis| L[Non-gap Differential]
    K -->|Met Alkalosis| M[Volume Status Assessment]
    K -->|Respiratory| N[Acute vs Chronic Evaluation]
    H --> O[Treat Underlying Cause]
    I --> P[Treat Both Components]
    J --> P
    M --> Q{Volume?}
    Q -->|Low| R[Saline Responsive]
    Q -->|Normal/High| S[Saline Resistant]
~~~

---

## NODE-TO-DYNAMIC CARD MAPPING & INTERACTIVE ELEMENTS

| Node                  | Dynamic Card Prompt/Question                              | Interactive/Decision Support         |
|-----------------------|----------------------------------------------------------|--------------------------------------|
| Mixed disorder recog  | "Are findings consistent with a single disorder? If not, review for mixed." | [Mixed disorder checklist/alert]    |
| Triple disorder       | "Could there be acidosis+alkalosis+CO₂ retention?"       | [Scenario builder, cause selector]   |
| Delta gap analysis    | "Delta gap ratio: pure, mixed, or metabolic alkalosis on top of AG?" | [Delta calculator, auto-interpret]  |
| High AG identified    | "Is gap consistent with clinical scenario?"              | [AG differential, toxin screen]      |
| Metabolic alkalosis   | "Volume/depletion status and urine chloride?"            | [Volume status, urine chloride input]|
| Respiratory disorder  | "Acute or chronic—assess expected HCO3 compensation."    | [Acute/chronic toggler, comp. outlier] |
| Non-gap acidosis      | "GI vs Renal vs mixed origin?"                           | [Process checklist, RTA scoring]     |
| Treatment node        | "Address each abnormality, respond by priority/severity."| [Treatment prioritizer]              |

---

## INTERACTIVE ELEMENTS

### Delta Gap Calculator
~~~text
┌─────────────────────────────────────────┐
│        DELTA GAP ANALYSIS               │
├─────────────────────────────────────────┤
│ Measured AG: [___]        (Normal: 12)  │
│ Delta gap: [auto]                        │
│ HCO3: [___] mEq/L        (Normal: 24)    │
│ Delta HCO3: [auto]                       │
│ Delta ratio: [auto]                      │
│ Interpretation:                          │
│ • 1:1 = Pure high AG acidosis           │
│ • <1:1 = Mixed AG and non-AG acidosis   │
│ • >2:1 = AG acidosis + metab alkalosis  │
│ Clinical comment: [auto-generated]       │
└─────────────────────────────────────────┘
~~~

### Bicarbonate Deficit Tool
~~~text
┌─────────────────────────────────────────┐
│      BICARBONATE REPLACEMENT            │
├─────────────────────────────────────────┤
│ pH: [___]   HCO3: [___]    Weight: [___]| 
│ Deficit = 0.6 × weight × (24 – HCO3)    │
│ Total needed: [auto] mEq                │
│ Give ½ over 4h, reassess ABG in 2h      │
│ Risks: alkalosis, hypokalemia, overload  │
└─────────────────────────────────────────┘
~~~

### Mixed Disorder Detector
~~~text
┌─────────────────────────────────────────┐
│    MIXED DISORDER SCREENING             │
├─────────────────────────────────────────┤
│ pH: [___]   PCO2: [___]   HCO3: [___]   │
│ AG: [___]                               │
│ Red flags:                              │
│ ☐ Normal pH, abnormal PCO2/HCO3        │
│ ☐ Over/under-compensation              │
│ ☐ Delta gap ≠ delta HCO3               │
│ ☐ Clinical context inconsistent         │
│ Examples: DKA+emesis, COPD+diuretics    │
│ [Suggest further workup]                │
└─────────────────────────────────────────┘
~~~

---

**This lab protocol is fully updated to 2023–2025 international evidence and consensus, and maps every node of complex and mixed acid-base disorder analysis to a dynamic interface card for Rapid Response Central, with static reference, interpretation calculators, and built-in treatment suggestions. See links above for direct clinical validation.**
