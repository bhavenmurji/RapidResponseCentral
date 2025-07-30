import Foundation
import SwiftUI

@MainActor
final class ProtocolService: ObservableObject {
    @Published private(set) var protocols: [EmergencyProtocol] = []
    @Published private(set) var rrtProtocols: [EmergencyProtocol] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    init() {
        loadSampleProtocols()
        // Load RRT protocols lazily to avoid blocking main thread
        Task {
            await loadRRTProtocolsAsync()
        }
    }
    
    private func loadSampleProtocols() {
        // Emergency protocols as specified in documentation
        protocols = [
            createCodeBlueProtocol(),
            createCodeStrokeProtocol(),
            createCodeSTEMIProtocol(),
            createRSIProtocol(),
            createShockProtocol()
        ]
    }
    
    func getProtocol(for id: String) -> EmergencyProtocol? {
        protocols.first { $0.id == id }
    }
    
    func getProtocol(by title: String) -> EmergencyProtocol? {
        protocols.first { $0.title == title }
    }
    
    private func createCodeBlueProtocol() -> EmergencyProtocol {
        EmergencyProtocol(
            id: "code-blue",
            title: "Code Blue – ACLS",
            icon: "🫀",
            category: .cardiac,
            algorithm: ProtocolAlgorithm(nodes: [
                AlgorithmNode(
                    id: "start",
                    title: "Unresponsive, no normal breathing",
                    nodeType: .assessment,
                    critical: true,
                    content: "Is the patient unresponsive, with no normal breathing or only gasping?",
                    connections: ["activate-code"]
                ),
                AlgorithmNode(
                    id: "activate-code",
                    title: "Code Blue Activated & High-Quality CPR Started",
                    nodeType: .intervention,
                    critical: true,
                    content: "Begin high-quality CPR. Activate Code Blue team?",
                    connections: ["attach-pads"]
                ),
                AlgorithmNode(
                    id: "attach-pads",
                    title: "Attach Pads and Analyze Rhythm",
                    nodeType: .assessment,
                    critical: true,
                    content: "Attach defibrillator/AED. Is a shockable rhythm detected (VF/pulseless VT)?",
                    connections: ["shockable", "non-shockable"]
                ),
                AlgorithmNode(
                    id: "shockable",
                    title: "Shockable Rhythm (VF/pulseless VT)",
                    nodeType: .decision,
                    critical: true,
                    content: "Deliver shock at 200J biphasic. Immediately resume CPR for 2min. Was shock delivered?",
                    connections: ["shock-delivered"]
                ),
                AlgorithmNode(
                    id: "shock-delivered",
                    title: "Shock 200J then Immediate CPR 2 min",
                    nodeType: .intervention,
                    critical: true,
                    content: "Continue CPR. 2-min timer started. Rotate compressor at next cycle?",
                    connections: ["cpr-cycle"]
                ),
                AlgorithmNode(
                    id: "cpr-cycle",
                    title: "CPR Timer & Rotate Compressor",
                    nodeType: .intervention,
                    critical: true,
                    content: "High-quality CPR: 100-120/min, 2 inches deep, complete recoil",
                    connections: ["rhythm-recheck"]
                ),
                AlgorithmNode(
                    id: "rhythm-recheck",
                    title: "Re-check Rhythm",
                    nodeType: .decision,
                    critical: true,
                    content: "Pause compressions <10 sec. Recheck rhythm: shockable or not?",
                    connections: ["rosc-check", "shockable", "non-shockable"]
                ),
                AlgorithmNode(
                    id: "non-shockable",
                    title: "Non-Shockable Rhythm (PEA/Asystole)",
                    nodeType: .decision,
                    critical: true,
                    content: "No shock advised. Resume CPR for 2min. Administer epinephrine 1mg IV/IO?",
                    connections: ["cpr-with-epi"]
                ),
                AlgorithmNode(
                    id: "cpr-with-epi",
                    title: "CPR 2 min with Epinephrine for PEA or Asystole",
                    nodeType: .intervention,
                    critical: true,
                    content: "Give epinephrine 1mg IV/IO every 3–5min as soon as possible for non-shockable rhythm?",
                    connections: ["cpr-cycle"]
                ),
                AlgorithmNode(
                    id: "refractory-vf",
                    title: "Refractory VF/pulseless VT",
                    nodeType: .medication,
                    critical: true,
                    content: "Still in VF/pulseless VT after multiple shocks? Give amiodarone 300mg IV/IO (then 150mg)?",
                    connections: ["cpr-cycle"]
                ),
                AlgorithmNode(
                    id: "advanced-airway",
                    title: "Advanced Airway / ETCO2 Monitoring",
                    nodeType: .intervention,
                    critical: false,
                    content: "Consider advanced airway. Confirm with ETCO₂. Continue compressions?",
                    connections: ["cpr-cycle"]
                ),
                AlgorithmNode(
                    id: "reversible-causes",
                    title: "Reversible Causes (H's & T's)",
                    nodeType: .assessment,
                    critical: false,
                    content: "Evaluate/treat reversible causes (H's & T's): Hypoxia? Hypovolemia? Hyper-K+? Tamponade? MI?",
                    connections: ["cpr-cycle"]
                ),
                AlgorithmNode(
                    id: "rosc-check",
                    title: "ROSC Achieved",
                    nodeType: .decision,
                    critical: true,
                    content: "Has return of spontaneous circulation (ROSC) been achieved?",
                    connections: ["post-rosc", "cpr-cycle"]
                ),
                AlgorithmNode(
                    id: "post-rosc",
                    title: "Post-ROSC Care",
                    nodeType: .endpoint,
                    critical: false,
                    content: "Begin post–cardiac arrest care: manage airway, oxygenate, initiate hypothermia protocol (TTM)?",
                    connections: []
                ),
                AlgorithmNode(
                    id: "virtua-icu",
                    title: "Virtua ICU Transfer Criteria",
                    nodeType: .endpoint,
                    critical: false,
                    content: "Patient stable for Virtua Voorhees ICU? Initiate transfer protocols and continuous monitoring?",
                    connections: []
                )
            ]),
            cards: [
                ProtocolCard(
                    id: "dynamic",
                    type: .dynamic,
                    title: "Dynamic Action Card",
                    sections: [
                        CardSection(
                            title: "IMMEDIATE ACTIONS",
                            items: [
                                "Start CPR if indicated",
                                "Charge defibrillator to 200J",
                                "Deliver shock for VF/pVT",
                                "Administer medications per algorithm"
                            ]
                        ),
                        CardSection(
                            title: "CPR QUALITY",
                            items: [
                                "Rate: 100-120 compressions/min",
                                "Depth: At least 2 inches (5cm)",
                                "Allow complete chest recoil",
                                "Minimize interruptions (<10 sec)"
                            ]
                        ),
                        CardSection(
                            title: "SHOCK COUNTER",
                            items: [
                                "After 2nd shock: Give Epinephrine 1mg IV/IO",
                                "After 3rd shock: Give Amiodarone 300mg IV/IO"
                            ]
                        )
                    ]
                ),
                ProtocolCard(
                    id: "assessment",
                    type: .assessment,
                    title: "CAUSES & DIFFERENTIAL (H's & T's)",
                    sections: [
                        CardSection(
                            title: "H's",
                            items: [
                                "🩸 Hypovolemia - IV fluids, blood products",
                                "🫁 Hypoxia - Secure airway, 100% O2",
                                "💧 Hypo/Hyperkalemia - Check K+, treat accordingly",
                                "🧊 Hypothermia - Check temp, warm patient",
                                "🪒 H+ (acidosis) - Check ABG, give bicarb if pH <7.1"
                            ]
                        ),
                        CardSection(
                            title: "T's",
                            items: [
                                "⚡ Thrombosis (MI) - Consider PCI/thrombolytics",
                                "⚡ Thrombosis (PE) - Consider thrombolytics",
                                "💉 Toxins - Specific antidotes, toxicology consult",
                                "💓 Tamponade - Echo, pericardiocentesis",
                                "🫁 Tension Pneumothorax - Needle decompression"
                            ]
                        ),
                        CardSection(
                            title: "HISTORY",
                            items: [
                                "Witnessed? Bystander CPR? DNR? Initial rhythm?"
                            ]
                        )
                    ]
                ),
                ProtocolCard(
                    id: "actions",
                    type: .actions,
                    title: "PHYSICAL EXAM & MEDICATIONS",
                    sections: [
                        CardSection(
                            title: "EXAM",
                            items: [
                                "ABCDE assessment",
                                "Airway/breath sounds/ETCO2/SpO2",
                                "Pulse checks between cycles",
                                "Pupil reactivity"
                            ]
                        ),
                        CardSection(
                            title: "MEDICATIONS",
                            items: [
                                "💊 EPI 1mg IV/IO q3–5min",
                                "💡 AMIO 300mg → 150mg (for VF/pVT)",
                                "🔢 LIDOCAINE: 1–1.5mg/kg IV/IO (if no amio)",
                                "Consider: Calcium, bicarb, magnesium for specific causes"
                            ]
                        ),
                        CardSection(
                            title: "POST-ROSC",
                            items: [
                                "Targeted temperature management 32–36°C",
                                "Optimize oxygenation/ventilation",
                                "Treat precipitating causes",
                                "Consider cardiac catheterization"
                            ]
                        ),
                        CardSection(
                            title: "CONTRAINDICATIONS",
                            items: [
                                "None in arrest, benefit > risk"
                            ]
                        )
                    ]
                )
            ]
        )
    }
    
    private func createCodeStrokeProtocol() -> EmergencyProtocol {
        EmergencyProtocol(
            id: "code-stroke",
            title: "Code Stroke – Acute Ischemic Stroke",
            icon: "🧠",
            category: .neurological,
            algorithm: ProtocolAlgorithm(nodes: [
                AlgorithmNode(
                    id: "start",
                    title: "Stroke Alert Activated Call Code Stroke 99",
                    nodeType: .assessment,
                    critical: true,
                    content: "Stroke symptoms identified. Activate Code Stroke 99 immediately?",
                    connections: ["nihss-assessment"]
                ),
                AlgorithmNode(
                    id: "nihss-assessment",
                    title: "Assess NIHSS and Obtain Vital Signs",
                    nodeType: .assessment,
                    critical: true,
                    content: "Complete NIH Stroke Scale assessment. Current total score and severity?",
                    connections: ["ct-head"]
                ),
                AlgorithmNode(
                    id: "ct-head",
                    title: "CT Head STAT within 25 minutes",
                    nodeType: .intervention,
                    critical: true,
                    content: "CT Head completed within 25 minutes. Any signs of hemorrhage visible?",
                    connections: ["hemorrhage-decision"]
                ),
                AlgorithmNode(
                    id: "hemorrhage-decision",
                    title: "Hemorrhage on CT?",
                    nodeType: .decision,
                    critical: true,
                    content: "Hemorrhagic stroke confirmed on CT?",
                    connections: ["hemorrhagic-stroke", "lvo-screening"]
                ),
                AlgorithmNode(
                    id: "hemorrhagic-stroke",
                    title: "Hemorrhagic Stroke ICH/SAH Protocol",
                    nodeType: .intervention,
                    critical: true,
                    content: "Hemorrhagic stroke confirmed on CT. Initiate ICH/SAH management protocol?",
                    connections: ["neurosurgery-consult", "icu-management"]
                ),
                AlgorithmNode(
                    id: "lvo-screening",
                    title: "LVO Screening NIHSS ≥6?",
                    nodeType: .decision,
                    critical: true,
                    content: "NIHSS ≥6 suggesting large vessel occlusion. Order CTA brain and neck?",
                    connections: ["cta-brain-neck", "tnk-eligible"]
                ),
                AlgorithmNode(
                    id: "cta-brain-neck",
                    title: "CTA Brain/Neck Consider Thrombectomy",
                    nodeType: .intervention,
                    critical: true,
                    content: "CTA ordered. Consider thrombectomy evaluation.",
                    connections: ["consult-teleneurology"]
                ),
                AlgorithmNode(
                    id: "tnk-eligible",
                    title: "TNK Eligible Check Contraindications",
                    nodeType: .decision,
                    critical: true,
                    content: "Patient within 4.5 hour window. Complete TNK contraindication screening?",
                    connections: ["consult-teleneurology"]
                ),
                AlgorithmNode(
                    id: "consult-teleneurology",
                    title: "Consult Teleneurology Sevaro 856-247-3098",
                    nodeType: .intervention,
                    critical: true,
                    content: "Contact Sevaro teleneurology for expert stroke consultation?",
                    connections: ["tnk-recommended"]
                ),
                AlgorithmNode(
                    id: "tnk-recommended",
                    title: "TNK Recommended?",
                    nodeType: .decision,
                    critical: true,
                    content: "Teleneurology consultation complete. Proceed with TNK administration?",
                    connections: ["initiate-tnk", "medical-management"]
                ),
                AlgorithmNode(
                    id: "initiate-tnk",
                    title: "Initiate TNK 0.25mg/kg IV bolus",
                    nodeType: .medication,
                    critical: true,
                    content: "TNK 0.25mg/kg administered as single IV bolus. Begin monitoring protocol?",
                    connections: ["post-tnk-monitoring"]
                ),
                AlgorithmNode(
                    id: "medical-management",
                    title: "Medical Management Antiplatelet Therapy",
                    nodeType: .intervention,
                    critical: false,
                    content: "TNK not indicated. Begin standard medical management with antiplatelet therapy?",
                    connections: ["stroke-unit-admission"]
                ),
                AlgorithmNode(
                    id: "post-tnk-monitoring",
                    title: "Post-TNK Monitoring Neuro checks q15min",
                    nodeType: .intervention,
                    critical: true,
                    content: "Post-thrombolytic monitoring active. Any neurological changes or bleeding signs?",
                    connections: ["thrombectomy-candidate"]
                ),
                AlgorithmNode(
                    id: "thrombectomy-candidate",
                    title: "Thrombectomy Candidate?",
                    nodeType: .decision,
                    critical: true,
                    content: "Patient eligible for mechanical thrombectomy within treatment window?",
                    connections: ["transfer-for-evt", "stroke-unit-admission"]
                ),
                AlgorithmNode(
                    id: "transfer-for-evt",
                    title: "Transfer for EVT Within 6-24 hours",
                    nodeType: .intervention,
                    critical: true,
                    content: "Transfer for endovascular thrombectomy",
                    connections: ["stroke-unit-admission"]
                ),
                AlgorithmNode(
                    id: "stroke-unit-admission",
                    title: "Stroke Unit Admission Secondary Prevention",
                    nodeType: .endpoint,
                    critical: false,
                    content: "Admit to stroke unit for ongoing care and secondary stroke prevention?",
                    connections: []
                ),
                AlgorithmNode(
                    id: "neurosurgery-consult",
                    title: "Neurosurgery Consult BP Management",
                    nodeType: .intervention,
                    critical: true,
                    content: "Hemorrhagic stroke requires neurosurgical evaluation and intensive monitoring?",
                    connections: ["icu-management"]
                ),
                AlgorithmNode(
                    id: "icu-management",
                    title: "ICU Management ICP Monitoring",
                    nodeType: .endpoint,
                    critical: true,
                    content: "ICU admission for ICP monitoring and management",
                    connections: []
                )
            ]),
            cards: [
                ProtocolCard(
                    id: "dynamic",
                    type: .dynamic,
                    title: "NIH STROKE SCALE ASSESSMENT",
                    sections: [
                        CardSection(
                            title: "DOOR-TO-NEEDLE TIMER",
                            items: [
                                "🕐 Target: <60 minutes from arrival",
                                "Current time: [TIMER]"
                            ]
                        ),
                        CardSection(
                            title: "NIH STROKE SCALE CALCULATOR",
                            items: [
                                "1a. Level of Consciousness: 0-3",
                                "1b. LOC Questions: 0-2",
                                "1c. LOC Commands: 0-2",
                                "2. Best Gaze: 0-2",
                                "3. Visual Fields: 0-3",
                                "4. Facial Palsy: 0-3",
                                "5a. Motor Left Arm: 0-4",
                                "5b. Motor Right Arm: 0-4",
                                "6a. Motor Left Leg: 0-4",
                                "6b. Motor Right Leg: 0-4",
                                "7. Limb Ataxia: 0-2",
                                "8. Sensory: 0-2",
                                "9. Language: 0-3",
                                "10. Dysarthria: 0-2",
                                "11. Extinction/Inattention: 0-2",
                                "TOTAL NIHSS SCORE: [Calculate]"
                            ]
                        ),
                        CardSection(
                            title: "SEVARO TELENEUROLOGY",
                            items: [
                                "📞 Virtua Voorhees: 856-247-3098",
                                "Response time: <45 seconds",
                                "TNK ELIGIBILITY: Check based on assessment",
                                "⚠️ CRITICAL: Hold anticoagulants until ICH ruled out"
                            ]
                        )
                    ]
                ),
                ProtocolCard(
                    id: "assessment",
                    type: .assessment,
                    title: "STROKE TYPES & PATHOPHYSIOLOGY",
                    sections: [
                        CardSection(
                            title: "🧠 ISCHEMIC (87%)",
                            items: [
                                "LVO: ICA, MCA M1/M2, ACA, PCA, Basilar",
                                "Small vessel: Lacunar, deep penetrating arteries",
                                "Cardioembolic: A-fib (most common), valvular disease",
                                "Cryptogenic: Unknown etiology, consider PFO"
                            ]
                        ),
                        CardSection(
                            title: "🔴 HEMORRHAGIC (13%)",
                            items: [
                                "ICH: Hypertensive, AVM, amyloid angiopathy",
                                "SAH: Aneurysmal rupture, traumatic, AVM"
                            ]
                        ),
                        CardSection(
                            title: "FAST-ED Assessment",
                            items: [
                                "F - Facial droop",
                                "A - Arm weakness",
                                "S - Speech issues",
                                "T - Time of onset",
                                "E - Eyes (gaze/field)",
                                "D - Dizziness/ataxia"
                            ]
                        ),
                        CardSection(
                            title: "CRITICAL HISTORY",
                            items: [
                                "Last known normal time (EXACT)",
                                "Current medications (anticoagulants)",
                                "Functional baseline (mRS score)",
                                "RISK FACTORS: A-fib (5x), HTN (3-5x), DM (2-3x)"
                            ]
                        )
                    ]
                ),
                ProtocolCard(
                    id: "actions",
                    type: .actions,
                    title: "NEUROLOGICAL EXAM & TNK PROTOCOL",
                    sections: [
                        CardSection(
                            title: "VITAL SIGNS",
                            items: [
                                "BP: <185/110 for TNK (labetalol 10-20mg IV)",
                                "HR/Rhythm: Screen for A-fib",
                                "Temp: <38°C (treat hyperthermia)",
                                "Glucose: 140-180 mg/dL (avoid <60 mg/dL)"
                            ]
                        ),
                        CardSection(
                            title: "💊 TENECTEPLASE (TNK)",
                            items: [
                                "0.25 mg/kg IV bolus (max 25mg)",
                                "Single push over 5 seconds, no infusion",
                                "Dedicated IV line, flush before/after",
                                "Use within 4 hours of reconstitution"
                            ]
                        ),
                        CardSection(
                            title: "⚠️ ABSOLUTE CONTRAINDICATIONS",
                            items: [
                                "Active bleeding",
                                "Recent ICH (<3mo)",
                                "Head trauma (<14d)"
                            ]
                        ),
                        CardSection(
                            title: "⚠️ RELATIVE CONTRAINDICATIONS",
                            items: [
                                "Age >80",
                                "NIHSS >25",
                                "BP >185/110",
                                "Glucose <50/>400"
                            ]
                        ),
                        CardSection(
                            title: "POST-TNK",
                            items: [
                                "Neuro checks q15min x2hr",
                                "BP <180/105",
                                "No anticoagulants x24hr",
                                "ICU monitoring",
                                "CONTACTS: Transfer Center 856-886-5111"
                            ]
                        )
                    ]
                )
            ]
        )
    }
    
    private func createCodeSTEMIProtocol() -> EmergencyProtocol {
        EmergencyProtocol(
            id: "code-stemi",
            title: "Code STEMI – ST-Elevation MI",
            icon: "💔",
            category: .cardiac,
            algorithm: ProtocolAlgorithm(nodes: [
                AlgorithmNode(
                    id: "start",
                    title: "STEMI Recognition 12-lead ECG plus Clinical",
                    nodeType: .assessment,
                    critical: true,
                    content: "12-lead ECG shows STEMI criteria. Activate Code STEMI immediately?",
                    connections: ["stemi-criteria"]
                ),
                AlgorithmNode(
                    id: "stemi-criteria",
                    title: "STEMI Criteria Met?",
                    nodeType: .decision,
                    critical: true,
                    content: "Confirm STEMI criteria: ST elevation ≥1mm in 2+ contiguous leads?",
                    connections: ["code-stemi-activated", "evaluate-equivalents"]
                ),
                AlgorithmNode(
                    id: "code-stemi-activated",
                    title: "CODE STEMI ACTIVATED Start D2B Timer",
                    nodeType: .intervention,
                    critical: true,
                    content: "Code STEMI activated. Door-to-balloon timer started. Contact Transfer Center?",
                    connections: ["transfer-center"]
                ),
                AlgorithmNode(
                    id: "evaluate-equivalents",
                    title: "Evaluate STEMI Equivalents",
                    nodeType: .assessment,
                    critical: true,
                    content: "No classic STEMI pattern. Evaluate for STEMI equivalents (De Winter, posterior)?",
                    connections: ["stemi-equivalent-present", "nstemi-ua"]
                ),
                AlgorithmNode(
                    id: "stemi-equivalent-present",
                    title: "STEMI Equivalent Present?",
                    nodeType: .decision,
                    critical: true,
                    content: "STEMI equivalent identified?",
                    connections: ["transfer-center"]
                ),
                AlgorithmNode(
                    id: "nstemi-ua",
                    title: "NSTEMI/UA Protocol",
                    nodeType: .endpoint,
                    critical: false,
                    content: "No STEMI criteria. Consider NSTEMI/UA protocol",
                    connections: []
                ),
                AlgorithmNode(
                    id: "transfer-center",
                    title: "Transfer Center 856-886-5111",
                    nodeType: .intervention,
                    critical: true,
                    content: "Contact Transfer Center for cath lab activation and coordination?",
                    connections: ["immediate-actions"]
                ),
                AlgorithmNode(
                    id: "immediate-actions",
                    title: "Immediate Actions ASA IV Labs",
                    nodeType: .intervention,
                    critical: true,
                    content: "Complete immediate STEMI interventions: ASA, IV access, labs, ECG?",
                    connections: ["pci-available"]
                ),
                AlgorithmNode(
                    id: "pci-available",
                    title: "PCI Available <120 min?",
                    nodeType: .decision,
                    critical: true,
                    content: "Primary PCI available within 120 minutes from first medical contact?",
                    connections: ["primary-pci", "fibrinolysis-eligible"]
                ),
                AlgorithmNode(
                    id: "primary-pci",
                    title: "PRIMARY PCI Preferred Strategy",
                    nodeType: .intervention,
                    critical: true,
                    content: "Primary PCI strategy selected. Administer dual antiplatelet and anticoagulation?",
                    connections: ["p2y12-loading"]
                ),
                AlgorithmNode(
                    id: "fibrinolysis-eligible",
                    title: "Fibrinolysis Eligible?",
                    nodeType: .decision,
                    critical: true,
                    content: "PCI not available <120min. Patient eligible for fibrinolytic therapy?",
                    connections: ["tnk-administration", "transfer-for-pci"]
                ),
                AlgorithmNode(
                    id: "p2y12-loading",
                    title: "P2Y12 Loading and Anticoagulation",
                    nodeType: .medication,
                    critical: true,
                    content: "Administer P2Y12 inhibitor loading dose and anticoagulation for PCI?",
                    connections: ["cath-lab"]
                ),
                AlgorithmNode(
                    id: "tnk-administration",
                    title: "TNK 0.25mg/kg IV Push",
                    nodeType: .medication,
                    critical: true,
                    content: "Administer tenecteplase 0.25mg/kg IV push immediately?",
                    connections: ["monitor-reperfusion"]
                ),
                AlgorithmNode(
                    id: "transfer-for-pci",
                    title: "Transfer for Urgent PCI",
                    nodeType: .intervention,
                    critical: true,
                    content: "Not eligible for fibrinolysis. Transfer for urgent PCI",
                    connections: ["post-stemi-care"]
                ),
                AlgorithmNode(
                    id: "cath-lab",
                    title: "Cath Lab D2B Goal <90min",
                    nodeType: .intervention,
                    critical: true,
                    content: "Transfer to cath lab for primary PCI. Door-to-balloon goal <90 minutes?",
                    connections: ["cardiogenic-shock"]
                ),
                AlgorithmNode(
                    id: "monitor-reperfusion",
                    title: "Monitor Reperfusion ST Resolution",
                    nodeType: .assessment,
                    critical: true,
                    content: "Monitor for successful reperfusion: ST resolution, symptom relief?",
                    connections: ["successful-reperfusion"]
                ),
                AlgorithmNode(
                    id: "cardiogenic-shock",
                    title: "Cardiogenic Shock?",
                    nodeType: .decision,
                    critical: true,
                    content: "Evaluate for cardiogenic shock: hypotension, poor perfusion, elevated lactate?",
                    connections: ["mcs-ecmo", "standard-pci"]
                ),
                AlgorithmNode(
                    id: "successful-reperfusion",
                    title: "Successful Reperfusion?",
                    nodeType: .decision,
                    critical: true,
                    content: "Failed fibrinolysis. Proceed with rescue PCI immediately?",
                    connections: ["transfer-pci-2-24h", "rescue-pci"]
                ),
                AlgorithmNode(
                    id: "mcs-ecmo",
                    title: "MCS/ECMO Consideration",
                    nodeType: .intervention,
                    critical: true,
                    content: "Consider mechanical circulatory support",
                    connections: ["post-stemi-care"]
                ),
                AlgorithmNode(
                    id: "standard-pci",
                    title: "Standard PCI",
                    nodeType: .intervention,
                    critical: false,
                    content: "Proceed with standard PCI",
                    connections: ["post-stemi-care"]
                ),
                AlgorithmNode(
                    id: "transfer-pci-2-24h",
                    title: "Transfer for PCI 2-24 hours",
                    nodeType: .intervention,
                    critical: false,
                    content: "Successful reperfusion. Transfer for PCI within 2-24 hours",
                    connections: ["post-stemi-care"]
                ),
                AlgorithmNode(
                    id: "rescue-pci",
                    title: "Rescue PCI Immediate",
                    nodeType: .intervention,
                    critical: true,
                    content: "Failed fibrinolysis. Immediate rescue PCI",
                    connections: ["post-stemi-care"]
                ),
                AlgorithmNode(
                    id: "post-stemi-care",
                    title: "Post-STEMI Care",
                    nodeType: .endpoint,
                    critical: false,
                    content: "Initiate post-STEMI care: secondary prevention, monitoring, rehabilitation?",
                    connections: []
                )
            ]),
            cards: [
                ProtocolCard(
                    id: "dynamic",
                    type: .dynamic,
                    title: "CODE STEMI ACTIVATED",
                    sections: [
                        CardSection(
                            title: "DOOR-TO-BALLOON TIMER",
                            items: [
                                "🚨 Target: <90 minutes (PCI-capable)",
                                "Target: <120 minutes (transfer required)",
                                "Current time: [TIMER]"
                            ]
                        ),
                        CardSection(
                            title: "STEMI CRITERIA MET",
                            items: [
                                "☑ ST elevation ≥1mm (2+ leads)",
                                "☐ New LBBB (Sgarbossa criteria)",
                                "☐ Posterior MI (V1-V3 depression)",
                                "☐ STEMI equivalent identified"
                            ]
                        ),
                        CardSection(
                            title: "IMMEDIATE ACTIONS",
                            items: [
                                "☑ 12-lead ECG (<10 min)",
                                "☑ IV access x2 (18G)",
                                "☑ ASA 324mg chewed",
                                "☐ Labs ordered",
                                "☐ Transfer Center called",
                                "☐ Portable CXR"
                            ]
                        ),
                        CardSection(
                            title: "TRANSFER CENTER",
                            items: [
                                "📞 856-886-5111 [CALL STEMI ALERT]"
                            ]
                        )
                    ]
                ),
                ProtocolCard(
                    id: "assessment",
                    type: .assessment,
                    title: "STEMI RECOGNITION & PATHOPHYSIOLOGY",
                    sections: [
                        CardSection(
                            title: "📊 ECG CRITERIA (ACC/AHA 2022)",
                            items: [
                                "Men <40y: V2-V3 ≥2.5mm, others ≥1mm",
                                "Men ≥40y: V2-V3 ≥2mm, others ≥1mm",
                                "Women: V2-V3 ≥1.5mm, others ≥1mm",
                                "(2+ contiguous leads required)"
                            ]
                        ),
                        CardSection(
                            title: "🎯 STEMI EQUIVALENTS",
                            items: [
                                "De Winter's Sign: ST depression V1-V6, tall T waves",
                                "Posterior STEMI: ST depression V1-V3, tall R waves",
                                "Hyperacute T waves: Broad, asymmetric",
                                "Modified Sgarbossa (LBBB): Concordant ≥1mm"
                            ]
                        ),
                        CardSection(
                            title: "CORONARY TERRITORIES",
                            items: [
                                "V1-V4: LAD (anterior)",
                                "V5-V6,I,aVL: LCX (lateral)",
                                "II,III,aVF: RCA (inferior)",
                                "aVR elevation: Left main"
                            ]
                        ),
                        CardSection(
                            title: "HIGH-RISK FEATURES",
                            items: [
                                "Anterior location, HR >100/<60",
                                "SBP <100, Killip II-IV",
                                "Age >75, DM, Prior MI"
                            ]
                        )
                    ]
                ),
                ProtocolCard(
                    id: "actions",
                    type: .actions,
                    title: "PHYSICAL EXAM & MEDICATIONS",
                    sections: [
                        CardSection(
                            title: "EXAM",
                            items: [
                                "BP both arms, HR/rhythm",
                                "Heart sounds, rales/JVD",
                                "KILLIP CLASS: I(no CHF-6%), II(rales-17%),",
                                "III(edema-38%), IV(shock-81%)"
                            ]
                        ),
                        CardSection(
                            title: "💊 ANTIPLATELET (Choose P2Y12)",
                            items: [
                                "ASA 162-325mg chewed, then 81mg daily",
                                "Ticagrelor: 180mg load, 90mg BID (preferred)",
                                "Prasugrel: 60mg load, 10mg daily (avoid >75y, <60kg)",
                                "Clopidogrel: 600mg load, 75mg daily (if others CI)"
                            ]
                        ),
                        CardSection(
                            title: "💊 ANTICOAGULATION",
                            items: [
                                "Primary PCI: UFH 70-100 units/kg bolus (max 10,000)",
                                "Bivalirudin: 0.75mg/kg bolus, 1.75mg/kg/hr infusion"
                            ]
                        ),
                        CardSection(
                            title: "💊 FIBRINOLYTIC (if no PCI <120min)",
                            items: [
                                "TNK 0.25mg/kg IV push (max 25mg), single bolus"
                            ]
                        ),
                        CardSection(
                            title: "⚠️ FIBRINOLYTIC CONTRAINDICATIONS",
                            items: [
                                "Absolute: Prior ICH, stroke <6mo, major trauma <3wks",
                                "Relative: Age >75, uncontrolled HTN >180/110"
                            ]
                        ),
                        CardSection(
                            title: "ADJUNCT",
                            items: [
                                "Metoprolol 25mg PO, Atorvastatin 80mg PO",
                                "CONTACTS: Transfer Center 856-886-5111"
                            ]
                        )
                    ]
                )
            ]
        )
    }
    
    private func createRSIProtocol() -> EmergencyProtocol {
        EmergencyProtocol(
            id: "rsi",
            title: "RSI & Advanced Airway",
            icon: "🫁",
            category: .respiratory,
            algorithm: ProtocolAlgorithm(nodes: [
                AlgorithmNode(
                    id: "start",
                    title: "Decision to Intubate & Assess Airway",
                    nodeType: .assessment,
                    critical: true,
                    content: "Clinical indications for intubation identified. Proceed with airway management?",
                    connections: ["difficult-airway"]
                ),
                AlgorithmNode(
                    id: "difficult-airway",
                    title: "Difficult Airway Predicted?",
                    nodeType: .decision,
                    critical: true,
                    content: "Complete LEMON assessment. Is this predicted to be a difficult airway?",
                    connections: ["standard-rsi", "difficult-airway-algorithm"]
                ),
                AlgorithmNode(
                    id: "standard-rsi",
                    title: "Standard RSI Pathway",
                    nodeType: .intervention,
                    critical: true,
                    content: "Standard RSI pathway selected. Begin 7 P's checklist preparation?",
                    connections: ["preoxygenate"]
                ),
                AlgorithmNode(
                    id: "difficult-airway-algorithm",
                    title: "Difficult Airway Algorithm",
                    nodeType: .intervention,
                    critical: true,
                    content: "Difficult airway predicted. Call for expert help and gather additional equipment?",
                    connections: ["call-for-help"]
                ),
                AlgorithmNode(
                    id: "preoxygenate",
                    title: "Preoxygenate 3-5 min 100% O2",
                    nodeType: .intervention,
                    critical: true,
                    content: "Begin preoxygenation with 100% O2 for 3-5 minutes. SpO2 target >95%?",
                    connections: ["position-patient"]
                ),
                AlgorithmNode(
                    id: "call-for-help",
                    title: "Call for Help & Gather Equipment",
                    nodeType: .intervention,
                    critical: true,
                    content: "Call anesthesia/ENT backup. Gather video laryngoscope, fiberoptic, surgical airway kit",
                    connections: ["awake-intubation"]
                ),
                AlgorithmNode(
                    id: "position-patient",
                    title: "Position Patient Sniffing/Ramped",
                    nodeType: .intervention,
                    critical: true,
                    content: "Position patient in sniffing position or ramp. Optimize laryngeal view?",
                    connections: ["pretreatment"]
                ),
                AlgorithmNode(
                    id: "awake-intubation",
                    title: "Awake Intubation Indicated?",
                    nodeType: .decision,
                    critical: true,
                    content: "Awake fiberoptic intubation indicated for difficult airway management?",
                    connections: ["topical-anesthesia", "video-laryngoscopy"]
                ),
                AlgorithmNode(
                    id: "pretreatment",
                    title: "Pretreatment If Indicated",
                    nodeType: .medication,
                    critical: false,
                    content: "Consider pretreatment medications 3 minutes before induction. Indicated?",
                    connections: ["induction-agent"]
                ),
                AlgorithmNode(
                    id: "topical-anesthesia",
                    title: "Topical Anesthesia & Sedation",
                    nodeType: .medication,
                    critical: true,
                    content: "Apply topical anesthesia and provide light sedation for awake technique",
                    connections: ["fiberoptic"]
                ),
                AlgorithmNode(
                    id: "video-laryngoscopy",
                    title: "Video Laryngoscopy First Attempt",
                    nodeType: .intervention,
                    critical: true,
                    content: "Use video laryngoscopy for difficult airway",
                    connections: ["induction-agent"]
                ),
                AlgorithmNode(
                    id: "induction-agent",
                    title: "Induction Agent Weight-based",
                    nodeType: .medication,
                    critical: true,
                    content: "Select and administer induction agent based on clinical scenario?",
                    connections: ["paralytic-agent"]
                ),
                AlgorithmNode(
                    id: "fiberoptic",
                    title: "Fiberoptic/Awake Technique",
                    nodeType: .intervention,
                    critical: true,
                    content: "Proceed with awake fiberoptic intubation",
                    connections: ["successful-placement"]
                ),
                AlgorithmNode(
                    id: "paralytic-agent",
                    title: "Paralytic Agent Rocuronium/Sux",
                    nodeType: .medication,
                    critical: true,
                    content: "Administer paralytic agent and allow adequate time for onset?",
                    connections: ["allow-time"]
                ),
                AlgorithmNode(
                    id: "allow-time",
                    title: "Allow Time 45-60 seconds",
                    nodeType: .intervention,
                    critical: true,
                    content: "Wait 45-60 seconds for paralytic effect",
                    connections: ["first-attempt"]
                ),
                AlgorithmNode(
                    id: "first-attempt",
                    title: "First Attempt Best Look",
                    nodeType: .intervention,
                    critical: true,
                    content: "Proceed with first intubation attempt using best visualization technique?",
                    connections: ["successful-intubation"]
                ),
                AlgorithmNode(
                    id: "successful-intubation",
                    title: "Successful Intubation?",
                    nodeType: .decision,
                    critical: true,
                    content: "ETT placement successful? Confirm with ETCO2 and clinical assessment?",
                    connections: ["confirm-placement", "spo2-check"]
                ),
                AlgorithmNode(
                    id: "successful-placement",
                    title: "Successful Placement?",
                    nodeType: .decision,
                    critical: true,
                    content: "Awake intubation successful?",
                    connections: ["confirm-placement", "surgical-airway"]
                ),
                AlgorithmNode(
                    id: "confirm-placement",
                    title: "Confirm Placement ETCO2",
                    nodeType: .assessment,
                    critical: true,
                    content: "Confirm ETT placement with continuous ETCO2, bilateral breath sounds",
                    connections: ["post-intubation"]
                ),
                AlgorithmNode(
                    id: "spo2-check",
                    title: "SpO2 >90%?",
                    nodeType: .decision,
                    critical: true,
                    content: "First attempt unsuccessful. SpO2 adequate for second attempt?",
                    connections: ["second-attempt", "bvm-ventilation"]
                ),
                AlgorithmNode(
                    id: "second-attempt",
                    title: "Second Attempt Different Approach",
                    nodeType: .intervention,
                    critical: true,
                    content: "Modify technique for second attempt: different blade, operator, or approach?",
                    connections: ["second-successful"]
                ),
                AlgorithmNode(
                    id: "bvm-ventilation",
                    title: "BVM Ventilation Recover SpO2",
                    nodeType: .intervention,
                    critical: true,
                    content: "Provide BVM ventilation to recover SpO2 >90%",
                    connections: ["lma-rescue"]
                ),
                AlgorithmNode(
                    id: "second-successful",
                    title: "Second Attempt Successful?",
                    nodeType: .decision,
                    critical: true,
                    content: "Second intubation attempt successful?",
                    connections: ["confirm-placement", "lma-rescue"]
                ),
                AlgorithmNode(
                    id: "lma-rescue",
                    title: "Consider LMA Rescue Device",
                    nodeType: .intervention,
                    critical: true,
                    content: "Consider LMA or other rescue device for ventilation and oxygenation?",
                    connections: ["adequate-ventilation"]
                ),
                AlgorithmNode(
                    id: "adequate-ventilation",
                    title: "Adequate Ventilation?",
                    nodeType: .decision,
                    critical: true,
                    content: "Adequate ventilation achieved with rescue device?",
                    connections: ["stabilize-plan", "surgical-airway"]
                ),
                AlgorithmNode(
                    id: "stabilize-plan",
                    title: "Stabilize & Plan Next Steps",
                    nodeType: .intervention,
                    critical: false,
                    content: "Patient stable with rescue device. Plan definitive airway",
                    connections: []
                ),
                AlgorithmNode(
                    id: "surgical-airway",
                    title: "Surgical Airway",
                    nodeType: .intervention,
                    critical: true,
                    content: "Cannot intubate, cannot ventilate scenario. Proceed with surgical airway?",
                    connections: ["post-intubation"]
                ),
                AlgorithmNode(
                    id: "post-intubation",
                    title: "Post-Intubation Management",
                    nodeType: .endpoint,
                    critical: false,
                    content: "Successful intubation confirmed. Begin post-intubation sedation and ventilator setup?",
                    connections: []
                )
            ]),
            cards: [
                ProtocolCard(
                    id: "dynamic",
                    type: .dynamic,
                    title: "RAPID SEQUENCE INTUBATION",
                    sections: [
                        CardSection(
                            title: "🚨 RSI CHECKLIST - 7 P's",
                            items: [
                                "☑ Preparation - Equipment ready",
                                "☑ Preoxygenation - 3-5 min 100% O2",
                                "☐ Pretreatment - Consider medications",
                                "☐ Paralysis with induction",
                                "☐ Positioning - Sniffing position",
                                "☐ Placement with confirmation",
                                "☐ Post-intubation management"
                            ]
                        ),
                        CardSection(
                            title: "MEDICATION CALCULATOR",
                            items: [
                                "Patient Weight: [INPUT] kg",
                                "INDUCTION:",
                                "• Etomidate: [CALC] mg (0.3 mg/kg)",
                                "• Ketamine: [CALC] mg (1.5 mg/kg)",
                                "PARALYTIC:",
                                "• Rocuronium: [CALC] mg (1.2 mg/kg)",
                                "• Sux: [CALC] mg (1.5 mg/kg)"
                            ]
                        ),
                        CardSection(
                            title: "DIFFICULT AIRWAY",
                            items: [
                                "⚠️ DIFFICULT AIRWAY PREDICTORS: [COUNT]",
                                "Backup plan: LMA → Surgical airway ready"
                            ]
                        )
                    ]
                ),
                ProtocolCard(
                    id: "assessment",
                    type: .assessment,
                    title: "RSI INDICATIONS & DIFFICULT AIRWAY",
                    sections: [
                        CardSection(
                            title: "🚨 INDICATIONS FOR INTUBATION",
                            items: [
                                "Failure to protect airway (GCS ≤8)",
                                "Failure to oxygenate (SpO2 <90% despite O2)",
                                "Failure to ventilate (PaCO2 >50, pH <7.30)",
                                "Expected clinical deterioration"
                            ]
                        ),
                        CardSection(
                            title: "LEMON Difficult Airway Assessment",
                            items: [
                                "L - Look externally (facial trauma, obesity, beard)",
                                "E - Evaluate 3-3-2 (mouth opening, hyomental distance)",
                                "M - Mallampati (Class I-IV visibility assessment)",
                                "O - Obstruction/Obesity (BMI >35, neck circumference)",
                                "N - Neck mobility (C-spine, limited ROM)"
                            ]
                        ),
                        CardSection(
                            title: "CONTRAINDICATIONS",
                            items: [
                                "Absolute: Total upper airway obstruction",
                                "Relative: Severe hemodynamic instability, known allergy"
                            ]
                        ),
                        CardSection(
                            title: "PRETREATMENT OPTIONS (3 min before)",
                            items: [
                                "Fentanyl 3 mcg/kg: Blunts sympathetic response",
                                "Lidocaine 1.5 mg/kg: May decrease ICP",
                                "Atropine 0.02 mg/kg: Pediatric <1 year only"
                            ]
                        )
                    ]
                ),
                ProtocolCard(
                    id: "actions",
                    type: .actions,
                    title: "AIRWAY EXAMINATION & MEDICATIONS",
                    sections: [
                        CardSection(
                            title: "PHYSICAL ASSESSMENT",
                            items: [
                                "Inter-incisor distance >3cm, TMJ mobility",
                                "Thyromental distance >6cm, neck circumference",
                                "Mallampati Class I-IV, tongue size, dental assessment"
                            ]
                        ),
                        CardSection(
                            title: "💊 INDUCTION AGENTS",
                            items: [
                                "Etomidate 0.3 mg/kg (hemodynamically stable)",
                                "Ketamine 1-2 mg/kg (shock, asthma, bronchospasm)",
                                "Propofol 1-2 mg/kg (status epilepticus, ↑ICP)"
                            ]
                        ),
                        CardSection(
                            title: "💊 PARALYTIC AGENTS",
                            items: [
                                "Rocuronium 1.2 mg/kg (preferred, reversible)",
                                "Succinylcholine 1.5 mg/kg (faster onset)",
                                "CI: Hyperkalemia, burns >48h, crush injury"
                            ]
                        ),
                        CardSection(
                            title: "POST-INTUBATION SEDATION",
                            items: [
                                "Propofol 5-80 mcg/kg/min infusion",
                                "Fentanyl 25-200 mcg/hr infusion",
                                "Midazolam 1-10 mg/hr infusion"
                            ]
                        ),
                        CardSection(
                            title: "VENTILATOR",
                            items: [
                                "TV 6-8 mL/kg IBW, PEEP 5, Rate 12-20"
                            ]
                        ),
                        CardSection(
                            title: "CONFIRMATION & BACKUP",
                            items: [
                                "CONFIRMATION: ETCO2 (gold standard), bilateral sounds",
                                "BACKUP CONTACTS: Anesthesia ext. 5555, ENT ext. 6666"
                            ]
                        )
                    ]
                )
            ]
        )
    }
    
    private func createShockProtocol() -> EmergencyProtocol {
        EmergencyProtocol(
            id: "shock",
            title: "Shock & ECMO",
            icon: "⚡",
            category: .cardiac,
            algorithm: ProtocolAlgorithm(nodes: [
                AlgorithmNode(
                    id: "start",
                    title: "Recognize Shock MAP <65 or Lactate >2",
                    nodeType: .assessment,
                    critical: true,
                    content: "Signs of shock identified: hypotension, tachycardia, or elevated lactate. Begin protocol?",
                    connections: ["initial-stabilization"]
                ),
                AlgorithmNode(
                    id: "initial-stabilization",
                    title: "Initial Stabilization O2 IV Monitors",
                    nodeType: .intervention,
                    critical: true,
                    content: "Complete initial stabilization: oxygen, IV access, monitors, and vital signs?",
                    connections: ["fluid-resuscitation"]
                ),
                AlgorithmNode(
                    id: "fluid-resuscitation",
                    title: "Fluid Resuscitation 30 mL/kg crystalloid",
                    nodeType: .intervention,
                    critical: true,
                    content: "Administer 30 mL/kg crystalloid bolus rapidly. Monitor response to fluid challenge?",
                    connections: ["fluid-responsive"]
                ),
                AlgorithmNode(
                    id: "fluid-responsive",
                    title: "Fluid Responsive?",
                    nodeType: .decision,
                    critical: true,
                    content: "Assess fluid responsiveness: improved BP, HR, perfusion, or urine output?",
                    connections: ["continue-fluids", "identify-shock-type"]
                ),
                AlgorithmNode(
                    id: "continue-fluids",
                    title: "Continue Fluids & Reassess",
                    nodeType: .intervention,
                    critical: false,
                    content: "Continue fluid resuscitation and reassess",
                    connections: ["map-adequate"]
                ),
                AlgorithmNode(
                    id: "identify-shock-type",
                    title: "Identify Shock Type Clinical plus POCUS",
                    nodeType: .assessment,
                    critical: true,
                    content: "Identify shock type using clinical assessment and point-of-care ultrasound?",
                    connections: ["shock-type"]
                ),
                AlgorithmNode(
                    id: "map-adequate",
                    title: "MAP >65?",
                    nodeType: .decision,
                    critical: true,
                    content: "Is MAP >65 mmHg achieved?",
                    connections: ["monitor-treat", "identify-shock-type"]
                ),
                AlgorithmNode(
                    id: "monitor-treat",
                    title: "Monitor and Treat Underlying Cause",
                    nodeType: .intervention,
                    critical: false,
                    content: "Continue monitoring and treat underlying cause",
                    connections: []
                ),
                AlgorithmNode(
                    id: "shock-type",
                    title: "Shock Type?",
                    nodeType: .decision,
                    critical: true,
                    content: "What type of shock is identified?",
                    connections: ["distributive", "cardiogenic", "hypovolemic", "obstructive"]
                ),
                AlgorithmNode(
                    id: "distributive",
                    title: "Start Norepinephrine Culture and Antibiotics",
                    nodeType: .intervention,
                    critical: true,
                    content: "Distributive shock identified. Start norepinephrine and obtain cultures before antibiotics?",
                    connections: ["adequate-response"]
                ),
                AlgorithmNode(
                    id: "cardiogenic",
                    title: "Dobutamine/Milrinone Consider MCS",
                    nodeType: .intervention,
                    critical: true,
                    content: "Cardiogenic shock confirmed. Determine SCAI stage and consider mechanical support?",
                    connections: ["scai-stage"]
                ),
                AlgorithmNode(
                    id: "hypovolemic",
                    title: "Volume/Blood Find Source",
                    nodeType: .intervention,
                    critical: true,
                    content: "Hypovolemic shock identified. Continue volume resuscitation and identify bleeding source?",
                    connections: ["bleeding-controlled"]
                ),
                AlgorithmNode(
                    id: "obstructive",
                    title: "Treat Cause Immediate",
                    nodeType: .intervention,
                    critical: true,
                    content: "Obstructive shock identified. Perform immediate intervention based on specific cause?",
                    connections: ["decompress-anticoag"]
                ),
                AlgorithmNode(
                    id: "adequate-response",
                    title: "Adequate Response?",
                    nodeType: .decision,
                    critical: true,
                    content: "Adequate response to first-line therapy?",
                    connections: ["continue-resuscitation", "add-vasopressin"]
                ),
                AlgorithmNode(
                    id: "scai-stage",
                    title: "SCAI Stage?",
                    nodeType: .decision,
                    critical: true,
                    content: "Cardiogenic shock SCAI Stage C-E identified. Evaluate for ECMO or mechanical support?",
                    connections: ["ecmo-evaluation", "standard-treatment"]
                ),
                AlgorithmNode(
                    id: "bleeding-controlled",
                    title: "Bleeding Controlled?",
                    nodeType: .decision,
                    critical: true,
                    content: "Is bleeding source controlled?",
                    connections: ["continue-resuscitation", "surgery-ir"]
                ),
                AlgorithmNode(
                    id: "decompress-anticoag",
                    title: "Decompress/Anticoag Based on Cause",
                    nodeType: .intervention,
                    critical: true,
                    content: "Needle decompression for tension pneumo, anticoagulation for PE, pericardiocentesis for tamponade",
                    connections: ["continue-resuscitation"]
                ),
                AlgorithmNode(
                    id: "add-vasopressin",
                    title: "Add Vasopressin Consider Epinephrine",
                    nodeType: .medication,
                    critical: true,
                    content: "Inadequate response to first-line therapy. Add vasopressin or consider epinephrine?",
                    connections: ["refractory-shock"]
                ),
                AlgorithmNode(
                    id: "ecmo-evaluation",
                    title: "ECMO Evaluation Early MCS",
                    nodeType: .intervention,
                    critical: true,
                    content: "Initiate ECMO evaluation and early mechanical circulatory support",
                    connections: ["transfer-center"]
                ),
                AlgorithmNode(
                    id: "standard-treatment",
                    title: "Standard Treatment",
                    nodeType: .intervention,
                    critical: false,
                    content: "Continue standard cardiogenic shock treatment",
                    connections: ["continue-resuscitation"]
                ),
                AlgorithmNode(
                    id: "surgery-ir",
                    title: "Surgery/IR Massive Transfusion",
                    nodeType: .intervention,
                    critical: true,
                    content: "Ongoing bleeding identified in hypovolemic shock. Activate massive transfusion protocol?",
                    connections: ["continue-resuscitation"]
                ),
                AlgorithmNode(
                    id: "continue-resuscitation",
                    title: "Continue Resuscitation",
                    nodeType: .intervention,
                    critical: false,
                    content: "Continue resuscitation efforts",
                    connections: ["refractory-shock"]
                ),
                AlgorithmNode(
                    id: "refractory-shock",
                    title: "Refractory Shock?",
                    nodeType: .decision,
                    critical: true,
                    content: "Refractory shock despite optimal medical therapy. Consider ECMO evaluation?",
                    connections: ["consider-ecmo", "continue-current"]
                ),
                AlgorithmNode(
                    id: "consider-ecmo",
                    title: "Consider ECMO High-dose Pressors",
                    nodeType: .intervention,
                    critical: true,
                    content: "Consider ECMO evaluation for refractory shock on high-dose pressors",
                    connections: ["mobile-ecmo"]
                ),
                AlgorithmNode(
                    id: "continue-current",
                    title: "Continue Current Management",
                    nodeType: .endpoint,
                    critical: false,
                    content: "Continue current management strategy",
                    connections: []
                ),
                AlgorithmNode(
                    id: "transfer-center",
                    title: "Transfer Center 856-886-5111",
                    nodeType: .intervention,
                    critical: true,
                    content: "Contact Transfer Center for coordination",
                    connections: ["mobile-ecmo"]
                ),
                AlgorithmNode(
                    id: "mobile-ecmo",
                    title: "Mobile ECMO Team Activation",
                    nodeType: .intervention,
                    critical: true,
                    content: "Contact Transfer Center for mobile ECMO team evaluation and potential cannulation?",
                    connections: ["ecmo-cannulation"]
                ),
                AlgorithmNode(
                    id: "ecmo-cannulation",
                    title: "ECMO Cannulation ICU Management",
                    nodeType: .endpoint,
                    critical: true,
                    content: "Mobile ECMO team en route. Prepare for cannulation: anticoagulation, positioning?",
                    connections: []
                )
            ]),
            cards: [
                ProtocolCard(
                    id: "dynamic",
                    type: .dynamic,
                    title: "SHOCK PROTOCOL ACTIVATED",
                    sections: [
                        CardSection(
                            title: "SHOCK TYPE",
                            items: [
                                "🚨 SHOCK TYPE: [Identify type]",
                                "Time from recognition: [TIMER]"
                            ]
                        ),
                        CardSection(
                            title: "IMMEDIATE STABILIZATION",
                            items: [
                                "☑ IV access x2 large bore",
                                "☑ Fluid bolus 30 mL/kg started",
                                "☑ Labs sent (lactate, CBC, BMP)",
                                "☑ Blood cultures x2 obtained",
                                "☐ Arterial line placement",
                                "☐ Central line if needed",
                                "Fluid given: [AMOUNT]mL/[TARGET]mL"
                            ]
                        ),
                        CardSection(
                            title: "TRANSFER CENTER",
                            items: [
                                "📞 856-886-5111 [ACTIVATE MOBILE ECMO]"
                            ]
                        ),
                        CardSection(
                            title: "BEDSIDE ASSESSMENT",
                            items: [
                                "☑ RUSH exam (heart, IVC, lungs, abd)",
                                "☑ Passive leg raise test",
                                "☐ Check for obvious bleeding",
                                "☐ ECG for STEMI/arrhythmia",
                                "☐ CXR portable STAT",
                                "⚡ Early recognition + treatment = survival"
                            ]
                        )
                    ]
                ),
                ProtocolCard(
                    id: "assessment",
                    type: .assessment,
                    title: "SHOCK TYPES & PATHOPHYSIOLOGY",
                    sections: [
                        CardSection(
                            title: "🔴 DISTRIBUTIVE (Low SVR, High/Normal CO)",
                            items: [
                                "Septic: Infection + organ dysfunction, lactate >2",
                                "Anaphylactic: IgE-mediated, epinephrine first-line",
                                "Neurogenic: Spinal cord injury T6+, bradycardia"
                            ]
                        ),
                        CardSection(
                            title: "💙 CARDIOGENIC (Low CO, High SVR)",
                            items: [
                                "Acute MI: Large anterior STEMI, mortality 40-50%",
                                "Mechanical: Acute MR, VSD, tamponade",
                                "Arrhythmic: VT/VF, complete heart block"
                            ]
                        ),
                        CardSection(
                            title: "🩸 HYPOVOLEMIC (Low CO, High SVR)",
                            items: [
                                "Hemorrhagic: Trauma, GI bleeding, ruptured AAA",
                                "Non-hemorrhagic: Dehydration, burns, third spacing"
                            ]
                        ),
                        CardSection(
                            title: "🪬 OBSTRUCTIVE (Low CO, Variable SVR)",
                            items: [
                                "Tension pneumothorax: Immediate decompression needed",
                                "Massive PE: RV strain, consider thrombolysis",
                                "Cardiac tamponade: Beck's triad, pericardiocentesis"
                            ]
                        ),
                        CardSection(
                            title: "SCAI CARDIOGENIC SHOCK STAGES",
                            items: [
                                "A: At risk | B: Beginning | C: Classic",
                                "D: Deteriorating | E: Extremis (arrest, profound shock)"
                            ]
                        ),
                        CardSection(
                            title: "CLINICAL PEARLS",
                            items: [
                                "Mixed shock common, early shock may have normal BP",
                                "Lactate clearance guides resuscitation",
                                "ScvO2 <70% = ↓DO2"
                            ]
                        )
                    ]
                ),
                ProtocolCard(
                    id: "actions",
                    type: .actions,
                    title: "PHYSICAL EXAM & MEDICATIONS",
                    sections: [
                        CardSection(
                            title: "RAPID ASSESSMENT (<2 min)",
                            items: [
                                "Vitals: MAP >65 goal, HR/rhythm, RR, temp, SpO2",
                                "Perfusion: GCS, cap refill <3s, skin temp, UOP",
                                "Volume: JVD, lung sounds, edema, IVC by ultrasound",
                                "RUSH ULTRASOUND: Heart, IVC, lungs, abdomen, aorta"
                            ]
                        ),
                        CardSection(
                            title: "💊 VASOPRESSORS/INOTROPES",
                            items: [
                                "Norepinephrine (1st line): 2-30 mcg/min, α>β effects",
                                "Epinephrine (2nd line): 1-20 mcg/min, β>α at low doses",
                                "Vasopressin (adjunct): 0.03-0.04 units/min fixed dose",
                                "Dobutamine (cardiogenic): 2.5-20 mcg/kg/min, pure β",
                                "Milrinone (cardiogenic): 0.375-0.75 mcg/kg/min, PDE-3"
                            ]
                        ),
                        CardSection(
                            title: "💊 FLUID RESUSCITATION",
                            items: [
                                "Crystalloids: LR/NS 30 mL/kg bolus, reassess each liter",
                                "Blood products: PRBCs Hgb >7 (>10 cardiac), PLT <50K"
                            ]
                        ),
                        CardSection(
                            title: "💊 MOBILE ECMO PROTOCOL",
                            items: [
                                "Activation: Refractory shock, cardiac arrest, bridge",
                                "Contraindications: Age >75 (rel), unwitnessed arrest",
                                "Pre-ECMO: Heparin 50-100 units/kg, platelets, PRBCs"
                            ]
                        ),
                        CardSection(
                            title: "CONTACTS",
                            items: [
                                "📞 VIRTUA ECMO: Transfer Center 856-886-5111",
                                "Request: \"Mobile ECMO evaluation\"",
                                "Have ready: Demographics, diagnosis, current support"
                            ]
                        )
                    ]
                )
            ]
        )
    }
    
    // MARK: - RRT Protocols
    
    @MainActor
    private func loadRRTProtocolsAsync() async {
        isLoading = true
        defer { isLoading = false }
        
        // Create protocols directly - they're just data structures
        rrtProtocols = createAllRRTProtocols()
    }
    
    private func createAllRRTProtocols() -> [EmergencyProtocol] {
        return [
            createChestPainRRTProtocol(),
            createShortnesOfBreathRRTProtocol(),
            createAlteredMentalStatusRRTProtocol(),
            createTachycardiaRRTProtocol(),
            createBradycardiaRRTProtocol(),
            createHypotensionRRTProtocol(),
            createFallsRRTProtocol()
        ]
    }
    
    private func loadRRTProtocols() {
        rrtProtocols = [
            createChestPainRRTProtocol(),
            createShortnesOfBreathRRTProtocol(),
            createAlteredMentalStatusRRTProtocol(),
            createTachycardiaRRTProtocol(),
            createBradycardiaRRTProtocol(),
            createHypotensionRRTProtocol(),
            createFallsRRTProtocol()
        ]
    }
    
    private func createChestPainRRTProtocol() -> EmergencyProtocol {
        EmergencyProtocol(
            id: "rrt-chest-pain",
            title: "Chest Pain Evaluation",
            icon: "💔",
            category: .cardiac,
            algorithm: ProtocolAlgorithm(nodes: [
                AlgorithmNode(
                    id: "start",
                    title: "Chest Pain Assessment",
                    nodeType: .assessment,
                    critical: true,
                    content: "Patient complaining of chest pain. Begin rapid assessment?",
                    connections: ["immediate-actions"]
                ),
                AlgorithmNode(
                    id: "immediate-actions",
                    title: "Immediate Actions",
                    nodeType: .intervention,
                    critical: true,
                    content: "Complete immediate interventions: 12-lead ECG, IV access, monitoring?",
                    connections: ["ecg-interpretation"]
                ),
                AlgorithmNode(
                    id: "ecg-interpretation",
                    title: "ECG Interpretation",
                    nodeType: .decision,
                    critical: true,
                    content: "Is there evidence of STEMI or ischemic changes on ECG?",
                    connections: ["stemi-pathway", "nstemi-pathway", "non-cardiac"]
                ),
                AlgorithmNode(
                    id: "stemi-pathway",
                    title: "STEMI Identified",
                    nodeType: .intervention,
                    critical: true,
                    content: "Activate Code STEMI. Call Transfer Center for cath lab activation?",
                    connections: ["transfer-center"]
                ),
                AlgorithmNode(
                    id: "nstemi-pathway",
                    title: "NSTEMI/Unstable Angina",
                    nodeType: .intervention,
                    critical: true,
                    content: "Start ACS protocol: ASA, P2Y12, anticoagulation?",
                    connections: ["cardiac-markers"]
                ),
                AlgorithmNode(
                    id: "non-cardiac",
                    title: "Non-Cardiac Evaluation",
                    nodeType: .assessment,
                    critical: false,
                    content: "Consider other causes: PE, dissection, GI, MSK?",
                    connections: ["alternative-workup"]
                ),
                AlgorithmNode(
                    id: "transfer-center",
                    title: "Transfer Center Contact",
                    nodeType: .intervention,
                    critical: true,
                    content: "Call 856-886-5111 for emergent cardiac catheterization",
                    connections: ["monitor-stabilize"]
                ),
                AlgorithmNode(
                    id: "cardiac-markers",
                    title: "Cardiac Biomarkers",
                    nodeType: .assessment,
                    critical: false,
                    content: "Troponin sent. Serial ECGs and monitoring initiated?",
                    connections: ["risk-stratification"]
                ),
                AlgorithmNode(
                    id: "alternative-workup",
                    title: "Alternative Diagnosis Workup",
                    nodeType: .assessment,
                    critical: false,
                    content: "D-dimer for PE, CTA for dissection, CXR for pneumothorax?",
                    connections: ["symptom-management"]
                ),
                AlgorithmNode(
                    id: "risk-stratification",
                    title: "Risk Stratification",
                    nodeType: .decision,
                    critical: false,
                    content: "HEART score or TIMI risk score calculated?",
                    connections: ["admit-decision"]
                ),
                AlgorithmNode(
                    id: "monitor-stabilize",
                    title: "Monitor and Stabilize",
                    nodeType: .endpoint,
                    critical: false,
                    content: "Continue monitoring, symptom management, prepare for transfer",
                    connections: []
                ),
                AlgorithmNode(
                    id: "symptom-management",
                    title: "Symptom Management",
                    nodeType: .intervention,
                    critical: false,
                    content: "Pain control, anxiolytics if indicated, supportive care",
                    connections: ["disposition"]
                ),
                AlgorithmNode(
                    id: "admit-decision",
                    title: "Admission Decision",
                    nodeType: .endpoint,
                    critical: false,
                    content: "Cardiology consultation, telemetry admission vs observation",
                    connections: []
                ),
                AlgorithmNode(
                    id: "disposition",
                    title: "Disposition Planning",
                    nodeType: .endpoint,
                    critical: false,
                    content: "Determine appropriate level of care based on findings",
                    connections: []
                )
            ]),
            cards: [
                ProtocolCard(
                    id: "dynamic",
                    type: .dynamic,
                    title: "CHEST PAIN RAPID RESPONSE",
                    sections: [
                        CardSection(
                            title: "IMMEDIATE ACTIONS",
                            items: [
                                "☑ 12-lead ECG within 10 minutes",
                                "☑ IV access established",
                                "☑ Continuous cardiac monitoring",
                                "☑ Aspirin 324mg chewed",
                                "☐ Troponin, CBC, BMP sent",
                                "☐ Portable CXR ordered",
                                "☐ Sublingual NTG PRN"
                            ]
                        ),
                        CardSection(
                            title: "HIGH RISK FEATURES",
                            items: [
                                "Known CAD/Prior MI",
                                "Diabetes",
                                "Age >65",
                                "Dynamic ECG changes",
                                "Hemodynamic instability"
                            ]
                        )
                    ]
                ),
                ProtocolCard(
                    id: "assessment",
                    type: .assessment,
                    title: "CAUSES & DIFFERENTIAL DIAGNOSIS",
                    sections: [
                        CardSection(
                            title: "🔴 LIFE-THREATENING CAUSES",
                            items: [
                                "ACS: STEMI/NSTEMI/Unstable angina, pressure/radiation",
                                "PE: Sudden onset, pleuritic, dyspnea, risk factors",
                                "Aortic dissection: Tearing pain, back radiation, BP diff",
                                "Tension pneumothorax: Unilateral, decreased sounds"
                            ]
                        ),
                        CardSection(
                            title: "🟡 URGENT CAUSES",
                            items: [
                                "Pericarditis: Sharp, positional, friction rub",
                                "Myocarditis: Recent viral illness, young patients",
                                "Esophageal rupture: Post-vomiting, subcutaneous emphysema"
                            ]
                        ),
                        CardSection(
                            title: "🟢 OTHER CAUSES",
                            items: [
                                "GI: GERD, esophageal spasm, PUD, biliary colic",
                                "MSK: Costochondritis, rib fracture, muscle strain",
                                "Pulmonary: Pneumonia, pleuritis, bronchitis",
                                "Psychiatric: Panic attack, anxiety, somatization"
                            ]
                        ),
                        CardSection(
                            title: "RED FLAGS",
                            items: [
                                "Tearing pain (dissection)",
                                "Sudden onset (PE)",
                                "Hemodynamic instability",
                                "New neurologic findings"
                            ]
                        )
                    ]
                ),
                ProtocolCard(
                    id: "actions",
                    type: .actions,
                    title: "PHYSICAL EXAM & MEDICATIONS",
                    sections: [
                        CardSection(
                            title: "EXAMINATION PRIORITIES",
                            items: [
                                "Vitals: BP both arms (>20mmHg diff = dissection)",
                                "Cardiac: Rhythm, murmurs, S3/S4, friction rub",
                                "Pulmonary: Equal sounds, rales, friction rub",
                                "Vascular: Pulses, bruits, JVD",
                                "Chest wall: Reproducible tenderness, trauma"
                            ]
                        ),
                        CardSection(
                            title: "💊 ACS MEDICATIONS",
                            items: [
                                "ASA 324mg chewed immediately, then 81mg daily",
                                "P2Y12: Ticagrelor 180mg → 90mg BID (preferred)",
                                "Heparin: 60 units/kg bolus, 12 units/kg/hr (PTT 50-70)",
                                "Statin: Atorvastatin 80mg PO daily",
                                "Beta-blocker: Metoprolol 25mg PO BID (if stable)"
                            ]
                        ),
                        CardSection(
                            title: "💊 SYMPTOM RELIEF",
                            items: [
                                "Nitroglycerin 0.4mg SL q5min x3 (CI: SBP <90, RV MI)",
                                "Morphine 2-4mg IV q5-30min (Class IIb, delays P2Y12)"
                            ]
                        ),
                        CardSection(
                            title: "VIRTUA VOORHEES CONTACTS",
                            items: [
                                "Transfer Center: 856-886-5111",
                                "Cath Lab: Direct activation via Transfer Center",
                                "Cardiology: Available 24/7 via operator"
                            ]
                        )
                    ]
                )
            ]
        )
    }
    
    private func createShortnesOfBreathRRTProtocol() -> EmergencyProtocol {
        EmergencyProtocol(
            id: "rrt-shortness-of-breath",
            title: "Shortness of Breath",
            icon: "🫁",
            category: .respiratory,
            algorithm: ProtocolAlgorithm(nodes: [
                AlgorithmNode(
                    id: "start",
                    title: "Dyspnea Assessment",
                    nodeType: .assessment,
                    critical: true,
                    content: "Patient with acute dyspnea. Assess severity and begin intervention?",
                    connections: ["severity-check"]
                ),
                AlgorithmNode(
                    id: "severity-check",
                    title: "Severity Assessment",
                    nodeType: .decision,
                    critical: true,
                    content: "Is patient in severe respiratory distress (RR >30, SpO2 <90%, accessory muscles)?",
                    connections: ["critical-intervention", "standard-assessment"]
                ),
                AlgorithmNode(
                    id: "critical-intervention",
                    title: "Critical Respiratory Support",
                    nodeType: .intervention,
                    critical: true,
                    content: "High-flow O2, prepare for BiPAP/intubation, call RT?",
                    connections: ["bipap-trial"]
                ),
                AlgorithmNode(
                    id: "standard-assessment",
                    title: "Standard Evaluation",
                    nodeType: .assessment,
                    critical: false,
                    content: "Apply O2 to maintain SpO2 >92%, obtain ABG/VBG, CXR?",
                    connections: ["differential-diagnosis"]
                ),
                AlgorithmNode(
                    id: "bipap-trial",
                    title: "BiPAP Trial",
                    nodeType: .intervention,
                    critical: true,
                    content: "Start BiPAP 10/5, titrate to comfort. Contraindications checked?",
                    connections: ["bipap-response"]
                ),
                AlgorithmNode(
                    id: "differential-diagnosis",
                    title: "Determine Etiology",
                    nodeType: .decision,
                    critical: false,
                    content: "Primary diagnosis: CHF, COPD, pneumonia, PE, pneumothorax?",
                    connections: ["chf-treatment", "copd-treatment", "other-treatment"]
                ),
                AlgorithmNode(
                    id: "bipap-response",
                    title: "Assess BiPAP Response",
                    nodeType: .decision,
                    critical: true,
                    content: "Improving with BiPAP? RR decreasing, SpO2 improving, work of breathing less?",
                    connections: ["continue-bipap", "prepare-intubation"]
                ),
                AlgorithmNode(
                    id: "chf-treatment",
                    title: "CHF Management",
                    nodeType: .intervention,
                    critical: false,
                    content: "Lasix 40-80mg IV, nitro if SBP >100, consider BiPAP",
                    connections: ["reassess-response"]
                ),
                AlgorithmNode(
                    id: "copd-treatment",
                    title: "COPD Exacerbation Treatment",
                    nodeType: .intervention,
                    critical: false,
                    content: "Bronchodilators, steroids, antibiotics if indicated",
                    connections: ["reassess-response"]
                ),
                AlgorithmNode(
                    id: "other-treatment",
                    title: "Alternative Treatment",
                    nodeType: .intervention,
                    critical: false,
                    content: "Treat underlying cause: antibiotics, anticoagulation, needle decompression",
                    connections: ["reassess-response"]
                ),
                AlgorithmNode(
                    id: "continue-bipap",
                    title: "Continue BiPAP",
                    nodeType: .endpoint,
                    critical: false,
                    content: "Monitor closely, ICU admission for BiPAP management",
                    connections: []
                ),
                AlgorithmNode(
                    id: "prepare-intubation",
                    title: "Prepare for Intubation",
                    nodeType: .intervention,
                    critical: true,
                    content: "Call anesthesia/RT, prepare RSI medications, optimize positioning",
                    connections: ["intubation"]
                ),
                AlgorithmNode(
                    id: "reassess-response",
                    title: "Reassess Response",
                    nodeType: .decision,
                    critical: false,
                    content: "Improving with treatment? Respiratory status stable?",
                    connections: ["continue-treatment", "escalate-care"]
                ),
                AlgorithmNode(
                    id: "intubation",
                    title: "Intubation",
                    nodeType: .endpoint,
                    critical: true,
                    content: "Proceed with RSI protocol, post-intubation care",
                    connections: []
                ),
                AlgorithmNode(
                    id: "continue-treatment",
                    title: "Continue Current Management",
                    nodeType: .endpoint,
                    critical: false,
                    content: "Monitor response, adjust therapy as needed",
                    connections: []
                ),
                AlgorithmNode(
                    id: "escalate-care",
                    title: "Escalate Level of Care",
                    nodeType: .endpoint,
                    critical: false,
                    content: "Consider ICU transfer, intensify monitoring",
                    connections: []
                )
            ]),
            cards: [
                ProtocolCard(
                    id: "dynamic",
                    type: .dynamic,
                    title: "RESPIRATORY DISTRESS MANAGEMENT",
                    sections: [
                        CardSection(
                            title: "IMMEDIATE ACTIONS",
                            items: [
                                "☑ High-flow O2 applied",
                                "☑ Continuous SpO2 monitoring",
                                "☑ ABG/VBG obtained",
                                "☑ Portable CXR ordered",
                                "☐ BiPAP ready at bedside",
                                "☐ RT notified",
                                "☐ Intubation equipment ready"
                            ]
                        ),
                        CardSection(
                            title: "BiPAP SETTINGS",
                            items: [
                                "Start: IPAP 10, EPAP 5",
                                "FiO2: Start at 40-50%",
                                "Titrate IPAP by 2 q5min to comfort",
                                "Max IPAP 20, EPAP 10",
                                "Target: RR <25, SpO2 >92%"
                            ]
                        )
                    ]
                ),
                ProtocolCard(
                    id: "assessment",
                    type: .assessment,
                    title: "DIFFERENTIAL DIAGNOSIS",
                    sections: [
                        CardSection(
                            title: "🔴 CRITICAL CAUSES",
                            items: [
                                "Tension pneumothorax: Tracheal deviation, decreased BS",
                                "Massive PE: Sudden onset, chest pain, hypotension",
                                "Anaphylaxis: Rash, swelling, recent exposure",
                                "Upper airway obstruction: Stridor, drooling"
                            ]
                        ),
                        CardSection(
                            title: "🟡 COMMON CAUSES",
                            items: [
                                "CHF exacerbation: Orthopnea, edema, rales",
                                "COPD/Asthma: Wheezing, prolonged expiration",
                                "Pneumonia: Fever, productive cough, infiltrate",
                                "Anxiety: Normal exam, hyperventilation"
                            ]
                        ),
                        CardSection(
                            title: "BiPAP CONTRAINDICATIONS",
                            items: [
                                "Facial trauma/burns",
                                "Vomiting/inability to protect airway",
                                "Hemodynamic instability",
                                "Decreased mental status (relative)",
                                "Pneumothorax (untreated)"
                            ]
                        )
                    ]
                ),
                ProtocolCard(
                    id: "actions",
                    type: .actions,
                    title: "TREATMENT PROTOCOLS",
                    sections: [
                        CardSection(
                            title: "💊 CHF TREATMENT",
                            items: [
                                "Lasix 40-80mg IV (2x home dose)",
                                "Nitroglycerin 0.4mg SL q5min if SBP >100",
                                "Morphine 2-4mg IV for anxiety/dyspnea",
                                "Consider BiPAP early for pulmonary edema"
                            ]
                        ),
                        CardSection(
                            title: "💊 COPD/ASTHMA",
                            items: [
                                "Albuterol/ipratropium nebulizer q20min x3",
                                "Methylprednisolone 125mg IV",
                                "Magnesium 2g IV over 20min if severe",
                                "Antibiotics if suspected infection",
                                "BiPAP for hypercapnic failure"
                            ]
                        ),
                        CardSection(
                            title: "💊 PNEUMONIA",
                            items: [
                                "Ceftriaxone 1g IV + Azithromycin 500mg IV",
                                "Add Vancomycin if MRSA risk",
                                "O2 to maintain SpO2 >92%",
                                "Consider BiPAP if hypoxemic"
                            ]
                        ),
                        CardSection(
                            title: "ESCALATION CRITERIA",
                            items: [
                                "RR >35 despite treatment",
                                "SpO2 <88% on high-flow O2",
                                "pH <7.30 or pCO2 rising",
                                "Altered mental status",
                                "Hemodynamic instability"
                            ]
                        )
                    ]
                )
            ]
        )
    }
    
    private func createAlteredMentalStatusRRTProtocol() -> EmergencyProtocol {
        EmergencyProtocol(
            id: "rrt-altered-mental-status",
            title: "Altered Mental Status",
            icon: "🧠",
            category: .neurological,
            algorithm: ProtocolAlgorithm(nodes: [
                AlgorithmNode(
                    id: "start",
                    title: "AMS Initial Assessment",
                    nodeType: .assessment,
                    critical: true,
                    content: "Patient with altered mental status. Begin systematic evaluation?",
                    connections: ["abcs-check"]
                ),
                AlgorithmNode(
                    id: "abcs-check",
                    title: "ABCs and Stabilization",
                    nodeType: .intervention,
                    critical: true,
                    content: "Assess airway, breathing, circulation. Protect airway if GCS <8?",
                    connections: ["glucose-check"]
                ),
                AlgorithmNode(
                    id: "glucose-check",
                    title: "Check Blood Glucose",
                    nodeType: .decision,
                    critical: true,
                    content: "Fingerstick glucose obtained. Is glucose <70 or >250?",
                    connections: ["hypoglycemia", "hyperglycemia", "other-causes"]
                ),
                AlgorithmNode(
                    id: "hypoglycemia",
                    title: "Hypoglycemia Treatment",
                    nodeType: .intervention,
                    critical: true,
                    content: "Give D50 1 amp IV. Recheck glucose in 5 minutes?",
                    connections: ["reassess-mental-status"]
                ),
                AlgorithmNode(
                    id: "hyperglycemia",
                    title: "Hyperglycemia Management",
                    nodeType: .intervention,
                    critical: false,
                    content: "Start insulin protocol, check for DKA/HHS. Anion gap, ketones?",
                    connections: ["metabolic-workup"]
                ),
                AlgorithmNode(
                    id: "other-causes",
                    title: "Systematic Evaluation",
                    nodeType: .assessment,
                    critical: false,
                    content: "Consider AEIOU-TIPS differential. Neuro exam, labs, imaging?",
                    connections: ["neuro-exam"]
                ),
                AlgorithmNode(
                    id: "reassess-mental-status",
                    title: "Reassess After Treatment",
                    nodeType: .decision,
                    critical: false,
                    content: "Mental status improved after glucose correction?",
                    connections: ["resolved", "persistent-ams"]
                ),
                AlgorithmNode(
                    id: "metabolic-workup",
                    title: "Metabolic Evaluation",
                    nodeType: .assessment,
                    critical: false,
                    content: "CBC, CMP, LFTs, ammonia, TSH, B12/folate?",
                    connections: ["toxicology-screen"]
                ),
                AlgorithmNode(
                    id: "neuro-exam",
                    title: "Neurological Assessment",
                    nodeType: .decision,
                    critical: false,
                    content: "Focal deficits, meningeal signs, or seizure activity?",
                    connections: ["stroke-workup", "infection-workup", "continue-evaluation"]
                ),
                AlgorithmNode(
                    id: "resolved",
                    title: "AMS Resolved",
                    nodeType: .endpoint,
                    critical: false,
                    content: "Monitor for recurrence, address underlying cause",
                    connections: []
                ),
                AlgorithmNode(
                    id: "persistent-ams",
                    title: "Persistent AMS",
                    nodeType: .assessment,
                    critical: false,
                    content: "Continue systematic workup, consider other etiologies",
                    connections: ["metabolic-workup"]
                ),
                AlgorithmNode(
                    id: "toxicology-screen",
                    title: "Toxicology Evaluation",
                    nodeType: .assessment,
                    critical: false,
                    content: "Urine drug screen, alcohol level, medication review?",
                    connections: ["imaging-decision"]
                ),
                AlgorithmNode(
                    id: "stroke-workup",
                    title: "Stroke Evaluation",
                    nodeType: .intervention,
                    critical: true,
                    content: "Activate stroke alert, urgent CT head, neurology consult",
                    connections: ["disposition"]
                ),
                AlgorithmNode(
                    id: "infection-workup",
                    title: "Infection Evaluation",
                    nodeType: .intervention,
                    critical: false,
                    content: "Blood cultures, UA, CXR, consider LP if indicated",
                    connections: ["antibiotic-decision"]
                ),
                AlgorithmNode(
                    id: "continue-evaluation",
                    title: "Continue Systematic Workup",
                    nodeType: .assessment,
                    critical: false,
                    content: "Complete metabolic and toxic evaluation",
                    connections: ["toxicology-screen"]
                ),
                AlgorithmNode(
                    id: "imaging-decision",
                    title: "Neuroimaging Decision",
                    nodeType: .decision,
                    critical: false,
                    content: "Clinical indication for CT head or MRI?",
                    connections: ["order-imaging", "observe"]
                ),
                AlgorithmNode(
                    id: "antibiotic-decision",
                    title: "Empiric Antibiotics",
                    nodeType: .decision,
                    critical: false,
                    content: "Start empiric antibiotics for suspected CNS infection?",
                    connections: ["start-antibiotics", "disposition"]
                ),
                AlgorithmNode(
                    id: "order-imaging",
                    title: "Order Neuroimaging",
                    nodeType: .intervention,
                    critical: false,
                    content: "CT head without contrast, consider MRI if indicated",
                    connections: ["disposition"]
                ),
                AlgorithmNode(
                    id: "observe",
                    title: "Clinical Observation",
                    nodeType: .endpoint,
                    critical: false,
                    content: "Serial neuro exams, supportive care, monitor for changes",
                    connections: []
                ),
                AlgorithmNode(
                    id: "start-antibiotics",
                    title: "Start Antibiotics",
                    nodeType: .intervention,
                    critical: false,
                    content: "Vancomycin + ceftriaxone + acyclovir empirically",
                    connections: ["disposition"]
                ),
                AlgorithmNode(
                    id: "disposition",
                    title: "Disposition Planning",
                    nodeType: .endpoint,
                    critical: false,
                    content: "Determine appropriate level of care, specialist consultation",
                    connections: []
                )
            ]),
            cards: [
                ProtocolCard(
                    id: "dynamic",
                    type: .dynamic,
                    title: "ALTERED MENTAL STATUS EVALUATION",
                    sections: [
                        CardSection(
                            title: "IMMEDIATE ACTIONS",
                            items: [
                                "☑ ABCs assessed and secured",
                                "☑ Fingerstick glucose checked",
                                "☑ IV access established",
                                "☑ Continuous monitoring",
                                "☐ Naloxone 0.4mg IV if indicated",
                                "☐ Thiamine 100mg IV",
                                "☐ D50 if glucose <70"
                            ]
                        ),
                        CardSection(
                            title: "GLASGOW COMA SCALE",
                            items: [
                                "Eye Opening: Spontaneous(4), Voice(3), Pain(2), None(1)",
                                "Verbal: Oriented(5), Confused(4), Words(3), Sounds(2), None(1)",
                                "Motor: Commands(6), Localizes(5), Withdraws(4), Flexion(3), Extension(2), None(1)",
                                "Total GCS: __/15"
                            ]
                        )
                    ]
                ),
                ProtocolCard(
                    id: "assessment",
                    type: .assessment,
                    title: "DIFFERENTIAL DIAGNOSIS - AEIOU TIPS",
                    sections: [
                        CardSection(
                            title: "A-E",
                            items: [
                                "A - Alcohol, Acidosis (metabolic)",
                                "E - Electrolytes (Na, Ca), Encephalopathy",
                                "I - Infection (meningitis, sepsis)",
                                "O - Opiates, Overdose",
                                "U - Uremia"
                            ]
                        ),
                        CardSection(
                            title: "T-S",
                            items: [
                                "T - Trauma, Temperature (hypo/hyper)",
                                "I - Insulin (hypo/hyperglycemia)",
                                "P - Psychiatric, Porphyria",
                                "S - Stroke, Seizure (postictal), Shock"
                            ]
                        ),
                        CardSection(
                            title: "RED FLAGS",
                            items: [
                                "Focal neurological deficits",
                                "Meningeal signs (neck stiffness, photophobia)",
                                "Fever with AMS",
                                "Recent head trauma",
                                "Sudden onset with headache"
                            ]
                        )
                    ]
                ),
                ProtocolCard(
                    id: "actions",
                    type: .actions,
                    title: "WORKUP & TREATMENT",
                    sections: [
                        CardSection(
                            title: "LABORATORY STUDIES",
                            items: [
                                "CBC with differential",
                                "CMP (electrolytes, renal, glucose)",
                                "LFTs, ammonia level",
                                "TSH, B12/folate if indicated",
                                "ABG/VBG for acid-base status",
                                "Urine drug screen, alcohol level",
                                "Blood cultures if febrile"
                            ]
                        ),
                        CardSection(
                            title: "💊 EMPIRIC TREATMENTS",
                            items: [
                                "D50 1 amp IV if glucose <70",
                                "Thiamine 100mg IV before glucose",
                                "Naloxone 0.4-2mg IV if opioid suspected",
                                "Flumazenil 0.2mg IV (caution: seizures)",
                                "Antibiotics if CNS infection suspected",
                                "Lactulose for hepatic encephalopathy"
                            ]
                        ),
                        CardSection(
                            title: "IMAGING INDICATIONS",
                            items: [
                                "CT head: trauma, focal deficits, new AMS",
                                "MRI: suspected stroke, encephalitis",
                                "CXR: aspiration risk, infection",
                                "CT C-spine if trauma suspected"
                            ]
                        ),
                        CardSection(
                            title: "CONSULTATION TRIGGERS",
                            items: [
                                "Neurology: focal deficits, seizures",
                                "Psychiatry: primary psychiatric cause",
                                "Toxicology: suspected overdose",
                                "ICU: GCS <8, unstable vitals"
                            ]
                        )
                    ]
                )
            ]
        )
    }
    
    private func createTachycardiaRRTProtocol() -> EmergencyProtocol {
        EmergencyProtocol(
            id: "rrt-tachycardia",
            title: "Tachycardia",
            icon: "⚡",
            category: .cardiac,
            algorithm: ProtocolAlgorithm(nodes: [
                AlgorithmNode(
                    id: "start",
                    title: "Tachycardia Assessment",
                    nodeType: .assessment,
                    critical: true,
                    content: "HR >100 bpm. Assess hemodynamic stability?",
                    connections: ["stability-check"]
                ),
                AlgorithmNode(
                    id: "stability-check",
                    title: "Hemodynamic Stability",
                    nodeType: .decision,
                    critical: true,
                    content: "Is patient unstable (hypotension, AMS, chest pain, CHF)?",
                    connections: ["unstable-pathway", "stable-pathway"]
                ),
                AlgorithmNode(
                    id: "unstable-pathway",
                    title: "Unstable Tachycardia",
                    nodeType: .intervention,
                    critical: true,
                    content: "Prepare for synchronized cardioversion. Sedate if conscious?",
                    connections: ["cardioversion"]
                ),
                AlgorithmNode(
                    id: "stable-pathway",
                    title: "Stable Tachycardia",
                    nodeType: .assessment,
                    critical: false,
                    content: "Obtain 12-lead ECG. Assess QRS width?",
                    connections: ["qrs-assessment"]
                ),
                AlgorithmNode(
                    id: "cardioversion",
                    title: "Synchronized Cardioversion",
                    nodeType: .intervention,
                    critical: true,
                    content: "Synchronized cardioversion: Narrow 50-100J, Wide 100-200J",
                    connections: ["post-cardioversion"]
                ),
                AlgorithmNode(
                    id: "qrs-assessment",
                    title: "QRS Width Assessment",
                    nodeType: .decision,
                    critical: false,
                    content: "Is QRS >120ms (wide complex)?",
                    connections: ["wide-complex", "narrow-complex"]
                ),
                AlgorithmNode(
                    id: "post-cardioversion",
                    title: "Post-Cardioversion Care",
                    nodeType: .endpoint,
                    critical: false,
                    content: "Reassess rhythm, treat underlying cause, cardiology consult",
                    connections: []
                ),
                AlgorithmNode(
                    id: "wide-complex",
                    title: "Wide Complex Tachycardia",
                    nodeType: .decision,
                    critical: false,
                    content: "Regular or irregular rhythm?",
                    connections: ["regular-wide", "irregular-wide"]
                ),
                AlgorithmNode(
                    id: "narrow-complex",
                    title: "Narrow Complex Tachycardia",
                    nodeType: .decision,
                    critical: false,
                    content: "Regular or irregular rhythm?",
                    connections: ["regular-narrow", "irregular-narrow"]
                ),
                AlgorithmNode(
                    id: "regular-wide",
                    title: "Regular Wide Complex",
                    nodeType: .intervention,
                    critical: false,
                    content: "Likely VT. Consider adenosine if uncertain. Amiodarone 150mg IV?",
                    connections: ["reassess-rhythm"]
                ),
                AlgorithmNode(
                    id: "irregular-wide",
                    title: "Irregular Wide Complex",
                    nodeType: .intervention,
                    critical: false,
                    content: "AFib with aberrancy vs pre-excited AFib. Expert consultation?",
                    connections: ["cardiology-consult"]
                ),
                AlgorithmNode(
                    id: "regular-narrow",
                    title: "Regular Narrow Complex",
                    nodeType: .intervention,
                    critical: false,
                    content: "Likely SVT. Vagal maneuvers, then adenosine 6mg → 12mg IV",
                    connections: ["reassess-rhythm"]
                ),
                AlgorithmNode(
                    id: "irregular-narrow",
                    title: "Irregular Narrow Complex",
                    nodeType: .intervention,
                    critical: false,
                    content: "Likely AFib/Flutter. Rate control with diltiazem or metoprolol",
                    connections: ["rate-control"]
                ),
                AlgorithmNode(
                    id: "reassess-rhythm",
                    title: "Reassess Rhythm",
                    nodeType: .decision,
                    critical: false,
                    content: "Rhythm converted to sinus?",
                    connections: ["sinus-rhythm", "persistent-tachycardia"]
                ),
                AlgorithmNode(
                    id: "cardiology-consult",
                    title: "Cardiology Consultation",
                    nodeType: .endpoint,
                    critical: false,
                    content: "Expert consultation for complex arrhythmia management",
                    connections: []
                ),
                AlgorithmNode(
                    id: "rate-control",
                    title: "Rate Control Achieved",
                    nodeType: .endpoint,
                    critical: false,
                    content: "Monitor rate, consider anticoagulation, rhythm control strategy",
                    connections: []
                ),
                AlgorithmNode(
                    id: "sinus-rhythm",
                    title: "Sinus Rhythm Restored",
                    nodeType: .endpoint,
                    critical: false,
                    content: "Identify and treat precipitating factors, monitor for recurrence",
                    connections: []
                ),
                AlgorithmNode(
                    id: "persistent-tachycardia",
                    title: "Persistent Tachycardia",
                    nodeType: .intervention,
                    critical: false,
                    content: "Consider alternative agents, expert consultation",
                    connections: ["cardiology-consult"]
                )
            ]),
            cards: [
                ProtocolCard(
                    id: "dynamic",
                    type: .dynamic,
                    title: "TACHYCARDIA MANAGEMENT",
                    sections: [
                        CardSection(
                            title: "IMMEDIATE ASSESSMENT",
                            items: [
                                "☑ Continuous cardiac monitoring",
                                "☑ 12-lead ECG obtained",
                                "☑ IV access x2",
                                "☑ Pads placed for cardioversion",
                                "☐ Labs: electrolytes, troponin, TSH",
                                "☐ Sedation ready if cardioversion needed"
                            ]
                        ),
                        CardSection(
                            title: "UNSTABLE FEATURES",
                            items: [
                                "Hypotension (SBP <90)",
                                "Altered mental status",
                                "Ischemic chest pain",
                                "Acute heart failure",
                                "Immediate cardioversion indicated"
                            ]
                        )
                    ]
                ),
                ProtocolCard(
                    id: "assessment",
                    type: .assessment,
                    title: "RHYTHM IDENTIFICATION",
                    sections: [
                        CardSection(
                            title: "NARROW COMPLEX (<120ms)",
                            items: [
                                "Regular: Sinus tach, SVT, atrial flutter (2:1)",
                                "Irregular: AFib, MAT, atrial flutter (variable)"
                            ]
                        ),
                        CardSection(
                            title: "WIDE COMPLEX (>120ms)",
                            items: [
                                "Regular: VT, SVT with aberrancy, antidromic AVRT",
                                "Irregular: AFib with aberrancy, pre-excited AFib, polymorphic VT"
                            ]
                        ),
                        CardSection(
                            title: "CARDIOVERSION ENERGY",
                            items: [
                                "Narrow regular: 50-100J synchronized",
                                "Narrow irregular: 120-200J synchronized",
                                "Wide regular: 100J synchronized",
                                "Wide irregular: Defibrillation dose (200J)"
                            ]
                        )
                    ]
                ),
                ProtocolCard(
                    id: "actions",
                    type: .actions,
                    title: "PHARMACOLOGIC TREATMENT",
                    sections: [
                        CardSection(
                            title: "💊 SVT TREATMENT",
                            items: [
                                "Vagal maneuvers: Modified Valsalva, carotid massage",
                                "Adenosine 6mg rapid IV push → 12mg if needed",
                                "Diltiazem 0.25mg/kg IV over 2min",
                                "Metoprolol 5mg IV q5min x3"
                            ]
                        ),
                        CardSection(
                            title: "💊 AFIB/FLUTTER RATE CONTROL",
                            items: [
                                "Diltiazem 0.25mg/kg IV, then 5-15mg/hr infusion",
                                "Metoprolol 5mg IV q5min x3",
                                "Digoxin 0.25-0.5mg IV (if CHF)",
                                "Amiodarone 150mg IV over 10min if others fail"
                            ]
                        ),
                        CardSection(
                            title: "💊 VT TREATMENT",
                            items: [
                                "Amiodarone 150mg IV over 10min",
                                "Lidocaine 1-1.5mg/kg IV bolus",
                                "Procainamide 17mg/kg over 30min",
                                "Magnesium 2g IV if torsades"
                            ]
                        ),
                        CardSection(
                            title: "SPECIAL CONSIDERATIONS",
                            items: [
                                "WPW: Avoid AV nodal blockers",
                                "Pregnancy: Adenosine safe, avoid amiodarone",
                                "CHF: Use diltiazem cautiously",
                                "COPD: Use cardioselective beta-blockers"
                            ]
                        )
                    ]
                )
            ]
        )
    }
    
    private func createBradycardiaRRTProtocol() -> EmergencyProtocol {
        EmergencyProtocol(
            id: "rrt-bradycardia",
            title: "Bradycardia",
            icon: "🐢",
            category: .cardiac,
            algorithm: ProtocolAlgorithm(nodes: [
                AlgorithmNode(
                    id: "start",
                    title: "Bradycardia Assessment",
                    nodeType: .assessment,
                    critical: true,
                    content: "HR <60 bpm. Assess for symptoms and hemodynamic compromise?",
                    connections: ["symptomatic-check"]
                ),
                AlgorithmNode(
                    id: "symptomatic-check",
                    title: "Symptomatic Assessment",
                    nodeType: .decision,
                    critical: true,
                    content: "Is patient symptomatic (chest pain, dyspnea, AMS, hypotension)?",
                    connections: ["symptomatic", "asymptomatic"]
                ),
                AlgorithmNode(
                    id: "symptomatic",
                    title: "Symptomatic Bradycardia",
                    nodeType: .intervention,
                    critical: true,
                    content: "Begin immediate treatment. Atropine 0.5mg IV ready?",
                    connections: ["atropine-administration"]
                ),
                AlgorithmNode(
                    id: "asymptomatic",
                    title: "Asymptomatic Bradycardia",
                    nodeType: .assessment,
                    critical: false,
                    content: "Monitor and identify underlying cause. ECG interpretation?",
                    connections: ["identify-rhythm"]
                ),
                AlgorithmNode(
                    id: "atropine-administration",
                    title: "Atropine Administration",
                    nodeType: .intervention,
                    critical: true,
                    content: "Give atropine 0.5mg IV, may repeat q3-5min (max 3mg)",
                    connections: ["atropine-response"]
                ),
                AlgorithmNode(
                    id: "identify-rhythm",
                    title: "Rhythm Identification",
                    nodeType: .decision,
                    critical: false,
                    content: "Type of bradycardia: Sinus, AV block, or junctional?",
                    connections: ["sinus-brady", "av-block", "other-brady"]
                ),
                AlgorithmNode(
                    id: "atropine-response",
                    title: "Assess Atropine Response",
                    nodeType: .decision,
                    critical: true,
                    content: "Adequate response to atropine? HR >60 and symptoms resolved?",
                    connections: ["response-adequate", "response-inadequate"]
                ),
                AlgorithmNode(
                    id: "sinus-brady",
                    title: "Sinus Bradycardia",
                    nodeType: .assessment,
                    critical: false,
                    content: "Identify cause: medications, hypothyroid, increased vagal tone",
                    connections: ["treat-cause"]
                ),
                AlgorithmNode(
                    id: "av-block",
                    title: "AV Block Assessment",
                    nodeType: .decision,
                    critical: false,
                    content: "Degree of AV block: First, Second (Type I or II), or Third?",
                    connections: ["low-grade-block", "high-grade-block"]
                ),
                AlgorithmNode(
                    id: "other-brady",
                    title: "Other Bradycardia",
                    nodeType: .assessment,
                    critical: false,
                    content: "Junctional, idioventricular, or other rhythm",
                    connections: ["monitor-closely"]
                ),
                AlgorithmNode(
                    id: "response-adequate",
                    title: "Adequate Response",
                    nodeType: .endpoint,
                    critical: false,
                    content: "Monitor for recurrence, identify and treat underlying cause",
                    connections: []
                ),
                AlgorithmNode(
                    id: "response-inadequate",
                    title: "Inadequate Response",
                    nodeType: .intervention,
                    critical: true,
                    content: "Consider transcutaneous pacing or alternative medications",
                    connections: ["pacing-decision"]
                ),
                AlgorithmNode(
                    id: "treat-cause",
                    title: "Treat Underlying Cause",
                    nodeType: .endpoint,
                    critical: false,
                    content: "Address reversible causes, adjust medications, monitor",
                    connections: []
                ),
                AlgorithmNode(
                    id: "low-grade-block",
                    title: "First Degree or Mobitz I",
                    nodeType: .endpoint,
                    critical: false,
                    content: "Usually benign, monitor closely, treat if symptomatic",
                    connections: []
                ),
                AlgorithmNode(
                    id: "high-grade-block",
                    title: "Mobitz II or Third Degree",
                    nodeType: .intervention,
                    critical: true,
                    content: "High risk for progression. Prepare for pacing",
                    connections: ["prepare-pacing"]
                ),
                AlgorithmNode(
                    id: "monitor-closely",
                    title: "Close Monitoring",
                    nodeType: .endpoint,
                    critical: false,
                    content: "Continuous monitoring, cardiology consultation",
                    connections: []
                ),
                AlgorithmNode(
                    id: "pacing-decision",
                    title: "Pacing Decision",
                    nodeType: .decision,
                    critical: true,
                    content: "Transcutaneous pacing immediately available?",
                    connections: ["tcp-pacing", "alternative-therapy"]
                ),
                AlgorithmNode(
                    id: "prepare-pacing",
                    title: "Prepare for Pacing",
                    nodeType: .intervention,
                    critical: true,
                    content: "Apply pacing pads, prepare for TCP or transvenous",
                    connections: ["cardiology-consult"]
                ),
                AlgorithmNode(
                    id: "tcp-pacing",
                    title: "Transcutaneous Pacing",
                    nodeType: .intervention,
                    critical: true,
                    content: "Start at 70 bpm, increase mA until capture achieved",
                    connections: ["pacing-capture"]
                ),
                AlgorithmNode(
                    id: "alternative-therapy",
                    title: "Alternative Therapy",
                    nodeType: .intervention,
                    critical: true,
                    content: "Epinephrine 2-10 mcg/min or dopamine 2-20 mcg/kg/min",
                    connections: ["reassess-response"]
                ),
                AlgorithmNode(
                    id: "cardiology-consult",
                    title: "Cardiology Consultation",
                    nodeType: .endpoint,
                    critical: false,
                    content: "Urgent consultation for permanent pacemaker consideration",
                    connections: []
                ),
                AlgorithmNode(
                    id: "pacing-capture",
                    title: "Assess Pacing Capture",
                    nodeType: .endpoint,
                    critical: false,
                    content: "Confirm electrical and mechanical capture, sedate for comfort",
                    connections: []
                ),
                AlgorithmNode(
                    id: "reassess-response",
                    title: "Reassess Response",
                    nodeType: .endpoint,
                    critical: false,
                    content: "Monitor response to therapy, prepare for transvenous pacing if needed",
                    connections: []
                )
            ]),
            cards: [
                ProtocolCard(
                    id: "dynamic",
                    type: .dynamic,
                    title: "BRADYCARDIA MANAGEMENT",
                    sections: [
                        CardSection(
                            title: "IMMEDIATE ASSESSMENT",
                            items: [
                                "☑ Continuous cardiac monitoring",
                                "☑ 12-lead ECG obtained",
                                "☑ IV access established",
                                "☑ Pacing pads applied",
                                "☐ Atropine 0.5mg ready",
                                "☐ Transcutaneous pacer at bedside"
                            ]
                        ),
                        CardSection(
                            title: "SYMPTOMATIC FEATURES",
                            items: [
                                "Chest pain or dyspnea",
                                "Altered mental status",
                                "Hypotension (SBP <90)",
                                "Signs of shock",
                                "Heart failure"
                            ]
                        )
                    ]
                ),
                ProtocolCard(
                    id: "assessment",
                    type: .assessment,
                    title: "BRADYCARDIA TYPES & CAUSES",
                    sections: [
                        CardSection(
                            title: "RHYTHM TYPES",
                            items: [
                                "Sinus bradycardia: P before every QRS",
                                "1° AV block: PR >200ms, all conducted",
                                "2° Type I (Wenckebach): Progressive PR prolongation",
                                "2° Type II (Mobitz): Fixed PR, dropped beats",
                                "3° (Complete): AV dissociation",
                                "Junctional: Narrow QRS, no/retrograde P"
                            ]
                        ),
                        CardSection(
                            title: "COMMON CAUSES",
                            items: [
                                "Medications: Beta-blockers, CCB, digoxin",
                                "Cardiac: MI (inferior), sick sinus, conduction disease",
                                "Metabolic: Hypothyroid, hypothermia, hyperkalemia",
                                "Increased vagal tone: Vomiting, bearing down",
                                "Neurologic: Increased ICP, cushing reflex"
                            ]
                        ),
                        CardSection(
                            title: "HIGH-RISK FEATURES",
                            items: [
                                "Mobitz II AV block",
                                "Third-degree AV block",
                                "Symptomatic bradycardia",
                                "Ventricular escape rhythm",
                                "Recent MI with new block"
                            ]
                        )
                    ]
                ),
                ProtocolCard(
                    id: "actions",
                    type: .actions,
                    title: "TREATMENT PROTOCOLS",
                    sections: [
                        CardSection(
                            title: "💊 PHARMACOLOGIC",
                            items: [
                                "Atropine 0.5mg IV q3-5min (max 3mg)",
                                "CI: Mobitz II, 3° block, transplant",
                                "Epinephrine infusion 2-10 mcg/min",
                                "Dopamine infusion 2-20 mcg/kg/min",
                                "Glucagon 3mg IV if beta-blocker OD",
                                "Calcium chloride 1g IV if CCB OD"
                            ]
                        ),
                        CardSection(
                            title: "TRANSCUTANEOUS PACING",
                            items: [
                                "Apply pads (anterior-posterior preferred)",
                                "Set rate: 70 bpm (or 10 above intrinsic)",
                                "Start output: 20 mA, increase by 10 mA",
                                "Capture: Wide QRS after each spike",
                                "Confirm mechanical capture (pulse)",
                                "Sedate if conscious (versed/fentanyl)"
                            ]
                        ),
                        CardSection(
                            title: "TRANSVENOUS PACING INDICATIONS",
                            items: [
                                "Failed medical therapy",
                                "High-grade AV block with symptoms",
                                "Hemodynamically unstable",
                                "Bridge to permanent pacemaker",
                                "Overdrive pacing for VT"
                            ]
                        ),
                        CardSection(
                            title: "REVERSIBLE CAUSES TO TREAT",
                            items: [
                                "Hold AV nodal blockers",
                                "Treat hyperkalemia if present",
                                "Warm if hypothermic",
                                "Correct hypothyroidism",
                                "Treat increased ICP if present"
                            ]
                        )
                    ]
                )
            ]
        )
    }
    
    private func createHypotensionRRTProtocol() -> EmergencyProtocol {
        EmergencyProtocol(
            id: "rrt-hypotension",
            title: "Hypotension & Hemorrhage",
            icon: "🩸",
            category: .cardiac,
            algorithm: ProtocolAlgorithm(nodes: [
                AlgorithmNode(
                    id: "start",
                    title: "Hypotension Identified",
                    nodeType: .assessment,
                    critical: true,
                    content: "SBP <90 or MAP <65. Begin rapid assessment?",
                    connections: ["initial-resuscitation"]
                ),
                AlgorithmNode(
                    id: "initial-resuscitation",
                    title: "Initial Resuscitation",
                    nodeType: .intervention,
                    critical: true,
                    content: "Start IV fluids, apply O2, continuous monitoring?",
                    connections: ["volume-status"]
                ),
                AlgorithmNode(
                    id: "volume-status",
                    title: "Assess Volume Status",
                    nodeType: .decision,
                    critical: true,
                    content: "Signs of volume loss: bleeding, dehydration, third-spacing?",
                    connections: ["hypovolemic", "other-shock"]
                ),
                AlgorithmNode(
                    id: "hypovolemic",
                    title: "Hypovolemic Shock",
                    nodeType: .decision,
                    critical: true,
                    content: "Evidence of active bleeding?",
                    connections: ["hemorrhagic", "non-hemorrhagic"]
                ),
                AlgorithmNode(
                    id: "other-shock",
                    title: "Other Shock Types",
                    nodeType: .assessment,
                    critical: false,
                    content: "Consider: septic, cardiogenic, obstructive causes",
                    connections: ["shock-protocol"]
                ),
                AlgorithmNode(
                    id: "hemorrhagic",
                    title: "Hemorrhagic Shock",
                    nodeType: .intervention,
                    critical: true,
                    content: "Activate massive transfusion protocol. Source control?",
                    connections: ["mtp-activation"]
                ),
                AlgorithmNode(
                    id: "non-hemorrhagic",
                    title: "Non-hemorrhagic Hypovolemia",
                    nodeType: .intervention,
                    critical: false,
                    content: "Aggressive crystalloid resuscitation 30 mL/kg",
                    connections: ["reassess-volume"]
                ),
                AlgorithmNode(
                    id: "shock-protocol",
                    title: "Shock Protocol",
                    nodeType: .intervention,
                    critical: false,
                    content: "See specific shock protocol. Consider pressors early",
                    connections: ["vasopressor-initiation"]
                ),
                AlgorithmNode(
                    id: "mtp-activation",
                    title: "Massive Transfusion Protocol",
                    nodeType: .intervention,
                    critical: true,
                    content: "1:1:1 ratio PRBCs:FFP:Platelets. TXA if <3 hours?",
                    connections: ["source-control"]
                ),
                AlgorithmNode(
                    id: "reassess-volume",
                    title: "Reassess After Fluids",
                    nodeType: .decision,
                    critical: false,
                    content: "Hemodynamics improved after fluid bolus?",
                    connections: ["fluid-responsive", "fluid-refractory"]
                ),
                AlgorithmNode(
                    id: "vasopressor-initiation",
                    title: "Start Vasopressors",
                    nodeType: .intervention,
                    critical: false,
                    content: "Norepinephrine first-line, add vasopressin if needed",
                    connections: ["monitor-response"]
                ),
                AlgorithmNode(
                    id: "source-control",
                    title: "Source Control",
                    nodeType: .decision,
                    critical: true,
                    content: "Surgical or IR intervention needed for bleeding control?",
                    connections: ["emergency-intervention", "medical-management"]
                ),
                AlgorithmNode(
                    id: "fluid-responsive",
                    title: "Fluid Responsive",
                    nodeType: .endpoint,
                    critical: false,
                    content: "Continue resuscitation, monitor for recurrence",
                    connections: []
                ),
                AlgorithmNode(
                    id: "fluid-refractory",
                    title: "Fluid Refractory",
                    nodeType: .intervention,
                    critical: false,
                    content: "Start vasopressors, investigate other causes",
                    connections: ["vasopressor-initiation"]
                ),
                AlgorithmNode(
                    id: "monitor-response",
                    title: "Monitor Response",
                    nodeType: .endpoint,
                    critical: false,
                    content: "Target MAP >65, monitor end-organ perfusion",
                    connections: []
                ),
                AlgorithmNode(
                    id: "emergency-intervention",
                    title: "Emergency Intervention",
                    nodeType: .intervention,
                    critical: true,
                    content: "OR/IR for immediate source control",
                    connections: ["perioperative-care"]
                ),
                AlgorithmNode(
                    id: "medical-management",
                    title: "Medical Management",
                    nodeType: .intervention,
                    critical: false,
                    content: "Continue resuscitation, correct coagulopathy",
                    connections: ["stabilization"]
                ),
                AlgorithmNode(
                    id: "perioperative-care",
                    title: "Perioperative Management",
                    nodeType: .endpoint,
                    critical: false,
                    content: "Continue resuscitation during procedure",
                    connections: []
                ),
                AlgorithmNode(
                    id: "stabilization",
                    title: "Stabilization",
                    nodeType: .endpoint,
                    critical: false,
                    content: "ICU admission, continue monitoring and support",
                    connections: []
                )
            ]),
            cards: [
                ProtocolCard(
                    id: "dynamic",
                    type: .dynamic,
                    title: "HYPOTENSION MANAGEMENT",
                    sections: [
                        CardSection(
                            title: "IMMEDIATE ACTIONS",
                            items: [
                                "☑ Large bore IV x2 (16-18G)",
                                "☑ Fluid bolus started",
                                "☑ Type & crossmatch sent",
                                "☑ Labs: CBC, BMP, lactate, coags",
                                "☐ Blood products available",
                                "☐ Massive transfusion protocol activated",
                                "☐ Pressors at bedside"
                            ]
                        ),
                        CardSection(
                            title: "HEMORRHAGE ASSESSMENT",
                            items: [
                                "Obvious external bleeding",
                                "Abdominal distension/tenderness",
                                "Unstable pelvis",
                                "Long bone fractures",
                                "Recent surgery or procedure"
                            ]
                        )
                    ]
                ),
                ProtocolCard(
                    id: "assessment",
                    type: .assessment,
                    title: "SHOCK CLASSIFICATION",
                    sections: [
                        CardSection(
                            title: "HEMORRHAGIC SHOCK CLASSES",
                            items: [
                                "Class I: <15% blood loss, HR <100, BP normal",
                                "Class II: 15-30% loss, HR 100-120, pulse pressure ↓",
                                "Class III: 30-40% loss, HR >120, SBP <90",
                                "Class IV: >40% loss, HR >140, obtunded"
                            ]
                        ),
                        CardSection(
                            title: "SOURCES OF BLEEDING",
                            items: [
                                "Chest: Hemothorax, aortic injury",
                                "Abdomen: Solid organ, mesentery, retroperitoneum",
                                "Pelvis: Pelvic fracture, vascular injury",
                                "Extremities: Long bone fractures, vascular",
                                "External: Scalp, open wounds"
                            ]
                        ),
                        CardSection(
                            title: "NON-HEMORRHAGIC CAUSES",
                            items: [
                                "Septic shock: Fever, source of infection",
                                "Cardiogenic: Chest pain, CHF, EKG changes",
                                "Neurogenic: Spinal injury, warm extremities",
                                "Anaphylactic: Exposure, rash, swelling",
                                "Adrenal crisis: Steroid dependence"
                            ]
                        )
                    ]
                ),
                ProtocolCard(
                    id: "actions",
                    type: .actions,
                    title: "RESUSCITATION PROTOCOLS",
                    sections: [
                        CardSection(
                            title: "💊 MASSIVE TRANSFUSION",
                            items: [
                                "Activate MTP: Call blood bank stat",
                                "Initial: 6 PRBC, 6 FFP, 1 platelet",
                                "Ratio: 1:1:1 (PRBC:FFP:Platelets)",
                                "TXA 1g IV over 10min if <3hr from injury",
                                "Calcium chloride 1g IV after 4 units",
                                "Warm all blood products"
                            ]
                        ),
                        CardSection(
                            title: "💊 VASOPRESSORS",
                            items: [
                                "Norepinephrine: 0.05-2 mcg/kg/min",
                                "Vasopressin: 0.03-0.04 units/min",
                                "Epinephrine: 0.05-2 mcg/kg/min",
                                "Phenylephrine: 0.5-5 mcg/kg/min",
                                "Push-dose epi: 10mcg q2-5min PRN"
                            ]
                        ),
                        CardSection(
                            title: "PERMISSIVE HYPOTENSION",
                            items: [
                                "Target SBP 80-90 until bleeding controlled",
                                "Exception: TBI (SBP >90)",
                                "Avoid over-resuscitation",
                                "Minimize crystalloid use",
                                "Early blood product use"
                            ]
                        ),
                        CardSection(
                            title: "VIRTUA RESOURCES",
                            items: [
                                "Trauma Surgery: Via operator",
                                "IR: For embolization",
                                "Blood Bank: x5555",
                                "OR: Direct line x6666",
                                "Transfer Center: 856-886-5111"
                            ]
                        )
                    ]
                )
            ]
        )
    }
    
    private func createFallsRRTProtocol() -> EmergencyProtocol {
        EmergencyProtocol(
            id: "rrt-falls",
            title: "Falls Assessment",
            icon: "🤕",
            category: .trauma,
            algorithm: ProtocolAlgorithm(nodes: [
                AlgorithmNode(
                    id: "start",
                    title: "Fall Reported",
                    nodeType: .assessment,
                    critical: true,
                    content: "Patient found down or witnessed fall. Begin assessment?",
                    connections: ["initial-assessment"]
                ),
                AlgorithmNode(
                    id: "initial-assessment",
                    title: "Initial Safety Assessment",
                    nodeType: .intervention,
                    critical: true,
                    content: "C-spine precautions if indicated. Primary survey?",
                    connections: ["trauma-assessment"]
                ),
                AlgorithmNode(
                    id: "trauma-assessment",
                    title: "Trauma Assessment",
                    nodeType: .decision,
                    critical: true,
                    content: "Signs of significant trauma or head injury?",
                    connections: ["major-trauma", "minor-trauma"]
                ),
                AlgorithmNode(
                    id: "major-trauma",
                    title: "Major Trauma Identified",
                    nodeType: .intervention,
                    critical: true,
                    content: "Activate trauma team. Maintain spine precautions?",
                    connections: ["head-injury-check"]
                ),
                AlgorithmNode(
                    id: "minor-trauma",
                    title: "Minor Trauma",
                    nodeType: .assessment,
                    critical: false,
                    content: "Focused assessment of injuries. Check mechanism?",
                    connections: ["mechanism-assessment"]
                ),
                AlgorithmNode(
                    id: "head-injury-check",
                    title: "Head Injury Assessment",
                    nodeType: .decision,
                    critical: true,
                    content: "LOC, amnesia, or signs of head trauma?",
                    connections: ["head-ct-indicated", "continue-assessment"]
                ),
                AlgorithmNode(
                    id: "mechanism-assessment",
                    title: "Mechanism and Risk Factors",
                    nodeType: .assessment,
                    critical: false,
                    content: "Why did patient fall? Mechanical vs medical cause?",
                    connections: ["medical-cause", "mechanical-cause"]
                ),
                AlgorithmNode(
                    id: "head-ct-indicated",
                    title: "Head CT Indicated",
                    nodeType: .intervention,
                    critical: true,
                    content: "Order urgent head CT. Check anticoagulation status?",
                    connections: ["anticoag-check"]
                ),
                AlgorithmNode(
                    id: "continue-assessment",
                    title: "Continue Trauma Assessment",
                    nodeType: .assessment,
                    critical: false,
                    content: "Complete secondary survey, X-rays as indicated",
                    connections: ["injury-management"]
                ),
                AlgorithmNode(
                    id: "medical-cause",
                    title: "Medical Cause Suspected",
                    nodeType: .assessment,
                    critical: false,
                    content: "Syncope, seizure, stroke, hypoglycemia workup",
                    connections: ["medical-workup"]
                ),
                AlgorithmNode(
                    id: "mechanical-cause",
                    title: "Mechanical Fall",
                    nodeType: .assessment,
                    critical: false,
                    content: "Environmental factors, weakness, gait issues",
                    connections: ["fall-prevention"]
                ),
                AlgorithmNode(
                    id: "anticoag-check",
                    title: "Anticoagulation Status",
                    nodeType: .decision,
                    critical: true,
                    content: "On anticoagulation or antiplatelet therapy?",
                    connections: ["anticoag-protocol", "standard-management"]
                ),
                AlgorithmNode(
                    id: "injury-management",
                    title: "Injury Management",
                    nodeType: .intervention,
                    critical: false,
                    content: "Treat identified injuries, pain control",
                    connections: ["disposition-planning"]
                ),
                AlgorithmNode(
                    id: "medical-workup",
                    title: "Medical Evaluation",
                    nodeType: .intervention,
                    critical: false,
                    content: "ECG, labs, orthostatics, medication review",
                    connections: ["treat-medical-cause"]
                ),
                AlgorithmNode(
                    id: "fall-prevention",
                    title: "Fall Prevention",
                    nodeType: .endpoint,
                    critical: false,
                    content: "PT/OT evaluation, home safety assessment",
                    connections: []
                ),
                AlgorithmNode(
                    id: "anticoag-protocol",
                    title: "Anticoagulated Patient Protocol",
                    nodeType: .intervention,
                    critical: true,
                    content: "Stat INR if on warfarin. Lower threshold for imaging",
                    connections: ["reverse-anticoag"]
                ),
                AlgorithmNode(
                    id: "standard-management",
                    title: "Standard Management",
                    nodeType: .intervention,
                    critical: false,
                    content: "Monitor neuro status, serial exams",
                    connections: ["disposition-planning"]
                ),
                AlgorithmNode(
                    id: "treat-medical-cause",
                    title: "Treat Medical Cause",
                    nodeType: .intervention,
                    critical: false,
                    content: "Address underlying medical condition",
                    connections: ["disposition-planning"]
                ),
                AlgorithmNode(
                    id: "reverse-anticoag",
                    title: "Consider Reversal",
                    nodeType: .decision,
                    critical: true,
                    content: "Intracranial hemorrhage identified?",
                    connections: ["urgent-reversal", "monitor-closely"]
                ),
                AlgorithmNode(
                    id: "disposition-planning",
                    title: "Disposition Planning",
                    nodeType: .endpoint,
                    critical: false,
                    content: "Admission vs discharge based on injuries and risk",
                    connections: []
                ),
                AlgorithmNode(
                    id: "urgent-reversal",
                    title: "Urgent Reversal",
                    nodeType: .intervention,
                    critical: true,
                    content: "Reverse anticoagulation per protocol, neurosurgery consult",
                    connections: ["icu-admission"]
                ),
                AlgorithmNode(
                    id: "monitor-closely",
                    title: "Close Monitoring",
                    nodeType: .endpoint,
                    critical: false,
                    content: "Serial neuro exams, repeat imaging if deterioration",
                    connections: []
                ),
                AlgorithmNode(
                    id: "icu-admission",
                    title: "ICU Admission",
                    nodeType: .endpoint,
                    critical: false,
                    content: "Intensive monitoring, neurosurgical management",
                    connections: []
                )
            ]),
            cards: [
                ProtocolCard(
                    id: "dynamic",
                    type: .dynamic,
                    title: "FALL ASSESSMENT",
                    sections: [
                        CardSection(
                            title: "IMMEDIATE ACTIONS",
                            items: [
                                "☑ Assess for C-spine injury",
                                "☑ Vital signs and neuro exam",
                                "☑ Check for obvious injuries",
                                "☑ Medication list reviewed",
                                "☐ Head CT if indicated",
                                "☐ X-rays as needed",
                                "☐ Labs if medical cause suspected"
                            ]
                        ),
                        CardSection(
                            title: "HIGH-RISK FEATURES",
                            items: [
                                "Age >65 years",
                                "Anticoagulation/antiplatelet therapy",
                                "Head strike or facial injury",
                                "Loss of consciousness",
                                "Multiple falls recently",
                                "Significant medical comorbidities"
                            ]
                        )
                    ]
                ),
                ProtocolCard(
                    id: "assessment",
                    type: .assessment,
                    title: "FALL EVALUATION",
                    sections: [
                        CardSection(
                            title: "HEAD CT INDICATIONS",
                            items: [
                                "GCS <15 at 2 hours post-injury",
                                "Suspected skull fracture",
                                "Any sign of basal skull fracture",
                                "Post-traumatic seizure",
                                "Focal neurological deficit",
                                "2+ episodes of vomiting",
                                "Age >65 years",
                                "Anticoagulation/coagulopathy"
                            ]
                        ),
                        CardSection(
                            title: "CANADIAN C-SPINE RULE",
                            items: [
                                "High Risk (imaging needed):",
                                "- Age ≥65 years",
                                "- Dangerous mechanism",
                                "- Paresthesias in extremities",
                                "Low Risk (assess ROM if no high risk):",
                                "- Simple rear-end MVC",
                                "- Ambulatory at any time",
                                "- Delayed onset neck pain",
                                "- No midline tenderness"
                            ]
                        ),
                        CardSection(
                            title: "MEDICAL CAUSES OF FALLS",
                            items: [
                                "Cardiovascular: Syncope, arrhythmia, orthostatic",
                                "Neurologic: Stroke, seizure, Parkinson's",
                                "Metabolic: Hypoglycemia, electrolyte abnormality",
                                "Medication: Sedatives, antihypertensives, psychotropics",
                                "Other: Infection (UTI), anemia, alcohol"
                            ]
                        )
                    ]
                ),
                ProtocolCard(
                    id: "actions",
                    type: .actions,
                    title: "MANAGEMENT PROTOCOLS",
                    sections: [
                        CardSection(
                            title: "ANTICOAGULATION REVERSAL",
                            items: [
                                "Warfarin: Vitamin K 10mg IV + PCC",
                                "Dabigatran: Idarucizumab 5g IV",
                                "Rivaroxaban/Apixaban: PCC 50 units/kg",
                                "Heparin: Protamine 1mg per 100 units",
                                "Antiplatelet: Platelets ± DDAVP"
                            ]
                        ),
                        CardSection(
                            title: "💊 PAIN MANAGEMENT",
                            items: [
                                "Acetaminophen 1g PO/IV q6h",
                                "Tramadol 50-100mg PO q6h",
                                "Lidocaine patches for local pain",
                                "Avoid NSAIDs if bleeding risk",
                                "Low-dose opioids if severe pain"
                            ]
                        ),
                        CardSection(
                            title: "FALL PREVENTION",
                            items: [
                                "PT/OT evaluation",
                                "Medication reconciliation",
                                "Orthostatic vital signs",
                                "Vision/hearing assessment",
                                "Home safety evaluation",
                                "Assistive device training"
                            ]
                        ),
                        CardSection(
                            title: "DISPOSITION CRITERIA",
                            items: [
                                "Admit if: ICH, significant injury, unsafe",
                                "Observe if: Minor head injury, stable",
                                "Discharge if: No injury, safe environment",
                                "Follow-up: PCP within 1 week",
                                "Return if: Headache, vomiting, confusion"
                            ]
                        )
                    ]
                )
            ]
        )
    }
}