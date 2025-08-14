import SwiftUI

// MARK: - Enhanced Dynamic Card with Decision Support
struct EnhancedDynamicCard: View {
    let card: ProtocolCard
    let selectedNode: AlgorithmNode?
    let algorithm: ProtocolAlgorithm
    let onNodeSelect: (String) -> Void
    
    @State private var expandedSections: Set<UUID> = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Compact Header
            cardHeader
            
            // Current Node Context
            if let node = selectedNode {
                currentNodeSection(node)
            }
            
            // Decision Branches (if applicable)
            if let node = selectedNode, node.nodeType == .decision {
                decisionBranchesSection(node)
            }
            
            // Additional Card Sections (collapsible)
            ForEach(card.sections) { section in
                collapsibleSection(section)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.secondarySystemBackground))
        )
    }
    
    private var cardHeader: some View {
        HStack {
            Image(systemName: iconForCardType(card.type))
                .font(.system(size: 14))
                .foregroundColor(colorForCardType(card.type))
            
            Text(card.title)
                .font(.system(size: 14, weight: .semibold))
            
            Spacer()
            
            if let node = selectedNode {
                if node.critical {
                    Label("Critical", systemImage: "exclamationmark.triangle.fill")
                        .font(.caption2)
                        .foregroundColor(.red)
                        .labelStyle(.iconOnly)
                }
            }
        }
    }
    
    private func currentNodeSection(_ node: AlgorithmNode) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            // Node Title and Type
            HStack {
                nodeTypeIcon(node.nodeType)
                    .font(.system(size: 12))
                    .foregroundColor(nodeTypeColor(node.nodeType))
                
                Text(node.title)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            // Node Content
            if !node.content.isEmpty {
                Text(node.content)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.leading, 20)
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(UIColor.tertiarySystemBackground))
        )
    }
    
    private func decisionBranchesSection(_ node: AlgorithmNode) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("DECISION REQUIRED")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.orange)
            
            // Get connected nodes for branches
            let connectedNodes = node.connections.compactMap { connectionId in
                algorithm.nodes.first { $0.id == connectionId }
            }
            
            if !connectedNodes.isEmpty {
                ForEach(connectedNodes) { nextNode in
                    Button(action: {
                        onNodeSelect(nextNode.id)
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.system(size: 14))
                                .foregroundColor(nextNode.critical ? .red : .blue)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(nextNode.title)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.primary)
                                
                                if !nextNode.content.isEmpty {
                                    Text(nextNode.content)
                                        .font(.system(size: 10))
                                        .foregroundColor(.secondary)
                                        .lineLimit(2)
                                }
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 10))
                                .foregroundColor(.secondary)
                        }
                        .padding(6)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(nextNode.critical ? Color.red.opacity(0.5) : Color.blue.opacity(0.3), lineWidth: 1)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.orange.opacity(0.05))
        )
    }
    
    private func collapsibleSection(_ section: CardSection) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    if expandedSections.contains(section.id) {
                        expandedSections.remove(section.id)
                    } else {
                        expandedSections.insert(section.id)
                    }
                }
            }) {
                HStack {
                    Text(section.title)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Image(systemName: expandedSections.contains(section.id) ? "chevron.up" : "chevron.down")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            if expandedSections.contains(section.id) {
                VStack(alignment: .leading, spacing: 3) {
                    ForEach(section.items, id: \.self) { item in
                        HStack(alignment: .top, spacing: 4) {
                            Text("•")
                                .font(.system(size: 10))
                                .foregroundColor(.secondary)
                            Text(item)
                                .font(.system(size: 11))
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .padding(.leading, 8)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(.vertical, 4)
    }
    
    private func iconForCardType(_ type: CardType) -> String {
        switch type {
        case .dynamic:
            return "arrow.triangle.2.circlepath"
        case .assessment:
            return "stethoscope"
        case .actions:
            return "cross.case.fill"
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
    
    private func nodeTypeIcon(_ type: NodeType) -> Image {
        switch type {
        case .assessment:
            return Image(systemName: "stethoscope")
        case .decision:
            return Image(systemName: "arrow.triangle.branch")
        case .intervention:
            return Image(systemName: "cross.case")
        case .medication:
            return Image(systemName: "pills")
        case .endpoint:
            return Image(systemName: "checkmark.circle")
        case .action:
            return Image(systemName: "hand.tap")
        }
    }
    
    private func nodeTypeColor(_ type: NodeType) -> Color {
        switch type {
        case .assessment:
            return .orange
        case .decision:
            return .purple
        case .intervention:
            return .blue
        case .medication:
            return .green
        case .endpoint:
            return .gray
        case .action:
            return .indigo
        }
    }
}

// MARK: - Compact Flowchart View
// Note: Moved to separate file CompactFlowchartView.swift
/*
struct CompactFlowchartView: View {
    let algorithm: ProtocolAlgorithm
    @Binding var selectedNodeId: String?
    let onNodeSelect: (String) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(algorithm.nodes) { node in
                    CompactNodeView(
                        node: node,
                        isSelected: selectedNodeId == node.id,
                        hasConnections: !node.connections.isEmpty
                    ) {
                        onNodeSelect(node.id)
                    }
                    
                    if !node.connections.isEmpty {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 12)
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(UIColor.tertiarySystemBackground))
        )
    }
}
*/

// Compact flowchart components moved to separate files for better organization