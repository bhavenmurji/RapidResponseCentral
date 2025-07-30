import SwiftUI

// MARK: - Medical Flowchart View (SMART DR Style)

struct FlowchartView: View {
    let algorithm: ProtocolAlgorithm
    @Binding var selectedNodeId: String?
    let onNodeSelect: (String) -> Void
    
    var body: some View {
        ScrollView([.horizontal, .vertical], showsIndicators: true) {
            ZStack {
                // Connection lines (draw first, behind nodes)
                FlowchartConnectionsView(
                    algorithm: algorithm,
                    selectedNodeId: selectedNodeId ?? ""
                )
                
                // Nodes with proper positioning
                FlowchartNodesView(
                    algorithm: algorithm,
                    selectedNodeId: $selectedNodeId,
                    onNodeSelect: onNodeSelect
                )
            }
            .frame(minWidth: 400, minHeight: 600)
            .padding(20)
        }
        .background(Color(.systemGroupedBackground))
    }
}

// MARK: - Flowchart Nodes Layout

struct FlowchartNodesView: View {
    let algorithm: ProtocolAlgorithm
    @Binding var selectedNodeId: String?
    let onNodeSelect: (String) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(Array(algorithm.nodes.enumerated()), id: \.element.id) { index, node in
                FlowchartNodeView(
                    node: node,
                    isSelected: selectedNodeId == node.id,
                    onTap: { onNodeSelect(node.id) }
                )
                .position(positionForNode(at: index, in: geometry))
            }
        }
    }
    
    private func positionForNode(at index: Int, in geometry: GeometryProxy) -> CGPoint {
        let nodeWidth: CGFloat = 140
        let nodeHeight: CGFloat = 80
        let horizontalSpacing: CGFloat = 180
        let verticalSpacing: CGFloat = 120
        
        // Create a flowing layout similar to SMART DR
        let nodesPerRow = 2
        let row = index / nodesPerRow
        let col = index % nodesPerRow
        
        let x = (geometry.size.width / 3) + CGFloat(col) * horizontalSpacing
        let y = 60 + CGFloat(row) * verticalSpacing
        
        return CGPoint(x: x, y: y)
    }
}

// MARK: - Flowchart Node (SMART DR Style)

struct FlowchartNodeView: View {
    let node: AlgorithmNode
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 6) {
                // Node content
                Text(node.title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(textColorForNode(node))
                    .lineLimit(2)
                
                if !node.content.isEmpty {
                    Text(node.content)
                        .font(.caption2)
                        .multilineTextAlignment(.center)
                        .foregroundColor(textColorForNode(node))
                        .lineLimit(3)
                        .padding(.horizontal, 4)
                }
            }
            .frame(width: 130, height: 70)
            .padding(8)
            .background(backgroundForNode(node, isSelected: isSelected))
            .overlay(
                RoundedRectangle(cornerRadius: nodeCornerRadius(for: node))
                    .stroke(strokeColorForNode(node, isSelected: isSelected), lineWidth: isSelected ? 3 : 2)
            )
            .clipShape(RoundedRectangle(cornerRadius: nodeCornerRadius(for: node)))
        }
        .buttonStyle(.plain)
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
    
    private func backgroundForNode(_ node: AlgorithmNode, isSelected: Bool) -> Color {
        if isSelected {
            return Color.blue.opacity(0.1)
        }
        
        switch node.nodeType {
        case .decision:
            return Color(.systemBackground) // White/clear for questions
        case .assessment:
            return Color(.systemBackground) // White/clear for assessments
        case .intervention, .medication:
            return Color.green.opacity(0.8) // Green fill for actions (like SMART DR)
        case .endpoint:
            return Color.green.opacity(0.9) // Darker green for endpoints
        }
    }
    
    private func textColorForNode(_ node: AlgorithmNode) -> Color {
        switch node.nodeType {
        case .decision, .assessment:
            return node.critical ? .red : .primary
        case .intervention, .medication, .endpoint:
            return .white // White text on green background
        }
    }
    
    private func strokeColorForNode(_ node: AlgorithmNode, isSelected: Bool) -> Color {
        if isSelected {
            return .blue
        }
        
        switch node.nodeType {
        case .decision, .assessment:
            return .green // Green outline like SMART DR
        case .intervention, .medication, .endpoint:
            return .green.opacity(0.8)
        }
    }
    
    private func nodeCornerRadius(for node: AlgorithmNode) -> CGFloat {
        switch node.nodeType {
        case .decision:
            return 25 // More rounded for decisions
        case .assessment:
            return 15 // Moderately rounded
        case .intervention, .medication:
            return 12 // Slightly rounded for actions
        case .endpoint:
            return 20 // Rounded for endpoints
        }
    }
}

// MARK: - Flowchart Connections (Arrows)

struct FlowchartConnectionsView: View {
    let algorithm: ProtocolAlgorithm
    let selectedNodeId: String
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(Array(algorithm.nodes.enumerated()), id: \.element.id) { index, node in
                ForEach(node.connections, id: \.self) { connectionId in
                    if let targetIndex = algorithm.nodes.firstIndex(where: { $0.id == connectionId }) {
                        FlowchartArrow(
                            from: positionForNode(at: index, in: geometry),
                            to: positionForNode(at: targetIndex, in: geometry),
                            isHighlighted: selectedNodeId == node.id || selectedNodeId == connectionId
                        )
                    }
                }
            }
        }
    }
    
    private func positionForNode(at index: Int, in geometry: GeometryProxy) -> CGPoint {
        let horizontalSpacing: CGFloat = 180
        let verticalSpacing: CGFloat = 120
        
        let nodesPerRow = 2
        let row = index / nodesPerRow
        let col = index % nodesPerRow
        
        let x = (geometry.size.width / 3) + CGFloat(col) * horizontalSpacing
        let y = 60 + CGFloat(row) * verticalSpacing
        
        return CGPoint(x: x, y: y)
    }
}

// MARK: - Flowchart Arrow Component

struct FlowchartArrow: View {
    let from: CGPoint
    let to: CGPoint
    let isHighlighted: Bool
    
    var body: some View {
        Path { path in
            // Simple straight line with arrow
            path.move(to: from)
            path.addLine(to: to)
        }
        .stroke(
            isHighlighted ? Color.blue : Color.green,
            style: StrokeStyle(
                lineWidth: isHighlighted ? 3 : 2,
                lineCap: .round
            )
        )
        
        // Arrow head
        Path { path in
            let angle = atan2(to.y - from.y, to.x - from.x)
            let arrowLength: CGFloat = 8
            let arrowAngle: CGFloat = .pi / 6
            
            let arrowStart = CGPoint(
                x: to.x - arrowLength * cos(angle - arrowAngle),
                y: to.y - arrowLength * sin(angle - arrowAngle)
            )
            let arrowEnd = CGPoint(
                x: to.x - arrowLength * cos(angle + arrowAngle),
                y: to.y - arrowLength * sin(angle + arrowAngle)
            )
            
            path.move(to: arrowStart)
            path.addLine(to: to)
            path.addLine(to: arrowEnd)
        }
        .stroke(
            isHighlighted ? Color.blue : Color.green,
            style: StrokeStyle(
                lineWidth: isHighlighted ? 3 : 2,
                lineCap: .round,
                lineJoin: .round
            )
        )
    }
}

// MARK: - Decision Branch Indicators (Thumbs Up/Down)

struct DecisionBranchIndicator: View {
    let isPositiveBranch: Bool
    let position: CGPoint
    
    var body: some View {
        Image(systemName: isPositiveBranch ? "hand.thumbsup.fill" : "hand.thumbsdown.fill")
            .font(.caption2)
            .foregroundColor(isPositiveBranch ? .green : .red)
            .background(
                Circle()
                    .fill(Color(.systemBackground))
                    .frame(width: 20, height: 20)
            )
            .position(position)
    }
}

// MARK: - Preview

#Preview {
    FlowchartView(
        algorithm: ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "start",
                title: "CT Head",
                nodeType: .assessment,
                critical: false,
                content: "Obtain CT scan",
                connections: ["decision1"]
            ),
            AlgorithmNode(
                id: "decision1",
                title: "Haemorrhage?",
                nodeType: .decision,
                critical: true,
                content: "Evidence of bleeding on CT",
                connections: ["action1", "action2"]
            ),
            AlgorithmNode(
                id: "action1",
                title: "Contact Neurosurgeons",
                nodeType: .intervention,
                critical: true,
                content: "Immediate neurosurgical consultation",
                connections: []
            ),
            AlgorithmNode(
                id: "action2",
                title: "Aspirin 300mg",
                nodeType: .medication,
                critical: false,
                content: "PO/NG/PR STAT",
                connections: ["decision2"]
            ),
            AlgorithmNode(
                id: "decision2",
                title: "< 4.5 hours since onset?",
                nodeType: .decision,
                critical: true,
                content: "Time window for thrombolysis",
                connections: ["thrombolysis", "maintenance"]
            ),
            AlgorithmNode(
                id: "thrombolysis",
                title: "Thrombolysis",
                nodeType: .intervention,
                critical: true,
                content: "Administer thrombolytic therapy",
                connections: []
            )
        ]),
        selectedNodeId: .constant("decision1"),
        onNodeSelect: { _ in }
    )
    .frame(height: 500)
}