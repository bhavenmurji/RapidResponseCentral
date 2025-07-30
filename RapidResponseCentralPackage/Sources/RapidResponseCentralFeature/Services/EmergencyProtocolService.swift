import Foundation
import SwiftUI

// MARK: - Emergency Protocol Service

@MainActor
public class EmergencyProtocolService: ObservableObject {
    @Published public private(set) var protocols: [EmergencyProtocol] = []
    @Published public private(set) var isLoading = false
    
    public init() {
        loadEmergencyProtocols()
    }
    
    private func loadEmergencyProtocols() {
        isLoading = true
        defer { isLoading = false }
        
        protocols = createEmergencyProtocols()
    }
    
    private func createEmergencyProtocols() -> [EmergencyProtocol] {
        return [
            createCodeBlueProtocol(),
            createCodeStrokeProtocol(),
            createCodeSTEMIProtocol(),
            createRSIProtocol(),
            createShockProtocol()
        ]
    }
    
    // MARK: - Code Blue Protocol
    
    private func createCodeBlueProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "initial_assessment",
                title: "Initial Assessment",
                nodeType: .assessment,
                critical: true,
                content: "Check responsiveness and pulse. Call for help immediately.",
                connections: ["cpr_check"]
            ),
            AlgorithmNode(
                id: "cpr_check",
                title: "CPR Decision",
                nodeType: .decision,
                critical: true,
                content: "Is patient in cardiac arrest (no pulse)?",
                connections: ["start_cpr", "advanced_assessment"]
            ),
            AlgorithmNode(
                id: "start_cpr",
                title: "Start CPR",
                nodeType: .intervention,
                critical: true,
                content: "Begin high-quality CPR: 100-120/min, 2+ inches depth, minimal interruptions",
                connections: ["rhythm_check"]
            ),
            AlgorithmNode(
                id: "rhythm_check",
                title: "Rhythm Analysis",
                nodeType: .assessment,
                critical: true,
                content: "Analyze rhythm: VF/VT vs PEA/Asystole",
                connections: ["shockable", "non_shockable"]
            ),
            AlgorithmNode(
                id: "shockable",
                title: "Shockable Rhythm",
                nodeType: .intervention,
                critical: true,
                content: "Deliver shock, resume CPR immediately for 2 minutes",
                connections: ["epinephrine"]
            ),
            AlgorithmNode(
                id: "non_shockable",
                title: "Non-Shockable Rhythm",
                nodeType: .intervention,
                critical: true,
                content: "Continue CPR, consider reversible causes (H's and T's)",
                connections: ["epinephrine"]
            ),
            AlgorithmNode(
                id: "epinephrine",
                title: "Epinephrine Administration",
                nodeType: .medication,
                critical: true,
                content: "Epinephrine 1mg IV/IO every 3-5 minutes",
                connections: ["continue_care"]
            ),
            AlgorithmNode(
                id: "continue_care",
                title: "Continue Resuscitation",
                nodeType: .intervention,
                critical: false,
                content: "Continue cycles, consider advanced interventions",
                connections: []
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Code Blue Status",
                sections: [
                    CardSection(title: "Current Priority", items: [
                        "High-quality CPR with minimal interruptions",
                        "Early defibrillation for VF/VT",
                        "Epinephrine every 3-5 minutes"
                    ])
                ]
            ),
            ProtocolCard(
                id: "assessment_card",
                type: .assessment,
                title: "Assessment & Causes",
                sections: [
                    CardSection(title: "H's and T's", items: [
                        "Hypovolemia, Hypoxia, Hydrogen ions (acidosis)",
                        "Hyperkalemia, Hypothermia",
                        "Tension pneumothorax, Tamponade",
                        "Toxins, Thrombosis (pulmonary/coronary)"
                    ]),
                    CardSection(title: "Initial Assessment", items: [
                        "Check responsiveness",
                        "Check carotid pulse (10 seconds max)",
                        "Assess breathing pattern"
                    ])
                ]
            ),
            ProtocolCard(
                id: "actions_card",
                type: .actions,
                title: "Actions & Medications",
                sections: [
                    CardSection(title: "CPR Guidelines", items: [
                        "Rate: 100-120 compressions/minute",
                        "Depth: At least 2 inches (5cm)",
                        "Complete recoil between compressions",
                        "Minimize interruptions (<10 seconds)"
                    ]),
                    CardSection(title: "Medications", items: [
                        "Epinephrine 1mg IV/IO q3-5min",
                        "Amiodarone 300mg IV/IO → 150mg",
                        "Lidocaine 1-1.5mg/kg if no amiodarone"
                    ]),
                    CardSection(title: "Post-ROSC Care", items: [
                        "Targeted temperature management",
                        "12-lead ECG",
                        "Hemodynamic optimization"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "code_blue",
            title: "Code Blue - ACLS",
            icon: "bx-pulse",
            category: .cardiac,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    // MARK: - Code Stroke Protocol
    
    private func createCodeStrokeProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "ct_head",
                title: "CT Head",
                nodeType: .assessment,
                critical: true,
                content: "Stat CT head without contrast",
                connections: ["hemorrhage_check"]
            ),
            AlgorithmNode(
                id: "hemorrhage_check",
                title: "Haemorrhage?",
                nodeType: .decision,
                critical: true,
                content: "Evidence of bleeding on CT scan",
                connections: ["contact_neurosurgeons", "aspirin_therapy"]
            ),
            AlgorithmNode(
                id: "contact_neurosurgeons",
                title: "Contact Neurosurgeons",
                nodeType: .intervention,
                critical: true,
                content: "Immediate neurosurgical consultation",
                connections: []
            ),
            AlgorithmNode(
                id: "aspirin_therapy",
                title: "Aspirin 300mg",
                nodeType: .medication,
                critical: false,
                content: "PO/NG/PR STAT",
                connections: ["time_window"]
            ),
            AlgorithmNode(
                id: "time_window",
                title: "< 4.5 hours since onset?",
                nodeType: .decision,
                critical: true,
                content: "Time window for thrombolysis",
                connections: ["thrombolysis", "maintenance_therapy"]
            ),
            AlgorithmNode(
                id: "thrombolysis",
                title: "Thrombolysis",
                nodeType: .intervention,
                critical: true,
                content: "TNK 0.25mg/kg IV bolus",
                connections: ["blood_pressure"]
            ),
            AlgorithmNode(
                id: "maintenance_therapy",
                title: "Continue Aspirin 300mg OD",
                nodeType: .medication,
                critical: false,
                content: "14 days then switch to clopidogrel 75mg PO OD",
                connections: ["blood_pressure"]
            ),
            AlgorithmNode(
                id: "blood_pressure",
                title: "Blood Pressure",
                nodeType: .endpoint,
                critical: false,
                content: "Only treat if hypertensive emergency with end-organ damage",
                connections: []
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Stroke Timeline",
                sections: [
                    CardSection(title: "Critical Actions", items: [
                        "Door to CT: <25 minutes",
                        "Door to needle: <60 minutes",
                        "Call Sevaro immediately for consultation"
                    ])
                ]
            ),
            ProtocolCard(
                id: "assessment_card",
                type: .assessment,
                title: "Stroke Assessment",
                sections: [
                    CardSection(title: "FAST-ED Assessment", items: [
                        "Facial droop",
                        "Arm weakness",
                        "Speech difficulty",
                        "Time of onset",
                        "Eye deviation",
                        "Denial/neglect"
                    ]),
                    CardSection(title: "Sevaro Numbers", items: [
                        "Voorhees: 856-347-3098",
                        "Berlin: 856-363-0709",
                        "Camden: 856-440-9978",
                        "Marlton: 856-341-7949"
                    ])
                ]
            ),
            ProtocolCard(
                id: "actions_card",
                type: .actions,
                title: "Treatment Protocol",
                sections: [
                    CardSection(title: "TNK (Tenecteplase)", items: [
                        "Dose: 0.25mg/kg IV bolus",
                        "Max dose: 25mg",
                        "Given over 5-10 seconds",
                        "Within 4.5 hours of onset"
                    ]),
                    CardSection(title: "Contraindications", items: [
                        "Recent surgery/trauma",
                        "Active bleeding",
                        "Platelets <100k",
                        "INR >1.7, severe hypertension"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "code_stroke",
            title: "Code Stroke",
            icon: "bx-brain",
            category: .neurological,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    // MARK: - Code STEMI Protocol
    
    private func createCodeSTEMIProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "ecg_analysis",
                title: "12-Lead ECG",
                nodeType: .assessment,
                critical: true,
                content: "STEMI criteria: ≥1mm ST elevation in ≥2 contiguous leads",
                connections: ["stemi_confirmed"]
            ),
            AlgorithmNode(
                id: "stemi_confirmed",
                title: "STEMI Activation",
                nodeType: .decision,
                critical: true,
                content: "Activate cathlab. Call Transfer Center 856-886-5111",
                connections: ["dual_antiplatelet"]
            ),
            AlgorithmNode(
                id: "dual_antiplatelet",
                title: "Antiplatelet Therapy",
                nodeType: .medication,
                critical: true,
                content: "ASA 325mg + Clopidogrel 600mg loading dose",
                connections: ["anticoagulation"]
            ),
            AlgorithmNode(
                id: "anticoagulation",
                title: "Anticoagulation",
                nodeType: .medication,
                critical: true,
                content: "Heparin per protocol, consider bivalirudin",
                connections: ["transfer_prep"]
            ),
            AlgorithmNode(
                id: "transfer_prep",
                title: "Transfer Preparation",
                nodeType: .intervention,
                critical: false,
                content: "Prepare for emergent cardiac catheterization",
                connections: []
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "STEMI Timeline",
                sections: [
                    CardSection(title: "Door-to-Balloon Goal", items: [
                        "Target: <90 minutes",
                        "Transfer Center: 856-886-5111",
                        "Activate cathlab immediately"
                    ])
                ]
            ),
            ProtocolCard(
                id: "assessment_card",
                type: .assessment,
                title: "STEMI Criteria",
                sections: [
                    CardSection(title: "ECG Criteria", items: [
                        "≥1mm ST elevation in ≥2 contiguous leads",
                        "New LBBB (equivalent)",
                        "Posterior STEMI: ST depression V1-V3"
                    ]),
                    CardSection(title: "Vessel Territories", items: [
                        "Anterior: V1-V6 (LAD)",
                        "Inferior: II, III, aVF (RCA)",
                        "Lateral: I, aVL, V5-V6 (LCX)"
                    ])
                ]
            ),
            ProtocolCard(
                id: "actions_card",
                type: .actions,
                title: "Acute Management",
                sections: [
                    CardSection(title: "Antiplatelet", items: [
                        "ASA 325mg chewed",
                        "Clopidogrel 600mg loading",
                        "Consider prasugrel/ticagrelor"
                    ]),
                    CardSection(title: "Anticoagulation", items: [
                        "Heparin 60 units/kg bolus",
                        "Max 4000 units",
                        "Target aPTT 50-70 seconds"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "code_stemi",
            title: "Code STEMI",
            icon: "bx-heart",
            category: .cardiac,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    // MARK: - RSI Protocol
    
    private func createRSIProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "rsi_prep",
                title: "RSI Preparation",
                nodeType: .assessment,
                critical: true,
                content: "Preoxygenate, prepare equipment, team briefing",
                connections: ["premedication"]
            ),
            AlgorithmNode(
                id: "premedication",
                title: "Premedication",
                nodeType: .medication,
                critical: false,
                content: "Consider fentanyl, lidocaine if indicated",
                connections: ["induction"]
            ),
            AlgorithmNode(
                id: "induction",
                title: "Induction Agent",
                nodeType: .medication,
                critical: true,
                content: "Ketamine 1-2mg/kg OR Propofol 1-2mg/kg",
                connections: ["paralysis"]
            ),
            AlgorithmNode(
                id: "paralysis",
                title: "Neuromuscular Blockade",
                nodeType: .medication,
                critical: true,
                content: "Rocuronium 1-1.2mg/kg IV push",
                connections: ["intubation"]
            ),
            AlgorithmNode(
                id: "intubation",
                title: "Intubation",
                nodeType: .intervention,
                critical: true,
                content: "Direct laryngoscopy or video laryngoscopy",
                connections: ["confirmation"]
            ),
            AlgorithmNode(
                id: "confirmation",
                title: "Tube Confirmation",
                nodeType: .assessment,
                critical: true,
                content: "End-tidal CO2, bilateral breath sounds, CXR",
                connections: ["post_intubation"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "RSI Checklist",
                sections: [
                    CardSection(title: "Pre-RSI", items: [
                        "Preoxygenate ≥3 minutes",
                        "Equipment check complete",
                        "Backup airway ready"
                    ])
                ]
            ),
            ProtocolCard(
                id: "assessment_card",
                type: .assessment,
                title: "Difficult Airway Predictors",
                sections: [
                    CardSection(title: "LEMON Assessment", items: [
                        "Look externally",
                        "Evaluate 3-3-2 rule",
                        "Mallampati score",
                        "Obstruction/obesity",
                        "Neck mobility"
                    ])
                ]
            ),
            ProtocolCard(
                id: "actions_card",
                type: .actions,
                title: "Medications & Dosing",
                sections: [
                    CardSection(title: "Induction Agents", items: [
                        "Ketamine: 1-2mg/kg",
                        "Propofol: 1-2mg/kg",
                        "Etomidate: 0.3mg/kg"
                    ]),
                    CardSection(title: "Paralytic Agents", items: [
                        "Rocuronium: 1-1.2mg/kg",
                        "Succinylcholine: 1-1.5mg/kg",
                        "Onset: 60-90 seconds"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "rsi_protocol",
            title: "RSI & Advanced Airway",
            icon: "bx-ambulance",
            category: .respiratory,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    // MARK: - Shock Protocol
    
    private func createShockProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "shock_recognition",
                title: "Shock Recognition",
                nodeType: .assessment,
                critical: true,
                content: "Hypotension + signs of hypoperfusion",
                connections: ["shock_classification"]
            ),
            AlgorithmNode(
                id: "shock_classification",
                title: "Classify Shock Type",
                nodeType: .decision,
                critical: true,
                content: "Distributive, cardiogenic, hypovolemic, or obstructive?",
                connections: ["fluid_resuscitation", "vasopressors", "inotropes"]
            ),
            AlgorithmNode(
                id: "fluid_resuscitation",
                title: "Fluid Challenge",
                nodeType: .intervention,
                critical: true,
                content: "500-1000mL crystalloid bolus, reassess",
                connections: ["reassessment"]
            ),
            AlgorithmNode(
                id: "vasopressors",
                title: "Vasopressor Therapy",
                nodeType: .medication,
                critical: true,
                content: "Norepinephrine first-line, titrate to MAP >65",
                connections: ["ecmo_consideration"]
            ),
            AlgorithmNode(
                id: "reassessment",
                title: "Reassess Response",
                nodeType: .assessment,
                critical: false,
                content: "Evaluate hemodynamics, consider additional interventions",
                connections: []
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Shock Management",
                sections: [
                    CardSection(title: "Priority Actions", items: [
                        "Identify and treat underlying cause",
                        "Maintain MAP >65 mmHg",
                        "Consider ECMO for refractory shock"
                    ])
                ]
            ),
            ProtocolCard(
                id: "assessment_card",
                type: .assessment,
                title: "Shock Classification",
                sections: [
                    CardSection(title: "Types of Shock", items: [
                        "Distributive: Sepsis, anaphylaxis",
                        "Cardiogenic: MI, heart failure",
                        "Hypovolemic: Bleeding, dehydration",
                        "Obstructive: PE, tamponade"
                    ])
                ]
            ),
            ProtocolCard(
                id: "actions_card",
                type: .actions,
                title: "Treatment Options",
                sections: [
                    CardSection(title: "Vasopressors", items: [
                        "Norepinephrine: 0.1-30 mcg/min",
                        "Epinephrine: 0.1-10 mcg/min",
                        "Vasopressin: 0.01-0.04 units/min"
                    ]),
                    CardSection(title: "ECMO Activation", items: [
                        "Refractory cardiogenic shock",
                        "Consider early in appropriate candidates",
                        "Mobile ECMO team available"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "shock_protocol",
            title: "Shock & ECMO Protocols",
            icon: "bx-pulse",
            category: .cardiac,
            algorithm: algorithm,
            cards: cards
        )
    }
}