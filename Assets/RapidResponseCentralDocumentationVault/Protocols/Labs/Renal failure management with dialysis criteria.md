# AKI Protocol – Acute Kidney Injury & Dialysis Management with Virtua Voorhees Addenda
## Final Version with Integrated Diagnostic Calculators

**Primary Guideline:** KDIGO Acute Kidney Injury Work Group Guidelines 2024
**Official Source:** https://kdigo.org/guidelines/acute-kidney-injury
**Supporting Guidelines:** 
- AAFP Clinical Guidelines for Acute Kidney Injury 2019
- KDOQI Clinical Practice Guidelines for Hemodialysis 2023
- MDCalc Clinical Decision Support Tools

## ENHANCED DYNAMIC CARD SYSTEM WITH INTEGRATED CALCULATORS

### Card 0 – Initial AKI Assessment (Node A → B)
┌─────────────────────────────────────────┐
│ 🔬 ACUTE KIDNEY INJURY ASSESSMENT       │
├─────────────────────────────────────────┤
│ 📊 KDIGO AKI STAGING:                   │
│ • Stage 1: Cr 1.5-1.9× baseline OR     │
│   ≥26.5μmol/L increase, UOP <0.5mL/kg/h│
│ • Stage 2: Cr 2.0-2.9× baseline        │
│ • Stage 3: Cr ≥3× baseline OR ≥353.6μmol/L│
│   OR initiation of RRT OR anuria ≥12h  │
│                                         │
│ 🚨 Immediate drug chart review needed   │
│                                         │
│ ❓ Does patient meet AKI criteria?      │
│                                         │
│ 🔘 YES → Investigate causes            │
│ 🔘 NO → Monitor renal function         │
│                                         │
│ [Next: Based on Selection ▶]            │
└─────────────────────────────────────────┘

### Card 1A – Investigate AKI (Node C → Investigations)
┌─────────────────────────────────────────┐
│ 🔍 AKI INVESTIGATION PROTOCOL           │
├─────────────────────────────────────────┤
│ 💊 Drug chart modifications:            │
│ • Hold metformin                       │
│ • Hold diuretics                       │
│ • Hold ACE/ARBs                        │
│ • Hold NSAIDs                          │
│ • Avoid IV contrast                    │
│ • Review antimicrobials dosing         │
│   (aminoglycosides, vancomycin,        │
│   aciclovir, amphotericin, foscarnet)  │
│                                         │
│ 📋 Essential investigations ordered:    │
│ • FBC, U&E, CRP, Ca²⁺, PO₄³⁻, Mg²⁺    │
│ • VBG, LFT, clot, CK                   │
│ • Urinalysis with microscopy           │
│ • Urine electrolytes (Na+, Cr for FENa)│
│                                         │
│ [Next: Etiology determination ▶]       │
│                                         │
│ [◀ Previous: Initial Assessment]       │
└─────────────────────────────────────────┘

### Card 1B – Monitor Function (Node Monitor - Final)
┌─────────────────────────────────────────┐
│ 📈 RENAL FUNCTION MONITORING            │
├─────────────────────────────────────────┤
│ 📊 Trend monitoring:                    │
│ • Baseline creatinine established      │
│ • No acute rise detected              │
│ • Continue routine monitoring          │
│                                         │
│ ⚠️  Watch for progression:              │
│ • Daily creatinine if at risk          │
│ • Urine output monitoring              │
│ • Nephrotoxin avoidance                │
│                                         │
│ ✅ FUNCTION MONITORING ACTIVE          │
│                                         │
│ [◀ Previous: Initial Assessment]       │
└─────────────────────────────────────────┘

### Card 2A – Etiology Determination (Node Investigations → Etiology)
┌─────────────────────────────────────────┐
│ 🔬 AKI ETIOLOGY ASSESSMENT              │
├─────────────────────────────────────────┤
│ 🩺 Clinical evaluation:                 │
│ • Volume status assessment             │
│ • Medication review completed          │
│ • Systemic illness evaluation          │
│ • Urinary obstruction screening        │
│                                         │
│ 🧪 Urinalysis interpretation:           │
│ • Bland sediment → Prerenal likely     │
│ • Muddy brown casts → ATN              │
│ • RBC casts → Glomerulonephritis       │
│ • WBC casts → Interstitial nephritis   │
│                                         │
│ ❓ Prerenal vs intrinsic unclear?       │
│                                         │
│ 🔘 YES → FENa/FEUrea calculators       │
│ 🔘 NO → Proceed to specific management │
│                                         │
│ [◀ Previous] [Next: Based on Selection ▶]│
└─────────────────────────────────────────┘

### Card 2B – Direct Management (Node Specific Mgmt)
┌─────────────────────────────────────────┐
│ 🎯 DIRECT AKI MANAGEMENT                │
├─────────────────────────────────────────┤
│ 📋 Clear etiology identified:           │
│ • Prerenal: Volume resuscitation       │
│ • ATN: Supportive care                 │
│ • Glomerular: Consider biopsy          │
│ • Obstructive: Relieve obstruction     │
│                                         │
│ 🏥 Nephrology consultation if:          │
│ • Unclear intrinsic cause              │
│ • Rapidly progressive GN suspected     │
│ • Severe AKI (Stage 3)                 │
│                                         │
│ [Next: Risk stratification ▶]          │
│                                         │
│ [◀ Previous: Etiology Determination]   │
└─────────────────────────────────────────┘

### Card 3A – FENa Calculator (Node Calculator Modal)
┌─────────────────────────────────────────┐
│ 🧮 FRACTIONAL EXCRETION OF SODIUM      │
├─────────────────────────────────────────┤
│ 📊 Required values:                     │
│ • Serum Creatinine: [___] mg/dL        │
│ • Serum Sodium: [___] mEq/L            │
│ • Urine Creatinine: [___] mg/dL        │
│ • Urine Sodium: [___] mEq/L            │
│                                         │
│ 🔢 Formula:                             │
│ FENa = (UNa×SCr)/(UCr×SNa) × 100       │
│                                         │
│ 📈 Result: [__._]%                      │
│                                         │
│ 🎯 Interpretation:                      │
│ • <1%: Prerenal AKI                    │
│ • >2%: Intrinsic renal disease (ATN)   │
│ • 1-2%: Indeterminate (use FEUrea)     │
│                                         │
│ ❓ FENa result interpretation?          │
│                                         │
│ 🔘 <1% → Prerenal management           │
│ 🔘 >2% → ATN management                │
│ 🔘 1-2% → Check FEUrea calculator      │
│                                         │
│ [◀ Previous] [Next: Based on Selection ▶]│
└─────────────────────────────────────────┘

### Card 3B – FEUrea Calculator (Node Calculator Modal)
┌─────────────────────────────────────────┐
│ 🧮 FRACTIONAL EXCRETION OF UREA        │
├─────────────────────────────────────────┤
│ 📊 Required values:                     │
│ • Serum BUN: [___] mg/dL               │
│ • Serum Creatinine: [___] mg/dL        │
│ • Urine BUN: [___] mg/dL               │
│ • Urine Creatinine: [___] mg/dL        │
│                                         │
│ 🔢 Formula:                             │
│ FEUrea = (UBun×SCr)/(UCr×SBun) × 100   │
│                                         │
│ 📈 Result: [__._]%                      │
│                                         │
│ 🎯 Interpretation:                      │
│ • ≤35%: Prerenal AKI                   │
│ • >50%: Intrinsic renal disease        │
│ • 35-50%: Indeterminate                │
│                                         │
│ 💡 More accurate than FENa if:          │
│ • Patient on diuretics                 │
│ • Chronic kidney disease               │
│                                         │
│ ❓ FEUrea result interpretation?        │
│                                         │
│ 🔘 ≤35% → Prerenal management          │
│ 🔘 >50% → ATN management               │
│ 🔘 35-50% → Clinical judgment needed   │
│                                         │
│ [◀ Previous] [Next: Based on Selection ▶]│
└─────────────────────────────────────────┘

### Card 4A – Prerenal Management (Node Prerenal → Volume)
┌─────────────────────────────────────────┐
│ 🩸 PRERENAL AKI MANAGEMENT              │
├─────────────────────────────────────────┤
│ 💧 Volume assessment & resuscitation:   │
│ • Assess volume status clinically      │
│ • Isotonic crystalloid (LR preferred)  │
│ • Initial bolus: 500mL-1L over 30min   │
│ • Target MAP ≥65 mmHg                  │
│                                         │
│ 📊 Monitor response:                    │
│ • Urine output improvement             │
│ • Creatinine stabilization/improvement │
│ • Hemodynamic parameters               │
│                                         │
│ ⚠️  Avoid overresuscitation:            │
│ • Stop if signs of volume overload     │
│                                         │
│ ❓ Response to fluid resuscitation?     │
│                                         │
│ 🔘 GOOD → Continue supportive care     │
│ 🔘 POOR → Reassess etiology           │
│                                         │
│ [◀ Previous] [Next: Based on Selection ▶]│
└─────────────────────────────────────────┘

### Card 4B – ATN Management (Node ATN → Support)
┌─────────────────────────────────────────┐
│ 🫘 ACUTE TUBULAR NECROSIS MANAGEMENT    │
├─────────────────────────────────────────┤
│ 🛡️  Supportive care measures:           │
│ • Maintain euvolemia                   │
│ • Continue medication holds            │
│ • Optimize hemodynamics                │
│ • Nutrition support                    │
│                                         │
│ 📊 Monitor for recovery:                │
│ • Daily creatinine trending           │
│ • Urine output patterns               │
│ • Electrolyte stability               │
│                                         │
│ 🎯 Recovery timeline:                   │
│ • Typically 1-3 weeks for recovery    │
│ • Monitor for complications            │
│                                         │
│ [Next: Complication monitoring ▶]      │
│                                         │
│ [◀ Previous: Calculator Results]       │
└─────────────────────────────────────────┘

### Card 4C – Clinical Judgment (Node Indeterminate)
┌─────────────────────────────────────────┐
│ 🤔 INDETERMINATE RESULTS - CLINICAL JUDGMENT│
├─────────────────────────────────────────┤
│ 🔍 Additional considerations:           │
│ • Mixed prerenal + ATN possible        │
│ • Early ATN may have low FENa          │
│ • Contrast exposure timing             │
│ • Sepsis with prerenal + intrinsic     │
│                                         │
│ 🎯 Approach:                            │
│ • Cautious fluid trial                 │
│ • Close monitoring of response         │
│ • Early nephrology consultation        │
│                                         │
│ ❓ Clinical assessment suggests?        │
│                                         │
│ 🔘 LIKELY PRERENAL → Cautious fluids   │
│ 🔘 LIKELY ATN → Supportive care        │
│ 🔘 UNCLEAR → Nephrology consult        │
│                                         │
│ [◀ Previous] [Next: Based on Selection ▶]│
└─────────────────────────────────────────┘

### Card 5A – Risk Stratification (Node Risk Assessment)
┌─────────────────────────────────────────┐
│ ⚖️  AKI RISK STRATIFICATION             │
├─────────────────────────────────────────┤
│ 📊 Assess patient risk factors:         │
│ • Hypovolaemia                         │
│ • Acidosis (pH <7.35)                  │
│ • Pulmonary oedema                     │
│ • Uraemic encephalopathy               │
│ • Hyperkalaemia (K+ >5.5)              │
│                                         │
│ 🔬 Laboratory trend analysis:           │
│ • Rising creatinine velocity           │
│ • Electrolyte abnormalities            │
│ • Acid-base disturbances               │
│                                         │
│ ❓ Risk level assessment?               │
│                                         │
│ 🔘 HIGH RISK → Emergency management    │
│ 🔘 MODERATE → Medical optimization     │
│ 🔘 LOW RISK → Conservative care        │
│                                         │
│ [◀ Previous] [Next: Based on Selection ▶]│
└─────────────────────────────────────────┘

### Card 6A – Emergency Management (Node High Risk → Complications)
┌─────────────────────────────────────────┐
│ 🚨 EMERGENCY AKI MANAGEMENT             │
├─────────────────────────────────────────┤
│ 🎯 Immediate priorities:                │
│ • Life-threatening complications first │
│ • Hyperkalaemia (K+ >6.5): Ca²⁺ + insulin│
│ • Severe acidosis: Bicarbonate if pH<7.1│
│ • Pulmonary edema: Diuretics + CPAP    │
│ • Uremic complications: Consider RRT   │
│                                         │
│ 🔄 Supportive measures:                 │
│ • PPI for GI bleeding prevention       │
│ • Phosphate monitoring                 │
│ • Anemia management                    │
│                                         │
│ ❓ Emergent dialysis criteria (AEIOU)?  │
│                                         │
│ 🔘 YES → Dialysis evaluation           │
│ 🔘 NO → Intensive monitoring           │
│                                         │
│ [◀ Previous] [Next: Based on Selection ▶]│
└─────────────────────────────────────────┘

### Card 6B – Medical Optimization (Node Moderate → Monitoring)
┌─────────────────────────────────────────┐
│ 💊 MEDICAL OPTIMIZATION PROTOCOL        │
├─────────────────────────────────────────┤
│ 🎯 Systematic approach:                 │
│ • Optimize volume status               │
│ • Address underlying causes            │
│ • Prevent further injury               │
│ • Monitor for progression              │
│                                         │
│ 📊 Enhanced monitoring:                 │
│ • Labs q12-24h based on stability      │
│ • I/O balance tracking                 │
│ • Daily weights                        │
│ • Medication level monitoring          │
│                                         │
│ [Next: Response monitoring ▶]          │
│                                         │
│ [◀ Previous: Risk Stratification]      │
└─────────────────────────────────────────┘

### Card 6C – Conservative Care (Node Low Risk → Follow-up)
┌─────────────────────────────────────────┐
│ 🛡️  CONSERVATIVE AKI MANAGEMENT         │
├─────────────────────────────────────────┤
│ 💊 Standard supportive measures:        │
│ • Maintain drug holds appropriately    │
│ • Monitor fluid balance                │
│ • Regular laboratory surveillance      │
│ • Patient/family education             │
│                                         │
│ 📈 Recovery monitoring:                 │
│ • Daily creatinine until stable        │
│ • Trend toward baseline               │
│ • Resume medications when appropriate  │
│                                         │
│ [Next: Follow-up planning ▶]           │
│                                         │
│ [◀ Previous: Risk Stratification]      │
└─────────────────────────────────────────┘

### Card 7A – Dialysis Evaluation (Node AEIOU Assessment)
┌─────────────────────────────────────────┐
│ 🔬 EMERGENT DIALYSIS CRITERIA (AEIOU)   │
├─────────────────────────────────────────┤
│ 🚨 Life-threatening indications:        │
│ • Acidosis: pH <7.2 refractory         │
│ • Electrolytes: K+ >6.5 refractory     │
│ • Intoxication: Dialyzable toxins       │
│   (methanol, ethylene glycol, lithium, │
│   salicylates, isopropanol)            │
│ • Overload: Pulmonary edema + hypoxia  │
│ • Uremia: Pericarditis, encephalopathy,│
│   bleeding diathesis                   │
│                                         │
│ ⏰ Time-sensitive decision               │
│                                         │
│ ❓ AEIOU criteria present?              │
│                                         │
│ 🔘 YES → Emergent RRT setup            │
│ 🔘 NO → Continue intensive monitoring  │
│                                         │
│ [◀ Previous] [Next: Based on Selection ▶]│
└─────────────────────────────────────────┘

### Card 7B – Intensive Monitoring (Node Enhanced Surveillance - Final)
┌─────────────────────────────────────────┐
│ 👁️  INTENSIVE MONITORING PROTOCOL       │
├─────────────────────────────────────────┤
│ 📊 Enhanced surveillance:               │
│ • Labs q6-12h until stable             │
│ • Continuous cardiac monitoring        │
│ • Hourly urine output if catheterized  │
│ • Serial arterial blood gases          │
│                                         │
│ ⚠️  Escalation triggers:                │
│ • K+ >6.0 despite treatment            │
│ • pH <7.25 or worsening               │
│ • Mental status changes               │
│ • Respiratory distress from overload   │
│                                         │
│ 📞 Immediate nephrology if deterioration│
│                                         │
│ ✅ INTENSIVE MONITORING ACTIVE         │
│                                         │
│ [◀ Previous: Dialysis Evaluation]      │
└─────────────────────────────────────────┘

### Card 8A – Emergent RRT (Node RRT Setup → Modality)
┌─────────────────────────────────────────┐
│ ⚡ EMERGENT RENAL REPLACEMENT THERAPY   │
├─────────────────────────────────────────┤
│ 🚀 Immediate actions:                   │
│ • STAT nephrology consultation         │
│ • ICU admission if unstable            │
│ • Prepare temporary vascular access     │
│ • Family communication                 │
│                                         │
│ ⚙️  Modality selection criteria:        │
│ • Hemodynamically stable → IHD         │
│ • Unstable/pressors → CRRT             │
│ • Large volume removal needed → CRRT   │
│                                         │
│ ❓ Patient hemodynamically stable?      │
│                                         │
│ 🔘 YES → Intermittent hemodialysis     │
│ 🔘 NO → Continuous RRT                 │
│                                         │
│ [◀ Previous] [Next: Based on Selection ▶]│
└─────────────────────────────────────────┘

### Card 9A – Intermittent Hemodialysis (Node IHD - Final)
┌─────────────────────────────────────────┐
│ 🩺 INTERMITTENT HEMODIALYSIS PROTOCOL   │
├─────────────────────────────────────────┤
│ ⚙️ HD parameters:                       │
│ • Duration: 3-4 hours                  │
│ • Blood flow: 300-400 mL/min           │
│ • Dialysate flow: 500-800 mL/min       │
│ • UF rate: <13 mL/kg/h (hemodynamic tolerance)│
│                                         │
│ 💊 Anticoagulation protocol:            │
│ • Standard heparin: PTT 60-80s         │
│ • Heparin-free if bleeding risk        │
│ • Regional citrate for contraindications│
│                                         │
│ 📊 Initial prescription conservative    │
│                                         │
│ ✅ INTERMITTENT HD INITIATED           │
│                                         │
│ [◀ Previous: RRT Setup]                │
└─────────────────────────────────────────┘

### Card 9B – Continuous RRT (Node CRRT - Final)
┌─────────────────────────────────────────┐
│ 🔄 CONTINUOUS RRT PROTOCOL              │
├─────────────────────────────────────────┤
│ ⚙️ CRRT parameters:                     │
│ • Blood flow: 150-200 mL/min           │
│ • Effluent rate: 25-35 mL/kg/h         │
│ • CVVHDF mode preferred                │
│ • Replacement fluid: Pre-dilution      │
│                                         │
│ 💊 Anticoagulation (regional citrate):  │
│ • Citrate infusion pre-filter          │
│ • Monitor ionized calcium q6h          │
│ • Contraindicated in liver failure     │
│                                         │
│ 🏥 ICU-level monitoring required        │
│                                         │
│ ✅ CONTINUOUS RRT INITIATED            │
│                                         │
│ [◀ Previous: RRT Setup]                │
└─────────────────────────────────────────┘

### Card 9C – Response Monitoring (Node Treatment Response - Final)
┌─────────────────────────────────────────┐
│ 📈 TREATMENT RESPONSE MONITORING        │
├─────────────────────────────────────────┤
│ 🎯 Recovery indicators:                 │
│ • Creatinine plateau/decline           │
│ • Urine output improvement             │
│ • Electrolyte normalization            │
│ • Resolution of uremic symptoms        │
│                                         │
│ 🔄 Medication management:               │
│ • Gradual reintroduction of held meds  │
│ • ACE/ARB when creatinine stable       │
│ • Adjust doses for current GFR         │
│                                         │
│ 📅 Transition planning:                 │
│ • Step-down from intensive monitoring  │
│ • Outpatient follow-up arrangement     │
│                                         │
│ ✅ RESPONSE MONITORING COMPLETE        │
│                                         │
│ [◀ Previous: Medical Optimization]     │
└─────────────────────────────────────────┘

### Card 9D – Follow-Up Planning (Node Discharge Planning - Final)
┌─────────────────────────────────────────┐
│ 📅 POST-AKI FOLLOW-UP PROTOCOL          │
├─────────────────────────────────────────┤
│ 📊 Discharge readiness criteria:        │
│ • Creatinine stable or improving       │
│ • No ongoing complications             │
│ • Medication reconciliation complete   │
│ • Patient education completed          │
│                                         │
│ 🔄 Outpatient monitoring plan:          │
│ • 1 week: Renal function check         │
│ • 3 months: CKD assessment if incomplete│
│   recovery                             │
│ • Annual: CKD screening thereafter     │
│                                         │
│ 📚 Patient education materials:         │
│ • AKI prevention strategies            │
│ • Nephrotoxin avoidance               │
│ • When to seek medical attention       │
│                                         │
│ ✅ FOLLOW-UP PROTOCOL ESTABLISHED      │
│                                         │
│ [◀ Previous: Conservative Care]        │
└─────────────────────────────────────────┘

## ENHANCED FLOWCHART WITH CALCULATOR INTEGRATION
Initial AKI Assessment  
↓  
AKI Criteria Met?  
├─ YES → Investigate AKI (Drug holds + Labs including urine electrolytes)  
│ ↓  
│ Etiology Determination  
│ ├─ CLEAR ETIOLOGY → Direct Management  
│ └─ PRERENAL vs ATN UNCLEAR → Calculators  
│ ├─ FENa Calculator  
│ └─ FEUrea Calculator  
│ ├─ Prerenal → Volume Resuscitation  
│ ├─ ATN → Supportive Care  
│ └─ Indeterminate → Clinical Judgment  
│ ↓  
│ Risk Stratification  
│ ├─ HIGH → Emergency Management → AEIOU?  
│ │ ├─ YES → RRT  
│ │ │ ├─ Stable → IHD  
│ │ │ └─ Unstable → CRRT  
│ │ └─ NO → Intensive Monitoring  
│ ├─ MODERATE → Medical Optimization → Response Monitoring  
│ └─ LOW → Conservative Care → Follow-up Planning  
└─ NO → Monitor Function
## VIRTUA VOORHEES ENHANCED INTEGRATION

### Calculator Integration Specifications
**FENa Calculator (MDCalc Integration):**
- **Automated Population:** Pull serum values from EHR
- **Real-Time Calculation:** Dynamic result display
- **Clinical Decision Support:** Interpretation guidance
- **Documentation:** Auto-populate in clinical notes

**FEUrea Calculator (Enhanced Accuracy):**
- **Preferred When:** Diuretic use, CKD, elderly patients
- **Superior Specificity:** Better discrimination than FENa
- **Clinical Context Integration:** Consider with urinalysis findings

### Enhanced Diagnostic Protocol
**Urine Studies - Comprehensive Panel:**
STANDARD URINE WORKUP FOR AKI:  
┌─────────────────────────────────────────┐  
│ 🧪 COMPREHENSIVE URINE ANALYSIS │  
├─────────────────────────────────────────┤  
│ Basic Dipstick: │  
│ - Protein, blood, glucose, ketones │  
│ - Specific gravity, pH │  
│ │  
│ Microscopy (Fresh <2h): │  
│ - RBC casts → Glomerulonephritis │  
│ - WBC casts → Acute interstitial nephritis│  
│ - Granular casts → ATN │  
│ - Hyaline casts → Normal/prerenal │  
│ │  
│ Electrolytes (if prerenal vs ATN unclear):│  
│ - Urine sodium, creatinine for FENa │  
│ - Urine BUN, creatinine for FEUrea │  
│ │  
│ Special Studies (if indicated): │  
│ - Protein:creatinine ratio │  
│ - Urine eosinophils │  
│ - Urine myoglobin │  
└─────────────────────────────────────────┘
### Clinical Decision Tree Integration
**Calculator Trigger Points:**
1. **Volume Status Unclear:** Physical exam equivocal
2. **Diuretic Use:** FEUrea more accurate than FENa
3. **Mixed Picture:** Clinical and lab findings discordant
4. **Early ATN:** May still have low FENa initially

### Quality Improvement Integration
**Process Measures:**
- Calculator utilization rate in appropriate cases
- Time from AKI recognition to etiology determination
- Accuracy of prerenal vs ATN differentiation
- Appropriate fluid management response

**Outcome Measures:**
- Reduction in inappropriate fluid administration
- Improved diagnostic accuracy
- Decreased time to appropriate therapy
- Reduced AKI progression

### System Integration Features
**EHR Calculator Embedding:**
CLINICAL DECISION SUPPORT INTEGRATION:  
┌─────────────────────────────────────────┐  
│ Smart Calculator Triggers: │  
│ - Auto-suggest when urine lytes ordered │  
│ - Pop-up when AKI + bland sediment │  
│ - Integration with order sets │  
│ │  
│ Results Interpretation: │  
│ - Color-coded results (Green/Yellow/Red)│  
│ - Automatic clinical recommendations │  
│ - Link to management protocols │  
│ │  
│ Documentation Support: │  
│ - Auto-populate assessment section │  
│ - Generate plan recommendations │  
│ - Track calculator utilization │  
└─────────────────────────────────────────┘

### Advanced Features
**Calculator Enhancements:**
- **Pediatric Adjustments:** Age-appropriate normal values
- **CKD Modifications:** Baseline-adjusted interpretations  
- **Drug Interaction Alerts:** When diuretics affect results
- **Trending Capability:** Serial calculations over time

**Clinical Context Integration:**
- **Sepsis Modifier:** Adjust thresholds in septic AKI
- **Heart Failure Integration:** Consider cardiorenal physiology
- **Medication Timeline:** Link to nephrotoxin exposure timing
- **Recovery Tracking:** Monitor trends during treatment response

## REFERENCE GUIDELINES & CALCULATOR SOURCES
- **2024 KDIGO Acute Kidney Injury Guidelines**
- **2019 AAFP Clinical Guidelines for AKI**
- **2023 KDOQI Hemodialysis Guidelines**
- **MDCalc FENa Calculator:** https://www.mdcalc.com/fractional-excretion-sodium-fena
- **MDCalc FEUrea Calculator:** https://www.mdcalc.com/fractional-excretion-urea-feurea
- **Clinical Protocol Integration (Evidence-Based Practice)**
- **Virtua Health System AKI Protocol v2024**

**This final version integrates the FENa and FEUrea calculators as dynamic, interactive cards within the clinical decision-making process, enhancing diagnostic accuracy and providing real-time clinical decision support for optimal AKI management.**
