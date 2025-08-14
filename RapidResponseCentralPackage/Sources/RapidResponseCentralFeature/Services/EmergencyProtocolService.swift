import Foundation
import SwiftUI
import QuartzCore
import os.log
import os.signpost

// MARK: - Emergency Protocol Service

@MainActor
public class EmergencyProtocolService: ObservableObject {
    @Published public private(set) var protocols: [EmergencyProtocol] = []
    @Published public private(set) var isLoading = false
    
    // Performance monitoring
    private let performanceLogger = Logger(subsystem: "com.rapidresponsecentral.performance", category: "EmergencyProtocolService")
    private let signposter = OSSignposter(subsystem: "com.rapidresponsecentral.performance", category: "ProtocolCreation")
    
    public init() {
        Task {
            await loadEmergencyProtocols()
        }
    }
    
    @MainActor
    private func loadEmergencyProtocols() async {
        isLoading = true
        defer { isLoading = false }
        
        // Enhanced concurrent protocol loading with TaskGroup
        protocols = await measureAsyncPerformance("Concurrent Protocol Loading") {
            await createEmergencyProtocolsConcurrently()
        }
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
    
    private func createEmergencyProtocolsConcurrently() async -> [EmergencyProtocol] {
        performanceLogger.info("🚀 Starting truly concurrent protocol creation with TaskGroup")
        let signpostID = signposter.makeSignpostID()
        let signpostState = signposter.beginInterval("ConcurrentProtocolCreation", id: signpostID)
        
        return await withTaskGroup(of: (Int, EmergencyProtocol).self, returning: [EmergencyProtocol].self) { group in
            let protocolCreators: [(String, @Sendable () async -> EmergencyProtocol)] = [
                ("Code Blue - ACLS", { await self.createCodeBlueProtocolAsync() }),
                ("Code Stroke - Virtua Voorhees myEOP Protocol", { await self.createCodeStrokeProtocolAsync() }),
                ("Code STEMI", { await self.createCodeSTEMIProtocolAsync() }),
                ("RSI & Advanced Airway Protocol", { await self.createRSIProtocolAsync() }),
                ("Shock & ECMO Protocols", { await self.createShockProtocolAsync() })
            ]
            
            // Add all protocol creation tasks to the TaskGroup
            for (index, (name, creator)) in protocolCreators.enumerated() {
                group.addTask {
                    let emergencyProtocol = await self.measureAsyncPerformance(name) {
                        await creator()
                    }
                    return (index, emergencyProtocol)
                }
            }
            
            // Collect results in order
            var results: [(Int, EmergencyProtocol)] = []
            for await result in group {
                results.append(result)
            }
            
            signposter.endInterval("ConcurrentProtocolCreation", signpostState)
            
            // Sort by index to maintain order
            let sortedProtocols = results.sorted { $0.0 < $1.0 }.map { $0.1 }
            performanceLogger.info("✅ Concurrent protocol creation completed - \(sortedProtocols.count) protocols loaded")
            
            return sortedProtocols
        }
    }
    
    private func measurePerformance<T>(_ operation: String, _ block: () -> T) -> T {
        let signpostID = signposter.makeSignpostID()
        let signpostState = signposter.beginInterval("ProtocolCreation", id: signpostID, "\(operation)")
        
        let startTime = CACurrentMediaTime()
        let result = block()
        let duration = CACurrentMediaTime() - startTime
        
        signposter.endInterval("ProtocolCreation", signpostState, "\(operation) completed in \(String(format: "%.2f", duration * 1000))ms")
        
        if duration > 0.1 { // 100ms threshold
            performanceLogger.warning("⚠️ Performance Warning: \(operation) took \(String(format: "%.2f", duration * 1000))ms")
        } else {
            performanceLogger.info("✅ \(operation) completed in \(String(format: "%.2f", duration * 1000))ms")
        }
        
        return result
    }
    
    private func measureAsyncPerformance<T: Sendable>(_ operation: String, _ block: @Sendable () async -> T) async -> T {
        let signpostID = signposter.makeSignpostID()
        let signpostState = signposter.beginInterval("AsyncProtocolCreation", id: signpostID, "\(operation)")
        
        let startTime = CACurrentMediaTime()
        let result = await block()
        let duration = CACurrentMediaTime() - startTime
        
        signposter.endInterval("AsyncProtocolCreation", signpostState, "\(operation) completed in \(String(format: "%.2f", duration * 1000))ms")
        
        // For emergency protocols, even stricter performance requirements
        let threshold = operation.contains("Code Blue") ? 0.05 : 0.1 // Code Blue gets 50ms threshold
        
        if duration > threshold {
            performanceLogger.warning("🚨 Critical Performance Warning: \(operation) took \(String(format: "%.2f", duration * 1000))ms (threshold: \(Int(threshold * 1000))ms)")
        } else {
            performanceLogger.info("⚡ \(operation) completed in \(String(format: "%.2f", duration * 1000))ms")
        }
        
        return result
    }
    
    // MARK: - Async Protocol Creation Methods
    
    private func createCodeBlueProtocolAsync() async -> EmergencyProtocol {
        return createCodeBlueProtocol()
    }
    
    private func createCodeStrokeProtocolAsync() async -> EmergencyProtocol {
        return createCodeStrokeProtocol()
    }
    
    private func createCodeSTEMIProtocolAsync() async -> EmergencyProtocol {
        return createCodeSTEMIProtocol()
    }
    
    private func createRSIProtocolAsync() async -> EmergencyProtocol {
        return createRSIProtocol()
    }
    
    private func createShockProtocolAsync() async -> EmergencyProtocol {
        return createShockProtocol()
    }
    
    // MARK: - Code Blue Protocol (AHA ACLS 2025 Guidelines)
    // Enhanced with dynamic card-node mapping interface
    
    private func createCodeBlueProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            // Code Blue Confirmed - Start directly with CPR and rhythm analysis
            AlgorithmNode(
                id: "code_blue_activated",
                title: "Code Blue",
                nodeType: .action,
                critical: true,
                content: "Cardiac arrest confirmed. Start High-Quality CPR. Attach Monitor/Defibrillator.",
                connections: ["analyze_rhythm"]
            ),
            
            // Rhythm Analysis - Node D → E
            AlgorithmNode(
                id: "analyze_rhythm",
                title: "Rhythm Check",
                nodeType: .assessment,
                critical: true,
                content: "Rhythm identification ≤10 seconds. Minimize CPR interruptions.",
                connections: ["shockable_rhythm"]
            ),
            AlgorithmNode(
                id: "shockable_rhythm",
                title: "Shockable?",
                nodeType: .decision,
                critical: true,
                content: "VF/Pulseless VT (shockable) vs PEA/Asystole (non-shockable)",
                connections: ["vf_pvt", "pea_asystole"]
            ),
            
            // VF/pVT Path - Node F → H
            AlgorithmNode(
                id: "vf_pvt",
                title: "VF/pVT",
                nodeType: .intervention,
                critical: true,
                content: "SHOCK: Biphasic 200J. Resume CPR Immediately.",
                connections: ["high_quality_cpr"]
            ),
            
            // PEA/Asystole Path - Node G → H
            AlgorithmNode(
                id: "pea_asystole",
                title: "PEA/Asystole",
                nodeType: .intervention,
                critical: true,
                content: "CPR + EPINEPHRINE 1mg IV/IO. Continue CPR.",
                connections: ["high_quality_cpr"]
            ),
            
            // High-Quality CPR Cycle - Node H → I
            AlgorithmNode(
                id: "high_quality_cpr",
                title: "CPR 2min",
                nodeType: .intervention,
                critical: true,
                content: "2 Minutes CPR. Rotate Compressor. Rate: 100-120/min, Depth: 2-2.4 inches.",
                connections: ["rhythm_pulse_check"]
            ),
            
            // Rhythm & Pulse Check - Node I → J
            AlgorithmNode(
                id: "rhythm_pulse_check",
                title: "Rhythm/Pulse",
                nodeType: .decision,
                critical: true,
                content: "≤10 seconds. Check monitor rhythm and pulse if organized rhythm.",
                connections: ["status_check"]
            ),
            AlgorithmNode(
                id: "status_check",
                title: "Status?",
                nodeType: .decision,
                critical: true,
                content: "ROSC achieved? VF/pVT persists? PEA/Asystole?",
                connections: ["rosc", "vf_pvt_persists", "pea_asystole_continues"]
            ),
            
            // ROSC Achieved - Node K (Final)
            AlgorithmNode(
                id: "rosc",
                title: "ROSC Achieved",
                nodeType: .endpoint,
                critical: true,
                content: "Airway, Breathing, Circulation. TTM 32-36°C if comatose. ICU admission.",
                connections: []
            ),
            
            // VF/pVT Persists - Node L → N
            AlgorithmNode(
                id: "vf_pvt_persists",
                title: "VF/pVT Persist?",
                nodeType: .decision,
                critical: true,
                content: "After Multiple Shocks?",
                connections: ["antiarrhythmics", "vf_pvt"]
            ),
            AlgorithmNode(
                id: "antiarrhythmics",
                title: "Antiarrhythmics",
                nodeType: .medication,
                critical: true,
                content: "Amiodarone 300mg IV/IO or Lidocaine 1-1.5mg/kg",
                connections: ["shock_cpr_cycle"]
            ),
            AlgorithmNode(
                id: "shock_cpr_cycle",
                title: "Shock + CPR 2min",
                nodeType: .intervention,
                critical: true,
                content: "Shock + CPR 2min. Consider Reversible Causes.",
                connections: ["rhythm_pulse_check"]
            ),
            
            // PEA/Asystole Continues - Node M → P
            AlgorithmNode(
                id: "pea_asystole_continues",
                title: "PEA Persists",
                nodeType: .intervention,
                critical: true,
                content: "Continue CPR. Epinephrine q3-5min. Address H's & T's.",
                connections: ["assess_reversible_causes"]
            ),
            AlgorithmNode(
                id: "assess_reversible_causes",
                title: "H's & T's",
                nodeType: .assessment,
                critical: true,
                content: "Hypovolemia, Hypoxia, H+, Hypo/Hyperkalemia, Hypothermia, Toxins, Tamponade, Tension Pneumo, Thrombosis",
                connections: ["rhythm_pulse_check"]
            )
        ])
        
        // Dynamic cards mapped to algorithm nodes
        let cards = [
            // Card 0 - Initial Assessment (Node A → B)
            ProtocolCard(
                id: "card_0_unresponsive",
                type: .assessment,
                title: "🚨 UNRESPONSIVE PATIENT",
                sections: [
                    CardSection(title: "📊 Initial assessment", items: [
                        "• Check responsiveness",
                        "• Look for normal breathing (not gasping)",
                        "• Check pulse (≤10 seconds)"
                    ]),
                    CardSection(title: "🚀 If cardiac arrest confirmed", items: [
                        "• Activate Code Blue team",
                        "• Start high-quality CPR immediately"
                    ]),
                    CardSection(title: "❓ Cardiac arrest confirmed?", items: [
                        "🔘 YES → Start CPR & attach monitor",
                        "🔘 NO → Assess for other emergencies"
                    ])
                ]
            ),
            
            // Card 1A - Start CPR & Monitor (Node C → D)
            ProtocolCard(
                id: "card_1a_cpr",
                type: .actions,
                title: "💓 HIGH-QUALITY CPR INITIATED",
                sections: [
                    CardSection(title: "⚙️ CPR parameters", items: [
                        "• Rate: 100-120/min",
                        "• Depth: 2-2.4 inches (5-6 cm)",
                        "• Complete recoil between compressions",
                        "• Minimize interruptions (<10 seconds)"
                    ]),
                    CardSection(title: "🔌 Equipment setup", items: [
                        "• Attach monitor/defibrillator",
                        "• Give oxygen, establish IV/IO access"
                    ])
                ]
            ),
            
            // Card 2A - Rhythm Analysis (Node D → E)
            ProtocolCard(
                id: "card_2a_rhythm",
                type: .assessment,
                title: "📈 ANALYZE CARDIAC RHYTHM",
                sections: [
                    CardSection(title: "🔍 Rhythm identification", items: [
                        "• VF/Pulseless VT (shockable)",
                        "• Asystole (non-shockable)",
                        "• PEA (non-shockable)"
                    ]),
                    CardSection(title: "⏱️ Key timing", items: [
                        "• Minimize interruptions <10 seconds"
                    ]),
                    CardSection(title: "❓ Shockable rhythm?", items: [
                        "🔘 YES → Deliver shock",
                        "🔘 NO → Continue CPR + epinephrine"
                    ])
                ]
            ),
            
            // Card 3A - Shock Delivery (Node F → H)
            ProtocolCard(
                id: "card_3a_shock",
                type: .actions,
                title: "⚡ DEFIBRILLATION - VF/PULSELESS VT",
                sections: [
                    CardSection(title: "⚙️ Shock parameters", items: [
                        "• Energy: 200J biphasic (120-200J range)",
                        "• Single shock strategy",
                        "• Clear patient before shock"
                    ]),
                    CardSection(title: "🚀 Immediately after shock", items: [
                        "• Resume CPR for 2 minutes",
                        "• Do not check pulse/rhythm"
                    ])
                ]
            ),
            
            // Card 3B - CPR + Epinephrine (Node G → H)
            ProtocolCard(
                id: "card_3b_epinephrine",
                type: .actions,
                title: "💊 CPR + EPINEPHRINE (NON-SHOCKABLE)",
                sections: [
                    CardSection(title: "💉 Epinephrine dosing", items: [
                        "• 1mg IV/IO immediately",
                        "• Repeat every 3-5 minutes",
                        "• Continue throughout resuscitation"
                    ]),
                    CardSection(title: "💓 Continue high-quality CPR", items: [
                        "• 2-minute cycles",
                        "• Rotate compressor q2min"
                    ])
                ]
            ),
            
            // Card 6A - ROSC Achieved (Node K - Final)
            ProtocolCard(
                id: "card_6a_rosc",
                type: .dynamic,
                title: "✅ RETURN OF SPONTANEOUS CIRCULATION",
                sections: [
                    CardSection(title: "🎯 Immediate priorities", items: [
                        "• Confirm ROSC (pulse, BP, waveform)",
                        "• Optimize airway and breathing",
                        "• Support circulation/BP",
                        "• 12-lead ECG"
                    ]),
                    CardSection(title: "📊 Target parameters", items: [
                        "• SBP >90 mmHg or MAP >65 mmHg",
                        "• SpO₂ 92-98%"
                    ]),
                    CardSection(title: "🏥 Post-cardiac arrest care", items: [
                        "• TTM 32-36°C if comatose",
                        "• ICU admission for monitoring",
                        "• Neurologic assessment",
                        "• Consider coronary angiography"
                    ])
                ]
            ),
            
            // Additional cards for advanced management
            ProtocolCard(
                id: "card_reversible_causes",
                type: .assessment,
                title: "🔍 REVERSIBLE CAUSES (H's & T's)",
                sections: [
                    CardSection(title: "4 H's", items: [
                        "• Hypovolemia: IV fluid bolus, blood products",
                        "• Hypoxia: Optimize ventilation, increase FiO₂",
                        "• Hydrogen ions (Acidosis): Consider sodium bicarbonate",
                        "• Hypo/Hyperkalemia: Treat electrolyte abnormalities"
                    ]),
                    CardSection(title: "4 T's", items: [
                        "• Toxins: Antidotes, decontamination",
                        "• Tamponade: Emergency pericardiocentesis",
                        "• Tension Pneumothorax: Needle decompression",
                        "• Thrombosis: Consider thrombolytics, embolectomy"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "code_blue_acls",
            title: "Code Blue - ACLS",
            icon: "bolt.heart.fill", // VF/VT cardiac arrest rhythm
            category: .cardiac,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    // MARK: - Additional Protocols (Updated to match documentation)
    
    // MARK: - Code Stroke Protocol (TNK-Optimized 2025)
    private func createCodeStrokeProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            // Node A - Initial Assessment
            AlgorithmNode(
                id: "code_stroke_activated",
                title: "Code Stroke Activated\nNIHSS Assessment + Teleneurology",
                nodeType: .assessment,
                critical: true,
                content: "Door-to-needle timer <60 minutes. Complete NIHSS assessment. Contact Sevaro Teleneurology.",
                connections: ["ct_head_stat"]
            ),
            
            // Node B - CT Imaging
            AlgorithmNode(
                id: "ct_head_stat",
                title: "CT Head STAT\n<25 minutes",
                nodeType: .action,
                critical: true,
                content: "Target: <25 minutes from arrival. Evaluate for hemorrhage, hypodensity, mass effect.",
                connections: ["hemorrhage_on_ct"]
            ),
            
            // Node C - Hemorrhage Decision
            AlgorithmNode(
                id: "hemorrhage_on_ct",
                title: "Hemorrhage\non CT?",
                nodeType: .decision,
                critical: true,
                content: "Evaluate for intracranial hemorrhage, large hypodensity >1/3 MCA, mass effect.",
                connections: ["hemorrhagic_stroke_protocol", "lvo_screening"]
            ),
            
            // Node D - Hemorrhagic Path
            AlgorithmNode(
                id: "hemorrhagic_stroke_protocol",
                title: "Hemorrhagic Stroke Protocol\nNeurosurgery + BP Control + ICU",
                nodeType: .intervention,
                critical: true,
                content: "STAT neurosurgery consult. BP <160/90 (ICH). Reversal agents if on anticoagulants. ICP monitoring. AVOID all thrombolytics.",
                connections: ["icu_management"]
            ),
            
            // Node E - LVO Screening
            AlgorithmNode(
                id: "lvo_screening",
                title: "LVO Screening\nNIHSS ≥6?",
                nodeType: .decision,
                critical: true,
                content: "High-risk: NIHSS ≥6, gaze deviation, dense hemiparesis, aphasia, neglect/extinction.",
                connections: ["cta_brain_neck", "tnk_eligibility_assessment"]
            ),
            
            // Node F - CTA Path
            AlgorithmNode(
                id: "cta_brain_neck",
                title: "CTA Brain/Neck\nThrombectomy Planning",
                nodeType: .action,
                critical: true,
                content: "Evaluate for large vessel occlusion: ICA, M1/M2 MCA, basilar. ASPECTS ≥6. Collateral assessment.",
                connections: ["stroke_unit_admission"]
            ),
            
            // Node G - TNK Eligibility
            AlgorithmNode(
                id: "tnk_eligibility_assessment",
                title: "TNK Eligibility\nAssessment",
                nodeType: .decision,
                critical: true,
                content: "Onset <4.5 hours, Age ≥18, NIHSS ≥2. Exclusions: Prior ICH, BP >185/110, INR >1.7, platelets <100K.",
                connections: ["tnk_bolus", "medical_management"]
            ),
            
            // Node H - TNK Administration
            AlgorithmNode(
                id: "tnk_bolus",
                title: "TNK 0.25mg/kg bolus\n5 seconds",
                nodeType: .medication,
                critical: true,
                content: "0.25 mg/kg IV bolus (max 25mg). Single 5-second injection. No infusion required. Hold antithrombotics 24h.",
                connections: ["post_tnk_monitoring"]
            ),
            
            // Node I - Medical Management
            AlgorithmNode(
                id: "medical_management",
                title: "Medical Management\nASA + Standard Care",
                nodeType: .intervention,
                critical: false,
                content: "ASA 325mg after 24h if TNK given. BP <220/120. Glucose 140-180. Temperature <38°C. DVT prophylaxis.",
                connections: ["stroke_unit_admission"]
            ),
            
            // Node K - Post-TNK Monitoring
            AlgorithmNode(
                id: "post_tnk_monitoring",
                title: "Post-TNK Monitoring\nNeuro Checks q15min",
                nodeType: .assessment,
                critical: true,
                content: "Q15min × 2h, Q30min × 6h, Q1h × 16h. Alert if NIHSS ↑4, severe headache, BP >180/105.",
                connections: ["evt_candidate"]
            ),
            
            // Node L - EVT Decision
            AlgorithmNode(
                id: "evt_candidate",
                title: "EVT Candidate\nCTA Results?",
                nodeType: .decision,
                critical: true,
                content: "Large vessel occlusion confirmed? Within 6-24 hour window? ASPECTS ≥6?",
                connections: ["transfer_for_evt", "stroke_unit_admission"]
            ),
            
            // Node M - Transfer for EVT
            AlgorithmNode(
                id: "transfer_for_evt",
                title: "Transfer for EVT\n6-24 hour window",
                nodeType: .action,
                critical: true,
                content: "Expedited transfer to EVT center. Continue medical management during transport.",
                connections: ["stroke_unit_admission"]
            ),
            
            // Node J - Stroke Unit (Central Hub)
            AlgorithmNode(
                id: "stroke_unit_admission",
                title: "Stroke Unit Admission\nPost-Intervention Care",
                nodeType: .intervention,
                critical: false,
                content: "Swallow screening, early mobilization, cardiac monitoring ×24h, secondary prevention.",
                connections: ["disposition_planning"]
            ),
            
            // Node N - Disposition
            AlgorithmNode(
                id: "disposition_planning",
                title: "Disposition Planning\nRehab Assessment",
                nodeType: .endpoint,
                critical: false,
                content: "Rehab options: home with therapy, acute rehab facility, skilled nursing. Follow-up: Neuro 1-2 weeks.",
                connections: []
            ),
            
            // Node O - ICU Management (Hemorrhagic)
            AlgorithmNode(
                id: "icu_management",
                title: "ICU Management\nICP Monitoring",
                nodeType: .endpoint,
                critical: true,
                content: "Intensive monitoring, ICP management, neurosurgical intervention as needed.",
                connections: []
            )
        ])
        
        // Dynamic cards mapped to nodes
        let cards = [
            // Card 0 - Stroke Alert & NIHSS
            ProtocolCard(
                id: "card_0_stroke_alert",
                type: .assessment,
                title: "🚨 CODE STROKE ACTIVATED",
                sections: [
                    CardSection(title: "⏱️ Time targets", items: [
                        "• Door-to-needle: <60 minutes",
                        "• TNK advantage: 5-second bolus"
                    ]),
                    CardSection(title: "📊 NIHSS Assessment", items: [
                        "• Complete 11-item scale promptly",
                        "• Score 0-42 (higher = more severe)",
                        "• Mild (1-4), Moderate (5-15), Severe (16+)"
                    ]),
                    CardSection(title: "📞 Sevaro Teleneurology", items: [
                        "• Call: 856-247-3098",
                        "• Response time: <45 seconds"
                    ])
                ]
            ),
            
            // Card 1A - CT Imaging
            ProtocolCard(
                id: "card_1a_ct",
                type: .assessment,
                title: "🧠 CT HEAD - STAT IMAGING",
                sections: [
                    CardSection(title: "🎯 Target", items: [
                        "• <25 minutes from arrival"
                    ]),
                    CardSection(title: "🔍 Evaluate for", items: [
                        "• Intracranial hemorrhage (absolute CI)",
                        "• Large hypodensity (>1/3 MCA territory)",
                        "• Mass effect or midline shift",
                        "• Early signs of infarction"
                    ]),
                    CardSection(title: "❓ Hemorrhage on CT?", items: [
                        "🔘 YES → Hemorrhagic stroke protocol",
                        "🔘 NO → LVO screening"
                    ])
                ]
            ),
            
            // Card 2B - TNK Eligibility
            ProtocolCard(
                id: "card_2b_tnk",
                type: .actions,
                title: "💉 TENECTEPLASE ELIGIBILITY",
                sections: [
                    CardSection(title: "✅ Inclusion criteria", items: [
                        "• Onset <4.5 hours (last known well)",
                        "• Age ≥18 years",
                        "• Measurable neurologic deficit",
                        "• NIHSS potentially disabling (≥2)"
                    ]),
                    CardSection(title: "❌ Key exclusions", items: [
                        "• Prior ICH, recent stroke <3mo",
                        "• BP >185/110 refractory to treatment",
                        "• Active bleeding, recent major surgery",
                        "• INR >1.7, platelets <100,000",
                        "• Recent anticoagulation"
                    ])
                ]
            ),
            
            // Card 3B - TNK Administration
            ProtocolCard(
                id: "card_3b_tnk_admin",
                type: .actions,
                title: "💉 TENECTEPLASE ADMINISTRATION",
                sections: [
                    CardSection(title: "💊 TNK Protocol (FDA 2025)", items: [
                        "• Dose: 0.25 mg/kg IV bolus (max 25mg)",
                        "• Single 5-second bolus injection",
                        "• Dedicated IV line, flush after",
                        "• No infusion required (vs 60min alteplase)"
                    ]),
                    CardSection(title: "🚫 Hold for 24 hours", items: [
                        "• Anticoagulants, antiplatelets",
                        "• Avoid arterial punctures",
                        "• No NG tubes, foley catheters"
                    ]),
                    CardSection(title: "⚡ Advantages over alteplase", items: [
                        "• Faster administration",
                        "• No infusion delays",
                        "• Better for transport/transfers"
                    ])
                ]
            ),
            
            // Card 5 - Stroke Unit Care
            ProtocolCard(
                id: "card_5_stroke_unit",
                type: .dynamic,
                title: "🏥 STROKE UNIT CARE",
                sections: [
                    CardSection(title: "📋 Acute management", items: [
                        "• Dedicated stroke unit admission",
                        "• Swallow screening before PO",
                        "• Early mobilization (24-48h)",
                        "• Cardiac monitoring × 24h minimum"
                    ]),
                    CardSection(title: "💊 Secondary prevention (after 24h)", items: [
                        "• Antiplatelet: ASA 81mg daily",
                        "• High-intensity statin: Atorvastatin 80mg",
                        "• BP optimization per guidelines",
                        "• Diabetes management if present"
                    ]),
                    CardSection(title: "🔄 Rehabilitation", items: [
                        "• PT evaluation and mobility",
                        "• OT for activities of daily living",
                        "• Speech therapy for dysphagia/aphasia"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "code_stroke_tnk",
            title: "Code Stroke - TNK Protocol",
            icon: "brain.head.profile", // Brain with stroke zone
            category: .neurological,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createCodeSTEMIProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "stemi_assessment",
                title: "STEMI Assessment",
                nodeType: .assessment,
                critical: true,
                content: "12-lead ECG, troponins, door-to-balloon timer",
                connections: ["transfer_center"]
            ),
            AlgorithmNode(
                id: "transfer_center",
                title: "Transfer Center Activation",
                nodeType: .action,
                critical: true,
                content: "Call Transfer Center: 856-886-5111. Interventional cardiology consultation.",
                connections: ["cardiogenic_shock"]
            ),
            AlgorithmNode(
                id: "cardiogenic_shock",
                title: "Cardiogenic Shock Management",
                nodeType: .intervention,
                critical: true,
                content: "ECMO protocols, hemodynamic support, vasopressor protocols",
                connections: ["endpoint"]
            ),
            AlgorithmNode(
                id: "endpoint",
                title: "Protocol End",
                nodeType: .endpoint,
                critical: false,
                content: "Protocol completed. Document all interventions and times.",
                connections: []
            )
        ])
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Code STEMI",
                sections: [
                    CardSection(title: "Critical Actions", items: [
                        "💔 12-lead ECG interpretation",
                        "📞 Transfer Center activation",
                        "💉 Interventional cardiology",
                        "⚡ Cardiogenic shock management",
                        "🫀 ECMO protocols"
                    ])
                ]
            )
        ]
        return EmergencyProtocol(
            id: "code_stemi",
            title: "Code STEMI",
            icon: "waveform.path.ecg.rectangle.fill", // STEMI ECG pattern
            category: .cardiac,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createRSIProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            // Node A
            AlgorithmNode(
                id: "decision_to_intubate",
                title: "Decision to Intubate & Assess Airway",
                nodeType: .assessment,
                critical: true,
                content: "Clinical indications for intubation identified. Complete LEMON assessment",
                connections: ["difficult_airway_predicted"]
            ),
            // Node B
            AlgorithmNode(
                id: "difficult_airway_predicted",
                title: "Difficult Airway Predicted?",
                nodeType: .decision,
                critical: true,
                content: "Is this predicted to be a difficult airway based on LEMON assessment?",
                connections: ["standard_rsi", "difficult_airway_algorithm"]
            ),
            // Node C
            AlgorithmNode(
                id: "standard_rsi",
                title: "Standard RSI Pathway",
                nodeType: .action,
                critical: false,
                content: "Standard RSI pathway selected. Begin 7 P's checklist",
                connections: ["preoxygenate"]
            ),
            // Node D
            AlgorithmNode(
                id: "difficult_airway_algorithm",
                title: "Difficult Airway Algorithm",
                nodeType: .action,
                critical: true,
                content: "Call for expert help and gather additional equipment",
                connections: ["call_for_help"]
            ),
            // Node E
            AlgorithmNode(
                id: "preoxygenate",
                title: "Preoxygenate 3-5 min 100% O2",
                nodeType: .intervention,
                critical: true,
                content: "Begin preoxygenation with 100% O2 for 3-5 minutes. SpO2 target >95%",
                connections: ["position_patient"]
            ),
            // Node F
            AlgorithmNode(
                id: "call_for_help",
                title: "Call for Help & Gather Equipment",
                nodeType: .action,
                critical: true,
                content: "Call anesthesia ext. 5555, prepare video laryngoscopy, fiberoptic scope",
                connections: ["awake_intubation_indicated"]
            ),
            // Node G
            AlgorithmNode(
                id: "position_patient",
                title: "Position Patient Sniffing/Ramped",
                nodeType: .action,
                critical: false,
                content: "Position patient in sniffing position or ramp to optimize laryngeal view",
                connections: ["pretreatment"]
            ),
            // Node H
            AlgorithmNode(
                id: "awake_intubation_indicated",
                title: "Awake Intubation Indicated?",
                nodeType: .decision,
                critical: true,
                content: "Is awake fiberoptic intubation indicated for difficult airway?",
                connections: ["topical_anesthesia", "video_laryngoscopy"]
            ),
            // Node I
            AlgorithmNode(
                id: "pretreatment",
                title: "Pretreatment If Indicated",
                nodeType: .medication,
                critical: false,
                content: "Consider fentanyl 3 mcg/kg, lidocaine 1.5 mg/kg if indicated",
                connections: ["induction_agent"]
            ),
            // Node J
            AlgorithmNode(
                id: "topical_anesthesia",
                title: "Topical Anesthesia & Sedation",
                nodeType: .medication,
                critical: false,
                content: "Apply topical anesthesia and light sedation for awake technique",
                connections: ["fiberoptic_technique"]
            ),
            // Node K
            AlgorithmNode(
                id: "video_laryngoscopy",
                title: "Video Laryngoscopy First Attempt",
                nodeType: .intervention,
                critical: true,
                content: "Use video laryngoscopy for improved visualization",
                connections: ["induction_agent"]
            ),
            // Node L
            AlgorithmNode(
                id: "induction_agent",
                title: "Induction Agent Weight-based",
                nodeType: .medication,
                critical: true,
                content: "Etomidate 0.3 mg/kg or Ketamine 1-2 mg/kg based on clinical scenario",
                connections: ["paralytic_agent"]
            ),
            // Node M
            AlgorithmNode(
                id: "fiberoptic_technique",
                title: "Fiberoptic/Awake Technique",
                nodeType: .intervention,
                critical: true,
                content: "Perform awake fiberoptic intubation with patient cooperation",
                connections: ["successful_placement"]
            ),
            // Node N
            AlgorithmNode(
                id: "paralytic_agent",
                title: "Paralytic Agent Rocuronium/Sux",
                nodeType: .medication,
                critical: true,
                content: "Rocuronium 1.2 mg/kg (preferred) or Succinylcholine 1.5 mg/kg",
                connections: ["allow_time"]
            ),
            // Node O
            AlgorithmNode(
                id: "successful_placement",
                title: "Successful Placement?",
                nodeType: .decision,
                critical: true,
                content: "Awake intubation successful? Confirm placement",
                connections: ["confirm_placement", "surgical_airway"]
            ),
            // Node P
            AlgorithmNode(
                id: "allow_time",
                title: "Allow Time 45-60 seconds",
                nodeType: .action,
                critical: false,
                content: "Allow adequate time for paralytic onset (45-60 seconds)",
                connections: ["first_attempt"]
            ),
            // Node Q
            AlgorithmNode(
                id: "confirm_placement",
                title: "Confirm Placement ETCO2",
                nodeType: .assessment,
                critical: true,
                content: "Confirm with ETCO2 waveform, bilateral breath sounds, chest rise",
                connections: ["post_intubation"]
            ),
            // Node R
            AlgorithmNode(
                id: "surgical_airway",
                title: "Surgical Airway",
                nodeType: .intervention,
                critical: true,
                content: "Cannot intubate, cannot ventilate - proceed with cricothyrotomy. Call ENT ext. 6666",
                connections: []
            ),
            // Node S
            AlgorithmNode(
                id: "first_attempt",
                title: "First Attempt Best Look",
                nodeType: .intervention,
                critical: true,
                content: "Proceed with first intubation attempt using best visualization technique",
                connections: ["successful_intubation"]
            ),
            // Node T
            AlgorithmNode(
                id: "successful_intubation",
                title: "Successful Intubation?",
                nodeType: .decision,
                critical: true,
                content: "ETT placement successful? Confirm with ETCO2",
                connections: ["confirm_placement", "spo2_check"]
            ),
            // Node U
            AlgorithmNode(
                id: "spo2_check",
                title: "SpO2 >90%?",
                nodeType: .decision,
                critical: true,
                content: "Is SpO2 adequate for second attempt?",
                connections: ["second_attempt", "bvm_ventilation"]
            ),
            // Node V
            AlgorithmNode(
                id: "second_attempt",
                title: "Second Attempt Different Approach",
                nodeType: .intervention,
                critical: true,
                content: "Modify technique: different blade, operator, or external manipulation",
                connections: ["second_attempt_successful"]
            ),
            // Node W
            AlgorithmNode(
                id: "bvm_ventilation",
                title: "BVM Ventilation Recover SpO2",
                nodeType: .intervention,
                critical: true,
                content: "Bag-mask ventilation to recover oxygenation before next attempt",
                connections: ["lma_rescue"]
            ),
            // Node X
            AlgorithmNode(
                id: "second_attempt_successful",
                title: "Second Attempt Successful?",
                nodeType: .decision,
                critical: true,
                content: "Was second intubation attempt successful?",
                connections: ["confirm_placement", "lma_rescue"]
            ),
            // Node Y
            AlgorithmNode(
                id: "lma_rescue",
                title: "Consider LMA Rescue Device",
                nodeType: .intervention,
                critical: true,
                content: "Insert LMA or other supraglottic airway device",
                connections: ["adequate_ventilation"]
            ),
            // Node Z
            AlgorithmNode(
                id: "adequate_ventilation",
                title: "Adequate Ventilation?",
                nodeType: .decision,
                critical: true,
                content: "Is ventilation and oxygenation adequate with rescue device?",
                connections: ["stabilize_plan", "surgical_airway"]
            ),
            // Node AA
            AlgorithmNode(
                id: "stabilize_plan",
                title: "Stabilize & Plan Next Steps",
                nodeType: .action,
                critical: false,
                content: "Stabilize patient with rescue device and plan definitive airway",
                connections: []
            ),
            // Node AB
            AlgorithmNode(
                id: "post_intubation",
                title: "Post-Intubation Management",
                nodeType: .action,
                critical: false,
                content: "Begin post-intubation sedation and ventilator setup",
                connections: ["secure_ett"]
            ),
            // Node AC
            AlgorithmNode(
                id: "secure_ett",
                title: "Secure ETT & Obtain CXR",
                nodeType: .action,
                critical: false,
                content: "Secure endotracheal tube and confirm position with chest X-ray",
                connections: ["initiate_sedation"]
            ),
            // Node AD
            AlgorithmNode(
                id: "initiate_sedation",
                title: "Initiate Sedation & Set Ventilator",
                nodeType: .endpoint,
                critical: false,
                content: "Start sedation infusion and set ventilator: TV 6-8 mL/kg IBW, PEEP 5, Rate 12-20",
                connections: []
            )
        ])
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "RSI & Advanced Airway Protocol",
                sections: [
                    CardSection(title: "Critical Actions", items: [
                        "🫁 Airway assessment",
                        "💊 Drug dosing calculators",
                        "🔪 Backup airway algorithms",
                        "⚙️ Ventilator management",
                        "📊 Post-intubation care"
                    ])
                ]
            )
        ]
        return EmergencyProtocol(
            id: "rsi_protocol",
            title: "RSI & Advanced Airway Protocol",
            icon: "lungs", // Airway/breathing for intubation
            category: .respiratory,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    private func createShockProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            // Node A
            AlgorithmNode(
                id: "recognize_shock",
                title: "Recognize Shock MAP <65 or Lactate >2",
                nodeType: .assessment,
                critical: true,
                content: "Signs of shock identified: hypotension, tachycardia, or elevated lactate",
                connections: ["initial_stabilization"]
            ),
            // Node B
            AlgorithmNode(
                id: "initial_stabilization",
                title: "Initial Stabilization O2 IV Monitors",
                nodeType: .intervention,
                critical: true,
                content: "Complete initial stabilization: oxygen, IV access x2, monitors, vital signs",
                connections: ["fluid_resuscitation"]
            ),
            // Node C
            AlgorithmNode(
                id: "fluid_resuscitation",
                title: "Fluid Resuscitation 30 mL/kg crystalloid",
                nodeType: .intervention,
                critical: true,
                content: "Administer 30 mL/kg crystalloid bolus rapidly. Monitor response",
                connections: ["fluid_responsive"]
            ),
            // Node D
            AlgorithmNode(
                id: "fluid_responsive",
                title: "Fluid Responsive?",
                nodeType: .decision,
                critical: true,
                content: "Assess fluid responsiveness: improved BP, HR, perfusion, or urine output?",
                connections: ["continue_fluids", "identify_shock_type"]
            ),
            // Node E
            AlgorithmNode(
                id: "continue_fluids",
                title: "Continue Fluids & Reassess",
                nodeType: .intervention,
                critical: false,
                content: "Continue fluid resuscitation and reassess hemodynamics",
                connections: ["map_adequate"]
            ),
            // Node F
            AlgorithmNode(
                id: "identify_shock_type",
                title: "Identify Shock Type Clinical plus POCUS",
                nodeType: .assessment,
                critical: true,
                content: "Identify shock type using clinical assessment and point-of-care ultrasound (RUSH exam)",
                connections: ["shock_type"]
            ),
            // Node G
            AlgorithmNode(
                id: "map_adequate",
                title: "MAP >65?",
                nodeType: .decision,
                critical: true,
                content: "Is MAP >65 mmHg with current resuscitation?",
                connections: ["monitor_treat", "identify_shock_type"]
            ),
            // Node H
            AlgorithmNode(
                id: "monitor_treat",
                title: "Monitor and Treat Underlying Cause",
                nodeType: .action,
                critical: false,
                content: "Continue monitoring and treat underlying cause of shock",
                connections: []
            ),
            // Node I
            AlgorithmNode(
                id: "shock_type",
                title: "Shock Type?",
                nodeType: .decision,
                critical: true,
                content: "Distributive vs Cardiogenic vs Hypovolemic vs Obstructive?",
                connections: ["distributive_shock", "cardiogenic_shock", "hypovolemic_shock", "obstructive_shock"]
            ),
            // Node J
            AlgorithmNode(
                id: "distributive_shock",
                title: "Start Norepinephrine Culture and Antibiotics",
                nodeType: .medication,
                critical: true,
                content: "Distributive shock: Start norepinephrine 2-30 mcg/min, obtain cultures, give antibiotics",
                connections: ["adequate_response"]
            ),
            // Node K
            AlgorithmNode(
                id: "cardiogenic_shock",
                title: "Dobutamine/Milrinone Consider MCS",
                nodeType: .medication,
                critical: true,
                content: "Cardiogenic shock: Dobutamine 2.5-20 mcg/kg/min or Milrinone. Consider mechanical support",
                connections: ["scai_stage"]
            ),
            // Node L
            AlgorithmNode(
                id: "hypovolemic_shock",
                title: "Volume/Blood Find Source",
                nodeType: .intervention,
                critical: true,
                content: "Hypovolemic shock: Continue volume resuscitation, identify bleeding source",
                connections: ["bleeding_controlled"]
            ),
            // Node M
            AlgorithmNode(
                id: "obstructive_shock",
                title: "Treat Cause Immediate",
                nodeType: .intervention,
                critical: true,
                content: "Obstructive shock: Immediate intervention - needle decompression, pericardiocentesis, or anticoagulation",
                connections: ["decompress_anticoag"]
            ),
            // Node N
            AlgorithmNode(
                id: "adequate_response",
                title: "Adequate Response?",
                nodeType: .decision,
                critical: true,
                content: "Adequate response to first-line therapy?",
                connections: ["monitor_treat", "add_vasopressin"]
            ),
            // Node O
            AlgorithmNode(
                id: "scai_stage",
                title: "SCAI Stage?",
                nodeType: .decision,
                critical: true,
                content: "SCAI Stage C-E? (C: Classic, D: Deteriorating, E: Extremis)",
                connections: ["ecmo_evaluation"]
            ),
            // Node P
            AlgorithmNode(
                id: "bleeding_controlled",
                title: "Bleeding Controlled?",
                nodeType: .decision,
                critical: true,
                content: "Is bleeding source identified and controlled?",
                connections: ["continue_resuscitation", "surgery_ir"]
            ),
            // Node Q
            AlgorithmNode(
                id: "decompress_anticoag",
                title: "Decompress/Anticoag Based on Cause",
                nodeType: .intervention,
                critical: true,
                content: "Perform intervention based on obstructive cause",
                connections: []
            ),
            // Node R
            AlgorithmNode(
                id: "add_vasopressin",
                title: "Add Vasopressin Consider Epinephrine",
                nodeType: .medication,
                critical: true,
                content: "Add vasopressin 0.03-0.04 units/min or consider epinephrine 1-20 mcg/min",
                connections: ["refractory_shock"]
            ),
            // Node S
            AlgorithmNode(
                id: "ecmo_evaluation",
                title: "ECMO Evaluation Early MCS",
                nodeType: .assessment,
                critical: true,
                content: "Evaluate for ECMO or other mechanical circulatory support",
                connections: ["transfer_center"]
            ),
            // Node T
            AlgorithmNode(
                id: "surgery_ir",
                title: "Surgery/IR Massive Transfusion",
                nodeType: .intervention,
                critical: true,
                content: "Consult surgery/IR, activate massive transfusion protocol if needed",
                connections: []
            ),
            // Node U
            AlgorithmNode(
                id: "continue_resuscitation",
                title: "Continue Resuscitation",
                nodeType: .action,
                critical: false,
                content: "Continue resuscitation efforts and reassess",
                connections: []
            ),
            // Node V
            AlgorithmNode(
                id: "refractory_shock",
                title: "Refractory Shock?",
                nodeType: .decision,
                critical: true,
                content: "Refractory shock despite optimal medical therapy?",
                connections: ["consider_ecmo_high_dose"]
            ),
            // Node W
            AlgorithmNode(
                id: "transfer_center",
                title: "Transfer Center 856-886-5111",
                nodeType: .action,
                critical: true,
                content: "Contact Transfer Center for mobile ECMO evaluation",
                connections: ["mobile_ecmo_team"]
            ),
            // Node X
            AlgorithmNode(
                id: "consider_ecmo_high_dose",
                title: "Consider ECMO High-dose Pressors",
                nodeType: .decision,
                critical: true,
                content: "Consider ECMO evaluation for refractory shock on high-dose pressors",
                connections: ["mobile_ecmo_team"]
            ),
            // Node Y
            AlgorithmNode(
                id: "mobile_ecmo_team",
                title: "Mobile ECMO Team Activation",
                nodeType: .action,
                critical: true,
                content: "Mobile ECMO team activation - prepare for cannulation",
                connections: ["ecmo_cannulation"]
            ),
            // Node Z
            AlgorithmNode(
                id: "ecmo_cannulation",
                title: "ECMO Cannulation ICU Management",
                nodeType: .endpoint,
                critical: true,
                content: "ECMO cannulation and ICU management with specialized team",
                connections: []
            )
        ])
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Shock & ECMO Protocols",
                sections: [
                    CardSection(title: "Critical Actions", items: [
                        "⚡ Shock classification",
                        "🫀 ECMO activation",
                        "💉 Hemodynamic support",
                        "📊 Vasopressor protocols",
                        "🩸 Mobile ECMO coordination"
                    ])
                ]
            )
        ]
        return EmergencyProtocol(
            id: "shock_protocol",
            title: "Shock & ECMO Protocols",
            icon: "drop.circle.fill", // Circulatory shock/perfusion
            category: .cardiac,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    // MARK: - Anaphylaxis Protocol
    
    private func createAnaphylaxisProtocolAsync() async -> EmergencyProtocol {
        return createAnaphylaxisProtocol()
    }
    
    private func createAnaphylaxisProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "recognition",
                title: "Recognize Anaphylaxis",
                nodeType: .assessment,
                critical: true,
                content: "Sudden onset with rapid progression: skin/mucosal involvement + respiratory compromise OR hypotension",
                connections: ["immediate_epinephrine"]
            ),
            AlgorithmNode(
                id: "immediate_epinephrine",
                title: "Epinephrine IM",
                nodeType: .medication,
                critical: true,
                content: "0.3-0.5mg IM (1:1000) in anterolateral thigh. Repeat q5-15min PRN",
                connections: ["position_oxygen"]
            ),
            AlgorithmNode(
                id: "position_oxygen",
                title: "Position & Oxygen",
                nodeType: .intervention,
                critical: true,
                content: "Supine position (elevate legs if hypotensive), high-flow O2, prepare for intubation",
                connections: ["iv_access"]
            ),
            AlgorithmNode(
                id: "iv_access",
                title: "IV Access & Fluids",
                nodeType: .intervention,
                critical: true,
                content: "Large bore IV x2, NS bolus 1-2L rapidly for hypotension",
                connections: ["adjunctive_therapy"]
            ),
            AlgorithmNode(
                id: "adjunctive_therapy",
                title: "Adjunctive Medications",
                nodeType: .medication,
                critical: false,
                content: "H1 blocker: Diphenhydramine 25-50mg IV/IM\nH2 blocker: Famotidine 20mg IV\nCorticosteroids: Methylprednisolone 125mg IV",
                connections: ["refractory_treatment"]
            ),
            AlgorithmNode(
                id: "refractory_treatment",
                title: "Refractory Anaphylaxis?",
                nodeType: .decision,
                critical: true,
                content: "Not responding to epinephrine and fluids?",
                connections: ["epinephrine_infusion", "monitor_biphasic"]
            ),
            AlgorithmNode(
                id: "epinephrine_infusion",
                title: "Epinephrine Infusion",
                nodeType: .medication,
                critical: true,
                content: "Start epinephrine infusion 0.1-1 mcg/kg/min. Consider glucagon 1-5mg IV if on beta-blockers",
                connections: ["monitor_biphasic"]
            ),
            AlgorithmNode(
                id: "monitor_biphasic",
                title: "Monitor for Biphasic Reaction",
                nodeType: .assessment,
                critical: true,
                content: "Observe minimum 4-6 hours, up to 24 hours for severe reactions. Monitor for recurrence",
                connections: ["endpoint"]
            ),
            AlgorithmNode(
                id: "endpoint",
                title: "Protocol End",
                nodeType: .endpoint,
                critical: false,
                content: "Document trigger if identified. Prescribe EpiPen. Refer to allergy/immunology.",
                connections: []
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "Anaphylaxis Management",
                sections: [
                    CardSection(title: "Recognition Criteria", items: [
                        "🔴 Acute onset (minutes to hours)",
                        "🫁 Respiratory: dyspnea, wheeze, stridor, hypoxemia",
                        "🫀 Cardiovascular: hypotension, syncope, collapse",
                        "🎯 Skin: urticaria, angioedema, flushing, pruritus",
                        "🤢 GI: crampy abdominal pain, vomiting"
                    ]),
                    CardSection(title: "Epinephrine Dosing", items: [
                        "💉 Adult: 0.3-0.5mg IM (1:1000)",
                        "👶 Pediatric: 0.01mg/kg IM (max 0.3mg)",
                        "🔁 Repeat q5-15 minutes PRN",
                        "📍 Location: Anterolateral thigh",
                        "⚠️ IV only if arrest/profound shock"
                    ])
                ]
            ),
            ProtocolCard(
                id: "assessment_card",
                type: .assessment,
                title: "Differential Diagnosis",
                sections: [
                    CardSection(title: "Consider", items: [
                        "Vasovagal reaction",
                        "Panic attack",
                        "Asthma exacerbation",
                        "Urticaria without anaphylaxis",
                        "Hereditary angioedema",
                        "Systemic mastocytosis"
                    ])
                ]
            ),
            ProtocolCard(
                id: "actions_card",
                type: .actions,
                title: "Post-Stabilization",
                sections: [
                    CardSection(title: "Essential Actions", items: [
                        "📋 Document trigger if identified",
                        "💊 Prescribe EpiPen (2 doses)",
                        "📚 Patient education on avoidance",
                        "🏥 Allergy/immunology referral",
                        "⏱️ Observe 4-24 hours for biphasic reaction"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "anaphylaxis",
            title: "Anaphylaxis",
            icon: "allergens", // Anaphylaxis reaction
            category: .allergic,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    // MARK: - Emergency Support Protocol
    
    private func createEmergencySupportProtocolAsync() async -> EmergencyProtocol {
        return createEmergencySupportProtocol()
    }
    
    private func createEmergencySupportProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "rrt_activation",
                title: "RRT Activation",
                nodeType: .assessment,
                critical: true,
                content: "Rapid Response Team activated for clinical deterioration",
                connections: ["initial_assessment"]
            ),
            AlgorithmNode(
                id: "initial_assessment",
                title: "Initial Assessment",
                nodeType: .assessment,
                critical: true,
                content: "Primary survey: Airway, Breathing, Circulation, Disability, Exposure",
                connections: ["vital_signs"]
            ),
            AlgorithmNode(
                id: "vital_signs",
                title: "Vital Signs & Monitoring",
                nodeType: .intervention,
                critical: true,
                content: "Full set of vitals, continuous cardiac monitoring, pulse oximetry",
                connections: ["focused_exam"]
            ),
            AlgorithmNode(
                id: "focused_exam",
                title: "Focused Physical Exam",
                nodeType: .assessment,
                critical: true,
                content: "Targeted examination based on chief concern",
                connections: ["immediate_interventions"]
            ),
            AlgorithmNode(
                id: "immediate_interventions",
                title: "Immediate Interventions",
                nodeType: .intervention,
                critical: true,
                content: "IV access, oxygen as needed, labs, ECG, medications per protocol",
                connections: ["contact_resources"]
            ),
            AlgorithmNode(
                id: "contact_resources",
                title: "Contact Resources",
                nodeType: .action,
                critical: false,
                content: "Call appropriate consultants based on clinical needs",
                connections: ["disposition"]
            ),
            AlgorithmNode(
                id: "disposition",
                title: "Determine Disposition",
                nodeType: .decision,
                critical: true,
                content: "ICU transfer, floor with increased monitoring, or stabilize in place",
                connections: ["endpoint"]
            ),
            AlgorithmNode(
                id: "endpoint",
                title: "Protocol End",
                nodeType: .endpoint,
                critical: false,
                content: "Document RRT activation, interventions, and outcome",
                connections: []
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "RRT Initial Steps",
                sections: [
                    CardSection(title: "Immediate Actions", items: [
                        "🔴 Assess ABCs",
                        "📊 Full vital signs",
                        "🫀 Cardiac monitoring",
                        "🩸 IV access x2",
                        "🧪 Labs: CBC, BMP, ABG",
                        "📋 12-lead ECG",
                        "💊 Medications per protocol"
                    ])
                ]
            ),
            ProtocolCard(
                id: "assessment_card",
                type: .assessment,
                title: "Critical Phone Numbers",
                sections: [
                    CardSection(title: "Emergency Contacts", items: [
                        "📞 ICU NP: 856-XXX-XXXX",
                        "🏥 Anesthesia: 856-XXX-XXXX",
                        "🚁 Sevaro: 1-856-363-0709",
                        "🚑 Transfer Center: 856-886-5111",
                        "💊 Pharmacy: 856-XXX-XXXX",
                        "🩸 Blood Bank: 856-XXX-XXXX"
                    ]),
                    CardSection(title: "Swipe for More →", items: [
                        "👉 Swipe card right for additional contacts"
                    ])
                ]
            ),
            ProtocolCard(
                id: "actions_card",
                type: .actions,
                title: "Additional Resources",
                sections: [
                    CardSection(title: "Specialty Consults", items: [
                        "🫀 Cardiology: 856-XXX-XXXX",
                        "🧠 Neurology: 856-XXX-XXXX",
                        "🫁 Pulmonology: 856-XXX-XXXX",
                        "🩺 Hospitalist: 856-XXX-XXXX",
                        "🔬 Infectious Disease: 856-XXX-XXXX"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "emergency_support",
            title: "Emergency Support",
            icon: "stethoscope", // Medical emergency support
            category: .support,
            algorithm: algorithm,
            cards: cards
        )
    }
}