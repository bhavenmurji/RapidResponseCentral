import SwiftUI

// MARK: - Decision Card for Branching Nodes
public struct DecisionCard: View {
    let node: AlgorithmNode
    let onSelection: (String) -> Void
    @State private var selectedOption: String?
    
    public init(node: AlgorithmNode, onSelection: @escaping (String) -> Void) {
        self.node = node
        self.onSelection = onSelection
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Compact Header with decision icon
            HStack(spacing: 6) {
                Image(systemName: "questionmark.diamond.fill")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.blue)
                
                Text("DECISION POINT")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                if node.critical {
                    Label("CRITICAL", systemImage: "exclamationmark.triangle.fill")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(.red)
                        .labelStyle(.titleAndIcon)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(Color.blue.opacity(0.1))
            
            VStack(alignment: .leading, spacing: 8) {
                // Question (more compact)
                VStack(alignment: .leading, spacing: 2) {
                    Text("❓ " + node.title)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    if !node.content.isEmpty {
                        Text(node.content)
                            .font(.system(size: 9))
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(2)
                    }
                }
                
                Divider()
                
                // Decision Options (more compact)
                if node.connections.count >= 2 {
                    VStack(spacing: 6) {
                        // YES Option
                        DecisionOptionButton(
                            label: "YES",
                            description: getOptionDescription(for: node.connections[0]),
                            icon: "checkmark.circle.fill",
                            color: .green,
                            isSelected: selectedOption == node.connections[0],
                            action: {
                                selectedOption = node.connections[0]
                                onSelection(node.connections[0])
                            }
                        )
                        
                        // NO Option
                        DecisionOptionButton(
                            label: "NO",
                            description: getOptionDescription(for: node.connections[1]),
                            icon: "xmark.circle.fill",
                            color: .red,
                            isSelected: selectedOption == node.connections[1],
                            action: {
                                selectedOption = node.connections[1]
                                onSelection(node.connections[1])
                            }
                        )
                    }
                } else if node.connections.count == 1 {
                    // Single path forward
                    Button(action: {
                        onSelection(node.connections[0])
                    }) {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.system(size: 11))
                                .foregroundColor(.blue)
                            Text("Continue")
                                .font(.system(size: 10, weight: .medium))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 9))
                                .foregroundColor(.secondary)
                        }
                        .padding(6)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(6)
                    }
                    .buttonStyle(.plain)
                }
                
                // Critical Information Panel (more compact)
                if node.nodeType == .decision {
                    VStack(alignment: .leading, spacing: 4) {
                        Divider()
                        
                        // Context-specific critical values or guidance
                        CriticalInfoBox(node: node)
                        
                        Text("Tap an option to proceed")
                            .font(.system(size: 8))
                            .foregroundColor(.secondary)
                            .italic()
                    }
                }
            }
            .padding(8)
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemBackground))
                .shadow(color: .blue.opacity(0.2), radius: 4, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.blue.opacity(0.3), lineWidth: 1)
        )
    }
    
    private func getOptionDescription(for connectionId: String) -> String {
        // Enhanced protocol-specific decision guidance
        let title = node.title.lowercased()
        
        // Code Blue - ACLS
        if title.contains("shockable") || title.contains("rhythm") {
            return connectionId == node.connections[0] ? 
                "VF/Pulseless VT detected → Proceed to defibrillation (200J biphasic)" : 
                "PEA/Asystole → Continue CPR + Epinephrine 1mg q3-5min"
        }
        
        if title.contains("rosc") || title.contains("return") {
            return connectionId == node.connections[0] ? 
                "Pulse present → Initiate post-cardiac arrest care, target temp 32-36°C" : 
                "No pulse → Resume CPR cycles, reassess rhythm q2min"
        }
        
        // Code Stroke
        if title.contains("hemorrhage") || title.contains("bleed") {
            return connectionId == node.connections[0] ? 
                "Hemorrhagic stroke confirmed → Reverse anticoagulation, neurosurgery consult" : 
                "Ischemic stroke → Evaluate for tPA (if <4.5hr) or thrombectomy"
        }
        
        if title.contains("tpa") || title.contains("thrombolysis") {
            return connectionId == node.connections[0] ? 
                "Eligible for tPA → Administer 0.9mg/kg (max 90mg), 10% bolus" : 
                "Contraindications present → Consider mechanical thrombectomy"
        }
        
        // Code STEMI
        if title.contains("stemi") || title.contains("elevation") {
            return connectionId == node.connections[0] ? 
                "STEMI confirmed → Activate cath lab, door-to-balloon <90min" : 
                "No ST elevation → Evaluate for NSTEMI, serial troponins"
        }
        
        // RSI
        if title.contains("difficult airway") || title.contains("intubation") {
            return connectionId == node.connections[0] ? 
                "Difficult airway anticipated → Prepare backup devices, call anesthesia" : 
                "Standard airway → Proceed with RSI sequence"
        }
        
        // Shock & ECMO
        if title.contains("shock") || title.contains("hypotension") {
            return connectionId == node.connections[0] ? 
                "Fluid responsive → Continue crystalloid resuscitation" : 
                "Refractory shock → Initiate vasopressors, consider ECMO"
        }
        
        // Default enhanced descriptions
        return connectionId == node.connections[0] ? 
            "Positive finding → Proceed with primary intervention pathway" : 
            "Negative/Alternative → Follow secondary management protocol"
    }
}

// MARK: - Decision Option Button
struct DecisionOptionButton: View {
    let label: String
    let description: String
    let icon: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                // Icon (smaller)
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(isSelected ? .white : color)
                    .frame(width: 20, height: 20)
                
                // Text content (more compact)
                VStack(alignment: .leading, spacing: 1) {
                    Text("🔘 " + label)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(isSelected ? .white : .primary)
                    
                    Text("→ " + description)
                        .font(.system(size: 8))
                        .foregroundColor(isSelected ? .white.opacity(0.9) : .secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                // Arrow
                Image(systemName: "arrow.right")
                    .font(.system(size: 9, weight: .medium))
                    .foregroundColor(isSelected ? .white : .secondary)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(isSelected ? color : color.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(color, lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isSelected)
    }
}

// MARK: - Critical Information Box
struct CriticalInfoBox: View {
    let node: AlgorithmNode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Label("Critical Information", systemImage: "info.circle.fill")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.orange)
            
            VStack(alignment: .leading, spacing: 3) {
                ForEach(getCriticalInfo(), id: \.self) { info in
                    HStack(alignment: .top, spacing: 4) {
                        Text("•")
                            .font(.system(size: 10))
                            .foregroundColor(.orange)
                        Text(info)
                            .font(.system(size: 10))
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .padding(6)
            .background(Color.orange.opacity(0.08))
            .cornerRadius(6)
        }
    }
    
    private func getCriticalInfo() -> [String] {
        let title = node.title.lowercased()
        
        // Protocol-specific critical information
        if title.contains("shockable") || title.contains("rhythm") {
            return [
                "Check pulse for max 10 seconds",
                "Minimize interruptions in compressions",
                "Consider reversible causes (H's and T's)"
            ]
        }
        
        if title.contains("rosc") {
            return [
                "Monitor ETCO2 (sudden rise >40 indicates ROSC)",
                "Check central pulse",
                "Avoid hyperventilation"
            ]
        }
        
        if title.contains("hemorrhage") || title.contains("stroke") {
            return [
                "Time is brain - note last known well time",
                "Check BP (goal <185/110 for tPA)",
                "NIHSS score for severity"
            ]
        }
        
        if title.contains("stemi") {
            return [
                "Door-to-balloon time goal: <90 min",
                "Give ASA 325mg, P2Y12 inhibitor",
                "Monitor for cardiogenic shock"
            ]
        }
        
        if title.contains("airway") || title.contains("intubation") {
            return [
                "Pre-oxygenate to SpO2 100%",
                "Have backup airway ready",
                "Two-person BVM if needed"
            ]
        }
        
        if title.contains("shock") {
            return [
                "MAP goal >65 mmHg",
                "Lactate clearance target",
                "Consider early vasopressors if fluid refractory"
            ]
        }
        
        // Default critical info
        return [
            "Reassess vital signs",
            "Document time and interventions",
            "Consider consulting specialist"
        ]
    }
}

// MARK: - Enhanced Protocol Card Following Documentation Style
public struct EnhancedProtocolCard: View {
    let title: String
    let emoji: String
    let sections: [CardSection]
    let cardType: CardType
    let isActive: Bool
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Card header matching documentation style
            Text("\(emoji) \(title.uppercased())")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.primary)
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(cardTypeColor.opacity(0.1))
                .overlay(
                    Rectangle()
                        .fill(cardTypeColor)
                        .frame(height: 2),
                    alignment: .bottom
                )
            
            // Card content with documentation-style formatting
            VStack(alignment: .leading, spacing: 8) {
                ForEach(sections, id: \.id) { section in
                    VStack(alignment: .leading, spacing: 4) {
                        if !section.title.isEmpty {
                            Text(section.title)
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundColor(cardTypeColor)
                        }
                        
                        ForEach(section.items, id: \.self) { item in
                            HStack(alignment: .top, spacing: 4) {
                                Text("•")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(cardTypeColor)
                                
                                Text(item)
                                    .font(.system(size: 10))
                                    .foregroundColor(.primary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }
            }
            .padding(10)
            
            // Navigation hint at bottom
            if isActive {
                HStack {
                    Text("[Next: Based on Selection ▶]")
                        .font(.system(size: 9))
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .padding(.horizontal, 10)
                .padding(.bottom, 8)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemBackground))
                .shadow(
                    color: isActive ? cardTypeColor.opacity(0.2) : .black.opacity(0.05),
                    radius: isActive ? 4 : 2,
                    y: 2
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(
                    isActive ? cardTypeColor : Color(.systemGray4),
                    lineWidth: isActive ? 2 : 0.5
                )
        )
    }
    
    private var cardTypeColor: Color {
        switch cardType {
        case .dynamic: return .blue
        case .assessment: return .orange
        case .actions: return .green
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        DecisionCard(
            node: AlgorithmNode(
                id: "rhythm-check",
                title: "Shockable Rhythm?",
                nodeType: .decision,
                critical: true,
                content: "VF/Pulseless VT or PEA/Asystole?",
                connections: ["shock", "cpr"]
            ),
            onSelection: { _ in }
        )
        .frame(width: 350)
        
        EnhancedProtocolCard(
            title: "HIGH-QUALITY CPR INITIATED",
            emoji: "💓",
            sections: [
                CardSection(
                    title: "⚙️ CPR parameters:",
                    items: [
                        "Rate: 100-120/min",
                        "Depth: 2-2.4 inches (5-6 cm)",
                        "Complete recoil between compressions",
                        "Minimize interruptions (<10 seconds)"
                    ]
                ),
                CardSection(
                    title: "🔌 Equipment:",
                    items: [
                        "Attach monitor/defibrillator",
                        "Give oxygen, establish IV/IO access"
                    ]
                )
            ],
            cardType: .actions,
            isActive: true
        )
        .frame(width: 350)
    }
    .padding()
}