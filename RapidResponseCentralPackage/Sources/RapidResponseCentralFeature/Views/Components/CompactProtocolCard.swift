import SwiftUI

// MARK: - Local Types for CompactProtocolCard
public enum ProtocolCalculatorType: String, CaseIterable {
    case medicationDosing = "Medication Dosing"
    case cardiacRisk = "Cardiac Risk"
    case respiratoryScore = "Respiratory Score"
    case vitalSigns = "Vital Signs"
    case fluidBalance = "Fluid Balance"
    case glasgow = "Glasgow Coma"
}

// MARK: - Compact Protocol Card - Ultra-Optimized for 45% Panel, Zero Scrolling
// Maximum information density, dynamic content based on selected node

public struct CompactProtocolCard: View {
    let card: ProtocolCard
    let selectedNode: AlgorithmNode?
    let algorithm: ProtocolAlgorithm
    let onNodeSelect: (String) -> Void
    let onCalculatorRequest: (ProtocolCalculatorType) -> Void
    let onNavigateBack: () -> Void
    
    @State private var showingCalculator = false
    
    public init(
        card: ProtocolCard,
        selectedNode: AlgorithmNode?,
        algorithm: ProtocolAlgorithm,
        onNodeSelect: @escaping (String) -> Void,
        onCalculatorRequest: @escaping (ProtocolCalculatorType) -> Void = { _ in },
        onNavigateBack: @escaping () -> Void = { }
    ) {
        self.card = card
        self.selectedNode = selectedNode
        self.algorithm = algorithm
        self.onNodeSelect = onNodeSelect
        self.onCalculatorRequest = onCalculatorRequest
        self.onNavigateBack = onNavigateBack
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Ultra-compact header with navigation
            compactHeader
            
            // Dynamic content based on selected node - fits remaining space
            ScrollView {
                if let selectedNode {
                    dynamicNodeContent(selectedNode)
                } else {
                    staticCardContent
                }
            }
            .scrollIndicators(.hidden)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(selectedNode?.critical == true ? Color.red.opacity(0.3) : Color(.systemGray5), lineWidth: 1)
        )
        .clipped()
    }
    
    private var compactHeader: some View {
        HStack(spacing: 8) {
            // Navigation back button
            if selectedNode != nil {
                Button(action: onNavigateBack) {
                    Image(systemName: "chevron.left.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.blue)
                }
            }
            
            // Dynamic title based on context
            if let node = selectedNode {
                HStack(spacing: 6) {
                    Image(systemName: nodeTypeIcon(node.nodeType))
                        .font(.system(size: 14))
                        .foregroundColor(nodeTypeColor(node.nodeType))
                    
                    Text(node.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    if node.critical {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.red)
                    }
                }
            } else {
                HStack(spacing: 6) {
                    BoxiconView(iconName: boxiconForCardType(card.type), size: 14)
                        .font(.system(size: 14))
                        .foregroundColor(colorForCardType(card.type))
                    
                    Text(card.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            // Action buttons
            actionButtons
        }
        .frame(height: 24)
    }
    
    private var actionButtons: some View {
        HStack(spacing: 6) {
            // Calculator button if relevant
            if let calculatorType = getRelevantCalculator() {
                Button(action: { onCalculatorRequest(calculatorType) }) {
                    Image(systemName: "function")
                        .font(.system(size: 14))
                        .foregroundColor(.green)
                }
            }
            
            // Next step indicator
            if let node = selectedNode, !node.connections.isEmpty {
                Text("\(node.connections.count)")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 16, height: 16)
                    .background(
                        Circle()
                            .fill(Color.blue)
                    )
            }
        }
    }
    
    private func dynamicNodeContent(_ node: AlgorithmNode) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            // Current question/content
            if !node.content.isEmpty {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Current Question:")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                    
                    Text(node.content)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.primary)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(.tertiarySystemBackground))
                )
            }
            
            // Next options
            if !node.connections.isEmpty {
                nextOptionsSection(for: node)
            }
            
            // Relevant card content
            relevantCardContent(for: node)
        }
    }
    
    private var staticCardContent: some View {
        VStack(alignment: .leading, spacing: 6) {
            ForEach(card.sections.prefix(2), id: \.id) { section in
                compactCardSection(section)
            }
        }
    }
    
    private func nextOptionsSection(for node: AlgorithmNode) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("Next Steps:")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                
                Spacer()
                
                if node.nodeType == .decision {
                    Text("DECISION")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 1)
                        .background(
                            Capsule()
                                .fill(Color.orange)
                        )
                }
            }
            
            let nextNodes = node.connections.compactMap { id in
                algorithm.nodes.first { $0.id == id }
            }
            
            ForEach(Array(nextNodes.prefix(2).enumerated()), id: \.element.id) { index, nextNode in
                Button(action: { onNodeSelect(nextNode.id) }) {
                    HStack(spacing: 8) {
                        Text("\(index + 1)")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 16, height: 16)
                            .background(
                                Circle()
                                    .fill(nextNode.critical ? Color.red : Color.blue)
                            )
                        
                        VStack(alignment: .leading, spacing: 1) {
                            Text(nextNode.title)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.primary)
                                .lineLimit(1)
                                .multilineTextAlignment(.leading)
                            
                            if !nextNode.content.isEmpty {
                                Text(nextNode.content)
                                    .font(.system(size: 10))
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        
                        Spacer()
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                    .padding(.horizontal, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color(.secondarySystemBackground))
                    )
                }
                .buttonStyle(.plain)
            }
            
            if nextNodes.count > 2 {
                Text("+ \(nextNodes.count - 2) more options")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                    .italic()
            }
        }
    }
    
    private func compactCardSection(_ section: CardSection) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            if !section.title.isEmpty {
                Text(section.title)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.primary)
            }
            
            ForEach(section.items.prefix(3), id: \.self) { item in
                HStack(alignment: .top, spacing: 4) {
                    Text("•")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(colorForCardType(card.type))
                    
                    Text(item)
                        .font(.system(size: 11))
                        .foregroundColor(.primary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            
            if section.items.count > 3 {
                Text("+ \(section.items.count - 3) more")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                    .italic()
                    .padding(.leading, 8)
            }
        }
    }
    
    private func relevantCardContent(for node: AlgorithmNode) -> some View {
        let relevantSection = getRelevantSection(for: node)
        
        return Group {
            if let section = relevantSection {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Relevant Info:")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                    
                    compactCardSection(section)
                }
                .padding(6)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(colorForCardType(card.type).opacity(0.05))
                )
            }
        }
    }
    
    // MARK: - Helper Functions
    
    private func getRelevantSection(for node: AlgorithmNode) -> CardSection? {
        // Return the most relevant section based on node type
        switch node.nodeType {
        case .medication:
            return card.sections.first { $0.title.lowercased().contains("medic") || $0.title.lowercased().contains("drug") }
        case .assessment:
            return card.sections.first { $0.title.lowercased().contains("assess") || $0.title.lowercased().contains("check") }
        case .intervention, .action:
            return card.sections.first { $0.title.lowercased().contains("action") || $0.title.lowercased().contains("step") }
        default:
            return card.sections.first
        }
    }
    
    private func getRelevantCalculator() -> ProtocolCalculatorType? {
        guard let node = selectedNode else { return nil }
        
        switch node.nodeType {
        case .medication:
            return .medicationDosing
        case .assessment:
            if node.title.lowercased().contains("cardiac") {
                return .cardiacRisk
            } else if node.title.lowercased().contains("respiratory") {
                return .respiratoryScore
            }
            return .vitalSigns
        default:
            return nil
        }
    }
    
    // MARK: - Helper Functions
    
    private func boxiconForCardType(_ type: CardType) -> String {
        switch type {
        case .dynamic:
            return "bx-refresh"
        case .assessment:
            return "bx-search"
        case .actions:
            return "bx-play"
        }
    }
    
    private func colorForCardType(_ type: CardType) -> Color {
        switch type {
        case .dynamic:
            return .blue
        case .assessment:
            return .orange
        case .actions:
            return .green
        }
    }
    
    private func cardTypeDescription(_ type: CardType) -> String {
        switch type {
        case .dynamic:
            return "Context-aware"
        case .assessment:
            return "Assessment"
        case .actions:
            return "Actions"
        }
    }
    
    private func nodeTypeIcon(_ type: NodeType) -> String {
        switch type {
        case .decision:
            return "arrow.triangle.branch"
        case .assessment:
            return "stethoscope"
        case .intervention:
            return "cross.case"
        case .medication:
            return "pills"
        case .endpoint:
            return "checkmark.circle"
        case .action:
            return "hand.raised"
        }
    }
    
    private func nodeTypeColor(_ type: NodeType) -> Color {
        switch type {
        case .decision:
            return .blue
        case .assessment:
            return .orange
        case .intervention, .action:
            return .green
        case .medication:
            return .purple
        case .endpoint:
            return .gray
        }
    }
}

// MARK: - Preview

#Preview {
    CompactProtocolCard(
        card: ProtocolCard(
            id: "dynamic",
            type: .dynamic,
            title: "Current Step",
            sections: [
                CardSection(
                    title: "Immediate Actions",
                    items: [
                        "Check pulse and breathing",
                        "Call for help immediately",
                        "Get AED if available",
                        "Position patient on firm surface"
                    ]
                ),
                CardSection(
                    title: "Medications",
                    items: [
                        "Epinephrine 1mg IV/IO every 3-5 minutes",
                        "Amiodarone 300mg IV/IO for VF/VT"
                    ]
                )
            ]
        ),
        selectedNode: AlgorithmNode(
            id: "test",
            title: "CPR Decision Point",
            nodeType: .decision,
            critical: true,
            content: "Is patient showing signs of ROSC?",
            connections: ["rosc", "continue"]
        ),
        algorithm: ProtocolAlgorithm(
            nodes: [
                AlgorithmNode(
                    id: "rosc",
                    title: "Post-ROSC Care",
                    nodeType: .intervention,
                    critical: false,
                    content: "Begin post-resuscitation care",
                    connections: []
                ),
                AlgorithmNode(
                    id: "continue",
                    title: "Continue CPR",
                    nodeType: .intervention,
                    critical: true,
                    content: "Resume chest compressions",
                    connections: []
                )
            ]
        ),
        onNodeSelect: { _ in },
        onCalculatorRequest: { _ in },
        onNavigateBack: { }
    )
    .frame(height: 300)
    .padding()
    .background(Color(.systemBackground))
}