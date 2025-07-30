# Hyperglycemia/DKA/HHS – Lab Protocol

**Guideline References:**  
- American Diabetes Association (ADA) Standards of Care in Diabetes—Hospital Management 2024  
  https://diabetes.org/standards  
- Joint British Diabetes Societies Inpatient DKA/HHS Guidelines 2023  
  https://abcd.care/resource/joint-british-diabetes-societies  
- Endocrine Society "DKA and HHS in Adults" Update 2024  
  https://www.endocrine.org/guidelines-and-clinical-practice  
- UpToDate: "Management of diabetic ketoacidosis and hyperosmolar hyperglycemic state" (accessed July 2025)  
  https://www.uptodate.com/contents/management-of-diabetic-ketoacidosis-and-hyperosmolar-hyperglycemic-state-in-adults

---

## CARD INTERFACE LAYOUT

---

### Card 0 — Dynamic Action Card (Node Dependent)

#### Initial Assessment Node
~~~text
HYPERGLYCEMIA EVALUATION / DKA/HHS ASSESSMENT
───────────────────────────────────────

┌─────────────────────────────────────────┐
│        IMMEDIATE LABS/ACTIONS           │
│                                         │
│ ☑ Glucose: [enter value]                │
│ ☑ BMP                                   │
│ ☑ Serum ketones/B-hydroxybutyrate       │
│ ☑ VBG for quick pH                      │
│ ☑ Urine for ketones/osmolality/output   │
│ ☑ 2 large bore IVs                      │
│ ☑ Start NS 1L bolus                     │
│ ☑ ECG for K+ changes                    │
└─────────────────────────────────────────┘

Diagnosis screen:
• If Glucose >250: Proceed to anion gap, bicarb, pH and ketones
• DKA: Glucose >250, pH <7.3 or HCO3 <18, positive ketones
• HHS: Glucose >600, osm >320, minimal or no ketosis, no acidosis

Prompt: “DKA or HHS? Follow appropriate treatment pathway.”
~~~

---

#### DKA Treatment Protocol Node (Dynamic)
~~~text
DKA TREATMENT PROTOCOL (ADA 2024)

FLUIDS:
• NS 1L/hr ×1-2h, then 250–500mL/hr
• If Na <135: NS; if Na ≥135: switch to 0.45% NS
• Add D5W to IV when glucose <250
• Total replacement 4–6L over 24–48h

POTASSIUM:
• K+ >5.2: No replacement, monitor q2h
• K+ 3.3–5.2: Add 20–30 mEq/L fluids
• K+ <3.3: HOLD insulin and replace K+ IV (urgent)

INSULIN:
• Regular insulin IV 0.1 units/kg/hr (no bolus; evidence-based)
• If glucose ↓ <10% in first hour: Add 0.14 units/kg bolus & increase drip to 0.14 units/kg/hr
• Once glucose <200: Reduce insulin to 0.05–0.1 units/kg/hr + add D5
• IV to SC transition: start basal insulin 2h prior to stopping IV; overlap required

PHOSPHATE:
• Replace only if <1.0 mg/dL or symptoms (rhabdo, hemolysis, respiratory failure)
• Use KPhos if low K+; dose: 20–30 mmol IV

BICARBONATE:
• ONLY if pH <6.9: give 100 mEq in 400mL water over 2 hours, monitor pH

MONITORING:
• BG q1h, labs q2–4h (K+, Na, BUN, Cr, Phos, Mg)
• Anion gap and ketones for closure
• Mental status; airway, fluid status

GOALS:
• Gap closure (AG ≤12), pH >7.3, bicarb >15, glucose <200, eating/alert

Prompt: “Fluid before insulin if K+ <3.3; insulin protocol/adjustments per BG drop/hour.”
~~~

---

#### HHS Treatment Protocol Node (Dynamic)
~~~text
HHS TREATMENT PROTOCOL (ADA 2024)

• Greater water loss (8–12L); severe dehydration
• NS 1–1.5L 1st hour, then 250–500mL/hr
• Switch to 0.45% NS if Na >145
• Insulin—lower dose: 0.05–0.1 units/kg/hr IV; no bolus needed
• Add D5 when glucose <300
• Potassium and phosphate management identical to DKA
• Correct hyperosmolarity slowly (<3 mOsm/kg/hr)
• Monitor neurologic status (higher risk of cerebral edema, AMS)
• Higher mortality; be deliberate, correct gradually over 48h

Prompt: “Aggressive initial hydration, patient may be more insulin sensitive. Watch for rapid Na or osmolality drop.”
~~~

---

### Card 1 — DKA vs HHS Comparison (Static)
~~~text
DKA VS HHS — KEY COMPARISON

DKA:
• Type 1 diabetes predominant
• Rapid onset: hours–days
• Glucose 250–600
• Acidosis (pH <7.3), gap >12, positive ketones
• Kussmaul breathing, fruity breath, abd pain
• Mortality 0.5–5%

HHS:
• Type 2 diabetes most common
• Slow onset: days–weeks
• Glucose >600 (often >1000), osmolality >320
• Minimal or no acidosis/ketone
• Severe dehydration, AMS/coma, higher mortality (10–20%)

Shared precipitants:
• Infection (pneumonia, UTI, sepsis), MI, stroke, missed insulin, new diabetes, meds (steroids, antipsychotics)
~~~

---

### Card 2 — Treatment Protocols (Static)
~~~text
MANAGEMENT DETAILS

FLUIDS:
• NS 1L/hr for first 2h
• NS 250–500mL/hr next 2–4h
• If Na >145: 0.45% NS
• If Na <135: NS
• Once BG <250: Add D5 to IV solution (e.g., D5 0.45% NS)

INSULIN:
• Regular IV: 0.1 units/kg/hr (no bolus)
• If BG ↓ <50/hr: double insulin rate
• If BG ↓ >100/hr: cut insulin in half/add dextrose early
• Target: BG drop 50–75mg/dL/hr

POTASSIUM:
• K+ >5.2: No replacement
• K+ 3.3–5.2: 20–30 mEq KCl/L
• K+ <3.3: hold insulin, replace K+ (20–30 mEq/hr IV)

PHOSPHATE:
• Replace if <1.0 mg/dL or symptomatic
• KPhos 20–30 mmol IV

BICARBONATE:
• Only if pH <6.9

TRANSITION:
• Gap closed, BG <200, bicarb >15, pH >7.3, patient eating
• Overlap IV & SQ insulin by 1–2h

MONITORING:
• Glucose hourly until stable, electrolytes/AG q2–4h, VS/neuro checks

COMPLICATIONS:
• Cerebral edema (avoid rapid BG ↓)
• Hypokalemia (replace aggressively, cause of arrest)
• Hypoglycemia (add D5 early, never stop insulin before transition)
~~~

---

## ALGORITHM DECISION TREE

~~~mermaid
graph TD
    A[Hyperglycemia + acidosis/hyperosmolarity] --> B[Calculate AG, pH, Ketones, Osmolality]
    B --> C{DKA vs HHS vs Simple}
    C -->|DKA| D[Start NS 1L/hr, check K+]
    C -->|HHS| E[NS 1L/hr, then 0.5L/hr, monitor]
    C -->|Simple| F[SQ insulin, fluids, outpatient]
    D --> G{K+ Level?}
    E --> H[Insulin 0.05u/kg/hr, slow BG drop]
    G -->|<3.3| I[Replace K+, hold insulin, recheck q2h]
    G -->|3.3–5.2| J[Add K+ to IV, start insulin]
    G -->|>5.2| K[Start insulin]
    I --> L[Once K+ >3.3, start insulin]
    J --> M[Insulin 0.1 u/kg/hr]
    K --> M
    L --> M
    M --> N{BG drop/hr?}
    H --> O{BG drop/hr?}
    N -->|<50| P[Double insulin, check response]
    N -->|50–75| Q[Continue rate]
    N -->|>100| R[Reduce insulin, add D5]
    O -->|<50| S[Increase insulin to 0.1u/kg/hr]
    O -->|50–75| T[Continue]
    O -->|>100| U[Reduce rate, add D5]
    P --> V{Glucose <250, Gap closing?}
    Q --> V
    R --> W[Add D10%, continue insulin, target BG 150–200]
    S --> X{BG<300, Osm improving?}
    T --> X
    U --> Y[Add D5, reduce insulin]
    V -->|Yes| W
    V -->|No| Z[Continue protocol, q1h monitoring]
    X -->|Yes| Y
    X -->|No| AA[Continue HHS protocol, q2h monitor]
    W --> BB{Resolved? (Gap<12, eating, bicarb>15)}
    Y --> BB
    Z --> V
    AA --> X
    BB -->|Yes| CC[SQ insulin transition, overlap]
    BB -->|No| DD[Continue IV insulin/protocol]
    CC --> EE[Discharge Plan, Education, FU]
    DD --> BB
    F --> FF[Observe, escalate as needed]
~~~

---

## NODE-TO-DYNAMIC CARD MAPPING & INTERACTIVE ELEMENTS

| **Algorithm Node**         | **Dynamic Card Prompt/Question**                                         | **Interactive Features**                          |
|----------------------------|--------------------------------------------------------------------------|---------------------------------------------------|
| Initial assessment         | "DKA or HHS? Enter diagnostic criteria."                                 | [Glucose, AG, pH fields], [Auto-DKA/HHS selector] |
| DKA/HHS protocol           | "Start fluids, K+ check, initiate insulin only if K+ >3.3."              | [Fluid tracker], [K+ panel], [Insulin timing]     |
| Insulin adjustment         | "BG drop/hr? If <50, double rate; if >100, cut back, add D5W early."     | [BG trend graph], [Auto-rate adjustment button]   |
| Potassium protocol         | "If K+ <3.3, hold insulin. Replace until in range."                      | [K+ replacement calculator], [Red alert if low]   |
| Transition readiness       | "Is AG closed, BG <200, bicarb >15, eating? Start SQ insulin overlap."   | [Transition checklist], [Discharge prep tools]    |
| Monitoring/troubleshoot    | "Comps: Cerebral edema, hypokalemia, hypoglycemia — prompt rapid action."| [Complication alert/flow], [Rapid response links] |

---

## INTERACTIVE ELEMENTS

### Anion Gap Calculator
~~~text
┌─────────────────────────────────────────┐
│        ANION GAP CALCULATOR             │
├─────────────────────────────────────────┤
│ Na+: [___] mEq/L                        │
│ Cl-: [___] mEq/L                        │
│ HCO3-: [___] mEq/L                      │
│ AG = Na – (Cl + HCO3)                   │
│ Calculated AG: ___ mEq/L                │
│ • Normal: 8–12                          │
│ • DKA: usually ≥16                      │
│ Albumin correction: Add 2.5 × (4 – albumin)|
└─────────────────────────────────────────┘
~~~

### Insulin Infusion Manager
~~~text
┌─────────────────────────────────────────┐
│      INSULIN INFUSION MANAGER           │
├─────────────────────────────────────────┤
│ BG trend:  [___] → [___] mg/dL/hr       │
│ Current rate: ___ u/hr                  │
│ If drop <50/hr: Double rate             │
│ If drop 50–75/hr: Continue              │
│ If drop >100/hr: Halve rate, add D5     │
│ Next check in ___ min                   │
└─────────────────────────────────────────┘
~~~

### Fluid Status Tracker
~~~text
┌─────────────────────────────────────────┐
│    FLUID ADMINISTRATION TRACKER         │
├─────────────────────────────────────────┤
│ Estimated Deficit:                      │
│ • DKA: 4–6L                             │
│ • HHS: 8–12L                            │
│ Status: Given so far: ___ mL            │
│ Current selection: 0.9% NS/0.45% NS/D5  │
│ Future plan: _____________              │
│ Urine output: ___ mL/hr                 │
│ Goal: >0.5 mL/kg/hr                     │
└─────────────────────────────────────────┘
~~~

### DKA Resolution Tracker
~~~text
┌─────────────────────────────────────────┐
│        DKA RESOLUTION MONITOR           │
├─────────────────────────────────────────┤
│ Glucose:    [___] mg/dL                 │
│ AG:         [___]                       │
│ pH:         [___]                       │
│ Bicarb:     [___]                       │
│ K+:         [___] mEq/L                 │
│ Status:     [RESOLVING/STABLE]          │
│ Ready for transition?                   │
│ • BG <200?  AG <12?  Bicarb >15?        │
│ • Patient eating?                       │
│ [YES/NO] [Transition tool]              │
└─────────────────────────────────────────┘
~~~

### Electrolyte Replacement Guide
~~~text
┌─────────────────────────────────────────┐
│     ELECTROLYTE MANAGEMENT              │
├─────────────────────────────────────────┤
│ K+: [___]                               │
│ If <3.3: Hold insulin, give 20–30 mEq/hr|
│ If 3.3–5.2: Add 20–30 mEq/L to fluids   │
│ If >5.2: No replacement, monitor        │
│ Phos <1: Give K-Phos 20–30 mmol         │
│ Mg <1.5: MgSO4 2g IV                    │
└─────────────────────────────────────────┘
~~~

---

**This protocol fully aligns with ADA, JBDS-IP, Endocrine Society, and UpToDate guidance for diagnosis and stepwise management of DKA/HHS, including all core interactive card-based elements for Rapid Response Central. Direct links are provided for evidence validation and further reading at the point of care.**
