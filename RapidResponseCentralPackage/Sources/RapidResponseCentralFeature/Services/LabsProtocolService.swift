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
                title: "Anemia Check",
                nodeType: .assessment,
                critical: true,
                content: "Hemoglobin <7 g/dL (severe), <10 g/dL (moderate), evaluate cause",
                connections: ["transfusion_consideration"]
            ),
            AlgorithmNode(
                id: "transfusion_consideration",
                title: "Transfuse?",
                nodeType: .decision,
                critical: true,
                content: "Hgb <7 g/dL or symptomatic with Hgb <10 g/dL",
                connections: ["type_crossmatch", "iron_studies"]
            ),
            AlgorithmNode(
                id: "type_crossmatch",
                title: "T&C",
                nodeType: .intervention,
                critical: true,
                content: "Order packed RBCs, consider urgency for crossmatch",
                connections: ["transfusion_monitoring"]
            ),
            AlgorithmNode(
                id: "iron_studies",
                title: "Iron Studies",
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
            title: "Anemia",
            icon: "drop", // Anemia - blood cells
            category: .cardiac,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createCoagulopathyProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "coagulopathy_assessment",
                title: "Coag Assessment",
                nodeType: .assessment,
                critical: true,
                content: "PT/INR >1.5, aPTT >45 sec, assess bleeding risk",
                connections: ["bleeding_assessment"]
            ),
            AlgorithmNode(
                id: "bleeding_assessment",
                title: "Bleeding?",
                nodeType: .decision,
                critical: true,
                content: "Current bleeding or high risk procedure planned",
                connections: ["urgent_reversal", "monitoring"]
            ),
            AlgorithmNode(
                id: "urgent_reversal",
                title: "Reversal",
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
            title: "Coagulopathy/INR",
            icon: "waveform.path.badge.plus", // Coagulopathy - clotting
            category: .cardiac,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createThrombocytopeniaProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "thrombocytopenia_assessment",
                title: "Platelet Check",
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
            icon: "drop.degreesign", // Thrombocytopenia - platelets
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
                title: "Na+ >145",
                nodeType: .assessment,
                critical: true,
                content: "Assess volume status and calculate free water deficit",
                connections: ["correction_rate"]
            ),
            AlgorithmNode(
                id: "correction_rate",
                title: "Correct Rate",
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
            icon: "plus.circle.fill", // Hypernatremia - high sodium
            category: .infectious,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createHyponatremiaProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "hyponatremia_assessment",
                title: "Na+ <135",
                nodeType: .assessment,
                critical: true,
                content: "Assess symptoms, volume status, and serum osmolality",
                connections: ["severity_classification"]
            ),
            AlgorithmNode(
                id: "severity_classification",
                title: "Severe Sx?",
                nodeType: .decision,
                critical: true,
                content: "Seizures, coma, severe altered mental status",
                connections: ["hypertonic_saline", "fluid_restriction"]
            ),
            AlgorithmNode(
                id: "hypertonic_saline",
                title: "3% NaCl",
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
            icon: "minus.circle.fill", // Hyponatremia - low sodium
            category: .infectious,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createHyperkalemiaProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "hyperkalemia_assessment",
                title: "K+ >5.5",
                nodeType: .assessment,
                critical: true,
                content: "Check ECG, assess symptoms, confirm with repeat sample",
                connections: ["ecg_changes"]
            ),
            AlgorithmNode(
                id: "ecg_changes",
                title: "ECG Changes?",
                nodeType: .decision,
                critical: true,
                content: "Peaked T waves, widened QRS, loss of P waves",
                connections: ["calcium_gluconate", "potassium_shift"]
            ),
            AlgorithmNode(
                id: "calcium_gluconate",
                title: "Ca Gluconate",
                nodeType: .medication,
                critical: true,
                content: "1-2g IV over 2-5 minutes for cardiac protection",
                connections: ["potassium_shift"]
            ),
            AlgorithmNode(
                id: "potassium_shift",
                title: "Shift K+",
                nodeType: .medication,
                critical: true,
                content: "Insulin 10 units + D50W 25g IV, Albuterol nebulizer",
                connections: ["potassium_removal"]
            ),
            AlgorithmNode(
                id: "potassium_removal",
                title: "Remove K+",
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
            icon: "bolt.circle.fill", // Hyperkalemia - high potassium
            category: .infectious,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createHypokalemiaProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "hypokalemia_assessment",
                title: "K+ <3.5",
                nodeType: .assessment,
                critical: true,
                content: "Assess symptoms, check Mg level, ECG if severe",
                connections: ["replacement_route"]
            ),
            AlgorithmNode(
                id: "replacement_route",
                title: "Replace Route",
                nodeType: .decision,
                critical: true,
                content: "IV if K+ <2.5 or symptomatic, PO if stable",
                connections: ["iv_replacement", "oral_replacement"]
            ),
            AlgorithmNode(
                id: "iv_replacement",
                title: "IV K+",
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
            icon: "bolt.slash.circle", // Hypokalemia - low potassium
            category: .infectious,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createHypocalcemiaProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "hypocalcemia_assessment",
                title: "Ca2+ <8.5",
                nodeType: .assessment,
                critical: true,
                content: "Check ionized calcium, symptoms, Mg and phosphorus levels",
                connections: ["symptomatic_treatment"]
            ),
            AlgorithmNode(
                id: "symptomatic_treatment",
                title: "Sx Treatment",
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
            icon: "minus.circle.fill",
            category: .infectious,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createHypercalcemiaProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "hypercalcemia_assessment",
                title: "Ca2+ >10.5",
                nodeType: .assessment,
                critical: true,
                content: "Assess symptoms, identify cause (PTH, PTHrP, vitamin D)",
                connections: ["fluid_therapy"]
            ),
            AlgorithmNode(
                id: "fluid_therapy",
                title: "IV Fluids",
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
            icon: "plus.circle.fill",
            category: .infectious,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createHypomagnesemiaProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "hypomagnesemia_assessment",
                title: "Mg2+ <1.8",
                nodeType: .assessment,
                critical: false,
                content: "Often accompanies hypokalemia and hypocalcemia",
                connections: ["magnesium_replacement"]
            ),
            AlgorithmNode(
                id: "magnesium_replacement",
                title: "Mg Replace",
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
            icon: "atom", // Hypocalcemia - calcium
            category: .infectious,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createHypophosphatemiaProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "hypophosphatemia_assessment",
                title: "PO4 <2.5",
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
            icon: "atom", // Hypercalcemia - calcium
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
                title: "Glucose >250",
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
            title: "Hyperglycemia/DKA/HHS",
            icon: "square.stack", // Hypomagnesemia - magnesium
            category: .infectious,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createHypoglycemiaLabsProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "hypoglycemia_labs_assessment",
                title: "Glucose <70",
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
            title: "Hypoglycemia",
            icon: "sparkles", // Hypophosphatemia - phosphate
            category: .infectious,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createRenalFailureProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            // Initial AKI Assessment - Node A → B
            AlgorithmNode(
                id: "aki_assessment",
                title: "AKI Assessment",
                nodeType: .assessment,
                critical: true,
                content: "KDIGO staging: Stage 1 (Cr 1.5-1.9× baseline), Stage 2 (Cr 2.0-2.9×), Stage 3 (Cr ≥3× or ≥353.6μmol/L)",
                connections: ["aki_criteria_met"]
            ),
            
            // Decision Point - Node B
            AlgorithmNode(
                id: "aki_criteria_met",
                title: "AKI Criteria?",
                nodeType: .decision,
                critical: true,
                content: "Does patient meet AKI criteria based on creatinine rise or urine output?",
                connections: ["investigate_aki", "monitor_function"]
            ),
            
            // Investigation Path - Node C
            AlgorithmNode(
                id: "investigate_aki",
                title: "Investigate",
                nodeType: .intervention,
                critical: true,
                content: "Hold nephrotoxins, order labs including urine electrolytes for FENa/FEUrea",
                connections: ["etiology_determination"]
            ),
            
            // Monitor Function - Alternative Path
            AlgorithmNode(
                id: "monitor_function",
                title: "Monitor Function",
                nodeType: .endpoint,
                critical: false,
                content: "Continue routine monitoring, no acute rise detected",
                connections: []
            ),
            
            // Etiology Determination - Node D
            AlgorithmNode(
                id: "etiology_determination",
                title: "Find Cause",
                nodeType: .assessment,
                critical: true,
                content: "Clinical evaluation, urinalysis interpretation, volume status assessment",
                connections: ["prerenal_intrinsic_unclear", "direct_management"]
            ),
            
            // Calculator Decision - Node E
            AlgorithmNode(
                id: "prerenal_intrinsic_unclear",
                title: "Unclear Cause?",
                nodeType: .decision,
                critical: true,
                content: "If etiology unclear, use FENa/FEUrea calculators for differentiation",
                connections: ["fena_calculator", "feurea_calculator"]
            ),
            
            // Direct Management Path
            AlgorithmNode(
                id: "direct_management",
                title: "Direct Mgmt",
                nodeType: .intervention,
                critical: true,
                content: "Clear etiology identified - proceed with specific management",
                connections: ["risk_stratification"]
            ),
            
            // FENa Calculator - Node F
            AlgorithmNode(
                id: "fena_calculator",
                title: "FENa Calc",
                nodeType: .assessment,
                critical: false,
                content: "FENa = (UNa×SCr)/(UCr×SNa) × 100. <1%: Prerenal, >2%: ATN, 1-2%: Indeterminate",
                connections: ["fena_result_interpretation"]
            ),
            
            // FEUrea Calculator - Node G
            AlgorithmNode(
                id: "feurea_calculator",
                title: "FEUrea Calc",
                nodeType: .assessment,
                critical: false,
                content: "FEUrea = (UBun×SCr)/(UCr×SBun) × 100. ≤35%: Prerenal, >50%: ATN",
                connections: ["feurea_result_interpretation"]
            ),
            
            // FENa Result Interpretation
            AlgorithmNode(
                id: "fena_result_interpretation",
                title: "FENa Result",
                nodeType: .decision,
                critical: true,
                content: "Based on FENa result, determine prerenal vs ATN",
                connections: ["prerenal_management", "atn_management", "clinical_judgment"]
            ),
            
            // FEUrea Result Interpretation
            AlgorithmNode(
                id: "feurea_result_interpretation",
                title: "FEUrea Result",
                nodeType: .decision,
                critical: true,
                content: "Based on FEUrea result, determine prerenal vs ATN",
                connections: ["prerenal_management", "atn_management", "clinical_judgment"]
            ),
            
            // Prerenal Management - Node H
            AlgorithmNode(
                id: "prerenal_management",
                title: "Prerenal Mgmt",
                nodeType: .intervention,
                critical: true,
                content: "Volume resuscitation with isotonic crystalloid, target MAP ≥65 mmHg",
                connections: ["response_monitoring"]
            ),
            
            // ATN Management - Node I
            AlgorithmNode(
                id: "atn_management",
                title: "ATN Mgmt",
                nodeType: .intervention,
                critical: true,
                content: "Supportive care, maintain euvolemia, monitor for recovery (1-3 weeks typical)",
                connections: ["complication_monitoring"]
            ),
            
            // Clinical Judgment - Node J
            AlgorithmNode(
                id: "clinical_judgment",
                title: "Clinical Judge",
                nodeType: .decision,
                critical: true,
                content: "Indeterminate results - use clinical context for management decision",
                connections: ["cautious_fluid_trial", "nephrology_consult"]
            ),
            
            // Risk Stratification - Node K
            AlgorithmNode(
                id: "risk_stratification",
                title: "Risk Stratify",
                nodeType: .assessment,
                critical: true,
                content: "Assess for high-risk features: acidosis, hyperkalemia, volume overload, uremia",
                connections: ["high_risk_management", "moderate_risk_management", "conservative_care"]
            ),
            
            // High Risk Management - Node L
            AlgorithmNode(
                id: "high_risk_management",
                title: "Emergency AKI",
                nodeType: .intervention,
                critical: true,
                content: "Life-threatening complications: K+ >6.5, severe acidosis, pulmonary edema",
                connections: ["aeiou_assessment"]
            ),
            
            // AEIOU Assessment - Node M
            AlgorithmNode(
                id: "aeiou_assessment",
                title: "AEIOU Criteria",
                nodeType: .decision,
                critical: true,
                content: "Acidosis, Electrolytes, Intoxication, Overload, Uremia",
                connections: ["emergent_rrt", "intensive_monitoring"]
            ),
            
            // Emergent RRT - Node N
            AlgorithmNode(
                id: "emergent_rrt",
                title: "Emergent RRT",
                nodeType: .intervention,
                critical: true,
                content: "STAT nephrology, ICU admission, prepare vascular access",
                connections: ["rrt_modality_selection"]
            ),
            
            // RRT Modality Selection - Node O
            AlgorithmNode(
                id: "rrt_modality_selection",
                title: "RRT Modality",
                nodeType: .decision,
                critical: true,
                content: "Hemodynamically stable → IHD, Unstable → CRRT",
                connections: ["intermittent_hd", "continuous_rrt"]
            ),
            
            // Final Endpoints
            AlgorithmNode(
                id: "intermittent_hd",
                title: "IHD",
                nodeType: .endpoint,
                critical: false,
                content: "3-4 hours, blood flow 300-400 mL/min, conservative initial prescription",
                connections: []
            ),
            
            AlgorithmNode(
                id: "continuous_rrt",
                title: "CRRT",
                nodeType: .endpoint,
                critical: false,
                content: "CVVHDF mode, effluent rate 25-35 mL/kg/h, regional citrate anticoagulation",
                connections: []
            ),
            
            AlgorithmNode(
                id: "intensive_monitoring",
                title: "Intensive Monitor",
                nodeType: .endpoint,
                critical: false,
                content: "Labs q6-12h, continuous cardiac monitoring, hourly urine output",
                connections: []
            )
        ])
        
        let cards = [
            // Card 0 - Initial AKI Assessment (Node A → B)
            ProtocolCard(
                id: "card_0_aki_assessment",
                type: .assessment,
                title: "🔬 ACUTE KIDNEY INJURY ASSESSMENT",
                sections: [
                    CardSection(title: "📊 KDIGO AKI Staging", items: [
                        "• Stage 1: Cr 1.5-1.9× baseline OR ≥26.5μmol/L increase, UOP <0.5mL/kg/h",
                        "• Stage 2: Cr 2.0-2.9× baseline",
                        "• Stage 3: Cr ≥3× baseline OR ≥353.6μmol/L OR initiation of RRT OR anuria ≥12h"
                    ]),
                    CardSection(title: "🚨 Immediate Actions", items: [
                        "• Drug chart review needed",
                        "• Hold nephrotoxins",
                        "• Assess volume status"
                    ])
                ]
            ),
            
            // Card 1A - Investigate AKI (Node C)
            ProtocolCard(
                id: "card_1a_investigate",
                type: .dynamic,
                title: "🔍 AKI INVESTIGATION PROTOCOL",
                sections: [
                    CardSection(title: "💊 Drug Modifications", items: [
                        "• Hold metformin, diuretics, ACE/ARBs, NSAIDs",
                        "• Avoid IV contrast",
                        "• Review antimicrobials dosing"
                    ]),
                    CardSection(title: "📋 Essential Investigations", items: [
                        "• FBC, U&E, CRP, Ca²⁺, PO₄³⁻, Mg²⁺",
                        "• VBG, LFT, clot, CK",
                        "• Urinalysis with microscopy",
                        "• Urine electrolytes (Na+, Cr for FENa)"
                    ])
                ]
            ),
            
            // Card 2A - Etiology Determination (Node D)
            ProtocolCard(
                id: "card_2a_etiology",
                type: .assessment,
                title: "🔬 AKI ETIOLOGY ASSESSMENT",
                sections: [
                    CardSection(title: "🩺 Clinical Evaluation", items: [
                        "• Volume status assessment",
                        "• Medication review completed",
                        "• Systemic illness evaluation",
                        "• Urinary obstruction screening"
                    ]),
                    CardSection(title: "🧪 Urinalysis Interpretation", items: [
                        "• Bland sediment → Prerenal likely",
                        "• Muddy brown casts → ATN",
                        "• RBC casts → Glomerulonephritis",
                        "• WBC casts → Interstitial nephritis"
                    ])
                ]
            ),
            
            // Card 3A - FENa Calculator (Node F)
            ProtocolCard(
                id: "card_3a_fena",
                type: .dynamic,
                title: "🧮 FRACTIONAL EXCRETION OF SODIUM",
                sections: [
                    CardSection(title: "📊 Required Values", items: [
                        "• Serum Creatinine (mg/dL)",
                        "• Serum Sodium (mEq/L)",
                        "• Urine Creatinine (mg/dL)",
                        "• Urine Sodium (mEq/L)"
                    ]),
                    CardSection(title: "🎯 Interpretation", items: [
                        "• <1%: Prerenal AKI",
                        "• >2%: Intrinsic renal disease (ATN)",
                        "• 1-2%: Indeterminate (use FEUrea)"
                    ])
                ]
            ),
            
            // Card 3B - FEUrea Calculator (Node G)
            ProtocolCard(
                id: "card_3b_feurea",
                type: .dynamic,
                title: "🧮 FRACTIONAL EXCRETION OF UREA",
                sections: [
                    CardSection(title: "📊 Required Values", items: [
                        "• Serum BUN (mg/dL)",
                        "• Serum Creatinine (mg/dL)",
                        "• Urine BUN (mg/dL)",
                        "• Urine Creatinine (mg/dL)"
                    ]),
                    CardSection(title: "🎯 Interpretation", items: [
                        "• ≤35%: Prerenal AKI",
                        "• >50%: Intrinsic renal disease",
                        "• 35-50%: Indeterminate"
                    ]),
                    CardSection(title: "💡 Preferred When", items: [
                        "• Patient on diuretics",
                        "• Chronic kidney disease",
                        "• More accurate than FENa"
                    ])
                ]
            ),
            
            // Card 4A - Prerenal Management (Node H)
            ProtocolCard(
                id: "card_4a_prerenal",
                type: .actions,
                title: "🩸 PRERENAL AKI MANAGEMENT",
                sections: [
                    CardSection(title: "💧 Volume Resuscitation", items: [
                        "• Isotonic crystalloid (LR preferred)",
                        "• Initial bolus: 500mL-1L over 30min",
                        "• Target MAP ≥65 mmHg"
                    ]),
                    CardSection(title: "📊 Monitor Response", items: [
                        "• Urine output improvement",
                        "• Creatinine stabilization",
                        "• Hemodynamic parameters"
                    ])
                ]
            ),
            
            // Card 4B - ATN Management (Node I)
            ProtocolCard(
                id: "card_4b_atn",
                type: .actions,
                title: "🫘 ACUTE TUBULAR NECROSIS MANAGEMENT",
                sections: [
                    CardSection(title: "🛡️ Supportive Care", items: [
                        "• Maintain euvolemia",
                        "• Continue medication holds",
                        "• Optimize hemodynamics",
                        "• Nutrition support"
                    ]),
                    CardSection(title: "🎯 Recovery Timeline", items: [
                        "• Typically 1-3 weeks for recovery",
                        "• Monitor for complications",
                        "• Daily creatinine trending"
                    ])
                ]
            ),
            
            // Card 5A - Risk Stratification (Node K)
            ProtocolCard(
                id: "card_5a_risk",
                type: .assessment,
                title: "⚖️ AKI RISK STRATIFICATION",
                sections: [
                    CardSection(title: "📊 Risk Factors", items: [
                        "• Hypovolaemia",
                        "• Acidosis (pH <7.35)",
                        "• Pulmonary oedema",
                        "• Uraemic encephalopathy",
                        "• Hyperkalaemia (K+ >5.5)"
                    ])
                ]
            ),
            
            // Card 7A - Dialysis Evaluation (Node M)
            ProtocolCard(
                id: "card_7a_aeiou",
                type: .dynamic,
                title: "🔬 EMERGENT DIALYSIS CRITERIA (AEIOU)",
                sections: [
                    CardSection(title: "🚨 Life-threatening Indications", items: [
                        "• Acidosis: pH <7.2 refractory",
                        "• Electrolytes: K+ >6.5 refractory",
                        "• Intoxication: Dialyzable toxins",
                        "• Overload: Pulmonary edema + hypoxia",
                        "• Uremia: Pericarditis, encephalopathy"
                    ])
                ]
            ),
            
            // Card 8A - Emergent RRT (Node N)
            ProtocolCard(
                id: "card_8a_rrt",
                type: .actions,
                title: "⚡ EMERGENT RENAL REPLACEMENT THERAPY",
                sections: [
                    CardSection(title: "🚀 Immediate Actions", items: [
                        "• STAT nephrology consultation",
                        "• ICU admission if unstable",
                        "• Prepare temporary vascular access",
                        "• Family communication"
                    ]),
                    CardSection(title: "⚙️ Modality Selection", items: [
                        "• Hemodynamically stable → IHD",
                        "• Unstable/pressors → CRRT",
                        "• Large volume removal → CRRT"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "labs_renal_failure",
            title: "AKI/Renal Failure",
            icon: "drop.degreesign.fill", // Renal failure - kidney function
            category: .cardiac,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createHepaticEncephalopathyProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "hepatic_encephalopathy_assessment",
                title: "Hepatic Enceph",
                nodeType: .assessment,
                critical: true,
                content: "Altered mental status with elevated ammonia (>50 μmol/L)",
                connections: ["lactulose_therapy"]
            ),
            AlgorithmNode(
                id: "lactulose_therapy",
                title: "Lactulose",
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
            icon: "brain.fill", // Hepatic encephalopathy
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
                title: "ABG Interpret",
                nodeType: .assessment,
                critical: true,
                content: "pH, CO2, HCO3, base excess, oxygenation status",
                connections: ["acid_base_classification"]
            ),
            AlgorithmNode(
                id: "acid_base_classification",
                title: "Acid-Base Class",
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
            title: "ABG w/ Winter's Eqn",
            icon: "waveform", // ABG analysis
            category: .respiratory,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createAcidBaseProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "acid_base_assessment",
                title: "Acid-Base Check",
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
            title: "Acid-Base Disorders",
            icon: "scalemass.fill", // Acid-base balance
            category: .respiratory,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createVentilatorAdjustmentProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "ventilator_assessment",
                title: "Vent Assessment",
                nodeType: .assessment,
                critical: true,
                content: "ABG results, ventilator settings, patient comfort",
                connections: ["parameter_adjustment"]
            ),
            AlgorithmNode(
                id: "parameter_adjustment",
                title: "Adjust Settings",
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
            title: "Ventilator Adj.",
            icon: "gearshape.2.fill", // Ventilator settings
            category: .respiratory,
            algorithm: algorithm,
            cards: cards
        )
    }
}