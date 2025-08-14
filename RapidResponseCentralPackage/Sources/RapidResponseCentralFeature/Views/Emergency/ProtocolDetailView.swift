import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Professional Medical Protocol Detail View with 45/50/5 Layout
public struct ProtocolDetailView: View {
    let proto: EmergencyProtocol
    @State private var selectedNodeId: String?
    @State private var selectedNode: AlgorithmNode?
    @State private var currentCardIndex = 0
    @StateObject private var session: ProtocolSession
    @Environment(\.dismiss) private var dismiss
    @Environment(\.activeProtocolSession) private var activeSession
    @State private var showingEventLog = false
    @State private var showEndProtocolAlert = false
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?
    @State private var isTimerPaused = false
    @State private var lapCount = 0
    @State private var lastLapTime: TimeInterval = 0
    // Removed expandedSections - cards now update dynamically
    
    public init(protocol proto: EmergencyProtocol) {
        self.proto = proto
        self._session = StateObject(wrappedValue: ProtocolSession(
            protocolId: proto.id,
            protocolTitle: proto.title,
            location: nil
        ))
        // Pre-select the first node immediately
        let firstNode = proto.algorithm.nodes.first
        self._selectedNodeId = State(initialValue: firstNode?.id)
        self._selectedNode = State(initialValue: firstNode)
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // TOP 38%: Ultra-Efficient Clinical Cards with proper spacing
                VStack(spacing: 0) {
                    // Add proper top padding to avoid navigation bar overlap
                    Color.clear
                        .frame(height: 8) // Reduced from 20 to 8 for better space usage
                    
                    // Protocol header with timer
                    HStack(spacing: 12) {
                        Text(proto.title)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.primary)
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                        
                        // Enhanced timer display with controls
                        if session.isActive {
                            HStack(spacing: 6) {
                                Image(systemName: "timer")
                                    .font(.system(size: 14))
                                    .foregroundColor(.blue)
                                
                                Text(formattedTime)
                                    .font(.system(size: 14, design: .monospaced))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                    .fixedSize() // This ensures the text stays on one line
                                
                                // Timer controls
                                HStack(spacing: 4) {
                                    // Rewind 10s
                                    Button(action: { adjustTime(-10) }) {
                                        Image(systemName: "gobackward.10")
                                            .font(.system(size: 12))
                                            .foregroundColor(.primary)
                                    }
                                    .buttonStyle(.plain)
                                    
                                    // Play/Pause
                                    Button(action: toggleTimer) {
                                        Image(systemName: isTimerPaused ? "play.fill" : "pause.fill")
                                            .font(.system(size: 12))
                                            .foregroundColor(.primary)
                                    }
                                    .buttonStyle(.plain)
                                    
                                    // Fast Forward 10s
                                    Button(action: { adjustTime(10) }) {
                                        Image(systemName: "goforward.10")
                                            .font(.system(size: 12))
                                            .foregroundColor(.primary)
                                    }
                                    .buttonStyle(.plain)
                                    
                                    // Lap button
                                    Button(action: addLapMarker) {
                                        HStack(spacing: 2) {
                                            Image(systemName: "timer")
                                                .font(.system(size: 10))
                                            if lapCount > 0 {
                                                Text("\(lapCount)")
                                                    .font(.system(size: 9, weight: .medium))
                                            }
                                        }
                                        .foregroundColor(.orange)
                                    }
                                    .buttonStyle(.plain)
                                }
                                
                                Divider()
                                    .frame(height: 20)
                                
                                // End Protocol button - red square with X
                                Button(action: { showEndProtocolAlert = true }) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(Color.red)
                                            .frame(width: 32, height: 32)
                                        
                                        Image(systemName: "xmark")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                }
                                .buttonStyle(.plain)
                                .accessibilityLabel("End protocol")
                                .accessibilityHint("Double tap to end the current protocol")
                                .accessibilityAddTraits(.isButton)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(Color(.systemGray6))
                            )
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.systemBackground))
                    .overlay(
                        Rectangle()
                            .fill(Color(.systemGray5))
                            .frame(height: 1),
                        alignment: .bottom
                    )
                    
                    // Dynamic cards - NO SCROLLING - all must fit on screen
                    NodeSpecificCards(
                        allCards: proto.cards,
                        selectedNode: selectedNode,
                        currentNodeIndex: getCurrentStepNumber() - 1,
                        totalNodes: proto.algorithm.nodes.count,
                        onNodeSelect: { nodeId in
                            if let node = proto.algorithm.nodes.first(where: { $0.id == nodeId }) {
                                handleNodeSelection(node)
                            }
                        },
                        onPrevious: navigateToPreviousNode,
                        onNext: navigateToNextNode
                    )
                    .padding(.bottom, 4) // Minimal padding
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, 8) // Small horizontal padding
                    .background(Color(.systemBackground))
            }
            .frame(height: geometry.size.height * 0.35)  // Reduced to 35% to prevent card overlap with back button
            .layoutPriority(1)
            
            // Divider
            Rectangle()
                .fill(Color(.systemGray4))
                .frame(height: 1)
            
            // MIDDLE 45%: Compact Flowchart
            VStack(spacing: 0) {
                // Minimal header
                HStack {
                    Text("PROTOCOL FLOW")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.secondary)
                    
                    if let selectedNode {
                        Spacer()
                        HStack(spacing: 3) {
                            Image(systemName: selectedNode.critical ? "exclamationmark.triangle.fill" : "circle.fill")
                            Text(selectedNode.critical ? "CRITICAL" : "ACTIVE")
                        }
                        .font(.caption2)
                        .foregroundColor(selectedNode.critical ? .red : .blue)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 1)
                        .background(
                            Capsule()
                                .fill((selectedNode.critical ? Color.red : Color.blue).opacity(0.1))
                        )
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .frame(maxHeight: 30)
                .background(Color(.systemGray6))
                
                // Snap-to-node flowchart with branching
                SnapFlowchartView(
                    algorithm: proto.algorithm,
                    selectedNodeId: $selectedNodeId,
                    onNodeSelect: { nodeId in
                        if let node = proto.algorithm.nodes.first(where: { $0.id == nodeId }) {
                            handleNodeSelection(node)
                        }
                    }
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground))
            }
            .frame(height: geometry.size.height * 0.55)  // Increased to 55% for better flowchart visibility
            .layoutPriority(0.8)
            
            // Divider
            Rectangle()
                .fill(Color(.systemGray4))
                .frame(height: 1)
            
            // BOTTOM 10%: Horizontal Protocol Flow Navigation
            ProtocolFlowNavigationPanel(
                nodes: proto.algorithm.nodes,
                selectedNodeId: $selectedNodeId,
                onNodeSelect: { nodeId in
                    if let node = proto.algorithm.nodes.first(where: { $0.id == nodeId }) {
                        handleNodeSelection(node)
                    }
                }
            )
            .frame(height: geometry.size.height * 0.10)  // Use percentage for consistent layout
            }
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .navigationBarTitleDisplayMode(.inline)
        .padding(.top, 1) // Small additional padding to ensure no overlap
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
                HStack(spacing: 12) {
                    Button(action: { showingEventLog.toggle() }) {
                        Image(systemName: "list.bullet.clipboard")
                            .foregroundColor(.blue)
                    }
                    
                    if !session.isActive {
                        Button(action: { 
                            session.start()
                            startTimer()
                            // Set as active session in ContentView
                        }) {
                            Label("Start", systemImage: "play.fill")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.green)
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            // Start protocol session when view appears
            ProtocolSessionManager.shared.startSession(
                protocolId: proto.id,
                protocolTitle: proto.title,
                location: nil
            )
            
            // Start timer if session is already active
            if session.isActive {
                startTimer()
            }
            
            // Force selection of first node and trigger immediate update
            if let firstNode = proto.algorithm.nodes.first {
                // Set initial selection immediately
                selectedNodeId = firstNode.id
                selectedNode = firstNode
                
                // Then trigger the handle function after a brief delay for UI to settle
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    handleNodeSelection(firstNode)
                }
            }
        }
        .sheet(isPresented: $showingEventLog) {
            EventLogModal(session: session)
        }
        .alert("End Protocol?", isPresented: $showEndProtocolAlert) {
            Button("Cancel", role: .cancel) { }
            Button("End Protocol", role: .destructive) {
                session.endSession()
                stopTimer()
                dismiss()
            }
        } message: {
            Text("Are you sure you want to end this protocol?")
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    // MARK: - Flowchart Node Component
    
    private func flowchartNode(_ node: AlgorithmNode) -> some View {
        VStack(spacing: 6) {
            HStack(spacing: 8) {
                // Node type icon
                nodeIcon(for: node)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(node.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    
                    if !node.content.isEmpty {
                        Text(node.content)
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                            .lineLimit(3)
                    }
                }
                
                Spacer()
                
                if node.critical {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.red)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(selectedNodeId == node.id ? nodeTypeColor(node.nodeType).opacity(0.1) : Color(.systemGray6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        selectedNodeId == node.id ? nodeTypeColor(node.nodeType) : Color(.systemGray4),
                        lineWidth: selectedNodeId == node.id ? 2 : 1
                    )
            )
            .shadow(
                color: selectedNodeId == node.id ? nodeTypeColor(node.nodeType).opacity(0.2) : Color.black.opacity(0.05),
                radius: selectedNodeId == node.id ? 4 : 1,
                x: 0,
                y: 1
            )
        }
    }
    
    private func nodeIcon(for node: AlgorithmNode) -> some View {
        ZStack {
            Group {
                switch node.nodeType {
                case .decision:
                    Diamond()
                        .fill(nodeTypeColor(node.nodeType).opacity(0.2))
                case .assessment, .intervention, .medication, .action:
                    RoundedRectangle(cornerRadius: 4)
                        .fill(nodeTypeColor(node.nodeType).opacity(0.2))
                case .endpoint:
                    Circle()
                        .fill(nodeTypeColor(node.nodeType).opacity(0.2))
                }
            }
            .frame(width: 24, height: 24)
            
            Image(systemName: nodeTypeIcon(node.nodeType))
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(nodeTypeColor(node.nodeType))
        }
    }
    
    // MARK: - Node Selection Handler
    
    private func handleNodeSelection(_ node: AlgorithmNode) {
        withAnimation(.easeInOut(duration: 0.2)) {
            selectedNodeId = node.id
            selectedNode = node
            
            // Update card index based on node selection
            switch node.nodeType {
            case .assessment:
                currentCardIndex = proto.cards.firstIndex { $0.type == .assessment } ?? 0
            case .intervention, .medication, .action:
                currentCardIndex = proto.cards.firstIndex { $0.type == .actions } ?? 0
            case .decision, .endpoint:
                currentCardIndex = proto.cards.firstIndex { $0.type == .dynamic } ?? 0
            }
        }
        
        // Log the node transition
        let currentTime = Date().timeIntervalSince(session.startTime)
        let event = EventLogEntry(
            relativeTime: currentTime,
            type: .algorithmNode,
            description: "Navigated to: \(node.title)"
        )
        session.addEvent(event)
    }
    
    private func navigateToPreviousNode() {
        guard let currentNode = selectedNode,
              let currentIndex = proto.algorithm.nodes.firstIndex(where: { $0.id == currentNode.id }),
              currentIndex > 0 else { return }
        
        let previousNode = proto.algorithm.nodes[currentIndex - 1]
        handleNodeSelection(previousNode)
    }
    
    private func navigateToNextNode() {
        guard let currentNode = selectedNode,
              let currentIndex = proto.algorithm.nodes.firstIndex(where: { $0.id == currentNode.id }),
              currentIndex < proto.algorithm.nodes.count - 1 else { return }
        
        let nextNode = proto.algorithm.nodes[currentIndex + 1]
        handleNodeSelection(nextNode)
    }
    
    // MARK: - Helper Functions
    
    private func getCurrentStepNumber() -> Int {
        guard let selectedId = selectedNodeId,
              let index = proto.algorithm.nodes.firstIndex(where: { $0.id == selectedId }) else {
            return 1
        }
        return index + 1
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
    
    // MARK: - Timer Helpers
    
    private var formattedTime: String {
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func startTimer() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            Task { @MainActor in
                if !isTimerPaused {
                    elapsedTime += 1
                }
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        elapsedTime = 0
        isTimerPaused = false
        lapCount = 0
        lastLapTime = 0
    }
    
    private func toggleTimer() {
        isTimerPaused.toggle()
        let event = EventLogEntry(
            relativeTime: elapsedTime,
            type: .customNote,
            description: isTimerPaused ? "Timer paused" : "Timer resumed"
        )
        session.addEvent(event)
    }
    
    private func adjustTime(_ seconds: TimeInterval) {
        elapsedTime = max(0, elapsedTime + seconds)
        let event = EventLogEntry(
            relativeTime: elapsedTime,
            type: .customNote,
            description: seconds > 0 ? "Time forward \(Int(seconds))s" : "Time back \(Int(-seconds))s"
        )
        session.addEvent(event)
    }
    
    private func addLapMarker() {
        lapCount += 1
        let splitTime = elapsedTime - lastLapTime
        lastLapTime = elapsedTime
        
        let event = EventLogEntry(
            relativeTime: elapsedTime,
            type: .lapMarker,
            description: "Lap \(lapCount) - Split: \(formatTime(splitTime))",
            additionalNotes: "Total time: \(formattedTime)"
        )
        session.addEvent(event)
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func compactCardSection(_ section: CardSection) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            if !section.title.isEmpty {
                Text(section.title)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.primary)
            }
            
            ForEach(section.items, id: \.self) { item in
                HStack(alignment: .top, spacing: 3) {
                    Text("•")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(.blue)
                    
                    Text(item)
                        .font(.system(size: 9))
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(2)
                }
            }
        }
    }
}

// MARK: - Protocol Flow Navigation Panel
struct ProtocolFlowNavigationPanel: View {
    let nodes: [AlgorithmNode]
    @Binding var selectedNodeId: String?
    let onNodeSelect: (String) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(Array(nodes.enumerated()), id: \.element.id) { index, node in
                    Button(action: { onNodeSelect(node.id) }) {
                        VStack(spacing: 6) {
                            // Node indicator with number
                            ZStack {
                                Circle()
                                    .fill(selectedNodeId == node.id ? Color.blue : Color.gray.opacity(0.2))
                                    .frame(width: 24, height: 24)
                                
                                Text("\(index + 1)")
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundColor(selectedNodeId == node.id ? .white : .secondary)
                            }
                            
                            Text(node.title)
                                .font(.system(size: 11, weight: selectedNodeId == node.id ? .medium : .regular))
                                .foregroundColor(selectedNodeId == node.id ? .primary : .secondary)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .frame(width: 70)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(.horizontal, 4)
                        .padding(.vertical, 8)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
        }
        .frame(maxHeight: .infinity)
        .background(Color(.systemGray6))
    }
}

// MARK: - Diamond Shape for Decision Nodes
struct Diamond: Shape {
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

#Preview {
    NavigationStack {
        ProtocolDetailView(
            protocol: EmergencyProtocol(
                id: "code-blue",
                title: "Code Blue - Cardiac Arrest",
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
                            connections: ["cpr"]
                        ),
                        AlgorithmNode(
                            id: "cpr",
                            title: "Start CPR",
                            nodeType: .intervention,
                            critical: true,
                            content: "30:2 compressions to ventilations",
                            connections: ["rhythm"]
                        ),
                        AlgorithmNode(
                            id: "rhythm",
                            title: "Check Rhythm",
                            nodeType: .decision,
                            critical: false,
                            content: "VF/VT or Asystole/PEA?",
                            connections: ["shock", "continue"]
                        ),
                        AlgorithmNode(
                            id: "shock",
                            title: "Defibrillate",
                            nodeType: .intervention,
                            critical: true,
                            content: "200J biphasic",
                            connections: ["continue"]
                        ),
                        AlgorithmNode(
                            id: "continue",
                            title: "Continue Protocol",
                            nodeType: .endpoint,
                            critical: false,
                            content: "Resume CPR for 2 minutes",
                            connections: []
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
                                title: "Immediate Actions",
                                items: ["Check responsiveness", "Call for help", "Get AED", "Position patient"]
                            ),
                            CardSection(
                                title: "Medications",
                                items: ["Epinephrine 1mg IV/IO q3-5min", "Amiodarone 300mg IV/IO"]
                            )
                        ]
                    ),
                    ProtocolCard(
                        id: "assessment",
                        type: .assessment,
                        title: "Clinical Assessment",
                        sections: [
                            CardSection(
                                title: "Reversible Causes",
                                items: ["Hypoxia", "Hypovolemia", "Hyperkalemia", "Hypothermia", "Toxins", "Thrombosis"]
                            )
                        ]
                    )
                ]
            )
        )
    }
}