import Foundation
import SwiftUI

// MARK: - RRT Protocol Service

@MainActor
public class RRTProtocolService: ObservableObject {
    @Published public private(set) var protocols: [EmergencyProtocol] = []
    @Published public private(set) var isLoading = false
    
    public init() {
        loadRRTProtocols()
    }
    
    private func loadRRTProtocols() {
        isLoading = true
        defer { isLoading = false }
        
        protocols = createRRTProtocols()
    }
    
    private func createRRTProtocols() -> [EmergencyProtocol] {
        return [
            createSepsisProtocol(),
            createRespiratoryDistressProtocol(),
            createCardiacMonitoringProtocol(),
            createNeurologicalAssessmentProtocol(),
            createHypotensionProtocol(),
            createAcuteKidneyInjuryProtocol(),
            createElectrolyteImbalanceProtocol(),
            createOxygenationProtocol(),
            createPainCrisisProtocol(),
            createRapidDeteriorationProtocol()
        ]
    }
    
    // MARK: - Sepsis Recognition & Management Protocol
    
    private func createSepsisProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "sepsis_screening",
                title: "Sepsis Screening",
                nodeType: .assessment,
                critical: true,
                content: "qSOFA score: GCS <15, SBP <100, RR ≥22. SIRS criteria: Temp >38°C or <36°C, HR >90, RR >20, WBC >12k or <4k",
                connections: ["sepsis_suspected"]
            ),
            AlgorithmNode(
                id: "sepsis_suspected",
                title: "Sepsis Suspected?",
                nodeType: .decision,
                critical: true,
                content: "Clinical suspicion based on screening criteria and clinical presentation",
                connections: ["sepsis_bundle", "continue_monitoring"]
            ),
            AlgorithmNode(
                id: "sepsis_bundle",
                title: "Sepsis Bundle - Hour 1",
                nodeType: .intervention,
                critical: true,
                content: "1. Blood cultures before antibiotics 2. Lactate level 3. Broad-spectrum antibiotics 4. IV fluid resuscitation",
                connections: ["fluid_resuscitation"]
            ),
            AlgorithmNode(
                id: "fluid_resuscitation",
                title: "Fluid Challenge",
                nodeType: .intervention,
                critical: true,
                content: "30mL/kg crystalloid within 3 hours. Reassess after each 500mL bolus",
                connections: ["vasopressor_need"]
            ),
            AlgorithmNode(
                id: "vasopressor_need",
                title: "Vasopressor Required?",
                nodeType: .decision,
                critical: true,
                content: "MAP <65 mmHg despite adequate fluid resuscitation",
                connections: ["start_vasopressors", "monitor_response"]
            ),
            AlgorithmNode(
                id: "start_vasopressors",
                title: "Vasopressor Therapy",
                nodeType: .medication,
                critical: true,
                content: "Norepinephrine first-line: 0.1-30 mcg/min. Target MAP ≥65 mmHg",
                connections: ["icu_consultation"]
            ),
            AlgorithmNode(
                id: "monitor_response",
                title: "Monitor Response",
                nodeType: .assessment,
                critical: false,
                content: "Serial lactate, vital signs, urine output, mental status",
                connections: ["icu_consultation"]
            ),
            AlgorithmNode(
                id: "icu_consultation",
                title: "ICU Consultation",
                nodeType: .intervention,
                critical: true,
                content: "Early ICU consultation for severe sepsis/septic shock",
                connections: []
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Sepsis Bundle Progress",
                sections: [
                    CardSection(title: "Hour 1 Goals", items: [
                        "Blood cultures obtained before antibiotics",
                        "Lactate level drawn",
                        "Broad-spectrum antibiotics started",
                        "30mL/kg IV fluids if hypotensive/lactate ≥4"
                    ])
                ]
            ),
            ProtocolCard(
                id: "assessment_card",
                type: .assessment,
                title: "Sepsis Recognition",
                sections: [
                    CardSection(title: "qSOFA Criteria (≥2 points)", items: [
                        "Altered mental status (GCS <15)",
                        "Systolic BP <100 mmHg",
                        "Respiratory rate ≥22/min"
                    ]),
                    CardSection(title: "SIRS Criteria (≥2 points)", items: [
                        "Temperature >38°C (100.4°F) or <36°C (96.8°F)",
                        "Heart rate >90 bpm",
                        "Respiratory rate >20/min or PaCO2 <32 mmHg",
                        "WBC >12,000 or <4,000 or >10% bands"
                    ]),
                    CardSection(title: "Organ Dysfunction Signs", items: [
                        "Hypotension (SBP <90 or MAP <65)",
                        "Altered mental status",
                        "Oliguria (<0.5 mL/kg/hr)",
                        "Lactate >2 mmol/L",
                        "Platelets <100,000"
                    ])
                ]
            ),
            ProtocolCard(
                id: "actions_card",
                type: .actions,
                title: "Treatment Protocol",
                sections: [
                    CardSection(title: "Immediate Actions", items: [
                        "Obtain blood cultures from 2 sites",
                        "Start broad-spectrum antibiotics within 1 hour",
                        "Measure serum lactate",
                        "IV access and fluid resuscitation"
                    ]),
                    CardSection(title: "Antibiotic Selection", items: [
                        "Vancomycin 15-20mg/kg + Piperacillin-Tazobactam 4.5g",
                        "Consider local antibiogram patterns",
                        "De-escalate based on culture results",
                        "Duration: typically 7-10 days"
                    ]),
                    CardSection(title: "Fluid Management", items: [
                        "Initial: 30mL/kg crystalloid",
                        "Reassess after each 500mL bolus",
                        "Target CVP 8-12 mmHg (if available)",
                        "Monitor for fluid overload"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "rrt_sepsis",
            title: "Sepsis Recognition & Management",
            icon: "bx-virus",
            category: .infectious,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    // MARK: - Respiratory Distress Protocol
    
    private func createRespiratoryDistressProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "respiratory_assessment",
                title: "Respiratory Assessment",
                nodeType: .assessment,
                critical: true,
                content: "RR, O2 sat, work of breathing, breath sounds, ABG if indicated",
                connections: ["severity_classification"]
            ),
            AlgorithmNode(
                id: "severity_classification",
                title: "Classify Severity",
                nodeType: .decision,
                critical: true,
                content: "Mild, moderate, or severe based on vital signs and clinical presentation",
                connections: ["oxygen_therapy", "high_flow_oxygen", "bipap_consideration"]
            ),
            AlgorithmNode(
                id: "oxygen_therapy",
                title: "Standard Oxygen",
                nodeType: .intervention,
                critical: false,
                content: "Nasal cannula 1-6L/min or simple mask to maintain SpO2 >90%",
                connections: ["bronchodilators"]
            ),
            AlgorithmNode(
                id: "high_flow_oxygen",
                title: "High-Flow Nasal Cannula",
                nodeType: .intervention,
                critical: true,
                content: "HFNC 30-60L/min, FiO2 0.21-1.0, heated and humidified",
                connections: ["bronchodilators"]
            ),
            AlgorithmNode(
                id: "bipap_consideration",
                title: "BiPAP/CPAP",
                nodeType: .intervention,
                critical: true,
                content: "Consider for COPD exacerbation, CHF, or respiratory acidosis",
                connections: ["intubation_criteria"]
            ),
            AlgorithmNode(
                id: "bronchodilators",
                title: "Bronchodilator Therapy",
                nodeType: .medication,
                critical: false,
                content: "Albuterol 2.5-5mg nebulizer q20min x3, then q2-6h PRN",
                connections: ["steroid_therapy"]
            ),
            AlgorithmNode(
                id: "steroid_therapy",
                title: "Corticosteroids",
                nodeType: .medication,
                critical: false,
                content: "Methylprednisolone 125mg IV or Prednisone 40-60mg PO if COPD/asthma",
                connections: ["reassessment"]
            ),
            AlgorithmNode(
                id: "intubation_criteria",
                title: "Intubation Criteria Met?",
                nodeType: .decision,
                critical: true,
                content: "Respiratory failure, altered mental status, inability to protect airway",
                connections: ["rsi_protocol", "reassessment"]
            ),
            AlgorithmNode(
                id: "rsi_protocol",
                title: "RSI Protocol",
                nodeType: .intervention,
                critical: true,
                content: "Rapid sequence intubation per protocol. Consider difficult airway",
                connections: ["mechanical_ventilation"]
            ),
            AlgorithmNode(
                id: "mechanical_ventilation",
                title: "Mechanical Ventilation",
                nodeType: .intervention,
                critical: true,
                content: "Lung-protective ventilation strategy. ARDSNet protocol if applicable",
                connections: []
            ),
            AlgorithmNode(
                id: "reassessment",
                title: "Reassess Response",
                nodeType: .assessment,
                critical: false,
                content: "Monitor vital signs, work of breathing, arterial blood gases",
                connections: []
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Respiratory Status",
                sections: [
                    CardSection(title: "Critical Actions", items: [
                        "Maintain SpO2 >90% (>88% in COPD)",
                        "Monitor work of breathing continuously",
                        "Prepare for intubation if deteriorating"
                    ])
                ]
            ),
            ProtocolCard(
                id: "assessment_card",
                type: .assessment,
                title: "Respiratory Assessment",
                sections: [
                    CardSection(title: "Severity Indicators", items: [
                        "Mild: RR 20-24, SpO2 90-94%, minimal accessory muscles",
                        "Moderate: RR 25-30, SpO2 85-89%, moderate distress",
                        "Severe: RR >30, SpO2 <85%, severe distress, altered mental status"
                    ]),
                    CardSection(title: "Intubation Criteria", items: [
                        "Respiratory arrest or impending arrest",
                        "Severe hypoxemia despite high FiO2",
                        "Severe hypercapnia with acidosis (pH <7.25)",
                        "Altered mental status with inability to protect airway",
                        "Hemodynamic instability"
                    ])
                ]
            ),
            ProtocolCard(
                id: "actions_card",
                type: .actions,
                title: "Treatment Options",
                sections: [
                    CardSection(title: "Oxygen Delivery", items: [
                        "Nasal cannula: 1-6 L/min",
                        "Simple mask: 6-10 L/min",
                        "Non-rebreather: 10-15 L/min",
                        "HFNC: 30-60 L/min with heated humidity"
                    ]),
                    CardSection(title: "Bronchodilators", items: [
                        "Albuterol: 2.5-5mg nebulizer q20min x3",
                        "Ipratropium: 0.5mg nebulizer q6h",
                        "Combination: DuoNeb q20min x3 doses"
                    ]),
                    CardSection(title: "Ventilator Settings", items: [
                        "Tidal volume: 6-8 mL/kg ideal body weight",
                        "PEEP: 5-10 cmH2O (titrate to oxygenation)",
                        "FiO2: Start 100%, wean to lowest effective",
                        "Plateau pressure <30 cmH2O"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "rrt_respiratory_distress",
            title: "Respiratory Distress Management",
            icon: "bx-wind",
            category: .respiratory,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    // MARK: - Cardiac Monitoring Protocol
    
    private func createCardiacMonitoringProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "cardiac_assessment",
                title: "Cardiac Assessment",
                nodeType: .assessment,
                critical: true,
                content: "12-lead ECG, vital signs, cardiac history, chest pain assessment",
                connections: ["rhythm_analysis"]
            ),
            AlgorithmNode(
                id: "rhythm_analysis",
                title: "Rhythm Analysis",
                nodeType: .decision,
                critical: true,
                content: "Analyze rhythm: NSR, arrhythmia, ischemic changes, or conduction blocks",
                connections: ["normal_rhythm", "arrhythmia_management", "ischemic_changes"]
            ),
            AlgorithmNode(
                id: "normal_rhythm",
                title: "Normal Rhythm",
                nodeType: .assessment,
                critical: false,
                content: "Continue monitoring, assess for other causes of symptoms",
                connections: ["troponin_labs"]
            ),
            AlgorithmNode(
                id: "arrhythmia_management",
                title: "Arrhythmia Protocol",
                nodeType: .intervention,
                critical: true,
                content: "Identify type: bradycardia, tachycardia, or irregular rhythm",
                connections: ["bradycardia_protocol", "tachycardia_protocol"]
            ),
            AlgorithmNode(
                id: "ischemic_changes",
                title: "Ischemic Changes",
                nodeType: .assessment,
                critical: true,
                content: "ST elevations, depressions, T-wave inversions, Q waves",
                connections: ["acute_mi_protocol"]
            ),
            AlgorithmNode(
                id: "bradycardia_protocol",
                title: "Bradycardia Management",
                nodeType: .intervention,
                critical: true,
                content: "HR <50 with symptoms: Atropine 0.5mg IV, consider pacing",
                connections: ["cardiology_consult"]
            ),
            AlgorithmNode(
                id: "tachycardia_protocol",
                title: "Tachycardia Management",
                nodeType: .intervention,
                critical: true,
                content: "Wide vs narrow complex, stable vs unstable, consider cardioversion",
                connections: ["cardiology_consult"]
            ),
            AlgorithmNode(
                id: "acute_mi_protocol",
                title: "Acute MI Protocol",
                nodeType: .intervention,
                critical: true,
                content: "STEMI vs NSTEMI pathway, activate appropriate protocols",
                connections: ["cardiology_consult"]
            ),
            AlgorithmNode(
                id: "troponin_labs",
                title: "Cardiac Biomarkers",
                nodeType: .assessment,
                critical: false,
                content: "Troponin I/T, BNP/NT-proBNP if heart failure suspected",
                connections: ["serial_monitoring"]
            ),
            AlgorithmNode(
                id: "cardiology_consult",
                title: "Cardiology Consultation",
                nodeType: .intervention,
                critical: true,
                content: "Urgent cardiology consultation for significant findings",
                connections: ["serial_monitoring"]
            ),
            AlgorithmNode(
                id: "serial_monitoring",
                title: "Serial Monitoring",
                nodeType: .assessment,
                critical: false,
                content: "Continuous cardiac monitoring, serial ECGs, trending biomarkers",
                connections: []
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Cardiac Monitoring Status",
                sections: [
                    CardSection(title: "Priority Actions", items: [
                        "Continuous cardiac monitoring",
                        "Serial 12-lead ECGs every 30 minutes if ACS suspected",
                        "Trending cardiac biomarkers"
                    ])
                ]
            ),
            ProtocolCard(
                id: "assessment_card",
                type: .assessment,
                title: "Cardiac Assessment",
                sections: [
                    CardSection(title: "Critical Rhythms", items: [
                        "Complete heart block",
                        "Ventricular tachycardia",
                        "Atrial fibrillation with RVR",
                        "Symptomatic bradycardia <50 bpm"
                    ]),
                    CardSection(title: "Ischemic ECG Changes", items: [
                        "ST elevation ≥1mm in ≥2 contiguous leads",
                        "New left bundle branch block",
                        "ST depression >0.5mm in ≥2 leads",
                        "T-wave inversions in multiple leads"
                    ]),
                    CardSection(title: "High-Risk Features", items: [
                        "Chest pain with ECG changes",
                        "Hemodynamically unstable arrhythmias",
                        "Signs of heart failure",
                        "Elevated cardiac biomarkers"
                    ])
                ]
            ),
            ProtocolCard(
                id: "actions_card",
                type: .actions,
                title: "Interventions",
                sections: [
                    CardSection(title: "Bradycardia Treatment", items: [
                        "Atropine 0.5mg IV (may repeat to 3mg total)",
                        "Transcutaneous pacing if atropine ineffective",
                        "Dopamine 5-20 mcg/kg/min",
                        "Epinephrine 2-10 mcg/min if severe"
                    ]),
                    CardSection(title: "Tachycardia Treatment", items: [
                        "Unstable: synchronized cardioversion",
                        "Stable narrow complex: vagal maneuvers, adenosine",
                        "Stable wide complex: amiodarone or procainamide",
                        "Rate control: metoprolol, diltiazem"
                    ]),
                    CardSection(title: "Monitoring Parameters", items: [
                        "Heart rate and rhythm",
                        "Blood pressure every 15 minutes",
                        "Oxygen saturation",
                        "Level of consciousness"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "rrt_cardiac_monitoring",
            title: "Cardiac Monitoring & Arrhythmias",
            icon: "bx-heart-wave",
            category: .cardiac,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    // MARK: - Neurological Assessment Protocol
    
    private func createNeurologicalAssessmentProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "neuro_assessment",
                title: "Neurological Assessment",
                nodeType: .assessment,
                critical: true,
                content: "Glasgow Coma Scale, pupil response, focal deficits, vital signs",
                connections: ["gcs_evaluation"]
            ),
            AlgorithmNode(
                id: "gcs_evaluation",
                title: "GCS Evaluation",
                nodeType: .decision,
                critical: true,
                content: "GCS 15: normal, 13-14: mild, 9-12: moderate, ≤8: severe",
                connections: ["normal_gcs", "altered_mental_status", "severe_impairment"]
            ),
            AlgorithmNode(
                id: "normal_gcs",
                title: "Normal GCS (15)",
                nodeType: .assessment,
                critical: false,
                content: "Assess for subtle changes, focal deficits, or cognitive impairment",
                connections: ["focal_deficit_check"]
            ),
            AlgorithmNode(
                id: "altered_mental_status",
                title: "Altered Mental Status",
                nodeType: .assessment,
                critical: true,
                content: "GCS 9-14: Investigate causes, continuous monitoring",
                connections: ["cause_investigation"]
            ),
            AlgorithmNode(
                id: "severe_impairment",
                title: "Severe Impairment",
                nodeType: .intervention,
                critical: true,
                content: "GCS ≤8: Consider intubation, CT head, neurology consult",
                connections: ["airway_protection"]
            ),
            AlgorithmNode(
                id: "focal_deficit_check",
                title: "Focal Deficits Present?",
                nodeType: .decision,
                critical: true,
                content: "Check for weakness, sensory loss, speech changes, coordination",
                connections: ["stroke_protocol", "seizure_evaluation"]
            ),
            AlgorithmNode(
                id: "cause_investigation",
                title: "Investigate Causes",
                nodeType: .assessment,
                critical: true,
                content: "Hypoglycemia, hypoxia, drugs, infection, metabolic, trauma",
                connections: ["glucose_check", "infection_workup"]
            ),
            AlgorithmNode(
                id: "airway_protection",
                title: "Airway Protection",
                nodeType: .intervention,
                critical: true,
                content: "Consider intubation for airway protection if GCS ≤8",
                connections: ["ct_head"]
            ),
            AlgorithmNode(
                id: "stroke_protocol",
                title: "Stroke Protocol",
                nodeType: .intervention,
                critical: true,
                content: "Activate Code Stroke, urgent CT head, neurology consult",
                connections: ["neurology_consult"]
            ),
            AlgorithmNode(
                id: "seizure_evaluation",
                title: "Seizure Evaluation",
                nodeType: .assessment,
                critical: true,
                content: "History of seizure activity, postictal state, status epilepticus",
                connections: ["antiepileptic_drugs"]
            ),
            AlgorithmNode(
                id: "glucose_check",
                title: "Glucose Check",
                nodeType: .assessment,
                critical: true,
                content: "Point-of-care glucose, treat if <70 mg/dL",
                connections: ["dextrose_administration"]
            ),
            AlgorithmNode(
                id: "dextrose_administration",
                title: "Dextrose 50%",
                nodeType: .medication,
                critical: true,
                content: "25-50mL D50W IV push if hypoglycemic",
                connections: ["reassess_neuro"]
            ),
            AlgorithmNode(
                id: "ct_head",
                title: "CT Head",
                nodeType: .assessment,
                critical: true,
                content: "Urgent CT head without contrast for altered mental status",
                connections: ["neurology_consult"]
            ),
            AlgorithmNode(
                id: "neurology_consult",
                title: "Neurology Consultation",
                nodeType: .intervention,
                critical: true,
                content: "Urgent neurology consultation for significant findings",
                connections: ["serial_neuro_checks"]
            ),
            AlgorithmNode(
                id: "serial_neuro_checks",
                title: "Serial Neuro Checks",
                nodeType: .assessment,
                critical: false,
                content: "Frequent neurological assessments, monitor for deterioration",
                connections: []
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Neurological Status",
                sections: [
                    CardSection(title: "Critical Priorities", items: [
                        "Protect airway if GCS ≤8",
                        "Identify and treat reversible causes",
                        "Monitor for neurological deterioration"
                    ])
                ]
            ),
            ProtocolCard(
                id: "assessment_card",
                type: .assessment,
                title: "Neurological Assessment",
                sections: [
                    CardSection(title: "Glasgow Coma Scale", items: [
                        "Eye opening: 4=spontaneous, 3=to voice, 2=to pain, 1=none",
                        "Verbal response: 5=oriented, 4=confused, 3=words, 2=sounds, 1=none",
                        "Motor response: 6=obeys, 5=localizes, 4=withdraws, 3=flexion, 2=extension, 1=none"
                    ]),
                    CardSection(title: "Pupil Assessment", items: [
                        "Size: 2-4mm normal, >6mm dilated, <2mm constricted",
                        "Reactivity: brisk, sluggish, or non-reactive",
                        "Symmetry: equal vs unequal",
                        "Anisocoria: difference >1mm abnormal"
                    ]),
                    CardSection(title: "Red Flags", items: [
                        "Rapidly declining GCS",
                        "Unequal pupils",
                        "Focal neurological deficits",
                        "Signs of increased intracranial pressure"
                    ])
                ]
            ),
            ProtocolCard(
                id: "actions_card",
                type: .actions,
                title: "Interventions",
                sections: [
                    CardSection(title: "Reversible Causes", items: [
                        "Hypoglycemia: D50W 25-50mL IV",
                        "Hypoxia: oxygen supplementation",
                        "Hypotension: fluid resuscitation",
                        "Opioid overdose: naloxone 0.4-2mg IV"
                    ]),
                    CardSection(title: "Seizure Management", items: [
                        "Lorazepam 2-4mg IV or diazepam 5-10mg IV",
                        "Phenytoin 18-20mg/kg IV loading dose",
                        "Levetiracetam 500-1500mg IV alternative",
                        "Status epilepticus: continuous infusion may be needed"
                    ]),
                    CardSection(title: "Increased ICP Management", items: [
                        "Elevate head of bed 30 degrees",
                        "Maintain normothermia",
                        "Avoid hypotension and hypoxia",
                        "Consider mannitol or hypertonic saline"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "rrt_neurological_assessment",
            title: "Neurological Assessment & Management",
            icon: "bx-brain-waves",
            category: .neurological,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    // MARK: - Hypotension Management Protocol
    
    private func createHypotensionProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "hypotension_recognition",
                title: "Hypotension Recognition",
                nodeType: .assessment,
                critical: true,
                content: "SBP <90 mmHg or MAP <65 mmHg or >40 mmHg drop from baseline",
                connections: ["shock_assessment"]
            ),
            AlgorithmNode(
                id: "shock_assessment",
                title: "Assess for Shock",
                nodeType: .decision,
                critical: true,
                content: "Signs of hypoperfusion: altered mental status, oliguria, cool extremities",
                connections: ["fluid_responsive", "distributive_shock", "cardiogenic_shock"]
            ),
            AlgorithmNode(
                id: "fluid_responsive",
                title: "Fluid Responsive?",
                nodeType: .decision,
                critical: true,
                content: "Hypovolemic shock likely: dehydration, bleeding, third-spacing",
                connections: ["fluid_challenge", "blood_products"]
            ),
            AlgorithmNode(
                id: "fluid_challenge",
                title: "Fluid Challenge",
                nodeType: .intervention,
                critical: true,
                content: "500-1000mL crystalloid bolus over 15-30 minutes, reassess",
                connections: ["response_evaluation"]
            ),
            AlgorithmNode(
                id: "blood_products",
                title: "Blood Products",
                nodeType: .intervention,
                critical: true,
                content: "If active bleeding: type & crossmatch, consider O-negative PRBCs",
                connections: ["surgical_consult"]
            ),
            AlgorithmNode(
                id: "distributive_shock",
                title: "Distributive Shock",
                nodeType: .assessment,
                critical: true,
                content: "Sepsis, anaphylaxis, neurogenic - warm extremities, wide pulse pressure",
                connections: ["vasopressor_therapy"]
            ),
            AlgorithmNode(
                id: "cardiogenic_shock",
                title: "Cardiogenic Shock",
                nodeType: .assessment,
                critical: true,
                content: "Heart failure, MI, arrhythmia - cool extremities, pulmonary edema",
                connections: ["inotropic_support"]
            ),
            AlgorithmNode(
                id: "vasopressor_therapy",
                title: "Vasopressor Therapy",
                nodeType: .medication,
                critical: true,
                content: "Norepinephrine 0.1-30 mcg/min, titrate to MAP ≥65 mmHg",
                connections: ["source_control"]
            ),
            AlgorithmNode(
                id: "inotropic_support",
                title: "Inotropic Support",
                nodeType: .medication,
                critical: true,
                content: "Dobutamine 2.5-10 mcg/kg/min or milrinone loading then infusion",
                connections: ["cardiology_consult"]
            ),
            AlgorithmNode(
                id: "response_evaluation",
                title: "Evaluate Response",
                nodeType: .assessment,
                critical: false,
                content: "Improvement in BP, perfusion markers, urine output",
                connections: ["continue_monitoring"]
            ),
            AlgorithmNode(
                id: "continue_monitoring",
                title: "Continue Monitoring",
                nodeType: .assessment,
                critical: false,
                content: "Serial vital signs, urine output, lactate levels",
                connections: []
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Hypotension Management",
                sections: [
                    CardSection(title: "Immediate Goals", items: [
                        "Maintain MAP ≥65 mmHg",
                        "Restore tissue perfusion",
                        "Identify and treat underlying cause"
                    ])
                ]
            ),
            ProtocolCard(
                id: "assessment_card",
                type: .assessment,
                title: "Shock Classification",
                sections: [
                    CardSection(title: "Hypovolemic Shock", items: [
                        "History: bleeding, vomiting, diarrhea, poor intake",
                        "Physical: dry mucous membranes, poor skin turgor",
                        "Response: improves with fluid resuscitation"
                    ]),
                    CardSection(title: "Distributive Shock", items: [
                        "Septic: fever, infection source, warm extremities",
                        "Anaphylactic: allergen exposure, urticaria, bronchospasm",
                        "Neurogenic: spinal injury, warm dry skin below lesion"
                    ]),
                    CardSection(title: "Cardiogenic Shock", items: [
                        "History: MI, heart failure, arrhythmia",
                        "Physical: cool extremities, pulmonary edema, JVD",
                        "May worsen with aggressive fluid administration"
                    ])
                ]
            ),
            ProtocolCard(
                id: "actions_card",
                type: .actions,
                title: "Treatment Options",
                sections: [
                    CardSection(title: "Fluid Resuscitation", items: [
                        "Crystalloids: Normal saline or lactated Ringer's",
                        "Initial bolus: 500-1000mL over 15-30 minutes",
                        "Reassess after each bolus",
                        "Avoid overresuscitation in heart failure"
                    ]),
                    CardSection(title: "Vasopressors", items: [
                        "Norepinephrine: 0.1-30 mcg/min (first-line)",
                        "Vasopressin: 0.01-0.04 units/min (adjunct)",
                        "Epinephrine: 0.1-10 mcg/min (distributive shock)",
                        "Phenylephrine: 100-180 mcg/min (neurogenic shock)"
                    ]),
                    CardSection(title: "Monitoring", items: [
                        "Continuous BP monitoring",
                        "Urine output ≥0.5 mL/kg/hr",
                        "Lactate levels (target <2 mmol/L)",
                        "Central venous pressure if indicated"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "rrt_hypotension",
            title: "Hypotension & Shock Management",
            icon: "bx-trending-down",
            category: .cardiac,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    // MARK: - Acute Kidney Injury Protocol
    
    private func createAcuteKidneyInjuryProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "aki_recognition",
                title: "AKI Recognition",
                nodeType: .assessment,
                critical: true,
                content: "Cr increase ≥0.3 mg/dL in 48hrs or ≥1.5x baseline, or urine <0.5 mL/kg/hr for 6hrs",
                connections: ["aki_staging"]
            ),
            AlgorithmNode(
                id: "aki_staging",
                title: "AKI Staging",
                nodeType: .decision,
                critical: true,
                content: "Stage 1: Cr 1.5-1.9x baseline, Stage 2: 2-2.9x baseline, Stage 3: ≥3x baseline",
                connections: ["cause_classification"]
            ),
            AlgorithmNode(
                id: "cause_classification",
                title: "Classify AKI Cause",
                nodeType: .decision,
                critical: true,
                content: "Pre-renal (volume), intrinsic (ATN, GN), or post-renal (obstruction)",
                connections: ["prerenal_management", "intrinsic_workup", "postrenal_evaluation"]
            ),
            AlgorithmNode(
                id: "prerenal_management",
                title: "Pre-renal AKI",
                nodeType: .intervention,
                critical: true,
                content: "Volume depletion: cautious fluid resuscitation, avoid nephrotoxins",
                connections: ["fluid_optimization"]
            ),
            AlgorithmNode(
                id: "intrinsic_workup",
                title: "Intrinsic AKI Workup",
                nodeType: .assessment,
                critical: true,
                content: "Urinalysis, urine microscopy, proteinuria, nephrology consult",
                connections: ["nephrotoxin_removal"]
            ),
            AlgorithmNode(
                id: "postrenal_evaluation",
                title: "Post-renal Evaluation",
                nodeType: .assessment,
                critical: true,
                content: "Bladder scan, renal ultrasound, urology consult if obstruction",
                connections: ["obstruction_relief"]
            ),
            AlgorithmNode(
                id: "fluid_optimization",
                title: "Fluid Optimization",
                nodeType: .intervention,
                critical: true,
                content: "Maintain euvolemia, monitor daily weights, I/O balance",
                connections: ["medication_adjustment"]
            ),
            AlgorithmNode(
                id: "nephrotoxin_removal",
                title: "Remove Nephrotoxins",
                nodeType: .intervention,
                critical: true,
                content: "Stop ACE/ARB, NSAIDs, aminoglycosides, contrast agents",
                connections: ["medication_adjustment"]
            ),
            AlgorithmNode(
                id: "obstruction_relief",
                title: "Relieve Obstruction",
                nodeType: .intervention,
                critical: true,
                content: "Foley catheter, urology consult for upper tract obstruction",
                connections: ["renal_recovery"]
            ),
            AlgorithmNode(
                id: "medication_adjustment",
                title: "Medication Adjustment",
                nodeType: .intervention,
                critical: false,
                content: "Dose adjust for GFR, avoid nephrotoxic medications",
                connections: ["electrolyte_management"]
            ),
            AlgorithmNode(
                id: "electrolyte_management",
                title: "Electrolyte Management",
                nodeType: .assessment,
                critical: true,
                content: "Monitor K+, PO4, acid-base status, treat abnormalities",
                connections: ["dialysis_consideration"]
            ),
            AlgorithmNode(
                id: "dialysis_consideration",
                title: "Dialysis Indication?",
                nodeType: .decision,
                critical: true,
                content: "AEIOU: Acidosis, Electrolytes, Intoxication, Overload, Uremia",
                connections: ["nephrology_urgent", "conservative_management"]
            ),
            AlgorithmNode(
                id: "nephrology_urgent",
                title: "Urgent Nephrology",
                nodeType: .intervention,
                critical: true,
                content: "Immediate nephrology consultation for dialysis consideration",
                connections: []
            ),
            AlgorithmNode(
                id: "conservative_management",
                title: "Conservative Management",
                nodeType: .intervention,
                critical: false,
                content: "Continue supportive care, monitor renal function closely",
                connections: ["renal_recovery"]
            ),
            AlgorithmNode(
                id: "renal_recovery",
                title: "Monitor Recovery",
                nodeType: .assessment,
                critical: false,
                content: "Daily creatinine, urine output, trending towards baseline",
                connections: []
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "AKI Management Status",
                sections: [
                    CardSection(title: "Critical Actions", items: [
                        "Identify and treat underlying cause",
                        "Stop nephrotoxic medications",
                        "Optimize fluid balance and hemodynamics"
                    ])
                ]
            ),
            ProtocolCard(
                id: "assessment_card",
                type: .assessment,
                title: "AKI Assessment",
                sections: [
                    CardSection(title: "AKI Criteria (KDIGO)", items: [
                        "Creatinine increase ≥0.3 mg/dL within 48 hours",
                        "Creatinine increase ≥1.5x baseline within 7 days",
                        "Urine output <0.5 mL/kg/hr for 6 hours"
                    ]),
                    CardSection(title: "AKI Staging", items: [
                        "Stage 1: Cr 1.5-1.9x baseline or +0.3 mg/dL",
                        "Stage 2: Cr 2.0-2.9x baseline",
                        "Stage 3: Cr ≥3x baseline or Cr ≥4.0 mg/dL"
                    ]),
                    CardSection(title: "Dialysis Indications (AEIOU)", items: [
                        "Acidosis: severe metabolic acidosis",
                        "Electrolytes: hyperkalemia >6.5 mEq/L",
                        "Intoxication: methanol, ethylene glycol",
                        "Overload: pulmonary edema, volume overload",
                        "Uremia: BUN >100, uremic symptoms"
                    ])
                ]
            ),
            ProtocolCard(
                id: "actions_card",
                type: .actions,
                title: "Management Strategies",
                sections: [
                    CardSection(title: "Nephrotoxin Avoidance", items: [
                        "Stop ACE inhibitors/ARBs temporarily",
                        "Avoid NSAIDs and COX-2 inhibitors",
                        "Hold aminoglycosides if possible",
                        "Minimize contrast exposure"
                    ]),
                    CardSection(title: "Medication Dosing", items: [
                        "Adjust doses for estimated GFR",
                        "Avoid or reduce metformin",
                        "Careful with digoxin dosing",
                        "Monitor levels of renally cleared drugs"
                    ]),
                    CardSection(title: "Monitoring Parameters", items: [
                        "Daily creatinine and BUN",
                        "Daily weights and I/O balance",
                        "Electrolytes (K+, PO4, Ca++)",
                        "Urine output hourly if indicated"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "rrt_acute_kidney_injury",
            title: "Acute Kidney Injury Management",
            icon: "bx-droplet-cross",
            category: .cardiac,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    // MARK: - Electrolyte Imbalance Protocol
    
    private func createElectrolyteImbalanceProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "electrolyte_assessment",
                title: "Electrolyte Assessment",
                nodeType: .assessment,
                critical: true,
                content: "Na+, K+, Cl-, CO2, Ca++, Mg++, PO4. Check severity and symptoms",
                connections: ["critical_abnormality"]
            ),
            AlgorithmNode(
                id: "critical_abnormality",
                title: "Critical Abnormality?",
                nodeType: .decision,
                critical: true,
                content: "Life-threatening levels or severe symptoms present",
                connections: ["hyperkalemia_protocol", "hyponatremia_protocol", "hypercalcemia_protocol", "routine_correction"]
            ),
            AlgorithmNode(
                id: "hyperkalemia_protocol",
                title: "Hyperkalemia >6.5 mEq/L",
                nodeType: .intervention,
                critical: true,
                content: "Immediate: Calcium gluconate, insulin/dextrose, albuterol",
                connections: ["ecg_monitoring"]
            ),
            AlgorithmNode(
                id: "hyponatremia_protocol",
                title: "Severe Hyponatremia <120",
                nodeType: .intervention,
                critical: true,
                content: "Symptomatic: 3% saline 100mL bolus, can repeat x2",
                connections: ["sodium_monitoring"]
            ),
            AlgorithmNode(
                id: "hypercalcemia_protocol",
                title: "Severe Hypercalcemia >14",
                nodeType: .intervention,
                critical: true,
                content: "IV fluids, furosemide, calcitonin, bisphosphonates",
                connections: ["calcium_monitoring"]
            ),
            AlgorithmNode(
                id: "routine_correction",
                title: "Routine Correction",
                nodeType: .intervention,
                critical: false,
                content: "Standard replacement protocols based on specific deficits",
                connections: ["replacement_therapy"]
            ),
            AlgorithmNode(
                id: "ecg_monitoring",
                title: "ECG Monitoring",
                nodeType: .assessment,
                critical: true,
                content: "Monitor for peaked T waves, widened QRS, arrhythmias",
                connections: ["potassium_removal"]
            ),
            AlgorithmNode(
                id: "potassium_removal",
                title: "Potassium Removal",
                nodeType: .intervention,
                critical: true,
                content: "Kayexalate, patiromer, or emergent dialysis if severe",
                connections: ["serial_monitoring"]
            ),
            AlgorithmNode(
                id: "sodium_monitoring",
                title: "Sodium Monitoring",
                nodeType: .assessment,
                critical: true,
                content: "Limit correction to 6-8 mEq/L in 24hrs to avoid CPM",
                connections: ["neurologic_monitoring"]
            ),
            AlgorithmNode(
                id: "calcium_monitoring",
                title: "Calcium Monitoring",
                nodeType: .assessment,
                critical: true,
                content: "Monitor for hypocalcemia rebound, QT prolongation",
                connections: ["serial_monitoring"]
            ),
            AlgorithmNode(
                id: "replacement_therapy",
                title: "Replacement Therapy",
                nodeType: .medication,
                critical: false,
                content: "PO or IV replacement based on severity and symptoms",
                connections: ["serial_monitoring"]
            ),
            AlgorithmNode(
                id: "neurologic_monitoring",
                title: "Neurologic Monitoring",
                nodeType: .assessment,
                critical: true,
                content: "Monitor for seizures, altered mental status, focal deficits",
                connections: ["serial_monitoring"]
            ),
            AlgorithmNode(
                id: "serial_monitoring",
                title: "Serial Monitoring",
                nodeType: .assessment,
                critical: false,
                content: "Repeat electrolytes every 4-6 hours until stable",
                connections: []
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Electrolyte Status",
                sections: [
                    CardSection(title: "Critical Priorities", items: [
                        "Identify life-threatening abnormalities",
                        "Protect cardiac and neurologic function",
                        "Correct at appropriate rate to avoid complications"
                    ])
                ]
            ),
            ProtocolCard(
                id: "assessment_card",
                type: .assessment,
                title: "Critical Values",
                sections: [
                    CardSection(title: "Hyperkalemia (>5.5 mEq/L)", items: [
                        "Mild: 5.5-6.0 mEq/L - usually asymptomatic",
                        "Moderate: 6.1-6.9 mEq/L - ECG changes",
                        "Severe: ≥7.0 mEq/L - life-threatening arrhythmias"
                    ]),
                    CardSection(title: "Hyponatremia (<135 mEq/L)", items: [
                        "Mild: 130-134 mEq/L - usually asymptomatic",
                        "Moderate: 120-129 mEq/L - nausea, malaise",
                        "Severe: <120 mEq/L - altered mental status, seizures"
                    ]),
                    CardSection(title: "Hypercalcemia (>10.5 mg/dL)", items: [
                        "Mild: 10.6-11.9 mg/dL - fatigue, depression",
                        "Moderate: 12.0-13.9 mg/dL - confusion, kidney stones",
                        "Severe: ≥14.0 mg/dL - altered mental status, arrhythmias"
                    ])
                ]
            ),
            ProtocolCard(
                id: "actions_card",
                type: .actions,
                title: "Treatment Protocols",
                sections: [
                    CardSection(title: "Hyperkalemia Treatment", items: [
                        "Calcium gluconate 1-2g IV (cardiac protection)",
                        "Insulin 10 units + D50W 25g IV (shifts K+ intracellularly)",
                        "Albuterol 10-20mg nebulizer (shifts K+ intracellularly)",
                        "Kayexalate 15-30g PO or Patiromer (removes K+)"
                    ]),
                    CardSection(title: "Hyponatremia Treatment", items: [
                        "Acute/symptomatic: 3% saline 100mL over 10 min",
                        "Target initial rise: 4-6 mEq/L in first 6 hours",
                        "Maximum correction: 6-8 mEq/L in 24 hours",
                        "Chronic: correct more slowly to avoid CPM"
                    ]),
                    CardSection(title: "Other Electrolyte Replacements", items: [
                        "Hypokalemia: KCl 10-20 mEq IV over 1 hour",
                        "Hypomagnesemia: MgSO4 1-2g IV over 1 hour",
                        "Hypophosphatemia: K-Phos 0.15-0.3 mmol/kg IV",
                        "Hypocalcemia: Calcium gluconate 1-2g IV"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "rrt_electrolyte_imbalance",
            title: "Electrolyte Imbalance Management",
            icon: "bx-atom",
            category: .cardiac,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    // MARK: - Oxygenation Crisis Protocol
    
    private func createOxygenationProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "oxygenation_assessment",
                title: "Oxygenation Assessment",
                nodeType: .assessment,
                critical: true,
                content: "SpO2, ABG, work of breathing, cyanosis, altered mental status",
                connections: ["hypoxemia_severity"]
            ),
            AlgorithmNode(
                id: "hypoxemia_severity",
                title: "Hypoxemia Severity",
                nodeType: .decision,
                critical: true,
                content: "Mild (SpO2 90-94%), Moderate (85-89%), Severe (<85%)",
                connections: ["mild_hypoxemia", "moderate_hypoxemia", "severe_hypoxemia"]
            ),
            AlgorithmNode(
                id: "mild_hypoxemia",
                title: "Mild Hypoxemia",
                nodeType: .intervention,
                critical: false,
                content: "Nasal cannula 2-4 L/min, target SpO2 >90%",
                connections: ["response_assessment"]
            ),
            AlgorithmNode(
                id: "moderate_hypoxemia",
                title: "Moderate Hypoxemia",
                nodeType: .intervention,
                critical: true,
                content: "High-flow nasal cannula or non-rebreather mask",
                connections: ["ards_evaluation"]
            ),
            AlgorithmNode(
                id: "severe_hypoxemia",
                title: "Severe Hypoxemia",
                nodeType: .intervention,
                critical: true,
                content: "Consider BiPAP/CPAP or intubation with mechanical ventilation",
                connections: ["ventilator_management"]
            ),
            AlgorithmNode(
                id: "response_assessment",
                title: "Response Assessment",
                nodeType: .assessment,
                critical: false,
                content: "Improvement in SpO2, work of breathing, mental status",
                connections: ["continue_monitoring"]
            ),
            AlgorithmNode(
                id: "ards_evaluation",
                title: "ARDS Evaluation",
                nodeType: .assessment,
                critical: true,
                content: "PaO2/FiO2 ratio, bilateral infiltrates, no cardiogenic cause",
                connections: ["lung_protective_ventilation"]
            ),
            AlgorithmNode(
                id: "ventilator_management",
                title: "Mechanical Ventilation",
                nodeType: .intervention,
                critical: true,
                content: "Low tidal volume strategy, PEEP optimization, FiO2 titration",
                connections: ["advanced_therapies"]
            ),
            AlgorithmNode(
                id: "lung_protective_ventilation",
                title: "Lung Protective Strategy",
                nodeType: .intervention,
                critical: true,
                content: "TV 6-8 mL/kg IBW, plateau pressure <30 cmH2O, PEEP optimization",
                connections: ["prone_positioning"]
            ),
            AlgorithmNode(
                id: "prone_positioning",
                title: "Prone Positioning",
                nodeType: .intervention,
                critical: true,
                content: "Consider for severe ARDS (P/F ratio <150) and FiO2 >60%",
                connections: ["advanced_therapies"]
            ),
            AlgorithmNode(
                id: "advanced_therapies",
                title: "Advanced Therapies",
                nodeType: .intervention,
                critical: true,
                content: "ECMO consideration, inhaled vasodilators, recruitment maneuvers",
                connections: ["critical_care_consult"]
            ),
            AlgorithmNode(
                id: "critical_care_consult",
                title: "Critical Care Consultation",
                nodeType: .intervention,
                critical: true,
                content: "Urgent critical care or pulmonology consultation",
                connections: ["continue_monitoring"]
            ),
            AlgorithmNode(
                id: "continue_monitoring",
                title: "Continue Monitoring",
                nodeType: .assessment,
                critical: false,
                content: "Serial ABGs, chest imaging, ventilator parameters",
                connections: []
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Oxygenation Status",
                sections: [
                    CardSection(title: "Priority Goals", items: [
                        "Maintain adequate tissue oxygenation",
                        "Minimize ventilator-induced injury",
                        "Identify and treat underlying cause"
                    ])
                ]
            ),
            ProtocolCard(
                id: "assessment_card",
                type: .assessment,
                title: "Oxygenation Assessment",
                sections: [
                    CardSection(title: "Hypoxemia Classification", items: [
                        "Mild: SpO2 90-94%, PaO2 60-79 mmHg",
                        "Moderate: SpO2 85-89%, PaO2 45-59 mmHg",
                        "Severe: SpO2 <85%, PaO2 <45 mmHg"
                    ]),
                    CardSection(title: "ARDS Criteria (Berlin)", items: [
                        "Acute onset within 1 week",
                        "Bilateral pulmonary infiltrates",
                        "Not fully explained by cardiac failure",
                        "P/F ratio: Mild 200-300, Moderate 100-200, Severe <100"
                    ]),
                    CardSection(title: "Clinical Signs", items: [
                        "Central cyanosis",
                        "Use of accessory muscles",
                        "Altered mental status",
                        "Tachycardia and tachypnea"
                    ])
                ]
            ),
            ProtocolCard(
                id: "actions_card",
                type: .actions,
                title: "Oxygen Therapy",
                sections: [
                    CardSection(title: "Oxygen Delivery Systems", items: [
                        "Nasal cannula: 1-6 L/min (FiO2 24-44%)",
                        "Simple mask: 6-10 L/min (FiO2 35-60%)",
                        "Non-rebreather: 10-15 L/min (FiO2 60-90%)",
                        "HFNC: 30-60 L/min (FiO2 21-100%)"
                    ]),
                    CardSection(title: "Mechanical Ventilation", items: [
                        "Tidal volume: 6-8 mL/kg ideal body weight",
                        "PEEP: Start 5 cmH2O, titrate to oxygenation",
                        "Plateau pressure: Keep <30 cmH2O",
                        "FiO2: Start high, wean to lowest effective"
                    ]),
                    CardSection(title: "Advanced Strategies", items: [
                        "Prone positioning: 12-16 hours daily for severe ARDS",
                        "Recruitment maneuvers: Consider in early ARDS",
                        "Inhaled NO: Limited evidence, case-by-case",
                        "ECMO: Consider for refractory hypoxemia"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "rrt_oxygenation_crisis",
            title: "Oxygenation Crisis Management",
            icon: "bx-oxygen",
            category: .respiratory,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    // MARK: - Pain Crisis Protocol
    
    private func createPainCrisisProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "pain_assessment",
                title: "Pain Assessment",
                nodeType: .assessment,
                critical: true,
                content: "Pain scale 0-10, vital signs, functional impact, previous analgesics",
                connections: ["pain_severity"]
            ),
            AlgorithmNode(
                id: "pain_severity",
                title: "Pain Severity Classification",
                nodeType: .decision,
                critical: true,
                content: "Severe pain (8-10/10), physiologic distress, functional impairment",
                connections: ["acute_management", "chronic_exacerbation", "breakthrough_pain"]
            ),
            AlgorithmNode(
                id: "acute_management",
                title: "Acute Severe Pain",
                nodeType: .intervention,
                critical: true,
                content: "Immediate analgesia, multi-modal approach, reassess frequently",
                connections: ["opioid_therapy"]
            ),
            AlgorithmNode(
                id: "chronic_exacerbation",
                title: "Chronic Pain Exacerbation",
                nodeType: .intervention,
                critical: true,
                content: "Review baseline regimen, identify precipitating factors",
                connections: ["dose_optimization"]
            ),
            AlgorithmNode(
                id: "breakthrough_pain",
                title: "Breakthrough Pain",
                nodeType: .intervention,
                critical: true,
                content: "Short-acting opioid, typically 10-20% of daily opioid dose",
                connections: ["response_evaluation"]
            ),
            AlgorithmNode(
                id: "opioid_therapy",
                title: "Opioid Therapy",
                nodeType: .medication,
                critical: true,
                content: "Morphine 2-4mg IV q15min or Hydromorphone 0.5-1mg IV q15min",
                connections: ["adjuvant_therapy"]
            ),
            AlgorithmNode(
                id: "dose_optimization",
                title: "Dose Optimization",
                nodeType: .medication,
                critical: true,
                content: "Increase baseline dose by 25-50% or add short-acting opioid",
                connections: ["adjuvant_therapy"]
            ),
            AlgorithmNode(
                id: "adjuvant_therapy",
                title: "Adjuvant Medications",
                nodeType: .medication,
                critical: false,
                content: "Acetaminophen, NSAIDs (if appropriate), anticonvulsants, steroids",
                connections: ["non_pharmacologic"]
            ),
            AlgorithmNode(
                id: "non_pharmacologic",
                title: "Non-Pharmacologic Interventions",
                nodeType: .intervention,
                critical: false,
                content: "Heat/cold therapy, positioning, relaxation techniques, distraction",
                connections: ["response_evaluation"]
            ),
            AlgorithmNode(
                id: "response_evaluation",
                title: "Response Evaluation",
                nodeType: .assessment,
                critical: true,
                content: "Pain scale reduction, vital signs, side effects, functional improvement",
                connections: ["adequate_control", "inadequate_control"]
            ),
            AlgorithmNode(
                id: "adequate_control",
                title: "Adequate Pain Control",
                nodeType: .assessment,
                critical: false,
                content: "Pain reduced to acceptable level, plan for discharge or admission",
                connections: ["transition_planning"]
            ),
            AlgorithmNode(
                id: "inadequate_control",
                title: "Inadequate Control",
                nodeType: .intervention,
                critical: true,
                content: "Consider alternative opioids, regional anesthesia, specialty consult",
                connections: ["pain_service_consult"]
            ),
            AlgorithmNode(
                id: "pain_service_consult",
                title: "Pain Service Consultation",
                nodeType: .intervention,
                critical: true,
                content: "Acute pain service or palliative care consultation",
                connections: ["transition_planning"]
            ),
            AlgorithmNode(
                id: "transition_planning",
                title: "Transition Planning",
                nodeType: .intervention,
                critical: false,
                content: "Long-acting opioids, follow-up, safety counseling",
                connections: []
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Pain Management Status",
                sections: [
                    CardSection(title: "Treatment Goals", items: [
                        "Achieve functional pain relief",
                        "Minimize adverse effects",
                        "Prevent withdrawal or rebound pain"
                    ])
                ]
            ),
            ProtocolCard(
                id: "assessment_card",
                type: .assessment,
                title: "Pain Assessment",
                sections: [
                    CardSection(title: "Pain Scale", items: [
                        "0-3: Mild pain - usually manageable",
                        "4-6: Moderate pain - interferes with activities",
                        "7-10: Severe pain - unable to function normally"
                    ]),
                    CardSection(title: "Pain Crisis Indicators", items: [
                        "Pain score 8-10/10",
                        "Vital sign changes (↑HR, ↑BP)",
                        "Functional impairment",
                        "Psychological distress"
                    ]),
                    CardSection(title: "Red Flags", items: [
                        "New neurological deficits",
                        "Signs of infection",
                        "Substance abuse concerns",
                        "Suicidal ideation"
                    ])
                ]
            ),
            ProtocolCard(
                id: "actions_card",
                type: .actions,
                title: "Pain Management Options",
                sections: [
                    CardSection(title: "Opioid Analgesics", items: [
                        "Morphine: 2-4mg IV q15min PRN",
                        "Hydromorphone: 0.5-1mg IV q15min PRN",
                        "Fentanyl: 25-50mcg IV q15min PRN",
                        "Oxycodone: 5-10mg PO q4-6h PRN"
                    ]),
                    CardSection(title: "Non-Opioid Analgesics", items: [
                        "Acetaminophen: 650-1000mg q6h (max 4g/day)",
                        "Ibuprofen: 400-800mg q8h (if no contraindications)",
                        "Ketorolac: 30mg IV/IM q6h x 5 days max",
                        "Gabapentin: 300-800mg q8h for neuropathic pain"
                    ]),
                    CardSection(title: "Safety Considerations", items: [
                        "Monitor respiratory depression",
                        "Assess for sedation and confusion",
                        "Watch for drug interactions",
                        "Consider naloxone availability"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "rrt_pain_crisis",
            title: "Pain Crisis Management",
            icon: "bx-sad",
            category: .neurological,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    // MARK: - Rapid Deterioration Protocol
    
    private func createRapidDeteriorationProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "deterioration_recognition",
                title: "Deterioration Recognition",
                nodeType: .assessment,
                critical: true,
                content: "Early warning scores, vital sign trends, clinical concern, family worry",
                connections: ["mews_calculation"]
            ),
            AlgorithmNode(
                id: "mews_calculation",
                title: "MEWS Score Calculation",
                nodeType: .assessment,
                critical: true,
                content: "Modified Early Warning Score: HR, BP, RR, Temp, AVPU, SpO2",
                connections: ["risk_stratification"]
            ),
            AlgorithmNode(
                id: "risk_stratification",
                title: "Risk Stratification",
                nodeType: .decision,
                critical: true,
                content: "Low risk (MEWS 0-2), Medium risk (3-4), High risk (≥5)",
                connections: ["low_risk_monitoring", "medium_risk_intervention", "high_risk_escalation"]
            ),
            AlgorithmNode(
                id: "low_risk_monitoring",
                title: "Enhanced Monitoring",
                nodeType: .intervention,
                critical: false,
                content: "Increase vital sign frequency, nursing assessment every 2-4 hours",
                connections: ["trend_monitoring"]
            ),
            AlgorithmNode(
                id: "medium_risk_intervention",
                title: "Active Intervention",
                nodeType: .intervention,
                critical: true,
                content: "Physician evaluation within 30 minutes, focused assessment",
                connections: ["system_support"]
            ),
            AlgorithmNode(
                id: "high_risk_escalation",
                title: "Immediate Escalation",
                nodeType: .intervention,
                critical: true,
                content: "Immediate physician evaluation, consider ICU consultation",
                connections: ["abcde_assessment"]
            ),
            AlgorithmNode(
                id: "abcde_assessment",
                title: "ABCDE Assessment",
                nodeType: .assessment,
                critical: true,
                content: "Airway, Breathing, Circulation, Disability, Exposure systematic review",
                connections: ["system_failure_identification"]
            ),
            AlgorithmNode(
                id: "system_failure_identification",
                title: "System Failure Identification",
                nodeType: .decision,
                critical: true,
                content: "Respiratory, cardiovascular, neurological, renal, or multi-organ failure",
                connections: ["respiratory_support", "hemodynamic_support", "neurologic_support"]
            ),
            AlgorithmNode(
                id: "respiratory_support",
                title: "Respiratory Support",
                nodeType: .intervention,
                critical: true,
                content: "Oxygen therapy, airway management, ventilatory support as needed",
                connections: ["icu_transfer"]
            ),
            AlgorithmNode(
                id: "hemodynamic_support",
                title: "Hemodynamic Support",
                nodeType: .intervention,
                critical: true,
                content: "IV access, fluid resuscitation, vasopressor support if indicated",
                connections: ["icu_transfer"]
            ),
            AlgorithmNode(
                id: "neurologic_support",
                title: "Neurologic Support",
                nodeType: .intervention,
                critical: true,
                content: "Neuroprotective measures, seizure control, ICP management",
                connections: ["icu_transfer"]
            ),
            AlgorithmNode(
                id: "system_support",
                title: "Organ System Support",
                nodeType: .intervention,
                critical: true,
                content: "Targeted interventions based on failing system",
                connections: ["reassessment"]
            ),
            AlgorithmNode(
                id: "icu_transfer",
                title: "ICU Transfer",
                nodeType: .intervention,
                critical: true,
                content: "Immediate ICU transfer for intensive monitoring and support",
                connections: ["family_communication"]
            ),
            AlgorithmNode(
                id: "trend_monitoring",
                title: "Trend Monitoring",
                nodeType: .assessment,
                critical: false,
                content: "Serial MEWS scores, identify worsening trends early",
                connections: ["reassessment"]
            ),
            AlgorithmNode(
                id: "reassessment",
                title: "Continuous Reassessment",
                nodeType: .assessment,
                critical: true,
                content: "Frequent reassessment, response to interventions, trend analysis",
                connections: ["family_communication"]
            ),
            AlgorithmNode(
                id: "family_communication",
                title: "Family Communication",
                nodeType: .intervention,
                critical: false,
                content: "Keep family informed, address concerns, involve in care decisions",
                connections: []
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Deterioration Status",
                sections: [
                    CardSection(title: "Critical Actions", items: [
                        "Calculate MEWS score every 4 hours",
                        "Escalate care based on score and trends",
                        "Systematic ABCDE assessment for high-risk patients"
                    ])
                ]
            ),
            ProtocolCard(
                id: "assessment_card",
                type: .assessment,
                title: "Early Warning Scoring",
                sections: [
                    CardSection(title: "MEWS Components", items: [
                        "Heart rate: <51 (2 pts), 51-100 (0 pts), 101-110 (1 pt), >110 (2 pts)",
                        "Systolic BP: <101 (2 pts), 101-199 (0 pts), ≥200 (2 pts)",
                        "Respiratory rate: <9 (2 pts), 9-14 (0 pts), 15-20 (1 pt), >20 (2 pts)",
                        "Temperature: <36°C (1 pt), 36-38°C (0 pts), >38°C (1 pt)"
                    ]),
                    CardSection(title: "Risk Categories", items: [
                        "Low risk (0-2): Routine monitoring",
                        "Medium risk (3-4): Increased monitoring, MD notification",
                        "High risk (≥5): Immediate evaluation, consider ICU"
                    ]),
                    CardSection(title: "Warning Signs", items: [
                        "Sustained single parameter abnormality",
                        "Any MEWS score increase ≥2 points",
                        "Clinical concern regardless of score",
                        "Family expressing worry about patient"
                    ])
                ]
            ),
            ProtocolCard(
                id: "actions_card",
                type: .actions,
                title: "Response Actions",
                sections: [
                    CardSection(title: "ABCDE Assessment", items: [
                        "Airway: Patent, positioning, suction if needed",
                        "Breathing: RR, SpO2, breath sounds, chest movement",
                        "Circulation: HR, BP, perfusion, IV access",
                        "Disability: GCS, pupils, glucose, temperature",
                        "Exposure: Full examination, maintain dignity"
                    ]),
                    CardSection(title: "Escalation Pathways", items: [
                        "MEWS 3-4: Primary team notification within 30 min",
                        "MEWS ≥5: Immediate physician evaluation",
                        "No improvement: Senior physician or ICU consultation",
                        "Continuing deterioration: Rapid response activation"
                    ]),
                    CardSection(title: "Documentation", items: [
                        "MEWS score with each vital sign set",
                        "Clinical response to interventions",
                        "Escalation communications and timing",
                        "Family involvement and communication"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "rrt_rapid_deterioration",
            title: "Rapid Deterioration Response",
            icon: "bx-trending-down-alert",
            category: .cardiac,
            algorithm: algorithm,
            cards: cards
        )
    }
}