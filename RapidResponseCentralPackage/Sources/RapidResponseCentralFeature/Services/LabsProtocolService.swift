import Foundation
import SwiftUI

// MARK: - Labs Protocol Service

@MainActor
public class LabsProtocolService: ObservableObject {
    @Published public private(set) var protocols: [EmergencyProtocol] = []
    @Published public private(set) var isLoading = false
    
    public init() {
        loadLabsProtocols()
    }
    
    private func loadLabsProtocols() {
        isLoading = true
        defer { isLoading = false }
        
        protocols = createLabsProtocols()
    }
    
    private func createLabsProtocols() -> [EmergencyProtocol] {
        return [
            // Hematology
            createAnemiaProtocol(),
            createCoagulopathyProtocol(),
            createThrombocytopeniaProtocol(),
            
            // Chemistry - Electrolytes
            createHypernatremiaProtocol(),
            createHyponatremiaProtocol(),
            createHyperkalemiaProtocol(),
            createHypokalemiaProtocol(),
            createHypocalcemiaProtocol(),
            createHypercalcemiaProtocol(),
            createHypomagnesemiaProtocol(),
            createHypophosphatemiaProtocol(),
            
            // Chemistry - Metabolic
            createHyperglycemiaProtocol(),
            createHypoglycemiaLabProtocol(),
            createRenalFailureProtocol(),
            createHepaticEncephalopathyProtocol(),
            
            // Blood Gas
            createABGAnalysisProtocol(),
            createAcidBaseProtocol(),
            createVentilatorAdjustmentProtocol()
        ]
    }
    
    // MARK: - Hematology Protocols
    
    private func createAnemiaProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "anemia_recognition",
                title: "Anemia Recognition",
                nodeType: .assessment,
                critical: true,
                content: "Hemoglobin <13 g/dL (men) or <12 g/dL (women). Click to assess severity and type.",
                connections: ["severity_assessment"]
            ),
            AlgorithmNode(
                id: "severity_assessment",
                title: "Severity Assessment",
                nodeType: .decision,
                critical: true,
                content: "Mild (Hgb 10-12), Moderate (8-10), or Severe (<8)? Click to determine transfusion needs.",
                connections: ["transfusion_decision", "workup"]
            ),
            AlgorithmNode(
                id: "transfusion_decision",
                title: "Transfusion Decision",
                nodeType: .intervention,
                critical: true,
                content: "Type & crossmatch. Transfuse if Hgb <7 or symptomatic. Click for transfusion protocol.",
                connections: ["post_transfusion"]
            ),
            AlgorithmNode(
                id: "workup",
                title: "Anemia Workup",
                nodeType: .assessment,
                critical: false,
                content: "CBC with differential, reticulocyte count, iron studies. Click for detailed workup.",
                connections: ["specific_treatment"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Anemia Management",
                sections: [
                    CardSection(title: "Transfusion Thresholds", items: [
                        "Hgb <7 g/dL: Transfuse in stable patients",
                        "Hgb <8 g/dL: Consider in cardiac disease",
                        "Symptomatic anemia: Transfuse regardless of level"
                    ])
                ]
            ),
            ProtocolCard(
                id: "assessment_card",
                type: .assessment,
                title: "Anemia Classification",
                sections: [
                    CardSection(title: "MCV-Based Classification", items: [
                        "Microcytic (<80): Iron deficiency, thalassemia",
                        "Normocytic (80-100): Chronic disease, hemolysis",
                        "Macrocytic (>100): B12/folate deficiency, alcohol"
                    ])
                ]
            ),
            ProtocolCard(
                id: "actions_card",
                type: .actions,
                title: "Blood Bank Protocols",
                sections: [
                    CardSection(title: "Transfusion Orders", items: [
                        "Type & crossmatch 2 units PRBC",
                        "Transfuse 1 unit over 2-4 hours",
                        "Recheck Hgb 6 hours post-transfusion"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "anemia",
            title: "Anemia Workup & Transfusion",
            icon: "bx-donate-blood",
            category: .infectious,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createCoagulopathyProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "coagulopathy_assessment",
                title: "Coagulopathy Assessment",
                nodeType: .assessment,
                critical: true,
                content: "INR >1.5, PTT >40s, or clinical bleeding. Click to assess bleeding risk.",
                connections: ["bleeding_risk"]
            ),
            AlgorithmNode(
                id: "bleeding_risk",
                title: "Bleeding Risk Stratification",
                nodeType: .decision,
                critical: true,
                content: "Active bleeding, high-risk procedure, or asymptomatic? Click for management pathway.",
                connections: ["active_bleeding", "reversal_agents"]
            ),
            AlgorithmNode(
                id: "active_bleeding",
                title: "Active Bleeding Management",
                nodeType: .intervention,
                critical: true,
                content: "FFP, PCC, or specific reversal agents. Click for dosing protocols.",
                connections: ["monitor_response"]
            ),
            AlgorithmNode(
                id: "reversal_agents",
                title: "Anticoagulation Reversal",
                nodeType: .medication,
                critical: true,
                content: "Warfarin: Vitamin K ± PCC. DOAC: Specific antidotes. Click for details.",
                connections: ["recheck_labs"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "INR Correction",
                sections: [
                    CardSection(title: "Correction Targets", items: [
                        "Emergency surgery: INR <1.5",
                        "Major bleeding: INR <2.0",
                        "Minor procedures: INR <2.5"
                    ])
                ]
            ),
            ProtocolCard(
                id: "actions_card",
                type: .actions,
                title: "Reversal Protocols",
                sections: [
                    CardSection(title: "Warfarin Reversal", items: [
                        "Vitamin K 10mg IV/PO",
                        "4-factor PCC 25-50 units/kg",
                        "FFP 15ml/kg if no PCC available"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "coagulopathy",
            title: "Coagulopathy & INR Management",
            icon: "bx-test-tube",
            category: .infectious,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createThrombocytopeniaProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "thrombocytopenia_recognition",
                title: "Thrombocytopenia Recognition",
                nodeType: .assessment,
                critical: true,
                content: "Platelet count <150k. Assess for bleeding risk and cause. Click for severity grading.",
                connections: ["severity_grading"]
            ),
            AlgorithmNode(
                id: "severity_grading",
                title: "Severity Assessment",
                nodeType: .decision,
                critical: true,
                content: "Mild (100-150k), Moderate (50-100k), or Severe (<50k)? Click for transfusion criteria.",
                connections: ["platelet_transfusion", "cause_workup"]
            ),
            AlgorithmNode(
                id: "platelet_transfusion",
                title: "Platelet Transfusion",
                nodeType: .intervention,
                critical: true,
                content: "Transfuse if <10k or bleeding. Higher thresholds for procedures. Click for protocols.",
                connections: ["post_transfusion_count"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Platelet Transfusion Criteria",
                sections: [
                    CardSection(title: "Transfusion Thresholds", items: [
                        "<10k: Prophylactic transfusion",
                        "<50k: Major surgery/bleeding",
                        "<100k: Neurosurgery/ophthalmology"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "thrombocytopenia",
            title: "Thrombocytopenia Management",
            icon: "bx-test-tube",
            category: .infectious,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    // MARK: - Chemistry Protocols - Electrolytes
    
    private func createHypernatremiaProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "hypernatremia_recognition",
                title: "Hypernatremia Recognition",
                nodeType: .assessment,
                critical: true,
                content: "Serum Na >145 mEq/L. Assess volume status and neurologic symptoms. Click to evaluate.",
                connections: ["volume_assessment"]
            ),
            AlgorithmNode(
                id: "volume_assessment",
                title: "Volume Status Assessment",
                nodeType: .decision,
                critical: true,
                content: "Hypovolemic, euvolemic, or hypervolemic? Click to determine correction strategy.",
                connections: ["correction_rate", "fluid_choice"]
            ),
            AlgorithmNode(
                id: "correction_rate",
                title: "Correction Rate Calculation",
                nodeType: .assessment,
                critical: true,
                content: "Correct at 0.5 mEq/L/hr (max 12 mEq/L/day). Click for water deficit calculation.",
                connections: ["monitor_sodium"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Hypernatremia Correction",
                sections: [
                    CardSection(title: "Correction Principles", items: [
                        "Rate: 0.5 mEq/L/hr maximum",
                        "Daily limit: 12 mEq/L per day",
                        "Monitor for cerebral edema"
                    ])
                ]
            ),
            ProtocolCard(
                id: "actions_card",
                type: .actions,
                title: "Water Deficit Calculation",
                sections: [
                    CardSection(title: "Formula", items: [
                        "Water deficit = 0.6 × weight × (Na/140 - 1)",
                        "Replace over 48-72 hours",
                        "Use D5W or hypotonic saline"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "hypernatremia",
            title: "Hypernatremia Management",
            icon: "bx-water",
            category: .infectious,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createHyponatremiaProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "hyponatremia_recognition",
                title: "Hyponatremia Recognition",
                nodeType: .assessment,
                critical: true,
                content: "Serum Na <135 mEq/L. Assess symptoms and chronicity. Click for severity assessment.",
                connections: ["symptom_assessment"]
            ),
            AlgorithmNode(
                id: "symptom_assessment",
                title: "Symptom Assessment",
                nodeType: .decision,
                critical: true,
                content: "Severe symptoms (seizures, coma) or mild/asymptomatic? Click for treatment pathway.",
                connections: ["severe_treatment", "chronic_management"]
            ),
            AlgorithmNode(
                id: "severe_treatment",
                title: "Severe Hyponatremia Treatment",
                nodeType: .intervention,
                critical: true,
                content: "3% saline 150ml over 20 min. Repeat if needed. Click for correction limits.",
                connections: ["correction_monitoring"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Hyponatremia Correction",
                sections: [
                    CardSection(title: "Correction Limits", items: [
                        "Acute: 1-2 mEq/L/hr for 3-4 hours",
                        "Chronic: 0.5 mEq/L/hr maximum",
                        "Daily max: 8-12 mEq/L per day"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "hyponatremia",
            title: "Hyponatremia Management",
            icon: "bx-water",
            category: .infectious,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createHyperkalemiaProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "hyperkalemia_recognition",
                title: "Hyperkalemia Recognition",
                nodeType: .assessment,
                critical: true,
                content: "Serum K >5.5 mEq/L. Check ECG for cardiac toxicity. Click for ECG assessment.",
                connections: ["ecg_assessment"]
            ),
            AlgorithmNode(
                id: "ecg_assessment",
                title: "ECG Assessment",
                nodeType: .decision,
                critical: true,
                content: "ECG changes present? Peaked T waves, widened QRS? Click for treatment urgency.",
                connections: ["cardiac_protection", "potassium_removal"]
            ),
            AlgorithmNode(
                id: "cardiac_protection",
                title: "Cardiac Membrane Stabilization",
                nodeType: .medication,
                critical: true,
                content: "Calcium gluconate 1-2g IV over 2-5 minutes. Click for repeat dosing criteria.",
                connections: ["potassium_shifts"]
            ),
            AlgorithmNode(
                id: "potassium_shifts",
                title: "Intracellular K+ Shift",
                nodeType: .medication,
                critical: true,
                content: "Insulin 10 units + D50W 25g IV. Albuterol nebulizer. Click for monitoring.",
                connections: ["potassium_removal"]
            ),
            AlgorithmNode(
                id: "potassium_removal",
                title: "Potassium Removal",
                nodeType: .intervention,
                critical: false,
                content: "Kayexalate, diuretics, or dialysis. Click for removal options.",
                connections: ["recheck_levels"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Hyperkalemia Treatment",
                sections: [
                    CardSection(title: "Treatment Sequence", items: [
                        "1. Cardiac protection (Calcium)",
                        "2. K+ shifts (Insulin/D50, Albuterol)",
                        "3. K+ removal (Kayexalate, dialysis)"
                    ])
                ]
            ),
            ProtocolCard(
                id: "assessment_card",
                type: .assessment,
                title: "ECG Changes",
                sections: [
                    CardSection(title: "Progressive ECG Changes", items: [
                        "Peaked T waves (earliest)",
                        "PR prolongation, P wave flattening",
                        "QRS widening, sine wave pattern"
                    ])
                ]
            ),
            ProtocolCard(
                id: "actions_card",
                type: .actions,
                title: "Emergency Medications",
                sections: [
                    CardSection(title: "Cardiac Protection", items: [
                        "Calcium gluconate 1-2g IV",
                        "Onset: immediate, duration: 30-60 min",
                        "Repeat if ECG changes persist"
                    ]),
                    CardSection(title: "K+ Shifting", items: [
                        "Insulin 10 units + D50W 25g IV",
                        "Albuterol 10-20mg nebulized",
                        "Monitor glucose closely"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "hyperkalemia",
            title: "Hyperkalemia Management",
            icon: "bx-pulse",
            category: .cardiac,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createHypokalemiaProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "hypokalemia_recognition",
                title: "Hypokalemia Recognition",
                nodeType: .assessment,
                critical: true,
                content: "Serum K <3.5 mEq/L. Assess for cardiac arrhythmias and weakness. Click for severity.",
                connections: ["severity_assessment"]
            ),
            AlgorithmNode(
                id: "severity_assessment",
                title: "Severity Assessment",
                nodeType: .decision,
                critical: true,
                content: "Severe (<2.5), moderate (2.5-3.0), or mild (3.0-3.5)? Click for replacement strategy.",
                connections: ["iv_replacement", "oral_replacement"]
            ),
            AlgorithmNode(
                id: "iv_replacement",
                title: "IV Potassium Replacement",
                nodeType: .medication,
                critical: true,
                content: "KCl 20-40 mEq in 100mL NS over 1-2 hours. Click for infusion rates.",
                connections: ["magnesium_check"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Potassium Replacement",
                sections: [
                    CardSection(title: "Replacement Guidelines", items: [
                        "20 mEq raises serum K by ~0.25 mEq/L",
                        "Maximum: 20 mEq/hr via peripheral IV",
                        "Central line: up to 40 mEq/hr"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "hypokalemia",
            title: "Hypokalemia Management",
            icon: "bx-pulse",
            category: .cardiac,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createHypocalcemiaProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "hypocalcemia_recognition",
                title: "Hypocalcemia Recognition",
                nodeType: .assessment,
                critical: true,
                content: "Ionized Ca <1.15 mmol/L. Check for Chvostek/Trousseau signs. Click for symptoms.",
                connections: ["symptom_severity"]
            ),
            AlgorithmNode(
                id: "symptom_severity",
                title: "Symptom Assessment",
                nodeType: .decision,
                critical: true,
                content: "Severe (tetany, seizures) or mild (paresthesias)? Click for treatment approach.",
                connections: ["iv_calcium", "oral_calcium"]
            ),
            AlgorithmNode(
                id: "iv_calcium",
                title: "IV Calcium Replacement",
                nodeType: .medication,
                critical: true,
                content: "Calcium gluconate 1-2g IV over 10-20 minutes. Click for repeat criteria.",
                connections: ["magnesium_replacement"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Calcium Replacement",
                sections: [
                    CardSection(title: "IV Calcium Options", items: [
                        "Calcium gluconate: 1-2g IV (preferred)",
                        "Calcium chloride: 1g IV (central line only)",
                        "Repeat q6-8hrs as needed"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "hypocalcemia",
            title: "Hypocalcemia Management",
            icon: "bx-bone",
            category: .infectious,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createHypercalcemiaProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "hypercalcemia_recognition",
                title: "Hypercalcemia Recognition",
                nodeType: .assessment,
                critical: true,
                content: "Serum Ca >10.5 mg/dL. Assess for malignancy or hyperparathyroidism. Click to evaluate.",
                connections: ["severity_symptoms"]
            ),
            AlgorithmNode(
                id: "severity_symptoms",
                title: "Symptom Assessment",
                nodeType: .decision,
                critical: true,
                content: "Severe symptoms (altered mental status, Ca >14)? Click for treatment urgency.",
                connections: ["aggressive_treatment", "conservative_management"]
            ),
            AlgorithmNode(
                id: "aggressive_treatment",
                title: "Aggressive Treatment",
                nodeType: .intervention,
                critical: true,
                content: "IV saline hydration + calcitonin + bisphosphonates. Click for protocols.",
                connections: ["monitor_response"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Hypercalcemia Treatment",
                sections: [
                    CardSection(title: "Treatment Steps", items: [
                        "1. IV saline hydration",
                        "2. Calcitonin for rapid effect",
                        "3. Bisphosphonates for sustained effect"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "hypercalcemia",
            title: "Hypercalcemia Management",
            icon: "bx-bone",
            category: .infectious,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createHypomagnesemiaProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "hypomagnesemia_recognition",
                title: "Hypomagnesemia Recognition",
                nodeType: .assessment,
                critical: true,
                content: "Serum Mg <1.7 mg/dL. Often coexists with hypokalemia/hypocalcemia. Click to assess.",
                connections: ["electrolyte_check"]
            ),
            AlgorithmNode(
                id: "electrolyte_check",
                title: "Associated Electrolyte Abnormalities",
                nodeType: .assessment,
                critical: true,
                content: "Check K+ and Ca2+ levels. Mg replacement needed for K+/Ca2+ correction. Click for protocol.",
                connections: ["mg_replacement"]
            ),
            AlgorithmNode(
                id: "mg_replacement",
                title: "Magnesium Replacement",
                nodeType: .medication,
                critical: true,
                content: "MgSO4 2g IV over 2 hours. Repeat based on levels. Click for dosing.",
                connections: ["recheck_electrolytes"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Magnesium Replacement",
                sections: [
                    CardSection(title: "Replacement Protocol", items: [
                        "MgSO4 2g IV over 2 hours",
                        "Repeat q12hrs until Mg >1.7",
                        "Recheck levels after each dose"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "hypomagnesemia",
            title: "Hypomagnesemia Management",
            icon: "bx-test-tube",
            category: .infectious,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createHypophosphatemiaProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "hypophosphatemia_recognition",
                title: "Hypophosphatemia Recognition",
                nodeType: .assessment,
                critical: true,
                content: "Serum PO4 <2.5 mg/dL. Assess for refeeding syndrome risk. Click for severity.",
                connections: ["severity_assessment"]
            ),
            AlgorithmNode(
                id: "severity_assessment",
                title: "Severity Assessment",
                nodeType: .decision,
                critical: true,
                content: "Severe (<1.0), moderate (1.0-2.0), or mild (2.0-2.5)? Click for replacement.",
                connections: ["iv_phosphorus", "oral_phosphorus"]
            ),
            AlgorithmNode(
                id: "iv_phosphorus",
                title: "IV Phosphorus Replacement",
                nodeType: .medication,
                critical: true,
                content: "Sodium phosphate 0.08-0.16 mmol/kg IV over 6 hours. Click for monitoring.",
                connections: ["calcium_monitoring"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Phosphorus Replacement",
                sections: [
                    CardSection(title: "Replacement Guidelines", items: [
                        "Severe: IV replacement over 6-12 hours",
                        "Monitor calcium during replacement",
                        "Avoid rapid correction"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "hypophosphatemia",
            title: "Hypophosphatemia Management",
            icon: "bx-test-tube",
            category: .infectious,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    // MARK: - Chemistry Protocols - Metabolic
    
    private func createHyperglycemiaProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "hyperglycemia_recognition",
                title: "Hyperglycemia Assessment",
                nodeType: .assessment,
                critical: true,
                content: "Glucose >250 mg/dL. Check for DKA/HHS. Click to assess ketosis and mental status.",
                connections: ["dka_hhs_assessment"]
            ),
            AlgorithmNode(
                id: "dka_hhs_assessment",
                title: "DKA/HHS Assessment",
                nodeType: .decision,
                critical: true,
                content: "Ketones present? pH <7.3? Altered mental status? Click for specific protocols.",
                connections: ["dka_protocol", "hhs_protocol", "simple_hyperglycemia"]
            ),
            AlgorithmNode(
                id: "dka_protocol",
                title: "DKA Protocol",
                nodeType: .intervention,
                critical: true,
                content: "Fluid resuscitation + insulin infusion + electrolyte management. Click for details.",
                connections: ["monitor_anion_gap"]
            ),
            AlgorithmNode(
                id: "hhs_protocol",
                title: "HHS Protocol",
                nodeType: .intervention,
                critical: true,
                content: "Aggressive fluid resuscitation, careful insulin use. Click for hyperosmolar management.",
                connections: ["monitor_osmolality"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Hyperglycemic Emergencies",
                sections: [
                    CardSection(title: "DKA vs HHS", items: [
                        "DKA: Ketones +, pH <7.3, younger patients",
                        "HHS: Glucose >600, osmolality >320, elderly",
                        "Mixed presentations possible"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "hyperglycemia_dka_hhs",
            title: "Hyperglycemia/DKA/HHS",
            icon: "bx-test-tube",
            category: .infectious,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createHypoglycemiaLabProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "hypoglycemia_lab_recognition",
                title: "Hypoglycemia Recognition",
                nodeType: .assessment,
                critical: true,
                content: "Glucose <70 mg/dL with Whipple's triad. Click to assess consciousness level.",
                connections: ["consciousness_assessment"]
            ),
            AlgorithmNode(
                id: "consciousness_assessment",
                title: "Consciousness Assessment",
                nodeType: .decision,
                critical: true,
                content: "Patient conscious and able to swallow? Click for treatment route.",
                connections: ["oral_treatment", "iv_treatment"]
            ),
            AlgorithmNode(
                id: "iv_treatment",
                title: "IV Glucose Treatment",
                nodeType: .medication,
                critical: true,
                content: "D50W 25g IV push. Recheck glucose in 15 minutes. Click for repeat dosing.",
                connections: ["glucose_monitoring"]
            ),
            AlgorithmNode(
                id: "oral_treatment",
                title: "Oral Glucose Treatment",
                nodeType: .intervention,
                critical: false,
                content: "15g fast-acting carbs. Recheck in 15 min, repeat if needed. Click for options.",
                connections: ["glucose_monitoring"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Hypoglycemia Treatment",
                sections: [
                    CardSection(title: "Treatment Options", items: [
                        "Conscious: 15g PO carbs (juice, glucose tabs)",
                        "Unconscious: D50W 25g IV push",
                        "No IV access: Glucagon 1mg IM/SC"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "hypoglycemia_lab",
            title: "Hypoglycemia (Lab Values)",
            icon: "bx-test-tube",
            category: .infectious,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createRenalFailureProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "renal_failure_recognition",
                title: "Renal Failure Recognition",
                nodeType: .assessment,
                critical: true,
                content: "Rising creatinine, decreased GFR, oliguria. Click to classify AKI vs CKD.",
                connections: ["aki_vs_ckd"]
            ),
            AlgorithmNode(
                id: "aki_vs_ckd",
                title: "AKI vs CKD Classification",
                nodeType: .decision,
                critical: true,
                content: "Acute (hours-days) vs chronic (months-years)? Click for management pathway.",
                connections: ["aki_management", "ckd_management"]
            ),
            AlgorithmNode(
                id: "aki_management",
                title: "AKI Management",
                nodeType: .intervention,
                critical: true,
                content: "Identify cause, optimize fluid status, avoid nephrotoxins. Click for staging.",
                connections: ["dialysis_criteria"]
            ),
            AlgorithmNode(
                id: "dialysis_criteria",
                title: "Dialysis Criteria Assessment",
                nodeType: .decision,
                critical: true,
                content: "AEIOU criteria met? Click to evaluate need for urgent dialysis.",
                connections: ["urgent_dialysis", "conservative_management"]
            ),
            AlgorithmNode(
                id: "urgent_dialysis",
                title: "Urgent Dialysis",
                nodeType: .intervention,
                critical: true,
                content: "Contact nephrology for emergent dialysis. Click for temporary access.",
                connections: ["post_dialysis_care"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Renal Failure Management",
                sections: [
                    CardSection(title: "Dialysis Criteria (AEIOU)", items: [
                        "Acidosis (pH <7.1)",
                        "Electrolytes (K >6.5)",
                        "Intoxication (methanol, ethylene glycol)",
                        "Overload (pulmonary edema)",
                        "Uremia (encephalopathy, pericarditis)"
                    ])
                ]
            ),
            ProtocolCard(
                id: "assessment_card",
                type: .assessment,
                title: "AKI Staging",
                sections: [
                    CardSection(title: "KDIGO AKI Stages", items: [
                        "Stage 1: Cr 1.5-1.9x baseline",
                        "Stage 2: Cr 2.0-2.9x baseline",
                        "Stage 3: Cr ≥3x baseline or >4 mg/dL"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "renal_failure",
            title: "Renal Failure & Dialysis",
            icon: "bx-pulse",
            category: .infectious,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createHepaticEncephalopathyProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "he_recognition",
                title: "Hepatic Encephalopathy Recognition",
                nodeType: .assessment,
                critical: true,
                content: "Altered mental status in liver disease. Grade asterixis and confusion. Click for staging.",
                connections: ["he_staging"]
            ),
            AlgorithmNode(
                id: "he_staging",
                title: "HE Staging Assessment",
                nodeType: .decision,
                critical: true,
                content: "Grade 1-4 based on confusion, asterixis, coma. Click for precipitant identification.",
                connections: ["precipitant_search", "lactulose_treatment"]
            ),
            AlgorithmNode(
                id: "precipitant_search",
                title: "Precipitant Identification",
                nodeType: .assessment,
                critical: true,
                content: "GI bleeding, infection, constipation, medications? Click to address causes.",
                connections: ["treat_precipitants"]
            ),
            AlgorithmNode(
                id: "lactulose_treatment",
                title: "Lactulose Treatment",
                nodeType: .medication,
                critical: true,
                content: "Lactulose 30ml PO q2hrs until bowel movement, then q6hrs. Click for dosing.",
                connections: ["rifaximin_consideration"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Hepatic Encephalopathy",
                sections: [
                    CardSection(title: "Treatment Goals", items: [
                        "2-3 soft bowel movements daily",
                        "Ammonia reduction (not routinely monitored)",
                        "Identify and treat precipitants"
                    ])
                ]
            ),
            ProtocolCard(
                id: "assessment_card",
                type: .assessment,
                title: "HE Grading",
                sections: [
                    CardSection(title: "West Haven Criteria", items: [
                        "Grade 1: Mild confusion, euphoria",
                        "Grade 2: Lethargy, disorientation",
                        "Grade 3: Marked confusion, stupor",
                        "Grade 4: Coma"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "hepatic_encephalopathy",
            title: "Hepatic Encephalopathy",
            icon: "bx-brain",
            category: .neurological,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    // MARK: - Blood Gas Protocols
    
    private func createABGAnalysisProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "abg_interpretation",
                title: "ABG Interpretation",
                nodeType: .assessment,
                critical: true,
                content: "Analyze pH, pCO2, HCO3, anion gap systematically. Click for step-by-step analysis.",
                connections: ["ph_assessment"]
            ),
            AlgorithmNode(
                id: "ph_assessment",
                title: "pH Assessment",
                nodeType: .decision,
                critical: true,
                content: "pH <7.35 (acidosis) or >7.45 (alkalosis)? Click to determine primary disorder.",
                connections: ["acidosis_workup", "alkalosis_workup"]
            ),
            AlgorithmNode(
                id: "acidosis_workup",
                title: "Acidosis Classification",
                nodeType: .decision,
                critical: true,
                content: "Respiratory (high pCO2) or metabolic (low HCO3)? Click for specific workup.",
                connections: ["respiratory_acidosis", "metabolic_acidosis"]
            ),
            AlgorithmNode(
                id: "metabolic_acidosis",
                title: "Metabolic Acidosis Workup",
                nodeType: .assessment,
                critical: true,
                content: "Calculate anion gap. High gap vs normal gap causes. Click for Winter's formula.",
                connections: ["winters_formula"]
            ),
            AlgorithmNode(
                id: "winters_formula",
                title: "Winter's Formula Check",
                nodeType: .assessment,
                critical: false,
                content: "Expected pCO2 = 1.5 × [HCO3] + 8 (±2). Click to assess compensation.",
                connections: ["compensation_assessment"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "ABG Analysis Steps",
                sections: [
                    CardSection(title: "Systematic Approach", items: [
                        "1. Assess oxygenation (PaO2, A-a gradient)",
                        "2. Determine acid-base status (pH)",
                        "3. Identify primary disorder",
                        "4. Check for compensation",
                        "5. Calculate anion gap if metabolic"
                    ])
                ]
            ),
            ProtocolCard(
                id: "assessment_card",
                type: .assessment,
                title: "Compensation Rules",
                sections: [
                    CardSection(title: "Expected Compensation", items: [
                        "Metabolic acidosis: pCO2 = 1.5×[HCO3] + 8 (±2)",
                        "Metabolic alkalosis: pCO2 = 0.7×[HCO3] + 21 (±2)",
                        "Respiratory: Acute vs chronic formulas"
                    ])
                ]
            ),
            ProtocolCard(
                id: "actions_card",
                type: .actions,
                title: "Common Causes",
                sections: [
                    CardSection(title: "High Anion Gap Acidosis", items: [
                        "MUDPILES: Methanol, Uremia, DKA",
                        "Propylene glycol, Iron/Isoniazid",
                        "Lactic acidosis, Ethylene glycol, Salicylates"
                    ]),
                    CardSection(title: "Normal Gap Acidosis", items: [
                        "Diarrhea, ureteral diversions",
                        "Post-hypocapnia, carbonic anhydrase inhibitors",
                        "RTA, saline administration"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "abg_analysis",
            title: "ABG Analysis & Winter's Equation",
            icon: "bx-test-tube",
            category: .respiratory,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createAcidBaseProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "acid_base_classification",
                title: "Acid-Base Disorder Classification",
                nodeType: .assessment,
                critical: true,
                content: "Primary disorder: metabolic vs respiratory. Click to assess mixed disorders.",
                connections: ["mixed_disorder_check"]
            ),
            AlgorithmNode(
                id: "mixed_disorder_check",
                title: "Mixed Disorder Assessment",
                nodeType: .decision,
                critical: true,
                content: "Single disorder with compensation or mixed primary disorders? Click for analysis.",
                connections: ["single_disorder", "mixed_disorders"]
            ),
            AlgorithmNode(
                id: "mixed_disorders",
                title: "Mixed Disorder Management",
                nodeType: .intervention,
                critical: true,
                content: "Address each disorder separately. Prioritize by severity. Click for specific treatments.",
                connections: ["disorder_specific_treatment"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Acid-Base Disorders",
                sections: [
                    CardSection(title: "Four Primary Disorders", items: [
                        "Metabolic acidosis (↓HCO3, ↓pH)",
                        "Metabolic alkalosis (↑HCO3, ↑pH)",
                        "Respiratory acidosis (↑pCO2, ↓pH)",
                        "Respiratory alkalosis (↓pCO2, ↑pH)"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "acid_base_disorders",
            title: "Acid-Base Disorder Management",
            icon: "bx-test-tube",
            category: .respiratory,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createVentilatorAdjustmentProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "vent_assessment",
                title: "Ventilator Assessment",
                nodeType: .assessment,
                critical: true,
                content: "Current vent settings vs ABG results. Click to identify needed adjustments.",
                connections: ["oxygenation_adjustment"]
            ),
            AlgorithmNode(
                id: "oxygenation_adjustment",
                title: "Oxygenation Adjustment",
                nodeType: .decision,
                critical: true,
                content: "PaO2 target 55-80 mmHg. Adjust FiO2 or PEEP? Click for oxygen adjustment strategy.",
                connections: ["fio2_adjustment", "peep_adjustment"]
            ),
            AlgorithmNode(
                id: "ventilation_adjustment",
                title: "Ventilation Adjustment",
                nodeType: .decision,
                critical: true,
                content: "pCO2 target based on condition. Adjust rate or tidal volume? Click for CO2 management.",
                connections: ["rate_adjustment", "vt_adjustment"]
            ),
            AlgorithmNode(
                id: "fio2_adjustment",
                title: "FiO2 Adjustment",
                nodeType: .intervention,
                critical: false,
                content: "Titrate FiO2 to maintain SpO2 88-95%. Click for oxygen toxicity considerations.",
                connections: ["reassess_abg"]
            ),
            AlgorithmNode(
                id: "peep_adjustment",
                title: "PEEP Adjustment",
                nodeType: .intervention,
                critical: false,
                content: "Increase PEEP for recruitment. Monitor hemodynamics. Click for PEEP/FiO2 table.",
                connections: ["hemodynamic_monitoring"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Ventilator Adjustments",
                sections: [
                    CardSection(title: "Oxygenation Strategy", items: [
                        "Target SpO2: 88-95% (COPD: 88-92%)",
                        "First: Adjust FiO2",
                        "Then: Adjust PEEP if FiO2 >60%"
                    ])
                ]
            ),
            ProtocolCard(
                id: "assessment_card",
                type: .assessment,
                title: "Ventilation Targets",
                sections: [
                    CardSection(title: "pCO2 Targets by Condition", items: [
                        "Normal: 35-45 mmHg",
                        "COPD: 50-60 mmHg (permissive hypercapnia)",
                        "Head injury: 32-35 mmHg",
                        "ARDS: Plateau pressure <30 cmH2O"
                    ])
                ]
            ),
            ProtocolCard(
                id: "actions_card",
                type: .actions,
                title: "Adjustment Guidelines",
                sections: [
                    CardSection(title: "For Hypoxemia", items: [
                        "Increase FiO2 by 10-20%",
                        "Increase PEEP by 2-5 cmH2O",
                        "Consider recruitment maneuvers"
                    ]),
                    CardSection(title: "For Hypercarbia", items: [
                        "Increase respiratory rate",
                        "Increase tidal volume (if safe)",
                        "Decrease dead space"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "ventilator_adjustment",
            title: "Ventilator Adjustments Based on ABG",
            icon: "bx-wind",
            category: .respiratory,
            algorithm: algorithm,
            cards: cards
        )
    }
}