import SwiftUI
import UIKit
import Combine

// MARK: - Snap-to-Node Flowchart View
public struct SnapFlowchartView: View {
    let algorithm: ProtocolAlgorithm
    @Binding var selectedNodeId: String?
    let onNodeSelect: (String) -> Void
    
    // Navigation state
    @State private var currentNodeIndex: Int = 0
    @State private var scrollProxy: ScrollViewProxy?
    @State private var dragOffset: CGSize = .zero
    @State private var accumlatedDrag: CGFloat = 0
    @State private var hasPerformedInitialScroll = false
    
    // Visual state
    @State private var zoomScale: CGFloat = 1.0
    @State private var animateNodes = false
    @State private var centeringZoomScale: CGFloat = 1.0
    @State private var showCenteringEffect = false
    
    // Enhanced animation states
    @State private var selectedNodeScale: CGFloat = 1.0
    @State private var focusRingScale: CGFloat = 0.8
    @State private var pulseAnimation: Bool = false
    @State private var particleAnimation: Bool = false
    
    // Gesture states for pinch zoom
    @State private var currentZoom: CGFloat = 1.0
    @State private var totalZoom: CGFloat = 1.0
    
    // Mini-map state
    @State private var showMiniMap: Bool = false
    
    // Navigation tracking for breadcrumb trail
    @State private var navigationPath: [String] = []
    @State private var visitedNodes: Set<String> = []
    
    // Haptic feedback generator
    private let hapticFeedback = UIImpactFeedbackGenerator(style: .medium)
    private let selectionFeedback = UISelectionFeedbackGenerator()
    
    // Node mapping for branching
    private var nodeMap: [String: AlgorithmNode] {
        Dictionary(uniqueKeysWithValues: algorithm.nodes.map { ($0.id, $0) })
    }
    
    // Find node index by ID
    private func nodeIndex(for id: String) -> Int? {
        algorithm.nodes.firstIndex(where: { $0.id == id })
    }
    
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
                // Clean background
                LinearGradient(
                    colors: [
                        Color(.systemBackground),
                        Color(.secondarySystemBackground).opacity(0.3)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // Main flowchart scroll view with branching support
                ScrollViewReader { proxy in
                    ScrollView([.vertical, .horizontal], showsIndicators: true) {
                        ZStack(alignment: .topLeading) {
                            // Calculate node positions for branching layout
                            let positions = calculateNodePositions()
                            
                            // Draw connection lines first (behind nodes)
                            ForEach(algorithm.nodes, id: \.id) { node in
                                ForEach(node.connections, id: \.self) { targetId in
                                    if let fromPos = positions[node.id],
                                       let toNode = nodeMap[targetId],
                                       let toPos = positions[targetId] {
                                        FlowchartConnection(
                                            from: node,
                                            to: toNode,
                                            isActive: selectedNodeId == node.id || selectedNodeId == targetId,
                                            nodePositions: positions
                                        )
                                    }
                                }
                            }
                            
                            // Draw nodes with proper positioning
                            ForEach(algorithm.nodes, id: \.id) { node in
                                if let position = positions[node.id] {
                                    EnhancedCompactNodeView(
                                        node: node,
                                        isSelected: selectedNodeId == node.id,
                                        isVisited: visitedNodes.contains(node.id),
                                        position: position,
                                        pulseAnimation: pulseAnimation,
                                        particleAnimation: particleAnimation,
                                        onTap: {
                                            snapToNode(node.id, proxy: proxy)
                                        }
                                    )
                                    .position(position)
                                    .id(node.id)
                                    .onTapGesture {
                                        snapToNode(node.id, proxy: proxy)
                                    }
                                }
                            }
                        }
                        .frame(width: max(geometry.size.width * 1.5, 1200), height: max(geometry.size.height * 2.5, 1600))
                        .scaleEffect(zoomScale * centeringZoomScale * totalZoom)
                    }
                    .onAppear {
                        scrollProxy = proxy
                        
                        // ALWAYS select and center first node
                        if let firstNode = algorithm.nodes.first {
                            // Force selection of first node
                            selectedNodeId = firstNode.id
                            onNodeSelect(firstNode.id)
                            
                            // Mark as visited
                            visitedNodes.insert(firstNode.id)
                            navigationPath = [firstNode.id]
                            
                            // Center the first node properly
                            proxy.scrollTo(firstNode.id, anchor: .center)
                            
                            // Multiple delayed attempts to ensure proper positioning
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                withAnimation(.easeOut(duration: 0.3)) {
                                    proxy.scrollTo(firstNode.id, anchor: .center)
                                }
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                proxy.scrollTo(firstNode.id, anchor: .center)
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    proxy.scrollTo(firstNode.id, anchor: .center)
                                }
                            }
                        }
                    }
                    .onChange(of: selectedNodeId) { oldValue, newValue in
                        if let nodeId = newValue, oldValue != newValue {
                            // Trigger haptic feedback
                            triggerHapticFeedback()
                            
                            // Update navigation tracking
                            updateNavigationPath(to: nodeId)
                            
                            // AGGRESSIVE CENTERING - Always center selected node
                            // Immediate scroll
                            proxy.scrollTo(nodeId, anchor: .center)
                            
                            // Quick animated follow-up
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                withAnimation(.easeOut(duration: 0.25)) {
                                    proxy.scrollTo(nodeId, anchor: .center)
                                }
                            }
                            
                            // Secondary centering
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    proxy.scrollTo(nodeId, anchor: .center)
                                }
                            }
                            
                            // Final positioning
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                                proxy.scrollTo(nodeId, anchor: .center)
                            }
                            
                            // Visual feedback
                            withAnimation(.easeInOut(duration: 0.3)) {
                                pulseAnimation.toggle()
                            }
                        }
                    }
                    .onReceive(Just(selectedNodeId).delay(for: .milliseconds(200), scheduler: RunLoop.main)) { nodeId in
                        // Ensure initial centering when view first appears
                        if let nodeId = nodeId, let proxy = scrollProxy {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                proxy.scrollTo(nodeId, anchor: .center)
                            }
                        }
                    }
                }
                .gesture(
                    SimultaneousGesture(
                        // Pinch to zoom gesture
                        MagnificationGesture()
                            .onChanged { value in
                                let delta = value / currentZoom
                                currentZoom = value
                                totalZoom = min(max(totalZoom * delta, 0.5), 3.0) // Limit zoom between 0.5x and 3x
                            }
                            .onEnded { value in
                                currentZoom = 1.0
                            },
                        // Drag gesture for navigation
                        DragGesture()
                            .onChanged { value in
                                dragOffset = value.translation
                            }
                            .onEnded { value in
                                // Determine swipe direction and navigate
                                handleSwipeNavigation(value.translation)
                                dragOffset = .zero
                            }
                    )
                )
                
                // Floating controls overlay
                VStack {
                    // Top controls
                    HStack {
                        Spacer()
                        
                        // Enhanced Recenter Button
                        Button(action: recenterOnSelectedNode) {
                            HStack(spacing: 4) {
                                Image(systemName: "location.circle.fill")
                                    .font(.system(size: 14, weight: .medium))
                                Text("Center")
                                    .font(.system(size: 12, weight: .medium))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(showCenteringEffect ? Color.orange : Color.blue)
                                    .shadow(radius: showCenteringEffect ? 8 : 4)
                            )
                            .scaleEffect(showCenteringEffect ? 1.05 : 1.0)
                            .animation(.spring(response: 0.3), value: showCenteringEffect)
                        }
                        .padding(.top, 16)
                        .padding(.trailing, 16)
                    }
                    
                    Spacer()
                    
                    // Bottom controls with mini-map toggle and zoom
                    HStack {
                        // Mini-map toggle button
                        Button(action: { showMiniMap.toggle() }) {
                            Image(systemName: showMiniMap ? "map.fill" : "map")
                                .font(.system(size: 16, weight: .medium))
                                .frame(width: 44, height: 44)
                                .background(.regularMaterial)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        .padding(.leading, 16)
                        .padding(.bottom, 16)
                        
                        Spacer()
                        
                        // Zoom controls
                        ZoomControls(zoomScale: $totalZoom)
                            .padding()
                    }
                }
                
                // Mini-map overlay
                if showMiniMap {
                    MiniMapOverlay(
                        algorithm: algorithm,
                        selectedNodeId: $selectedNodeId,
                        nodePositions: calculateNodePositions(),
                        onNodeSelect: { nodeId in
                            snapToNode(nodeId, proxy: scrollProxy)
                        }
                    )
                    .transition(.asymmetric(
                        insertion: .scale.combined(with: .opacity),
                        removal: .scale.combined(with: .opacity)
                    ))
                }
            }
        }
        .onAppear {
            withAnimation {
                animateNodes = true
            }
            
            // Additional failsafe for initial centering
            if !hasPerformedInitialScroll, let proxy = scrollProxy {
                if let nodeToCenter = selectedNodeId ?? algorithm.nodes.first?.id {
                    performInitialScroll(to: nodeToCenter, proxy: proxy)
                }
            }
        }
        .task {
            // Use task modifier for async initial setup
            if let firstNode = algorithm.nodes.first {
                let nodeToSelect = selectedNodeId ?? firstNode.id
                
                // Wait for view to be fully ready
                try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
                
                if let proxy = scrollProxy {
                    await MainActor.run {
                        proxy.scrollTo(nodeToSelect, anchor: .center)
                    }
                }
            }
        }
    }
    
    // Calculate node positions for branching layout
    private func calculateNodePositions() -> [String: CGPoint] {
        var positions: [String: CGPoint] = [:]
        var visited: Set<String> = []
        var levelNodes: [Int: [String]] = [:]
        
        // Start at a position that will be visible when centered
        let startY: CGFloat = 150  // Better initial visibility
        let xSpacing: CGFloat = 300  // Increased spacing for better branch separation
        let ySpacing: CGFloat = 200  // Increased vertical spacing
        let centerX: CGFloat = 400  // Center baseline
        
        // First pass: build level mapping for proper branching layout
        func assignLevels(_ nodeId: String, level: Int) {
            guard !visited.contains(nodeId),
                  let node = nodeMap[nodeId] else { return }
            
            visited.insert(nodeId)
            
            if levelNodes[level] == nil {
                levelNodes[level] = []
            }
            levelNodes[level]?.append(nodeId)
            
            // Process children at next level
            for childId in node.connections {
                assignLevels(childId, level: level + 1)
            }
        }
        
        // Reset visited for second pass
        visited.removeAll()
        
        // Build level mapping starting from first node
        if let firstNode = algorithm.nodes.first {
            assignLevels(firstNode.id, level: 0)
        }
        
        // Second pass: position nodes within levels
        for (level, nodesAtLevel) in levelNodes {
            let y = startY + CGFloat(level) * ySpacing
            let nodeCount = nodesAtLevel.count
            
            if nodeCount == 1 {
                // Single node - center it
                positions[nodesAtLevel[0]] = CGPoint(x: centerX, y: y)
            } else {
                // Multiple nodes - distribute them horizontally
                let totalWidth = CGFloat(nodeCount - 1) * xSpacing
                let startX = centerX - totalWidth / 2
                
                for (index, nodeId) in nodesAtLevel.enumerated() {
                    let x = startX + CGFloat(index) * xSpacing
                    positions[nodeId] = CGPoint(x: x, y: y)
                }
            }
        }
        
        return positions
    }
    
    // Enhanced swipe navigation with improved snapping
    private func handleSwipeNavigation(_ translation: CGSize) {
        guard let currentId = selectedNodeId,
              let currentNode = nodeMap[currentId] else { return }
        
        let threshold: CGFloat = 30  // Reduced for more responsive navigation
        let velocity = sqrt(pow(translation.width, 2) + pow(translation.height, 2))
        
        // Use velocity for more natural navigation
        if velocity > threshold {
            if abs(translation.width) > abs(translation.height) {
                // Horizontal swipe - navigate between branches
                if translation.width > 0 {
                    navigateToNextBranch(from: currentNode)
                } else {
                    navigateToPreviousBranch(from: currentNode)
                }
            } else {
                // Vertical swipe - navigate up/down the flow
                if translation.height > 0 {
                    navigateToNextNode(from: currentNode)
                } else {
                    navigateToPreviousNode(from: currentNode)
                }
            }
        }
    }
    
    private func navigateToNextNode(from node: AlgorithmNode) {
        if let firstConnection = node.connections.first {
            snapToNode(firstConnection, proxy: scrollProxy)
        }
    }
    
    private func navigateToPreviousNode(from node: AlgorithmNode) {
        // Find parent node (node that connects to current)
        if let parentNode = algorithm.nodes.first(where: { $0.connections.contains(node.id) }) {
            snapToNode(parentNode.id, proxy: scrollProxy)
        }
    }
    
    private func navigateToNextBranch(from node: AlgorithmNode) {
        guard node.connections.count > 1 else { return }
        // If multiple connections, cycle through them
        if let currentChildIndex = node.connections.firstIndex(of: selectedNodeId ?? ""),
           currentChildIndex < node.connections.count - 1 {
            snapToNode(node.connections[currentChildIndex + 1], proxy: scrollProxy)
        } else {
            snapToNode(node.connections.first ?? "", proxy: scrollProxy)
        }
    }
    
    private func navigateToPreviousBranch(from node: AlgorithmNode) {
        guard node.connections.count > 1 else { return }
        // If multiple connections, cycle through them backwards
        if let currentChildIndex = node.connections.firstIndex(of: selectedNodeId ?? ""),
           currentChildIndex > 0 {
            snapToNode(node.connections[currentChildIndex - 1], proxy: scrollProxy)
        } else {
            snapToNode(node.connections.last ?? "", proxy: scrollProxy)
        }
    }
    
    private func snapToNode(_ nodeId: String, proxy: ScrollViewProxy?) {
        guard let proxy = proxy else { return }
        
        // Enhanced spring animation with haptic feedback
        triggerSelectionFeedback()
        
        // Update navigation tracking first
        updateNavigationPath(to: nodeId)
        
        // Update selection state
        selectedNodeId = nodeId
        onNodeSelect(nodeId)
        
        // Magnetic snap animation with enhanced precision
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.1)) {
            proxy.scrollTo(nodeId, anchor: .center)
        }
        
        // Secondary positioning for precision
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeOut(duration: 0.15)) {
                proxy.scrollTo(nodeId, anchor: .center)
            }
        }
        
        // Visual feedback with enhanced centering effect
        withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
            focusRingScale = 1.15
            showCenteringEffect = true
        }
        
        // Reset visual effects
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                focusRingScale = 1.0
                showCenteringEffect = false
            }
        }
    }
    
    // MARK: - Haptic Feedback Methods
    private func triggerHapticFeedback() {
        hapticFeedback.impactOccurred()
    }
    
    private func triggerSelectionFeedback() {
        selectionFeedback.selectionChanged()
    }
    
    // MARK: - Navigation Tracking
    private func updateNavigationPath(to nodeId: String) {
        // Add to visited nodes
        visitedNodes.insert(nodeId)
        
        // Update navigation path (limit to last 5 nodes for performance)
        if !navigationPath.contains(nodeId) {
            navigationPath.append(nodeId)
            if navigationPath.count > 5 {
                navigationPath.removeFirst()
            }
        }
    }
    
    // MARK: - Initial Scroll
    private func performInitialScroll(to nodeId: String, proxy: ScrollViewProxy) {
        // Guard against multiple initial scrolls
        guard !hasPerformedInitialScroll else { return }
        
        // Aggressive multi-layer centering for initial load
        // Layer 1: Immediate positioning (before any animations)
        proxy.scrollTo(nodeId, anchor: .center)
        
        // Layer 2: After RunLoop cycle
        DispatchQueue.main.async {
            proxy.scrollTo(nodeId, anchor: .center)
        }
        
        // Layer 3: After brief delay for view hierarchy
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            proxy.scrollTo(nodeId, anchor: .center)
        }
        
        // Layer 4: After UI has settled
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.easeOut(duration: 0.2)) {
                proxy.scrollTo(nodeId, anchor: .center)
            }
        }
        
        // Layer 5: After initial animations
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            proxy.scrollTo(nodeId, anchor: .center)
        }
        
        // Layer 6: Final positioning check
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            proxy.scrollTo(nodeId, anchor: .center)
            hasPerformedInitialScroll = true
        }
        
        // Layer 7: Delayed final adjustment
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            withAnimation(.easeInOut(duration: 0.3)) {
                proxy.scrollTo(nodeId, anchor: .center)
            }
        }
        
        // Layer 8: Ultimate fallback
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            proxy.scrollTo(nodeId, anchor: .center)
        }
    }
    
    // MARK: - View Controls
    private func recenterOnSelectedNode() {
        guard let nodeId = selectedNodeId else { return }
        
        // Trigger enhanced haptic feedback
        hapticFeedback.impactOccurred()
        
        // Visual centering effect
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            showCenteringEffect = true
            centeringZoomScale = 1.1
        }
        
        // Center on the selected node with smooth animation
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            scrollProxy?.scrollTo(nodeId, anchor: .center)
        }
        
        // Reset visual effects
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                showCenteringEffect = false
                centeringZoomScale = 1.0
            }
        }
    }
    
    private func resetView() {
        // Reset zoom with animation
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            totalZoom = 1.0
            currentZoom = 1.0
            centeringZoomScale = 1.0
        }
        
        // Reset to first node
        if let firstNodeId = algorithm.nodes.first?.id {
            selectedNodeId = firstNodeId
            onNodeSelect(firstNodeId)
            recenterOnSelectedNode()
        }
    }
}

// MARK: - Enhanced Compact Node View
struct EnhancedCompactNodeView: View {
    let node: AlgorithmNode
    let isSelected: Bool
    let isVisited: Bool
    let position: CGPoint
    let pulseAnimation: Bool
    let particleAnimation: Bool
    let onTap: () -> Void
    
    @State private var focusRingScale: CGFloat = 1.0
    @State private var glowOpacity: Double = 0.0
    @State private var particleOffset: [CGSize] = Array(repeating: .zero, count: 6)
    
    private var nodeColor: Color {
        if node.critical { return .red }
        switch node.nodeType {
        case .decision: return .blue
        case .assessment: return .orange
        case .intervention, .action: return .green
        case .medication: return .purple
        case .endpoint: return .gray
        }
    }
    
    private var nodeShape: some ShapeStyle {
        nodeColor.gradient
    }
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                // Particle effects for critical nodes
                if node.critical && particleAnimation {
                    ParticleEffects(nodeColor: nodeColor, particleOffset: $particleOffset)
                }
                
                // Focus ring animation
                if isSelected {
                    FocusRing(nodeColor: nodeColor, scale: focusRingScale)
                }
                
                // Main node content
                VStack(spacing: 4) {
                    // Node shape indicator with enhanced animations
                    ZStack {
                        Group {
                            switch node.nodeType {
                            case .decision:
                                DiamondShape()
                                    .fill(nodeShape)
                                    .frame(width: nodeWidth, height: nodeHeight)
                                    .overlay(
                                        DiamondShape()
                                            .stroke(
                                                selectionBorderColor,
                                                lineWidth: selectionBorderWidth
                                            )
                                    )
                            case .endpoint:
                                Circle()
                                    .fill(nodeShape)
                                    .frame(width: nodeWidth, height: nodeHeight)
                                    .overlay(
                                        Circle()
                                            .strokeBorder(
                                                selectionBorderColor,
                                                lineWidth: selectionBorderWidth
                                            )
                                    )
                            default:
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(nodeShape)
                                    .frame(width: nodeWidth, height: nodeHeight)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .strokeBorder(
                                                selectionBorderColor,
                                                lineWidth: selectionBorderWidth
                                            )
                                    )
                            }
                        }
                        .overlay(
                            // Glow effect for selected nodes
                            Group {
                                switch node.nodeType {
                                case .decision:
                                    DiamondShape()
                                        .fill(nodeColor.opacity(glowOpacity))
                                        .blur(radius: 8)
                                case .endpoint:
                                    Circle()
                                        .fill(nodeColor.opacity(glowOpacity))
                                        .blur(radius: 8)
                                default:
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(nodeColor.opacity(glowOpacity))
                                        .blur(radius: 8)
                                }
                            }
                        )
                        
                        // Concise title
                        Text(truncatedTitle)
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 8)
                            .lineLimit(2)
                    }
                    
                    // Enhanced critical indicator
                    if node.critical {
                        HStack(spacing: 2) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.caption)
                                .foregroundColor(.red)
                            
                            if isSelected {
                                Text("CRITICAL")
                                    .font(.system(size: 8, weight: .bold))
                                    .foregroundColor(.red)
                            }
                        }
                        .opacity(pulseAnimation && isSelected ? 0.7 : 1.0)
                    }
                    
                    // Visited indicator
                    if isVisited && !isSelected {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 6, height: 6)
                            .opacity(0.7)
                    }
                }
            }
        }
        // Removed .position() for VStack layout
        .buttonStyle(.plain)
        .scaleEffect(isSelected ? (pulseAnimation ? 1.15 : 1.1) : 1.0)
        .shadow(
            color: shadowColor,
            radius: shadowRadius,
            x: 0,
            y: shadowY
        )
        .onChange(of: isSelected) { _, newValue in
            if newValue {
                // Animate focus ring
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    focusRingScale = 1.2
                }
                
                // Animate glow
                withAnimation(.easeInOut(duration: 0.8).repeatCount(2, autoreverses: true)) {
                    glowOpacity = 0.4
                }
                
                // Reset after animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        focusRingScale = 1.0
                        glowOpacity = 0.0
                    }
                }
            }
        }
        .onChange(of: particleAnimation) { _, _ in
            if node.critical {
                animateParticles()
            }
        }
    }
    
    // MARK: - Computed Properties
    private var selectionBorderColor: Color {
        if isSelected {
            return Color.accentColor
        } else if isVisited {
            return Color.green.opacity(0.6)
        } else {
            return Color.clear
        }
    }
    
    private var selectionBorderWidth: CGFloat {
        isSelected ? 3 : (isVisited ? 2 : 0)
    }
    
    private var shadowColor: Color {
        if isSelected {
            return nodeColor.opacity(0.6)
        } else if node.critical {
            return Color.red.opacity(0.3)
        } else {
            return Color.black.opacity(0.1)
        }
    }
    
    private var shadowRadius: CGFloat {
        if isSelected {
            return pulseAnimation ? 12 : 8
        } else if node.critical {
            return 6
        } else {
            return 3
        }
    }
    
    private var shadowY: CGFloat {
        isSelected ? 4 : 2
    }
    
    private var nodeWidth: CGFloat {
        switch node.nodeType {
        case .decision: return 120
        case .endpoint: return 100
        default: return 140
        }
    }
    
    private var nodeHeight: CGFloat {
        switch node.nodeType {
        case .decision: return 80
        case .endpoint: return 60
        default: return 60
        }
    }
    
    // Truncate title for cleaner nodes
    private var truncatedTitle: String {
        let maxLength = 30
        if node.title.count > maxLength {
            return String(node.title.prefix(maxLength - 3)) + "..."
        }
        return node.title
    }
    
    // MARK: - Animation Methods
    private func animateParticles() {
        withAnimation(.easeOut(duration: 1.5)) {
            for i in 0..<particleOffset.count {
                let angle = Double(i) * (2 * .pi / Double(particleOffset.count))
                let radius: CGFloat = 40
                particleOffset[i] = CGSize(
                    width: cos(angle) * radius,
                    height: sin(angle) * radius
                )
            }
        }
        
        // Reset particles after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeIn(duration: 0.3)) {
                particleOffset = Array(repeating: .zero, count: 6)
            }
        }
    }
}

// MARK: - Enhanced Flowchart Connection
struct FlowchartConnection: View {
    let from: AlgorithmNode
    let to: AlgorithmNode
    let isActive: Bool
    let nodePositions: [String: CGPoint]
    
    @State private var animationProgress: CGFloat = 0.0
    @State private var pulseOpacity: Double = 1.0
    
    var body: some View {
        if let fromPos = nodePositions[from.id],
           let toPos = nodePositions[to.id] {
            ZStack {
                // Main connection path
                Path { path in
                    path.move(to: fromPos)
                    
                    // Enhanced curved connection for proper branching visualization
                    let deltaX = toPos.x - fromPos.x
                    let deltaY = toPos.y - fromPos.y
                    
                    if abs(deltaX) > 50 {
                        // Horizontal branching - create curved path
                        let midY = fromPos.y + deltaY * 0.5
                        let controlPoint1 = CGPoint(x: fromPos.x, y: midY)
                        let controlPoint2 = CGPoint(x: toPos.x, y: midY)
                        path.addCurve(to: toPos, control1: controlPoint1, control2: controlPoint2)
                    } else {
                        // Vertical flow - simple curved path
                        let controlPoint1 = CGPoint(
                            x: fromPos.x,
                            y: fromPos.y + deltaY * 0.3
                        )
                        let controlPoint2 = CGPoint(
                            x: toPos.x,
                            y: toPos.y - deltaY * 0.3
                        )
                        path.addCurve(to: toPos, control1: controlPoint1, control2: controlPoint2)
                    }
                }
                .stroke(
                    connectionGradient,
                    style: StrokeStyle(
                        lineWidth: isActive ? 4 : 2,
                        lineCap: .round,
                        lineJoin: .round,
                        dash: from.nodeType == .decision && !isActive ? [5, 5] : []
                    )
                )
                .opacity(pulseOpacity)
                
                // Animated flow indicator for active connections
                if isActive {
                    FlowIndicator(
                        fromPos: fromPos,
                        toPos: toPos,
                        animationProgress: animationProgress
                    )
                }
                
                // Enhanced arrowhead
                ArrowHead(
                    position: toPos,
                    isActive: isActive,
                    nodeType: to.nodeType,
                    fromPos: fromPos
                )
            }
            .onAppear {
                if isActive {
                    startFlowAnimation()
                    startPulseAnimation()
                }
            }
            .onChange(of: isActive) { _, newValue in
                if newValue {
                    startFlowAnimation()
                    startPulseAnimation()
                }
            }
        }
    }
    
    private var connectionGradient: LinearGradient {
        if isActive {
            return LinearGradient(
                colors: [Color.accentColor, Color.accentColor.opacity(0.7)],
                startPoint: .leading,
                endPoint: .trailing
            )
        } else {
            return LinearGradient(
                colors: [Color.secondary.opacity(0.3)],
                startPoint: .leading,
                endPoint: .trailing
            )
        }
    }
    
    private func startFlowAnimation() {
        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            animationProgress = 1.0
        }
    }
    
    private func startPulseAnimation() {
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            pulseOpacity = 0.6
        }
    }
}

// MARK: - Flow Indicator Component
struct FlowIndicator: View {
    let fromPos: CGPoint
    let toPos: CGPoint
    let animationProgress: CGFloat
    
    var body: some View {
        Circle()
            .fill(Color.accentColor.opacity(0.8))
            .frame(width: 8, height: 8)
            .position(
                CGPoint(
                    x: fromPos.x + (toPos.x - fromPos.x) * animationProgress,
                    y: fromPos.y + (toPos.y - fromPos.y) * animationProgress
                )
            )
            .blur(radius: 1)
    }
}

// MARK: - Arrow Head Component
struct ArrowHead: View {
    let position: CGPoint
    let isActive: Bool
    let nodeType: NodeType
    let fromPos: CGPoint
    
    private var arrowIcon: String {
        switch nodeType {
        case .decision:
            return "arrow.down.circle.fill"
        case .endpoint:
            return "checkmark.circle.fill"
        default:
            return "arrowtriangle.down.fill"
        }
    }
    
    private var arrowOffset: CGSize {
        let deltaX = position.x - fromPos.x
        let deltaY = position.y - fromPos.y
        
        if abs(deltaX) > 50 {
            // For branching connections, position arrow closer to target node
            return CGSize(width: 0, height: -40)
        } else {
            // For vertical connections
            return CGSize(width: 0, height: -30)
        }
    }
    
    var body: some View {
        Image(systemName: arrowIcon)
            .font(.caption)
            .foregroundColor(
                isActive ? Color.accentColor : Color.secondary.opacity(0.3)
            )
            .position(position)
            .offset(arrowOffset)
            .scaleEffect(isActive ? 1.2 : 1.0)
            .animation(.spring(response: 0.3), value: isActive)
    }
}

// MARK: - Current Node Indicator
struct CurrentNodeIndicator: View {
    let node: AlgorithmNode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: iconForNodeType)
                    .font(.headline)
                    .foregroundColor(colorForNodeType)
                
                Text(node.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                if node.critical {
                    Label("Critical", systemImage: "exclamationmark.triangle.fill")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            
            if !node.content.isEmpty {
                Text(node.content)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding()
        .background(.regularMaterial)
        .cornerRadius(12)
        .shadow(radius: 4)
    }
    
    private var iconForNodeType: String {
        switch node.nodeType {
        case .decision: return "arrow.triangle.branch"
        case .assessment: return "stethoscope"
        case .intervention, .action: return "cross.case.fill"
        case .medication: return "pills.fill"
        case .endpoint: return "checkmark.circle.fill"
        }
    }
    
    private var colorForNodeType: Color {
        if node.critical { return .red }
        switch node.nodeType {
        case .decision: return .blue
        case .assessment: return .orange
        case .intervention, .action: return .green
        case .medication: return .purple
        case .endpoint: return .gray
        }
    }
}

// MARK: - Zoom Controls
struct ZoomControls: View {
    @Binding var zoomScale: CGFloat
    private let minZoom: CGFloat = 0.5
    private let maxZoom: CGFloat = 2.0
    
    var body: some View {
        VStack(spacing: 8) {
            Button(action: { zoomIn() }) {
                Image(systemName: "plus.magnifyingglass")
                    .font(.title3)
                    .frame(width: 44, height: 44)
                    .background(.regularMaterial)
                    .clipShape(Circle())
            }
            
            Button(action: { resetZoom() }) {
                Text("\(Int(zoomScale * 100))%")
                    .font(.caption)
                    .fontWeight(.medium)
                    .frame(width: 44, height: 44)
                    .background(.regularMaterial)
                    .clipShape(Circle())
            }
            
            Button(action: { zoomOut() }) {
                Image(systemName: "minus.magnifyingglass")
                    .font(.title3)
                    .frame(width: 44, height: 44)
                    .background(.regularMaterial)
                    .clipShape(Circle())
            }
        }
        .shadow(radius: 4)
    }
    
    private func zoomIn() {
        withAnimation(.spring(response: 0.3)) {
            zoomScale = min(zoomScale + 0.2, maxZoom)
        }
    }
    
    private func zoomOut() {
        withAnimation(.spring(response: 0.3)) {
            zoomScale = max(zoomScale - 0.2, minZoom)
        }
    }
    
    private func resetZoom() {
        withAnimation(.spring(response: 0.3)) {
            zoomScale = 1.0
        }
    }
}

// MARK: - Focus Ring Component
struct FocusRing: View {
    let nodeColor: Color
    let scale: CGFloat
    
    var body: some View {
        Circle()
            .stroke(
                LinearGradient(
                    colors: [nodeColor.opacity(0.8), nodeColor.opacity(0.2)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 4
            )
            .frame(width: 160, height: 160)
            .scaleEffect(scale)
            .opacity(0.8)
    }
}

// MARK: - Particle Effects Component
struct ParticleEffects: View {
    let nodeColor: Color
    @Binding var particleOffset: [CGSize]
    
    var body: some View {
        ZStack {
            ForEach(0..<particleOffset.count, id: \.self) { index in
                Circle()
                    .fill(nodeColor.opacity(0.7))
                    .frame(width: 6, height: 6)
                    .offset(particleOffset[index])
                    .opacity(particleOffset[index] == .zero ? 0 : 1)
                    .blur(radius: 1)
            }
        }
    }
}

// MARK: - Navigation Trail Component
struct NavigationTrail: View {
    let navigationPath: [String]
    let nodePositions: [String: CGPoint]
    
    var body: some View {
        ForEach(0..<max(0, navigationPath.count - 1), id: \.self) { index in
            if let fromPos = nodePositions[navigationPath[index]],
               let toPos = nodePositions[navigationPath[index + 1]] {
                Path { path in
                    path.move(to: fromPos)
                    path.addLine(to: toPos)
                }
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.accentColor.opacity(0.6),
                            Color.accentColor.opacity(0.2)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(
                        lineWidth: 3,
                        lineCap: .round,
                        dash: [10, 5]
                    )
                )
                .opacity(0.8)
            }
        }
    }
}

// MARK: - Mini-Map Overlay
struct MiniMapOverlay: View {
    let algorithm: ProtocolAlgorithm
    @Binding var selectedNodeId: String?
    let nodePositions: [String: CGPoint]
    let onNodeSelect: (String) -> Void
    
    private let mapWidth: CGFloat = 180
    private let mapHeight: CGFloat = 240
    private let nodeSize: CGFloat = 8
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    // Title
                    HStack {
                        Image(systemName: "map.fill")
                            .font(.caption)
                            .foregroundColor(.blue)
                        Text("Protocol Map")
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                    
                    // Mini-map canvas
                    ZStack {
                        // Background
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemBackground).opacity(0.95))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(.separator), lineWidth: 1)
                            )
                        
                        // Scaled node visualization
                        GeometryReader { geometry in
                            let scale = calculateScale(for: geometry.size)
                            
                            ZStack {
                                // Draw connections
                                ForEach(algorithm.nodes, id: \.id) { node in
                                    ForEach(node.connections, id: \.self) { targetId in
                                        if let fromPos = scaledPosition(for: node.id, scale: scale, in: geometry.size),
                                           let toPos = scaledPosition(for: targetId, scale: scale, in: geometry.size) {
                                            Path { path in
                                                path.move(to: fromPos)
                                                path.addLine(to: toPos)
                                            }
                                            .stroke(
                                                Color.secondary.opacity(0.3),
                                                lineWidth: 0.5
                                            )
                                        }
                                    }
                                }
                                
                                // Draw nodes
                                ForEach(algorithm.nodes, id: \.id) { node in
                                    if let position = scaledPosition(for: node.id, scale: scale, in: geometry.size) {
                                        Button(action: {
                                            onNodeSelect(node.id)
                                        }) {
                                            Circle()
                                                .fill(miniMapNodeColor(for: node))
                                                .frame(width: nodeSize, height: nodeSize)
                                                .overlay(
                                                    Circle()
                                                        .stroke(
                                                            selectedNodeId == node.id ? Color.blue : Color.clear,
                                                            lineWidth: 2
                                                        )
                                                )
                                                .scaleEffect(selectedNodeId == node.id ? 1.5 : 1.0)
                                                .animation(.spring(response: 0.3), value: selectedNodeId)
                                        }
                                        .position(position)
                                    }
                                }
                                
                                // Current viewport indicator
                                if let currentId = selectedNodeId,
                                   let position = scaledPosition(for: currentId, scale: scale, in: geometry.size) {
                                    Circle()
                                        .stroke(Color.blue, lineWidth: 2)
                                        .frame(width: 30, height: 30)
                                        .position(position)
                                        .opacity(0.5)
                                        .animation(.easeInOut(duration: 0.3), value: selectedNodeId)
                                }
                            }
                        }
                        .frame(width: mapWidth, height: mapHeight)
                    }
                    .frame(width: mapWidth, height: mapHeight)
                    
                    // Legend
                    VStack(alignment: .leading, spacing: 2) {
                        legendItem(color: .blue, text: "Decision")
                        legendItem(color: .orange, text: "Assessment")
                        legendItem(color: .green, text: "Action")
                        if algorithm.nodes.contains(where: { $0.critical }) {
                            legendItem(color: .red, text: "Critical")
                        }
                    }
                    .font(.system(size: 9))
                    .padding(.top, 4)
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.regularMaterial)
                        .shadow(radius: 8)
                )
                
                Spacer()
            }
            
            Spacer()
        }
        .padding(16)
    }
    
    private func calculateScale(for size: CGSize) -> CGFloat {
        guard !nodePositions.isEmpty else { return 1.0 }
        
        let positions = nodePositions.values
        let minX = positions.map { $0.x }.min() ?? 0
        let maxX = positions.map { $0.x }.max() ?? 100
        let minY = positions.map { $0.y }.min() ?? 0
        let maxY = positions.map { $0.y }.max() ?? 100
        
        let width = maxX - minX
        let height = maxY - minY
        
        guard width > 0 && height > 0 else { return 1.0 }
        
        let scaleX = (size.width - 20) / width
        let scaleY = (size.height - 20) / height
        
        return min(scaleX, scaleY, 1.0)
    }
    
    private func scaledPosition(for nodeId: String, scale: CGFloat, in size: CGSize) -> CGPoint? {
        guard let originalPos = nodePositions[nodeId] else { return nil }
        
        let positions = nodePositions.values
        let minX = positions.map { $0.x }.min() ?? 0
        let minY = positions.map { $0.y }.min() ?? 0
        
        let scaledX = (originalPos.x - minX) * scale + 10
        let scaledY = (originalPos.y - minY) * scale + 10
        
        return CGPoint(x: scaledX, y: scaledY)
    }
    
    private func miniMapNodeColor(for node: AlgorithmNode) -> Color {
        if node.critical { return .red }
        switch node.nodeType {
        case .decision: return .blue.opacity(0.8)
        case .assessment: return .orange.opacity(0.8)
        case .intervention, .action: return .green.opacity(0.8)
        case .medication: return .purple.opacity(0.8)
        case .endpoint: return .gray.opacity(0.8)
        }
    }
    
    private func legendItem(color: Color, text: String) -> some View {
        HStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 6, height: 6)
            Text(text)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Diamond Shape
struct DiamondShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.closeSubpath()
        return path
    }
}

// MARK: - Preview
#Preview {
    SnapFlowchartView(
        algorithm: ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "start",
                title: "Emergency Start",
                nodeType: .decision,
                critical: true,
                content: "Begin emergency protocol with immediate assessment",
                connections: ["assess", "urgent"]
            ),
            AlgorithmNode(
                id: "assess",
                title: "Patient Assessment",
                nodeType: .assessment,
                critical: false,
                content: "Comprehensive patient evaluation and vital signs",
                connections: ["intervene"]
            ),
            AlgorithmNode(
                id: "urgent",
                title: "Urgent Action",
                nodeType: .action,
                critical: true,
                content: "Immediate life-saving intervention required",
                connections: ["medication"]
            ),
            AlgorithmNode(
                id: "medication",
                title: "Drug Administration",
                nodeType: .medication,
                critical: true,
                content: "Administer emergency medications per protocol",
                connections: ["intervene"]
            ),
            AlgorithmNode(
                id: "intervene",
                title: "Medical Intervention",
                nodeType: .intervention,
                critical: false,
                content: "Perform necessary medical procedures",
                connections: ["monitor", "end"]
            ),
            AlgorithmNode(
                id: "monitor",
                title: "Continuous Monitoring",
                nodeType: .assessment,
                critical: false,
                content: "Monitor patient response and vital signs",
                connections: ["end"]
            ),
            AlgorithmNode(
                id: "end",
                title: "Protocol Complete",
                nodeType: .endpoint,
                critical: false,
                content: "Emergency protocol successfully completed",
                connections: []
            )
        ]),
        selectedNodeId: .constant("start"),
        onNodeSelect: { nodeId in
            print("Selected node: \(nodeId)")
        }
    )
    .preferredColorScheme(.dark)
}