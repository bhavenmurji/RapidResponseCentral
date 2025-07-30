# Coagulopathy & INR Reversal – Lab Protocol

**Guideline References:**  
- American College of Chest Physicians Antithrombotic Therapy for VTE Disease: CHEST Guideline and Expert Panel Report, 2021  
  https://journal.chestnet.org/article/S0012-3692(20)34684-1/fulltext  
- American Society of Hematology (ASH) 2024 VTE and anticoagulant reversal/bleeding guidelines  
  https://www.hematology.org/education/clinicians/guidelines  
- British Society for Haematology "Guidelines on oral anticoagulation with warfarin" (2022)  
  https://b-s-h.org.uk/guidelines

---

## CARD INTERFACE LAYOUT

---

### Card 0 — Dynamic Action Card (Node Dependent)

#### Elevated INR/Coagulopathy Node
~~~text
INITIAL COAGULOPATHY ASSESSMENT
───────────────────────────────────────

Determine urgency:
• Life-threatening bleeding
• Active bleeding (non-critical)
• Elevated INR without bleeding
• Pre-procedure management

Key factors:
• Current anticoagulant and most recent dose
• Anticoagulant indication (VTE, AFib, valve, etc.)
• Time since last dose
• Current INR/PT, aPTT
• Thrombosis risk/bleed risk

Interactive prompt: "Is there active bleeding, need for urgent reversal, or upcoming high-risk procedure?"
~~~

---

#### Urgent Reversal Node
~~~text
IMMEDIATE REVERSAL PROTOCOL
───────────────────────────────────────

For life-threatening or major bleeding (see ASH/ACC 2024):

WARFARIN:
• 4-factor PCC (Kcentra; see weight+INR table)
• Vitamin K 10mg IV (slow infusion)
• Goal INR <1.5
• FFP can be used if PCC not available (15-20 mL/kg)

DOACS:
• If apixaban/rivaroxaban/edoxaban: Andexanet alfa if available
• Otherwise: 4-factor PCC 50 units/kg (max 5000u)
• Dabigatran: Idarucizumab 5g IV (preferred), or hemodialysis if unavailable

HEPARIN:
• Protamine sulfate: 1mg per 100 units heparin (max 50mg)
• Reverse only if bleeding/risk high

Prompt: "Which anticoagulant? Is reversal agent (PCC, andexanet, or idarucizumab) available?"
~~~

---

#### Hold & Monitor Node
~~~text
NON-URGENT MANAGEMENT
───────────────────────────────────────

No bleeding, elevated INR:

• Hold anticoagulation (warfarin, DOAC, heparin)
• Monitor INR daily if >5, q48h if 3-5, or per protocol if on DOAC
• Reassess risk/benefit for anticoagulation

Vitamin K if:
• INR >10 (regardless of symptoms): give 2.5–5mg PO
• INR 5–10 and high bleeding risk: consider 1–2.5mg PO
• Pre-procedure if rapid reversal needed (consult anesthesia/ID for specifics)

Prompt: "Is there a reason to resume, adjust, or further correct INR/PT?"
~~~

---

### Card 1 — INR Goals & Actions (Static)
~~~text
INR TARGETS & MANAGEMENT

THERAPEUTIC GOALS:
• AFib/DVT/PE: 2–3
• Mechanical mitral valve: 2.5–3.5
• Mechanical aortic valve (bileaflet/modern): 2–3
• Older AVR/high-risk: 3–4

SUPRATHERAPEUTIC INR (No Bleeding):

INR 3–4.5: Reduce/hold 1 dose, resume at lower dose  
INR 4.5–10: Hold 1–2 doses, consider vitamin K 1–2.5mg PO  
INR >10: Hold warfarin + vitamin K 2.5–5mg PO

ANY INR + BLEEDING:
• Urgent reversal (see dynamic card)
• 4-factor PCC, vitamin K 10mg IV (slow)

SUBTHERAPEUTIC INR:
• Increase dose 10–20%
• Recheck in 3–5 days
• May consider loading dose if very low INR

WARFARIN-DRUG INTERACTIONS:
• Many antibiotics, amiodarone, antiepileptics, alcohol: all may impact INR
~~~

---

### Card 2 — Reversal Agents (Static)
~~~text
ANTICOAGULANT REVERSAL

WARFARIN:
4-Factor PCC (Kcentra):
• INR 2–4: 25 units/kg (max 2500u)
• INR 4–6: 35 units/kg (max 3500u)
• INR >6: 50 units/kg (max 5000u)
• Vitamin K 10mg IV (major bleed), 2.5–5mg PO if not urgent

FFP (Fresh Frozen Plasma):
• 15–20 mL/kg if PCC not available

DOACS:
Xa inhibitors (apixaban, rivaroxaban, edoxaban):
• Andexanet alfa (if available) per dosing chart (otherwise PCC 50u/kg)
Dabigatran:
• Idarucizumab 5g IV
• Hemodialysis (if unavailable, especially in renal impairment)

HEPARIN/LMWH:
• Protamine: 1mg per 100u heparin (max 50mg)
• For LMWH: 1mg per 1mg enoxaparin if <8h, 0.5mg per 1mg if 8–12h

ANTIPLATELET DRUGS:
• Platelet transfusion: 1–2 apheresis packs (if major bleeding only)
• DDAVP 0.3 mcg/kg IV (vWF, uremic bleeding)

OTHER:
• rFVIIa, aPCC/FEIBA: reserved for life-threatening cases
~~~

---

## ALGORITHM DECISION TREE

~~~mermaid
graph TD
    A[Elevated INR/Coagulopathy] --> B{Active<br/>Bleeding?}
    B -->|Yes| C[Urgent Reversal<br/>PCC + Vitamin K]
    B -->|No| D{INR Level?}
    C --> E[Target INR <1.5<br/>Recheck 30min]
    E --> F{Life-threatening<br/>Bleed?}
    F -->|Yes| G[Consider rFVIIa<br/>Surgical consult]
    F -->|No| H[Supportive Care<br/>Resume when Safe]
    D -->|<5| I[Hold Anticoagulant<br/>Monitor INR]
    D -->|5-9| J[Give Vit K 1–2.5mg PO<br/>Hold doses]
    D -->|>9| K[Vit K 2.5–5mg PO<br/>Daily INR]
    I --> L{Procedure Planned?}
    L -->|Yes| M[Calculate Timing<br/>Bridge if Needed]
    L -->|No| N[Resume when INR<br/>Therapeutic]
    J --> O[Recheck 24–48 h]
    K --> O
~~~

---

## NODE-TO-DYNAMIC CARD MAPPING & INTERACTIVE ELEMENTS

| **Algorithm Node**        | **Dynamic Card/Prompt**                                 | **Interactive Features**                   |
|---------------------------|--------------------------------------------------------|--------------------------------------------|
| Initial INR/Critical      | "Does the patient have bleeding/need for urgent reversal?" | [Anticoagulant selection buttons, urgency]  |
| Urgent Reversal           | "Which agent is needed for reversal? (Warfarin, DOAC, Heparin)" | [Reversal calculator, drug pick list]       |
| Hold & Monitor            | "No bleeding—monitor and hold? Reassess vitamin K need?" | [INR input], [Schedule monitor]             |
| INR targets & dose        | "Adjust warfarin by target INR and risk. Hold or reduce?" | [Weekly dose planner, interaction checker]  |
| Post-reversal             | "INR after reversal. Target reached? Further action?"    | [INR recheck prompt, action buttons]        |
| Pre-procedure             | "Planned procedure: When safe to proceed; bridge options?" | [Timing calculator, risk review]            |
| Bleeding + OAC agent      | "Which anticoagulation is present? Which reversal agent to order?" | [Drug/reversal matrix, dosing tool]         |

---

## INTERACTIVE ELEMENTS

### PCC Dose Calculator
~~~text
┌─────────────────────────────────────────┐
│        4-FACTOR PCC DOSING              │
├─────────────────────────────────────────┤
│ Enter INR: [___]                        │
│ Enter Weight (kg): [___]                │
│                                         │
│ INR 2–4: 25 units/kg                   │
│ INR 4–6: 35 units/kg                   │
│ INR >6: 50 units/kg                    │
│ [CALCULATE DOSE]                        │
│ Maximum single dose: 2500–3000 units    │
└─────────────────────────────────────────┘
~~~

### Warfarin Adjustment Tool
~~~text
┌─────────────────────────────────────────┐
│      WARFARIN DOSE ADJUSTMENT           │
├─────────────────────────────────────────┤
│ Current weekly dose: [___] mg           │
│ Most recent INR: [___]                  │
│ Target INR: 2–3                         │
│ Adjustment:                             │
│ – INR <2: increase 10–20 %              │
│ – INR 3–3.5: decrease 10 %              │
│ – INR 3.5–4: hold 1 dose/decrease 10–20%│
│ – INR >4: see reversal protocol         │
│ [CALCULATE]                             │
└─────────────────────────────────────────┘
~~~

### DOAC Reversal Guide
~~~text
┌─────────────────────────────────────────┐
│    DOAC REVERSAL SELECTION              │
├─────────────────────────────────────────┤
│ Select DOAC:                            │
│ ○ Apixaban (Eliquis)                   │
│ ○ Rivaroxaban (Xarelto)                │
│ ○ Dabigatran (Pradaxa)                 │
│ ○ Edoxaban (Savaysa)                   │
│                                         │
│ Bleed severity: ○ life-threatening ○ major ○ minor │
│ [GET REVERSAL PROTOCOL]                 │
│ (Shows: andexanet/idarucizumab/PCC plan)│
└─────────────────────────────────────────┘
~~~

---

**All recommendations reflect most recent ASH, CHEST, AABB, and BSH guidelines for anticoagulant reversal and INR/anticoagulant therapy adjustment. For direct clinical validation or further reading, use the URLs provided in the references above.**
