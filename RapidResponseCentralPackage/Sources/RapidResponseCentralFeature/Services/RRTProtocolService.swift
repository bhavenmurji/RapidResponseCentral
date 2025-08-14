import Foundation
import SwiftUI
import os.log
import os.signpost

// MARK: - RRT Protocol Service (Fixed Concurrent Version)

@MainActor
public class RRTProtocolService: ObservableObject {
    @Published public private(set) var protocols: [EmergencyProtocol] = []
    @Published public private(set) var isLoading = false
    
    private let performanceLogger = Logger(subsystem: "com.rapidresponsecentral.performance", category: "RRTProtocolService")
    private let signposter = OSSignposter(subsystem: "com.rapidresponsecentral.performance", category: "RRTProtocolCreation")
    
    public init() {
        Task {
            await loadRRTProtocolsConcurrently()
        }
    }
    
    @MainActor
    private func loadRRTProtocolsConcurrently() async {
        isLoading = true
        defer { isLoading = false }
        
        performanceLogger.info("🚀 Starting concurrent RRT protocol creation")
        let signpostID = signposter.makeSignpostID()
        let signpostState = signposter.beginInterval("RRTProtocolCreation", id: signpostID)
        
        protocols = await withTaskGroup(of: (Int, EmergencyProtocol).self, returning: [EmergencyProtocol].self) { group in
            let protocolCreators: [(String, @Sendable () async -> EmergencyProtocol)] = [
                ("Chest Pain Evaluation", { await self.createChestPainProtocol() }),
                ("Shortness of Breath/Hypoxia", { await self.createShortnessOfBreathProtocol() }),
                ("Altered Mental Status", { await self.createAlteredMentalStatusProtocol() }),
                ("Tachycardia", { await self.createTachycardiaProtocol() }),
                ("Hypotension & Hemorrhage", { await self.createHypotensionHemorrhageProtocol() }),
                ("Falls Assessment", { await self.createFallsAssessmentProtocol() })
            ]
            
            for (index, (name, creator)) in protocolCreators.enumerated() {
                group.addTask {
                    let startTime = CACurrentMediaTime()
                    let emergencyProtocol = await creator()
                    let duration = CACurrentMediaTime() - startTime
                    
                    if duration > 0.05 { // 50ms threshold for RRT protocols
                        self.performanceLogger.warning("⚠️ RRT Protocol Performance: \(name) took \(String(format: "%.2f", duration * 1000))ms")
                    } else {
                        self.performanceLogger.info("✅ \(name) created in \(String(format: "%.2f", duration * 1000))ms")
                    }
                    
                    return (index, emergencyProtocol)
                }
            }
            
            var results: [(Int, EmergencyProtocol)] = []
            for await result in group {
                results.append(result)
            }
            
            return results.sorted { $0.0 < $1.0 }.map { $0.1 }
        }
        
        signposter.endInterval("RRTProtocolCreation", signpostState)
        performanceLogger.info("✅ RRT Protocol creation completed: \(self.protocols.count) protocols loaded")
    }
    
    // MARK: - Individual Protocol Creation Methods (All Async)
    
    private func createChestPainProtocol() async -> EmergencyProtocol {
        // Chest Pain Evaluation protocol - Complete flowchart from documentation
        let algorithm = ProtocolAlgorithm(nodes: [
            // Node A
            AlgorithmNode(
                id: "chest_pain_initial",
                title: "Chest Pain RRT",
                nodeType: .assessment,
                critical: true,
                content: "Chest pain RRT activated. Begin immediate assessment and 12-lead ECG within 10 minutes",
                connections: ["ecg_vitals"]
            ),
            // Node B
            AlgorithmNode(
                id: "ecg_vitals",
                title: "ECG + Vitals",
                nodeType: .intervention,
                critical: true,
                content: "12-lead ECG obtained and vital signs documented. Evaluate for acute ST-elevation",
                connections: ["stemi_check"]
            ),
            // Node C
            AlgorithmNode(
                id: "stemi_check",
                title: "STEMI on ECG?",
                nodeType: .decision,
                critical: true,
                content: "STEMI criteria: ST elevation ≥1mm in 2 contiguous leads",
                connections: ["code_stemi", "risk_stratification"]
            ),
            // Node D
            AlgorithmNode(
                id: "code_stemi",
                title: "Code STEMI",
                nodeType: .action,
                critical: true,
                content: "STEMI confirmed. Activate Code STEMI protocol immediately. Transfer to STEMI pathway",
                connections: []
            ),
            // Node E
            AlgorithmNode(
                id: "risk_stratification",
                title: "Risk Stratify",
                nodeType: .assessment,
                critical: false,
                content: "No STEMI present. Complete risk stratification using history, exam, and HEART score",
                connections: ["life_threatening"]
            ),
            // Node F
            AlgorithmNode(
                id: "life_threatening",
                title: "Life-Threat?",
                nodeType: .decision,
                critical: true,
                content: "Evaluate for life-threatening causes: ACS, PE, dissection, tension pneumothorax",
                connections: ["immediate_workup", "systematic_evaluation"]
            ),
            // Node G
            AlgorithmNode(
                id: "immediate_workup",
                title: "Immediate Workup",
                nodeType: .intervention,
                critical: true,
                content: "High-risk features identified. Begin immediate diagnostic workup based on suspected cause",
                connections: ["suspected_diagnosis"]
            ),
            // Node H
            AlgorithmNode(
                id: "systematic_evaluation",
                title: "Systematic Evaluation",
                nodeType: .assessment,
                critical: false,
                content: "No immediate life threats. Proceed with systematic evaluation",
                connections: ["troponin_labs"]
            ),
            // Node I
            AlgorithmNode(
                id: "suspected_diagnosis",
                title: "Suspected Diagnosis?",
                nodeType: .decision,
                critical: true,
                content: "Clinical presentation suggests specific diagnosis. Initiate targeted evaluation",
                connections: ["acs_protocol", "pe_pathway", "dissection_eval", "pneumothorax_eval"]
            ),
            // Node J
            AlgorithmNode(
                id: "acs_protocol",
                title: "ACS + Troponins",
                nodeType: .intervention,
                critical: true,
                content: "ACS suspected. Begin dual antiplatelet therapy and anticoagulation. Serial troponins",
                connections: ["troponin_elevated"]
            ),
            // Node K
            AlgorithmNode(
                id: "pe_pathway",
                title: "CTA + Wells",
                nodeType: .intervention,
                critical: true,
                content: "PE suspected. Calculate Wells score, check D-dimer if indicated, order CTA chest",
                connections: ["pe_confirmed"]
            ),
            // Node L
            AlgorithmNode(
                id: "dissection_eval",
                title: "CTA + BP Control",
                nodeType: .intervention,
                critical: true,
                content: "Aortic dissection suspected. Emergency CTA chest/abdomen/pelvis. Control BP",
                connections: ["dissection_confirmed"]
            ),
            // Node M
            AlgorithmNode(
                id: "pneumothorax_eval",
                title: "CXR + Decompress",
                nodeType: .intervention,
                critical: true,
                content: "Pneumothorax suspected. STAT CXR. If tension, immediate needle decompression",
                connections: []
            ),
            // Node N
            AlgorithmNode(
                id: "troponin_labs",
                title: "Labs + CXR",
                nodeType: .intervention,
                critical: false,
                content: "Order troponin, CBC, BMP, CXR for systematic evaluation",
                connections: ["troponin_elevated"]
            ),
            // Node O
            AlgorithmNode(
                id: "troponin_elevated",
                title: "Troponin Elevated?",
                nodeType: .decision,
                critical: true,
                content: "Initial troponin result available. Elevated suggesting myocardial injury?",
                connections: ["nstemi_protocol", "serial_troponins"]
            ),
            // Node P
            AlgorithmNode(
                id: "nstemi_protocol",
                title: "NSTEMI + Cards",
                nodeType: .intervention,
                critical: true,
                content: "NSTEMI confirmed. Cardiology consultation for risk stratification and cath consideration",
                connections: ["admit_cardiology"]
            ),
            // Node Q
            AlgorithmNode(
                id: "serial_troponins",
                title: "Serial Trops",
                nodeType: .intervention,
                critical: false,
                content: "Negative initial troponin. Order serial troponins and consider stress testing",
                connections: ["high_risk_features"]
            ),
            // Node R
            AlgorithmNode(
                id: "pe_confirmed",
                title: "PE Confirmed?",
                nodeType: .decision,
                critical: true,
                content: "CTA results available. PE confirmed on imaging?",
                connections: ["anticoagulation", "alternative_diagnosis"]
            ),
            // Node S
            AlgorithmNode(
                id: "anticoagulation",
                title: "Anticoag + Risk",
                nodeType: .medication,
                critical: true,
                content: "PE confirmed. Begin anticoagulation and assess for thrombolysis candidacy",
                connections: ["admit_medicine"]
            ),
            // Node T
            AlgorithmNode(
                id: "alternative_diagnosis",
                title: "Alt Diagnosis",
                nodeType: .assessment,
                critical: false,
                content: "PE ruled out. Pursue alternative diagnoses based on clinical presentation",
                connections: []
            ),
            // Node U
            AlgorithmNode(
                id: "dissection_confirmed",
                title: "Dissection Confirmed?",
                nodeType: .decision,
                critical: true,
                content: "CTA results available. Aortic dissection confirmed?",
                connections: ["type_a_surgery", "type_b_medical"]
            ),
            // Node V
            AlgorithmNode(
                id: "type_a_surgery",
                title: "Surgery Type A",
                nodeType: .intervention,
                critical: true,
                content: "Type A dissection confirmed. Emergent cardiac surgery consultation",
                connections: ["or_stat"]
            ),
            // Node W
            AlgorithmNode(
                id: "type_b_medical",
                title: "Medical Type B",
                nodeType: .medication,
                critical: true,
                content: "Type B dissection. Medical management with BP control and pain management",
                connections: ["icu_admission"]
            ),
            // Node X
            AlgorithmNode(
                id: "admit_cardiology",
                title: "Admit Cards",
                nodeType: .action,
                critical: false,
                content: "Admission to cardiology service. Consider catheterization based on risk stratification",
                connections: []
            ),
            // Node Y
            AlgorithmNode(
                id: "high_risk_features",
                title: "High Risk?",
                nodeType: .decision,
                critical: false,
                content: "Assess for high-risk features requiring admission",
                connections: ["admit_cardiology", "observation_followup"]
            ),
            // Node Z
            AlgorithmNode(
                id: "observation_followup",
                title: "Obs + F/U",
                nodeType: .endpoint,
                critical: false,
                content: "Low risk. Observation unit or discharge with close outpatient follow-up",
                connections: []
            ),
            // Node AA
            AlgorithmNode(
                id: "admit_medicine",
                title: "Admit Med",
                nodeType: .endpoint,
                critical: false,
                content: "Admission to medicine service with telemetry monitoring",
                connections: []
            ),
            // Node AB
            AlgorithmNode(
                id: "or_stat",
                title: "OR STAT",
                nodeType: .endpoint,
                critical: true,
                content: "Emergency surgery for Type A dissection",
                connections: []
            ),
            // Node AC
            AlgorithmNode(
                id: "icu_admission",
                title: "ICU Admission",
                nodeType: .endpoint,
                critical: true,
                content: "ICU admission for intensive monitoring and management",
                connections: []
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Chest Pain Evaluation Progress",
                sections: [
                    CardSection(title: "Time Metrics", items: [
                        "Door to ECG: <10 minutes",
                        "Door to balloon: <90 minutes",
                        "First medical contact to device: <120 minutes"
                    ])
                ]
            ),
            ProtocolCard(
                id: "assessment_card",
                type: .assessment,
                title: "ACS Risk Assessment",
                sections: [
                    CardSection(title: "High Risk Features", items: [
                        "Dynamic ECG changes",
                        "Elevated troponins",
                        "Hemodynamic instability",
                        "Recurrent angina despite therapy"
                    ])
                ]
            ),
            ProtocolCard(
                id: "actions_card",
                type: .actions,
                title: "Critical Actions",
                sections: [
                    CardSection(title: "Immediate", items: [
                        "12-lead ECG within 10 minutes",
                        "IV access x2",
                        "Continuous cardiac monitoring",
                        "Aspirin 325mg chewed"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "rrt_chest_pain",
            title: "Chest Pain Evaluation",
            icon: "waveform.path.ecg", // Chest pain ECG evaluation
            category: .cardiac,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createShortnessOfBreathProtocol() async -> EmergencyProtocol {
        // Shortness of Breath/Hypoxia - BiPAP protocols, oxygen titration, respiratory failure management
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "initial_respiratory_assessment",
                title: "Initial Assess",
                nodeType: .assessment,
                critical: true,
                content: "ABC assessment, SpO2, RR, work of breathing, ABG if indicated",
                connections: ["hypoxia_severity"]
            ),
            AlgorithmNode(
                id: "hypoxia_severity",
                title: "Hypoxia Severity",
                nodeType: .decision,
                critical: true,
                content: "SpO2 <90% or PaO2 <60mmHg on room air",
                connections: ["acute_respiratory_failure", "mild_hypoxia"]
            ),
            AlgorithmNode(
                id: "acute_respiratory_failure",
                title: "Acute RF",
                nodeType: .intervention,
                critical: true,
                content: "High-flow O2, consider BiPAP/CPAP, prepare for intubation if needed",
                connections: ["bipap_trial"]
            ),
            AlgorithmNode(
                id: "bipap_trial",
                title: "BiPAP",
                nodeType: .intervention,
                critical: false,
                content: "Start BiPAP 10/5, titrate IPAP/EPAP based on response",
                connections: []
            ),
            AlgorithmNode(
                id: "mild_hypoxia",
                title: "Mild Hypoxia",
                nodeType: .intervention,
                critical: false,
                content: "Supplemental O2 via NC or face mask, target SpO2 92-96%",
                connections: []
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Respiratory Status",
                sections: [
                    CardSection(title: "Current Parameters", items: [
                        "SpO2 monitoring",
                        "Respiratory rate",
                        "ABG results",
                        "O2 delivery method"
                    ])
                ]
            ),
            ProtocolCard(
                id: "actions_card",
                type: .actions,
                title: "Interventions",
                sections: [
                    CardSection(title: "BiPAP Indications", items: [
                        "pH <7.35 with hypercapnia",
                        "Moderate to severe dyspnea",
                        "RR >25",
                        "Accessory muscle use"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "rrt_shortness_of_breath",
            title: "Shortness of Breath/Hypoxia",
            icon: "wind.circle.fill", // Respiratory distress/hypoxia
            category: .respiratory,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createAlteredMentalStatusProtocol() async -> EmergencyProtocol {
        // Altered Mental Status - Systematic workup with Glasgow Coma Scale integration
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "gcs_assessment",
                title: "GCS Assessment",
                nodeType: .assessment,
                critical: true,
                content: "Calculate Glasgow Coma Scale: Eye, Verbal, Motor response",
                connections: ["glucose_check"]
            ),
            AlgorithmNode(
                id: "glucose_check",
                title: "Check Glucose",
                nodeType: .decision,
                critical: true,
                content: "Fingerstick glucose - hypoglycemia is reversible cause",
                connections: ["hypoglycemia_treatment", "other_causes"]
            ),
            AlgorithmNode(
                id: "hypoglycemia_treatment",
                title: "Treat Hypo",
                nodeType: .medication,
                critical: true,
                content: "D50 1 amp IV if glucose <70mg/dL",
                connections: []
            ),
            AlgorithmNode(
                id: "other_causes",
                title: "Other Causes",
                nodeType: .assessment,
                critical: false,
                content: "Consider infection, metabolic, drugs, structural causes. Order labs, CT head if indicated",
                connections: []
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "assessment_card",
                type: .assessment,
                title: "Differential Diagnosis",
                sections: [
                    CardSection(title: "AEIOU TIPS", items: [
                        "Alcohol, Encephalopathy, Endocrine",
                        "Infection, Insulin, Intoxication",
                        "Oxygen, Opiates, Overdose",
                        "Uremia, Trauma, Temperature",
                        "Infection, Psych, Stroke, Seizure"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "rrt_altered_mental_status",
            title: "Altered Mental Status",
            icon: "brain", // Altered mental status
            category: .neurological,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createTachycardiaProtocol() async -> EmergencyProtocol {
        // Tachycardia - AHA/ACC ACLS guidelines with antiarrhythmic protocols
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "pulse_check",
                title: "Pulse Check",
                nodeType: .decision,
                critical: true,
                content: "Assess pulse and hemodynamic stability",
                connections: ["unstable_tachycardia", "stable_tachycardia"]
            ),
            AlgorithmNode(
                id: "unstable_tachycardia",
                title: "Unstable Tachy",
                nodeType: .intervention,
                critical: true,
                content: "Synchronized cardioversion: 100J → 200J → 300J → 360J",
                connections: []
            ),
            AlgorithmNode(
                id: "stable_tachycardia",
                title: "Assess QRS",
                nodeType: .decision,
                critical: false,
                content: "Wide QRS (≥0.12s) vs Narrow QRS (<0.12s)",
                connections: ["wide_qrs", "narrow_qrs"]
            ),
            AlgorithmNode(
                id: "wide_qrs",
                title: "Wide Complex",
                nodeType: .medication,
                critical: false,
                content: "Amiodarone 150mg IV over 10 min",
                connections: []
            ),
            AlgorithmNode(
                id: "narrow_qrs",
                title: "Narrow Complex",
                nodeType: .intervention,
                critical: false,
                content: "Vagal maneuvers, then adenosine 6mg → 12mg IV",
                connections: []
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "assessment_card",
                type: .assessment,
                title: "Unstable Signs",
                sections: [
                    CardSection(title: "Hemodynamic Instability", items: [
                        "Hypotension",
                        "Altered mental status",
                        "Chest pain",
                        "Acute heart failure"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "rrt_tachycardia",
            title: "Tachycardia",
            icon: "waveform", // Tachycardia rhythm
            category: .cardiac,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createHypotensionHemorrhageProtocol() async -> EmergencyProtocol {
        // Hypotension & Hemorrhage - Massive transfusion protocol activation
        let algorithm = ProtocolAlgorithm(nodes: [
            // Node A
            AlgorithmNode(
                id: "hypotension_recognition",
                title: "Hypotension",
                nodeType: .assessment,
                critical: true,
                content: "Hypotension identified (MAP <65 or SBP <90). Begin immediate hemodynamic support",
                connections: ["iv_access_fluids"]
            ),
            // Node B
            AlgorithmNode(
                id: "iv_access_fluids",
                title: "IV Access + Fluids",
                nodeType: .intervention,
                critical: true,
                content: "Establish large bore IV access x2 and initiate crystalloid fluid resuscitation",
                connections: ["hemorrhage_assessment"]
            ),
            // Node C
            AlgorithmNode(
                id: "hemorrhage_assessment",
                title: "Hemorrhage?",
                nodeType: .decision,
                critical: true,
                content: "Evaluate for signs of active bleeding: obvious sources, lab trends, clinical presentation",
                connections: ["activate_mtp", "non_hemorrhagic_evaluation"]
            ),
            // Node D
            AlgorithmNode(
                id: "activate_mtp",
                title: "Activate MTP",
                nodeType: .action,
                critical: true,
                content: "Significant hemorrhage suspected. Activate massive transfusion protocol immediately",
                connections: ["control_bleeding"]
            ),
            // Node E
            AlgorithmNode(
                id: "non_hemorrhagic_evaluation",
                title: "Non-hemorrhage",
                nodeType: .assessment,
                critical: false,
                content: "No obvious bleeding identified. Evaluate for distributive, cardiogenic, or obstructive shock",
                connections: ["fluid_responsive_check"]
            ),
            // Node F
            AlgorithmNode(
                id: "control_bleeding",
                title: "Control Bleeding",
                nodeType: .intervention,
                critical: true,
                content: "Apply direct pressure and initiate bleeding control measures while awaiting definitive care",
                connections: ["surgical_ir_consult"]
            ),
            // Node G
            AlgorithmNode(
                id: "fluid_responsive_check",
                title: "Fluid Responsive?",
                nodeType: .decision,
                critical: false,
                content: "Assess response to initial fluid bolus: improved BP, HR, perfusion, urine output",
                connections: ["continue_fluids", "start_vasopressors"]
            ),
            // Node H
            AlgorithmNode(
                id: "surgical_ir_consult",
                title: "Surgery/IR",
                nodeType: .action,
                critical: true,
                content: "Ongoing hemorrhage requires source control. Contact surgery and/or interventional radiology",
                connections: ["blood_products"]
            ),
            // Node I
            AlgorithmNode(
                id: "continue_fluids",
                title: "Continue Fluids",
                nodeType: .intervention,
                critical: false,
                content: "Continue fluid resuscitation and monitor hemodynamic response",
                connections: ["bp_stable_check"]
            ),
            // Node J
            AlgorithmNode(
                id: "start_vasopressors",
                title: "Start Vasopressors & Evaluate Etiology",
                nodeType: .medication,
                critical: false,
                content: "Fluid non-responsive hypotension. Begin vasopressor support with norepinephrine",
                connections: ["shock_type_classification"]
            ),
            // Node K
            AlgorithmNode(
                id: "blood_products",
                title: "Blood Products 1:1:1 Ratio",
                nodeType: .medication,
                critical: true,
                content: "Administer blood products in 1:1:1 ratio following massive transfusion protocol",
                connections: ["ongoing_bleeding_check"]
            ),
            // Node L
            AlgorithmNode(
                id: "ongoing_bleeding_check",
                title: "Ongoing Bleeding?",
                nodeType: .decision,
                critical: true,
                content: "Evaluate for continued active bleeding despite initial interventions",
                connections: ["or_ir_stat", "stabilize_coagulopathy"]
            ),
            // Node M
            AlgorithmNode(
                id: "or_ir_stat",
                title: "OR/IR STAT & Continue MTP",
                nodeType: .intervention,
                critical: true,
                content: "Refractory bleeding requiring immediate operative or interventional control",
                connections: ["damage_control"]
            ),
            // Node N
            AlgorithmNode(
                id: "stabilize_coagulopathy",
                title: "Stabilize & Correct Coagulopathy",
                nodeType: .intervention,
                critical: false,
                content: "Bleeding controlled. Correct coagulopathy and optimize hemostasis",
                connections: ["icu_admission"]
            ),
            // Node O
            AlgorithmNode(
                id: "bp_stable_check",
                title: "BP Stable?",
                nodeType: .decision,
                critical: false,
                content: "Reassess hemodynamic stability after interventions",
                connections: ["find_treat_cause", "start_vasopressors"]
            ),
            // Node P
            AlgorithmNode(
                id: "find_treat_cause",
                title: "Find/Treat Cause & Wean Support",
                nodeType: .intervention,
                critical: false,
                content: "Patient stabilized. Identify and treat underlying cause, wean hemodynamic support",
                connections: ["disposition"]
            ),
            // Node Q
            AlgorithmNode(
                id: "shock_type_classification",
                title: "Shock Type?",
                nodeType: .decision,
                critical: false,
                content: "Non-hemorrhagic shock present. Determine specific etiology: septic, cardiogenic, anaphylactic",
                connections: ["antibiotics_source", "echo_inotropes", "epinephrine_steroids"]
            ),
            // Node R
            AlgorithmNode(
                id: "antibiotics_source",
                title: "Antibiotics & Source Control",
                nodeType: .medication,
                critical: false,
                content: "Septic shock management: broad-spectrum antibiotics and source control",
                connections: []
            ),
            // Node S
            AlgorithmNode(
                id: "echo_inotropes",
                title: "Echo Cards & Inotropes",
                nodeType: .intervention,
                critical: false,
                content: "Cardiogenic shock: echocardiography and inotropic support",
                connections: []
            ),
            // Node T
            AlgorithmNode(
                id: "epinephrine_steroids",
                title: "Epinephrine & Steroids",
                nodeType: .medication,
                critical: false,
                content: "Anaphylactic shock: epinephrine IM/IV and corticosteroids",
                connections: []
            ),
            // Node U
            AlgorithmNode(
                id: "damage_control",
                title: "Damage Control Surgery/Embolization",
                nodeType: .intervention,
                critical: true,
                content: "Immediate surgical or interventional radiology intervention for hemorrhage control",
                connections: ["icu_admission"]
            ),
            // Node V
            AlgorithmNode(
                id: "icu_admission",
                title: "ICU Admission & Monitor Hgb",
                nodeType: .endpoint,
                critical: false,
                content: "Patient stabilized. Continue monitoring and supportive care in ICU setting",
                connections: []
            ),
            // Node W
            AlgorithmNode(
                id: "disposition",
                title: "Disposition per Underlying Cause",
                nodeType: .endpoint,
                critical: false,
                content: "Determine appropriate disposition based on underlying etiology and response to treatment",
                connections: []
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "actions_card",
                type: .actions,
                title: "Massive Transfusion Protocol",
                sections: [
                    CardSection(title: "Activation Criteria", items: [
                        "SBP <90 despite 2L crystalloid",
                        "Need for uncrossmatched blood",
                        "Anticipated >4 units PRBCs in 1 hour",
                        "Obvious massive hemorrhage"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "rrt_hypotension_hemorrhage",
            title: "Hypotension & Hemorrhage",
            icon: "arrow.down.heart.fill", // Hypotension/hemorrhage
            category: .cardiac,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createFallsAssessmentProtocol() async -> EmergencyProtocol {
        // Falls Assessment - Injury evaluation with anticoagulation considerations
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "trauma_assessment",
                title: "Primary Survey",
                nodeType: .assessment,
                critical: true,
                content: "ABCDE assessment, C-spine precautions if indicated",
                connections: ["head_injury_check"]
            ),
            AlgorithmNode(
                id: "head_injury_check",
                title: "Head Injury Assessment",
                nodeType: .decision,
                critical: true,
                content: "LOC, amnesia, anticoagulation status, visible trauma",
                connections: ["ct_head_indicated", "observation"]
            ),
            AlgorithmNode(
                id: "ct_head_indicated",
                title: "CT Head Indicated",
                nodeType: .intervention,
                critical: true,
                content: "Order CT head for: anticoagulation, LOC, focal neuro deficits, age >65",
                connections: []
            ),
            AlgorithmNode(
                id: "observation",
                title: "Observation",
                nodeType: .intervention,
                critical: false,
                content: "Neuro checks q2h, fall risk assessment, PT/OT evaluation",
                connections: []
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "assessment_card",
                type: .assessment,
                title: "Canadian CT Head Rule",
                sections: [
                    CardSection(title: "High Risk (CT Required)", items: [
                        "GCS <15 at 2 hours post-injury",
                        "Suspected skull fracture",
                        "Any sign of basal skull fracture",
                        "≥2 episodes of vomiting",
                        "Age ≥65 years"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "rrt_falls_assessment",
            title: "Falls Assessment",
            icon: "figure.fall", // Falls assessment
            category: .trauma,
            algorithm: algorithm,
            cards: cards
        )
    }
}