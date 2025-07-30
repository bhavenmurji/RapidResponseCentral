import SwiftUI

// MARK: - Medical Flowchart View (SMART DR Style)

struct FlowchartView: View {
    let algorithm: ProtocolAlgorithm
    @Binding var selectedNodeId: String?
    let onNodeSelect: (String) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView([.horizontal, .vertical], showsIndicators: false) {
                ZStack(alignment: .topLeading) {
                    // Connection lines with labels (draw first, behind nodes)
                    FlowchartConnectionsView(
                        algorithm: algorithm,
                        selectedNodeId: selectedNodeId ?? "",
                        containerWidth: geometry.size.width
                    )
                    
                    // Nodes with proper positioning
                    FlowchartNodesView(
                        algorithm: algorithm,
                        selectedNodeId: $selectedNodeId,
                        onNodeSelect: onNodeSelect,
                        containerWidth: geometry.size.width
                    )
                }
                .frame(minWidth: max(300, geometry.size.width - 20), 
                       minHeight: max(400, CGFloat(algorithm.nodes.count) * 100))
                .padding(20)
            }
            .background(Color(.systemBackground))
        }
    }
}

// MARK: - Flowchart Nodes Layout

struct FlowchartNodesView: View {
    let algorithm: ProtocolAlgorithm
    @Binding var selectedNodeId: String?
    let onNodeSelect: (String) -> Void
    let containerWidth: CGFloat
    
    var body: some View {
        ForEach(Array(algorithm.nodes.enumerated()), id: \.element.id) { index, node in
            FlowchartNodeView(
                node: node,
                isSelected: selectedNodeId == node.id,
                onTap: { onNodeSelect(node.id) }
            )
            .position(positionForNode(node, at: index))
        }
    }
    
    private func positionForNode(_ node: AlgorithmNode, at index: Int) -> CGPoint {
        let verticalSpacing: CGFloat = 100
        let centerX = containerWidth / 2
        let startY: CGFloat = 40
        
        // Create a cleaner vertical flow with centered nodes
        var yPosition = startY + CGFloat(index) * verticalSpacing
        var xPosition = centerX
        
        // For decision nodes with branches, offset slightly
        if index > 0 {
            let prevNode = algorithm.nodes[index - 1]
            if prevNode.nodeType == .decision && prevNode.connections.count > 1 {
                // This is likely a branch from a decision
                let connectionIndex = prevNode.connections.firstIndex(of: node.id) ?? 0
                xPosition = centerX + (connectionIndex == 0 ? -80 : 80)
            }
        }
        
        return CGPoint(x: xPosition, y: yPosition)
    }
}

// MARK: - Flowchart Node (SMART DR Style)

struct FlowchartNodeView: View {
    let node: AlgorithmNode
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(node.title)
                .font(.system(size: 12, weight: .medium))
                .multilineTextAlignment(.center)
                .foregroundColor(textColorForNode(node))
                .lineLimit(2)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .frame(minWidth: 100, maxWidth: 180)
                .background(backgroundForNode(node, isSelected: isSelected))
                .overlay(
                    shapeForNode(node)
                        .stroke(strokeColorForNode(node, isSelected: isSelected), lineWidth: 2)
                )
                .clipShape(shapeForNode(node))
        }
        .buttonStyle(.plain)
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.15), value: isSelected)
        .shadow(color: .black.opacity(isSelected ? 0.1 : 0.03), radius: 2, y: 1)
    }
    
    private func shapeForNode(_ node: AlgorithmNode) -> AnyShape {
        switch node.nodeType {
        case .decision:
            return AnyShape(DiamondShape())
        case .endpoint:
            return AnyShape(RoundedRectangle(cornerRadius: 20))
        default:
            return AnyShape(RoundedRectangle(cornerRadius: 6))
        }
    }
    
    private func backgroundForNode(_ node: AlgorithmNode, isSelected: Bool) -> Color {
        if isSelected {
            return Color.blue.opacity(0.08)
        }
        
        switch node.nodeType {
        case .decision:
            return Color(.systemBackground)
        case .assessment:
            return Color(.systemGray6)
        case .intervention, .medication:
            return Color.green.opacity(0.9)
        case .endpoint:
            return Color.orange.opacity(0.9)
        }
    }
    
    private func textColorForNode(_ node: AlgorithmNode) -> Color {
        switch node.nodeType {
        case .decision, .assessment:
            return node.critical ? .red : .primary
        case .intervention, .medication, .endpoint:
            return .white
        }
    }
    
    private func strokeColorForNode(_ node: AlgorithmNode, isSelected: Bool) -> Color {
        if isSelected {
            return .blue
        }
        
        switch node.nodeType {
        case .decision:
            return Color.gray.opacity(0.4)
        case .assessment:
            return Color.gray.opacity(0.3)
        case .intervention, .medication:
            return Color.green.opacity(0.7)
        case .endpoint:
            return Color.orange.opacity(0.7)
        }
    }
}

// MARK: - Diamond Shape for Decision Nodes

struct DiamondShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        path.move(to: CGPoint(x: center.x, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: center.y))
        path.addLine(to: CGPoint(x: center.x, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: center.y))
        path.closeSubpath()
        
        return path
    }
}

// MARK: - Flowchart Connections with Labels

struct FlowchartConnectionsView: View {
    let algorithm: ProtocolAlgorithm
    let selectedNodeId: String
    let containerWidth: CGFloat
    
    var body: some View {
        ForEach(Array(algorithm.nodes.enumerated()), id: \.element.id) { index, node in
            ForEach(Array(node.connections.enumerated()), id: \.offset) { connectionIndex, connectionId in
                if let targetIndex = algorithm.nodes.firstIndex(where: { $0.id == connectionId }) {
                    let targetNode = algorithm.nodes[targetIndex]
                    FlowchartArrowWithLabel(
                        from: positionForNode(node, at: index),
                        to: positionForNode(targetNode, at: targetIndex),
                        label: labelForConnection(from: node, to: targetNode, index: connectionIndex),
                        isHighlighted: selectedNodeId == node.id || selectedNodeId == connectionId,
                        fromNodeType: node.nodeType,
                        toNodeType: targetNode.nodeType
                    )
                }
            }
        }
    }
    
    private func positionForNode(_ node: AlgorithmNode, at index: Int) -> CGPoint {
        let verticalSpacing: CGFloat = 100
        let centerX = containerWidth / 2
        let startY: CGFloat = 40
        
        var yPosition = startY + CGFloat(index) * verticalSpacing
        var xPosition = centerX
        
        if index > 0 {
            let prevNode = algorithm.nodes[index - 1]
            if prevNode.nodeType == .decision && prevNode.connections.count > 1 {
                let connectionIndex = prevNode.connections.firstIndex(of: node.id) ?? 0
                xPosition = centerX + (connectionIndex == 0 ? -80 : 80)
            }
        }
        
        return CGPoint(x: xPosition, y: yPosition)
    }
    
    private func labelForConnection(from: AlgorithmNode, to: AlgorithmNode, index: Int) -> String {
        if from.nodeType == .decision {
            return index == 0 ? "Yes" : "No"
        }
        return ""
    }
}

// MARK: - Flowchart Arrow with Label

struct FlowchartArrowWithLabel: View {
    let from: CGPoint
    let to: CGPoint
    let label: String
    let isHighlighted: Bool
    let fromNodeType: NodeType
    let toNodeType: NodeType
    
    var body: some View {
        ZStack {
            // Arrow line
            Path { path in
                let adjustedFrom = adjustedStartPoint(from: from, to: to, nodeType: fromNodeType)
                let adjustedTo = adjustedEndPoint(from: from, to: to, nodeType: toNodeType)
                
                path.move(to: adjustedFrom)
                path.addLine(to: adjustedTo)
            }
            .stroke(
                isHighlighted ? Color.blue : Color.gray.opacity(0.5),
                style: StrokeStyle(
                    lineWidth: isHighlighted ? 2 : 1.5,
                    lineCap: .round
                )
            )
            
            // Arrow head
            Path { path in
                let adjustedFrom = adjustedStartPoint(from: from, to: to, nodeType: fromNodeType)
                let adjustedTo = adjustedEndPoint(from: from, to: to, nodeType: toNodeType)
                
                let angle = atan2(adjustedTo.y - adjustedFrom.y, adjustedTo.x - adjustedFrom.x)
                let arrowLength: CGFloat = 8
                let arrowAngle: CGFloat = .pi / 6
                
                let arrowStart = CGPoint(
                    x: adjustedTo.x - arrowLength * cos(angle - arrowAngle),
                    y: adjustedTo.y - arrowLength * sin(angle - arrowAngle)
                )
                let arrowEnd = CGPoint(
                    x: adjustedTo.x - arrowLength * cos(angle + arrowAngle),
                    y: adjustedTo.y - arrowLength * sin(angle + arrowAngle)
                )
                
                path.move(to: arrowStart)
                path.addLine(to: adjustedTo)
                path.addLine(to: arrowEnd)
            }
            .stroke(
                isHighlighted ? Color.blue : Color.gray.opacity(0.5),
                style: StrokeStyle(
                    lineWidth: isHighlighted ? 2 : 1.5,
                    lineCap: .round,
                    lineJoin: .round
                )
            )
            
            // Label (Yes/No)
            if !label.isEmpty {
                Text(label)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(label == "Yes" ? .green : .red)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 1)
                    .background(Color(.systemBackground))
                    .position(labelPosition())
            }
        }
    }
    
    private func adjustedStartPoint(from: CGPoint, to: CGPoint, nodeType: NodeType) -> CGPoint {
        let nodeRadius: CGFloat = nodeType == .decision ? 30 : 25
        let angle = atan2(to.y - from.y, to.x - from.x)
        
        return CGPoint(
            x: from.x + nodeRadius * cos(angle),
            y: from.y + nodeRadius * sin(angle)
        )
    }
    
    private func adjustedEndPoint(from: CGPoint, to: CGPoint, nodeType: NodeType) -> CGPoint {
        let nodeRadius: CGFloat = nodeType == .decision ? 30 : 25
        let angle = atan2(to.y - from.y, to.x - from.x)
        
        return CGPoint(
            x: to.x - nodeRadius * cos(angle),
            y: to.y - nodeRadius * sin(angle)
        )
    }
    
    private func labelPosition() -> CGPoint {
        let midX = (from.x + to.x) / 2
        let midY = (from.y + to.y) / 2
        
        // Offset label slightly to avoid overlapping with arrow
        let angle = atan2(to.y - from.y, to.x - from.x)
        let offset: CGFloat = 20
        
        return CGPoint(
            x: midX - offset * sin(angle),
            y: midY + offset * cos(angle)
        )
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