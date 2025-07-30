import SwiftUI

struct ProtocolTimerBanner: View {
    let session: ProtocolSession
    @State private var timer: Timer?
    @State private var elapsedTime: TimeInterval = 0
    @State private var isPlaying = true
    @State private var showingEventLog = false
    
    var body: some View {
        HStack(spacing: 8) {
            // Protocol Name
            Text(session.protocolTitle)
                .font(.caption)
                .fontWeight(.medium)
                .lineLimit(1)
                .frame(minWidth: 60, maxWidth: 100)
            
            Spacer()
            
            // Time controls and display
            HStack(spacing: 4) {
                // Time adjustment buttons
                TimeAdjustButton(seconds: -60, action: adjustTime)
                TimeAdjustButton(seconds: -30, action: adjustTime)
                TimeAdjustButton(seconds: -10, action: adjustTime)
                
                // Timer Display
                Text(formattedTime)
                    .font(.system(.body, design: .monospaced))
                    .fontWeight(.bold)
                    .frame(minWidth: 60)
                    .padding(.horizontal, 8)
                
                TimeAdjustButton(seconds: 10, action: adjustTime)
                TimeAdjustButton(seconds: 30, action: adjustTime)
                TimeAdjustButton(seconds: 60, action: adjustTime)
            }
            
            Spacer()
            
            // Control Buttons
            HStack(spacing: 12) {
                // Play/Pause
                Button(action: toggleTimer) {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(.caption)
                        .foregroundColor(.primary)
                }
                .buttonStyle(.plain)
                
                // Reset
                Button(action: resetTimer) {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.caption)
                        .foregroundColor(.primary)
                }
                .buttonStyle(.plain)
                
                // Lap
                Button(action: addLapMarker) {
                    Image(systemName: "timer")
                        .font(.caption)
                        .foregroundColor(.primary)
                }
                .buttonStyle(.plain)
                
                // Event Log
                Button(action: { showingEventLog = true }) {
                    Image(systemName: "list.bullet")
                        .font(.caption)
                        .foregroundColor(.primary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
        .sheet(isPresented: $showingEventLog) {
            EventLogModal(session: session)
        }
    }
    
    private var formattedTime: String {
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
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
            addEvent(.customNote, description: "Timer paused")
        } else {
            addEvent(.customNote, description: "Timer resumed")
        }
    }
    
    private func resetTimer() {
        elapsedTime = 0
        addEvent(.customNote, description: "Timer reset")
    }
    
    private func adjustTime(_ seconds: TimeInterval) {
        elapsedTime = max(0, elapsedTime + seconds)
    }
    
    private func addLapMarker() {
        addEvent(.lapMarker, description: "Lap marker")
    }
    
    private func addEvent(_ type: EventLogEntry.EventType, description: String) {
        let event = EventLogEntry(
            relativeTime: elapsedTime,
            type: type,
            description: description
        )
        session.addEvent(event)
    }
}

struct TimeAdjustButton: View {
    let seconds: Int
    let action: (TimeInterval) -> Void
    
    var iconName: String {
        switch seconds {
        case -60: return "gobackward.60"
        case -30: return "gobackward.30"
        case -10: return "gobackward.10"
        case 10: return "goforward.10"
        case 30: return "goforward.30"
        case 60: return "goforward.60"
        default: return "clock"
        }
    }
    
    var body: some View {
        Button(action: { action(Double(seconds)) }) {
            Image(systemName: iconName)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary)
                .frame(width: 28, height: 28)
                .background(Color(.systemGray6))
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ProtocolTimerBanner(
        session: ProtocolSession(
            protocolId: "code-blue",
            protocolTitle: "Code Blue",
            location: "Room 214"
        )
    )
}