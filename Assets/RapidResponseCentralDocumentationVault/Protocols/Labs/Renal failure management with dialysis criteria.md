# Renal Failure & Dialysis Criteria – Lab Protocol

**Guideline References:**  
- Kidney Disease: Improving Global Outcomes (KDIGO) Acute Kidney Injury Work Group Guidelines 2024  
  https://kdigo.org/guidelines/acute-kidney-injury  
- National Kidney Foundation KDOQI Clinical Practice Guidelines for Hemodialysis and Peritoneal Dialysis 2023  
  https://www.kidney.org/professionals/guidelines  
- International Society of Nephrology Global Kidney Health Atlas 2024  
  https://www.theisn.org/global-kidney-health-atlas  
- UpToDate: "Indications for renal replacement therapy in acute kidney injury" (accessed July 2025)  
  https://www.uptodate.com/contents/indications-for-renal-replacement-therapy-in-acute-kidney-injury

---

## CARD INTERFACE LAYOUT

---

### Card 0 — Dynamic Action Card (Node Dependent)

#### Initial Renal Assessment Node
~~~text
ACUTE KIDNEY INJURY EVALUATION
───────────────────────────────────────

Current renal function assessment:
• Document baseline creatinine (if available)
• Calculate eGFR using CKD-EPI equation
• Assess 24h urine output (<0.5 mL/kg/h = oliguria)
• Review trend over 48-72h

KDIGO AKI Staging:
• Stage 1: Cr ↑≥0.3 mg/dL or 1.5-1.9× baseline, UOP <0.5 mL/kg/h × 6-12h
• Stage 2: Cr 2.0-2.9× baseline, UOP <0.5 mL/kg/h × ≥12h
• Stage 3: Cr ≥3× baseline or ≥4.0 mg/dL, UOP <0.3 mL/kg/h × ≥24h or anuria ≥12h

Prompt: "What is the AKI stage and are there emergent dialysis indications?"
~~~

---

#### Dialysis Urgency Node
~~~text
EMERGENT DIALYSIS INDICATED
───────────────────────────────────────

Life-threatening indications present (AEIOU):
• Acidosis: pH <7.1, refractory to bicarbonate
• Electrolytes: K+ >6.5 mEq/L refractory to medical therapy
• Intoxication: Dialyzable toxins (methanol, ethylene glycol, lithium, salicylates)
• Overload: Pulmonary edema refractory to diuretics, respiratory compromise
• Uremia: Pericarditis, encephalopathy, bleeding diathesis

Immediate actions:
• Contact nephrology STAT
• Prepare for emergent vascular access (temporary dialysis catheter)
• Consider hemodialysis vs CRRT based on hemodynamic stability

Prompt: "Emergent dialysis needed within 2-6 hours. Is patient stable for intermittent HD or requires CRRT?"
~~~

---

#### Conservative Management Node
~~~text
MEDICAL MANAGEMENT APPROACH
───────────────────────────────────────

No emergent dialysis indications present:
• Optimize volume status (euvolemia vs gentle diuresis if overloaded)
• Dose-adjust all medications for reduced GFR
• Avoid nephrotoxins (NSAIDs, contrast, aminoglycosides)
• Monitor electrolytes q12-24h, daily weights
• Nutritional support, protein restriction if uremic

Consider elective dialysis planning if:
• Progressive decline toward Stage 3 AKI
• BUN >100 mg/dL with symptoms
• Persistent oliguria despite optimization
• Development of uremic symptoms

Prompt: "Continue medical management with close monitoring or plan elective dialysis initiation?"
~~~

---

### Card 1 — Dialysis Indications (Static)
~~~text
DIALYSIS CRITERIA

EMERGENT (AEIOU):
Acidosis: pH <7.1, refractory metabolic acidosis
Electrolytes: K+ >6.5 refractory, severe hyperphosphatemia (>10 mg/dL)
Intoxication: Methanol, ethylene glycol, lithium, salicylates, isopropanol
Overload: Pulmonary edema, CHF refractory to diuretics
Uremia: Pericarditis, encephalopathy, bleeding, asterixis

URGENT (within 24h):
• BUN >100 mg/dL with symptoms
• Persistent oliguria/anuria >24h
• Severe hyperphosphatemia in tumor lysis
• Volume overload with respiratory compromise

ELECTIVE/CKD:
• eGFR <10-15 mL/min/1.73m² (CKD 5)
• Uremic symptoms (nausea, pruritus, decreased appetite)
• Uncontrolled hypertension or volume overload
• Malnutrition from uremia
• Quality of life significantly impacted

RELATIVE CONTRAINDICATIONS:
• Severe hypotension/shock
• Active bleeding
• Comfort care goals
~~~

---

### Card 2 — Dialysis Modalities (Static)
~~~text
DIALYSIS MODALITIES

INTERMITTENT HEMODIALYSIS (IHD):
Indications:
• Hemodynamically stable patients
• Rapid correction needed (hyperkalemia, toxins)
• Efficient solute clearance

Settings:
• Duration: 3-4 hours
• Blood flow: 300-400 mL/min
• Dialysate flow: 500-800 mL/min
• Ultrafiltration: <13 mL/kg/h for hemodynamic stability

CONTINUOUS RENAL REPLACEMENT THERAPY (CRRT):
Indications:
• Hemodynamic instability/vasopressor dependence
• Severe volume overload requiring large fluid removal
• Elevated ICP/brain injury
• Liver failure

Modalities:
• CVVH: Convection-based, good for middle molecules
• CVVHD: Diffusion-based, efficient small solute clearance
• CVVHDF: Combined convection + diffusion

Settings:
• Blood flow: 150-200 mL/min
• Effluent rate: 25-35 mL/kg/h

VASCULAR ACCESS:
Temporary (emergent):
• Internal jugular (preferred, lowest infection risk)
• Femoral (quick access, limit to <5 days if possible)
• Subclavian (avoid—stenosis risk)

Permanent (CKD):
• Arteriovenous fistula (gold standard, lowest infection/thrombosis)
• Arteriovenous graft (if poor vessels)
• Tunneled dialysis catheter (bridge or last resort)

ANTICOAGULATION:
• Standard heparin (PTT 60-80s)
• Minimal heparin (bleeding risk)
• Heparin-free (active bleeding)
• Regional citrate (CRRT, contraindicated if liver failure)
~~~

---

## ALGORITHM DECISION TREE

~~~mermaid
graph TD
    A[Renal Failure/AKI] --> B{Emergent Indication?}
    B -->|Yes| C[STAT Nephrology + Dialysis]
    B -->|No| D[Assess Trajectory]
    C --> E{Vascular Access?}
    E -->|Available| F[Start Dialysis]
    E -->|None| G[Place Temporary Access]
    D --> H{Progressive Decline?}
    H -->|Yes| I[Plan Elective Dialysis]
    H -->|No| J[Medical Management]
    F --> K{Hemodynamically Stable?}
    K -->|Yes| L[Intermittent HD]
    K -->|No| M[CRRT]
    I --> N[Nephrology Consult]
    J --> O[Daily Labs, Monitor UOP]
    G --> P{Access Site?}
    P -->|IJ| Q[Preferred for Duration >5d]
    P -->|Femoral| R[Quick but <5d Duration]
    N --> S[Access Planning]
    S --> T[Fistula vs Graft vs Catheter]
    O --> U{Worsening?}
    U -->|Yes| V[Reassess Dialysis Need]
    U -->|No| W[Continue Conservative]
~~~

---

## NODE-TO-DYNAMIC CARD MAPPING & INTERACTIVE ELEMENTS

| **Algorithm Node**        | **Dynamic Card Prompt/Question**                                    | **Interactive Features**                     |
|---------------------------|---------------------------------------------------------------------|----------------------------------------------|
| Initial Assessment        | "What is current AKI stage? Any emergent dialysis criteria?"        | [KDIGO staging calculator], [Urgency scorer] |
| Emergent Dialysis         | "AEIOU criteria present? Start immediate dialysis planning."        | [Emergent checklist], [Access options]       |
| Conservative Management   | "No urgent need—optimize medical therapy and monitor closely."      | [Med adjustment tool], [Monitoring schedule] |
| Hemodynamic Assessment    | "Stable for intermittent HD or requires gentle CRRT?"              | [BP/pressor status], [Fluid removal calc]    |
| Access Planning           | "Temporary vs permanent access? Site selection and timing."         | [Access decision tree], [Site complications] |
| Modality Selection        | "IHD vs CRRT vs PD? Based on clinical status and goals."           | [Modality comparison], [Prescription tool]   |
| Monitoring/Trending       | "Is AKI improving, stable, or progressing toward RRT need?"        | [Trend tracker], [Recovery predictor]        |
| CKD Progression           | "Approaching CKD 5—time for permanent access and education."       | [CKD progression], [Patient education tools] |

---

## INTERACTIVE ELEMENTS

### Dialysis Urgency Scorer
~~~text
┌─────────────────────────────────────────┐
│      DIALYSIS URGENCY ASSESSMENT        │
├─────────────────────────────────────────┤
│ EMERGENT CRITERIA (within 2-6h):       │
│ ☐ K+ >6.5 refractory to medical Rx     │
│ ☐ pH <7.1 refractory to bicarbonate    │
│ ☐ Pulmonary edema + hypoxia             │
│ ☐ Uremic pericarditis/encephalopathy    │
│ ☐ Dialyzable toxin ingestion            │
│                                         │
│ URGENT CRITERIA (within 24h):           │
│ ☐ BUN >100 with symptoms                │
│ ☐ Anuria >12h                           │
│ ☐ Volume overload + CHF                 │
│                                         │
│ Recommendation: [EMERGENT/URGENT/ELECTIVE] │
│ Time to dialysis: [<6h/24h/Days]        │
└─────────────────────────────────────────┘
~~~

### Fluid Removal Calculator
~~~text
┌─────────────────────────────────────────┐
│    ULTRAFILTRATION PLANNING             │
├─────────────────────────────────────────┤
│ Current weight: [___] kg                │
│ Estimated dry weight: [___] kg          │
│ Excess fluid: ___ L                     │
│ IHD (3-4h): Max 13 mL/kg/h = ___ L max  │
│ CRRT: 100-200 mL/h = 2.4-4.8 L/day     │
│ BP: [___]/[___] Pressors: ○Y ○N        │
│ Recommendation:                         │
│ → CRRT if unstable or >4L removal       │
│ → IHD if stable                         │
└─────────────────────────────────────────┘
~~~

### Dialysis Prescription Tool
~~~text
┌─────────────────────────────────────────┐
│      INITIAL DIALYSIS PRESCRIPTION      │
├─────────────────────────────────────────┤
│ HEMODIALYSIS:                           │
│ Duration: ○ 3h ○ 4h                     │
│ Blood flow: 300-400 mL/min              │
│ Dialysate: K+ [2-4] Ca++ [2.5] HCO3 [35]│
│ UF goal: [___] L                        │
│ Anticoagulation: ○ Heparin ○ Minimal ○ Free │
│                                         │
│ CRRT:                                   │
│ Mode: ○ CVVH ○ CVVHD ○ CVVHDF           │
│ Blood flow: 150-200 mL/min              │
│ Effluent: 25-35 mL/kg/h                 │
│ [GENERATE ORDERS]                       │
└─────────────────────────────────────────┘
~~~

---

**This protocol reflects current KDIGO 2024, KDOQI 2023, and international nephrology society evidence for AKI management and RRT initiation. All decision nodes are mapped to interactive clinical decision support tools for immediate bedside use in Rapid Response Central. Direct validation links provided above for ongoing evidence review.**
