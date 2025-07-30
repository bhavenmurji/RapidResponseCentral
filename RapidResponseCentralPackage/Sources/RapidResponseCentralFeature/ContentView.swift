import SwiftUI

public struct ContentView: View {
    @State private var selectedTab: AppTab = .emergencies
    @State private var activeSession: ProtocolSession?
    @State private var showingSettings = false
    @State private var showingWelcome = !UserDefaults.standard.bool(forKey: "hasSeenWelcome")
    
    public init() {}
    
    public var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                EmergencyHomeView()
                    .tabItem {
                        Label("Emerg", systemImage: "exclamationmark.triangle.fill")
                    }
                    .tag(AppTab.emergencies)
                
                RRTHomeView()
                    .tabItem {
                        Label("RRT", systemImage: "circle.fill")
                    }
                    .tag(AppTab.rrt)
                
                CallsHomeView()
                    .tabItem {
                        Label("Calls", systemImage: "phone.fill")
                    }
                    .tag(AppTab.calls)
                
                LabsHomeView()
                    .tabItem {
                        Label("Labs", systemImage: "flask.fill")
                    }
                    .tag(AppTab.labs)
                
                CalculatorsHomeView()
                    .tabItem {
                        Label("Calc", systemImage: "function")
                    }
                    .tag(AppTab.calc)
                
                ChatHomeView()
                    .tabItem {
                        Label("Chat", systemImage: "message.fill")
                    }
                    .tag(AppTab.chat)
                
                StudyHomeView()
                    .tabItem {
                        Label("Study", systemImage: "book.fill")
                    }
                    .tag(AppTab.study)
            }
            .accentColor(.blue)
            
            // Active protocol timer banner
            if let session = activeSession, session.isActive {
                VStack {
                    ProtocolTimerBanner(session: session)
                        .background(.ultraThinMaterial)
                    Spacer()
                }
                .ignoresSafeArea(.all, edges: .horizontal)
            }
        }
        .environment(\.activeProtocolSession, activeSession)
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .fullScreenCover(isPresented: $showingWelcome) {
            WelcomeView(showingWelcome: $showingWelcome)
        }
    }
}

public enum AppTab: String, CaseIterable {
    case emergencies = "Emergencies"
    case rrt = "RRT"
    case calls = "Calls"
    case labs = "Labs"
    case calc = "Calc"
    case chat = "Chat"
    case study = "Study"
}

// MARK: - Environment Key for Active Session

@MainActor
private struct ActiveProtocolSessionKey: @preconcurrency EnvironmentKey {
    nonisolated(unsafe) static let defaultValue: ProtocolSession? = nil
}

extension EnvironmentValues {
    var activeProtocolSession: ProtocolSession? {
        get { self[ActiveProtocolSessionKey.self] }
        set { self[ActiveProtocolSessionKey.self] = newValue }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
