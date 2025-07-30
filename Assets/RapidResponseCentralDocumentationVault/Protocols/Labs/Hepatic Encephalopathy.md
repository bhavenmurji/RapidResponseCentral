# Hepatic Encephalopathy (HE) – Lab Protocol

**Guideline References:**  
- American Association for the Study of Liver Diseases (AASLD) Practice Guidance: Hepatic Encephalopathy in Chronic Liver Disease (2022)  
  https://www.aasld.org/publications/practice-guidelines  
- European Association for the Study of the Liver (EASL) Clinical Practice Guidelines on HE (2022)  
  https://easl.eu/publication/clinical-practice-guidelines-on-hepatic-encephalopathy  
- UpToDate: "Management of hepatic encephalopathy in adults" (accessed July 2025)  
  https://www.uptodate.com/contents/management-of-hepatic-encephalopathy-in-adults

---

## CARD INTERFACE LAYOUT

---

### Card 0 — Dynamic Action Card (Node Dependent)

#### Initial HE Assessment Node
~~~text
HEPATIC ENCEPHALOPATHY EVALUATION
───────────────────────────────────────

Mental status changes in cirrhosis
West Haven Criteria staging:
• Grade 1: Subtle attention/sleep changes
• Grade 2: Lethargy, disorientation, asterixis
• Grade 3: Somnolence, marked confusion, arousable
• Grade 4: Coma, unresponsive

First steps:
☑ Send ammonia (not for diagnosis, but trending/severity)
☑ Assess and document mental status (West Haven)
☑ Look for precipitating factors (see checklist below)

Prompt: “What is the West Haven grade and are there airway concerns?”
~~~

---

#### Acute Management Node
~~~text
HEPATIC ENCEPHALOPATHY TREATMENT
───────────────────────────────────────

If Grade 3–4 HE:
• Admit to monitored/ICU
• Secure airway; intubate if Grade 4 (coma)
• Hold sedatives, opioids, anticholinergics
• Start lactulose 30–45 mL PO/NG q1–2 h until BM, then titrate
• If unable PO: lactulose enema (300 mL in 700 mL retained)
• Add rifaximin 550 mg PO BID for all moderate-severe or persistent cases
• Monitor for dehydration and electrolyte derangements (esp. hypokalemia)
Prompt: “Has BM occurred? Monitor mental status and bowel frequency q4h”
~~~

---

#### Precipitant Search Node
~~~text
IDENTIFY & TREAT PRECIPITANTS
───────────────────────────────────────

Systematic search for triggers:
• GI bleeding (melena, heme+stool, falling hgb/BUN:Cr >20)
• Infection (SBP: paracentesis cell count, UTI: culture, CXR: pneumonia, blood/urine cultures)
• Dehydration, electrolyte issues (esp. hypoK, hypoNa)
• Drugs: recent sedatives, opioids, benzos, NSAIDs
• Constipation (last BM), dietary protein overload
• Renal failure/TIPS dysfunction

Actions:
• Control/treat underlying factor immediately (antibiotics, hold culprit drug, GI/endoscopy, fluids/electrolytes)
Prompt: “Have all precipitants been assessed and managed?”
~~~

---

### Card 1 — Diagnosis & Staging (Static)
~~~text
HEPATIC ENCEPHALOPATHY CLASSIFICATION

West Haven Criteria:
Grade 0: Normal
Grade 1: Subtle change, sleep reversal, mild confusion, attention
Grade 2: Lethargy, asterixis, disoriented, inappropriate behavior
Grade 3: Somnolent, marked confusion, arousable to stimuli only
Grade 4: Comatose, no pain response, posturing

Precipitants (from studies & AASLD/EASL):  
• GI bleed (varices, ulcer, etc.) — ~25%  
• Infection (SBP, UTI, pneumonia) — ~20%  
• Constipation, drug effect, electrolyte, dietary protein, post-TIPS

Diagnosis:  
• Primarily clinical; ammonia levels not required and may be misleading  
• Exclude non-HE causes of AMS  
• Document improvement following lactulose ± rifaximin  
~~~

---

### Card 2 — Treatment Protocols (Static)
~~~text
HE MANAGEMENT PROTOCOLS

FIRST-LINE THERAPY:
Lactulose:
• 30–45 mL PO/NG q1–2h until BM
• Titrate to 2–3 soft stools/day to prevent recurrence
• Enema if NPO/comatose: 300 mL in 700 mL H2O PR

Rifaximin:
• 550 mg PO BID (start for recurrent/severe HE or lack of response to lactulose)
• Reduces risk of recurrence

ADJUNCTS:
• Maintain K+ in high/normal range (3.5–4.5)
• Avoid protein restriction long-term; vegetable/branched-chain amino acids preferred (protein 1.2–1.5g/kg/d)
• Zinc supplementation if deficient (220 mg daily)
• Consider L-ornithine–L-aspartate for refractory cases (weak evidence)

MONITORING:
• Mental status, number of BMs, hydration status every shift/q4h if acute
• Electrolytes (esp. K+ and Na+) daily
• Reassess lactulose/rifaximin tolerance, dehydration risk

DO NOT Rely on ammonia levels to guide therapy. Clinical status trumps labs.
~~~

---

## ALGORITHM DECISION TREE

~~~mermaid
graph TD
    A[AMS in Cirrhosis] --> B[Grade HE<br/>West Haven]

    B --> C{Grade?}

    C -->|1–2| D[Floor/Outpatient<br/>Lactulose ± Rifaximin]
    C -->|3–4| E[ICU + Airway Precautions<br/>High-dose Lactulose]

    D --> F[Search Precipitant<br/>Correct]
    E --> F

    F --> G{Trigger Identified?}
    G -->|GI Bleed| H[Octreotide, Endoscopy, PRBC]
    G -->|Infection| I[Culture, Broad-spectrum Abx]
    G -->|Meds| J[Stop Sedatives/Opioids/Other]
    G -->|None| K[Continue Support, Re-assess]

    E --> L{Improvement after 24h?}
    L -->|Yes| M[Continue, taper lactulose, maintain therapy]
    L -->|No| N[Add/Continue Rifaximin, check compliance]

    N --> O{Persistent, Refractory?}
    O -->|Yes| P[Check for TIPS dysfunction, Consider L-ornithine-aspartate, ICU consult]
    O -->|No| Q[Maintenance Plan]
~~~

---

## NODE-TO-DYNAMIC CARD MAPPING & INTERACTIVE ELEMENTS

| **Algorithm Node**         | **Dynamic Card Prompt/Question**                           | **Interactive Features**                                        |
|----------------------------|-----------------------------------------------------------|-----------------------------------------------------------------|
| AMS in Cirrhosis           | "Assess mental status in cirrhosis: What is WH grade?"    | [West Haven Grade Picker][Level of Consciousness dropdown]      |
| Grade 1–2                  | "Start lactulose PO; outpatient or floor management ok?"  | [Lactulose dosing][BM tracking][Alert for infection/bleed]      |
| Grade 3–4                  | "ICU/admitted, secure airway if unconscious. Start intensive lactulose." | [ICU safety checklist][NG/enema dosing][Airway alert]  |
| Precipitant Search         | "Have you checked all common triggers?"                   | [Precipitant checklist][Abx order][Imaging prompts]             |
| Trigger-identified         | "Treat trigger: GI bleed, infection, med, constipation?"  | [Bleed/infection/medication workflow][Urgent consult]           |
| Post-treatment             | "Has mental status improved after 24h of therapy?"        | [Mental status reassessment][BM log][Continue/advance pathway]  |
| No improvement             | "Add/continue rifaximin, check compliance, re-check triggers." | [Rifaximin tracker][Review previous BM counts][Next steps]       |
| Persistent                 | "Refractory HE: TIPS problem? Consider specialist therapies." | [TIPS dysfunction screen][Specialist consult button]         |

---

## INTERACTIVE ELEMENTS

### HE Severity Calculator
~~~text
┌─────────────────────────────────────────┐
│    WEST HAVEN GRADE ASSESSMENT          │
├─────────────────────────────────────────┤
│ Mental status:                          │
│ ○ Alert and oriented                   │
│ ○ Mild confusion/sleep issues          │
│ ○ Lethargy, time disorientation        │
│ ○ Somnolent but arousable              │
│ ○ Comatose                             │
│ Motor findings:                         │
│ ○ No asterixis                         │
│ ○ Mild asterixis                       │
│ ○ Obvious asterixis                    │
│ ○ Hyperreflexia, rigidity              │
│ ○ Decerebrate posturing                │
│ West Haven Grade: ___                   │
│ Management:                             │
│ → ICU if Grade 3–4                     │
│ → Floor if Grade 1–2                   │
│ → Consider intubation if Grade 4        │
└─────────────────────────────────────────┘
~~~

### Lactulose Titration Guide
~~~text
┌─────────────────────────────────────────┐
│      LACTULOSE DOSING PROTOCOL          │
├─────────────────────────────────────────┤
│ Current HE Grade: [___]                 │
│ Time since last BM: [___] hours         │
│                                         │
│ Grade 3–4 (acute):                      │
│ • 30–45 mL q1–2h PO/NG until BM         │
│ • Then q8h or per BM                   
│ Grade 1–2:                              │
│ • 30 mL q4–6 h, titrate to 2–3 BM/d     │
│ Maintenance:                            │
│ • 15–30 mL BID-TID for prevention       │
│ NPO: Use retention enema (300 mL in 700 mL)│
└─────────────────────────────────────────┘
~~~

### Precipitant Checklist
~~~text
┌─────────────────────────────────────────┐
│    HE PRECIPITANT WORKUP                │
├─────────────────────────────────────────┤
│ BLEEDING:      ☐ Hemoccult   ☐ Hgb/BUN   │
│ INFECTION:     ☐ Paracentesis ☐ Cultures │
│                ☐ UA   ☐ CXR  ☐ Fever/WBC │
│ METABOLIC:     ☐ Electrolytes ☐ Diuretics│
│ CONSTIPATION:  ☐ BM log   ☐ Laxative ok │
│ MEDICATIONS:   ☐ Check for sedatives/opioids/benzos │
│ TIPS:          ☐ Imaging/Function if suspected     │
└─────────────────────────────────────────┘
~~~

---

**Protocol updates confirmed with latest AASLD and EASL guidance for diagnosis, staging, and management—including recommendations on lactulose, rifaximin, precipitant evaluation, dosing, safety, and monitoring. Direct URLs are included for rapid-access clinical validation and context.**
