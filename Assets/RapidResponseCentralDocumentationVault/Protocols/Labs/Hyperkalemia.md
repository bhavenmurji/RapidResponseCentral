# Hyperkalemia – Lab Protocol

**Guideline References:**  
- American Heart Association (AHA) Guidelines for Emergency Treatment of Hyperkalemia (2024): https://www.ahajournals.org  
- Kidney Disease: Improving Global Outcomes (KDIGO) Hyperkalemia Clinical Practice Guideline 2023: https://kdigo.org/guidelines/hyperkalemia  
- UpToDate: "Treatment and prevention of hyperkalemia in adults" (accessed July 2025): https://www.uptodate.com/contents/treatment-and-prevention-of-hyperkalemia-in-adults

---

## CARD INTERFACE LAYOUT

---

### Card 0 — Dynamic Action Card (Node Dependent)

#### Initial Assessment Node
~~~text
HYPERKALEMIA EVALUATION
───────────────────────────────────────

Severity classification:
• Mild: 5.5–5.9 mEq/L
• Moderate: 6.0–6.4 mEq/L
• Severe: ≥6.5 mEq/L

Immediate actions:
☑ STAT ECG for peaked T waves, conduction issues
☑ Repeat K+ to confirm (non-hemolyzed)
☑ Hold all K+ supplements/sources immediately
☑ Review medication list for contributors (see below)
Prompt: “Is hyperkalemia confirmed and is there ECG change or symptoms?”
~~~

---

#### ECG Changes Node
~~~text
CARDIAC EMERGENCY ASSESSMENT
───────────────────────────────────────

ECG progression in hyperkalemia:
• Peaked T waves (early)
• PR prolongation
• Loss of P waves
• Broad QRS complexes
• Sine wave pattern (pre-arrest)

**IMMEDIATE emergency treatment if any ECG changes**  
Do not wait for confirmatory potassium labs.  
Prompt: “Does ECG show evidence of hyperkalemia toxicity? If yes: start calcium administration and shifting immediately.”
~~~

---

#### Membrane Stabilization Node
~~~text
CALCIUM ADMINISTRATION
───────────────────────────────────────

Calcium gluconate (preferred unless central line for chloride):
• 10% solution, 10–20mL (1–2 amps) IV over 2–5 minutes
• Onset: 1–3 minutes; duration 30–60 minutes
• Repeat in 5–10 minutes if ECG not improved
• Stabilizes cardiac myocyte membranes, does NOT lower serum K+

**Start calcium first if any conduction delay/ECG abnormality.**
Prompt: “Has calcium been given? Is QRS/ECG improved within 5–10 min?”
~~~

---

### Card 1 — Causes & Pseudohyperkalemia (Static)
~~~text
HYPERKALEMIA CAUSES

PSEUDOHYPERKALEMIA:
• Hemolysis in sample collection
• Prolonged tourniquet, fist clenching during blood draw
• Marked thrombocytosis (>500K)
• Severe leukocytosis (>100K)
• Laboratory artifact (re-check non-hemolyzed sample)

INCREASED INTAKE:
• Excess dietary/supplemental K+
• Salt substitutes, transfusions

DECREASED EXCRETION:
• Chronic or acute kidney injury (most common hospital cause)
• Medications (ACE-I/ARB, aldosterone antagonists, trimethoprim, NSAIDs, heparin, beta-blockers)

REDISTRIBUTION (shift from ICF to ECF):
• Metabolic acidosis
• Insulin deficiency
• β-blocker use
• Tumor lysis, rhabdomyolysis, severe exercise, burns
~~~

---

### Card 2 — Treatment Sequence (Static)
~~~text
TREATMENT ALGORITHM

1. MEMBRANE STABILIZATION (1–3 min)
• Calcium gluconate/chloride IV

2. INTRACELLULAR SHIFT (10–30 min)
• Insulin: 10U IV + D50 25–50g (if BG <250, give 2 amps D50)
• β2-agonist: Albuterol 10–20mg nebulized over 10–20 min (↓K+ 0.5–1.5 mmol/L)
• Sodium bicarbonate: 50–100 mEq IV (for concurrent metabolic acidosis or if other measures fail; most effective in acidosis or ESRD)

3. POTASSIUM REMOVAL (hours)
• Cation exchange resin (sodium zirconium cyclosilicate, patiromer preferred over kayexalate, but kayexalate used if others unavailable; PO or PR)
• Loop diuretics: Furosemide 20–40mg IV (if adequate renal function/volume)
• Dialysis: For anuric/oliguric renal failure or refractory hyperkalemia

MONITORING
• ECG continuous
• Serum K+ q1h until <6.0, then q4–6h
• Monitor for hypoglycemia with insulin
• Monitor Ca2+ effect and consider re-dose if ECG not corrected
~~~

---

## ALGORITHM DECISION TREE

~~~mermaid
graph TD
    A[K+ >5.5] --> B{ECG Change or K+ ≥6.5?}
    B -->|Yes| C[Give Calcium IV immediately]
    B -->|No| D{K+ Level?}
    C --> E[Give Insulin + D50, Start Albuterol]
    D -->|5.5–5.9| F[Hold K+ sources, Recheck]
    D -->|6.0–6.4| G[Shift K+, Monitor Closely]
    E --> H{Renal Function?}
    H -->|Normal| I[Try Loop Diuretic, Kayexalate]
    H -->|Failed| J[Prepare for Dialysis]
    G --> K[Insulin/D50 ± Albuterol Neb]
    F --> L{True Hyperkalemia?}
    L -->|Yes| M[Find and Correct Cause, Adjust Meds]
    L -->|No| N[Pseudo (Sample Hemolyzed)]
    I --> O[Recheck K+ q1h]
    J --> O
    K --> O
    O --> P{K+ <5.5?}
    P -->|Yes| Q[Monitor, Address Cause]
    P -->|No| R[Repeat Treatments/Escalate]
~~~

---

## NODE-TO-DYNAMIC CARD MAPPING & INTERACTIVE COMPONENTS

| **Node**                  | **Dynamic Card Prompt/Question**                           | **Interactive/Decision Support**                |
|---------------------------|-----------------------------------------------------------|-------------------------------------------------|
| A: Initial K+ detection   | "Is patient symptomatic? Are there ECG changes/very high K+?" | [K+ entry], [ECG review status], [Alert button] |
| B: ECG/Critical           | "Immediate cardiac risk? Give IV calcium ASAP."           | [Calcium admin log], [ECG monitor tool]         |
| C: Calcium administered   | "Is ECG improved? Next step: shift K+ intracellular."     | [Timer], [ECG trend tool], [Proceed button]     |
| D: Level-based escalation | "Moderate or mild hyperK+? Choose next intervention."     | [Severity selector], [Treatment picker]         |
| E: K+ shift step          | "Start insulin + D50, consider albuterol. Track BG/K+."   | [Insulin/dextrose protocol], [Albuterol order]  |
| H: Kidney status          | "Is kidney function normal? Can loop/diuretic be used?"   | [Renal status radio], [Diuretic eligibility]    |
| I/J: Excretion            | "Removal: Choose resin, diuretic, or start RRT if needed."| [Product selector], [Dialysis consult link]     |
| K: Additional shifting    | "Repeat/double interventions if not improving?"           | [Protocol updater], [Check for response]        |
| O: Monitoring             | "K+ under 5.5 yet? Is serial check ongoing?"                 | [Auto K+ plot], [Next steps button]             |
| Q: Resolution             | "Continue to monitor and address chronic cause."          | [Discharge checklist], [Medication audit]       |

---

## INTERACTIVE ELEMENTS

### Emergency Treatment Timer
~~~text
┌─────────────────────────────────────────┐
│      HYPERKALEMIA TREATMENT TIMER       │
├─────────────────────────────────────────┤
│ Time    Treatment         Status        │
│ 14:00   Ca gluconate      Given ✓       │
│ 14:03   Insulin/D50       Given ✓       │
│ 14:05   Albuterol 20mg    Started ✓     │
│ 14:30   Kayexalate        Given ✓       │
│                                         │
│ Expected K+ change:                     │
│ • Calcium: No K+ change (membrane only) │
│ • Insulin/D50: ↓0.8–1.2 within 30–60min │
│ • Albuterol: ↓0.5–1.0 in 30 min         │
│ Next K+ check: 15:00                    │
│ Glucose check: 15:00                    │
│ [SET REMINDERS]                         │
└─────────────────────────────────────────┘
~~~

### Insulin/Glucose Protocol Calculator
~~~text
┌─────────────────────────────────────────┐
│    INSULIN-GLUCOSE PROTOCOL             │
├─────────────────────────────────────────┤
│ Plan:                                   │
│ • Regular insulin 10U IV                │
│ • D50W (Dextrose 50g) 1–2 amps IV       │
│ If BG <250: 2 amps D50                  │
│ If BG 250–400: 1 amp D50                │
│ If BG >400: D50 not required            │
│ Check glucose: 1h, then q2h × 6         │
│ Increased hypoglycemia risk if CKD      │
└─────────────────────────────────────────┘
~~~

### Medication Audit Tool
~~~text
┌─────────────────────────────────────────┐
│    HYPERKALEMIA MEDICATION AUDIT        │
├─────────────────────────────────────────┤
│ Medications to Hold:                    │
│ ☑ ACE-inhibitor / ARB                   │
│ ☑ Spironolactone / Eplerenone           │
│ ☑ Trimethoprim / Amiloride              │
│ ☑ NSAIDs                                │
│ ☐ K+ supplements / Salt substitutes     │
│ Review antihypertensive / diuretic regime│
│ Alternatives: hydralazine, loop diuretic│
│ [GENERATE SAFE MED LIST]                │
└─────────────────────────────────────────┘
~~~

---

**Protocol aligned to 2023–2024 AHA/KDIGO/ASN/UpToDate guidelines. Immediate ECG and membrane stabilization come first if changes are present; shifting strategies follow; potassium removal and cause identification then sustain safe correction. All workflow steps equipped for rapid protocol implementation and safety alerts. See references above for direct clinical context and validation.**
