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
        // Chest Pain Evaluation protocol - ACS protocols with STEMI/NSTEMI pathways
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "initial_assessment",
                title: "Initial Assessment",
                nodeType: .assessment,
                critical: true,
                content: "Vital signs, 12-lead ECG within 10 minutes, focused history (PQRST)",
                connections: ["ecg_interpretation"]
            ),
            AlgorithmNode(
                id: "ecg_interpretation",
                title: "ECG Interpretation",
                nodeType: .decision,
                critical: true,
                content: "STEMI criteria: ST elevation ≥1mm in 2 contiguous leads",
                connections: ["stemi_pathway", "nstemi_acs"]
            ),
            AlgorithmNode(
                id: "stemi_pathway",
                title: "STEMI Pathway",
                nodeType: .intervention,
                critical: true,
                content: "Activate cath lab, goal door-to-balloon <90 min. Aspirin 325mg, P2Y12 inhibitor, heparin",
                connections: ["transfer_cath_lab"]
            ),
            AlgorithmNode(
                id: "nstemi_acs",
                title: "NSTEMI/UA Evaluation",
                nodeType: .assessment,
                critical: false,
                content: "Troponins, risk stratification (TIMI/GRACE score), serial ECGs",
                connections: ["medical_management"]
            ),
            AlgorithmNode(
                id: "medical_management",
                title: "Medical Management",
                nodeType: .medication,
                critical: false,
                content: "Aspirin 325mg, nitroglycerin SL, morphine PRN, beta-blocker if no contraindications",
                connections: []
            ),
            AlgorithmNode(
                id: "transfer_cath_lab",
                title: "Transfer to Cath Lab",
                nodeType: .endpoint,
                critical: true,
                content: "Emergent cardiac catheterization for primary PCI",
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
            icon: "healthicon-stethoscope",
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
                title: "Initial Assessment",
                nodeType: .assessment,
                critical: true,
                content: "ABC assessment, SpO2, RR, work of breathing, ABG if indicated",
                connections: ["hypoxia_severity"]
            ),
            AlgorithmNode(
                id: "hypoxia_severity",
                title: "Assess Hypoxia Severity",
                nodeType: .decision,
                critical: true,
                content: "SpO2 <90% or PaO2 <60mmHg on room air",
                connections: ["acute_respiratory_failure", "mild_hypoxia"]
            ),
            AlgorithmNode(
                id: "acute_respiratory_failure",
                title: "Acute Respiratory Failure",
                nodeType: .intervention,
                critical: true,
                content: "High-flow O2, consider BiPAP/CPAP, prepare for intubation if needed",
                connections: ["bipap_trial"]
            ),
            AlgorithmNode(
                id: "bipap_trial",
                title: "BiPAP Trial",
                nodeType: .intervention,
                critical: false,
                content: "Start BiPAP 10/5, titrate IPAP/EPAP based on response",
                connections: []
            ),
            AlgorithmNode(
                id: "mild_hypoxia",
                title: "Mild Hypoxia Management",
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
            id: "rrt_shortness_breath",
            title: "Shortness of Breath/Hypoxia",
            icon: "healthicon-oxygen_tank",
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
                title: "Check Blood Glucose",
                nodeType: .decision,
                critical: true,
                content: "Fingerstick glucose - hypoglycemia is reversible cause",
                connections: ["hypoglycemia_treatment", "other_causes"]
            ),
            AlgorithmNode(
                id: "hypoglycemia_treatment",
                title: "Treat Hypoglycemia",
                nodeType: .medication,
                critical: true,
                content: "D50 1 amp IV if glucose <70mg/dL",
                connections: []
            ),
            AlgorithmNode(
                id: "other_causes",
                title: "Evaluate Other Causes",
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
            id: "rrt_altered_mental",
            title: "Altered Mental Status",
            icon: "bx-brain",
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
                title: "Unstable Tachycardia",
                nodeType: .intervention,
                critical: true,
                content: "Synchronized cardioversion: 100J → 200J → 300J → 360J",
                connections: []
            ),
            AlgorithmNode(
                id: "stable_tachycardia",
                title: "Stable - Assess QRS",
                nodeType: .decision,
                critical: false,
                content: "Wide QRS (≥0.12s) vs Narrow QRS (<0.12s)",
                connections: ["wide_qrs", "narrow_qrs"]
            ),
            AlgorithmNode(
                id: "wide_qrs",
                title: "Wide Complex Tachycardia",
                nodeType: .medication,
                critical: false,
                content: "Amiodarone 150mg IV over 10 min",
                connections: []
            ),
            AlgorithmNode(
                id: "narrow_qrs",
                title: "Narrow Complex Tachycardia",
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
            icon: "healthicon-blood_pressure_monitor",
            category: .cardiac,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createHypotensionHemorrhageProtocol() async -> EmergencyProtocol {
        // Hypotension & Hemorrhage - Massive transfusion protocol activation
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "shock_assessment",
                title: "Assess Shock Type",
                nodeType: .assessment,
                critical: true,
                content: "Determine: Hemorrhagic vs Septic vs Cardiogenic vs Obstructive",
                connections: ["hemorrhage_pathway", "other_shock"]
            ),
            AlgorithmNode(
                id: "hemorrhage_pathway",
                title: "Hemorrhage Protocol",
                nodeType: .intervention,
                critical: true,
                content: "Activate massive transfusion protocol if indicated. Target SBP >90mmHg",
                connections: ["blood_products"]
            ),
            AlgorithmNode(
                id: "blood_products",
                title: "Blood Product Resuscitation",
                nodeType: .medication,
                critical: true,
                content: "1:1:1 ratio - PRBCs:FFP:Platelets. Consider TXA 1g IV",
                connections: []
            ),
            AlgorithmNode(
                id: "other_shock",
                title: "Non-Hemorrhagic Shock",
                nodeType: .intervention,
                critical: false,
                content: "IV fluid resuscitation, vasopressors if needed (norepinephrine first-line)",
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
            icon: "healthicon-blood_bag",
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
            icon: "bx-injury",
            category: .trauma,
            algorithm: algorithm,
            cards: cards
        )
    }
}