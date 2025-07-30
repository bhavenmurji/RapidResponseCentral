# SmartDr Clinical Decision Support System
## Complete Protocol Reference Guide

---

## Table of Contents

1. [Introduction](#introduction)
2. [Main Menu Navigation](#main-menu-navigation)
3. [Emergency Protocols](#emergency-protocols)
   - [Acute Coronary Syndrome (ACS)](#acute-coronary-syndrome-acs)
   - [Pneumothorax](#pneumothorax)
   - [Stroke](#stroke)
   - [Anaphylaxis](#anaphylaxis)
   - [Respiratory Emergencies](#respiratory-emergencies)
   - [Cardiac Emergencies](#cardiac-emergencies)
   - [Neurological Emergencies](#neurological-emergencies)
   - [Metabolic Emergencies](#metabolic-emergencies)
4. [NEWS Calls](#news-calls)
5. [Asked To See Patient (ATSP)](#asked-to-see-patient-atsp)
6. [Ward Jobs](#ward-jobs)
7. [Protocol Structure](#protocol-structure)
8. [Clinical Decision Trees](#clinical-decision-trees)

---

## Introduction

SmartDr is a rapid-access clinical decision support system designed for emergency and acute medical care. The app provides evidence-based protocols organized into four main categories:

- **Emergencies**: Life-threatening conditions requiring immediate intervention
- **NEWS Calls**: Response to National Early Warning Score triggers
- **Asked To See Patient**: Common clinical scenarios on the wards
- **Ward Jobs**: Routine clinical tasks and procedures

Each protocol follows a standardized 4-tab format:
1. **Causes** - Differential diagnosis and etiology
2. **History** - Key questions and red flags
3. **Exam** - Physical examination findings
4. **Plan** - Management algorithm and treatment

---

## Main Menu Navigation

### Primary Categories:
- 🚑 **Emergencies** - Critical conditions requiring immediate action
- 🚦 **NEWS Calls** - Early warning score responses
- 🩺 **Asked To See Patient** - Ward consultation protocols
- 🖊️ **Ward Jobs** - Clinical procedures and tasks

---

## Emergency Protocols

### Acute Coronary Syndrome (ACS)

#### Classification:
- **STEMI** - ST-Elevation Myocardial Infarction
- **NSTEMI/UA** - Non-ST Elevation MI / Unstable Angina

#### NSTEMI/UA Management Pathway:

```
1. OXYGEN
   ↓
   If evidence of:
   - Hypoxia
   - Pulmonary oedema
   - Continuing myocardial ischaemia
   
2. ANALGESIA
   ↓
   Sublingual GTN
   If fails → IV GTN 2-10mg/hour
   If still fails → Diamorphine 1.25-2.5mg or Morphine 5mg IV
   + Antiemetic (Metoclopramide 10mg IV)
   
3. ANTIPLATELET
   ↓
   Aspirin 300mg PO STAT
   +
   Clopidogrel 300mg PO STAT
   OR
   Ticagrelor 180mg PO STAT
   OR
   Prasugrel 60mg PO STAT
```

#### STEMI Management:
- Immediate PCI if available within 120 minutes
- Otherwise thrombolysis if <12 hours from symptom onset
- Door-to-needle time target: 30 minutes

#### Causes:
- Atherosclerotic plaque rupture
- Coronary artery spasm
- Coronary embolism
- Cocaine use
- Spontaneous coronary artery dissection

#### History Red Flags:
- Central crushing chest pain
- Radiation to jaw/arm
- Associated dyspnoea
- Sweating, nausea
- Previous cardiac history

#### Examination:
- Vital signs (BP, HR, O2 sats)
- Evidence of heart failure
- Murmurs (new MR suggests papillary muscle rupture)
- Peripheral perfusion

---

### Pneumothorax

#### Decision Tree:

```
CHARACTERISE
↓
Age > 50 OR Evidence of underlying lung disease?
↓                          ↓
PRIMARY                    SECONDARY
↓                          ↓
>2cm OR breathless?        >2cm OR breathless?
↓           ↓              ↓           ↓
YES         NO             YES         NO (1-2cm)
↓           ↓              ↓           ↓
Pleural     Discharge      Chest       Pleural
aspiration                 drain       aspiration
↓                          ↓           ↓
<2cm and                   If <1cm →   Admit with
breathing                  high flow O2
improved?
↓
YES → Chest drain
NO → Discharge

Note: If bilateral, proceed directly to chest drain
```

#### Causes:
**Primary:**
- Tall, thin young males
- Smoking
- Marfan syndrome

**Secondary:**
- COPD
- Asthma
- Pneumonia
- TB
- Malignancy
- Cystic fibrosis

#### History:
- Sudden onset pleuritic chest pain
- Breathlessness
- Previous episodes
- Underlying lung disease

#### Examination:
- Reduced chest expansion
- Hyperresonant percussion
- Reduced/absent breath sounds
- Tracheal deviation (tension)

---

### Stroke

#### Management Flowchart:

```
CT HEAD
↓
Haemorrhage?
↓               ↓
YES             NO
↓               ↓
Contact         Aspirin 300mg PO/NG/PR STAT
neurosurgeons   ↓
                ≤4.5 hours since symptom onset?
                ↓               ↓
                YES             NO
                ↓               ↓
                Thrombolysis    Continue aspirin 300mg OD
                                for 14 days then switch to
                                maintenance clopidogrel 75mg OD
                
BLOOD PRESSURE:
Only treat if hypertensive emergency with end-organ damage
```

#### TIA Management:
- Aspirin 300mg PO OD
- Assess stroke risk (ABCD2 score)
- Investigate underlying cause
- Urgent carotid doppler if anterior circulation

#### Temporal Arteritis (if visual symptoms):
- Prednisolone 60mg PO OD
- Urgent ophthalmology review
- Aspirin 75mg PO OD
- Consider temporal artery biopsy

---

### Anaphylaxis

#### Emergency Management:

```
1. HIGH-FLOW OXYGEN (15L/min)
   ↓
2. REMOVE TRIGGER
   ↓
3. ADRENALINE
   500 microgram (0.5mL) IM
   1:1000 adrenaline
   ↓
4. IV FLUID CHALLENGE
   500-1000mL crystalloid
   ↓
5. CHLORPHENAMINE
   10mg IM or slow IV
   ↓
6. HYDROCORTISONE
   200mg IM or slow IV
   ↓
7. MEASURE MAST CELL TRYPTASE
   3 samples:
   - As soon as feasible
   - 1-2 hours after symptom start
   - 24 hours after symptom start
```

#### Causes:
- Foods (nuts, shellfish, eggs)
- Drugs (penicillin, NSAIDs, contrast)
- Insect stings
- Latex
- Exercise-induced
- Idiopathic

#### History:
- Previous allergic reactions
- Known allergens
- Timing of exposure
- Associated symptoms

#### Examination:
- Airway swelling
- Wheeze/stridor
- Hypotension
- Urticaria/angioedema
- Abdominal pain

---

### Respiratory Emergencies

#### Tachypnoea

**Red Flags:**
- Chest pain
- Breathlessness
- Dizziness
- Palpitations
- Haemoptysis
- Throat swelling
- Bleeding

**History Details:**
- Cough (productive?)
- Fever
- Pleuritic pain
- Orthopnoea
- Exercise tolerance

**Common Causes:**
- Pneumonia
- PE
- Pneumothorax
- Pulmonary oedema
- Metabolic acidosis
- Anxiety

**Management:**
- ABG
- Chest X-ray
- ECG
- Treat underlying cause

---

### Cardiac Emergencies

#### Palpitations

**Management Algorithm:**

```
Syncope/Ischaemia/Heart failure?
↓
YES → Synchronised DC shock (up to 3 attempts)
      ↓
      If fails → Amiodarone 300mg IV over 10-20min
                 and re-attempt cardioversion
                 May follow with infusion 900mg/24h

Consider causes:
- Acute coronary syndrome
- Valvular heart disease
- Congestive cardiac failure
- Hypertension
- Cardiac surgery
- Congenital heart disease
```

#### Hypertension

**Investigations:**
- FBC
- U&E
- Troponin
- TFT
- VBG

**Imaging:**
- Chest X-ray
- CT head (if end-organ damage)

**Management:**
1. Identify and treat reversible causes
2. Identify and treat end-organ damage
3. Only treat if hypertensive emergency

---

### Neurological Emergencies

#### Visual Loss

**Plan:**
- Contact ophthalmology if necessary
- Assess falls risk
- Reassure

**Specific Conditions:**

**Stroke:**
- Once haemorrhage excluded → Aspirin 300mg PO STAT
- Thrombolysis with alteplase if <4.5 hours

**TIA:**
- Aspirin 300mg PO OD
- Assess stroke risk
- Investigate underlying cause

**Temporal Arteritis:**
- Prednisolone 60mg PO OD
- Urgent ophthalmology review
- Aspirin 75mg PO OD
- Consider temporal artery biopsy

---

### Metabolic Emergencies

#### Anaemia

**History - Bleeding Screen:**
- Haematemesis
- Melaena
- PR bleed
- Haemoptysis
- Haematuria
- Menorrhagia
- Epistaxis

**Associated Symptoms:**
- Headache
- Fatigue
- Poor diet
- Abdominal pain
- Bowel habit change
- Weight loss

**Examination:**
- Pallor
- Tachycardia
- Flow murmur
- Signs of bleeding
- Lymphadenopathy
- Hepatosplenomegaly

#### Hypomagnesaemia

**Examination Focus:**
- Alert?
- Neurological deficit?
- Confused?

**Fluid Status Assessment:**
- Capillary refill time
- Skin turgor
- Mouth
- Sunken eyes?
- JVP
- Oedema?
- Peripheral temperature

**Check:**
- Pulse rhythm
- ECG for arrhythmias

---

## NEWS Calls

National Early Warning Score (NEWS) triggers clinical review based on physiological parameters:

**Parameters monitored:**
- Respiratory rate
- Oxygen saturations
- Temperature
- Systolic BP
- Heart rate
- Level of consciousness

**Response by score:**
- 0-4: Routine ward care
- 5-6: Urgent ward review
- 7+: Emergency team response

---

## Asked To See Patient (ATSP)

Common ward consultation scenarios requiring systematic approach:
- Post-operative complications
- Medication reviews
- Discharge planning
- Family discussions
- Capacity assessments

---

## Ward Jobs

Routine clinical tasks including:
- Cannulation
- Catheterization
- NG tube insertion
- Arterial puncture
- Lumbar puncture
- Ascitic tap
- Pleural tap

---

## Protocol Structure

### Standard 4-Tab Format:

1. **Causes Tab**
   - Lists differential diagnoses
   - Organized by likelihood/severity
   - Includes red flag conditions

2. **History Tab**
   - Key questions to ask
   - Red flag symptoms
   - Risk factors
   - Previous episodes

3. **Exam Tab**
   - Systematic examination approach
   - Key findings to elicit
   - Signs of severity

4. **Plan Tab**
   - Step-by-step management
   - Decision trees
   - Medication doses
   - Escalation criteria

---

## Clinical Decision Trees

### Common Decision Points:

**Time-critical:**
- <4.5 hours for stroke thrombolysis
- <12 hours for STEMI thrombolysis
- Door-to-needle targets

**Clinical parameters:**
- Size criteria (e.g., >2cm pneumothorax)
- Age thresholds (e.g., >50 for secondary pneumothorax)
- Physiological markers (hypoxia, hypotension)

**Treatment escalation:**
- When to involve seniors
- ITU referral criteria
- Specialist input needed

### Medication Protocols:

**Standard doses frequently used:**
- Oxygen: 15L/min for emergencies, titrate to 94-98% (88-92% if CO2 retention risk)
- Aspirin: 300mg loading dose
- Adrenaline: 500mcg (0.5mL of 1:1000) IM for anaphylaxis
- Morphine: 5-10mg IV for severe pain
- Prednisolone: 40-50mg for asthma/COPD

**IV fluid resuscitation:**
- 250-500mL crystalloid challenges
- Monitor response
- Avoid in pulmonary oedema

---

## Integration with Hospital Systems

### MyEOP Protocols Include:
- **Code STEMI**: Cath lab activation protocol
- **Code Stroke**: Teleneurology integration
- **Sepsis Protocol**: Time Zero bundles
- **ECMO**: Advanced life support
- **ACLS**: Full resuscitation algorithms

---

## Color Coding System

- 🟢 **Green**: Stable pathways, routine management
- 🔴 **Red**: Critical/urgent interventions
- 🟡 **Yellow**: Metabolic/endocrine protocols
- 🟣 **Purple**: Neurological protocols
- 🟠 **Orange**: Respiratory protocols
- 🔵 **Blue**: Ward procedures

---

## Quick Reference

### Emergency Numbers:
- Cardiac arrest: 2222
- Medical emergency team: [Hospital specific]
- Stroke team: [Hospital specific]
- Cath lab: [Hospital specific]

### Time Targets:
- Door-to-needle (thrombolysis): 30 minutes
- Door-to-balloon (PCI): 90 minutes
- Antibiotic administration (sepsis): 1 hour
- First shock (cardiac arrest): <3 minutes

---

*This protocol guide is based on UK clinical guidelines and should be adapted to local policies and procedures. Always consult senior colleagues when uncertain and follow local hospital protocols.*