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
                ("Code Blue Protocol", { await self.createCodeBlueProtocolAsync() }),
                ("Code Stroke Protocol", { await self.createCodeStrokeProtocolAsync() }),
                ("Code STEMI Protocol", { await self.createCodeSTEMIProtocolAsync() }),
                ("RSI Protocol", { await self.createRSIProtocolAsync() }),
                ("Shock Protocol", { await self.createShockProtocolAsync() }),
                ("Anaphylaxis Protocol", { await self.createAnaphylaxisProtocolAsync() }),
                ("Emergency Support Protocol", { await self.createEmergencySupportProtocolAsync() })
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
    
    private func createAnaphylaxisProtocolAsync() async -> EmergencyProtocol {
        return createAnaphylaxisProtocol()
    }
    
    private func createEmergencySupportProtocolAsync() async -> EmergencyProtocol {
        return createEmergencySupportProtocol()
    }
    
    // MARK: - Code Blue Protocol (AHA ACLS 2025 Guidelines)
    
    private func createCodeBlueProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "initial_assessment",
                title: "Initial Assessment",
                nodeType: .assessment,
                critical: true,
                content: "Check responsiveness and pulse. If unresponsive and no pulse, begin CPR immediately.",
                connections: ["cpr_start"]
            ),
            AlgorithmNode(
                id: "cpr_start",
                title: "Start CPR",
                nodeType: .intervention,
                critical: true,
                content: "High-quality CPR: 100-120 compressions/min, allow complete chest recoil, minimize interruptions.",
                connections: ["rhythm_check"]
            ),
            AlgorithmNode(
                id: "rhythm_check",
                title: "Rhythm Analysis",
                nodeType: .decision,
                critical: true,
                content: "Check rhythm after 2 minutes of CPR",
                connections: ["vf_vt", "pea_asystole"]
            ),
            AlgorithmNode(
                id: "vf_vt",
                title: "VF/VT - Shockable",
                nodeType: .intervention,
                critical: true,
                content: "Defibrillate immediately. Resume CPR for 2 minutes before next rhythm check.",
                connections: ["post_shock_drugs"]
            ),
            AlgorithmNode(
                id: "pea_asystole",
                title: "PEA/Asystole - Non-shockable",
                nodeType: .intervention,
                critical: true,
                content: "Continue CPR. Consider reversible causes (H's and T's).",
                connections: ["epinephrine"]
            ),
            AlgorithmNode(
                id: "epinephrine",
                title: "Epinephrine",
                nodeType: .medication,
                critical: true,
                content: "1mg IV/IO every 3-5 minutes during resuscitation",
                connections: ["advanced_airway"]
            ),
            AlgorithmNode(
                id: "post_shock_drugs",
                title: "Post-Shock Medications",
                nodeType: .medication,
                critical: true,
                content: "Amiodarone 300mg IV/IO or Lidocaine 1-1.5mg/kg if amiodarone unavailable",
                connections: ["advanced_airway"]
            ),
            AlgorithmNode(
                id: "advanced_airway",
                title: "Advanced Airway",
                nodeType: .intervention,
                critical: false,
                content: "Consider endotracheal intubation or supraglottic airway. Continuous chest compressions once secured.",
                connections: ["rosc_check"]
            ),
            AlgorithmNode(
                id: "rosc_check",
                title: "ROSC Achieved?",
                nodeType: .decision,
                critical: true,
                content: "Return of spontaneous circulation: pulse present, BP measurable, end-tidal CO2 >40mmHg",
                connections: ["post_cardiac_arrest", "continue_acls"]
            ),
            AlgorithmNode(
                id: "post_cardiac_arrest",
                title: "Post-Cardiac Arrest Care",
                nodeType: .intervention,
                critical: true,
                content: "Optimize oxygenation, ventilation, circulation. Consider targeted temperature management.",
                connections: []
            ),
            AlgorithmNode(
                id: "continue_acls",
                title: "Continue ACLS",
                nodeType: .intervention,
                critical: true,
                content: "Continue cycles of CPR and medications. Reassess rhythm every 2 minutes.",
                connections: ["rhythm_check"]
            )
        ])
        
        let cards = [
            ProtocolCard(
                id: "dynamic_card",
                type: .dynamic,
                title: "ACLS Algorithm Progress",
                sections: [
                    CardSection(title: "Current Status", items: [
                        "CPR in progress",
                        "Rhythm: Check every 2 minutes", 
                        "Next medication due: As per protocol",
                        "Time elapsed: Monitor continuously"
                    ])
                ]
            ),
            ProtocolCard(
                id: "assessment_card",
                type: .assessment,
                title: "Cardiac Arrest Assessment",
                sections: [
                    CardSection(title: "Shockable Rhythms", items: [
                        "Ventricular Fibrillation (VF)",
                        "Pulseless Ventricular Tachycardia (VT)"
                    ]),
                    CardSection(title: "Non-Shockable Rhythms", items: [
                        "Pulseless Electrical Activity (PEA)",
                        "Asystole"
                    ]),
                    CardSection(title: "Reversible Causes (H's and T's)", items: [
                        "Hypovolemia, Hypoxia, Hydrogen ion (acidosis)",
                        "Hyper/hypokalemia, Hypothermia",
                        "Toxins, Tamponade, Tension pneumothorax",
                        "Thrombosis (pulmonary), Thrombosis (coronary)"
                    ])
                ]
            ),
            ProtocolCard(
                id: "actions_card",
                type: .actions,
                title: "Critical Actions",
                sections: [
                    CardSection(title: "Immediate Actions", items: [
                        "Start high-quality CPR immediately",
                        "Attach defibrillator/monitor",
                        "Establish IV/IO access",
                        "Give oxygen, ensure adequate ventilation"
                    ]),
                    CardSection(title: "Medication Dosing", items: [
                        "Epinephrine: 1mg IV/IO every 3-5 minutes",
                        "Amiodarone: 300mg IV/IO (first dose), then 150mg",
                        "Lidocaine: 1-1.5mg/kg IV/IO (alternative to amiodarone)"
                    ])
                ]
            )
        ]
        
        return EmergencyProtocol(
            id: "code_blue_acls",
            title: "Code Blue ACLS",
            icon: "healthicon-defibrillator",
            category: .cardiac,
            algorithm: algorithm,
            cards: cards
        )
    }
    
    // MARK: - Additional Protocols (Simplified for space)
    
    private func createCodeStrokeProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(id: "stroke_assessment", title: "Stroke Assessment", nodeType: .assessment, critical: true, content: "NIHSS scale, onset time", connections: [])
        ])
        let cards = [ProtocolCard(id: "dynamic", type: .dynamic, title: "Stroke Care", sections: [])]
        return EmergencyProtocol(id: "code_stroke", title: "Code Stroke", icon: "healthicon-neurology", category: .neurological, algorithm: algorithm, cards: cards)
    }
    
    private func createCodeSTEMIProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(id: "stemi_assessment", title: "STEMI Assessment", nodeType: .assessment, critical: true, content: "12-lead ECG, troponins", connections: [])
        ])
        let cards = [ProtocolCard(id: "dynamic", type: .dynamic, title: "STEMI Care", sections: [])]
        return EmergencyProtocol(id: "code_stemi", title: "Code STEMI", icon: "healthicon-heart_organ", category: .cardiac, algorithm: algorithm, cards: cards)
    }
    
    private func createRSIProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(id: "rsi_preparation", title: "RSI Preparation", nodeType: .assessment, critical: true, content: "Airway assessment, equipment check", connections: [])
        ])
        let cards = [ProtocolCard(id: "dynamic", type: .dynamic, title: "RSI Protocol", sections: [])]
        return EmergencyProtocol(id: "rsi_protocol", title: "Rapid Sequence Intubation", icon: "healthicon-endotracheal_tube", category: .respiratory, algorithm: algorithm, cards: cards)
    }
    
    private func createShockProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(id: "shock_assessment", title: "Shock Assessment", nodeType: .assessment, critical: true, content: "Hemodynamic evaluation", connections: [])
        ])
        let cards = [ProtocolCard(id: "dynamic", type: .dynamic, title: "Shock Management", sections: [])]
        return EmergencyProtocol(id: "shock_protocol", title: "Shock/ECMO", icon: "healthicon-ecmo", category: .cardiac, algorithm: algorithm, cards: cards)
    }
    
    private func createAnaphylaxisProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(id: "anaphylaxis_assessment", title: "Anaphylaxis Assessment", nodeType: .assessment, critical: true, content: "Allergic reaction evaluation", connections: [])
        ])
        let cards = [ProtocolCard(id: "dynamic", type: .dynamic, title: "Anaphylaxis Care", sections: [])]
        return EmergencyProtocol(id: "anaphylaxis_protocol", title: "Anaphylaxis", icon: "exclamationmark.triangle.fill", category: .allergic, algorithm: algorithm, cards: cards)
    }
    
    private func createEmergencySupportProtocol() -> EmergencyProtocol {
        let algorithm = ProtocolAlgorithm(nodes: [
            AlgorithmNode(id: "support_assessment", title: "Support Assessment", nodeType: .assessment, critical: true, content: "General emergency support", connections: [])
        ])
        let cards = [ProtocolCard(id: "dynamic", type: .dynamic, title: "Emergency Support", sections: [])]
        return EmergencyProtocol(id: "emergency_support", title: "Emergency Support", icon: "cross.fill", category: .support, algorithm: algorithm, cards: cards)
    }
}