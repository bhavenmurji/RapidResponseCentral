# ABG Interpretation – Lab Protocol

**Guideline References:**  
- American Thoracic Society (ATS) "Interpretation of Arterial Blood Gases in Adults" 2023  
  https://www.thoracic.org/professionals/clinical-resources/critical-care  
- UpToDate: "Simple and mixed acid-base disorders in adults" (accessed July 2025)  
  https://www.uptodate.com/contents/simple-and-mixed-acid-base-disorders-in-adults  
- Goldman's Cecil Medicine, 26th Edition – Chapter: Acid-Base Disorders

---

## CARD INTERFACE LAYOUT

---

### Card 0 — Dynamic Action Card (Node Dependent)

#### Initial ABG Assessment Node
~~~text
ABG SYSTEMATIC APPROACH
───────────────────────────────────────

1. Evaluate oxygenation (PaO2, PaO2/FiO2 ratio)
2. Determine pH status (acidemia <7.35, alkalemia >7.45)
3. Identify the primary disorder (metabolic or respiratory)
4. Calculate expected compensation (see Card 1)
5. Check for mixed acid-base disorders (discordance, "overcompensation")
6. Calculate A-a gradient for hypoxemia (if indicated)

Key normal values:
• pH: 7.35–7.45
• PCO2: 35–45 mmHg
• HCO3: 22–26 mEq/L
• PaO2: 80–100 mmHg
Prompt: “Evaluate initial ABG. Is there acidemia, alkalemia, or normal pH?”
~~~

---

#### Acidemia Evaluation Node
~~~text
ACIDEMIA DETECTED (pH <7.35)
───────────────────────────────────────

Determine primary disorder:
• Metabolic acidosis: Low HCO3 (<22). Calculate anion gap; use Winter's formula for compensation.
• Respiratory acidosis: High PCO2 (>45). Determine if acute vs. chronic (see compensation).
• Mixed (both low HCO3 and high PCO2) possible.
Prompt: “What is the primary derangement—low HCO3 or high PCO2? Calculate/compare expected compensation.”
~~~

---

#### Alkalemia Evaluation Node
~~~text
ALKALEMIA DETECTED (pH >7.45)
───────────────────────────────────────

Determine primary disorder:
• Metabolic alkalosis: High HCO3 (>26). Check for volume depletion, diuretics, vomiting.
• Respiratory alkalosis: Low PCO2 (<35). Acute hyperventilation common—check for sepsis, pain, anxiety.
Prompt: “Is bicarb increased or PCO2 decreased? Apply appropriate compensation formula.”
~~~

---

### Card 1 — Compensation Rules (Static)
~~~text
COMPENSATION FORMULAS

Metabolic Acidosis:
• Winter's Formula: Expected PCO2 = 1.5 × (HCO3) + 8 ± 2

Metabolic Alkalosis:
• PCO2 should rise ~0.7 per 1 mEq/L HCO3 above 24 (Max PCO2 ~55)

Respiratory Acidosis:
• Acute: HCO3 ↑1 per 10 ↑PCO2
• Chronic: HCO3 ↑4 per 10 ↑PCO2

Respiratory Alkalosis:
• Acute: HCO3 ↓2 per 10 ↓PCO2
• Chronic: HCO3 ↓4 per 10 ↓PCO2

A-a GRADIENT:
• Normal = Age/4 + 4
• High in V/Q mismatch, shunt, or diffusion limitation

Compensation never “overcorrects.” If actual and expected do not match, suspect mixed disorder.
~~~

---

### Card 2 — Clinical Correlations (Static)
~~~text
CLINICAL SCENARIOS

Metabolic Acidosis:
• High AG: DKA, lactic acidosis, toxins, renal failure (MUDPILES)
• Normal AG: Diarrhea, RTA, ureterosigmoidostomy

Metabolic Alkalosis:
• Vomiting/NG suction
• Diuretics, contraction alkalosis
• Hyperaldosteronism

Respiratory Acidosis:
• Acute: Sedatives/benzodiazepines, neuromuscular disease, severe asthma
• Chronic: COPD, obesity hypoventilation, OSA

Respiratory Alkalosis:
• Hyperventilation (anxiety, pain), sepsis, pregnancy, altitude, PE

Hypoxemia Differential:
• Hypoventilation, low FiO2, V/Q mismatch, shunt, diffusion impairment
~~~

---

## ALGORITHM DECISION TREE

~~~mermaid
graph TD
    A[Check pH] --> B{pH Status?}
    B -->|<7.35| C[Acidemia]
    B -->|7.35–7.45| D[Normal pH]
    B -->|>7.45| E[Alkalemia]
    C --> F{PCO2 Direction?}
    F -->|High >45| G[Respiratory Acidosis]
    F -->|Low <35| H[Metabolic Acidosis]
    E --> I{PCO2 Direction?}
    I -->|Low <35| J[Respiratory Alkalosis]
    I -->|High >45| K[Metabolic Alkalosis]
    H --> L[Calculate Anion Gap]
    L --> M{Gap >12?}
    M -->|Yes| N[MUDPILES Differential]
    M -->|No| O[GI vs Renal Losses]
    G --> P{Acute vs Chronic?}
    P -->|Acute| Q[Minimal HCO3 Compensation]
    P -->|Chronic| R[HCO3 ↑4 per 10 PCO2]
    D --> S[Check for Mixed Disorder]
~~~

---

## NODE-TO-DYNAMIC CARD MAPPING & INTERACTIVE ELEMENTS

| Node                  | Dynamic Card Prompt/Question                                 | Interface/Interactive Features                |
|-----------------------|-------------------------------------------------------------|-----------------------------------------------|
| Initial ABG           | "What is pH? Acidemia, alkalemia, or normal pH?"            | [pH entry], [ABG value auto-categorizer]      |
| Acidemia              | "Determine primary—metabolic or respiratory acidosis?"      | [PCO2/HCO3 inputs], [Anion gap button], [Winters calculator] |
| Alkalemia             | "Is it metabolic or respiratory alkalosis?"                  | [HCO3 input], [PCO2 input], [Compensation calculator]        |
| Metabolic acidosis    | "Calculate AG, secondary gaps, proper compensation?"        | [AG calculator], [Winter’s formula]           |
| Metabolic alkalosis   | "Check volume, chloride, compensation."                     | [Volume status selector], [Expected PCO2]     |
| Respiratory acid-base | "Acute vs chronic? Is the expected bicarb present?"         | [Acute/Chronic selector], [Compensation display] |
| Mixed disorders       | "Does actual match expected? If not, suspect mixed process."| [Auto expected/actual comparison]             |
| A-a gradient          | "Is A-a gradient above normal? What is the probable cause?" | [Age/FIO2/PaO2/PaCO2 input], [Auto-interpret] |

---

## INTERACTIVE ELEMENTS

### ABG Analyzer
~~~text
┌─────────────────────────────────────────┐
│         ABG INTERPRETATION TOOL         │
├─────────────────────────────────────────┤
│ Enter values:                           │
│ pH: [___]                               │
│ PCO2: [___] mmHg                        │
│ HCO3: [___] mEq/L                       │
│ PaO2: [___] mmHg                        │
│ FiO2: [___]%                            │
│                                         │
│ Analysis:                               │
│ • Primary disorder: _____________        │
│ • Compensation: _____________            │
│ • Oxygenation: _____________             │
│ • Expected vs actual (comp): ___________ │
│ • Status: [Appropriate/Mixed]            │
│ [ANALYZE]                                │
└─────────────────────────────────────────┘
~~~

### Winter's Formula Calculator
~~~text
┌─────────────────────────────────────────┐
│      METABOLIC ACIDOSIS COMPENSATION    │
├─────────────────────────────────────────┤
│ HCO3: [___] mEq/L                       │
│ Expected PCO2: 1.5 × HCO3 + 8 ± 2       │
│ Calc result: [___] mmHg                 │
│ Actual PCO2: [___] mmHg                 │
│ Compensation: [Appropriate/Resp Alk/Resp Acid] |
└─────────────────────────────────────────┘
~~~

### A-a Gradient Tool
~~~text
┌─────────────────────────────────────────┐
│     ALVEOLAR-ARTERIAL GRADIENT TOOL     │
├─────────────────────────────────────────┤
│ Age: [___] yrs                          │
│ FiO2: [___]%                            │
│ PaCO2: [___] mmHg                       │
│ PaO2: [___] mmHg                        │
│ Altitude: ○ Sea Level ○ High            │
│ PAO2: (FiO2 × 713) – (PaCO2/0.8)        │
│ A–a gradient: ___ mmHg                  │
│ Expected: Age/4 + 4                     │
│ Output:                                 │
│ [Normal/High?]                          │
│ If high: [V/Q mismatch, shunt, diffusion] |
└─────────────────────────────────────────┘
~~~

---

**Protocol reflects the most recent ATS, major critical care, and UpToDate guidance for ABG interpretation including static/dynamic cards and calculator integration. All node triggers and compensation steps are mapped to rapid point-of-care algorithms and interactive tool support. Full external links above for validation and reference.**
