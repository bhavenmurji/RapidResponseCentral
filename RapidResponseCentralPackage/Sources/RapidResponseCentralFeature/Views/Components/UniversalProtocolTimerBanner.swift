import SwiftUI

// MARK: - Universal Protocol Timer Banner
// This banner appears at the top of all menu views when a protocol is active
public struct UniversalProtocolTimerBanner: View {
    @StateObject private var sessionManager = ProtocolSessionManager.shared
    @State private var timer: Timer?
    @State private var elapsedTime: TimeInterval = 0
    @State private var isPlaying = true
    @State private var showingEventLog = false
    
    public init() {}
    
    public var body: some View {
        if let session = sessionManager.activeSession {
            VStack(spacing: 0) {
                // Main Timer Banner
                HStack(spacing: 12) {
                    // Active Protocol Info
                    VStack(alignment: .leading, spacing: 2) {
                        Text("ACTIVE PROTOCOL")
                            .font(.system(size: 9, weight: .semibold))
                            .foregroundColor(.secondary)
                        
                        Text(session.protocolTitle)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.primary)
                            .lineLimit(1)
                        
                        if let location = session.location {
                            Text(location)
                                .font(.system(size: 11))
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    // Timer Display with Controls
                    HStack(spacing: 8) {
                        // Rewind buttons
                        Button(action: { adjustTime(-30) }) {
                            Image(systemName: "gobackward.30")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.primary)
                        }
                        .buttonStyle(.plain)
                        
                        Button(action: { adjustTime(-10) }) {
                            Image(systemName: "gobackward.10")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.primary)
                        }
                        .buttonStyle(.plain)
                        
                        // Timer Display
                        VStack(spacing: 0) {
                            Text(formattedTime)
                                .font(.system(size: 24, weight: .bold, design: .monospaced))
                                .foregroundColor(timerColor)
                            
                            Text(isPlaying ? "RUNNING" : "PAUSED")
                                .font(.system(size: 8, weight: .semibold))
                                .foregroundColor(isPlaying ? .green : .orange)
                        }
                        .frame(minWidth: 80)
                        
                        // Fast forward buttons
                        Button(action: { adjustTime(10) }) {
                            Image(systemName: "goforward.10")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.primary)
                        }
                        .buttonStyle(.plain)
                        
                        Button(action: { adjustTime(30) }) {
                            Image(systemName: "goforward.30")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.primary)
                        }
                        .buttonStyle(.plain)
                    }
                    
                    Spacer()
                    
                    // Control Buttons
                    HStack(spacing: 12) {
                        // Play/Pause
                        Button(action: toggleTimer) {
                            ZStack {
                                Circle()
                                    .fill(isPlaying ? Color.orange : Color.green)
                                    .frame(width: 36, height: 36)
                                
                                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        .buttonStyle(.plain)
                        
                        // Event Log
                        Button(action: { showingEventLog = true }) {
                            ZStack {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 36, height: 36)
                                
                                Image(systemName: "list.bullet.rectangle")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        .buttonStyle(.plain)
                        
                        // Stop/End Protocol
                        Button(action: endProtocol) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(Color.red)
                                    .frame(width: 90, height: 36)
                                
                                HStack(spacing: 4) {
                                    Image(systemName: "stop.fill")
                                        .font(.system(size: 12, weight: .bold))
                                    
                                    Text("END")
                                        .font(.system(size: 12, weight: .bold))
                                }
                                .foregroundColor(.white)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(timerBorderColor, lineWidth: 2)
                        )
                )
                
                // Quick Action Bar
                HStack(spacing: 16) {
                    // Lap Marker
                    Button(action: addLapMarker) {
                        Label("Lap", systemImage: "timer")
                            .font(.caption)
                            .foregroundColor(.primary)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                    
                    // Note
                    Button(action: addNote) {
                        Label("Note", systemImage: "note.text")
                            .font(.caption)
                            .foregroundColor(.primary)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                    
                    // Medication Given
                    Button(action: logMedication) {
                        Label("Med", systemImage: "pills")
                            .font(.caption)
                            .foregroundColor(.primary)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                    
                    Spacer()
                    
                    // Timer Stats
                    HStack(spacing: 8) {
                        Image(systemName: "clock.fill")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("Started: \(session.startTime, formatter: timeFormatter)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(Color(UIColor.secondarySystemBackground).opacity(0.5))
            }
            .onAppear {
                startTimer()
            }
            .onDisappear {
                stopTimer()
            }
            .sheet(isPresented: $showingEventLog) {
                EventLogModal(session: session)
            }
            .alert("End Protocol?", isPresented: $showEndConfirmation) {
                Button("Cancel", role: .cancel) {}
                Button("End Protocol", role: .destructive) {
                    sessionManager.endActiveSession()
                }
            } message: {
                Text("Are you sure you want to end the active protocol? This will save the event log.")
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var formattedTime: String {
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private var timerColor: Color {
        if elapsedTime < 300 { // < 5 minutes
            return .primary
        } else if elapsedTime < 600 { // < 10 minutes
            return .orange
        } else { // >= 10 minutes
            return .red
        }
    }
    
    private var timerBorderColor: Color {
        if isPlaying {
            return timerColor.opacity(0.3)
        } else {
            return Color.orange.opacity(0.5)
        }
    }
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    @State private var showEndConfirmation = false
    
    // MARK: - Actions
    
    private func startTimer() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            Task { @MainActor in
                if isPlaying {
                    elapsedTime += 1
                }
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func toggleTimer() {
        isPlaying.toggle()
        if !isPlaying {
            addEvent(.customNote, description: "Timer paused at \(formattedTime)")
        } else {
            addEvent(.customNote, description: "Timer resumed at \(formattedTime)")
        }
    }
    
    private func adjustTime(_ seconds: TimeInterval) {
        elapsedTime = max(0, elapsedTime + seconds)
        addEvent(.customNote, description: "Time adjusted by \(Int(seconds)) seconds to \(formattedTime)")
    }
    
    private func addLapMarker() {
        addEvent(.lapMarker, description: "Lap marker at \(formattedTime)")
    }
    
    private func addNote() {
        // In a real app, this would open a dialog for custom note entry
        addEvent(.customNote, description: "Manual note added")
    }
    
    private func logMedication() {
        // In a real app, this would open a medication logging dialog
        addEvent(.medication, description: "Medication administered")
    }
    
    private func endProtocol() {
        showEndConfirmation = true
    }
    
    private func addEvent(_ type: EventLogEntry.EventType, description: String) {
        guard let session = sessionManager.activeSession else { return }
        let event = EventLogEntry(
            relativeTime: elapsedTime,
            type: type,
            description: description
        )
        session.addEvent(event)
    }
}

// MARK: - Protocol Session Manager
// Singleton to manage active protocol sessions across the app
@MainActor
public class ProtocolSessionManager: ObservableObject {
    public static let shared = ProtocolSessionManager()
    
    @Published public var activeSession: ProtocolSession?
    @Published public var sessionHistory: [ProtocolSession] = []
    
    private init() {}
    
    public func startSession(protocolId: String, protocolTitle: String, location: String? = nil) {
        // End any existing session
        if let current = activeSession {
            endSession(current)
        }
        
        // Start new session
        let newSession = ProtocolSession(
            protocolId: protocolId,
            protocolTitle: protocolTitle,
            location: location
        )
        activeSession = newSession
        
        // Add initial event
        let startEvent = EventLogEntry(
            relativeTime: 0,
            type: .protocolStart,
            description: "Protocol started: \(protocolTitle)"
        )
        newSession.addEvent(startEvent)
    }
    
    public func endActiveSession() {
        if let session = activeSession {
            endSession(session)
        }
    }
    
    private func endSession(_ session: ProtocolSession) {
        session.endSession()
        sessionHistory.append(session)
        activeSession = nil
    }
    
    public func hasActiveSession() -> Bool {
        return activeSession != nil
    }
}

// MARK: - Preview
#Preview {
    VStack {
        UniversalProtocolTimerBanner()
            .onAppear {
                ProtocolSessionManager.shared.startSession(
                    protocolId: "code-blue",
                    protocolTitle: "Code Blue - ACLS",
                    location: "Room 214"
                )
            }
        
        Spacer()
    }
    .background(Color(.systemBackground))
}