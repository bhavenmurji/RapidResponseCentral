import Foundation
import SwiftUI
import os.log
import os.signpost

// MARK: - Calculators Protocol Service

@MainActor
public class CalculatorsProtocolService: ObservableObject {
    @Published public private(set) var protocols: [EmergencyProtocol] = []
    @Published public private(set) var isLoading = false
    
    private let performanceLogger = Logger(subsystem: "com.rapidresponsecentral.performance", category: "CalculatorsProtocolService")
    private let signposter = OSSignposter(subsystem: "com.rapidresponsecentral.performance", category: "CalculatorsProtocolCreation")
    
    public init() {
        Task {
            await loadCalculatorsProtocolsConcurrently()
        }
    }
    
    @MainActor
    private func loadCalculatorsProtocolsConcurrently() async {
        isLoading = true
        defer { isLoading = false }
        
        performanceLogger.info("🧮 Starting concurrent Calculators protocol creation")
        let signpostID = signposter.makeSignpostID()
        let signpostState = signposter.beginInterval("CalculatorsProtocolCreation", id: signpostID)
        
        protocols = await withTaskGroup(of: (Int, EmergencyProtocol).self, returning: [EmergencyProtocol].self) { group in
            let protocolCreators: [(String, @Sendable () async -> EmergencyProtocol)] = [
                // Stroke & Neurology
                ("NIH Stroke Scale", { await self.createNIHStrokeScaleProtocol() }),
                ("ABCD2 Score", { await self.createABCD2ScoreProtocol() }),
                ("Glasgow Coma Scale", { await self.createGlasgowComaScaleProtocol() }),
                
                // Cardiovascular Risk
                ("CHADS2-VASc2", { await self.createCHADS2VASc2Protocol() }),
                ("Wells Score for PE", { await self.createWellsScorePEProtocol() }),
                ("GRACE Score", { await self.createGRACEScoreProtocol() }),
                
                // Critical Care Scoring
                ("APACHE II", { await self.createAPACHEIIProtocol() }),
                ("qSOFA", { await self.createqSOFAProtocol() }),
                ("NEWS", { await self.createNEWSProtocol() }),
                ("SOFA Score", { await self.createSOFAScoreProtocol() }),
                ("Anion Gap", { await self.createAnionGapProtocol() }),
                
                // Pharmacology Tools
                ("QTc Calculation", { await self.createQTcCalculationProtocol() }),
                ("Creatinine Clearance", { await self.createCreatinineClearanceProtocol() }),
                ("Opiate Conversion", { await self.createOpiateConversionProtocol() }),
                ("Corrected Calcium", { await self.createCorrectedCalciumProtocol() }),
                ("FeNa", { await self.createFeNaProtocol() }),
                
                // Infectious Disease
                ("CURB-65", { await self.createCURB65Protocol() }),
                ("Pneumonia Severity Index", { await self.createPneumoniaSeverityIndexProtocol() }),
                ("Sepsis Screening", { await self.createSepsisScreeningProtocol() }),
                
                // Trauma
                ("Body Surface Area", { await self.createBodySurfaceAreaProtocol() }),
                ("Maintenance Fluid", { await self.createMaintenanceFluidProtocol() })
            ]
            
            for (index, (name, creator)) in protocolCreators.enumerated() {
                group.addTask {
                    let startTime = CACurrentMediaTime()
                    let emergencyProtocol = await creator()
                    let duration = CACurrentMediaTime() - startTime
                    
                    if duration > 0.05 { // 50ms threshold for calculator protocols
                        self.performanceLogger.warning("⚠️ Calculator Protocol Performance: \(name) took \(String(format: "%.2f", duration * 1000))ms")
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
        
        signposter.endInterval("CalculatorsProtocolCreation", signpostState)
        performanceLogger.info("✅ Calculators Protocol creation completed: \(self.protocols.count) protocols loaded")
    }
    
    // MARK: - Stroke & Neurology Calculators
    
    private func createNIHStrokeScaleProtocol() async -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "nihss_assessment",
                title: "NIH Stroke Scale Assessment",
                nodeType: .assessment,
                critical: true,
                content: "Interactive assessment with auto-totaling for stroke severity",
                connections: ["interpretation"]
            ),
            AlgorithmNode(
                id: "interpretation",
                title: "Score Interpretation",
                nodeType: .assessment,
                critical: true,
                content: "0-4: Minor stroke, 5-15: Moderate stroke, 16-20: Moderate-severe stroke, 21-42: Severe stroke",
                connections: ["endpoint"]
            ),
            AlgorithmNode(
                id: "endpoint",
                title: "Protocol End",
                nodeType: .endpoint,
                critical: false,
                content: "Protocol completed. Document score and interpretation.",
                connections: []
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "NIH Stroke Scale",
                sections: [
                    CardSection(title: "Assessment Components", items: [
                        "🧠 Level of consciousness",
                        "👁️ Best gaze",
                        "👁️ Visual fields",
                        "😐 Facial palsy",
                        "💪 Motor arm",
                        "🦵 Motor leg",
                        "🔄 Limb ataxia",
                        "👄 Sensory",
                        "💬 Best language",
                        "🗣️ Dysarthria",
                        "👁️ Extinction/inattention"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "nih_stroke_scale",
            title: "NIH Stroke Scale",
            icon: "brain.head.profile", // GCS neurological assessment
            category: .neurological,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createABCD2ScoreProtocol() async -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "abcd2_assessment",
                title: "ABCD2 Score Assessment",
                nodeType: .assessment,
                critical: true,
                content: "Stroke risk stratification for TIA patients",
                connections: ["risk_stratification"]
            ),
            AlgorithmNode(
                id: "risk_stratification",
                title: "Risk Stratification",
                nodeType: .assessment,
                critical: true,
                content: "0-3: Low risk, 4-5: Moderate risk, 6-7: High risk",
                connections: ["endpoint"]
            ),
            AlgorithmNode(
                id: "endpoint",
                title: "Protocol End",
                nodeType: .endpoint,
                critical: false,
                content: "Protocol completed. Document score and risk level.",
                connections: []
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "ABCD2 Score",
                sections: [
                    CardSection(title: "Score Components", items: [
                        "👴 Age ≥60 years",
                        "🩸 Blood pressure ≥140/90",
                        "🧠 Clinical features",
                        "⏱️ Duration of symptoms",
                        "💊 Diabetes mellitus"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "abcd2_score",
            title: "ABCD2 Score",
            icon: "chart.xyaxis.line", // APACHE II severity score
            category: .neurological,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createGlasgowComaScaleProtocol() async -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "gcs_assessment",
                title: "Glasgow Coma Scale Assessment",
                nodeType: .assessment,
                critical: true,
                content: "Eye opening, verbal response, motor response with pupil response integration",
                connections: ["interpretation"]
            ),
            AlgorithmNode(
                id: "interpretation",
                title: "Score Interpretation",
                nodeType: .assessment,
                critical: true,
                content: "13-15: Mild TBI, 9-12: Moderate TBI, 3-8: Severe TBI",
                connections: ["endpoint"]
            ),
            AlgorithmNode(
                id: "endpoint",
                title: "Protocol End",
                nodeType: .endpoint,
                critical: false,
                content: "Protocol completed. Document score and interpretation.",
                connections: []
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Glasgow Coma Scale",
                sections: [
                    CardSection(title: "Assessment Components", items: [
                        "👁️ Eye opening (1-4)",
                        "💬 Verbal response (1-5)",
                        "💪 Motor response (1-6)",
                        "👁️ Pupil response integration"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "glasgow_coma_scale",
            title: "Glasgow Coma Scale",
            icon: "eye.fill", // SOFA organ failure assessment
            category: .neurological,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    // MARK: - Cardiovascular Risk Calculators
    
    private func createCHADS2VASc2Protocol() async -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "chads2vasc2_assessment",
                title: "CHADS2-VASc2 Assessment",
                nodeType: .assessment,
                critical: true,
                content: "Anticoagulation decisions for atrial fibrillation",
                connections: ["risk_stratification"]
            ),
            AlgorithmNode(
                id: "risk_stratification",
                title: "Risk Stratification",
                nodeType: .assessment,
                critical: true,
                content: "0: Low risk, 1: Low-moderate risk, 2: Moderate risk, ≥3: High risk",
                connections: ["endpoint"]
            ),
            AlgorithmNode(
                id: "endpoint",
                title: "Protocol End",
                nodeType: .endpoint,
                critical: false,
                content: "Protocol completed. Document score and anticoagulation recommendation.",
                connections: []
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "CHADS2-VASc2 Score",
                sections: [
                    CardSection(title: "Risk Factors", items: [
                        "💔 Congestive heart failure",
                        "🩸 Hypertension",
                        "👴 Age ≥75 years",
                        "💊 Diabetes mellitus",
                        "🩸 Stroke/TIA",
                        "🩸 Vascular disease",
                        "👴 Age 65-74 years",
                        "👤 Sex category (female)"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "chads2vasc2_score",
            title: "CHADS2-VASc2",
            icon: "heart.text.square", // HEART score chest pain
            category: .cardiac,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createWellsScorePEProtocol() async -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "wells_pe_assessment",
                title: "Wells Score for PE Assessment",
                nodeType: .assessment,
                critical: true,
                content: "Pulmonary embolism probability with D-dimer interpretation",
                connections: ["probability_assessment"]
            ),
            AlgorithmNode(
                id: "probability_assessment",
                title: "Probability Assessment",
                nodeType: .assessment,
                critical: true,
                content: "<2: Low probability, 2-6: Moderate probability, >6: High probability",
                connections: ["endpoint"]
            ),
            AlgorithmNode(
                id: "endpoint",
                title: "Protocol End",
                nodeType: .endpoint,
                critical: false,
                content: "Protocol completed. Document score and probability.",
                connections: []
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Wells Score for PE",
                sections: [
                    CardSection(title: "Clinical Features", items: [
                        "🩸 Clinical signs of DVT",
                        "🩸 Alternative diagnosis less likely",
                        "💓 Heart rate >100",
                        "🩸 Immobilization/surgery",
                        "🩸 Previous DVT/PE",
                        "🩸 Hemoptysis",
                        "🩸 Malignancy"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "wells_score_pe",
            title: "Wells Score for PE",
            icon: "lungs", // PERC PE rule-out
            category: .respiratory,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createGRACEScoreProtocol() async -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "grace_assessment",
                title: "GRACE Score Assessment",
                nodeType: .assessment,
                critical: true,
                content: "ACS risk stratification for disposition decisions",
                connections: ["risk_stratification"]
            ),
            AlgorithmNode(
                id: "risk_stratification",
                title: "Risk Stratification",
                nodeType: .assessment,
                critical: true,
                content: "Low, intermediate, and high risk categories for 6-month mortality",
                connections: ["endpoint"]
            ),
            AlgorithmNode(
                id: "endpoint",
                title: "Protocol End",
                nodeType: .endpoint,
                critical: false,
                content: "Protocol completed. Document score and risk category.",
                connections: []
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "GRACE Score",
                sections: [
                    CardSection(title: "Score Components", items: [
                        "👴 Age",
                        "💓 Heart rate",
                        "🩸 Systolic blood pressure",
                        "💔 Killip class",
                        "💔 Cardiac arrest",
                        "💔 ST-segment deviation",
                        "💔 Elevated cardiac enzymes",
                        "💔 Serum creatinine"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "grace_score",
            title: "GRACE Score",
            icon: "heart", // Wells DVT criteria
            category: .cardiac,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    // MARK: - Critical Care Scoring Calculators
    
    private func createAPACHEIIProtocol() async -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "apacheii_assessment",
                title: "APACHE II Assessment",
                nodeType: .assessment,
                critical: true,
                content: "Mortality prediction with physiological variables",
                connections: ["mortality_prediction"]
            ),
            AlgorithmNode(
                id: "mortality_prediction",
                title: "Mortality Prediction",
                nodeType: .assessment,
                critical: true,
                content: "Score-based mortality risk prediction for ICU patients",
                connections: ["endpoint"]
            ),
            AlgorithmNode(
                id: "endpoint",
                title: "Protocol End",
                nodeType: .endpoint,
                critical: false,
                content: "Protocol completed. Document score and mortality risk.",
                connections: []
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "APACHE II Score",
                sections: [
                    CardSection(title: "Physiological Variables", items: [
                        "🌡️ Temperature",
                        "💓 Mean arterial pressure",
                        "💓 Heart rate",
                        "🫁 Respiratory rate",
                        "🩸 Arterial pH",
                        "🩸 Serum sodium",
                        "🩸 Serum potassium",
                        "🩸 Serum creatinine",
                        "🩸 Hematocrit",
                        "🩸 White blood cell count",
                        "🧠 Glasgow Coma Scale"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "apacheii_score",
            title: "APACHE II",
            icon: "chart.bar.xaxis", // CHADS2-VASc stroke risk
            category: .support,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createqSOFAProtocol() async -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "qsofa_assessment",
                title: "qSOFA Assessment",
                nodeType: .assessment,
                critical: true,
                content: "Quick Sequential Organ Failure Assessment for sepsis screening",
                connections: ["sepsis_risk"]
            ),
            AlgorithmNode(
                id: "sepsis_risk",
                title: "Sepsis Risk Assessment",
                nodeType: .assessment,
                critical: true,
                content: "≥2 criteria: Increased risk of poor outcomes in suspected infection",
                connections: ["endpoint"]
            ),
            AlgorithmNode(
                id: "endpoint",
                title: "Protocol End",
                nodeType: .endpoint,
                critical: false,
                content: "Protocol completed. Document score and sepsis risk.",
                connections: []
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "qSOFA Score",
                sections: [
                    CardSection(title: "Assessment Criteria", items: [
                        "💓 Respiratory rate ≥22/min",
                        "🩸 Systolic blood pressure ≤100 mmHg",
                        "🧠 Altered mental status"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "qsofa_score",
            title: "qSOFA",
            icon: "exclamationmark.triangle", // HAS-BLED bleeding
            category: .infectious,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createNEWSProtocol() async -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "news_assessment",
                title: "NEWS Assessment",
                nodeType: .assessment,
                critical: true,
                content: "National Early Warning Score for patient deterioration",
                connections: ["risk_assessment"]
            ),
            AlgorithmNode(
                id: "risk_assessment",
                title: "Risk Assessment",
                nodeType: .assessment,
                critical: true,
                content: "0-4: Low risk, 5-6: Low-medium risk, 7-8: Medium risk, ≥9: High risk",
                connections: ["endpoint"]
            ),
            AlgorithmNode(
                id: "endpoint",
                title: "Protocol End",
                nodeType: .endpoint,
                critical: false,
                content: "Protocol completed. Document score and risk level.",
                connections: []
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "NEWS Score",
                sections: [
                    CardSection(title: "Assessment Parameters", items: [
                        "💓 Pulse rate",
                        "🩸 Systolic blood pressure",
                        "🌡️ Temperature",
                        "🫁 Respiratory rate",
                        "🩸 Oxygen saturation",
                        "🧠 Level of consciousness"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "news_score",
            title: "NEWS",
            icon: "exclamationmark.shield", // qSOFA sepsis screen
            category: .support,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createSOFAScoreProtocol() async -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "sofa_assessment",
                title: "SOFA Score Assessment",
                nodeType: .assessment,
                critical: true,
                content: "Sequential Organ Failure Assessment for organ dysfunction",
                connections: ["organ_dysfunction"]
            ),
            AlgorithmNode(
                id: "organ_dysfunction",
                title: "Organ Dysfunction Assessment",
                nodeType: .assessment,
                critical: true,
                content: "Score-based assessment of respiratory, cardiovascular, hepatic, coagulation, renal, and neurological systems",
                connections: ["endpoint"]
            ),
            AlgorithmNode(
                id: "endpoint",
                title: "Protocol End",
                nodeType: .endpoint,
                critical: false,
                content: "Protocol completed. Document score and organ dysfunction assessment.",
                connections: []
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "SOFA Score",
                sections: [
                    CardSection(title: "Organ Systems", items: [
                        "🫁 Respiratory (PaO2/FiO2)",
                        "💓 Cardiovascular (vasopressors)",
                        "🩸 Coagulation (platelets)",
                        "🩸 Hepatic (bilirubin)",
                        "🩸 Renal (creatinine)",
                        "🧠 Neurological (GCS)"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "sofa_score",
            title: "SOFA Score",
            icon: "heart.text.clipboard", // NEWS early warning
            category: .support,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createAnionGapProtocol() async -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "anion_gap_calculation",
                title: "Anion Gap Calculation",
                nodeType: .assessment,
                critical: true,
                content: "Anion Gap = Na+ - (Cl- + HCO3-)",
                connections: ["interpretation"]
            ),
            AlgorithmNode(
                id: "interpretation",
                title: "Interpretation",
                nodeType: .assessment,
                critical: true,
                content: "Normal: 8-16 mEq/L, Elevated: >16 mEq/L suggests metabolic acidosis",
                connections: ["endpoint"]
            ),
            AlgorithmNode(
                id: "endpoint",
                title: "Protocol End",
                nodeType: .endpoint,
                critical: false,
                content: "Protocol completed. Document anion gap and interpretation.",
                connections: []
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Anion Gap",
                sections: [
                    CardSection(title: "Calculation", items: [
                        "🩸 Anion Gap = Na+ - (Cl- + HCO3-)",
                        "📊 Normal range: 8-16 mEq/L",
                        "⚠️ Elevated: >16 mEq/L",
                        "🔍 Differential diagnosis"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "anion_gap",
            title: "Anion Gap",
            icon: "plus.forwardslash.minus", // Anion gap calculation
            category: .support,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    // MARK: - Pharmacology Tools
    
    private func createQTcCalculationProtocol() async -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "qtc_calculation",
                title: "QTc Calculation",
                nodeType: .assessment,
                critical: true,
                content: "Bazett and Fridericia formulas for corrected QT interval",
                connections: ["interpretation"]
            ),
            AlgorithmNode(
                id: "interpretation",
                title: "QTc Interpretation",
                nodeType: .assessment,
                critical: true,
                content: "Normal: <440ms (males), <460ms (females), Prolonged: >500ms",
                connections: ["endpoint"]
            ),
            AlgorithmNode(
                id: "endpoint",
                title: "Protocol End",
                nodeType: .endpoint,
                critical: false,
                content: "Protocol completed. Document QTc and interpretation.",
                connections: []
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "QTc Calculation",
                sections: [
                    CardSection(title: "Formulas", items: [
                        "📏 Bazett: QTc = QT/√RR",
                        "📏 Fridericia: QTc = QT/RR^(1/3)",
                        "📊 Normal: <440ms (M), <460ms (F)",
                        "⚠️ Prolonged: >500ms"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "qtc_calculation",
            title: "QTc Calculation",
            icon: "waveform.path.ecg",
            category: .cardiac,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createCreatinineClearanceProtocol() async -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "cockcroft_gault",
                title: "Cockcroft-Gault Calculation",
                nodeType: .assessment,
                critical: true,
                content: "Creatinine clearance for drug dosing adjustments",
                connections: ["dosing_adjustment"]
            ),
            AlgorithmNode(
                id: "dosing_adjustment",
                title: "Dosing Adjustment",
                nodeType: .assessment,
                critical: true,
                content: "Dose adjustment recommendations based on CrCl",
                connections: ["endpoint"]
            ),
            AlgorithmNode(
                id: "endpoint",
                title: "Protocol End",
                nodeType: .endpoint,
                critical: false,
                content: "Protocol completed. Document CrCl and dosing recommendations.",
                connections: []
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Creatinine Clearance",
                sections: [
                    CardSection(title: "Cockcroft-Gault Formula", items: [
                        "🧮 CrCl = [(140-age) × weight] / (72 × SCr)",
                        "👤 Female: multiply by 0.85",
                        "💊 Dose adjustment recommendations",
                        "📊 Normal: 90-120 mL/min"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "creatinine_clearance",
            title: "Creatinine Clearance",
            icon: "drop.degreesign", // Creatinine clearance
            category: .support,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createOpiateConversionProtocol() async -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "mme_calculation",
                title: "Morphine Milligram Equivalents",
                nodeType: .assessment,
                critical: true,
                content: "Opiate conversion with morphine milligram equivalents",
                connections: ["conversion_table"]
            ),
            AlgorithmNode(
                id: "conversion_table",
                title: "Conversion Table",
                nodeType: .assessment,
                critical: true,
                content: "Equianalgesic dosing conversions",
                connections: ["endpoint"]
            ),
            AlgorithmNode(
                id: "endpoint",
                title: "Protocol End",
                nodeType: .endpoint,
                critical: false,
                content: "Protocol completed. Document conversion and dosing.",
                connections: []
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Opiate Conversion",
                sections: [
                    CardSection(title: "Common Conversions", items: [
                        "💊 Morphine 10mg PO = 5mg IV",
                        "💊 Oxycodone 5mg = Morphine 7.5mg",
                        "💊 Fentanyl 100mcg = Morphine 10mg",
                        "💊 Hydromorphone 1.5mg = Morphine 10mg"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "opiate_conversion",
            title: "Opiate Conversion",
            icon: "pills.fill", // MELD liver disease score
            category: .support,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createCorrectedCalciumProtocol() async -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "corrected_calcium",
                title: "Corrected Calcium Calculator",
                nodeType: .assessment,
                critical: true,
                content: "Corrected Ca = Total Ca + 0.8 × (4.0 - Albumin)",
                connections: ["interpretation"]
            ),
            AlgorithmNode(
                id: "interpretation",
                title: "Interpretation",
                nodeType: .assessment,
                critical: true,
                content: "Normal: 8.5-10.5 mg/dL, Adjusted for albumin",
                connections: ["endpoint"]
            ),
            AlgorithmNode(
                id: "endpoint",
                title: "Protocol End",
                nodeType: .endpoint,
                critical: false,
                content: "Protocol completed. Document corrected calcium.",
                connections: []
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Corrected Calcium",
                sections: [
                    CardSection(title: "Calculation", items: [
                        "🧮 Corrected Ca = Total Ca + 0.8 × (4.0 - Albumin)",
                        "📊 Normal: 8.5-10.5 mg/dL",
                        "🩸 Adjusts for hypoalbuminemia",
                        "🦴 Clinical interpretation"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "corrected_calcium",
            title: "Corrected Calcium Calculator",
            icon: "thermometer", // Parkland burn formula
            category: .support,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createFeNaProtocol() async -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "fena_calculation",
                title: "FeNa Calculation",
                nodeType: .assessment,
                critical: true,
                content: "Fractional Excretion of Sodium for AKI differentiation",
                connections: ["interpretation"]
            ),
            AlgorithmNode(
                id: "interpretation",
                title: "Interpretation",
                nodeType: .assessment,
                critical: true,
                content: "<1%: Prerenal, >2%: Intrinsic renal, 1-2%: Indeterminate",
                connections: ["endpoint"]
            ),
            AlgorithmNode(
                id: "endpoint",
                title: "Protocol End",
                nodeType: .endpoint,
                critical: false,
                content: "Protocol completed. Document FeNa and interpretation.",
                connections: []
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "FeNa",
                sections: [
                    CardSection(title: "Calculation", items: [
                        "🧮 FeNa = (UNa × PCr) / (PNa × UCr) × 100",
                        "📊 <1%: Prerenal AKI",
                        "📊 >2%: Intrinsic renal AKI",
                        "📊 1-2%: Indeterminate"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "fena",
            title: "FeNa",
            icon: "waveform.badge.plus", // CURB-65 pneumonia
            category: .support,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    // MARK: - Infectious Disease Calculators
    
    private func createCURB65Protocol() async -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "curb65_assessment",
                title: "CURB-65 Assessment",
                nodeType: .assessment,
                critical: true,
                content: "Pneumonia severity assessment for disposition decisions",
                connections: ["severity_assessment"]
            ),
            AlgorithmNode(
                id: "severity_assessment",
                title: "Severity Assessment",
                nodeType: .assessment,
                critical: true,
                content: "0-1: Low risk, 2: Moderate risk, ≥3: High risk",
                connections: ["endpoint"]
            ),
            AlgorithmNode(
                id: "endpoint",
                title: "Protocol End",
                nodeType: .endpoint,
                critical: false,
                content: "Protocol completed. Document score and severity.",
                connections: []
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "CURB-65 Score",
                sections: [
                    CardSection(title: "Assessment Criteria", items: [
                        "🧠 Confusion",
                        "🩸 Urea >7 mmol/L",
                        "💓 Respiratory rate ≥30/min",
                        "🩸 Blood pressure <90/60",
                        "👴 Age ≥65 years"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "curb65_score",
            title: "CURB-65",
            icon: "wind.snow", // PSI pneumonia severity
            category: .respiratory,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createPneumoniaSeverityIndexProtocol() async -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "psi_assessment",
                title: "PSI Assessment",
                nodeType: .assessment,
                critical: true,
                content: "Pneumonia Severity Index for disposition decisions",
                connections: ["risk_classification"]
            ),
            AlgorithmNode(
                id: "risk_classification",
                title: "Risk Classification",
                nodeType: .assessment,
                critical: true,
                content: "Class I-II: Low risk, Class III: Moderate risk, Class IV-V: High risk",
                connections: ["endpoint"]
            ),
            AlgorithmNode(
                id: "endpoint",
                title: "Protocol End",
                nodeType: .endpoint,
                critical: false,
                content: "Protocol completed. Document PSI class and risk.",
                connections: []
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Pneumonia Severity Index",
                sections: [
                    CardSection(title: "Risk Factors", items: [
                        "👴 Age and gender",
                        "🩸 Vital signs",
                        "🩸 Laboratory values",
                        "🩸 Comorbid conditions",
                        "🩸 Physical examination"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "pneumonia_severity_index",
            title: "Pneumonia Severity Index",
            icon: "lungs", // P/F ratio ARDS assessment
            category: .respiratory,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createSepsisScreeningProtocol() async -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "sepsis_screening",
                title: "Sepsis Screening",
                nodeType: .assessment,
                critical: true,
                content: "SIRS criteria integration for sepsis identification",
                connections: ["sepsis_assessment"]
            ),
            AlgorithmNode(
                id: "sepsis_assessment",
                title: "Sepsis Assessment",
                nodeType: .assessment,
                critical: true,
                content: "SIRS criteria and organ dysfunction assessment",
                connections: ["endpoint"]
            ),
            AlgorithmNode(
                id: "endpoint",
                title: "Protocol End",
                nodeType: .endpoint,
                critical: false,
                content: "Protocol completed. Document sepsis screening results.",
                connections: []
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Sepsis Screening",
                sections: [
                    CardSection(title: "SIRS Criteria", items: [
                        "🌡️ Temperature >38°C or <36°C",
                        "💓 Heart rate >90/min",
                        "🫁 Respiratory rate >20/min",
                        "🩸 WBC >12,000 or <4,000",
                        "🩸 Organ dysfunction assessment"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "sepsis_screening",
            title: "Sepsis Screening",
            icon: "drop.degreesign.fill", // FENa fractional sodium
            category: .infectious,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    // MARK: - Trauma Calculators
    
    private func createBodySurfaceAreaProtocol() async -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "bsa_calculation",
                title: "Body Surface Area Calculator",
                nodeType: .assessment,
                critical: true,
                content: "Dubois formula: BSA = 0.007184 × weight^0.425 × height^0.725",
                connections: ["interpretation"]
            ),
            AlgorithmNode(
                id: "interpretation",
                title: "Interpretation",
                nodeType: .assessment,
                critical: true,
                content: "BSA for drug dosing and burn assessment",
                connections: ["endpoint"]
            ),
            AlgorithmNode(
                id: "endpoint",
                title: "Protocol End",
                nodeType: .endpoint,
                critical: false,
                content: "Protocol completed. Document BSA and applications.",
                connections: []
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Body Surface Area",
                sections: [
                    CardSection(title: "Calculation", items: [
                        "🧮 Dubois: BSA = 0.007184 × W^0.425 × H^0.725",
                        "📏 Weight in kg, Height in cm",
                        "💊 Drug dosing applications",
                        "🔥 Burn assessment"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "body_surface_area",
            title: "Body Surface Area Calculator",
            icon: "figure.stand", // BMI body mass index
            category: .trauma,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createMaintenanceFluidProtocol() async -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "maintenance_fluid",
                title: "Maintenance Fluid Calculator",
                nodeType: .assessment,
                critical: true,
                content: "4-2-1 rule: 4mL/kg/hr for first 10kg, 2mL/kg/hr for next 10kg, 1mL/kg/hr for remainder",
                connections: ["fluid_requirements"]
            ),
            AlgorithmNode(
                id: "fluid_requirements",
                title: "Fluid Requirements",
                nodeType: .assessment,
                critical: true,
                content: "Daily fluid requirements and electrolyte composition",
                connections: ["endpoint"]
            ),
            AlgorithmNode(
                id: "endpoint",
                title: "Protocol End",
                nodeType: .endpoint,
                critical: false,
                content: "Protocol completed. Document fluid requirements.",
                connections: []
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Maintenance Fluid",
                sections: [
                    CardSection(title: "4-2-1 Rule", items: [
                        "💧 4 mL/kg/hr for first 10 kg",
                        "💧 2 mL/kg/hr for next 10 kg",
                        "💧 1 mL/kg/hr for remainder",
                        "🧂 Electrolyte composition"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "maintenance_fluid",
            title: "Maintenance Fluid Calculator",
            icon: "liver.fill", // Child-Pugh liver cirrhosis
            category: .support,
            algorithm: algorithm,
            cards: cards
        )
    }
}
