# Hypernatremia – Lab Protocol

**Guideline References:**  
- European Renal Best Practice and ERA Guidelines on the Management of Dysnatremia in Adults (ERBP, 2023): https://www.era-online.org/publications/era-guidelines  
- American Society of Nephrology (ASN) Hyponatremia/Hypernatremia Guidelines 2023: https://www.asn-online.org/guidelines  
- UpToDate: "Etiology and treatment of hypernatremia in adults" (accessed July 2025): https://www.uptodate.com/contents/etiology-and-treatment-of-hypernatremia-in-adults

---

## CARD INTERFACE LAYOUT

---

### Card 0 — Dynamic Action Card (Node Dependent)

#### Initial Assessment Node
~~~text
HYPERNATREMIA EVALUATION
───────────────────────────────────────

Severity classification:
• Mild: 146–149 mEq/L
• Moderate: 150–159 mEq/L
• Severe: ≥160 mEq/L

Duration critical:
• Acute (<48h): Faster correction permitted
• Chronic (≥48h): Strict slow correction

Core Steps:
☑ Calculate free water deficit (see calculator)
☑ Assess volume status (hypo/eu/hypervolemic)
☑ Identify/exclude acute sodium load (hypertonic saline, etc.)
☑ Check concurrent glucose/BUN for osmolar contributions

Prompt: "Is hypernatremia acute or chronic, and what is the volume status?"
~~~

---

#### Free Water Deficit Node
~~~text
WATER DEFICIT CALCULATION
───────────────────────────────────────

Estimated Formula:
Free water deficit = TBW × [(Na/140) – 1]

Total Body Water (TBW):
• Men: 0.6 × weight (kg)
• Women: 0.5 × weight (kg)

Replace deficit over:
• Acute (<48h): up to 24 hours (up to 1 mEq/L/hr)
• Chronic (>48h): 48–72 hours (≤0.5 mEq/L/hr, max 10 mEq/L/24h)

Add estimated ongoing and insensible losses to replacement plan.
Prompt: "Enter weight, sex, sodium to auto-calculate water deficit and repletion rate."
~~~

---

#### Correction Strategy Node
~~~text
SAFE CORRECTION APPROACH
───────────────────────────────────────

Correction limits (per guidelines):
• Acute: up to 1 mEq/L/hr (max 12 mEq/L in 24h)
• Chronic: ≤0.5 mEq/L/hr, max 10 mEq/L in 24h

Fluid selection:
• Pure water loss: D5W
• Volume depleted: Start NS until stable, then switch to 0.45% NS or D5W
• Euvolemic/central/nephrogenic DI: D5W (+ desmopressin for central)
• Hypervolemic: D5W with loop diuretic; consider dialysis if renal failure

Monitor:
• Serum Na q4h (q6–8h once stable)
• Daily weights, strict I/O
• Neuro checks for osmotic demyelination/brain edema

Formula for sodium change from fluids:
ΔNa = (Infusate Na – Serum Na)/(TBW + 1)
Prompt: "Monitor sodium closely; adjust rate by trend and clinical response."
~~~

---

### Card 1 — Diagnostic Workup (Static)
~~~text
HYPERNATREMIA CAUSES

WATER LOSS:
Renal:
• Diabetes insipidus (polyuria, dilute urine)
• Osmotic diuresis (glycosuria, mannitol, urea)
• Loop diuretics

Extrarenal:
• Insensible losses (fever, hyperventilation, burns)
• GI (diarrhea, vomiting, NG output)

SODIUM GAIN:
• Hypertonic saline infusion or bicarb
• Salt poisoning (iatrogenic or accidental)
• Seawater ingestion

Assessment Plan:
• Assess volemic status: signs of dehydration, overload, or euvolemia
• Evaluate urine osmolality: DI = <300, extrarenal loss = >700
• Urine sodium >20 → renal losses; <20 → extrarenal
• Review all medications, recent infusions, parenteral nutrition, fluids
~~~

---

### Card 2 — Treatment Protocols (Static)
~~~text
HYPERNATREMIA TREATMENT BY SUBTYPE

HYPOVOLEMIC
1. Initial: NS to restore perfusion/BP
2. Once stable: Switch to 0.45% NS or D5W (hypotonic)
3. Calculate and replace free water deficit (spread over 48–72h if chronic)
4. Replace ongoing insensible and urinary losses

EUVOLEMIC
• Central DI: Desmopressin (DDAVP) 1–2 mcg IV/SQ, repeat/titrate
• Nephrogenic DI: Thiazide diuretic, low Na diet, correct underlying cause
• Replace with D5W

HYPERVOLEMIC
• Remove excess Na with loop diuretics
• Replace free water with D5W
• Dialysis if severe/renal failure

Monitoring
• Serum Na q4h while correcting, daily weights, input/output
• Avoid correcting more than 10 mEq/L in 24h for chronic cases

Other key details
• Measure and account for urine/NG/fistula/insensible losses
• Adjust plan if fever (+13% insensible loss per °C above 37°C)
• Watch for mental status changes or seizures: may indicate rapid correction/cerebral edema
~~~

---

## ALGORITHM DECISION TREE

~~~mermaid
graph TD
    A[Na >145] --> B{Volume Status?}
    B -->|Hypovolemic| C[NS Until Stable, Then Hypotonic]
    B -->|Euvolemic| D[Check Urine Osmolality]
    B -->|Hypervolemic| E[Loops + D5W or Dialysis]
    C --> F[Calculate Free Water Deficit]
    D --> G{Urine Osmolality?}
    G -->|<300| H[Central/Nephrogenic DI Pathway]
    G -->|>700| I[Extrarenal Loss; Oral/IV Water]
    F --> J[0.45% NS or D5W, Replace Over 48-72h]
    H --> K{Response to DDAVP?}
    K -->|Yes| L[Central DI: Continue DDAVP + D5W]
    K -->|No| M[Nephrogenic DI: Thiazide, Low Na, Supportive]
    J --> N[Monitor Na q4h, Daily Weight]
    N --> O{Correction Rate OK?}
    O -->|Too Fast| P[Slow Rate, Consider D5W]
    O -->|Too Slow| Q[Increase Rate, Check Ongoing Losses]
~~~

---

## NODE-TO-DYNAMIC CARD MAPPING & INTERACTIVE ELEMENTS

| **Algorithm Node**   | **Dynamic Card Prompt/Question**                                | **Interactive Elements**                          |
|----------------------|-----------------------------------------------------------------|---------------------------------------------------|
| Na >145              | "Is hypernatremia acute or chronic? Assess volemic status."     | [Duration selector], [Volume status checklist]    |
| Water Deficit Calc   | "Input sodium, sex, weight for free water deficit calculation."  | [Water deficit calculator], [Plan replacement]    |
| Correction Node      | "Choose fluid for correction. Monitor sodium every 4h."         | [Fluid selector], [Rate monitor], [Na log]        |
| DI Pathway           | "Urine osmolality low? DDAVP response? Track polyuria/nocturia."| [DI screening tool], [Desmopressin tracker]       |
| Correction Tracking  | "Monitor correction rate. Is it within safe limits?"            | [Correction rate tool], [Alert if >10mEq/24h]     |
| Ongoing Losses       | "Are there significant ongoing water losses?"                    | [Ongoing loss tracker], [Update plan]             |
| Post-correction      | "Once Na <150 and stable, transition to oral intake if possible."| [Switch to PO], [Maintenance guidance]            |

---

## INTERACTIVE ELEMENTS

### Water Deficit Calculator
~~~text
┌─────────────────────────────────────────┐
│      FREE WATER DEFICIT                 │
├─────────────────────────────────────────┤
│ Current Na: [___] mEq/L                 │
│ Patient weight: [___] kg                │
│ Sex: [○ Male  ○ Female]                 │
│ TBW: ___ L (auto-calculated)            │
│ Deficit = TBW x [(Na/140) - 1]          │
│ Total deficit: ___ liters               │
│ Plan: Replace over 48–72h; add all ongoing losses           │
└─────────────────────────────────────────┘
~~~

### Fluid Selection Guide
~~~text
┌─────────────────────────────────────────┐
│       IV FLUID SELECTOR                 │
├─────────────────────────────────────────┤
│ Current Na: [___] mEq/L                 │
│ Volume status: [___]                    │
│ Fluid options:                          │
│ • NS (initial, if unstable/hypovolemic) │
│ • D5W primary for isolated water loss   │
│ • 0.45% NS for gradual correction       │
│ Expected Na drop per L:                 │
│ • D5W = 3–4 mEq/L                      │
│ • 0.45% NS = 1–2 mEq/L                  │
│ • 0.2% NS = 2–3 mEq/L                   │
└─────────────────────────────────────────┘
~~~

### Correction Rate Monitor
~~~text
┌─────────────────────────────────────────┐
│    HYPERNATREMIA CORRECTION TRACKING    │
├─────────────────────────────────────────┤
│ Time     Na    Δ/hr     Status         │
│ 00:00   168   --        Start          │
│ 04:00   166   0.5       Safe ✓         │
│ 08:00   163   0.75      Safe ✓         │
│ 12:00   161   0.5       Safe ✓         │
│   ...                                  │
│ Correction: 7 mEq/L in 12h             │
│ Maximum: 10 mEq/L/24h                  │
│ Next check: 16:00                      │
└─────────────────────────────────────────┘
~~~

---

**This protocol reflects the 2023–2024 ERBP/ERA and ASN evidence-based guidance for hypernatremia diagnosis and therapy. All algorithmic steps are captured in node-based dynamic cards, and interactive widgets deliver best-practice correction support. Direct links above enable rapid clinical validation and reference in the point-of-care environment.**
