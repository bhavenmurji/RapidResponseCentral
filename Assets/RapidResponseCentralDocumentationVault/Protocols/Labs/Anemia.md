# Anemia Workup & Transfusion – Lab Protocol

**Guideline References:**  
- American Society of Hematology (ASH) Choosing Wisely® guidelines, updated 2024  
  https://www.hematology.org/education/clinicians/guidelines  
- AABB Red Blood Cell Transfusion Guidelines 2023  
  https://www.aabb.org/clinical-resources/practice-guidelines  
- British Society for Haematology Guideline for Management of Acute and Chronic Anemia 2021  
  https://b-s-h.org.uk/guidelines

---

## CARD INTERFACE LAYOUT

---

### Card 0 — Dynamic Action Card (Node Dependent)

#### Critical Value Recognition Node
~~~text
SEVERE ANEMIA DETECTED
───────────────────────────────────────

Hemoglobin: 5.2 g/dL
Previous: 8.1 g/dL (3 days ago)

Acute drop >2 g/dL
MCV: 78 (microcytic)
Platelets: 385K
PT/INR: Normal

Immediate actions:
• Type & cross 2 units PRBC
• Orthostatic vital signs
• Assess for evidence of bleeding (GI, GU, retroperitoneal, surgical drains)
• Hold anticoagulation/antiplatelets pending evaluation
~~~
*Next step: "Is there evidence of active bleeding or high-risk comorbidity?"*
[Yes/No Buttons]

---

#### Transfusion Decision Node
~~~text
TRANSFUSION THRESHOLD ASSESSMENT
───────────────────────────────────────

Current Hgb: 6.8 g/dL
Symptoms: Dyspnea, tachycardia

Guideline criteria (AABB 2023):
• Transfuse if Hgb <7 g/dL in stable hospitalized adults
• <8 g/dL with active coronary syndromes/CAD, or pre-op
• Symptoms (chest pain, hypotension, tachycardia unresponsive to fluids) regardless of level

Recommended:
• Order 1 unit PRBC (restrictive transfusion) unless active bleeding
• Recheck Hgb 1 hr post-transfusion
• Reassess symptoms (fatigue, dyspnea, chest pain) before ordering additional units
• Target: Hgb 7–8 g/dL (Hgb >8–10: not usually indicated except for symptoms)

Note:
• Each unit PRBC → ↑ Hgb ≈ 1 g/dL
*Prompt: "Order placed. Monitor for transfusion reaction and reassess Hgb after each unit."*
~~~

---

#### Iron Studies Interpretation Node
~~~text
IRON DEFICIENCY CONFIRMED
───────────────────────────────────────

Findings:
• Iron: 28 mcg/dL (low)
• TIBC: 450 mcg/dL (high)
• Ferritin: 8 ng/mL (very low)
• Transferrin saturation: 6 %

Guideline-based next steps:
• Initiate oral or IV iron therapy (oral for non-severe, IV if intolerance, CKD, malabsorption, or severe)
• GI workup: stool guaiac, consider upper/lower endoscopy for adults >50 or with risk factors
• Screen for celiac, menstrual loss, other chronic GI sources if relevant
• Repeat CBC and retic in 1–2 weeks for response

Order set: [Iron replacement], [Outpatient GI referral], [Fecal occult blood]
~~~
*Prompt: "Iron deficiency confirmed. Is GI workup needed based on age/risk? Initiate iron therapy?"*
[Order Iron][GI Referral][Schedule recheck]

---

### Card 1 — Anemia Classification (Static)
~~~text
ANEMIA TYPES BY MCV

MICROCYTIC (<80):
• Iron deficiency (GI loss vs gynecologic)
• Thalassemia (check ethnicity/family hx)
• Anemia of chronic disease ( retic, normal/high ferritin)
• Lead poisoning (consider in children, basophilic stippling)
• Sideroblastic anemia (rare; check smear)

NORMOCYTIC (80–100):
• Acute blood loss
• Anemia of chronic disease
• CKD ("inappropriately low" retic, check EPO)
• Hemolysis ( retic, LDH,  haptoglobin)
• Bone marrow failure (pancytopenia/aplastic)
• Mixed etiology

MACROCYTIC (>100):
• B12/folate deficiency (neuro symptoms, hypersegmented neutrophils)
• Alcohol abuse
• Hypothyroidism
• Liver disease
• Medications (hydroxyurea, AZT, chemo)
• Reticulocytosis (rapid response states or post-transfusion)

WORKUP BY TYPE:
• Microcytic: Iron studies (Fe, TIBC, ferritin)
• Normocytic: Retic count, hemolysis labs, renal/liver function
• Macrocytic: B12, folate, TSH, LFTs, review medications

SEVERITY:
Mild: 10–12 (women), 10–13 (men)
Moderate: 8–10
Severe: <8
Life-threatening: <5
~~~

---

### Card 2 — Transfusion Guidelines (Static)
~~~text
TRANSFUSION THRESHOLDS (AABB 2023)

GENERAL:
• <7 g/dL: Transfuse most medical/surgical patients
• 7–8: Evaluate symptoms and comorbidities (CHF, ACS, recent MI, elderly)
• >8: Transfuse ONLY for active bleeding, symptoms, or cardiac disease

SPECIAL POPULATIONS:
Active bleeding: Transfuse for ongoing hemodynamic instability
Acute coronary syndrome: Target >8–9 g/dL (individualize)
Symptomatic: Transfuse PRN to relieve symptoms

RED CELL PRODUCT HANDLING:
• PRBCs: 1 unit raises Hgb ≈ 1 g/dL, Hct ≈ 3%
• Infuse over 2–4 hours per unit (slower for CHF/elderly)
• Use leukoreduced, crossmatched units
• Split units or wash if history of reactions

RISKS:
• TACO (volume overload)
• TRALI (acute lung injury)
• Febrile/non-feb hemolytic transfusion reactions
• Transmission of infection (HIV, HCV—rare)
• Iron overload (after repeated transfusion)

ALTERNATIVES:
• Correct iron, B12, or folate if deficient
• EPO-stimulating agents for CKD/chronic disease
• Minimize phlebotomy blood loss

MONITORING:
• Vitals baseline, q15min × 1h, then q1h
• Post-transfusion CBC within 1–2 h
• Watch for fever, hypertension, dyspnea, back pain, urticaria, chills

STOP IMMEDIATELY IF: reaction suspected; call blood bank/physician
~~~

---

## ALGORITHM DECISION TREE

~~~mermaid
graph TD
    A[Anemia Detected] --> B[Check MCV]
    
    B --> C{MCV Value?}
    
    C -->|<80| D[Microcytic<br/>Iron Studies]
    C -->|80-100| E[Normocytic<br/>Retic Count]
    C -->|>100| F[Macrocytic<br/>B12/Folate]
    
    D --> G{Iron Deficient?}
    
    G -->|Yes| H[GI Workup<br/>Iron Replace]
    G -->|No| I[Thalassemia<br/>Chronic Disease]
    
    E --> J{Retic Count?}
    
    J -->|High| K[Hemolysis<br/>Blood Loss]
    J -->|Low| L[Marrow Problem<br/>CKD]
    
    F --> M{B12/Folate Low?}
    
    M -->|Yes| N[Replace<br/>Find Cause]
    M -->|No| O[Alcohol, Thyroid<br/>Medications]
    
    A --> P{Hgb <7 or Symptomatic?}
    
    P -->|Yes| Q[Transfuse<br/>1 Unit PRBC, Reassess]
    P -->|No| R[Monitor / Treat<br/>Underlying]
~~~

---

## NODE-TO-DYNAMIC CARD MAPPING & INTERACTIVE ELEMENTS

| **Algorithm Node**  | **Dynamic Card/Prompt**                           | **Interactive Features**                     |
|---------------------|---------------------------------------------------|----------------------------------------------|
| Anemia Detected     | "How severe is anemia? Is workup started?"        | [Lab review], [Red flag alert]               |
| MCV Check           | "What is MCV? Launch micro/normo/macro pathway?"  | [MCV input], [Auto-path select]              |
| Iron Deficient      | "Is iron deficiency present? Trigger GI/iron Rx?" | [Iron study review], [Iron Rx chooser]       |
| Transfusion Trigger | "Is transfusion indicated by Hgb/Sx/guideline?"   | [Transfusion calculator], [Symptom review]   |
| Post-Transfusion    | "Hgb after 1 unit? Symptoms improved?"            | [Hgb input], [Recommend more or monitor]     |
| Marrow Failure      | "Low retic, consider marrow/CKD/bone biopsy?"     | [Retic input], [Further workup button]       |
| Macrocytosis        | "Low B12 or folate? Replace, find cause."         | [Replace/Workup buttons], [Education tips]   |
| Bleeding Identified | "Ongoing bleeding, escalate transfusion?"         | [Active bleed checklist], [Priority alert]   |

---

## INTERACTIVE ELEMENTS

### Transfusion Calculator
~~~text
┌─────────────────────────────────────────┐
│      TRANSFUSION PLANNING               │
├─────────────────────────────────────────┤
│ Current Hgb: 5.8 g/dL                   │
│ Target Hgb: 7.5 g/dL                    │
│                                         │
│ Estimated needed units: 2               │
│ (Each unit ≈ +1 g/dL)                   │
│                                         │
│ Risks:                                  │
│ ☐ Cardiac disease (slower rate)         │
│ ☐ Volume overload                       │
│ ☑ Active bleeding                       │
│                                         │
│ Order: 2 units PRBCs, each over 3–4 h   │
└─────────────────────────────────────────┘
~~~

### Iron Deficiency Calculator
~~~text
┌─────────────────────────────────────────┐
│    IRON REPLACEMENT DOSING              │
├─────────────────────────────────────────┤
│ Hgb: 8.2 g/dL                           │
│ Ferritin: 12 ng/mL                      │
│ Weight: 70 kg                           │
│                                         │
│ Deficit: (15 – 8.2) × 70 × 2.4 + 500 ≈ 1,640 mg iron needed  │
│                                         │
│ IV iron options:                        │
│   • Iron sucrose 200mg × 8 doses        │
│   • Ferric carboxymaltose 750mg × 2     │
│                                         │
│ PO option: Ferrous sulfate 325mg TID    │
└─────────────────────────────────────────┘
~~~

### Anemia Workup Tracker
~~~text
┌─────────────────────────────────────────┐
│       ANEMIA EVALUATION                 │
├─────────────────────────────────────────┤
│ Initial tests:                          │
│ ☑ CBC w/ diff                           │
│ ☑ Reticulocyte count: 0.5% (low)        │
│ ☑ Iron/Transferrin/Ferritin: Low        │
│ ☑ B12/folate: Normal                    │
│ Additional:                             │
│ ☐ Hemolysis: LDH/haptoglobin/bili       │
│ ☑ Occult blood: Positive                │
│ ☐ Endoscopy pending                     │
│ Dx: Iron deficiency anemia, likely GI   │
└─────────────────────────────────────────┘
~~~

---

**Protocol aligns with the latest ASH, AABB, and UK BSH anemia/transfusion guidelines. Each workflow node corresponds to an actionable dynamic card and prompts interactive lab-based decision support for Rapid Response Central. For validation/updates, full context and evidence are available at the official guideline URLs listed above.**
