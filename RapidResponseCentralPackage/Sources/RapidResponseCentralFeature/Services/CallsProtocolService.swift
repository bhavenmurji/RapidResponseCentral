import Foundation
import SwiftUI

// MARK: - Calls Protocol Service

@MainActor
public class CallsProtocolService: ObservableObject {
    @Published public private(set) var protocols: [EmergencyProtocol] = []
    @Published public private(set) var isLoading = false
    
    public init() {
        loadCallsProtocols()
    }
    
    private func loadCallsProtocols() {
        isLoading = true
        defer { isLoading = false }
        
        protocols = createCallsProtocols()
    }
    
    private func createCallsProtocols() -> [EmergencyProtocol] {
        return [
            // Cardiovascular
            createAcuteHFProtocol(),
            createRightHFProtocol(),
            createHypertensiveEmergencyProtocol(),
            
            // Endocrine
            createDKAProtocol(),
            createHypoglycemiaProtocol(),
            createAdrenalCrisisProtocol(),
            
            // Respiratory
            createPneumothoraxProtocol(),
            createRespiratoryFailureProtocol(),
            createAsthmaProtocol(),
            
            // GI
            createGIBleedingProtocol(),
            createBowelObstructionProtocol(),
            createAntiemeticProtocol(),
            
            // Pain & Palliative
            createAcutePainProtocol(),
            createOpiateConversionProtocol(),
            createEOLProtocol()
        ]
    }
    
    // MARK: - Cardiovascular Protocols
    
    private func createAcuteHFProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "hf_assessment",
                title: "Heart Failure Assessment",
                nodeType: .assessment,
                critical: true,
                content: "Assess volume status, hemodynamics, and precipitants",
                connections: ["volume_assessment"]
            ),
            AlgorithmNode(
                id: "volume_assessment",
                title: "Volume Status",
                nodeType: .decision,
                critical: true,
                content: "Fluid overloaded or euvolemic?",
                connections: ["diuretics", "inotropes"]
            ),
            AlgorithmNode(
                id: "diuretics",
                title: "Diuretic Therapy",
                nodeType: .medication,
                critical: true,
                content: "Furosemide 40-80mg IV, titrate based on response",
                connections: ["monitor_response"]
            ),
            AlgorithmNode(
                id: "inotropes",
                title: "Inotropic Support",
                nodeType: .medication,
                critical: true,
                content: "Consider dobutamine for cardiogenic shock",
                connections: ["monitor_response"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "HF Management",
                sections: [
                    CardSection(title: "Priority Actions", items: [
                        "Assess volume status and hemodynamics",
                        "Identify and treat precipitants",
                        "Optimize medical therapy"
                    ])
                ]
            ),
            ProtocolCard(
                id: "assessment_card",
                type: .assessment,
                title: "Assessment",
                sections: [
                    CardSection(title: "Volume Overload Signs", items: [
                        "Elevated JVP, edema, rales",
                        "S3 gallop, hepatomegaly",
                        "Chest X-ray findings"
                    ])
                ]
            ),
            ProtocolCard(
                id: "actions_card",
                type: .actions,
                title: "Treatment",
                sections: [
                    CardSection(title: "Diuretics", items: [
                        "Furosemide 40-80mg IV",
                        "Titrate based on response",
                        "Monitor electrolytes"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "acute_hf",
            title: "Acute Decompensated HF",
            icon: "bx-heart",
            category: .cardiac,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createRightHFProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "right_hf_assessment",
                title: "Right Heart Assessment",
                nodeType: .assessment,
                critical: true,
                content: "Evaluate for signs of right heart failure and pulmonary hypertension",
                connections: ["echo_assessment"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Right Heart Failure",
                sections: [
                    CardSection(title: "Key Features", items: [
                        "Elevated JVP, peripheral edema",
                        "Hepatomegaly, ascites",
                        "TR murmur, RV heave"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "right_hf",
            title: "Right Heart Failure",
            icon: "bx-heart",
            category: .cardiac,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createHypertensiveEmergencyProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "htn_assessment",
                title: "Hypertensive Emergency",
                nodeType: .assessment,
                critical: true,
                content: "BP >180/120 with end-organ damage",
                connections: ["target_bp"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Hypertensive Emergency",
                sections: [
                    CardSection(title: "Target BP Reduction", items: [
                        "Reduce MAP by 10-20% in first hour",
                        "Avoid precipitous drops",
                        "IV antihypertensives preferred"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "htn_emergency",
            title: "Hypertensive Emergency",
            icon: "bx-pulse",
            category: .cardiac,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    // MARK: - Endocrine Protocols
    
    private func createDKAProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "dka_diagnosis",
                title: "DKA Diagnosis",
                nodeType: .assessment,
                critical: true,
                content: "Glucose >250, ketones +, pH <7.3, anion gap >10",
                connections: ["fluid_resuscitation"]
            ),
            AlgorithmNode(
                id: "fluid_resuscitation",
                title: "Fluid Therapy",
                nodeType: .intervention,
                critical: true,
                content: "NS 1-2L rapidly, then maintenance based on deficit",
                connections: ["insulin_therapy"]
            ),
            AlgorithmNode(
                id: "insulin_therapy",
                title: "Insulin Protocol",
                nodeType: .medication,
                critical: true,
                content: "Regular insulin 0.1 units/kg/hr IV infusion",
                connections: ["electrolyte_management"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "DKA Management",
                sections: [
                    CardSection(title: "Treatment Goals", items: [
                        "Close anion gap",
                        "Clear ketones",
                        "Normalize glucose gradually"
                    ])
                ]
            ),
            ProtocolCard(
                id: "assessment_card",
                type: .assessment,
                title: "DKA Criteria",
                sections: [
                    CardSection(title: "Diagnostic Criteria", items: [
                        "Glucose >250 mg/dL",
                        "Ketones positive",
                        "pH <7.3 or HCO3 <15",
                        "Anion gap >10"
                    ])
                ]
            ),
            ProtocolCard(
                id: "actions_card",
                type: .actions,
                title: "Treatment Protocol",
                sections: [
                    CardSection(title: "Insulin Therapy", items: [
                        "Regular insulin 0.1 units/kg/hr",
                        "Continue until anion gap closes",
                        "Add D5W when glucose <250"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "dka_protocol",
            title: "DKA/HHS Management",
            icon: "bx-test-tube",
            category: .infectious,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createHypoglycemiaProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "hypoglycemia_recognition",
                title: "Hypoglycemia Recognition",
                nodeType: .assessment,
                critical: true,
                content: "Glucose <70 mg/dL with symptoms",
                connections: ["glucose_administration"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Hypoglycemia Treatment",
                sections: [
                    CardSection(title: "Immediate Actions", items: [
                        "D50W 25g IV push",
                        "Recheck glucose in 15 min",
                        "Consider glucagon if no IV access"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "hypoglycemia",
            title: "Hypoglycemia",
            icon: "bx-test-tube",
            category: .infectious,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createAdrenalCrisisProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "adrenal_crisis",
                title: "Adrenal Crisis",
                nodeType: .assessment,
                critical: true,
                content: "Hypotension, shock, electrolyte abnormalities",
                connections: ["steroid_therapy"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Adrenal Crisis",
                sections: [
                    CardSection(title: "Emergency Treatment", items: [
                        "Hydrocortisone 100mg IV stat",
                        "Aggressive fluid resuscitation",
                        "Correct electrolyte abnormalities"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "adrenal_crisis",
            title: "Adrenal Crisis",
            icon: "bx-test-tube",
            category: .infectious,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    // MARK: - Respiratory Protocols
    
    private func createPneumothoraxProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "pneumothorax_assessment",
                title: "Pneumothorax Assessment",
                nodeType: .assessment,
                critical: true,
                content: "Chest pain, dyspnea, decreased breath sounds",
                connections: ["size_assessment"]
            ),
            AlgorithmNode(
                id: "size_assessment",
                title: "Size Assessment",
                nodeType: .decision,
                critical: true,
                content: "Large (>20%) or tension pneumothorax?",
                connections: ["chest_tube", "observation"]
            ),
            AlgorithmNode(
                id: "chest_tube",
                title: "Chest Tube Insertion",
                nodeType: .intervention,
                critical: true,
                content: "Insert chest tube for drainage",
                connections: ["post_procedure"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Pneumothorax Management",
                sections: [
                    CardSection(title: "Indications for Chest Tube", items: [
                        "Large pneumothorax (>20%)",
                        "Tension pneumothorax",
                        "Hemodynamic instability"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "pneumothorax",
            title: "Pneumothorax",
            icon: "bx-wind",
            category: .respiratory,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createRespiratoryFailureProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "resp_failure_assessment",
                title: "Respiratory Failure",
                nodeType: .assessment,
                critical: true,
                content: "Assess oxygenation and ventilation",
                connections: ["niv_assessment"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Respiratory Failure",
                sections: [
                    CardSection(title: "NIV Indications", items: [
                        "COPD exacerbation",
                        "Acute cardiogenic pulmonary edema",
                        "pH 7.25-7.35"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "resp_failure",
            title: "Acute Respiratory Failure",
            icon: "bx-wind",
            category: .respiratory,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createAsthmaProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "asthma_assessment",
                title: "Asthma Exacerbation",
                nodeType: .assessment,
                critical: true,
                content: "Assess severity and response to bronchodilators",
                connections: ["bronchodilator_therapy"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Asthma Exacerbation",
                sections: [
                    CardSection(title: "Bronchodilator Therapy", items: [
                        "Albuterol nebulizer q20min x3",
                        "Ipratropium if severe",
                        "Systemic corticosteroids"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "asthma",
            title: "Asthma & COPD Exacerbation",
            icon: "bx-wind",
            category: .respiratory,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    // MARK: - GI Protocols
    
    private func createGIBleedingProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "gi_bleed_assessment",
                title: "GI Bleeding Assessment",
                nodeType: .assessment,
                critical: true,
                content: "Upper vs lower GI bleeding, hemodynamic status",
                connections: ["risk_stratification"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "GI Bleeding",
                sections: [
                    CardSection(title: "Risk Stratification", items: [
                        "Glasgow-Blatchford Score",
                        "Hemodynamic stability",
                        "Transfusion requirements"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "gi_bleeding",
            title: "GI Bleeding",
            icon: "bx-donate-blood",
            category: .trauma,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createBowelObstructionProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "bowel_obstruction",
                title: "Bowel Obstruction",
                nodeType: .assessment,
                critical: true,
                content: "Assess for mechanical vs functional obstruction",
                connections: ["decompression"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Bowel Obstruction",
                sections: [
                    CardSection(title: "Management", items: [
                        "NG tube decompression",
                        "IV fluid resuscitation",
                        "Surgery consultation"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "bowel_obstruction",
            title: "Bowel Obstruction",
            icon: "bx-food-menu",
            category: .trauma,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createAntiemeticProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "antiemetic_selection",
                title: "Antiemetic Choice",
                nodeType: .decision,
                critical: false,
                content: "Select appropriate antiemetic based on cause",
                connections: ["ondansetron", "metoclopramide"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Antiemetic Protocols",
                sections: [
                    CardSection(title: "First-Line Options", items: [
                        "Ondansetron 4-8mg IV",
                        "Metoclopramide 10mg IV",
                        "Promethazine 12.5-25mg IV"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "antiemetic",
            title: "Antiemetic & Fluids",
            icon: "bx-water",
            category: .infectious,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    // MARK: - Pain & Palliative Protocols
    
    private func createAcutePainProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "pain_assessment",
                title: "Pain Assessment",
                nodeType: .assessment,
                critical: false,
                content: "Assess pain severity (0-10 scale) and characteristics",
                connections: ["multimodal_analgesia"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Acute Pain Management",
                sections: [
                    CardSection(title: "Multimodal Approach", items: [
                        "Acetaminophen 1g PO/IV",
                        "NSAIDs if no contraindications",
                        "Opioids for severe pain"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "acute_pain",
            title: "Acute Pain Assessment",
            icon: "bx-plus-medical",
            category: .trauma,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createOpiateConversionProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "opiate_conversion",
                title: "Opiate Conversion",
                nodeType: .assessment,
                critical: false,
                content: "Convert between opiates using morphine equivalents",
                connections: ["calculate_dose"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Opiate Conversions",
                sections: [
                    CardSection(title: "Common Conversions", items: [
                        "Morphine 10mg PO = 5mg IV",
                        "Oxycodone 5mg = Morphine 7.5mg",
                        "Fentanyl 100mcg = Morphine 10mg"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "opiate_conversion",
            title: "Opiate Conversion",
            icon: "bx-calculator",
            category: .trauma,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createEOLProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "eol_care",
                title: "End-of-Life Care",
                nodeType: .assessment,
                critical: false,
                content: "Comfort-focused care and symptom management",
                connections: ["comfort_measures"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "End-of-Life Care",
                sections: [
                    CardSection(title: "Comfort Measures", items: [
                        "Pain and dyspnea management",
                        "Emotional and spiritual support",
                        "Family communication"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "eol_care",
            title: "End-of-Life Care",
            icon: "bx-heart",
            category: .trauma,
            algorithm: algorithm,
            cards: cards
        )
    }
}