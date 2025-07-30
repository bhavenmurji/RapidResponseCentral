# Thrombocytopenia & Platelet Transfusion – Lab Protocol

**Guideline References:**  
- American Society of Hematology (ASH) 2024 Guidelines on Platelet Transfusion and Thrombocytopenia  
  https://www.hematology.org/education/clinicians/guidelines  
- AABB Platelet Transfusion Guidelines 2023  
  https://www.aabb.org/clinical-resources/practice-guidelines  
- British Society for Haematology – Investigation and Management of Thrombocytopenia (2022)  
  https://b-s-h.org.uk/guidelines

---

## CARD INTERFACE LAYOUT

---

### Card 0 — Dynamic Action Card (Node Dependent)

#### Thrombocytopenia Detected Node
~~~text
PLATELET ASSESSMENT APPROACH
───────────────────────────────────────

Severity classification:
• Mild: 100–150K
• Moderate: 50–100K
• Severe: 20–50K
• Critical: <20K

Initial evaluation:
• Review current medications (especially new or high-risk)
• Check peripheral blood smear for morphology/clumping
• Assess for bleeding (mucosa, urine, stool, skin, CNS)
• Review prior platelet counts for chronicity/trend
• Confirm value (no clumps, check in citrate tube if spurious result)

Prompt: "Is platelet drop acute or chronic? Any active bleeding or procedural risk?"
~~~

#### Transfusion Decision Node
~~~text
PLATELET TRANSFUSION CRITERIA
───────────────────────────────────────

Prophylactic thresholds (AABB 2023, ASH 2024):
• <10K: Transfuse if not actively bleeding (primary prevention)
• <20K with fever/sepsis/clinically unstable: Transfuse
• <50K pre-major invasive procedures (surgery, lumbar puncture, etc.)
• <100K pre-neurosurgery/ocular surgery
• Active bleeding at any level with TCP: Transfuse
• Platelet dysfunction or anti-platelet drugs: Consider higher threshold

Expected increment:
• 1 apheresis unit ≈ 30–60K increase
• 1 random donor unit ≈ 5–10K increase

Next step: "What is the indication for transfusion—prophylaxis, procedure, or active bleeding?"
~~~

#### Drug-Induced Investigation Node
~~~text
MEDICATION REVIEW PRIORITY
───────────────────────────────────────

Common culprits:
• Heparin (check 4Ts/HIT panel)
• Beta-lactam or glycopeptide antibiotics (vanc, pip-tazo, linezolid)
• H2 blockers (rare but documented)
• Valproic acid, thiazide diuretics, quinine, chemotherapy agents

Timing:
• New medication: usually 5–10 days after start
• Prior sensitization: as soon as hours after exposure
• STOP all suspected agents if feasible

Prompt: "Any recently started medications, especially heparin or antibiotics?"
~~~

---

### Card 1 — Differential Diagnosis (Static)
~~~text
THROMBOCYTOPENIA CAUSES

DECREASED PRODUCTION:
• Bone marrow failure/suppression (MDS/leukemia)
• Chemo/radiation, alcohol, HIV/HCV/EBV/CMV
• Severe B12/folate deficiency
• Medications (chemo, antibiotics, anticonvulsants)

INCREASED DESTRUCTION:
Immune-mediated:
• ITP
• Heparin-induced (HIT)
• Drug-induced immune destruction
• Post-transfusion purpura

Non-immune:
• DIC, TTP/HUS, HELLP, sepsis, mechanical valves
• Massive transfusion/dilution

SEQUESTRATION:
• Splenomegaly, portal hypertension, cirrhosis

DILUTIONAL:
• Massive fluid or PRBC/FFP transfusion without platelet replacement

PSEUDOTHROMBOCYTOPENIA:
• EDTA- or laboratory artifact
• Repeat in citrate anticoagulant tube

WORKUP STEPS:
• CBC + smear + clotting studies + LFTs
• Check for splenomegaly, infection, pregnancy, recent drugs/transfusions
• Additional: 4Ts score if HIT, hemolysis panel if DIC/TTP
~~~

---

### Card 2 — Management Protocols (Static)
~~~text
PLATELET SUPPORT & SPECIAL SITUATIONS

TRANSFUSION PRODUCTS:
Random donor:
• 4–6 whole blood–derived units = 1 adult dose (~250 mL, ↑5–10K/unit)
Apheresis:
• Single large-volume donation = adult dose (~300 mL, ↑30–60K)
HLA-matched:
• Use for refractory patients or those with alloimmunization

KEY SPECIAL SITUATIONS:
HIT (heparin-induced):
• *DO NOT* transfuse platelets unless life-threatening CNS bleeding
• Switch to non-heparin anticoagulant

ITP (immune):
• High-dose steroids 1 mg/kg
• IVIG if urgent/refractory
• Platelet transfusion often ineffective but may temporize if severe bleed

TTP:
• *NO* platelets (risk of thrombosis)
• Emergency plasma exchange

DIC:
• Correct underlying cause
• Platelets if <50K and bleeding/procedure

OTHER TREATMENTS:
• IVIG (ITP, some drug causes)
• TPO agonists (chronic ITP)
• Anti-D (ITP, Rh+ only)
• Splenectomy for refractory
• Tranexamic acid (selected mucosal bleeds)

MONITOR:
• Daily CBC, count 1h post-transfusion to confirm increment
• Watch for fever, transfusion reaction, volume overload
~~~

---

## ALGORITHM DECISION TREE

~~~mermaid
graph TD
    A[Platelets <150K] --> B[Confirm True TCP<br/>Check for Clumps/Citrate]
    B --> C{Bleeding or<br/>Procedural Need?}
    C -->|Yes| D[Urgent Transfusion<br/>Based on Threshold]
    C -->|No| E{Platelet<br/>Count?}
    E -->|<10K| F[Transfuse Prophylactically]
    E -->|10–50K| G[Assess for Risk Factors]
    E -->|>50K| H[Monitor / Find Cause]
    G --> I{Fever/Sepsis/Bleeding Risk?}
    I -->|Yes| J[Transfuse if <20K]
    I -->|No| K[No transfusion, Daily CBC]
    D --> L[Transfuse per Procedure/Bleed]<br/>[Central line >20K, Surgery >50K, Neuro >100K]
    F --> M[Give adult dose → Recheck 1h]
    H --> N{Underlying Cause Identified?}
    N -->|HIT| O[Stop Heparin, NO Platelets]
    N -->|ITP| P[Steroids+/-IVIG, Platelets if critical]
    N -->|Drug| Q[Stop Drug, Supportive Care]
    N -->|TTP| R[Plasma Exchange Only]
~~~

---

## NODE-TO-DYNAMIC CARD MAPPING & INTERACTIVES

| **Algorithm Node**       | **Dynamic Card/Prompt**                                   | **Interactive/Decision Features**                    |
|--------------------------|----------------------------------------------------------|------------------------------------------------------|
| Platelet <150K detected  | "How low is the platelet count? Any active bleeding?"    | [Count input], [Acute/chronic selector]              |
| Confirm TCP              | "Lab artifact suspected? Repeat in citrate/check smear." | [Pseudothrombo checker], [Recheck prompt]            |
| Bleeding/Procedure?      | "Immediate transfusion needed for bleed or procedure?"   | [Indication input], [Procedure dropdown]             |
| <10K/<20K/<50K           | "Transfuse for primary prevention/refractory fever?"     | [Transfusion calculator], [Product type chooser]      |
| Risk factors present     | "Sepsis/fever/active bleed → Transfuse at higher threshold" | [Risk checklist], [Incremental transfusion]          |
| Special cause found      | "Suspect HIT/ITP/DIC/TTP? How to proceed?"               | [HIT 4Ts score], [Auto guideline pop-up], [NO transfusion locks]|
| Drug-induced             | "Any suspect new meds? Stop and monitor."                | [Drug selector], [Time since start]                  |
| Post-transfusion         | "Was increment appropriate? Consider HLA-matched if low."| [Response input], [Alloimmunization checker]         |

---

## INTERACTIVE ELEMENTS

### Transfusion Calculator
~~~text
┌─────────────────────────────────────────┐
│    PLATELET TRANSFUSION PLANNING        │
├─────────────────────────────────────────┤
│ Current platelets: [___] K              │
│ Target: [___] K                         │
│ Product: [ Apheresis | Random donor ]   │
│ Splenomegaly/fever: [Y/N]               │
│ Expected rise: 30–60K (apheresis), 5–10K per random unit │
│                                   │
│ Total needed: [auto-calc] units   │
└─────────────────────────────────────────┘
~~~

### HIT Probability (4Ts) Score
~~~text
┌─────────────────────────────────────────┐
│         4Ts SCORE FOR HIT               │
├─────────────────────────────────────────┤
│ Thrombocytopenia:                       │
│ ○ >50% fall or nadir 20–100K (2)        │
│ ○ 30–50% fall or nadir 10–19K (1)       │
│ ○ <30% fall or nadir <10K (0)           │
│ Timing (days since heparin):            │
│ ○ Typical (5–10 days or ≤1 day recent) (2)│
│ ○ >Day 10 or unclear (1)                │
│ ○ <Day 4/no recent (0)                  │
│ Thrombosis:                             │
│ ○ New or progressive thrombosis (2)     │
│ ○ Recurrent/thrombophlebitis (1)        │
│ ○ None (0)                              │
│ Other causes present:                   │
│ ○ None evident (2)                      │
│ ○ Possible (1)                          │
│ ○ Definite (0)                          │
│ Total: [___]  (Risk: 0–3 low, 4–5 int., 6–8 high) │
└─────────────────────────────────────────┘
~~~

### Procedure Platelet Thresholds
~~~text
┌─────────────────────────────────────────┐
│    PLATELET GOALS BY PROCEDURE          │
├─────────────────────────────────────────┤
│ • Central line, paracentesis, arthro: >20K   │
│ • Major surgery: >50K                        │
│ • Epidural/neurosurgery/ocular: >100K        │
│ • Special: Uremia—consider DDAVP             │
│                                               │
│ If antiplatelet/aspirin: may need higher     │
│ If liver disease (dysfunction): consult      │
└─────────────────────────────────────────┘
~~~

---

**All content reflects latest ASH/AABB/BSH evidence-based guidelines and can be validated via the URLs listed above. Each step aligns with actionable dynamic cards and interactive elements for use in Rapid Response Central.**
