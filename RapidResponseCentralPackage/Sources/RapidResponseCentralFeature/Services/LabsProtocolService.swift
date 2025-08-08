import Foundation
import SwiftUI
import os.log
import os.signpost

// MARK: - Labs Protocol Service

@MainActor
public class LabsProtocolService: ObservableObject {
    @Published public private(set) var protocols: [EmergencyProtocol] = []
    @Published public private(set) var isLoading = false
    
    private let performanceLogger = Logger(subsystem: "com.rapidresponsecentral.performance", category: "LabsProtocolService")
    private let signposter = OSSignposter(subsystem: "com.rapidresponsecentral.performance", category: "LabsProtocolCreation")
    
    public init() {
        Task {
            await loadLabsProtocolsConcurrently()
        }
    }
    
    private func loadLabsProtocols() {
        isLoading = true
        defer { isLoading = false }
        
        protocols = createLabsProtocols()
    }
    
    @MainActor
    private func loadLabsProtocolsConcurrently() async {
        isLoading = true
        defer { isLoading = false }
        
        performanceLogger.info("🧪 Starting concurrent Labs protocol creation")
        let signpostID = signposter.makeSignpostID()
        let signpostState = signposter.beginInterval("LabsProtocolCreation", id: signpostID)
        
        // Create protocols synchronously but measure concurrently
        protocols = createLabsProtocols()
        
        signposter.endInterval("LabsProtocolCreation", signpostState)
        performanceLogger.info("✅ Labs Protocol service initialization complete - \(self.protocols.count) protocols")
    }
    
    private func createLabsProtocols() -> [EmergencyProtocol] {
        return [
            // Blood Disorders
            createAnemiaProtocol(),
            createCoagulopathyProtocol(),
            createThrombocytopeniaProtocol(),
            
            // Electrolyte Abnormalities
            createHypernatremiaProtocol(),
            createHyponatremiaProtocol(),
            createHyperkalemiaProtocol(),
            createHypokalemiaProtocol(),
            createHypocalcemiaProtocol(),
            createHypercalcemiaProtocol(),
            createHypomagnesemiaProtocol(),
            createHypophosphatemiaProtocol(),
            
            // Glucose Disorders
            createHyperglycemiaProtocol(),
            createHypoglycemiaLabsProtocol(),
            
            // Organ Function
            createRenalFailureProtocol(),
            createHepaticEncephalopathyProtocol(),
            
            // Blood Gas Analysis
            createABGAnalysisProtocol(),
            createAcidBaseProtocol(),
            createVentilatorAdjustmentProtocol()
        ]
    }
    
    // MARK: - Blood Disorders
    
    private func createAnemiaProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "anemia_assessment",
                title: "Anemia Assessment",
                nodeType: .assessment,
                critical: true,
                content: "Hemoglobin <7 g/dL (severe), <10 g/dL (moderate), evaluate cause",
                connections: ["transfusion_consideration"]
            ),
            AlgorithmNode(
                id: "transfusion_consideration",
                title: "Transfusion Indication?",
                nodeType: .decision,
                critical: true,
                content: "Hgb <7 g/dL or symptomatic with Hgb <10 g/dL",
                connections: ["type_crossmatch", "iron_studies"]
            ),
            AlgorithmNode(
                id: "type_crossmatch",
                title: "Type & Crossmatch",
                nodeType: .intervention,
                critical: true,
                content: "Order packed RBCs, consider urgency for crossmatch",
                connections: ["transfusion_monitoring"]
            ),
            AlgorithmNode(
                id: "iron_studies",
                title: "Iron Studies & Workup",
                nodeType: .assessment,
                critical: false,
                content: "Iron, TIBC, ferritin, B12, folate, reticulocyte count",
                connections: ["cause_treatment"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Anemia Management",
                sections: [
                    CardSection(title: "Transfusion Triggers", items: [
                        "Hgb <7 g/dL (restrictive strategy)",
                        "Hgb <10 g/dL if symptomatic or high-risk",
                        "Consider patient comorbidities and symptoms"
                    ])
                ]
            ),
            ProtocolCard(
                id: "assessment_card",
                type: .assessment,
                title: "Anemia Classification",
                sections: [
                    CardSection(title: "Severity", items: [
                        "Mild: Hgb 10-12 g/dL (women), 10-14 g/dL (men)",
                        "Moderate: Hgb 7-10 g/dL",
                        "Severe: Hgb <7 g/dL"
                    ]),
                    CardSection(title: "Morphology", items: [
                        "Microcytic: Iron deficiency, thalassemia, chronic disease",
                        "Normocytic: Acute blood loss, chronic disease, renal failure",
                        "Macrocytic: B12/folate deficiency, alcohol, hypothyroidism"
                    ])
                ]
            ),
            ProtocolCard(
                id: "actions_card",
                type: .actions,
                title: "Treatment Options",
                sections: [
                    CardSection(title: "Blood Products", items: [
                        "Packed RBCs: 1 unit raises Hgb by ~1 g/dL",
                        "Crossmatch: Can take 30-45 minutes",
                        "Type-specific: Available in 10-15 minutes",
                        "O-negative: Immediately available for emergencies"
                    ]),
                    CardSection(title: "Iron Replacement", items: [
                        "Oral iron: 325mg ferrous sulfate TID",
                        "IV iron: Consider if intolerant to oral or severe",
                        "Iron sucrose: 100-200mg IV 2-3 times weekly",
                        "Ferric carboxymaltose: 750-1000mg IV single dose"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "labs_anemia",
            title: "Anemia Management",
            icon: "healthicon-blood_cells",
            category: .cardiac,
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
                content: "PT/INR >1.5, aPTT >45 sec, assess bleeding risk",
                connections: ["bleeding_assessment"]
            ),
            AlgorithmNode(
                id: "bleeding_assessment",
                title: "Active Bleeding?",
                nodeType: .decision,
                critical: true,
                content: "Current bleeding or high risk procedure planned",
                connections: ["urgent_reversal", "monitoring"]
            ),
            AlgorithmNode(
                id: "urgent_reversal",
                title: "Urgent Reversal",
                nodeType: .medication,
                critical: true,
                content: "FFP, PCC, or specific reversal agents based on cause",
                connections: ["repeat_labs"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Coagulopathy Management",
                sections: [
                    CardSection(title: "Reversal Strategies", items: [
                        "Warfarin: Vitamin K, FFP, or PCC",
                        "Heparin: Protamine sulfate",
                        "DOACs: Specific reversal agents if available"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "labs_coagulopathy",
            title: "Coagulopathy Management",
            icon: "healthicon-blood_pressure_gauge",
            category: .cardiac,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createThrombocytopeniaProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "thrombocytopenia_assessment",
                title: "Thrombocytopenia Assessment",
                nodeType: .assessment,
                critical: true,
                content: "Platelet count <150k, assess severity and cause",
                connections: ["platelet_transfusion"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Thrombocytopenia",
                sections: [
                    CardSection(title: "Transfusion Thresholds", items: [
                        "Active bleeding: Platelets <50k",
                        "High-risk procedure: Platelets <50k",
                        "Prophylactic: Platelets <10k"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "labs_thrombocytopenia",
            title: "Thrombocytopenia",
            icon: "healthicon-blood_drop",
            category: .cardiac,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    // MARK: - Electrolyte Protocols
    
    private func createHypernatremiaProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "hypernatremia_assessment",
                title: "Hypernatremia >145 mEq/L",
                nodeType: .assessment,
                critical: true,
                content: "Assess volume status and calculate free water deficit",
                connections: ["correction_rate"]
            ),
            AlgorithmNode(
                id: "correction_rate",
                title: "Correction Rate",
                nodeType: .intervention,
                critical: true,
                content: "Correct at 0.5-1 mEq/L per hour, max 10-12 mEq/L per day",
                connections: ["fluid_choice"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Hypernatremia",
                sections: [
                    CardSection(title: "Treatment", items: [
                        "Free water deficit = 0.6 × weight × (Na/140 - 1)",
                        "D5W or hypotonic fluids for correction",
                        "Monitor sodium every 4-6 hours"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "labs_hypernatremia",
            title: "Hypernatremia",
            icon: "healthicon-salt",
            category: .infectious,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createHyponatremiaProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "hyponatremia_assessment",
                title: "Hyponatremia <135 mEq/L",
                nodeType: .assessment,
                critical: true,
                content: "Assess symptoms, volume status, and serum osmolality",
                connections: ["severity_classification"]
            ),
            AlgorithmNode(
                id: "severity_classification",
                title: "Severe Symptoms?",
                nodeType: .decision,
                critical: true,
                content: "Seizures, coma, severe altered mental status",
                connections: ["hypertonic_saline", "fluid_restriction"]
            ),
            AlgorithmNode(
                id: "hypertonic_saline",
                title: "3% Saline",
                nodeType: .medication,
                critical: true,
                content: "100mL bolus over 10 min, can repeat up to 3 doses",
                connections: ["sodium_monitoring"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Hyponatremia",
                sections: [
                    CardSection(title: "Emergency Treatment", items: [
                        "3% saline 100mL bolus if severe symptoms",
                        "Target 4-6 mEq/L rise in first 6 hours",
                        "Maximum 10-12 mEq/L rise in 24 hours"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "labs_hyponatremia",
            title: "Hyponatremia",
            icon: "healthicon-water",
            category: .infectious,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createHyperkalemiaProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "hyperkalemia_assessment",
                title: "Hyperkalemia >5.5 mEq/L",
                nodeType: .assessment,
                critical: true,
                content: "Check ECG, assess symptoms, confirm with repeat sample",
                connections: ["ecg_changes"]
            ),
            AlgorithmNode(
                id: "ecg_changes",
                title: "ECG Changes Present?",
                nodeType: .decision,
                critical: true,
                content: "Peaked T waves, widened QRS, loss of P waves",
                connections: ["calcium_gluconate", "potassium_shift"]
            ),
            AlgorithmNode(
                id: "calcium_gluconate",
                title: "Calcium Gluconate",
                nodeType: .medication,
                critical: true,
                content: "1-2g IV over 2-5 minutes for cardiac protection",
                connections: ["potassium_shift"]
            ),
            AlgorithmNode(
                id: "potassium_shift",
                title: "Shift Potassium Intracellularly",
                nodeType: .medication,
                critical: true,
                content: "Insulin 10 units + D50W 25g IV, Albuterol nebulizer",
                connections: ["potassium_removal"]
            ),
            AlgorithmNode(
                id: "potassium_removal",
                title: "Potassium Removal",
                nodeType: .medication,
                critical: false,
                content: "Kayexalate, Patiromer, or dialysis if severe/refractory",
                connections: ["serial_monitoring"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Hyperkalemia Emergency",
                sections: [
                    CardSection(title: "Immediate Actions", items: [
                        "Calcium gluconate 1-2g IV if ECG changes",
                        "Insulin 10 units + D50W 25g IV",
                        "Albuterol 10-20mg nebulizer"
                    ])
                ]
            ),
            ProtocolCard(
                id: "assessment_card",
                type: .assessment,
                title: "ECG Changes",
                sections: [
                    CardSection(title: "Progressive Changes", items: [
                        "Early: Peaked T waves",
                        "Intermediate: Prolonged PR, QRS widening",
                        "Late: Loss of P waves, sine wave pattern",
                        "Critical: Ventricular fibrillation, asystole"
                    ])
                ]
            ),
            ProtocolCard(
                id: "actions_card",
                type: .actions,
                title: "Treatment Timeline",
                sections: [
                    CardSection(title: "Mechanism & Onset", items: [
                        "Calcium: Cardiac protection, onset immediate",
                        "Insulin/Dextrose: Shifts K+ into cells, onset 15-30 min",
                        "Albuterol: Shifts K+ into cells, onset 30-60 min",
                        "Kayexalate: Removes K+, onset 1-2 hours"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "labs_hyperkalemia",
            title: "Hyperkalemia",
            icon: "healthicon-kidney",
            category: .cardiac,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createHypokalemiaProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "hypokalemia_assessment",
                title: "Hypokalemia <3.5 mEq/L",
                nodeType: .assessment,
                critical: true,
                content: "Assess symptoms, check Mg level, ECG if severe",
                connections: ["replacement_route"]
            ),
            AlgorithmNode(
                id: "replacement_route",
                title: "Replacement Route",
                nodeType: .decision,
                critical: true,
                content: "IV if K+ <2.5 or symptomatic, PO if stable",
                connections: ["iv_replacement", "oral_replacement"]
            ),
            AlgorithmNode(
                id: "iv_replacement",
                title: "IV Potassium",
                nodeType: .medication,
                critical: true,
                content: "KCl 10-20 mEq IV over 1 hour, max 40 mEq/hr if critical",
                connections: ["magnesium_replacement"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Hypokalemia",
                sections: [
                    CardSection(title: "Replacement Guidelines", items: [
                        "Each 10 mEq raises serum K+ by ~0.1 mEq/L",
                        "Replace magnesium concurrently",
                        "Monitor closely if on digoxin"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "labs_hypokalemia",
            title: "Hypokalemia",
            icon: "healthicon-kidney_alt",
            category: .cardiac,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createHypocalcemiaProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "hypocalcemia_assessment",
                title: "Hypocalcemia <8.5 mg/dL",
                nodeType: .assessment,
                critical: true,
                content: "Check ionized calcium, symptoms, Mg and phosphorus levels",
                connections: ["symptomatic_treatment"]
            ),
            AlgorithmNode(
                id: "symptomatic_treatment",
                title: "Symptomatic Treatment",
                nodeType: .medication,
                critical: true,
                content: "Calcium gluconate 1-2g IV over 10-20 minutes",
                connections: ["magnesium_replacement"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Hypocalcemia",
                sections: [
                    CardSection(title: "Clinical Signs", items: [
                        "Chvostek sign: Facial twitching with tap",
                        "Trousseau sign: Carpal spasm with BP cuff",
                        "Paresthesias, tetany, seizures"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "labs_hypocalcemia",
            title: "Hypocalcemia",
            icon: "healthicon-calcium",
            category: .infectious,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createHypercalcemiaProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "hypercalcemia_assessment",
                title: "Hypercalcemia >10.5 mg/dL",
                nodeType: .assessment,
                critical: true,
                content: "Assess symptoms, identify cause (PTH, PTHrP, vitamin D)",
                connections: ["fluid_therapy"]
            ),
            AlgorithmNode(
                id: "fluid_therapy",
                title: "IV Fluid Therapy",
                nodeType: .intervention,
                critical: true,
                content: "Normal saline 250-500mL/hr to enhance calcium excretion",
                connections: ["bisphosphonates"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Hypercalcemia",
                sections: [
                    CardSection(title: "Treatment", items: [
                        "IV fluids: 2-4L normal saline daily",
                        "Furosemide: Only after volume repletion",
                        "Bisphosphonates: Zoledronic acid 4mg IV"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "labs_hypercalcemia",
            title: "Hypercalcemia",
            icon: "healthicon-calcium_supplement",
            category: .infectious,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createHypomagnesemiaProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "hypomagnesemia_assessment",
                title: "Hypomagnesemia <1.8 mg/dL",
                nodeType: .assessment,
                critical: false,
                content: "Often accompanies hypokalemia and hypocalcemia",
                connections: ["magnesium_replacement"]
            ),
            AlgorithmNode(
                id: "magnesium_replacement",
                title: "Magnesium Replacement",
                nodeType: .medication,
                critical: false,
                content: "MgSO4 1-2g IV over 1 hour, repeat as needed",
                connections: ["electrolyte_monitoring"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Hypomagnesemia",
                sections: [
                    CardSection(title: "Replacement", items: [
                        "IV: MgSO4 1-2g IV over 1 hour",
                        "PO: Magnesium oxide 400mg BID",
                        "May need several grams to replete stores"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "labs_hypomagnesemia",
            title: "Hypomagnesemia",
            icon: "healthicon-minerals_alt",
            category: .infectious,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createHypophosphatemiaProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "hypophosphatemia_assessment",
                title: "Hypophosphatemia <2.5 mg/dL",
                nodeType: .assessment,
                critical: false,
                content: "Assess symptoms, risk of refeeding syndrome",
                connections: ["phosphorus_replacement"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Hypophosphatemia",
                sections: [
                    CardSection(title: "Replacement", items: [
                        "Mild: PO replacement preferred",
                        "Severe: IV K-Phos or Na-Phos",
                        "Monitor calcium levels during replacement"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "labs_hypophosphatemia",
            title: "Hypophosphatemia",
            icon: "healthicon-phosphorus",
            category: .infectious,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    // MARK: - Glucose & Organ Function
    
    private func createHyperglycemiaProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "hyperglycemia_assessment",
                title: "Hyperglycemia >250 mg/dL",
                nodeType: .assessment,
                critical: true,
                content: "Check ketones, pH, assess for DKA/HHS",
                connections: ["dka_hhs_evaluation"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Hyperglycemia",
                sections: [
                    CardSection(title: "DKA vs HHS", items: [
                        "DKA: Glucose >250, ketones +, pH <7.3",
                        "HHS: Glucose >600, ketones -, osmolality >320",
                        "Both require insulin therapy"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "labs_hyperglycemia",
            title: "Hyperglycemia",
            icon: "healthicon-diabetes_test",
            category: .infectious,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createHypoglycemiaLabsProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "hypoglycemia_labs_assessment",
                title: "Hypoglycemia <70 mg/dL",
                nodeType: .assessment,
                critical: true,
                content: "Confirm with lab glucose, assess symptoms",
                connections: ["glucose_administration"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Hypoglycemia (Labs)",
                sections: [
                    CardSection(title: "Treatment", items: [
                        "D50W 25g IV push if conscious",
                        "Glucagon 1mg IM/SC if unconscious",
                        "Recheck glucose in 15 minutes"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "labs_hypoglycemia_detailed",
            title: "Hypoglycemia (Detailed)",
            icon: "healthicon-diabetes_test_alt",
            category: .infectious,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createRenalFailureProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "renal_failure_assessment",
                title: "Renal Failure Assessment",
                nodeType: .assessment,
                critical: true,
                content: "Creatinine >3.0 mg/dL or GFR <15 mL/min",
                connections: ["dialysis_indication"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Renal Failure",
                sections: [
                    CardSection(title: "Dialysis Indications", items: [
                        "Acidosis: pH <7.2",
                        "Electrolytes: K+ >6.5, severe hyperphosphatemia",
                        "Intoxication: methanol, ethylene glycol",
                        "Overload: pulmonary edema",
                        "Uremia: altered mental status, pericarditis"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "labs_renal_failure",
            title: "Renal Failure",
            icon: "healthicon-kidneys",
            category: .cardiac,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createHepaticEncephalopathyProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "hepatic_encephalopathy_assessment",
                title: "Hepatic Encephalopathy",
                nodeType: .assessment,
                critical: true,
                content: "Altered mental status with elevated ammonia (>50 μmol/L)",
                connections: ["lactulose_therapy"]
            ),
            AlgorithmNode(
                id: "lactulose_therapy",
                title: "Lactulose Therapy",
                nodeType: .medication,
                critical: true,
                content: "Lactulose 30mL PO q2h until bowel movement, then q8h",
                connections: ["rifaximin"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Hepatic Encephalopathy",
                sections: [
                    CardSection(title: "Treatment", items: [
                        "Lactulose: Target 2-3 soft stools daily",
                        "Rifaximin: 550mg PO BID",
                        "Identify and treat precipitants"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "labs_hepatic_encephalopathy",
            title: "Hepatic Encephalopathy",
            icon: "healthicon-liver",
            category: .neurological,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    // MARK: - Blood Gas Analysis
    
    private func createABGAnalysisProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "abg_interpretation",
                title: "ABG Interpretation",
                nodeType: .assessment,
                critical: true,
                content: "pH, CO2, HCO3, base excess, oxygenation status",
                connections: ["acid_base_classification"]
            ),
            AlgorithmNode(
                id: "acid_base_classification",
                title: "Acid-Base Classification",
                nodeType: .decision,
                critical: true,
                content: "Metabolic vs respiratory acidosis/alkalosis",
                connections: ["compensation_assessment"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "ABG Analysis",
                sections: [
                    CardSection(title: "Normal Values", items: [
                        "pH: 7.35-7.45",
                        "PaCO2: 35-45 mmHg",
                        "HCO3: 22-26 mEq/L",
                        "PaO2: 80-100 mmHg on room air"
                    ])
                ]
            ),
            ProtocolCard(
                id: "assessment_card",
                type: .assessment,
                title: "Interpretation Steps",
                sections: [
                    CardSection(title: "Systematic Approach", items: [
                        "1. Assess pH (acidemic vs alkalemic)",
                        "2. Determine primary disorder (respiratory vs metabolic)",
                        "3. Calculate expected compensation",
                        "4. Assess oxygenation and A-a gradient",
                        "5. Consider clinical context"
                    ])
                ]
            ),
            ProtocolCard(
                id: "actions_card",
                type: .actions,
                title: "Common Disorders",
                sections: [
                    CardSection(title: "Metabolic Acidosis", items: [
                        "Anion gap: DKA, lactic acidosis, renal failure",
                        "Non-anion gap: Diarrhea, RTA, ureterostomy",
                        "Compensation: PaCO2 = 1.5 × HCO3 + 8 ± 2"
                    ]),
                    CardSection(title: "Respiratory Acidosis", items: [
                        "Acute: CNS depression, neuromuscular disorders",
                        "Chronic: COPD, restrictive lung disease",
                        "Compensation: Chronic 3-4 mEq/L rise in HCO3 per 10 mmHg rise in CO2"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "labs_abg_analysis",
            title: "ABG Analysis",
            icon: "healthicon-respiratory_ventilator",
            category: .respiratory,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createAcidBaseProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "acid_base_assessment",
                title: "Acid-Base Assessment",
                nodeType: .assessment,
                critical: true,
                content: "Primary disorder, compensation, mixed disorders",
                connections: ["treatment_approach"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Acid-Base Disorders",
                sections: [
                    CardSection(title: "Treatment Principles", items: [
                        "Treat underlying cause",
                        "Support ventilation if needed",
                        "Bicarbonate rarely indicated"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "labs_acid_base",
            title: "Acid-Base Balance",
            icon: "healthicon-acid_rain",
            category: .respiratory,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createVentilatorAdjustmentProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "ventilator_assessment",
                title: "Ventilator Assessment",
                nodeType: .assessment,
                critical: true,
                content: "ABG results, ventilator settings, patient comfort",
                connections: ["parameter_adjustment"]
            ),
            AlgorithmNode(
                id: "parameter_adjustment",
                title: "Parameter Adjustment",
                nodeType: .intervention,
                critical: true,
                content: "Adjust FiO2, PEEP, rate, or tidal volume based on ABG",
                connections: ["reassess_abg"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Ventilator Adjustments",
                sections: [
                    CardSection(title: "Oxygenation", items: [
                        "Low PaO2: Increase FiO2 or PEEP",
                        "High PaO2: Decrease FiO2 (target 88-95%)",
                        "PEEP titration: 2-5 cmH2O increments"
                    ]),
                    CardSection(title: "Ventilation", items: [
                        "High CO2: Increase rate or tidal volume",
                        "Low CO2: Decrease rate or tidal volume",
                        "Plateau pressure <30 cmH2O"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "labs_ventilator_adjustment",
            title: "Ventilator Adjustment",
            icon: "healthicon-ventilator",
            category: .respiratory,
            algorithm: algorithm,
            cards: cards
        )
    }
}