import SwiftUI

// MARK: - Enhanced Flowchart View with Zoom
public struct FlowchartView: View {
    let algorithm: ProtocolAlgorithm
    @Binding var selectedNodeId: String?
    let onNodeSelect: (String) -> Void
    
    // Zoom and pan state
    @State private var zoomScale: CGFloat = 1.0
    @State private var panOffset: CGSize = .zero
    @State private var lastPanValue: CGSize = .zero
    
    // Zoom limits
    private let minZoom: CGFloat = 0.5
    private let maxZoom: CGFloat = 3.0
    
    public init(
        algorithm: ProtocolAlgorithm,
        selectedNodeId: Binding<String?>,
        onNodeSelect: @escaping (String) -> Void
    ) {
        self.algorithm = algorithm
        self._selectedNodeId = selectedNodeId
        self.onNodeSelect = onNodeSelect
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                Color(red: 0.98, green: 0.98, blue: 1.0)
                    .ignoresSafeArea()
                
                // Scrollable and zoomable content
                ScrollView([.horizontal, .vertical], showsIndicators: false) {
                    flowchartContent
                        .scaleEffect(zoomScale)
                        .offset(panOffset)
                        .frame(
                            minWidth: max(geometry.size.width, calculateContentWidth() * zoomScale),
                            minHeight: max(geometry.size.height, calculateContentHeight() * zoomScale)
                        )
                }
                .clipped()
                .simultaneousGesture(panGesture)
                .simultaneousGesture(magnifyGesture)
                
                // Zoom controls overlay
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        zoomControlsOverlay
                            .padding(.trailing, 16)
                            .padding(.bottom, 16)
                    }
                }
            }
        }
        .onAppear {
            // Center on first node if available
            centerOnSelectedNode()
        }
        .onChange(of: selectedNodeId) { _, _ in
            centerOnSelectedNode()
        }
    }
    
    // MARK: - Flowchart Content
    private var flowchartContent: some View {
        LazyVStack(alignment: .leading, spacing: 20) {
            ForEach(Array(algorithm.nodes.enumerated()), id: \.element.id) { index, node in
                EnhancedNodeView(
                    node: node,
                    isSelected: selectedNodeId == node.id,
                    onTap: { onNodeSelect(node.id) }
                )
                .padding(.horizontal, 20)
                
                // Connection indicator
                if !node.connections.isEmpty {
                    connectionIndicator
                }
            }
        }
        .frame(minWidth: 350)
        .padding(.vertical, 20)
    }
    
    // MARK: - Connection Indicator
    private var connectionIndicator: some View {
        HStack {
            Spacer()
            VStack(spacing: 4) {
                ForEach(0..<3) { _ in
                    Circle()
                        .fill(Color.blue.opacity(0.6))
                        .frame(width: 4, height: 4)
                }
            }
            Spacer()
        }
    }
    
    // MARK: - Zoom Controls
    private var zoomControlsOverlay: some View {
        VStack(spacing: 8) {
            Button(action: zoomIn) {
                Image(systemName: "plus.magnifyingglass")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                    .frame(width: 40, height: 40)
                    .background(.regularMaterial, in: Circle())
                    .shadow(radius: 2)
            }
            
            Button(action: zoomOut) {
                Image(systemName: "minus.magnifyingglass")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                    .frame(width: 40, height: 40)
                    .background(.regularMaterial, in: Circle())
                    .shadow(radius: 2)
            }
            
            Button(action: resetZoom) {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                    .frame(width: 40, height: 40)
                    .background(.regularMaterial, in: Circle())
                    .shadow(radius: 2)
            }
        }
    }
    
    // MARK: - Gestures
    private var panGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let delta = CGSize(
                    width: value.translation.width - lastPanValue.width,
                    height: value.translation.height - lastPanValue.height
                )
                panOffset = CGSize(
                    width: panOffset.width + delta.width,
                    height: panOffset.height + delta.height
                )
                lastPanValue = value.translation
            }
            .onEnded { _ in
                lastPanValue = .zero
            }
    }
    
    private var magnifyGesture: some Gesture {
        MagnifyGesture()
            .onChanged { value in
                let newScale = zoomScale * value.magnification
                zoomScale = min(max(newScale, minZoom), maxZoom)
            }
    }
    
    // MARK: - Zoom Actions
    private func zoomIn() {
        withAnimation(.easeInOut(duration: 0.3)) {
            zoomScale = min(zoomScale * 1.5, maxZoom)
        }
    }
    
    private func zoomOut() {
        withAnimation(.easeInOut(duration: 0.3)) {
            zoomScale = max(zoomScale / 1.5, minZoom)
        }
    }
    
    private func resetZoom() {
        withAnimation(.easeInOut(duration: 0.5)) {
            zoomScale = 1.0
            panOffset = .zero
        }
    }
    
    // MARK: - Helper Methods
    private func calculateContentWidth() -> CGFloat {
        return 350 // Minimum width for nodes
    }
    
    private func calculateContentHeight() -> CGFloat {
        let nodeHeight: CGFloat = 80
        let spacing: CGFloat = 20
        let connectionHeight: CGFloat = 20
        
        let nodesWithConnections = algorithm.nodes.filter { !$0.connections.isEmpty }.count
        return CGFloat(algorithm.nodes.count) * (nodeHeight + spacing) + 
               CGFloat(nodesWithConnections) * connectionHeight + 40
    }
    
    private func centerOnSelectedNode() {
        // Optional: Center the view on the selected node
        // Implementation could calculate the position of the selected node
        // and adjust panOffset to center it
    }
}

// MARK: - Enhanced Node View
private struct EnhancedNodeView: View {
    let node: AlgorithmNode
    let isSelected: Bool
    let onTap: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                // Header with icon and title
                HStack(spacing: 12) {
                    // Enhanced node icon
                    ZStack {
                        RoundedRectangle(cornerRadius: iconCornerRadius)
                            .fill(backgroundColorForNode(node))
                            .frame(width: 36, height: 36)
                            .shadow(color: .black.opacity(0.2), radius: 2, y: 1)
                        
                        Image(systemName: iconForNodeType(node.nodeType))
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(node.title)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                        
                        // Node type badge
                        Text(nodeTypeName(node.nodeType))
                            .font(.caption2)
                            .fontWeight(.medium)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                Capsule()
                                    .fill(backgroundColorForNode(node).opacity(0.2))
                            )
                            .foregroundColor(backgroundColorForNode(node))
                    }
                    
                    Spacer()
                    
                    // Critical indicator
                    if node.critical {
                        VStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 16))
                                .foregroundColor(.red)
                                .padding(6)
                                .background(
                                    Circle()
                                        .fill(.red.opacity(0.1))
                                )
                            Spacer()
                        }
                    }
                }
                
                // Content
                if !node.content.isEmpty {
                    Text(node.content)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(4)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                // Connections info
                if !node.connections.isEmpty {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.blue)
                        
                        Text("\(node.connections.count) next step\(node.connections.count == 1 ? "" : "s")")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.blue)
                        
                        Spacer()
                        
                        if isSelected {
                            Text("TAP TO CONTINUE")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(
                                    Capsule()
                                        .stroke(.blue, lineWidth: 1)
                                )
                        }
                    }
                    .padding(.top, 4)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.regularMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(strokeColor, lineWidth: strokeWidth)
                    )
                    .shadow(
                        color: shadowColor,
                        radius: shadowRadius,
                        y: shadowOffsetY
                    )
            )
        }
        .buttonStyle(.plain)
        .scaleEffect(isPressed ? 0.98 : (isSelected ? 1.02 : 1.0))
        .animation(.easeInOut(duration: 0.15), value: isSelected)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onLongPressGesture(minimumDuration: 0) {
            // Just for press effect
        } onPressingChanged: { pressing in
            isPressed = pressing
        }
    }
    
    // MARK: - Helper Properties
    private var iconCornerRadius: CGFloat {
        switch node.nodeType {
        case .decision: return 8
        case .endpoint: return 18
        default: return 6
        }
    }
    
    private var strokeColor: Color {
        if isSelected {
            return .blue
        } else if node.critical {
            return .red.opacity(0.8)
        } else {
            return .clear
        }
    }
    
    private var strokeWidth: CGFloat {
        if isSelected {
            return 2.5
        } else if node.critical {
            return 2.0
        } else {
            return 0
        }
    }
    
    private var shadowColor: Color {
        if isSelected {
            return .blue.opacity(0.3)
        } else if node.critical {
            return .red.opacity(0.2)
        } else {
            return .black.opacity(0.1)
        }
    }
    
    private var shadowRadius: CGFloat {
        if isSelected {
            return 8
        } else if node.critical {
            return 6
        } else {
            return 4
        }
    }
    
    private var shadowOffsetY: CGFloat {
        isSelected || node.critical ? 4 : 2
    }
    
    private func nodeTypeName(_ type: NodeType) -> String {
        switch type {
        case .decision: return "Decision"
        case .assessment: return "Assessment"
        case .intervention: return "Intervention"
        case .medication: return "Medication"
        case .endpoint: return "Complete"
        case .action: return "Action"
        }
    }
    
    private func iconForNodeType(_ type: NodeType) -> String {
        switch type {
        case .decision:
            return "diamond.fill"
        case .assessment:
            return "stethoscope"
        case .intervention:
            return "cross.case.fill"
        case .medication:
            return "pills.fill"
        case .endpoint:
            return "checkmark.circle.fill"
        case .action:
            return "hand.raised.fill"
        }
    }
    
    private func backgroundColorForNode(_ node: AlgorithmNode) -> Color {
        if node.critical {
            return .red
        }
        
        switch node.nodeType {
        case .decision:
            return .blue
        case .assessment:
            return .orange
        case .action:
            return .indigo
        case .intervention:
            return .green
        case .medication:
            return .purple
        case .endpoint:
            return .gray
        }
    }
}

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
            )
        ]),
        selectedNodeId: .constant("decision1"),
        onNodeSelect: { _ in }
    )
    .frame(height: 500)
}