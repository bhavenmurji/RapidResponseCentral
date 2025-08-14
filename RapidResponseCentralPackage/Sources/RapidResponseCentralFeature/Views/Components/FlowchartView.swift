import SwiftUI

// MARK: - Enhanced Flowchart View with Zoom
public struct FlowchartView: View {
    let algorithm: ProtocolAlgorithm
    @Binding var selectedNodeId: String?
    let onNodeSelect: (String) -> Void
    
    // Zoom and pan state
    @State private var zoomScale: CGFloat = 0.75  // Reduced initial zoom for better fit
    @State private var panOffset: CGSize = .zero
    @State private var lastPanValue: CGSize = .zero
    @State private var hasInitialized = false
    
    // Zoom limits
    private let minZoom: CGFloat = 0.5
    private let maxZoom: CGFloat = 2.0  // Reduced max zoom for better control
    
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
                // Enhanced background with subtle medical pattern
                LinearGradient(
                    colors: [
                        Color(red: 0.98, green: 0.98, blue: 1.0),
                        Color(red: 0.96, green: 0.97, blue: 1.0)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                .overlay(
                    GeometryReader { _ in
                        // Subtle medical grid pattern
                        Path { path in
                            let spacing: CGFloat = 50
                            for i in stride(from: 0, to: 2000, by: spacing) {
                                path.move(to: CGPoint(x: CGFloat(i), y: 0))
                                path.addLine(to: CGPoint(x: CGFloat(i), y: 2000))
                                path.move(to: CGPoint(x: 0, y: CGFloat(i)))
                                path.addLine(to: CGPoint(x: 2000, y: CGFloat(i)))
                            }
                        }
                        .stroke(Color.blue.opacity(0.03), lineWidth: 0.5)
                    }
                    .ignoresSafeArea()
                )
                
                // VERTICAL-ONLY scrolling - NO horizontal scroll allowed
                ScrollView(.vertical, showsIndicators: true) {
                    flowchartContent
                        .scaleEffect(zoomScale, anchor: .center)  // Changed to center anchor for better alignment
                        .offset(panOffset)
                        .frame(width: geometry.size.width) // Fixed width to prevent horizontal expansion
                        .frame(minHeight: calculateContentHeight() * zoomScale)
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
            // Initialize zoom and center on first node
            if !hasInitialized {
                hasInitialized = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    centerOnFirstNode()
                }
            }
        }
        .onChange(of: selectedNodeId) { oldValue, newValue in
            if oldValue != newValue {
                withAnimation(.easeInOut(duration: 0.3)) {
                    // Subtle zoom adjustment when selecting nodes
                    if newValue != nil {
                        zoomScale = min(zoomScale * 1.05, 1.0)
                    }
                }
            }
        }
    }
    
    // MARK: - Flowchart Content - Fixed Width, Vertical Only
    private var flowchartContent: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let nodeWidth = min(screenWidth - 40, 380) // Adjusted padding and increased max width
            
            VStack(alignment: .center, spacing: 24) {  // Increased spacing for better readability
                ForEach(Array(algorithm.nodes.enumerated()), id: \.element.id) { index, node in
                    EnhancedNodeView(
                        node: node,
                        isSelected: selectedNodeId == node.id,
                        onTap: { onNodeSelect(node.id) },
                        width: nodeWidth
                    )
                    
                    // Enhanced branching connection system - DEBUG VISIBLE
                    if !node.connections.isEmpty {
                        BranchingConnectionView(
                            node: node,
                            connections: node.connections,
                            allNodes: algorithm.nodes,
                            isActive: selectedNodeId == node.id,
                            containerWidth: nodeWidth
                        )
                        .frame(height: node.connections.count > 1 ? 80 : 40) // INCREASED HEIGHT
                        .padding(.vertical, 8) // INCREASED PADDING
                        .background(Color.blue.opacity(0.1)) // DEBUG BACKGROUND
                    }
                }
            }
            .padding(.horizontal, 20)  // Adjusted horizontal padding for better fit
            .padding(.vertical, 20)
            .frame(width: screenWidth)  // Use full width with padding
            .frame(maxWidth: .infinity, alignment: .center) // Center content
        }
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
            zoomScale = 0.75  // Reset to default zoom that fits content better
            panOffset = .zero
        }
    }
    
    // MARK: - Helper Methods
    private func calculateContentWidth() -> CGFloat {
        return UIScreen.main.bounds.width  // Use screen width
    }
    
    private func calculateContentHeight() -> CGFloat {
        let nodeHeight: CGFloat = 100  // Increased for better readability
        let spacing: CGFloat = 24
        let connectionHeight: CGFloat = 28  // Space for arrows
        
        let nodesWithConnections = algorithm.nodes.filter { !$0.connections.isEmpty }.count
        return CGFloat(algorithm.nodes.count) * (nodeHeight + spacing) + 
               CGFloat(nodesWithConnections) * connectionHeight + 80  // Extra padding
    }
    private func centerOnSelectedNode() {
        guard let nodeId = selectedNodeId,
              let nodeIndex = algorithm.nodes.firstIndex(where: { $0.id == nodeId }) else { return }
        
        // Calculate vertical position of the selected node
        let nodeHeight: CGFloat = 100
        let spacing: CGFloat = 44  // Total spacing including arrows
        let nodePosition = CGFloat(nodeIndex) * (nodeHeight + spacing) + 50
        
        // Center the node vertically in view
        withAnimation(.easeInOut(duration: 0.3)) {
            panOffset.height = -nodePosition * zoomScale + 200  // Offset to center in view
        }
    }
    
    private func centerOnFirstNode() {
        // Center on the first node when the view appears
        withAnimation(.easeInOut(duration: 0.5)) {
            zoomScale = 0.75  // Optimal zoom to see multiple nodes
            panOffset = CGSize(width: 0, height: 20)  // Slight offset for better initial view
        }
    }
}

// MARK: - Enhanced Node View with Modern Medical UI Patterns
private struct EnhancedNodeView: View {
    let node: AlgorithmNode
    let isSelected: Bool
    let onTap: () -> Void
    let width: CGFloat
    
    @State private var isPressed = false
    @State private var shimmerOffset: CGFloat = -1
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                // Header with title only
                HStack(spacing: 12) {
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(node.title)
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                        
                        // Minimal type indicator
                        if node.critical {
                            Text("CRITICAL")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                        }
                    }
                    
                    Spacer()
                    
                    // Connection indicator only
                    if !node.connections.isEmpty {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.blue)
                    }
                }
                
                // Content
                if !node.content.isEmpty {
                    Text(node.content)
                        .font(.system(size: 14, weight: .medium, design: .default))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(4)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.vertical, 2)
                        .padding(.horizontal, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.08))
                        )
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
            .padding(14)
            .frame(width: width, alignment: .leading)
            .background(
                ZStack {
                    // Base gradient background
                    RoundedRectangle(cornerRadius: 18)
                        .fill(
                            LinearGradient(
                                colors: backgroundGradient,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    // Glass morphism layer
                    RoundedRectangle(cornerRadius: 18)
                        .fill(
                            Material.ultraThinMaterial
                                .opacity(colorScheme == .dark ? 0.85 : 0.92)
                        )
                    
                    // Top highlight for depth
                    VStack {
                        LinearGradient(
                            colors: [
                                Color.white.opacity(isSelected ? 0.15 : 0.08),
                                Color.white.opacity(0)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 30)
                        .mask(RoundedRectangle(cornerRadius: 18))
                        Spacer()
                    }
                    
                    // Critical pulse effect
                    if node.critical {
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.red.opacity(0.6),
                                        Color.orange.opacity(0.4)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                            .opacity(isSelected ? 1.0 : 0.7)
                            .animation(
                                Animation.easeInOut(duration: 1.5)
                                    .repeatForever(autoreverses: true),
                                value: node.critical
                            )
                    }
                    
                    // Selection border
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(
                            isSelected ?
                            LinearGradient(
                                colors: [
                                    Color.blue.opacity(0.8),
                                    Color.purple.opacity(0.6)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ) :
                            LinearGradient(
                                colors: [strokeColor.opacity(0.5), strokeColor.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: isSelected ? 2.5 : strokeWidth
                        )
                }
                .shadow(
                    color: shadowColor.opacity(isSelected ? 0.4 : 0.25),
                    radius: isSelected ? 12 : shadowRadius,
                    x: 0,
                    y: isSelected ? 6 : shadowOffsetY
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
    
    private var backgroundGradient: [Color] {
        switch node.nodeType {
        case .decision:
            return [Color.blue.opacity(0.1), Color.blue.opacity(0.05)]
        case .assessment:
            return [Color.purple.opacity(0.1), Color.purple.opacity(0.05)]
        case .intervention:
            return [Color.green.opacity(0.1), Color.green.opacity(0.05)]
        case .medication:
            return [Color.orange.opacity(0.1), Color.orange.opacity(0.05)]
        case .endpoint:
            return [Color.red.opacity(0.1), Color.red.opacity(0.05)]
        case .action:
            return [Color.teal.opacity(0.1), Color.teal.opacity(0.05)]
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

// MARK: - Directional Arrow Component - Omnichart Professional Style

public struct DirectionalArrow: View {
    let isActive: Bool
    let hasConnection: Bool
    let nodeType: NodeType
    
    public var body: some View {
        VStack(spacing: 2) {
            // Clean connection line with proper thickness
            Rectangle()
                .fill(arrowColor)
                .frame(width: strokeWidth, height: arrowHeight)
            
            // Sharp directional arrow head
            Image(systemName: arrowHeadIcon)
                .font(.system(size: arrowHeadSize, weight: .bold))
                .foregroundColor(arrowColor)
                .scaleEffect(isActive ? 1.2 : 1.0)
        }
        .opacity(hasConnection ? 1.0 : 0.5)
        .animation(.spring(response: 0.2, dampingFraction: 0.8), value: isActive)
    }
    
    private var arrowColor: Color {
        if isActive {
            return .blue
        }
        switch nodeType {
        case .decision: return .blue.opacity(0.8)
        case .assessment: return .orange.opacity(0.8)
        case .intervention, .action: return .green.opacity(0.8)
        case .medication: return .purple.opacity(0.8)
        case .endpoint: return .gray.opacity(0.8)
        }
    }
    
    private var strokeWidth: CGFloat {
        isActive ? 8 : 6  // MUCH THICKER arrows
    }
    
    private var arrowHeight: CGFloat {
        24  // MUCH Taller arrow shaft
    }
    
    private var arrowHeadSize: CGFloat {
        isActive ? 20 : 16  // MUCH LARGER arrow heads
    }
    
    private var arrowHeadIcon: String {
        "arrowtriangle.down.fill"
    }
}

// MARK: - Enhanced Branching Connection View

public struct BranchingConnectionView: View {
    let node: AlgorithmNode
    let connections: [String]
    let allNodes: [AlgorithmNode]
    let isActive: Bool
    let containerWidth: CGFloat
    
    public var body: some View {
        VStack(spacing: 0) {
            if connections.count == 1 {
                // Single connection - straight arrow
                SingleConnectionArrow(isActive: isActive, nodeType: node.nodeType)
            } else if connections.count > 1 {
                // Multiple connections - branching arrows
                BranchingArrows(
                    connections: connections,
                    allNodes: allNodes,
                    isActive: isActive,
                    nodeType: node.nodeType,
                    containerWidth: containerWidth
                )
            }
        }
    }
}

// MARK: - Single Connection Arrow
struct SingleConnectionArrow: View {
    let isActive: Bool
    let nodeType: NodeType
    
    var body: some View {
        VStack(spacing: 4) {
            Rectangle()
                .fill(arrowColor)
                .frame(width: isActive ? 8 : 6, height: 24) // MUCH THICKER AND TALLER
            
            Image(systemName: "arrowtriangle.down.fill")
                .font(.system(size: isActive ? 20 : 16, weight: .bold)) // MUCH LARGER
                .foregroundColor(arrowColor)
                .scaleEffect(isActive ? 1.3 : 1.1) // BIGGER SCALE
        }
        .animation(.spring(response: 0.2, dampingFraction: 0.8), value: isActive)
    }
    
    private var arrowColor: Color {
        if isActive {
            return .blue
        }
        switch nodeType {
        case .decision: return .blue.opacity(0.8)
        case .assessment: return .orange.opacity(0.8)
        case .intervention, .action: return .green.opacity(0.8)
        case .medication: return .purple.opacity(0.8)
        case .endpoint: return .gray.opacity(0.8)
        }
    }
}

// MARK: - Branching Arrows
struct BranchingArrows: View {
    let connections: [String]
    let allNodes: [AlgorithmNode]
    let isActive: Bool
    let nodeType: NodeType
    let containerWidth: CGFloat
    
    var body: some View {
        VStack(spacing: 0) {
            // Main stem - MUCH THICKER
            Rectangle()
                .fill(arrowColor)
                .frame(width: isActive ? 8 : 6, height: 20)
            
            // Branching section
            HStack(spacing: 0) {
                ForEach(Array(connections.enumerated()), id: \.offset) { index, connectionId in
                    let targetNode = allNodes.first(where: { $0.id == connectionId })
                    let branchWidth = containerWidth / CGFloat(connections.count)
                    
                    VStack(spacing: 4) {
                        // Horizontal branch line
                        HStack(spacing: 0) {
                            if index > 0 {
                                Rectangle()
                                    .fill(arrowColor)
                                    .frame(width: branchWidth * 0.4, height: 4) // THICKER
                            }
                            
                            // Vertical drop - THICKER
                            Rectangle()
                                .fill(arrowColor)
                                .frame(width: 4, height: 28) // MUCH THICKER AND TALLER
                            
                            if index < connections.count - 1 {
                                Rectangle()
                                    .fill(arrowColor)
                                    .frame(width: branchWidth * 0.4, height: 4) // THICKER
                            }
                        }
                        
                        // Arrow head with label
                        VStack(spacing: 2) {
                            Image(systemName: "arrowtriangle.down.fill")
                                .font(.system(size: isActive ? 18 : 14, weight: .bold)) // MUCH LARGER
                                .foregroundColor(branchColor(for: targetNode))
                            
                            if let targetNode = targetNode {
                                Text(truncatedTitle(targetNode.title))
                                    .font(.system(size: 8, weight: .medium))
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                                    .frame(width: branchWidth * 0.8)
                            }
                        }
                    }
                    .frame(width: branchWidth)
                }
            }
            .frame(width: containerWidth)
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isActive)
    }
    
    private var arrowColor: Color {
        if isActive {
            return .blue
        }
        switch nodeType {
        case .decision: return .blue.opacity(0.8)
        case .assessment: return .orange.opacity(0.8)
        case .intervention, .action: return .green.opacity(0.8)
        case .medication: return .purple.opacity(0.8)
        case .endpoint: return .gray.opacity(0.8)
        }
    }
    
    private func branchColor(for node: AlgorithmNode?) -> Color {
        guard let node = node else { return .gray }
        
        if node.critical {
            return .red
        }
        
        switch node.nodeType {
        case .decision: return .blue
        case .assessment: return .orange
        case .intervention, .action: return .green
        case .medication: return .purple
        case .endpoint: return .gray
        }
    }
    
    private func truncatedTitle(_ title: String) -> String {
        let maxLength = 12
        if title.count > maxLength {
            return String(title.prefix(maxLength - 1)) + "…"
        }
        return title
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
            )
        ]),
        selectedNodeId: .constant("decision1"),
        onNodeSelect: { _ in }
    )
    .frame(height: 500)
}