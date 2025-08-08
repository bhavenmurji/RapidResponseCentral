import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Professional Medical Protocol Detail View
public struct ProtocolDetailView: View {
    let proto: EmergencyProtocol
    @State private var selectedNodeId: String?
    @State private var selectedNode: AlgorithmNode?
    @State private var currentCardIndex = 0
    @StateObject private var session: ProtocolSession
    @Environment(\.dismiss) private var dismiss
    @State private var showingEventLog = false
    
    public init(protocol proto: EmergencyProtocol) {
        self.proto = proto
        self._session = StateObject(wrappedValue: ProtocolSession(
            protocolId: proto.id,
            protocolTitle: proto.title,
            location: nil
        ))
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Timer Banner - Fixed Height
                ProtocolTimerBanner(session: session)
                    .frame(height: 60)
                    .background(.regularMaterial)
                    .shadow(color: Color.black.opacity(0.08), radius: 1, y: 1)
                
                // Main Content Area - Proper 45/50/5 Vertical Split
                VStack(spacing: 0) {
                    // TOP (45%): Protocol Information Cards
                    cardsPanel
                        .frame(height: (geometry.size.height - 60) * 0.45)
                    
                    // Horizontal Divider
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .frame(height: 1)
                    
                    // MIDDLE (50%): Flowchart View
                    flowchartPanel
                        .frame(height: (geometry.size.height - 60) * 0.50)
                    
                    // Horizontal Divider
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .frame(height: 1)
                    
                    // BOTTOM (5%): Protocol Flow Navigation
                    protocolFlowPanel
                        .frame(height: (geometry.size.height - 60) * 0.05)
                        .background(Color(.systemGray6))
                }
            }
        }
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(.blue)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 16) {
                    Button(action: { showingEventLog.toggle() }) {
                        Image(systemName: "list.bullet.clipboard")
                            .foregroundColor(.blue)
                    }
                    
                    Button("End Protocol") {
                        dismiss()
                    }
                    .foregroundColor(.red)
                    .fontWeight(.medium)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            // Select first node on appear
            if selectedNodeId == nil, let firstNode = proto.algorithm.nodes.first {
                selectedNodeId = firstNode.id
                selectedNode = firstNode
            }
        }
        .sheet(isPresented: $showingEventLog) {
            EventLogModal(session: session)
        }
    }
    
    // MARK: - Panel Components
    
    // Flowchart Panel (Middle 50%)
    private var flowchartPanel: some View {
        VStack(spacing: 0) {
            // Compact Panel Header for Middle Section
            HStack {
                Text("Protocol Algorithm")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                Spacer()
                if let selectedNode {
                    HStack(spacing: 4) {
                        Image(systemName: selectedNode.critical ? "exclamationmark.triangle.fill" : "info.circle.fill")
                        Text(selectedNode.critical ? "Critical" : "Active")
                    }
                    .font(.caption2)
                    .foregroundColor(selectedNode.critical ? .red : .blue)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(
                        Capsule()
                            .fill((selectedNode.critical ? Color.red : Color.blue).opacity(0.1))
                    )
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(.systemBackground))
            
            Rectangle()
                .fill(Color(.systemGray5))
                .frame(height: 1)
            
            // Flowchart Content
            FigmaOmnichartView(
                algorithm: proto.algorithm,
                selectedNodeId: $selectedNodeId,
                onNodeSelect: { nodeId in
                    if let node = proto.algorithm.nodes.first(where: { $0.id == nodeId }) {
                        handleNodeSelection(node)
                    }
                }
            )
            .background(Color(.systemBackground))
        }
    }
    
    // Information Cards Panel (Top 45%)
    private var cardsPanel: some View {
        VStack(spacing: 0) {
            // Prominent Panel Header for Top Section
            HStack {
                Text("Protocol Information")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                Spacer()
                if !proto.cards.isEmpty {
                    Text("\(currentCardIndex + 1) of \(proto.cards.count)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color(.systemGray6))
                        )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color(.systemBackground))
            
            Rectangle()
                .fill(Color(.systemGray5))
                .frame(height: 1)
            
            // Cards Content
            if !proto.cards.isEmpty {
                TabView(selection: $currentCardIndex) {
                    ForEach(Array(proto.cards.enumerated()), id: \.offset) { index, card in
                        ScrollView {
                            MedicalProtocolCard(
                                card: card,
                                selectedNode: selectedNodeId.flatMap { id in
                                    proto.algorithm.nodes.first { $0.id == id }
                                },
                                algorithm: proto.algorithm,
                                onNodeSelect: { nodeId in
                                    if let node = proto.algorithm.nodes.first(where: { $0.id == nodeId }) {
                                        handleNodeSelection(node)
                                    }
                                }
                            )
                            .padding(16)
                        }
                        .background(Color(.systemBackground))
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            } else {
                VStack {
                    Spacer()
                    Image(systemName: "doc.text")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    Text("No information cards available")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .background(Color(.systemBackground))
            }
        }
    }
    
    // Minimal Protocol Flow Panel (Bottom 5%)
    private var protocolFlowPanel: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Protocol Flow")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                Spacer()
                if let selectedNode {
                    Text("Current: \(selectedNode.title)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 12)
            .padding(.top, 4)
            
            CompactFlowchartView(
                algorithm: proto.algorithm,
                selectedNodeId: $selectedNodeId,
                onNodeSelect: { nodeId in
                    if let node = proto.algorithm.nodes.first(where: { $0.id == nodeId }) {
                        handleNodeSelection(node)
                    }
                }
            )
            .padding(.horizontal, 4)
            .padding(.bottom, 2)
        }
    }
    
    // MARK: - Node Selection Handler
    
    private func handleNodeSelection(_ node: AlgorithmNode) {
        selectedNodeId = node.id
        selectedNode = node
        
        // Update card index based on node selection with smooth animation
        withAnimation(.easeInOut(duration: 0.3)) {
            switch node.nodeType {
            case .assessment:
                currentCardIndex = min(1, proto.cards.count - 1) // Assessment card if available
            case .intervention, .medication, .action:
                currentCardIndex = min(2, proto.cards.count - 1) // Actions card if available
            case .decision, .endpoint:
                currentCardIndex = 0 // Dynamic content card
            }
        }
        
        // Log the node transition for analytics
        let currentTime = Date().timeIntervalSince(session.startTime)
        let event = EventLogEntry(
            relativeTime: currentTime,
            type: .algorithmNode,
            description: "Navigated to: \(node.title)"
        )
        session.addEvent(event)
    }
}

// MARK: - Medical Protocol Card Component

struct MedicalProtocolCard: View {
    let card: ProtocolCard
    let selectedNode: AlgorithmNode?
    let algorithm: ProtocolAlgorithm
    let onNodeSelect: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Professional Card Header
            cardHeader
            
            // Current Node Context (if available)
            if let selectedNode {
                currentNodeContext(selectedNode)
            }
            
            // Card Sections
            ForEach(card.sections) { section in
                cardSection(section)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
    }
    
    private var cardHeader: some View {
        HStack(spacing: 12) {
            // Card Type Icon
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(colorForCardType(card.type).opacity(0.15))
                    .frame(width: 40, height: 40)
                
                Image(systemName: iconForCardType(card.type))
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(colorForCardType(card.type))
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(card.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(cardTypeDescription(card.type))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
    
    private func currentNodeContext(_ node: AlgorithmNode) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("CURRENT STEP")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                Spacer()
                if node.critical {
                    Label("Critical", systemImage: "exclamationmark.triangle.fill")
                        .font(.caption)
                        .foregroundColor(.red)
                        .labelStyle(.titleAndIcon)
                }
            }
            
            HStack(spacing: 12) {
                Image(systemName: nodeTypeIcon(node.nodeType))
                    .font(.title3)
                    .foregroundColor(nodeTypeColor(node.nodeType))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(node.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    if !node.content.isEmpty {
                        Text(node.content)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.tertiarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(node.critical ? Color.red.opacity(0.3) : Color.blue.opacity(0.3), lineWidth: 1)
        )
    }
    
    private func cardSection(_ section: CardSection) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            if !section.title.isEmpty {
                Text(section.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                ForEach(section.items, id: \.self) { item in
                    HStack(alignment: .top, spacing: 8) {
                        Text("•")
                            .font(.subheadline)
                            .foregroundColor(colorForCardType(card.type))
                            .fontWeight(.bold)
                        
                        Text(item)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
    }
    
    // MARK: - Helper Functions
    
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
    
    private func cardTypeDescription(_ type: CardType) -> String {
        switch type {
        case .dynamic:
            return "Context-aware information"
        case .assessment:
            return "Clinical assessment guide"
        case .actions:
            return "Required interventions"
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



#Preview {
    if #available(iOS 16.0, macOS 13.0, *) {
        NavigationStack {
            ProtocolDetailView(
                protocol: EmergencyProtocol(
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
    } else {
        Text("Preview requires iOS 16+")
    }
}