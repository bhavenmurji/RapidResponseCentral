# Hypercalcemia – Lab Protocol

**Guideline References:**  
- American Association of Clinical Endocrinology (AACE) Hypercalcemia Guideline 2023  
  https://www.aace.com/disease-and-condition-resources/endocrine-disease/hypercalcemia  
- Endocrine Society Clinical Practice Guideline: Evaluation and Treatment of Hypercalcemia (2022)  
  https://www.endocrine.org/guidelines-and-clinical-practice  
- UpToDate: “Treatment of hypercalcemia in adults” (accessed July 2025)  
  https://www.uptodate.com/contents/treatment-of-hypercalcemia-in-adults

---

## CARD INTERFACE LAYOUT

---

### Card 0 — Dynamic Action Card (Node Dependent)

#### Initial Assessment Node
~~~text
HYPERCALCEMIA EVALUATION
───────────────────────────────────────

• Mild: 10.5–11.9 mg/dL
• Moderate: 12–13.9 mg/dL
• Severe: ≥14 mg/dL

Symptom assessment:
• "Stones, bones, groans, moans" (renal/GI/neuro/psych bones)
• Mental status (delirium, somnolence)
• Volume status (dehydration common)
• ECG for short QT, T wave changes

Prompt: "What is the degree of hypercalcemia and any significant symptoms?"
~~~

---

#### Acute Management Node
~~~text
IMMEDIATE INTERVENTIONS
───────────────────────────────────────

First-line:
• Isotonic NS 200–300 mL/hr (goal 3–6L in first 24h)
• Monitor for fluid overload, especially elderly/CKD/CHF

Once volume replete:
• IV furosemide 20–40 mg PRN to maintain urine output ≥200 mL/hr (avoid until after rehydration)
• Careful with loop; avoid thiazides (increase Ca)

Monitor:
• Output, volume, and electrolytes (esp. K+ and Mg++)
Prompt: "Has euvolemia been achieved and urine output >200 mL/hr?"
~~~

---

#### Bisphosphonate Node
~~~text
CALCIUM-LOWERING THERAPY
───────────────────────────────────────

Indications:
• Severe hypercalcemia (≥14) or moderate with symptoms
• Malignancy as etiology suspected/proven

Zoledronic acid 4 mg IV:
• Infuse over 15–30 minutes
• Peak effect 2–4 days, lasts 2–4 weeks
• CrCl must be >35 mL/min

Pamidronate alternative:
• 60–90 mg IV over 2–4 hrs
• Preferred if CKD/dialysis
• Slower effect but safer in renal impairment

Start as early as possible because maximal effect is not immediate.

Prompt: "Choose bisphosphonate based on renal function. Repeat dose only after 7 days if no response."
~~~

---

### Card 1 — Causes & Workup (Static)
~~~text
HYPERCALCEMIA CAUSES

Common (>90%):
Primary hyperparathyroidism:
• Outpatient #1; mild, few symptoms
• PTH high/inappropriately normal

Malignancy:
• Inpatient #1; severe (>13–14 mg/dL)
• PTHrP (humoral); local osteolytic activity
• Rapid onset, often symptomatic

Other causes:
• Medications: Thiazides, lithium, vitamin D/A, calcium supplements
• Granulomatous: Sarcoidosis, TB, histoplasma
• Endocrine: Thyrotoxicosis, adrenal insufficiency, pheochromocytoma
• Immobilization (esp. high bone turnover, Paget’s)

WORKUP:
• PTH (primary diagnostic test)
• PTHrP, 25(OH)D/1,25(OH)2D, TSH, cortisol if PTH low
• SPEP/UPEP (myeloma rule-out)
• Repeat Ca to confirm
~~~

---

### Card 2 — Treatment Options (Static)
~~~text
TREATMENT PROTOCOLS

Hydration:
• Isotonic NS 200–300 mL/h up to 3–6L/24h
• Maintain UOP ≥100–150 mL/h
• Monitor for signs of overload (lung/leg exam, weights)

Loop diuretics:
• IV furosemide 20–40 mg only after euvolemia achieved
• Strict avoid of thiazides (increase reabsorption)

Bisphosphonates:
• Zoledronic acid 4mg IV (preferred, CrCl >35)
• Pamidronate 60–90mg IV over 2–4h (CKD or zoledronic contraindicated)
• Check Ca daily; max effect at 48–72h

Calcitonin:
• 4–8 IU/kg SC/IM q12h; onset 1–2h, tachyphylaxis 48h
• Good bridging option with bisphosphonate delay

Glucocorticoids:
• Prednisone 40–60mg PO daily (granulomatous/myeloma/vit D intox)
• Taper rapidly as Ca normalizes

Dialysis:
• If severe/hypervolemic or renal failure
• Low–calcium dialysate

Other:
• Cinacalcet for refractory primary/secondary hyperparathyroidism (not for acute lowering)

Monitoring:
• Ca q6–8h during treatment, then daily
• Monitor K+, Mg, Phos, creat, urine output
• ECG for QT interval, arrhythmia
~~~

---

## ALGORITHM DECISION TREE

~~~mermaid
graph TD
    A[Ca >10.5] --> B{Symptoms or Ca >14?}
    B -->|Yes| C[Aggressive Hydration]
    B -->|No| D{Ca Level?}
    C --> E[NS 200–300mL/hr, Strict Monitor]
    D -->|10.5–12| F[PO Hydration, Outpatient Workup]
    D -->|12–14| G[IV Hydration/Monitor, Workup]
    E --> H{Volume Replete?}
    H -->|Yes| I[Furosemide 20–40mg IV]
    H -->|No| J[Continue NS, Monitor]
    I --> K{Ca Still Elevated?}
    K -->|Yes| L[Bisphosphonates or Calcitonin]
    K -->|No| M[Maintenance/Monitor Labs]
    F --> N[Check PTH, Outpatient Referral]
    G --> O{PTH Level?}
    O -->|High| P[Prob Primary HPT, Consider Surgery]
    O -->|Low| Q[Check PTHrP, SPEP/UPEP, Malignancy]
    L --> R{Improvement at 48h?}
    R -->|Yes| S[Continue Current Regimen]
    R -->|No| T[Dialysis or Glucocorticoids]
~~~

---

## NODE-TO-DYNAMIC CARD MAPPING & INTERACTIVE ELEMENTS

| Node                  | Dynamic Card Prompt                                    | Interactive/Decision Support                      |
|-----------------------|-------------------------------------------------------|---------------------------------------------------|
| Initial Ca elevated   | "Is hypercalcemia mild, moderate, or severe? Any symptoms?" | [Ca entry], [Symptom list], [Severity categorizer]|
| Acute management      | "Begin NS at 200–300 mL/h. Achieved euvolemia yet?"   | [Hydration tracker], [UOP log], [Fluid balance]   |
| Loop diuresis added   | "Begin/continue furosemide if replete. Ca falling?"   | [Dose tracker], [Ca log], [Volume/lyte log]       |
| Bisphosphonate node   | "Which agent? Check/enter renal function."            | [Drug selector], [Renal function calculator]      |
| Malignancy/PTH workup | "Causes: PTH checked? Malignancy/other?",             | [Lab checklist], [Historical comparison]          |
| Calcitonin used       | "Bridge with calcitonin if Ca >14 or if severe symptoms."| [Dosing guide], [Tachyphylaxis warning]        |
| Monitoring node       | "Track Ca, K, Mg, Phos q6–8h; ECG for arrhythmia."    | [Trend graph], [QTc checker], [Next lab reminder] |
| Dialysis considered   | "Refractory or renal fail? Initiate specialty consult."| [Dialysis consult link], [Severe alert]           |

---

## INTERACTIVE ELEMENTS

### Hydration Calculator
~~~text
┌─────────────────────────────────────────┐
│      CALCIUM REDUCTION ESTIMATOR        │
├─────────────────────────────────────────┤
│ Starting Ca: [___] mg/dL                │
│ Weight: [___] kg                        │
│                                         │
│ Expected drop:                          │
│ • NS hydration alone: ↓1–2 mg/dL/24h    │
│ • NS + furosemide: ↓2–3 mg/dL           │
│ • Bisphosphonate: ↓2–4 mg/dL (48–72h)   │
│ Target Ca: <10.5 mg/dL                   │
└─────────────────────────────────────────┘
~~~

### Bisphosphonate Selector
~~~text
┌─────────────────────────────────────────┐
│    BISPHOSPHONATE SELECTION GUIDE       │
├─────────────────────────────────────────┤
│ Renal function (CrCl): [___] mL/min     │
│                                         │
│ If CrCl >35:                            │
│ → Zoledronic acid 4mg IV                │
│ If CrCl 30–35: Pamidronate preferred    │
│ If CrCl <30: Avoid zoledronic, cautious with pamidronate |
│ Dialysis: Consider hemodialysis w/ low-Ca dialysate      |
└─────────────────────────────────────────┘
~~~

### Symptom Tracker
~~~text
┌─────────────────────────────────────────┐
│    HYPERCALCEMIA SYMPTOM MONITOR        │
├─────────────────────────────────────────┤
│ Initial symptoms:                       │
│ ☑ Confusion/AMS                         │
│ ☑ Polyuria/polydipsia                   │
│ ☑ Constipation                          │
│ ☑ Nausea/vomiting                       │
│ ☐ Kidney stones                         │
│ ☐ Bone pain                             │
│                                         │
│ After 24h:                              │
│ Mental status: [Improved/No change]     │
│ Volume: [Euvolemic/Overloaded/Depleted] │
│ Current Ca: [___] mg/dL                 │
└─────────────────────────────────────────┘
~~~

---

**This evidence-based protocol reflects AACE, Endocrine Society, and recent UpToDate guidance for diagnosing and treating hypercalcemia. All decision points map to user-directed dynamic cards and interface-calculator elements, with validation available via links above.**
