import SwiftUI

struct ProtocolDetailView: View {
    let proto: EmergencyProtocol
    @State private var selectedNodeId: String?
    @State private var currentCardIndex = 0
    @StateObject private var session: ProtocolSession
    @Environment(\.dismiss) private var dismiss
    
    init(proto: EmergencyProtocol) {
        self.proto = proto
        self._session = StateObject(wrappedValue: ProtocolSession(
            protocolId: proto.id,
            protocolTitle: proto.title,
            location: nil
        ))
    }
    
    var body: some View {
        GeometryReader { outerGeometry in
            VStack(spacing: 0) {
                // Timer Banner
                ProtocolTimerBanner(session: session)
                    .background(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.1), radius: 2, y: 2)
                
                // 50/50 Split Layout
                GeometryReader { geometry in
                    VStack(spacing: 0) {
                        // Top Panel: Dynamic Information Cards (50%)
                        TabView(selection: $currentCardIndex) {
                            ForEach(Array(proto.cards.enumerated()), id: \.offset) { index, card in
                                ScrollView {
                                    ProtocolCardView(card: card)
                                        .padding(.horizontal, outerGeometry.safeAreaInsets.leading > 0 ? 0 : 16)
                                        .padding(.vertical, 16)
                                }
                                .tag(index)
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .automatic))
                        .frame(height: max(200, geometry.size.height * 0.45))
                        .background(Color(.systemBackground))
                        
                        Divider()
                        
                        // Bottom Panel: Interactive Algorithm Flowchart (50%)
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Decision Tree Flowchart")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text("Tap nodes to navigate")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal, outerGeometry.safeAreaInsets.leading > 0 ? 16 : 20)
                            .padding(.top, 8)
                            
                            FlowchartView(
                                algorithm: proto.algorithm,
                                selectedNodeId: $selectedNodeId,
                                onNodeSelect: { nodeId in
                                    handleNodeSelection(nodeId)
                                }
                            )
                            .padding(.horizontal, outerGeometry.safeAreaInsets.leading > 0 ? 0 : 4)
                        }
                        .frame(height: max(200, geometry.size.height * 0.45))
                        .background(Color(.systemGroupedBackground))
                    }
                }
            }
            .edgesIgnoringSafeArea(.horizontal)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("End") {
                    dismiss()
                }
                .foregroundColor(.red)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
            }
        }
        .onAppear {
            // Select first node
            if selectedNodeId == nil, let firstNode = proto.algorithm.nodes.first {
                selectedNodeId = firstNode.id
            }
        }
    }
    
    private func handleNodeSelection(_ nodeId: String) {
        selectedNodeId = nodeId
        
        // Update card index based on node selection
        if let node = proto.algorithm.nodes.first(where: { $0.id == nodeId }) {
            switch node.nodeType {
            case .assessment:
                currentCardIndex = min(1, proto.cards.count - 1) // Assessment card if available
            case .intervention, .medication:
                currentCardIndex = min(2, proto.cards.count - 1) // Actions card if available
            case .decision, .endpoint:
                currentCardIndex = 0 // Dynamic content card
            }
        }
        
        // Log the node transition
        let currentTime = Date().timeIntervalSince(session.startTime)
        let event = EventLogEntry(
            relativeTime: currentTime,
            type: .algorithmNode,
            description: "Moved to: \(proto.algorithm.nodes.first(where: { $0.id == nodeId })?.title ?? nodeId)"
        )
        session.addEvent(event)
    }
}

struct ProtocolCardView: View {
    let card: ProtocolCard
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Card Header
            HStack {
                Image(systemName: iconForCardType(card.type))
                    .font(.subheadline)
                    .foregroundColor(colorForCardType(card.type))
                
                Text(card.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            
            // Card Content
            ForEach(card.sections) { section in
                VStack(alignment: .leading, spacing: 6) {
                    if !section.title.isEmpty {
                        Text(section.title)
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                    }
                    
                    ForEach(section.items, id: \.self) { item in
                        HStack(alignment: .top, spacing: 6) {
                            Text("•")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(item)
                                .font(.caption)
                                .fixedSize(horizontal: false, vertical: true)
                                .lineLimit(nil)
                        }
                    }
                }
                .padding(.vertical, 2)
            }
            
            Spacer(minLength: 20)
        }
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
}

struct AlgorithmFlowView: View {
    let algorithm: ProtocolAlgorithm
    @Binding var selectedNodeId: String?
    let onNodeSelect: (String) -> Void
    
    var body: some View {
        // Simple vertical layout for now - can be enhanced with proper flowchart layout
        VStack(alignment: .leading, spacing: 16) {
            ForEach(algorithm.nodes) { node in
                AlgorithmNodeView(
                    node: node,
                    isSelected: selectedNodeId == node.id,
                    onTap: {
                        onNodeSelect(node.id)
                    }
                )
            }
        }
        .frame(minWidth: 300)
    }
}

struct AlgorithmNodeView: View {
    let node: AlgorithmNode
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 10) {
                // Node Icon
                Image(systemName: iconForNodeType(node.nodeType))
                    .font(.caption)
                    .foregroundColor(.white)
                    .frame(width: 28, height: 28)
                    .background(backgroundColorForNode(node))
                    .clipShape(RoundedRectangle(cornerRadius: node.nodeType == .endpoint ? 14 : 6))
                
                // Node Content
                VStack(alignment: .leading, spacing: 3) {
                    Text(node.title)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(node.critical ? .red : .primary)
                        .lineLimit(1)
                    
                    Text(node.content)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    if !node.connections.isEmpty {
                        Text("→ Next options available")
                            .font(.caption2)
                            .foregroundColor(.blue)
                            .italic()
                    }
                }
                
                Spacer(minLength: 8)
                
                // Selection indicator
                if isSelected {
                    Image(systemName: "chevron.right.circle.fill")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? Color.blue.opacity(0.1) : Color(.systemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Color.blue : Color(.separator), lineWidth: isSelected ? 2 : 0.5)
            )
        }
        .buttonStyle(.plain)
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
    
    private func iconForNodeType(_ type: NodeType) -> String {
        switch type {
        case .decision:
            return "questionmark.diamond"
        case .assessment:
            return "stethoscope"
        case .intervention:
            return "cross.case"
        case .medication:
            return "pills"
        case .endpoint:
            return "checkmark.circle"
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
    NavigationStack {
        ProtocolDetailView(
            proto: EmergencyProtocol(
                id: "code-blue",
                title: "Code Blue",
                icon: "heart.fill",
                category: .cardiac,
                algorithm: ProtocolAlgorithm(
                    nodes: [
                        AlgorithmNode(
                            id: "start",
                            title: "Unresponsive Patient",
                            nodeType: .assessment,
                            critical: true,
                            content: "Check pulse and breathing",
                            connections: ["cpr", "shock"]
                        )
                    ]
                ),
                cards: [
                    ProtocolCard(
                        id: "dynamic",
                        type: .dynamic,
                        title: "Current Step",
                        sections: [
                            CardSection(
                                title: "Actions",
                                items: ["Check responsiveness", "Call for help", "Get AED"]
                            )
                        ]
                    )
                ]
            )
        )
    }
}