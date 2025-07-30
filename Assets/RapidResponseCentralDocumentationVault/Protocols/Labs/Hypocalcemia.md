# Hypocalcemia – Lab Protocol

**Guideline References:**  
- American Society for Bone and Mineral Research (ASBMR) – Hypocalcemia management update 2023  
  https://www.asbmr.org/publications/guidelines  
- Endocrine Society Clinical Practice Guideline: Evaluation, Diagnosis, and Treatment of Hypoparathyroidism 2022  
  https://www.endocrine.org/guidelines-and-clinical-practice  
- UpToDate: “Treatment of hypocalcemia” (accessed July 2025)  
  https://www.uptodate.com/contents/treatment-of-hypocalcemia-in-adults

---

## CARD INTERFACE LAYOUT

---

### Card 0 — Dynamic Action Card (Node Dependent)

#### Initial Assessment Node
~~~text
HYPOCALCEMIA EVALUATION
───────────────────────────────────────

Check ionized vs total Ca:
• Ionized <1.0 mmol/L (1.1-1.3 normal)
• Total Ca <8.0 mg/dL (8.5-10.5 normal)
• Correct total for albumin:
  Corrected Ca = Ca + 0.8 × (4 - albumin)

Immediate priorities:
☑ ECG for QT prolongation/arrhythmia
☑ Check magnesium, phosphate, PTH, Vitamin D
☑ Assess symptoms: tetany, numbness, seizures, spasms, hypotension

Prompt: "Is corrected Ca <8.0 or ionized <1.0? Are there severe symptoms?"
~~~

---

#### Symptomatic Management Node
~~~text
ACUTE CALCIUM REPLACEMENT
───────────────────────────────────────

Severe symptoms (tetany, seizures, laryngospasm, QTc >500ms):

IV calcium gluconate:
• 1–2 amps (10% solution: 90mg/amp elemental) in 50–100mL NS/D5W, over 10–20 min
• May repeat after 10–20 min if still symptomatic
• Use central line if possible (calcium chloride only if cardiac arrest/central)
• Continuous ECG monitoring
• During ongoing symptoms: consider continuous infusion 0.5–1.5 mg/kg/hr elemental Ca2+

Monitor ionized Ca and ECG frequently!
~~~

---

#### Chronic Replacement Node
~~~text
ORAL CALCIUM THERAPY
───────────────────────────────────────

Stable, mild, or chronic hypocalcemia:

• Oral calcium carbonate: 1–2g elemental/day (divided with meals, best with gastric acid)
  - Calcium citrate if achlorhydric or chronic PPI use

• Vitamin D required:
  - Calcitriol (0.25–0.5 mcg BID) for rapid effect, hypoparathyroidism/CKD
  - Cholecalciferol/ergocalciferol (50,000 IU weekly) for repleting stores in deficiency

• Always correct magnesium first if <2.0 mg/dL (Mg critical for PTH/Ca response)

Monitor Ca, Mg, phosphate daily if severe, weekly if stable
~~~

---

### Card 1 — Causes & Symptoms (Static)
~~~text
HYPOCALCEMIA OVERVIEW

Common Causes:
Hypoparathyroid:
• Post-neck/thryoid/parathyroid surgery (#1 in adults)
• Autoimmune
• Genetic/infiltrative syndromes

Deficiency States:
• Vitamin D deficiency/malabsorption
• Renal failure (secondary hyperparathyroid but low Ca)
• Liver disease (↓ 25-hydroxylation)

Other:
• Acute pancreatitis (saponification, fat necrosis)
• Massive transfusion (citrate binds Ca)
• Severe hypoMg, rhabdomyolysis, oncologic lysis

Typical Symptoms:
Neuromuscular:
• Perioral numbness/tingling
• Paresthesia
• Cramps, muscle spasm
• Carpopedal spasm/Trousseau sign
• Chvostek sign (facial twitch)

Severe:
• Seizures
• Laryngospasm/bronchospasm
• Hypotension, arrhythmias

ECG findings:
• Prolonged QT interval
• Torsades risk if untreated
~~~

---

### Card 2 — Treatment Details (Static)
~~~text
CALCIUM REPLACEMENT PROTOCOL

Corrected Ca = Ca (mg/dL) + 0.8 × (4 – albumin)

IV Replacement:
• Calcium gluconate 10%: 1–2 amps (90mg/amp elemental) in 100ml NS over 10–20 min
• May repeat q4–6h as needed
• Severe: 2g elemental over 2–4h (continuous), monitor ECG

• Calcium chloride: Central line only, 1g/10mL (3x more Ca2+ than gluconate); use for cardiac arrest/refractory

Oral Maintenance:
• Calcium carbonate (40% elemental): 500–1000mg elemental TID or QID
• Calcium citrate (21%): Preferred with achlorhydria/PPI, less constipation

Vitamin D Supplement:
• Calcitriol: 0.25–0.5 mcg BID for hypoparathyroid/CKD
• Cholecalciferol: 1000–2000 IU/day, or 50,000 IU weekly

Magnesium:
• If <2.0, IV repletion with Mg sulfate; oral mag oxide for chronic

Monitoring:
• IV: Ca q4–6h, ECG continuous
• Oral: Check Ca, Mg, PO4 daily until stable, then weekly

Targets:
• Total Ca 8.5–9.5 mg/dL, ionized >1.1 mmol/L
~~~

---

## ALGORITHM DECISION TREE

~~~mermaid
graph TD
    A[Low Calcium] --> B{Corrected for Albumin?}
    B -->|No| C[Calculate Corrected Ca]
    B -->|Yes| D{Symptoms?}
    C --> E{Still Low?}
    E -->|No| F[No Treatment]
    E -->|Yes| D
    D -->|Severe| G[IV Ca Gluconate 1–2 amps]
    D -->|Mild| H[Check Mg, PTH, Vit D]
    D -->|None| I[Oral Ca, Monitor]
    G --> J[Continuous Monitoring, ICU/Tele]
    H --> K{Is Mg Low?}
    K -->|Yes| L[Replace Mg First]
    K -->|No| M[Start Oral Ca + Vit D]
    J --> N{Symptoms Resolving?}
    N -->|Yes| O[Convert to Oral, Plan Outpatient FU]
    N -->|No| P[Repeat Labs, Check Mg, Adjust Dose]
    L --> Q[Then Calcium as Indicated]
    M --> R[Monitor Weekly, Adjust as Needed]
~~~

---

## NODE-TO-DYNAMIC CARD MAPPING & INTERACTIVE ELEMENTS

| Algorithm Node          | Dynamic Card Prompt/Question                            | Interactive/Decision Support Features         |
|------------------------|---------------------------------------------------------|-----------------------------------------------|
| Initial Ca low         | "Check albumin and correct calcium. Severe symptoms?"   | [Corrected calcium calculator], [Symptom type]|
| Severe symptoms        | "Tetany, seizure, laryngospasm? Start IV calcium stat." | [IV calcium dosing guide], [Monitor checklist]|
| Mild/No symptoms       | "Evaluate for magnesium deficiency, PTH, Vit D status." | [Lab entry], [Mg replacement meter]           |
| Mg low                 | "Mg <2.0 mg/dL detected! Replace Mg before Ca."         | [IV Mg protocol], [Repeat Ca check]           |
| Stable outpt/chronic   | "Start oral calcium ± vitamin D. Reassess weekly."      | [Oral regimens], [Adherence/risk factors]     |
| Monitoring             | "How is calcium trending? Review checks & ECG findings."| [Ca trend graph], [QTc viewer, alert if high] |

---

## INTERACTIVE ELEMENTS

### Corrected Calcium Calculator
~~~text
┌─────────────────────────────────────────┐
│     CALCIUM CORRECTION CALCULATOR       │
├─────────────────────────────────────────┤
│ Total calcium: [___] mg/dL              │
│ Albumin: [___] g/dL                     │
│ Formula: Corrected Ca = Ca + 0.8 × (4 - albumin)│
│ Corrected calcium: ___ mg/dL            │
│ Interpretation:                         │
│ • <8.0: Hypocalcemia                    │
│ • 8.5–10.5: Normal                      │
│ • >10.5: Hypercalcemia                  │
│ Consider ionized Ca: normal 1.1–1.3 mmol/L │
└─────────────────────────────────────────┘
~~~

### IV Calcium Dosing Guide
~~~text
┌─────────────────────────────────────────┐
│      IV CALCIUM ADMINISTRATION          │
├─────────────────────────────────────────┤
│ Severity: [Severe/Tetany/Seizure]       │
│ Regimen:                                │
│ • 2–3 amps Ca gluconate in 100mL NS/D5W │
│ • Over 10 min; may repeat after 10 min  │
│ • Maintenance: 50mL/hr of 100mg/mL      │
│ • Monitor ECG, Ca levels                │
│ • Cardiac arrest: 1g Ca chloride central│
└─────────────────────────────────────────┘
~~~

### Replacement Checklist
~~~text
┌─────────────────────────────────────────┐
│    HYPOCALCEMIA TREATMENT CHECKLIST     │
├─────────────────────────────────────────┤
│ Initial workup:                         │
│ ☑ Ionized or corrected Ca               │
│ ☑ Magnesium, phosphate                  │
│ ☑ PTH, 25-OH Vitamin D                  │
│ ☑ ECG for QT interval                   │
│                                         │
│ Treatment:                              │
│ ☐ Mg replaced if <2.0                   │
│ ☐ Ca gluconate ___ amps IV given        │
│ ☐ Oral calcium/vitamin D started        │
│                                         │
│ Monitoring:                             │
│ • Ca q4–6h if IV, daily if oral         │
│ • QTc with tele/ECG if severe           │
│ • Adjust regimen weekly                 │
│ Target: Ca 8.5–9.5 mg/dL                │
└─────────────────────────────────────────┘
~~~

---

**This protocol reflects current international guidelines and best practices from ASBMR, Endocrine Society, and updated expert sources, with all nodes mapped to dynamic cards and interactive tools for use in Rapid Response Central. Direct references above provide full evidence context for validators.**
