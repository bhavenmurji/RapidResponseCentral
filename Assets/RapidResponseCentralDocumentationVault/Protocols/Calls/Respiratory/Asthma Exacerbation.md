# Enhanced Asthma Exacerbation – Interactive Clinical Protocol

**Primary Guidelines:**
- Global Initiative for Asthma (GINA) 2025 Strategy Report[1][5][9]
- UpToDate: Acute Exacerbations of Asthma in Adults 2025
- NHLBI Asthma Care Quick Reference 2025[4]
- American Academy of Family Physicians Asthma Guidelines 2025

**Official Sources:**
- GINA 2025: https://ginasthma.org/2025-gina-strategy-report/
- UpToDate Clinical Decision Support: Asthma Exacerbation Management

## ENHANCED ASTHMA EXACERBATION MERMAID ALGORITHM

~~~mermaid
graph TD
    A["🫁 Acute Asthma Exacerbation<br/>Recognition + Rapid Triage"] --> B["📊 UpToDate Severity Assessment<br/>Clinical + PEFR + SpO2"]
    
    B --> C{"⚖️ Exacerbation<br/>Severity Level?"}
    
    C -->|MILD| D["🟢 Mild Protocol<br/>PEFR ≥70%, Sentences, SpO2 >95%"]
    C -->|MODERATE| E["🟡 Moderate Protocol<br/>PEFR 40-69%, Phrases, SpO2 91-95%"]
    C -->|SEVERE| F["🔴 Severe Protocol<br/>PEFR <40%, Words Only, SpO2 <91%"]
    C -->|LIFE-THREATENING| G["🚨 Critical Protocol<br/>Silent Chest, Cyanosis, Exhaustion"]
    
    D --> H["💨 GINA 2025 AIR Therapy<br/>ICS-Formoterol Preferred"]
    E --> I["💊 Standard Treatment Triad<br/>SABA + Ipratropium + Steroids"]
    F --> J["🏥 Intensive Protocol<br/>Continuous Nebs + Magnesium"]
    G --> K["🚨 Critical Care<br/>ICU + Intubation Ready"]
    
    H --> L["⏱️ Reassess 1h<br/>PEFR + Clinical Response"]
    I --> M["⏱️ Reassess 1h<br/>Standard Monitoring"]
    J --> N["⏱️ Continuous Monitor<br/>Q15min Assessment"]
    K --> O["🏥 ICU Management<br/>Advanced Life Support"]
    
    L --> P{"📈 Response<br/>Adequate?"}
    M --> Q{"📈 Treatment<br/>Response?"}
    N --> R{"🎯 Critical<br/>Improvement?"}
    
    P -->|GOOD| S["✅ Continue AIR<br/>Discharge Planning"]
    P -->|POOR| T["⬆️ Escalate Protocol<br/>Add Systemic Steroids"]
    Q -->|GOOD| U["✅ Continue Treatment<br/>Transition Planning"]
    Q -->|PARTIAL| V["⬆️ Increase Frequency<br/>Add Magnesium"]
    Q -->|POOR| W["🚨 Escalate to Severe<br/>Continuous Treatment"]
    R -->|YES| U
    R -->|NO| O
    
    T --> M
    V --> N
    W --> N
    S --> X{"🏠 Discharge<br/>Criteria Met?"}
    U --> X
    
    X -->|YES| Y["📋 GINA 2025 Discharge<br/>AIR + Action Plan"]
    X -->|NO| Z["🏥 Admit for Observation<br/>Extended Monitoring"]
    
    Y --> AA["✅ Home with Support<br/>Follow-up Arranged"]
    Z --> BB["📊 Inpatient Optimization<br/>Specialist Consultation"]
    O --> BB
    
    AA --> CC["✅ Asthma Protocol<br/>Complete"]
    BB --> CC
    
    style A fill:#ffcccc
    style F fill:#ffaaaa
    style G fill:#ff6666
    style J fill:#ff8888
    style K fill:#ff4444
    style O fill:#ff6666
    style Y fill:#ccffcc
    style CC fill:#ccffee
~~~

## ASTHMA DYNAMIC CARD SYSTEM

### Card 0 – Initial Assessment & Triage (Node A → B)
┌─────────────────────────────────────────┐
│ 🫁 ASTHMA EXACERBATION RECOGNITION      │
├─────────────────────────────────────────┤
│ **Immediate Recognition Criteria**:     │
│ -  **Acute dyspnea**: Worsening from baseline│
│ -  **Wheeze**: Audible with/without stethoscope│
│ -  **Cough**: Dry or productive        │
│ -  **Chest tightness**: Patient-reported sensation│
│ -  **Activity limitation**: Unable to perform usual tasks│
│                                         │
│ **High-Risk Historical Factors**:       │
│ -  **Previous ICU/intubation**: For asthma│
│ -  **≥3 ED visits**: In past year       │
│ -  **Recent hospitalization**: Within 12 months│
│ -  **Current steroid use**: Oral prednisolone│
│ -  **Poor adherence**: Controller medications│
│ -  **Food allergies**: Especially nuts  │
│                                         │
│ **Vital Sign Priorities**:             │
│ -  **Respiratory rate**: Baseline assessment│
│ -  **Heart rate**: Tachycardia common   │
│ -  **Blood pressure**: Pulsus paradoxus >15mmHg│
│ -  **SpO2**: Continuous monitoring      │
│ -  **Peak flow**: If patient able       │
│                                         │
│ **Differential Considerations**:        │
│ -  **Anaphylaxis**: Acute onset, systemic│
│ -  **Pneumothorax**: Sudden chest pain  │
│ -  **Pneumonia**: Fever, consolidation  │
│ -  **Foreign body**: Especially children│
│                                         │
│ [Next: Severity classification ▶]      │
└─────────────────────────────────────────┘

### Card 1A – UpToDate Severity Assessment (Node B → C)
┌─────────────────────────────────────────┐
│ 📊 UPTODATE ASTHMA SEVERITY CLASSIFICATION│
├─────────────────────────────────────────┤
│ **Mild Exacerbation**:                 │
│ -  **Breathlessness**: While walking    │
│ -  **Position**: Can lie down           │
│ -  **Speech**: Complete sentences       │
│ -  **PEFR**: ≥70% predicted/personal best│
│ -  **SpO2**: >95% room air              │
│ -  **Heart rate**: <100 bpm             │
│ -  **Wheeze**: Moderate, end-expiratory │
│                                         │
│ **Moderate Exacerbation**:             │
│ -  **Breathlessness**: At rest, prefers sitting│
│ -  **Speech**: Phrases only             │
│ -  **PEFR**: 40-69% predicted           │
│ -  **SpO2**: 90-95%                     │
│ -  **Heart rate**: 100-120 bpm          │
│ -  **Accessory muscles**: Commonly present│
│ -  **Wheeze**: Loud throughout exhalation│
│                                         │
│ **Severe Exacerbation**:               │
│ -  **Breathlessness**: At rest, sits upright│
│ -  **Speech**: Words only               │
│ -  **PEFR**: <40% predicted             │
│ -  **SpO2**: <90%                       │
│ -  **Heart rate**: >120 bpm             │
│ -  **Accessory muscles**: Throughout breathing│
│ -  **Wheeze**: Loud inspiration + expiration│
│                                         │
│ **Life-Threatening**:                  │
│ -  **Silent chest**: Minimal air movement│
│ -  **Cyanosis**: Central or peripheral  │
│ -  **Exhaustion**: Poor respiratory effort│
│ -  **Altered consciousness**: Confusion │
│ -  **Arrhythmias**: Brady/tachycardia   │
│                                         │
│ [Next: Severity-specific treatment ▶]  │
└─────────────────────────────────────────┘

### Card 2A – GINA 2025 AIR Therapy (Node H → L)
┌─────────────────────────────────────────┐
│ 💨 GINA 2025 AIR THERAPY PROTOCOL        │
├─────────────────────────────────────────┤
│ **Anti-Inflammatory Reliever 2025[1][5]**:│
│ -  **Preferred**: ICS-formoterol combination│
│ -  **Budesonide-formoterol**: 100/6 mcg │
│ -  **Dose**: 1-2 puffs every 20min × 3  │
│ -  **Maximum**: 8-12 puffs in 24h       │
│                                         │
│ **Alternative Track 2 Approach[8]**:    │
│ -  **ICS + SABA**: Take together        │
│ -  **Timing**: ICS immediately after SABA│
│ -  **Rationale**: Prevents SABA-only risk[14]│
│                                         │
│ **Oxygen Support**:                     │
│ -  **Target SpO2**: ≥92% (≥94% pregnancy)│
│ -  **Delivery**: Nasal cannula 2-4L/min │
│ -  **Monitor**: Continuous pulse oximetry│
│                                         │
│ **Patient Positioning**:                │
│ -  **Preferred**: Sitting upright       │
│ -  **Avoid**: Forcing supine position   │
│ -  **Support**: Pillow table for comfort│
│                                         │
│ **Response Timeline**:                  │
│ -  **Onset**: 15-30 minutes expected    │
│ -  **Peak effect**: 60-90 minutes       │
│ -  **Reassessment**: At 1 hour mandatory│
│                                         │
│ **Monitoring Parameters**:              │
│ -  **PEFR**: Before/after treatment     │
│ -  **Speech ability**: Sentence completion│
│ -  **Respiratory rate**: Trend analysis │
│ -  **Patient comfort**: Subjective assessment│
│                                         │
│ [Next: 1-hour evaluation ▶]            │
└─────────────────────────────────────────┘

### Card 2B – Standard Treatment Triad (Node I → M)
┌─────────────────────────────────────────┐
│ 💊 MODERATE ASTHMA STANDARD PROTOCOL     │
├─────────────────────────────────────────┤
│ **Bronchodilator Protocol[4][9]**:      │
│ -  **Albuterol**: 2.5-5mg nebulized q20min × 3│
│ -  **Alternative**: 4-8 puffs MDI + spacer│
│ -  **Ipratropium**: 0.5mg with each albuterol│
│ -  **Synergistic effect**: Dual mechanism│
│                                         │
│ **Systemic Corticosteroids[4][9]**:     │
│ -  **Oral preferred**: Prednisolone 40-60mg│
│ -  **IV option**: Methylprednisolone 60-125mg│
│ -  **Timing**: Give early, don't delay  │
│ -  **Onset**: 4-6 hours for effect      │
│                                         │
│ **Oxygen Therapy**:                     │
│ -  **Indication**: SpO2 <92%            │
│ -  **Target**: ≥92% (≥95% pregnancy)    │
│ -  **Method**: Nasal cannula or face mask│
│                                         │
│ **Enhanced Monitoring**:                │
│ -  **Continuous**: SpO2, cardiac rhythm │
│ -  **Q30min**: PEFR, vital signs        │
│ -  **Hourly**: Clinical assessment      │
│ -  **Document**: Treatment response     │
│                                         │
│ **Success Indicators**:                 │
│ -  **PEFR**: >70% predicted after 1h    │
│ -  **Speech**: Full sentences          │
│ -  **SpO2**: >92% stable              │
│ -  **Comfort**: Patient-reported improvement│
│                                         │
│ **Escalation Triggers**:                │
│ -  **No improvement**: After 1 hour     │
│ -  **Deterioration**: Any parameter     │
│ -  **Patient exhaustion**: Increased work of breathing│
│                                         │
│ [Next: Response-based decision ▶]      │
└─────────────────────────────────────────┘

### Card 2C – Severe Asthma Intensive Protocol (Node J → N)
┌─────────────────────────────────────────┐
│ 🔴 SEVERE ASTHMA INTENSIVE MANAGEMENT    │
├─────────────────────────────────────────┤
│ **High-Intensity Bronchodilators[9]**:  │
│ -  **Continuous albuterol**: 10-15mg/hr nebulized│
│ -  **Ipratropium**: 0.5mg q20min × 3, then q4h│
│ -  **High-frequency MDI**: 8 puffs q20min│
│                                         │
│ **IV Corticosteroids[9]**:              │
│ -  **Loading**: Methylprednisolone 125mg IV│
│ -  **Maintenance**: 60-125mg IV q6h     │
│ -  **High-dose option**: Up to 2mg/kg/day│
│                                         │
│ **Magnesium Sulfate[9]**:               │
│ -  **Dose**: 2g IV over 20 minutes      │
│ -  **Indication**: Life-threatening or unresponsive after 1h│
│ -  **Monitoring**: Blood pressure, respiratory effort│
│ -  **Mechanism**: Smooth muscle relaxation│
│                                         │
│ **Advanced Oxygen Support**:            │
│ -  **High-flow oxygen**: 15L non-rebreather│
│ -  **Target SpO2**: ≥92%                 │
│ -  **Consider HeliOx**: If available     │
│                                         │
│ **Intensive Monitoring**:               │
│ -  **Q15min**: All vital signs, PEFR    │
│ -  **Continuous**: SpO2, cardiac monitor│
│ -  **ABG consideration**: If poor response│
│ -  **Fluid balance**: IV access, hydration│
│                                         │
│ **Adjunctive Therapies[19]**:           │
│ -  **Epinephrine**: If anaphylaxis suspected│
│ -  **Terbutaline**: 0.25mg SC if MDI/nebulizer impossible│
│ -  **Ketamine**: 0.1-2mg/kg bolus for severe cases│
│                                         │
│ [Next: Critical care evaluation ▶]     │
└─────────────────────────────────────────┘

### Card 3A – Response Assessment (Node P/Q → X)
┌─────────────────────────────────────────┐
│ 📈 SYSTEMATIC RESPONSE EVALUATION        │
├─────────────────────────────────────────┤
│ **Good Response Criteria[9]**:          │
│ -  **PEFR**: >70% predicted sustained    │
│ -  **Speech**: Complete sentences        │
│ -  **SpO2**: >92% on room air ≥1 hour    │
│ -  **Respiratory rate**: <25/min         │
│ -  **Heart rate**: <100 bpm              │
│ -  **Wheeze**: Minimal or absent         │
│                                         │
│ **Partial Response**:                   │
│ -  **PEFR**: 40-70% with some improvement│
│ -  **Speech**: Phrases, still dyspneic   │
│ -  **SpO2**: 90-95% stable              │
│ -  **Some improvement**: But incomplete   │
│                                         │
│ **Poor Response**:                      │
│ -  **PEFR**: <40% or declining          │
│ -  **Speech**: Words only or worse       │
│ -  **SpO2**: <90% despite oxygen        │
│ -  **Exhaustion**: Increasing fatigue    │
│ -  **Silent chest**: Decreasing air movement│
│                                         │
│ **Escalation Strategies[9]**:           │
│ -  **Increase frequency**: Q15min treatments│
│ -  **Add magnesium**: 2g IV if severe   │
│ -  **Continuous nebs**: For poor response│
│ -  **ICU consultation**: Critical care   │
│                                         │
│ **Documentation Requirements**:         │
│ -  **Response timeline**: Each assessment│
│ -  **Peak flows**: Before/after treatment│
│ -  **Medication doses**: Total amounts   │
│ -  **Decision rationale**: For escalation│
│                                         │
│ [Next: Disposition planning ▶]         │
└─────────────────────────────────────────┘

### Card 4 – GINA 2025 Discharge Protocol (Node Y → AA)
┌─────────────────────────────────────────┐
│ 📋 GINA 2025 ENHANCED DISCHARGE PLANNING │
├─────────────────────────────────────────┤
│ **Discharge Readiness Criteria[9]**:    │
│ -  **PEFR**: >70% predicted ×2h sustained│
│ -  **SpO2**: >92% room air ×1h stable    │
│ -  **Clinical**: Sentences, minimal wheeze│
│ -  **Mobility**: Can walk without distress│
│ -  **Inhaler technique**: Demonstrated correctly│
│                                         │
│ **GINA 2025 Medication Strategy[1][6]**: │
│ -  **Preferred**: ICS-formoterol MART approach│
│ -  **Maintenance**: Same inhaler BID     │
│ -  **Reliever**: Same inhaler PRN        │
│ -  **Step-up**: From triggering level    │
│                                         │
│ **Oral Corticosteroid Course[4][9]**:   │
│ -  **Prednisolone**: 40-50mg daily       │
│ -  **Duration**: 5-7 days               │
│ -  **No taper**: Required for short course│
│ -  **Education**: Take with food, complete course│
│                                         │
│ **Asthma Action Plan Requirements[9]**:  │
│ -  **Green zone**: Well-controlled, continue maintenance│
│ -  **Yellow zone**: Worsening symptoms, increase treatment│
│ -  **Red zone**: Severe symptoms, seek urgent care│
│ -  **Personalized**: Based on patient's triggers│
│                                         │
│ **Follow-up Coordination**:             │
│ -  **Primary care**: 48-72 hours        │
│ -  **Asthma specialist**: 1-2 weeks if severe│
│ -  **Return precautions**: Clear instructions│
│                                         │
│ **Patient Education Priorities[5][9]**: │
│ -  **Trigger identification**: Environmental control│
│ -  **Early warning signs**: When to act │
│ -  **Medication adherence**: Importance of controllers│
│ -  **Emergency signs**: When to call 911│
│                                         │
│ [Next: Home management ▶]              │
└─────────────────────────────────────────┘

## QUALITY METRICS & IMPLEMENTATION

### **Asthma Protocol Key Features:**
- **GINA 2025 AIR Therapy**: Prioritizes ICS-formoterol over SABA-only approach[1][5]
- **UpToDate Severity**: Integrates formal assessment criteria
- **Evidence-based escalation**: Systematic approach to treatment intensification[9]
- **T2 biomarker consideration**: Future integration for severe asthma[13]

### **Quality Targets:**
- **Time to bronchodilator**: <30 minutes from recognition
- **Appropriate steroid use**: >90% compliance with guidelines
- **AIR therapy adoption**: >75% for appropriate patients
- **30-day readmission**: <15% target

### **Technology Integration:**
- **EMR-embedded flowcharts**: Click-through node activation
- **Real-time PEFR tracking**: Automated trend analysis and response assessment
- **Clinical decision support**: Built-in calculators and severity alerts
- **Quality dashboards**: Outcome metrics and compliance monitoring

### **Specialized Services Integration:**
- **Respiratory Therapy**: 24/7 RT coverage with advanced nebulizer protocols
- **Pulmonology consultation**: Same-day availability for severe cases
- **Allergy/Immunology**: Severe asthma and biologic therapy evaluation
- **Pharmacy services**: Inhaler technique education and AIR therapy optimization
