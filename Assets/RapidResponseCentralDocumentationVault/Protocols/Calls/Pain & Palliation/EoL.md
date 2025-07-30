# End-of-Life Comfort Care – Clinical Protocol

**Guideline References:**  
- National Coalition for Hospice and Palliative Care: Clinical Practice Guidelines for Quality Palliative Care (4th ed., 2018)  
  https://www.nationalcoalitionhpc.org/ncp  
- American Academy of Hospice & Palliative Medicine (AAHPM) Essential Practices 2023  
  https://aahpm.org/competencies  
- National Comprehensive Cancer Network (NCCN) Palliative Care Guidelines, Version 1.2024  
  https://www.nccn.org/guidelines/guidelines-detail?category=3&id=1452  
- World Health Organization – Palliative Care Guidance, 2020  
  https://www.who.int/news-room/fact-sheets/detail/palliative-care  

---

## CARD INTERFACE LAYOUT

---

### Card 0 — Dynamic Action Card (Node Dependent)

#### Initial Comfort Assessment Node
~~~text
COMFORT CARE INITIATION
───────────────────────────────────────

Goals of Care:
• Comfort measures only confirmed
• DNR/DNI status documented
• Family meeting completed

Priority Symptom Assessment:
• Pain
• Dyspnea
• Agitation/Delirium
• Secretions

Discontinue:
• Vital signs (unless actively dying symptoms unclear)
• Labs/imaging
• Non-comfort medications
• Cardiac monitoring

DECISION: Which symptom is currently the priority?  
→ [Pain]  [Dyspnea]  [Agitation/Delirium]  [Secretions]
~~~

#### Pain Management Node
~~~text
COMFORT CARE ANALGESIA
───────────────────────────────────────

Starting (Opioid Naive):
• Morphine 2–4 mg IV/SC q2h PRN
• If no IV: 5–10 mg PO q2h PRN

If frequent PRN (>3–4x in 8h):
• Calculate 24h total dose
• Start infusion or scheduled (24h ÷ 24 for hourly basal)

Breakthrough:
• 10–20% of 24h dose
• Available q1h PRN

Principles:
• Titrate to comfort, *no ceiling dose* per guidelines
• If ineffective, double previous dose rather than frequent minor increases
• Monitor for opioid-induced myoclonus (switch opioid or add benzodiazepine)
~~~

#### Dyspnea Management Node
~~~text
RESPIRATORY COMFORT
───────────────────────────────────────

Low-dose opioids are most effective:
• Morphine 2–4 mg IV/SC q1h PRN (not linked to RR)

Adjuncts:
• Fan to face
• Upright or semi-upright positioning
• Oxygen trial only if helpful for *subjective* comfort

Anxiety:
• Lorazepam 0.5–1 mg SL/IV/SC q4h PRN

If ongoing air hunger:
• Increase opioid dose by 50%
• Combine with non-pharmacologic support
~~~

#### Agitation/Delirium Node
~~~text
DELIRIUM / TERMINAL AGITATION
───────────────────────────────────────

Assessment:
• Rule out pain, urinary retention, constipation, hypoxia
• Environmental: lighting, noise, unfamiliar faces

Pharmacologic:
• Haloperidol 0.5–2 mg IV/SC/PO q6h PRN
• Add lorazepam 0.5–1 mg q4h PRN if not controlled

If delirium refractory:
• Consider levomepromazine 6.25–12.5 mg SC q4–6h (if available)

Principles:
• Avoid restraints if possible
• Provide reassurance—explain to family normalcy of terminal agitation
~~~

#### Secretion Management Node
~~~text
RESPIRATORY SECRETIONS ("DEATH RATTLE")
───────────────────────────────────────

First-line:
• Reposition—side lying or semi-prone preferred

Pharmacologic:
• Glycopyrrolate 0.2 mg SC q4h PRN
• Scopolamine patch 1.5 mg q72h
• Atropine 1% SL drops 1–2 q4h PRN

Notes:
• Do *not* routinely suction—can worsen distress & injury
• Family education: patient unaware/unbothered; interventions aimed at comfort and minimizing family distress
~~~

---

### Card 1 — Symptom Guide (Static)
~~~text
COMMON END-OF-LIFE SYMPTOMS

PAIN:
• Present in 70–90%
• May increase near death / organ failure
• Grimacing, restlessness, withdrawal, moaning
• If unsure, *assume pain is present* and treat

DYSPNEA:
• Subjective—RR not a reliable marker
• Opioids are first-line
• Oxygen only if comforted by it; trial off after 24h if tolerant

DELIRIUM/AGITATION:
• Terminal restlessness is common; day/night reversal
• Picking, pulling, hallucinations; periods of lucidity

SECRETIONS ("Death rattle"):
• From oropharyngeal secretions
• Not directly distressing to patient; family education vital
• Pharmacologic “drying” partially effective

MYOCLONUS:
• Opioid neurotoxicity / metabolites
• Rotate opioid, add benzo, hydrate if not contraindicated
~~~

---

### Card 2 — Medication Protocols (Static)
~~~text
COMFORT MEDICATIONS

MORPHINE (FIRST-LINE):
• PRN: 2–5 mg IV/SC q2–4h (IV/SC preferred for rapid effect)
• Infusion: 24h total divided by 24 = mg/hr
• No maximum dose—titrate for comfort

LORAZEPAM:
• Anxiety/dyspnea/agitation: 0.5–2 mg q4h (SL/IV/SC preferred; PO/rectal if able)
• Infusion rarely needed

HALOPERIDOL:
• Delirium/agitation: 0.5–2 mg q6h (IV/SC/PO)
• QTc prolongation not relevant at EOL

GLYCOPYRROLATE:
• Secretions: 0.2 mg SC q4h, or scopolamine patch, atropine 1% SL drops

LEVOMEPROMAZINE:
• For refractory symptoms: 6.25–12.5 mg SC q4–6h (sedating, broad symptom coverage)

ALTERNATIVE/BRIDGING ROUTES:
• Buccal, Sublingual, SC, Rectal, Transdermal (for specific agents)
~~~

---

## ALGORITHM DECISION TREE

~~~mermaid
graph TD
    A[Comfort Care Initiated] --> B[Symptom Assessment]

    B --> C{Primary Symptom?}

    C -->|Pain| D[Pain Node: Morphine q2h PRN, Assess in 1h]
    C -->|Dyspnea| E[Dyspnea Node: Morphine + Supports]
    C -->|Agitation| F[Delirium Node: Rule-out, Haloperidol ± Lorazepam]
    C -->|Secretions| G[Secretions Node: Position, Glycopyrrolate]

    D --> H{Controlled?}
    E --> H
    F --> I{Cause Found?}
    G --> J[Family Education]

    H -->|Yes| K[Continue Current]
    H -->|No| L[Increase by 50% or Add Adjuvant]

    I -->|Yes| M[Treat Cause]
    I -->|No| N[Escalate Sedatives]

    K --> O[Reassess q4h]
    L --> O
    M --> O
    N --> O

    O --> P{Actively Dying?}

    P -->|Yes| Q[Continue Comfort, Family Support]
    P -->|No| R[If Frequent PRN, Convert to Scheduled/Infusion]
~~~

---

## NODE TO DYNAMIC CARD MAPPING + INTERACTIVE COMPONENTS

| **Node**                   | **Dynamic Card Name**  | **Clinical Prompt/Question**                                               | **Interface/Interactive Features**                    |
|----------------------------|------------------------|---------------------------------------------------------------------------|-------------------------------------------------------|
| A: Comfort Care Initiated  | Initial Assessment     | “Which symptom is priority to address for comfort?”                        | [Symptom Prioritization Buttons]                      |
| B: Symptom Assessment      | Symptom Checklist      | “Select main symptom: pain, dyspnea, agitation, secretions?”               | [Checklist, selection]                                |
| D: Pain                    | Pain Management        | “Morphine started. Is pain controlled after 1 hour?”                       | [Pain Scale, PRN counter, ‘Escalate’ option]          |
| E: Dyspnea                 | Dyspnea Management     | “Is dyspnea comforted by opioid and non-pharm measures?”                   | [Dyspnea scale, comfort YES/NO, escalation option]    |
| F: Agitation/Delirium      | Agitation Management   | “Any reversible causes found? Is restlessness controlled?”                  | [Reversible cause checklist, hallucination prompt]    |
| G: Secretions              | Secretion Management   | “Is death rattle distressing to family? Are measures helping?”              | [Positioning checklist, family education box]         |
| H: Control Achieved        | Continue Current Regimen| “Continue current dosing and reassess q4h”                                 | [Monitoring tracker]                                  |
| L: Escalation              | Dose Adjustment        | “Increase dose by 50% or add medication? Select option.”                   | [Dose calculator, adjunct selector]                   |
| M: Cause Treatable         | Treat Cause            | “Begin targeted therapy for reversible cause.”                              | [Therapeutic action prompt]                           |
| N: Escalate Sedation       | Sedative Escalation    | “Symptoms refractory: add/adjust sedatives.”                               | [Sedative adjustment, safety checklist]               |
| O: Reassessment            | Reassessment Tracker   | “Reassess key symptoms and comfort”                                         | [Symptom review, comfort assessment log]              |
| Q: Actively Dying          | Family Support         | “Active dying: continue comfort and support for family”                     | [Family presence tracker, resources offered]          |
| R: PRN Escalation          | Scheduled Conversion   | “If PRN used >3/day: convert to scheduled/infusion dosing”                  | [Infusion calculator, regimen adjustment]             |
| J: Family Education        | Family Guidance        | “Continue family communication and education”                               | [FAQ list, key points display]                        |

---

## INTERACTIVE ELEMENT EXAMPLES

### Opioid Infusion Calculator
~~~text
┌─────────────────────────────────────────┐
│    CONTINUOUS INFUSION SETUP            │
├─────────────────────────────────────────┤
│ Last 24h morphine use: 4mg × 8 = 32mg   │
│ Basal rate: 32mg ÷ 24hr = 1.33mg/hr     │
│ Round to 1.5mg/hr                       │
│ Breakthrough: 3mg IV q1h PRN            │
│ (≈10% of daily dose)                    │
│ >3 breakthroughs/day? Increase basal 25-50% │
└─────────────────────────────────────────┘
~~~

### Symptom Tracker
~~~text
┌─────────────────────────────────────────┐
│      COMFORT ASSESSMENT                 │
├─────────────────────────────────────────┤
│ Time   Pain  Dyspnea  Agitation  Meds   │
│ 08:00   7      5         2    M4,L1     │
│ 12:00   4      3         1      M4      │
│ 16:00   3      4         3    M4,H1     │
│ 20:00   2      2         1      M6      │
│ Trending: IMPROVED                      │
│ Morphine/24h: 36mg                      │
│ M=Morphine, L=Lorazepam, H=Haloperidol  │
└─────────────────────────────────────────┘
~~~

### Family Communication Guide
~~~text
┌─────────────────────────────────────────┐
│    FAMILY EDUCATION POINTS              │
├─────────────────────────────────────────┤
│ Natural dying process:                  │
│ ▸ Breathing changes explained           │
│ ▸ Decreased intake normal               │
│ ▸ Secretions not painful                │
│ ▸ Medications for comfort only          │
│ What to expect:                         │
│   – Sleeping increases                  │
│   – Irregular breathing                 │
│   – Cool extremities                    │
│   – Possible restlessness               │
│ Family may help by:                     │
│ ▸ Talking, touch                        │
│ ▸ Mouth care                            │
│ ▸ Gentle repositioning                  │
└─────────────────────────────────────────┘
~~~

---

**All above workflow and content reflects consensus from latest AAHPM, NCCN, and WHO Palliative/End-of-Life Care guidelines. For full guideline context, see:**  
- https://www.nationalcoalitionhpc.org/ncp  
- https://www.nccn.org/guidelines/guidelines-detail?category=3&id=1452  
- https://www.who.int/news-room/fact-sheets/detail/palliative-care  
- https://aahpm.org/competencies

---
