import SwiftUI

// MARK: - Dynamic Protocol Card View (No Expansion, Auto-Updates)
public struct DynamicProtocolCardView: View {
    let card: ProtocolCard
    let isActive: Bool
    
    public init(card: ProtocolCard, isActive: Bool = false) {
        self.card = card
        self.isActive = isActive
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Ultra-compact card header
            HStack(spacing: 4) {
                // Type icon
                Image(systemName: cardTypeIcon)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(cardTypeColor)
                
                Text(card.title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                
                Spacer()
                
                if isActive {
                    Text("ACTIVE")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(cardTypeColor)
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(cardTypeColor.opacity(0.15))
            
            // Ultra-compact card content
            VStack(alignment: .leading, spacing: 4) {
                ForEach(card.sections, id: \.id) { section in
                    VStack(alignment: .leading, spacing: 2) {
                        if !section.title.isEmpty {
                            Text(section.title)
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(cardTypeColor)
                                .padding(.bottom, 2)
                        }
                        
                        ForEach(section.items, id: \.self) { item in
                            HStack(alignment: .top, spacing: 4) {
                                // Bullet point
                                Circle()
                                    .fill(cardTypeColor.opacity(0.7))
                                    .frame(width: 3, height: 3)
                                    .offset(y: 4)
                                
                                Text(item)
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundColor(.primary.opacity(0.95))
                                    .fixedSize(horizontal: false, vertical: true)
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.8)
                            }
                        }
                    }
                }
            }
            .padding(6)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity) // Ensure card uses full width
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
                    isActive ? cardTypeColor : cardTypeColor.opacity(0.2),
                    lineWidth: isActive ? 2 : 0.5
                )
        )
        .animation(.easeInOut(duration: 0.2), value: isActive)
    }
    
    private var cardTypeColor: Color {
        switch card.type {
        case .dynamic: return .blue
        case .assessment: return .orange
        case .actions: return .green
        }
    }
    
    private var cardTypeIcon: String {
        switch card.type {
        case .dynamic: return "arrow.triangle.2.circlepath"
        case .assessment: return "stethoscope"
        case .actions: return "cross.case"
        }
    }
}

// MARK: - Node-Specific Card Filter
public struct NodeSpecificCards: View {
    let allCards: [ProtocolCard]
    let selectedNode: AlgorithmNode?
    let currentNodeIndex: Int
    let totalNodes: Int
    let onNodeSelect: ((String) -> Void)?
    let onPrevious: (() -> Void)?
    let onNext: (() -> Void)?
    
    public init(
        allCards: [ProtocolCard], 
        selectedNode: AlgorithmNode?, 
        currentNodeIndex: Int = 0,
        totalNodes: Int = 0,
        onNodeSelect: ((String) -> Void)? = nil,
        onPrevious: (() -> Void)? = nil,
        onNext: (() -> Void)? = nil
    ) {
        self.allCards = allCards
        self.selectedNode = selectedNode
        self.currentNodeIndex = currentNodeIndex
        self.totalNodes = totalNodes
        self.onNodeSelect = onNodeSelect
        self.onPrevious = onPrevious
        self.onNext = onNext
    }
    
    public var body: some View {
        if let node = selectedNode {
            VStack(spacing: 6) {
                // Show special checklist for Code Blue first node
                if node.id == "code_blue_activated" {
                    CodeBlueInitialChecklist(
                        onComplete: {
                            // Navigate to next node when checklist complete
                            if let firstConnection = node.connections.first {
                                onNodeSelect?(firstConnection)
                            }
                        }
                    )
                    .padding(.horizontal, 12)
                }
                // Show DecisionCard for decision nodes
                else if node.nodeType == .decision && !node.connections.isEmpty {
                    DecisionCard(
                        node: node,
                        onSelection: { connectionId in
                            onNodeSelect?(connectionId)
                        }
                    )
                    .padding(.horizontal, 12)
                }
                
                // Show relevant protocol cards - no scrolling, fit to screen
                let relevantCards = getRelevantCards()
                if !relevantCards.isEmpty {
                    VStack(spacing: 8) {
                        ForEach(relevantCards.prefix(3), id: \.id) { card in
                            NavigableProtocolCardView(
                                card: card,
                                isActive: isCardActiveForNode(card: card),
                                currentNodeIndex: currentNodeIndex,
                                totalNodes: totalNodes,
                                onPrevious: onPrevious,
                                onNext: onNext
                            )
                            .frame(maxWidth: .infinity) // Each card uses full width
                        }
                    }
                    .frame(maxWidth: .infinity) // Stack uses full width
                    .padding(.horizontal, 12)
                }
                
                Spacer()
            }
        } else {
                // Show placeholder when no node selected
                VStack(spacing: 8) {
                    Image(systemName: "hand.tap")
                        .font(.system(size: 24))
                        .foregroundColor(.secondary)
                    Text("Select a node in the flowchart")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                    Text("to view relevant information")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.vertical, 40)
            }
        }
    
    private func getRelevantCards() -> [ProtocolCard] {
        guard let node = selectedNode else {
            return [] // No cards when no node selected
        }
        
        // Filter cards based on node type
        switch node.nodeType {
        case .assessment:
            // Show assessment cards
            return allCards.filter { $0.type == .assessment }
            
        case .intervention, .medication, .action:
            // Show action cards
            return allCards.filter { $0.type == .actions }
            
        case .decision:
            // Show dynamic cards for decisions
            return allCards.filter { $0.type == .dynamic }
            
        case .endpoint:
            // Show all cards for summary at endpoint
            return allCards
        }
    }
    
    private func isCardActiveForNode(card: ProtocolCard) -> Bool {
        guard let node = selectedNode else { return false }
        
        // Highlight cards that directly relate to the current node
        // This can be expanded with more sophisticated matching logic
        return card.type == .dynamic && node.nodeType == .decision
    }
    
    private func getEmojiForCard(_ card: ProtocolCard) -> String {
        // Map card types and titles to appropriate emojis
        switch card.type {
        case .assessment:
            return "📊"
        case .actions:
            if card.title.lowercased().contains("cpr") {
                return "💓"
            } else if card.title.lowercased().contains("medication") {
                return "💉"
            } else if card.title.lowercased().contains("equipment") {
                return "🔌"
            }
            return "🚀"
        case .dynamic:
            if card.title.lowercased().contains("critical") {
                return "🚨"
            }
            return "⚙️"
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        DynamicProtocolCardView(
            card: ProtocolCard(
                id: "test1",
                type: .assessment,
                title: "Initial Assessment",
                sections: [
                    CardSection(
                        title: "Primary Survey",
                        items: ["Airway", "Breathing", "Circulation", "Disability"]
                    ),
                    CardSection(
                        title: "Vital Signs",
                        items: ["HR: Target <100", "BP: Target >90/60", "SpO2: Target >94%"]
                    )
                ]
            ),
            isActive: true
        )
        .frame(width: 200)
        
        DynamicProtocolCardView(
            card: ProtocolCard(
                id: "test2",
                type: .actions,
                title: "Immediate Actions",
                sections: [
                    CardSection(
                        title: "Medications",
                        items: ["Epinephrine 1mg IV/IO", "Amiodarone 300mg"]
                    )
                ]
            ),
            isActive: false
        )
        .frame(width: 200)
    }
    .padding()
}