import SwiftUI
import os.log
import QuartzCore

public struct ContentView: View {
    @State private var selectedTab: AppTab = .emergencies
    @State private var activeSession: ProtocolSession?
    @State private var showingSettings = false
    @State private var showingWelcome = !UserDefaults.standard.bool(forKey: "hasSeenWelcome")
    @State private var showingPerformanceMonitor = false
    @StateObject private var protocolService = ProtocolService()
    
    public init() {}
    
    public var body: some View {
        ZStack {
            // Main content structure
            VStack(spacing: 0) {
                // Main content area with tabs (will show menu content)
                TabView(selection: $selectedTab) {
                EmergencyHomeView()
                    .tag(AppTab.emergencies)
                    .environmentObject(protocolService)
                    .task {
                        await protocolService.loadTabProtocols(.emergencies)
                    }
                
                RRTHomeView()
                    .tag(AppTab.rrt)
                    .environmentObject(protocolService)
                    .task {
                        await protocolService.loadTabProtocols(.rrt)
                    }
                
                CallsHomeView()
                    .tag(AppTab.calls)
                    .environmentObject(protocolService)
                    .task {
                        await protocolService.loadTabProtocols(.calls)
                    }
                
                LabsHomeView()
                    .tag(AppTab.labs)
                    .environmentObject(protocolService)
                    .task {
                        await protocolService.loadTabProtocols(.labs)
                    }
                
                CalculatorsHomeView()
                    .tag(AppTab.calc)
                
                ChatHomeView()
                    .tag(AppTab.chat)
                
                StudyHomeView()
                    .tag(AppTab.study)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                // Tab Bar - fixed at bottom
                CustomTabBar(selectedTab: $selectedTab)
                    .frame(height: 49)
                    .background(Color(UIColor.systemBackground))
                    .shadow(color: Color.black.opacity(0.1), radius: 2, y: -2)
            }
            
            // Timer banner overlay at top
            VStack {
                if let session = activeSession, session.isActive {
                    ProtocolTimerBanner(session: session)
                        .background(.ultraThinMaterial)
                        .shadow(color: Color.black.opacity(0.1), radius: 2, y: 2)
                }
                Spacer()
            }
            .ignoresSafeArea(.all, edges: .horizontal)
        }
        .overlay(
            // Performance Monitor Floating Button
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        showingPerformanceMonitor.toggle()
                    }) {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .foregroundStyle(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.blue)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    .padding(.trailing, 20)
                    .padding(.top, 100)
                }
                Spacer()
            }
        )
        .environment(\.activeProtocolSession, activeSession)
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        #if os(iOS)
        .fullScreenCover(isPresented: $showingWelcome) {
            WelcomeView(showingWelcome: $showingWelcome)
        }
        #else
        .sheet(isPresented: $showingWelcome) {
            WelcomeView(showingWelcome: $showingWelcome)
        }
        #endif
        // Performance monitor sheet (temporarily disabled)
        // .sheet(isPresented: $showingPerformanceMonitor) {
        //     PerformanceMonitorView()
        //         .presentationDetents([.medium, .large])
        //         .presentationDragIndicator(.visible)
        // }
        .onAppear {
            startPerformanceTracking()
        }
    }
    
    private func startPerformanceTracking() {
        // Performance tracking is now handled by PerformanceMonitorView
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
