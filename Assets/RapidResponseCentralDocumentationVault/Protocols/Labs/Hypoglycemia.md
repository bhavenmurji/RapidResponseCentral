# Hypoglycemia Management – Clinical Call Protocol

**Guideline References:**  
- American Diabetes Association (ADA) Standards of Care 2024: https://diabetes.org/standards  
- Endocrine Society Clinical Practice Guideline (2022): https://www.endocrine.org  
- Joint British Diabetes Societies Inpatient Guidance (JBDS-IP) 2022: https://abcd.care/resource/joint-british-diabetes-societies
- UpToDate: "Management of hypoglycemia in adults with diabetes" (accessed July 2025): https://www.uptodate.com/contents/management-of-hypoglycemia-in-adults-with-diabetes

---

## CARD INTERFACE LAYOUT

---

### Card 0 — Dynamic Action Card (Node Dependent)

#### Initial Call/Immediate Actions (Dynamic)
~~~text
• POC Glucose: **42** mg/dL ⚠️

┌─────────────────────────────────────────────┐
│        IMMEDIATE HYPOGLYCEMIA ACTIONS       │
│                                             │
│ ☑ Confirm with lab glucose                   │
│ ☑ D50 25mL IV push NOW                      │
│ ☑ Recheck glucose in 15 min                  │
│ ☐ If no IV: Glucagon 1mg IM or 3mg nasal     │
│ ☐ Repeat q15min until >70 mg/dL              │
│ ☐ Once alert, give oral carbs if safe        │
└─────────────────────────────────────────────┘

RISK FACTORS:
• NPO for procedure tomorrow
• Glargine 40 units last dose (long-acting)
• CKD Stage 3 (↓ insulin clearance)
• No dinner eaten

⏰ HIGH risk for recurrent hypoglycemia
**Due to long-acting insulin + reduced oral intake**.
~~~

#### Recurrence Risk/Prevention Node (Dynamic)
~~~text
HYPOGLYCEMIA RECURRENCE RISK
───────────────────────────────────────

Risk Factors Present:
☑ Long-acting insulin (glargine, detemir, degludec)
☑ NPO status
☑ Renal/hepatic impairment
☑ Elderly, cognitive impairment
☑ Sulfonylureas or CKD (if present)
☑ Missed dinner/poor intake

Protocol Actions:
• Initiate D10W infusion if recurrent/unstable
• Hold or reduce insulin/sulfonylurea (per ADA 2024, JBDS-IP 2022)
• Increase frequency of monitoring (q1h × 4, then q2-4h)
• Early endocrine consult for persistent hypoglycemia
• Document events + treatment/alert team
~~~

---

### Card 1 — Clinical Assessment (Static)
~~~text
HYPOGLYCEMIA CLASSIFICATION & PRESENTATION

Levels:
Level 1 ("Alert"):
• 54–69 mg/dL; self-treat possible; oral glucose preferred

Level 2 ("Serious"):
• <54 mg/dL; may need assistance/cognitive impairment

Level 3 ("Severe"):
• Altered mental status, seizure/coma, external help required

Clinical Signs:
Autonomic: diaphoresis, tremor, palpitations, anxiety, hunger, nausea
Neuroglycopenic: confusion, seizures, LOC, visual changes, focal deficits

Common Etiologies:
Medication (insulin, sulfonylurea), dietary intake (missed meals/fasting), chronic kidney/liver disease, exercise, drug interactions (beta-blockers, alcohol), adrenal insufficiency, severe sepsis

Hospital Risks:
• NPO/surgical procedure
• Poor meal–med timing
• Steroid tapers
• Unrecognized CKD/elderly/frail/hypoglycemia unawareness
~~~

---

### Card 2 — Treatment Protocols (Static)
~~~text
HYPOGLYCEMIA TREATMENT — ADA/JBDS-IP 2024

🍬 CONSCIOUS (swallowing intact, alert):
• 15g rapid-acting carbohydrate (juice/glucose tabs/soda/honey)
• Recheck in 15 min; repeat if glucose <70mg/dL
• Once >70 & eating: give snack with complex carb + protein

💉 Altered (confused/unresponsive/NPO):
• D50 25 mL IV push NOW (12.5g dextrose) — repeat q15min if <70 mg/dL
• D10W 100–150 mL IV as alternative to D50 for small veins
• If no IV: glucagon 1mg IM/SC or 3mg intranasal (if available; not effective with no hepatic glycogen)

🔁 For persistent/recurrent episodes:
• Start D10 infusion @ 50–100 mL/hr (provides 5–10g/hr glucose)
• Check glucose q1h, titrate rate to keep 100–150mg/dL

🔎 Recurrent/unexplained: order
• C-peptide, insulin, concurrent meds, cortisol, LFTs
• Consider sulfonylurea screen, Whipple’s triad assessment

⚠️ Special Populations:
• Sulfonylurea toxicity (glyburide, glipizide, glimepiride): admit/observe, consider octreotide 50–100 mcg SC q8h
• CKD/liver disease: reduced gluconeogenesis/prolonged hypoglycemia, may need higher dextrose dose
• Thiamine before glucose in malnourished/alcoholic/encephalopathic

PREVENTION:
• Reduce/hold insulin for NPO or low output
• Temporarily suspend sulfonylureas after hypoglycemia event
• Monitor frequently; adjust targets if elderly/frail
~~~

---

## ALGORITHM DECISION TREE

~~~mermaid
graph TD
    A[Glucose <70 mg/dL] --> B{Patient Alert?}
    B -->|Yes| C[15g Oral Carbs<br/>Rule of 15]
    B -->|No| D{IV Access?}
    C --> E[Recheck in 15 min]
    D -->|Yes| F[D50 25mL IV Push]
    D -->|No| G[Glucagon 1mg IM/3mg Nasal]
    E --> H{Glucose >70?}
    F --> I[Recheck q15min]
    G --> I
    H -->|Yes| J[Give Snack, Monitor q1h]
    H -->|No| K[Repeat 15g Carbs]
    I --> L{Glucose >70?}
    L -->|Yes| M[Assess for Recurrence Risk]
    L -->|No| N[Repeat D50, Consider D10 Infusion]
    K --> E
    N --> O[Start D10 @ 75mL/hr, Check q1h]
    M --> P{High Recurrence Risk?}
    P -->|Yes| Q[D5/10 Infusion, Frequent Monitoring]
    P -->|No| R[Resume Diet, Standard Monitor]
    J --> P
    O --> S[Investigate Underlying Cause, Adjust Meds]
    Q --> S
~~~

---

## NODE-TO-DYNAMIC CARD MAPPING & INTERACTIVE COMPONENTS

| **Algorithm Node**            | **Dynamic Card Prompt/Question**                                   | **Interface/Interactive Elements**                  |
|------------------------------ |-------------------------------------------------------------------|-----------------------------------------------------|
| Glucose <70 mg/dL             | "Is patient alert and able to swallow?"                            | [Alert? Y/N], [PO route ready?], [Call help button] |
| Rule of 15 (Oral)             | "Give 15g carbs, recheck in 15min. Did glucose correct?"           | [15g Sheet], [Recheck Timer], [Next Step]           |
| IV Access/Unconscious         | "Give D50 25ml IV push/frequency. No IV? Use Glucagon IM/nasal"    | [IV/No IV radio], [Glucagon/Repeat D50 buttons]     |
| Assess Recurrence Risk        | "Does this patient need preventive infusion/med adjustment?"       | [Risk factor checklist], [Infusion manager]         |
| Persistent/repeated episodes  | "Start D10W @ 75mL/h. How is glucose trending? Adjust as needed."  | [Infusion input], [Hourly glucose chart]            |
| Prevention/Education          | "Was this a preventable event? Adjust medication? Notify team?"    | [Educator pop-up], [Endocrine consult button]       |

---

## INTERACTIVE ELEMENTS

### Hypoglycemia Treatment Calculator

~~~text
┌─────────────────────────────────────────┐
│    HYPOGLYCEMIA TREATMENT GUIDE         │
├─────────────────────────────────────────┤
│ Glucose: 42 mg/dL                       │
│ Mental Status: Somnolent                │
│ IV Access: YES                          │
│                                         │
│ → D50W 25mL IV push NOW                │
│ → Recheck q15min x 2                    │
│ If no response or >3 episodes:          │
│ Start D10 at 75mL/hr & monitor          │
│ After recovery, give snack or titrate   │
└─────────────────────────────────────────┘
~~~

### Recurrence Risk Assessment

~~~text
┌─────────────────────────────────────────┐
│   HYPOGLYCEMIA RECURRENCE RISK ASSESS   │
├─────────────────────────────────────────┤
│ Factors:                                │
│ ☑ Long-acting insulin                   │
│ ☑ NPO status/procedure                  │
│ ☑ CKD/Liver disease                     │
│                                         │
│ HIGH RISK → Start D10W infusion         │
│ Frequent monitoring, adjust meds        │
└─────────────────────────────────────────┘
~~~

### D10 Infusion Manager

~~~text
┌────────────────────────────────────────┐
│   D10W INFUSION MANAGEMENT             │
├────────────────────────────────────────┤
│ Current Rate: 75 mL/hr                 │
│ Titrate: q1h to maintain >70 mg/dL     │
└────────────────────────────────────────┘
~~~

---

**Protocol last updated to reflect ADA/EASD/Endocrine Society/UK JBDS-IP 2022–2024 standards. All steps match the emergency management consensus for inpatient and critical care hypoglycemia. External links above allow clinical validation and full context for rapid-response reference.**
