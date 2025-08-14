# Code STEMI – ST-Elevation Myocardial Infarction with Virtua Voorhees Addenda
## Updated with 2025 ACS Guidelines & UpToDate Evidence

**Primary Guideline:** 2025 ACC/AHA/ACEP/NAEMSP/SCAI Guideline for Management of Patients with Acute Coronary Syndromes
**Official Source:** https://www.ahajournals.org/doi/10.1161/CIR.0000000000001309
**Supporting Guidelines:** 
- 2021 ACC/AHA/SCAI Coronary Revascularization Guidelines
- UpToDate STEMI Management Review 2025

## ENHANCED MERMAID FLOWCHART ALGORITHM

~~~mermaid
graph TD
    A["Chest Pain/ACS Symptoms<br/>Obtain 12-lead ECG ≤10min"] --> B{"STEMI Criteria<br/>Met?"}
    
    B -->|YES| C["Rule out STEMI Mimics<br/>Activate Code STEMI<br/>ASA + IV Access + Labs"]
    B -->|NO| D["Evaluate STEMI Equivalents<br/>NSTEACS Assessment"]
    
    C --> E["Assess Life-threatening<br/>Conditions"]
    D --> F{"Risk Level<br/>Assessment?"}
    
    E --> G{"Primary PCI Available<br/>within 120min?"}
    
    F -->|HIGH RISK| H["Urgent Catheterization<br/>within 24h"]
    F -->|LOW-INTERMEDIATE| I["Conservative/Selective<br/>Management"]
    
    G -->|YES| J["Primary PCI Preparation<br/>DAPT + UFH"]
    G -->|NO| K["Fibrinolytic Screening<br/>Contraindications Check"]
    
    J --> L["Cath Lab Procedure<br/>Door-to-Balloon <90min"]
    
    K --> M{"Fibrinolytic<br/>Contraindications?"}
    M -->|NO| N["TNK Administration<br/>0.25mg/kg bolus"]
    M -->|YES| O["Transfer for Rescue PCI<br/>Call 856-886-5111"]
    
    L --> P["Monitor Reperfusion<br/>ST Resolution Assessment"]
    N --> P
    O --> P
    H --> P
    I --> P
    
    P --> Q{"Reperfusion<br/>Success?"}
    
    Q -->|SUCCESS| R["Post-STEMI Care<br/>GDMT + Discharge Planning"]
    Q -->|FAILED| S["Rescue Intervention<br/>Emergency PCI"]
    Q -->|SHOCK| T["MCS Consideration<br/>IABP/Impella/ECMO"]
    
    style A fill:#ffcccc
    style C fill:#ffe6cc
    style J fill:#fff2cc
    style L fill:#ccffcc
    style N fill:#e6ccff
    style R fill:#ccffee
~~~

## STREAMLINED DYNAMIC CARD SYSTEM - 2025 UPDATED

### Card 0 – Initial Assessment & ECG (Node A → B)
┌─────────────────────────────────────────┐
│ 🫀 ACUTE CHEST PAIN ASSESSMENT          │
├─────────────────────────────────────────┤
│ ⏱️ CRITICAL TIMING:                     │
│ • 12-lead ECG within 10 minutes        │
│ • Repeat q15-30min if initial non-diagnostic│
│                                         │
│ 📊 STEMI CRITERIA (2025 Updated):       │
│ • ≥1mm ST elevation, ≥2 contiguous leads│
│ • V2-V3 criteria (age/sex specific):   │
│   - Males ≥40y: ≥2mm                   │
│   - Males <40y: ≥2.5mm                 │
│   - Females: ≥1.5mm                    │
│ • New LBBB with clinical correlation   │
│                                         │
│ ❓ STEMI criteria met?                  │
│                                         │
│ 🔘 YES → Rule out mimics & activate    │
│ 🔘 NO → STEMI equivalents assessment   │
│                                         │
│ [Next: Based on Selection ▶]            │
└─────────────────────────────────────────┘

### Card 1A – STEMI Activation & Mimic Assessment (Node C → E)
┌─────────────────────────────────────────┐
│ 🚨 CODE STEMI ACTIVATION                │
├─────────────────────────────────────────┤
│ 🚀 Immediate actions (<10 minutes):     │
│ • ASA 162-325mg chewed                 │
│ • IV access × 2 (18G)                  │
│ • Labs: CBC, BMP, PT/INR, troponin     │
│ • Call 856-886-5111 (Transfer Center)  │
│                                         │
│ ⚠️ STEMI mimics to exclude:             │
│ • Pericarditis (diffuse, PR depression)│
│ • Early repolarization (young, athletic)│
│ • LVH with strain pattern              │
│ • Takotsubo cardiomyopathy             │
│                                         │
│ [Next: Life-threatening assessment ▶]   │
│                                         │
│ [◀ Previous: Initial Assessment]       │
└─────────────────────────────────────────┘

### Card 1B – STEMI Equivalents & NSTEACS (Node D → F)
┌─────────────────────────────────────────┐
│ 🔍 STEMI EQUIVALENTS & NSTEACS          │
├─────────────────────────────────────────┤
│ 🎯 High-risk equivalent patterns:       │
│ • De Winter sign (ST depression + hyperacute T)│
│ • Posterior STEMI (ST depression V1-V3)│
│ • Wellens sign (biphasic T waves V2-V3)│
│ • Hyperacute T waves                   │
│ • New LBBB with Sgarbossa criteria     │
│                                         │
│ 📊 NSTEACS features:                    │
│ • ST depression ≥0.5mm (≥2 contiguous) │
│ • T wave inversion ≥1mm with R wave    │
│ • Positive cardiac biomarkers          │
│                                         │
│ [Next: Risk stratification ▶]          │
│                                         │
│ [◀ Previous: Initial Assessment]       │
└─────────────────────────────────────────┘

### Card 2A – Life-Threatening Assessment (Node E → G)
┌─────────────────────────────────────────┐
│ ⚠️ LIFE-THREATENING CONDITIONS          │
├─────────────────────────────────────────┤
│ 🔍 Evaluate immediately:                │
│ • Cardiogenic shock (cool extremities, │
│   JVD, hypotension)                    │
│ • Acute heart failure (orthopnea,      │
│   pulmonary edema)                     │
│ • Aortic dissection (tearing pain,     │
│   pulse deficits, new murmur)          │
│ • Ventricular arrhythmias              │
│                                         │
│ 💊 Contraindications assessment:        │
│ • Bleeding risk, anticoagulant use     │
│ • Recent surgery, trauma              │
│ • Coagulopathy, thrombocytopenia       │
│                                         │
│ [Next: PCI availability decision ▶]    │
│                                         │
│ [◀ Previous: STEMI Activation]         │
└─────────────────────────────────────────┘

### Card 2B – Risk Stratification (Node F)
┌─────────────────────────────────────────┐
│ 📊 NSTEACS RISK ASSESSMENT              │
├─────────────────────────────────────────┤
│ 🚨 High-risk features:                  │
│ • Recurrent ischemic symptoms          │
│ • Dynamic ECG changes                  │
│ • Hemodynamic instability              │
│ • Sustained VT/VF                      │
│ • Elevated troponin levels             │
│                                         │
│ 📋 Risk scores (use clinical judgment): │
│ • GRACE score for 6-month risk         │
│ • TIMI risk score for events           │
│                                         │
│ ❓ Risk level determined?               │
│                                         │
│ 🔘 HIGH → Urgent cath within 24h       │
│ 🔘 LOW-INTERMEDIATE → Conservative mgmt │
│                                         │
│ [◀ Previous] [Next: Based on Selection ▶]│
└─────────────────────────────────────────┘

### Card 3A – PCI Availability Decision (Node G)
┌─────────────────────────────────────────┐
│ ⏱️ PRIMARY PCI AVAILABILITY             │
├─────────────────────────────────────────┤
│ 🎯 Time-critical decision points:       │
│ • Door-to-balloon <90min (on-site PCI) │
│ • First medical contact to device       │
│   <120min (transfer required)          │
│ • Consider patient factors: age, comorbidities│
│                                         │
│ 📞 Transfer coordination:               │
│ • Call 856-886-5111 immediately        │
│ • Direct communication with PCI center │
│ • Expedited transport arrangements     │
│                                         │
│ ❓ Primary PCI achievable <120min?      │
│                                         │
│ 🔘 YES → Primary PCI preparation       │
│ 🔘 NO → Fibrinolytic evaluation        │
│                                         │
│ [◀ Previous] [Next: Based on Selection ▶]│
└─────────────────────────────────────────┘

### Card 4A – Primary PCI Preparation (Node J → L)
┌─────────────────────────────────────────┐
│ 🏥 PRIMARY PCI PREPARATION              │
├─────────────────────────────────────────┤
│ 💊 Dual antiplatelet therapy:           │
│ • Ticagrelor 180mg load (preferred)    │
│ • Prasugrel 60mg load (avoid if:       │
│   age ≥75y, <60kg, stroke history)     │
│ • Clopidogrel 600mg load (high bleed risk)│
│                                         │
│ 🩸 Anticoagulation:                     │
│ • UFH 70-100 units/kg bolus            │
│   (max 10,000 units, no GP IIb/IIIa)  │
│ • UFH 50-70 units/kg bolus             │
│   (max 7,000 units, with GP IIb/IIIa)  │
│ • Bivalirudin if HIT history            │
│                                         │
│ [Next: Cath lab procedure ▶]           │
│                                         │
│ [◀ Previous: PCI Availability]         │
└─────────────────────────────────────────┘

### Card 4B – Fibrinolytic Screening (Node K → M)
┌─────────────────────────────────────────┐
│ 💉 FIBRINOLYTIC THERAPY SCREENING       │
├─────────────────────────────────────────┤
│ ✅ Inclusion criteria:                  │
│ • Symptom onset <12 hours              │
│ • STEMI with no access to PCI <120min  │
│ • Age ≥18 years                        │
│                                         │
│ 🚫 Major contraindications:             │
│ • History of intracranial hemorrhage   │
│ • Ischemic stroke <3 months            │
│ • Active bleeding or bleeding disorder │
│ • Aortic dissection suspected          │
│ • Significant trauma <3 months         │
│                                         │
│ [Next: Contraindication assessment ▶]   │
│                                         │
│ [◀ Previous: PCI Availability]         │
└─────────────────────────────────────────┘

### Card 5A – Urgent Catheterization (Node H - Final)
┌─────────────────────────────────────────┐
│ 🚨 URGENT CATHETERIZATION <24H          │
├─────────────────────────────────────────┤
│ 🎯 High-risk NSTEACS management:        │
│ • Early invasive strategy indicated    │
│ • DAPT + anticoagulation optimization  │
│ • Hemodynamic monitoring               │
│ • Prepare for possible PCI             │
│                                         │
│ 💊 Medical therapy during wait:         │
│ • Continue dual antiplatelet therapy   │
│ • UFH or enoxaparin anticoagulation    │
│ • Beta blocker if no contraindications │
│                                         │
│ ✅ URGENT CATHETERIZATION PROTOCOL ACTIVE│
│                                         │
│ [◀ Previous: Risk Stratification]      │
└─────────────────────────────────────────┘

### Card 5B – Conservative Management (Node I - Final)
┌─────────────────────────────────────────┐
│ 🛡️ CONSERVATIVE MANAGEMENT              │
├─────────────────────────────────────────┤
│ 💊 Medical therapy optimization:        │
│ • Dual antiplatelet: ASA + P2Y12       │
│ • Anticoagulation: UFH, enoxaparin,    │
│   or fondaparinux                      │
│ • Beta blocker (if no contraindications)│
│ • High-intensity statin                │
│                                         │
│ 📊 Monitoring strategy:                 │
│ • Serial cardiac biomarkers           │
│ • Continuous telemetry monitoring      │
│ • Consider selective angiography       │
│   if symptoms recur                    │
│                                         │
│ ✅ CONSERVATIVE PROTOCOL ACTIVE        │
│                                         │
│ [◀ Previous: Risk Stratification]      │
└─────────────────────────────────────────┘

### Card 6A – Cath Lab Procedure (Node L → P)
┌─────────────────────────────────────────┐
│ 🏥 CARDIAC CATHETERIZATION              │
├─────────────────────────────────────────┤
│ 🎯 Procedure goals:                     │
│ • Identify culprit vessel              │
│ • Achieve TIMI 3 flow                 │
│ • Address culprit lesion first         │
│ • Consider multivessel intervention    │
│   if cardiogenic shock                 │
│                                         │
│ ⏱️ Time targets:                        │
│ • Door-to-balloon <90 minutes          │
│ • Minimize procedural delays           │
│                                         │
│ 🔧 Consider mechanical support:         │
│ • IABP for cardiogenic shock           │
│ • Impella for severe LV dysfunction    │
│                                         │
│ [Next: Reperfusion monitoring ▶]       │
│                                         │
│ [◀ Previous: PCI Preparation]          │
└─────────────────────────────────────────┘

### Card 6B – Contraindication Assessment (Node M)
┌─────────────────────────────────────────┐
│ 🔍 FIBRINOLYTIC CONTRAINDICATIONS       │
├─────────────────────────────────────────┤
│ 📋 Systematic evaluation:               │
│ • Complete bleeding history            │
│ • Recent procedures/surgeries          │
│ • Current medications (anticoagulants) │
│ • Age considerations (>75y relative CI)│
│                                         │
│ ⚖️ Risk-benefit analysis:               │
│ • Severity of STEMI presentation       │
│ • Time from symptom onset             │
│ • Availability of alternative therapy  │
│                                         │
│ ❓ Contraindications present?           │
│                                         │
│ 🔘 NO → Administer TNK                │
│ 🔘 YES → Rescue PCI transfer          │
│                                         │
│ [◀ Previous] [Next: Based on Selection ▶]│
└─────────────────────────────────────────┘

### Card 7A – TNK Administration (Node N → P)
┌─────────────────────────────────────────┐
│ 💉 TENECTEPLASE ADMINISTRATION          │
├─────────────────────────────────────────┤
│ 💊 TNK protocol (weight-based):         │
│ • Dose: 0.25mg/kg IV bolus (max 25mg)  │
│ • Single push over 5 seconds           │
│ • Dedicated IV line, flush after       │
│                                         │
│ 🩸 Adjunctive therapy:                  │
│ • UFH: 60 units/kg bolus               │
│   → 12 units/kg/hr infusion            │
│ • Clopidogrel 300mg if age <75y        │
│   75mg if age ≥75y                     │
│                                         │
│ 🚫 Avoid for 24 hours:                 │
│ • Additional anticoagulants/antiplatelets│
│ • Arterial punctures                   │
│                                         │
│ [Next: Reperfusion monitoring ▶]       │
│                                         │
│ [◀ Previous: Contraindication Check]   │
└─────────────────────────────────────────┘

### Card 7B – Rescue PCI Transfer (Node O → P)
┌─────────────────────────────────────────┐
│ 🚁 RESCUE PCI TRANSFER                 │
├─────────────────────────────────────────┐
│ 📞 Immediate coordination:              │
│ • Call 856-886-5111 (Transfer Center)  │
│ • Direct communication with PCI center │
│ • Expedited transport (air if >30min)  │
│                                         │
│ 💊 Continue medical therapy:            │
│ • Maintain antiplatelet therapy        │
│ • UFH anticoagulation                  │
│ • Supportive care during transport     │
│                                         │
│ 🎯 Target: Emergency PCI capability     │
│                                         │
│ [Next: Reperfusion monitoring ▶]       │
│                                         │
│ [◀ Previous: Contraindication Check]   │
└─────────────────────────────────────────┘

### Card 8 – Reperfusion Monitoring (Node P → Q)
┌─────────────────────────────────────────┐
│ 📈 REPERFUSION SUCCESS MONITORING       │
├─────────────────────────────────────────┤
│ 🎯 Success indicators (assess at 90min): │
│ • ST segment resolution >50%           │
│ • Complete resolution of chest pain    │
│ • Hemodynamic stability               │
│ • No new arrhythmias                  │
│                                         │
│ ⚠️ Failure indicators:                  │
│ • <30% ST resolution at 90 minutes     │
│ • Persistent/worsening chest pain      │
│ • Hemodynamic deterioration           │
│ • New mechanical complications         │
│                                         │
│ 🔍 Additional monitoring:               │
│ • Continuous telemetry                │
│ • Serial 12-lead ECGs                 │
│ • Cardiac biomarker trending          │
│                                         │
│ ❓ Reperfusion successful?              │
│                                         │
│ 🔘 SUCCESS → Post-STEMI care          │
│ 🔘 FAILED → Rescue intervention       │
│ 🔘 SHOCK → MCS consideration          │
│                                         │
│ [◀ Previous] [Next: Based on Selection ▶]│
└─────────────────────────────────────────┘

### Card 9A – Post-STEMI Care (Node R - Final)
┌─────────────────────────────────────────┐
│ 🏥 POST-STEMI OPTIMIZATION              │
├─────────────────────────────────────────┤
│ 💊 Guideline-directed medical therapy:  │
│ • DAPT: ASA + P2Y12 inhibitor          │
│ • Beta blocker (unless contraindicated)│
│ • ACE inhibitor or ARB                 │
│ • High-intensity statin (atorvastatin 80mg)│
│                                         │
│ 📊 Monitoring & assessment:             │
│ • Echocardiogram for EF assessment     │
│ • Lipid panel, HbA1c if diabetic      │
│ • Assessment for mechanical complications│
│                                         │
│ 🔄 Discharge planning:                  │
│ • Cardiac rehabilitation referral      │
│ • Follow-up appointments (1-2 weeks)   │
│ • Patient education and lifestyle mods │
│                                         │
│ ✅ POST-STEMI PROTOCOL COMPLETE        │
│                                         │
│ [◀ Previous: Success Monitoring]       │
└─────────────────────────────────────────┘

### Card 9B – Rescue Intervention (Node S - Final)
┌─────────────────────────────────────────┐
│ 🚨 RESCUE INTERVENTION                  │
├─────────────────────────────────────────┤
│ ⚠️ Failed reperfusion management:       │
│ • Emergency cardiac catheterization    │
│ • Consider rescue PCI if post-fibrinolytic│
│ • Mechanical thrombectomy if indicated │
│ • Address complications aggressively   │
│                                         │
│ 🏥 Intensive monitoring:                │
│ • ICU-level care                       │
│ • Hemodynamic monitoring               │
│ • Serial ECGs and biomarkers           │
│                                         │
│ 📞 Multidisciplinary team approach:     │
│ • Interventional cardiology           │
│ • Critical care medicine              │
│ • Cardiac surgery if needed           │
│                                         │
│ ✅ RESCUE PROTOCOL ACTIVE              │
│                                         │
│ [◀ Previous: Success Monitoring]       │
└─────────────────────────────────────────┘

### Card 9C – Mechanical Circulatory Support (Node T - Final)
┌─────────────────────────────────────────┐
│ 💓 MECHANICAL CIRCULATORY SUPPORT       │
├─────────────────────────────────────────┤
│ 🚨 Cardiogenic shock indications:       │
│ • SBP <90 mmHg despite volume          │
│ • Cardiac index <2.2 L/min/m²         │
│ • Pulmonary capillary wedge >18 mmHg   │
│ • End-organ hypoperfusion              │
│                                         │
│ 🛡️ MCS device options:                  │
│ • IABP: First-line for most patients   │
│ • Impella CP/5.0: Severe LV failure    │
│ • VA-ECMO: Refractory cardiogenic shock │
│ • Consider heart team consultation     │
│                                         │
│ 📊 Monitoring requirements:             │
│ • Invasive hemodynamic monitoring      │
│ • Frequent assessment of organ function│
│ • Anticoagulation management          │
│                                         │
│ ✅ MCS PROTOCOL ACTIVE                 │
│                                         │
│ [◀ Previous: Success Monitoring]       │
└─────────────────────────────────────────┘

## VIRTUA VOORHEES ENHANCED PROTOCOL ADDENDA

### **2025 Guideline Updates Integrated:**
- **Updated STEMI Criteria:** Age and sex-specific thresholds for V2-V3 leads
- **Time-Critical Metrics:** ECG within 10 minutes, door-to-balloon <90 minutes
- **Enhanced Risk Assessment:** Systematic evaluation for life-threatening conditions
- **Antiplatelet Optimization:** Ticagrelor preferred, prasugrel with specific exclusions
- **Transfer Protocols:** 120-minute first medical contact to device time

### **Critical Contact Information:**
- **STEMI Transfer Center:** 856-886-5111 (24/7 immediate response)
- **Emergency Activation:** Direct cath lab hot line
- **Air Medical Transport:** Weather permitting, >30-minute ground transport time

### **Enhanced Quality Metrics:**
- **Door-to-ECG:** <10 minutes (target: 5 minutes)
- **Door-to-Balloon (Primary PCI):** <90 minutes (target: 60 minutes)
- **First Medical Contact to Device:** <120 minutes (transfer cases)
- **Reperfusion Success Rate:** >95% TIMI 3 flow achievement

### **Medication Protocols - Evidence Based:**
**Immediate Actions:**
- **Aspirin:** 162-325mg chewed (unless anaphylaxis/aortic dissection)
- **Beta Blockers:** Oral within 24 hours (avoid if shock/heart failure)
- **Statins:** High-intensity (atorvastatin 80mg) within 24 hours

**Advanced Therapies:**
- **P2Y12 Inhibitor Selection:** Based on bleeding risk, age, weight
- **Anticoagulation:** UFH preferred for PCI, consider bivalirudin if HIT
- **Fibrinolytic Choice:** TNK preferred over alteplase (single bolus)

### **Special Population Considerations:**
- **COVID-19 Patients:** Standard STEMI care with appropriate PPE
- **Pregnancy:** Avoid fibrinolytics, prefer PCI with radiation protection
- **Elderly (≥75y):** Careful bleeding risk assessment, prefer clopidogrel
- **Cardiogenic Shock:** Immediate PCI regardless of symptom duration

### **System Integration Features:**
- **Real-time Decision Support:** Automated contraindication checking
- **Quality Dashboard:** Live D2B time monitoring and alerts
- **Mobile Alerts:** Push notifications for time-critical milestones
- **Documentation:** Automated protocol adherence tracking

### **Complications Management:**
- **Mechanical Complications:** Emergency surgical consultation
- **No-Reflow Phenomenon:** Intracoronary vasodilators, thrombectomy
- **Contrast-Induced Nephropathy:** Pre-hydration, minimize contrast volume
- **Bleeding Complications:** Rapid reversal protocols available

## REFERENCE GUIDELINES & EVIDENCE BASE
- **2025 ACC/AHA/ACEP/NAEMSP/SCAI ACS Guidelines**
- **2021 ACC/AHA/SCAI Coronary Revascularization Guidelines** 
- **UpToDate STEMI Management Review - Updated April 2025**
- **Virtua Health System STEMI Protocol v2025**

**This comprehensive protocol reflects the latest evidence-based approach to STEMI management, optimized for rapid recognition, appropriate reperfusion strategy selection, and excellent patient outcomes at Virtua Voorhees.**
