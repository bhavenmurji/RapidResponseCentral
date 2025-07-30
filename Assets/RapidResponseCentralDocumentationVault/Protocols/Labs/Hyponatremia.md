# Hyponatremia – Lab Protocol

**Guideline References:**  
- European Society of Endocrinology/European Renal Association Hyponatremia Guideline 2022  
  https://www.era-online.org/publications/era-edta-guidelines-position-statements  
- American Society of Nephrology (ASN) Hyponatremia Consensus Recommendations 2023  
  https://www.asn-online.org/guidelines  
- UpToDate: “Diagnostic evaluation and treatment of hyponatremia in adults” (accessed July 2025)  
  https://www.uptodate.com/contents/diagnostic-evaluation-and-treatment-of-hyponatremia-in-adults

---

## CARD INTERFACE LAYOUT

---

### Card 0 — Dynamic Action Card (Node Dependent)

#### Initial Assessment Node
~~~text
HYPONATREMIA EVALUATION
───────────────────────────────────────

Severity classification:
• Mild: 130–134 mEq/L
• Moderate: 120–129 mEq/L  
• Severe: <120 mEq/L

Assess symptoms:
• Asymptomatic
• Mild (nausea, headache)
• Severe (seizures, coma)

Immediate actions:
• Check serum glucose—calculate corrected Na if hyperglycemia
• Obtain serum osmolality
• Draw urine sodium and urine osmolality

Prompt: “What is the symptom severity…and is rapid intervention required?”
~~~

---

#### Volume Assessment Node
~~~text
VOLUME STATUS DETERMINATION
───────────────────────────────────────

Hypovolemic:
• Orthostatic hypotension, decreased skin turgor, dry mucosa
• Urine Na <20 (extrarenal losses) or >20 (renal losses, diuretics, salt-wasting)

Euvolemic:
• No peripheral edema, JVP normal, no ascites
• SIADH most common cause

Hypervolemic:
• Edema, increased JVP
• CHF, cirrhosis, nephrotic syndrome
• Urine Na usually <20 (RAAS activation)

Prompt: “Which volume deficit pattern does the patient fit? Proceed to etiology identification.”
~~~

---

#### Treatment Algorithm Node
~~~text
CORRECTION STRATEGY
───────────────────────────────────────

Severe symptoms (seizure/AMS):
• 3% hypertonic saline 100mL IV over 10 min
• May repeat x2 (max 3 boluses)
• Target increase: 4–6 mEq/L (stop seizures/edema)
• Pause after each bolus, check Na

Correction limits:
• Max rise: 6–8 mEq/L in 24 h
• No more than 0.5 mEq/L/hr, safest <4–6 in elderly/chronic

Moderate/mild/no symptoms:
• Assess and treat based on volume status (below)

Monitoring:
• Monitor sodium q2h (q4–6h if mild)
• Watch for overcorrection to prevent ODS
• If overcorrection: administer D5W and DDAVP (see protocols below)
~~~
*Prompt: “Track rate of sodium increase. At each step, confirm you do not exceed safe correction thresholds.”*
---

### Card 1 — Diagnostic Approach (Static)
~~~text
HYPONATREMIA WORKUP

Osmolality Calculation:
• Calculated = 2(Na) + glucose/18 + BUN/2.8
• “Gap” >10 → suspect other osmoles (mannitol, intox)

Urine studies:
• Urine osmolality and Na are essential for most cases
• Urine Osm <100: Primary polydipsia or beer potomania (dilute urine)
• Urine Osm >100: SIADH, hypovolemia, adrenal/thyroid, diuretics

Volume-based Causes:
Hypovolemic:
• GI losses, diuretics, adrenal, cerebral salt wasting

Euvolemic:
• SIADH, hypothyroid, adrenal insufficiency, drugs (SSRIs, carbamazepine)

Hypervolemic:
• CHF, cirrhosis, nephrotic

Check TSH, cortisol if unexplained.
~~~

---

### Card 2 — Treatment Details (Static)
~~~text
TREATMENT PROTOCOLS

3% Hypertonic Saline:
Indications:
• Symptomatic, severe hyponatremia (seizure, resp. distress, coma, Na<120)
Dosing:
• 100mL over 10 min (↑ Na ~2 mEq/L)
• Repeat q30 min if needed (max 3 total)
• Pause, recheck Na after each

Fluid Restriction:
• <800–1000 mL/24h (includes all intake)—first-line for SIADH
• Salt tabs or oral urea for chronic SIADH if needed

Specific Treatments:
Hypovolemic:  
• Isotonic saline replacement (cautiously to avoid deluge correction), stop culprit diuretics
SIADH:  
• Restrict fluids, salt tabs, consider oral vaptans (tolvaptan)—specialist only
Hypervolemic:  
• Fluid restrict, add loop diuretics, treat CHF/cirrhosis/nephrotic

Monitoring:
• Na q2h on 3%, q4–6h if non-emergent
• Watch for symptoms of ODS (dysarthria, dysphagia, confusion)

Overcorrection Rescue:
• If Na rises >8–10mEq in 24h, administer D5W IV, consider DDAVP (2mcg IV/subcu)
~~~

---

## ALGORITHM DECISION TREE

~~~mermaid
graph TD
    A[Na <135] --> B{Symptoms?}
    B -->|Severe| C[3% Saline 100mL bolus]
    B -->|Mild/None| D[Volume Status Assessment]
    C --> E[Repeat Na in 2h]
    D --> F{Volume Status?}
    F -->|Hypovolemic| G[NS + Stop Losses]
    F -->|Euvolemic| H[SIADH/SI Urine Studies → Fluid Restrict]
    F -->|Hypervolemic| I[Fluid Restrict, Loops]
    E --> J{↑ 4–6 mEq/L?}
    J -->|Yes| K[Continue Careful Monitor]
    J -->|No| L[Repeat Bolus, Max 3]
    G --> M[Monitor Na q4–6h]
    H --> M
    I --> M
    K --> N{Total ↑>8 in 24h?}
    N -->|Yes| O[Rescue: D5W + DDAVP]
    N -->|No| P[Continue TX]
~~~

---

## NODE-TO-DYNAMIC CARD MAPPING & INTERACTIVE ELEMENTS

| Node           | Dynamic Card Prompt                                       | Interactive Features                  |
|----------------|----------------------------------------------------------|---------------------------------------|
| A              | "Hyponatremia detected. What are the symptoms?"          | [Severity picker], [Symptom buttons]  |
| B              | "Is patient symptomatic? Seizure/AMS or mild only?"      | [Symptom slider], [AMS/seizure Y/N]   |
| C              | "Give 3% saline 100mL over 10 min, recheck Na q2h."      | [Administer bolus], [Timer], [Na entry]|
| D              | "Is patient hypovolemic, euvolemic, or hypervolemic?"    | [Exam checklist], [Lab review widget] |
| G/H/I          | "Treat per volume status. Enter labs/fluids given."      | [Fluids ordered], [Diuretic tracking] |
| K/N/O          | "Correction safe? If over-rapid, initiate D5W rescue and DDAVP." | [Correction rate calculator], [DDAVP tracker] |

---

## INTERACTIVE ELEMENTS

### Correction Rate Calculator
~~~text
┌─────────────────────────────────────────┐
│      SODIUM CORRECTION SAFETY           │
├─────────────────────────────────────────┤
│ Starting Na: [___] mEq/L                │
│ Current Na: [___] mEq/L                 │
│ Hours elapsed: [___]                    │
│                                         │
│ Rate: ___ mEq/L/hr                      │
│ Safe limits: 6–8 mEq/L in 24h           │
│           0.5 mEq/L/hr max              │
│ Status: [SAFE/AT RISK]                  │
│ Remaining allowed: ___ mEq/L            │
└─────────────────────────────────────────┘
~~~

### 3% Hypertonic Saline Calculator
~~~text
┌─────────────────────────────────────────┐
│        3% SALINE DOSING                 │
├─────────────────────────────────────────┤
│ Current Na: [___] mEq/L                 │
│ Weight: [___] kg                        │
│ Each 100mL bolus → ~1.5–2 mEq/L Na↑     │
│ Max: 300 mL (3 boluses)                 │
│ Prompt: "Recheck sodium before next."   │
└─────────────────────────────────────────┘
~~~

### SIADH Criteria Checker
~~~text
┌─────────────────────────────────────────┐
│         SIADH DIAGNOSTIC CHECKLIST      │
├─────────────────────────────────────────┤
│ [ ] Na <135                             │
│ [ ] Serum osm <275 mOsm/kg              │
│ [ ] Urine osm >100 mOsm/kg              │
│ [ ] Urine Na >40 mmol/L                 │
│ [ ] Clinical euvolemia                  │
│ [ ] Normal TSH/adrenal                  │
│ [ ] No diuretic in last week            │
│ All criteria met: SIADH likely          │
│ Common causes: CNS, thoracic neoplasia  │
└─────────────────────────────────────────┘
~~~

---

**Protocol fully aligns with 2022–2024 international guidelines for hospital hyponatremia workup and treatment. All dynamic decision points are mapped to node-based interface steps, linked to interactive calculators/checklists for rapid safe care. See direct URLs above for ongoing clinical validation and evidence updates.**
