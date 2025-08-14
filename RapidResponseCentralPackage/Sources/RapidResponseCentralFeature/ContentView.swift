import SwiftUI
import os.log
import QuartzCore

public struct ContentView: View {
    @State private var selectedTab: AppTab = .emergencies
    @State private var previousTab: AppTab = .emergencies
    @State private var activeSession: ProtocolSession?
    @State private var showingSettings = false
    @State private var showingWelcome = !UserDefaults.standard.bool(forKey: "hasSeenWelcome")
    @State private var showingPerformanceMonitor = false
    @State private var showingMoreMenu = false
    @StateObject private var protocolService = ProtocolService()
    
    // Navigation paths for each tab to control navigation programmatically
    @State private var emergencyPath = NavigationPath()
    @State private var rrtPath = NavigationPath()
    @State private var callsPath = NavigationPath()
    @State private var labsPath = NavigationPath()
    
    public init() {}
    
    public var body: some View {
        ZStack {
            // Main content structure
            VStack(spacing: 0) {
                // Main content area with tabs (will show menu content)
                TabView(selection: $selectedTab) {
                NavigationStack(path: $emergencyPath) {
                    EmergencyHomeView(navigationPath: $emergencyPath)
                        .navigationDestination(for: EmergencyProtocol.self) { proto in
                            ProtocolDetailView(protocol: proto)
                        }
                        .toolbar(.hidden, for: .tabBar)
                }
                    .tag(AppTab.emergencies)
                    .environmentObject(protocolService)
                    .task {
                        await protocolService.loadTabProtocols(.emergencies)
                    }
                
                NavigationStack(path: $rrtPath) {
                    RRTHomeView(navigationPath: $rrtPath)
                        .navigationDestination(for: EmergencyProtocol.self) { proto in
                            ProtocolDetailView(protocol: proto)
                        }
                        .toolbar(.hidden, for: .tabBar)
                }
                    .tag(AppTab.rrt)
                    .environmentObject(protocolService)
                    .task {
                        await protocolService.loadTabProtocols(.rrt)
                    }
                
                NavigationStack(path: $callsPath) {
                    CallsHomeView(navigationPath: $callsPath)
                        .navigationDestination(for: EmergencyProtocol.self) { proto in
                            ProtocolDetailView(protocol: proto)
                        }
                        .toolbar(.hidden, for: .tabBar)
                }
                    .tag(AppTab.calls)
                    .environmentObject(protocolService)
                    .task {
                        await protocolService.loadTabProtocols(.calls)
                    }
                
                NavigationStack(path: $labsPath) {
                    LabsHomeView(navigationPath: $labsPath)
                        .navigationDestination(for: EmergencyProtocol.self) { proto in
                            ProtocolDetailView(protocol: proto)
                        }
                        .toolbar(.hidden, for: .tabBar)
                }
                    .tag(AppTab.labs)
                    .environmentObject(protocolService)
                    .task {
                        await protocolService.loadTabProtocols(.labs)
                    }
                
                NavigationStack {
                    CalculatorsHomeView()
                        .toolbar(.hidden, for: .tabBar)
                }
                    .tag(AppTab.calc)
                    .environmentObject(protocolService)
                    .task {
                        await protocolService.loadTabProtocols(.calc)
                    }
                
                NavigationStack {
                    ChatHomeView()
                        .toolbar(.hidden, for: .tabBar)
                }
                    .tag(AppTab.chat)
                
                NavigationStack {
                    StudyHomeView()
                        .toolbar(.hidden, for: .tabBar)
                }
                    .tag(AppTab.study)
                
                // More tab - shows empty view, handled by sheet
                Color.clear
                    .tag(AppTab.more)
                    .toolbar(.hidden, for: .tabBar)
                }
                
                // Tab Bar - fixed at bottom
                CustomTabBar(selectedTab: Binding(
                    get: { selectedTab },
                    set: { newTab in
                        // Handle More tab specially
                        if newTab == .more {
                            showingMoreMenu = true
                            // Don't actually switch to the More tab
                            return
                        }
                        
                        // If we're on the same tab, pop to root
                        if newTab == selectedTab {
                            popToRoot(for: newTab)
                        } else {
                            // Switching to a different tab - always pop to root
                            popToRoot(for: newTab)
                        }
                        previousTab = selectedTab
                        selectedTab = newTab
                    }
                ))
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
        // Performance monitor moved to toolbar for better UX
        .environment(\.activeProtocolSession, activeSession)
        .sheet(isPresented: $showingMoreMenu) {
            MoreMenuView(selectedTab: $selectedTab)
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showingPerformanceMonitor) {
            if #available(iOS 16.4, *) {
                PerformanceMonitorView()
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 12) {
                    Button(action: {
                        showingPerformanceMonitor.toggle()
                    }) {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .foregroundStyle(.blue)
                    }
                    Button(action: {
                        showingSettings.toggle()
                    }) {
                        Image(systemName: "gear")
                    }
                }
            }
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
    
    private func popToRoot(for tab: AppTab) {
        switch tab {
        case .emergencies:
            emergencyPath = NavigationPath()
        case .rrt:
            rrtPath = NavigationPath()
        case .calls:
            callsPath = NavigationPath()
        case .labs:
            labsPath = NavigationPath()
        default:
            break
        }
    }
}

public enum AppTab: String, CaseIterable {
    case emergencies = "Codes"
    case rrt = "RRTs"
    case calls = "Calls"
    case labs = "Labs"
    case calc = "Calcs"
    case more = "More"
    // Hidden tabs (accessible through More menu)
    case chat = "Chat"
    case study = "Study"
    
    // Define which tabs are visible in the tab bar
    static var visibleTabs: [AppTab] {
        [.emergencies, .rrt, .calls, .labs, .calc, .more]
    }
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
