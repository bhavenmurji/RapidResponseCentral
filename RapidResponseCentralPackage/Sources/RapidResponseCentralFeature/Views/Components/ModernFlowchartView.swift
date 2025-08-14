import SwiftUI

// MARK: - Modern Flowchart View with Enhanced Aesthetics
public struct ModernFlowchartView: View {
    let algorithm: ProtocolAlgorithm
    @Binding var selectedNodeId: String?
    let onNodeSelect: (String) -> Void
    
    // Visual state
    @State private var zoomScale: CGFloat = 0.9
    @State private var panOffset: CGSize = .zero
    @State private var animateNodes = false
    @State private var pulseAnimation = false
    
    // Layout constants
    private let nodeSpacing: CGFloat = 32
    private let sideMargins: CGFloat = 24
    
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
                // Modern gradient background
                backgroundGradient
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        ForEach(Array(algorithm.nodes.enumerated()), id: \.element.id) { index, node in
                            ModernNodeCard(
                                node: node,
                                isSelected: selectedNodeId == node.id,
                                isFirst: index == 0,
                                isLast: index == algorithm.nodes.count - 1,
                                onTap: { 
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                        onNodeSelect(node.id)
                                    }
                                }
                            )
                            .padding(.horizontal, sideMargins)
                            .opacity(animateNodes ? 1 : 0)
                            .offset(y: animateNodes ? 0 : 20)
                            .animation(
                                .spring(response: 0.5, dampingFraction: 0.8)
                                    .delay(Double(index) * 0.05),
                                value: animateNodes
                            )
                            
                            // Connection line
                            if index < algorithm.nodes.count - 1 {
                                ModernFlowConnection(
                                    from: node,
                                    to: algorithm.nodes[index + 1],
                                    isActive: selectedNodeId == node.id || selectedNodeId == algorithm.nodes[index + 1].id
                                )
                                .opacity(animateNodes ? 1 : 0)
                                .animation(
                                    .easeInOut(duration: 0.3)
                                        .delay(Double(index) * 0.05 + 0.2),
                                    value: animateNodes
                                )
                            }
                        }
                    }
                    .padding(.vertical, 32)
                }
                .scaleEffect(zoomScale)
                
                // Floating zoom controls
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        FloatingZoomControls(
                            zoomScale: $zoomScale,
                            minZoom: 0.7,
                            maxZoom: 1.5
                        )
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
        .onAppear {
            withAnimation {
                animateNodes = true
            }
            // Start pulse animation
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                pulseAnimation = true
            }
        }
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color(red: 0.98, green: 0.98, blue: 1.0),
                Color(red: 0.94, green: 0.95, blue: 0.98)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        .overlay(
            // Subtle pattern overlay
            GeometryReader { _ in
                Image(systemName: "cross.fill")
                    .font(.system(size: 8))
                    .foregroundColor(Color.blue.opacity(0.02))
                    .frame(width: 40, height: 40)
                    .background(
                        ForEach(0..<50, id: \.self) { row in
                            ForEach(0..<20, id: \.self) { col in
                                Image(systemName: "cross.fill")
                                    .font(.system(size: 8))
                                    .foregroundColor(Color.blue.opacity(0.02))
                                    .position(x: CGFloat(col) * 60, y: CGFloat(row) * 60)
                            }
                        }
                    )
            }
            .ignoresSafeArea()
        )
    }
}

// MARK: - Modern Node Card
private struct ModernNodeCard: View {
    let node: AlgorithmNode
    let isSelected: Bool
    let isFirst: Bool
    let isLast: Bool
    let onTap: () -> Void
    
    @State private var isHovered = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Left side indicator
                nodeTypeIndicator
                    .frame(width: 4)
                    .frame(maxHeight: .infinity)
                
                // Content
                VStack(alignment: .leading, spacing: 8) {
                    // Header
                    HStack {
                        Text(node.title)
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(textColor)
                        
                        Spacer()
                        
                        if node.critical {
                            criticalBadge
                        }
                    }
                    
                    // Content
                    if !node.content.isEmpty {
                        Text(node.content)
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                            .lineLimit(3)
                            .multilineTextAlignment(.leading)
                    }
                    
                    // Node type badge
                    HStack {
                        nodeTypeBadge
                        Spacer()
                        if isSelected {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.system(size: 16))
                        }
                    }
                }
                .padding(.vertical, 14)
                .padding(.trailing, 16)
            }
            .background(cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(
                color: shadowColor,
                radius: isSelected ? 12 : 6,
                x: 0,
                y: isSelected ? 4 : 2
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: isSelected ? 2 : 0)
            )
            .scaleEffect(isHovered ? 1.02 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
    }
    
    private var nodeTypeIndicator: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(indicatorGradient)
    }
    
    private var indicatorGradient: LinearGradient {
        LinearGradient(
            colors: gradientColors,
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    private var gradientColors: [Color] {
        switch node.nodeType {
        case .decision:
            return [Color.blue, Color.blue.opacity(0.7)]
        case .action:
            return [Color.green, Color.green.opacity(0.7)]
        case .assessment:
            return [Color.orange, Color.orange.opacity(0.7)]
        case .intervention:
            return [Color.purple, Color.purple.opacity(0.7)]
        case .medication:
            return [Color.pink, Color.pink.opacity(0.7)]
        case .endpoint:
            return node.critical ? [Color.red, Color.red.opacity(0.7)] : [Color.gray, Color.gray.opacity(0.7)]
        }
    }
    
    private var cardBackground: some View {
        Group {
            if isSelected {
                LinearGradient(
                    colors: [
                        Color(UIColor.systemBackground),
                        Color(UIColor.secondarySystemBackground)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            } else {
                Color(UIColor.secondarySystemBackground)
            }
        }
    }
    
    private var borderColor: Color {
        if isSelected {
            switch node.nodeType {
            case .decision: return .blue
            case .action: return .green
            case .assessment: return .orange
            case .intervention: return .purple
            case .medication: return .pink
            case .endpoint: return node.critical ? .red : .gray
            }
        }
        return .clear
    }
    
    private var shadowColor: Color {
        if isSelected {
            return borderColor.opacity(0.3)
        }
        return Color.black.opacity(colorScheme == .dark ? 0.3 : 0.1)
    }
    
    private var textColor: Color {
        if node.critical {
            return .red
        } else if isFirst {
            return .blue
        }
        return .primary
    }
    
    private var criticalBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 12))
            Text("CRITICAL")
                .font(.system(size: 10, weight: .bold))
        }
        .foregroundColor(.white)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            Capsule()
                .fill(Color.red)
        )
    }
    
    private var nodeTypeBadge: some View {
        Text(nodeTypeText)
            .font(.system(size: 11, weight: .medium))
            .foregroundColor(borderColor == .clear ? .secondary : borderColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(
                Capsule()
                    .fill(borderColor.opacity(0.1))
            )
            .overlay(
                Capsule()
                    .stroke(borderColor.opacity(0.3), lineWidth: 1)
            )
    }
    
    private var nodeTypeText: String {
        switch node.nodeType {
        case .decision: return "DECISION"
        case .action: return "ACTION"
        case .assessment: return "ASSESS"
        case .intervention: return "INTERVENE"
        case .medication: return "MEDICATION"
        case .endpoint: return isLast ? "COMPLETE" : "ENDPOINT"
        }
    }
}

// MARK: - Modern Flow Connection
private struct ModernFlowConnection: View {
    let from: AlgorithmNode
    let to: AlgorithmNode
    let isActive: Bool
    
    @State private var animateArrow = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Connection line
            VStack(spacing: 4) {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(dotColor)
                        .frame(width: 4, height: 4)
                        .opacity(animateArrow ? 1 : 0.5)
                        .animation(
                            .easeInOut(duration: 0.5)
                                .delay(Double(index) * 0.1)
                                .repeatForever(autoreverses: true),
                            value: animateArrow
                        )
                }
            }
            .frame(height: 24)
            
            // Arrow
            Image(systemName: "chevron.down")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(arrowColor)
                .scaleEffect(animateArrow ? 1.1 : 1.0)
                .animation(
                    .easeInOut(duration: 1)
                        .repeatForever(autoreverses: true),
                    value: animateArrow
                )
        }
        .frame(height: nodeSpacing)
        .onAppear {
            if isActive {
                animateArrow = true
            }
        }
        .onChange(of: isActive) { _, newValue in
            animateArrow = newValue
        }
    }
    
    private var nodeSpacing: CGFloat { 32 }
    
    private var dotColor: Color {
        if isActive {
            return connectionColor(for: from.nodeType)
        }
        return Color.gray.opacity(0.3)
    }
    
    private var arrowColor: Color {
        if isActive {
            return connectionColor(for: to.nodeType)
        }
        return Color.gray.opacity(0.5)
    }
    
    private func connectionColor(for nodeType: NodeType) -> Color {
        switch nodeType {
        case .decision: return .blue
        case .action: return .green
        case .assessment: return .orange
        case .intervention: return .purple
        case .medication: return .pink
        case .endpoint: return .red
        }
    }
}

// MARK: - Floating Zoom Controls
private struct FloatingZoomControls: View {
    @Binding var zoomScale: CGFloat
    let minZoom: CGFloat
    let maxZoom: CGFloat
    
    var body: some View {
        VStack(spacing: 12) {
            // Zoom in
            Button(action: zoomIn) {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .medium))
                    .frame(width: 44, height: 44)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
            }
            .disabled(zoomScale >= maxZoom)
            
            // Reset
            Button(action: resetZoom) {
                Image(systemName: "viewfinder")
                    .font(.system(size: 18, weight: .medium))
                    .frame(width: 44, height: 44)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
            }
            
            // Zoom out
            Button(action: zoomOut) {
                Image(systemName: "minus")
                    .font(.system(size: 18, weight: .medium))
                    .frame(width: 44, height: 44)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
            }
            .disabled(zoomScale <= minZoom)
        }
    }
    
    private func zoomIn() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            zoomScale = min(zoomScale + 0.2, maxZoom)
        }
    }
    
    private func zoomOut() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            zoomScale = max(zoomScale - 0.2, minZoom)
        }
    }
    
    private func resetZoom() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            zoomScale = 0.9
        }
    }
}

#Preview {
    ModernFlowchartView(
        algorithm: ProtocolAlgorithm(nodes: [
            AlgorithmNode(
                id: "1",
                title: "Initial Assessment",
                nodeType: .assessment,
                critical: true,
                content: "Check vital signs and responsiveness",
                connections: ["2"]
            ),
            AlgorithmNode(
                id: "2",
                title: "Decision Point",
                nodeType: .decision,
                critical: false,
                content: "Is patient responsive?",
                connections: ["3", "4"]
            ),
            AlgorithmNode(
                id: "3",
                title: "Intervention",
                nodeType: .intervention,
                critical: true,
                content: "Begin CPR immediately",
                connections: ["5"]
            )
        ]),
        selectedNodeId: .constant(nil),
        onNodeSelect: { _ in }
    )
}