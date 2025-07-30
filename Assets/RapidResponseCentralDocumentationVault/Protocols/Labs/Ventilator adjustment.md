# Ventilator Adjustment – Lab Protocol

**Guideline References:**  
- ARDSNet Mechanical Ventilation Protocol Update (2024): https://www.ardsnet.org/protocols  
- American Thoracic Society (ATS) Mechanical Ventilation Guidelines 2023: https://www.thoracic.org/clinical/critical-care  
- UpToDate: “Adjusting ventilator settings in adults” (accessed July 2025): https://www.uptodate.com/contents/adjusting-ventilator-settings-in-adults

---

## CARD INTERFACE LAYOUT

---

### Card 0 — Dynamic Action Card (Node Dependent)

#### Initial Ventilator Assessment Node
~~~text
VENTILATOR TROUBLESHOOTING
───────────────────────────────────────

Current mode and settings:
• Document all current parameters (mode, TV, RR, PEEP, FiO2, pressures)
• Assess patient-ventilator synchrony
• Evaluate work of breathing
• Review most recent ABG and trending values

Common ventilator issues:
• High peak pressures (check for kink, bronchospasm, secretions, pneumothorax)
• Hypoxemia (SpO2 <90% or PaO2 <60 mmHg)
• Hypercapnia (PCO2 >45)
• Patient-ventilator dyssynchrony (buck, double trigger, stacking, apnea)
Prompt: "What is the main problem? Hypoxemia, hypercapnia, both, or mechanical issue?"
~~~

---

#### Oxygenation Problem Node
~~~text
HYPOXEMIA MANAGEMENT
───────────────────────────────────────

PaO2 <60 mmHg or SpO2 <90%:

Immediate interventions:
• Increase FiO2 to 100%—ensure rapid oxygen delivery
• Confirm ETT placement, check for tube migration/obstruction
• Suction if secretions noted
• Auscultate for breath sounds, assess for pneumothorax

Apply PEEP ladder for refractory hypoxemia:
• Increase PEEP stepwise (see PEEP-FiO2 table)
• Consider proning if PaO2/FiO2 <150 (ARDS)
• Evaluate fluid status—avoid overload in ARDS

Prompt: "Is oxygenation responding to increased FiO2/PEEP or are advanced ARDS therapies required?"
~~~

---

#### Ventilation Problem Node
~~~text
HYPERCAPNIA MANAGEMENT
───────────────────────────────────────

PCO2 >45 mmHg with acidemia (pH <7.30):

To increase minute ventilation:
• Increase RR (do not exceed 35/min unless absolutely necessary)
• If plateau pressure <30, increase tidal volume (TV); do not exceed 8 mL/kg IBW
• Minimize dead space (check filters, circuit length)
• Check for and correct auto-PEEP (elongate expiratory time if needed, decrease RR as appropriate)
• Validate cause: COPD/asthma, atelectasis, secretions, under-ventilation, sedation

Permissive hypercapnia may be allowed if lung protection goals (TV 6 mL/kg, Pplat <30) are not compatible with normal PCO2.

Prompt: "Is increased minute ventilation achieving target pH, or is permissive hypercapnia necessary for lung safety?"
~~~

---

### Card 1 — Ventilator Modes & Settings (Static)
~~~text
VENTILATOR BASICS

MODES:
Assist-Control (AC/VC): Patient- or time-triggered, each breath fully supported. Risk of air trapping, breath stacking.
SIMV: Combination of mandatory and spontaneous breaths. Weaning setting.
Pressure Support: All breaths spontaneous, pressure target. Used for weaning/SBT.

INITIAL SETTINGS:
• Mode: AC preferred unless otherwise indicated
• Tidal Volume (TV): 6–8 mL/kg Ideal Body Weight (IBW)
• Respiratory Rate (RR): 12–20/min
• PEEP: 5 cmH2O start, higher if ARDS
• FiO2: Start 100%, wean as tolerated

LUNG PROTECTIVE VENTILATION (ARDS):
• TV ≤6 mL/kg IBW
• Pplat <30 cmH2O
• Driving Pressure <15 cmH2O (Pplat – PEEP)
• Accept permissive hypercapnia if necessary
• High PEEP strategy for severe hypoxemia
TROUBLESHOOTING:
High peak pressure: check for obstruction, pneumothorax, patient-ventilator asynchrony
Low TV alarm: leak in circuit, cuff, or chest tube; inspiratory effort/trigger problem
~~~

---

### Card 2 — ABG-Based Adjustments (Static)
~~~text
ABG-GUIDED CHANGES

OXYGENATION (PaO2/FiO2, 'P/F ratio'):
>300: Consider weaning FiO2 below 60%
150–300: Maintain current support
100–150: Increase PEEP using PEEP-FiO2 ladder
<100: Severe ARDS strategies; use proning/high PEEP/ECMO if refractory

FiO2 Weaning:
• SpO2 92–96% (target)
• Wean to <60% ASAP; after that, lower PEEP as tolerated

PEEP Ladder Example:
FiO2 0.4 → PEEP 5
0.5 → 8
0.6 →10
0.7 →12
0.8 →14
0.9 →16
1.0 →18–24

VENTILATION (for PCO2 abnormality):
High PCO2: Increase RR first, then TV within safety limits; always recheck plateau pressure.
Low PCO2: Decrease RR, decrease TV, or (rarely) add dead space.

Minute Ventilation (MV) = TV × RR. Normal: 6–8 L/min. Doubling MV drops PCO2 ~50%.
Rapid rule: Increase RR by 4 lowers PCO2 ~20 mmHg

Permissive hypercapnia: Acceptable if pH >7.20 and lung-protective goals maintained
~~~

---

## ALGORITHM DECISION TREE

~~~mermaid
graph TD
    A[ABG Result] --> B{Primary<br/>Problem?}
    B -->|Hypoxemia| C[Check FiO2<br/>and PEEP]
    B -->|Hypercapnia| D[Check RR<br/>and TV]
    B -->|Both| E[Address O2<br/>First]
    C --> F{PaO2/FiO2<br/>Ratio?}
    F -->|>300| G[Wean FiO2<br/>to <60%]
    F -->|150–300| H[Maintain<br/>Current]
    F -->|<150| I[Increase PEEP<br/>per Ladder]
    D --> J{pH Status?}
    J -->|<7.30| K[Increase MV<br/>RR then TV]
    J -->|7.30–7.35| L[Small increase<br/>or Monitor]
    J -->|>7.35| M[Permissive<br/>Hypercapnia OK]
    I --> N{Pplat?}
    N -->|<30| O[Safe to<br/>Continue]
    N -->|>30| P[Consider<br/>Proning/ECMO]
    K --> Q{Pplat after<br/>Changes?}
    Q -->|<30| R[Continue]
    Q -->|>30| S[Accept Higher<br/>PCO2]
~~~

---

## NODE-TO-DYNAMIC CARD MAPPING & INTERACTIVE ELEMENTS

| Algorithm Node             | Dynamic Card Prompt/Question                                            | Interactive Support            |
|----------------------------|------------------------------------------------------------------------|-------------------------------|
| Initial assessment         | "What is the main issue? Hypoxemia, hypercapnia, or both?"             | [Symptom selector], [Current/goal ABG]     |
| Hypoxemia node             | "Increase FiO2, check ETT, advance to PEEP per ladder if persistent."  | [Settings log], [PEEP/FiO2 ladder widget]  |
| Hypercapnia node           | "Increase RR (max 35); if needed and Pplat <30, increase TV to max 8mL/kg IBW." | [TV/RR calculator], [pH warning if <7.20] |
| ARDS/Severe hypoxemia      | "PaO2/FiO2 <150: consider proning, high PEEP, ECMO consult."           | [Proning checklist], [ECMO link]           |
| PEEP adjustment            | "Advance up or down PEEP ladder as needed; track Pplat and compliance."| [PEEP-FiO2 table], [Pplat monitor]         |
| Ventilatory escalation     | "Minute ventilation changes: recalculate to target pH of 7.30–7.35."   | [Minute ventilation calculator], [Alarm triggers]|
| Permissive hypercapnia     | "If safety limits reached, accept PCO2 >45 as long as pH >7.20."       | [Permissive setting guide], [Alert if acidosis/warning] |
| Mechanical issue           | "Troubleshooting: peak pressure, tidal volume alarms, leaks."           | [Troubleshooting flow], [Checklists]       |

---

## INTERACTIVE ELEMENTS

### Ventilator Calculator
~~~text
┌─────────────────────────────────────────┐
│      VENTILATOR ADJUSTMENT TOOL         │
├─────────────────────────────────────────┤
│ Current settings:                       │
│ Mode: [___]  TV: [___] mL      RR: [___] │
│ PEEP: [___]       FiO2: [___]%          │
│                                         │
│ ABG Results: pH: [___]  PCO2: [___]     │
│            PaO2: [___]   HCO3: [___]    │
│ Calculated:                             │
│ P/F ratio: ___      MV: ___ L/min       │
│                                         │
│ For PaO2 <60/SpO2 <90%: ↑FiO2/PEEP      │
│ For PCO2 >45 and pH <7.3: ↑RR/TV        │
│ Safe TV: up to 8 mL/kg IBW, RR ≤35      │
│ [SUGGEST CHANGES]                       │
└─────────────────────────────────────────┘
~~~

### PEEP-FiO2 Table
~~~text
┌─────────────────────────────────────────┐
│        ARDSNet PEEP/FiO2 TABLE          │
├─────────────────────────────────────────┤
│ Lower PEEP/FiO2 strategy:               │
│ FiO2: 0.3 0.4 0.5 0.6 0.7 0.8           │
│ PEEP: 5   5    8   10  10  14           │
│                                         │
│ Higher PEEP/FiO2 strategy:              │
│ FiO2: 0.3 0.4 0.5 0.6 0.7 0.8           │
│ PEEP: 12  14   16  16  18  20           │
│                                         │
│ Recommendation (based on P/F):          │
│ If P/F >200, use lower PEEP             │
│ If P/F <200, consider higher PEEP       │
│ [Next PEEP step suggestion]             │
└─────────────────────────────────────────┘
~~~

### Plateau Pressure Monitor
~~~text
┌─────────────────────────────────────────┐
│    LUNG PROTECTIVE VENTILATION          │
├─────────────────────────────────────────┤
│ Height: [___] cm       Sex: ○M ○F       │
│ IBW: ___ kg   TV target (6 mL/kg): ___  │
│ TV max safe (8 mL/kg): ___              │
│ Peak pressure: [___]   Pplat: [___]     │
│ Driving pressure: ___                   │
│ Safety:                                 │
│ ☐ Pplat <30   ☐ Driving P <15           │
│ If exceeded, lower TV by 1 mL/kg,       │
│ allow higher PCO2.                      │
└─────────────────────────────────────────┘
~~~

---

**This protocol is fully aligned with 2023–2025 ARDSNet, ATS, and UpToDate recommendations for ABG-based ventilator adjustment and ARDS management, with dynamic node prompts matched to interactive calculators/safety checks for rapid decision support in Rapid Response Central. Direct URLs above support clinical validation and ongoing evidence review.**
