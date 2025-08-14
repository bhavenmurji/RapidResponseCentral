import SwiftUI

public struct EmergencyHomeView: View {
    @EnvironmentObject private var protocolService: ProtocolService
    @Binding var navigationPath: NavigationPath
    @State private var selectedProtocol: EmergencyProtocol?
    @State private var searchText = ""
    @State private var animateCards = false
    @Environment(\.colorScheme) private var colorScheme
    
    public init(navigationPath: Binding<NavigationPath> = .constant(NavigationPath())) {
        self._navigationPath = navigationPath
    }
    
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    // Define urgent protocols - removed Code STEMI as it should only highlight when active
    private let urgentProtocols: [String] = []
    
    public var body: some View {
        ZStack {
            // Background gradient adapted for dark mode
            LinearGradient(
                colors: colorScheme == .dark ? [
                    Color(UIColor.systemBackground),
                    Color(UIColor.systemBackground).opacity(0.98)
                ] : [
                    Color(UIColor.systemBackground),
                    Color(UIColor.systemBackground).opacity(0.95)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Universal Protocol Timer Banner - appears when protocol is active
                UniversalProtocolTimerBanner()
                
                // Consistent Protocol Menu Header
                ProtocolMenuHeader(
                    searchText: $searchText,
                    protocolCount: filteredProtocols.count,
                    protocolType: "protocols"
                )
                
                // Main content without ScrollView - fit everything on one screen
                VStack(spacing: 8) {
                    
                    // Emergency Cards - SMART DR style with large circular icons
                    VStack(spacing: 12) {
                        ForEach(Array(filteredProtocols.enumerated()), id: \.element.id) { index, proto in
                            NavigationLink(value: proto) {
                                HStack(spacing: 16) {
                                    // Large circular icon with Health Icons
                                    ZStack {
                                        Circle()
                                            .fill(iconBackgroundColor(for: proto.category))
                                            .frame(width: 60, height: 60)
                                        
                                        HealthIconView(proto.title, size: 32, color: .white)
                                    }
                                    
                                    Text(proto.title)
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.primary)
                                        .lineLimit(2)
                                        .multilineTextAlignment(.leading)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.secondary.opacity(0.5))
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color(UIColor.secondarySystemBackground))
                                        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            .opacity(animateCards ? 1 : 0)
                            .offset(y: animateCards ? 0 : 20)
                            .animation(
                                DesignSystem.Animation.springBounce
                                    .delay(Double(index) * 0.05),
                                value: animateCards
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    Spacer(minLength: 8)
                    
                    // Emergency Support Card - at bottom
                    EmergencySupportCard()
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                }
                .padding(.top, 8)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation {
                animateCards = true
            }
        }
    }
    
    private var filteredProtocols: [EmergencyProtocol] {
        if searchText.isEmpty {
            return protocolService.protocols
        } else {
            return protocolService.protocols.filter { proto in
                proto.title.localizedCaseInsensitiveContains(searchText) ||
                proto.category.rawValue.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    private func iconBackgroundColor(for category: ProtocolCategory) -> Color {
        switch category {
        case .cardiac:
            return Color(red: 0.95, green: 0.26, blue: 0.21) // Bright red
        case .neurological:
            return Color(red: 0.61, green: 0.35, blue: 0.71) // Purple
        case .respiratory:
            return Color(red: 0.13, green: 0.59, blue: 0.95) // Blue
        case .trauma:
            return Color(red: 1.0, green: 0.60, blue: 0.0) // Orange
        case .infectious:
            return Color(red: 0.30, green: 0.69, blue: 0.31) // Green
        case .allergic:
            return Color(red: 0.91, green: 0.12, blue: 0.39) // Pink
        case .support:
            return Color(red: 0.46, green: 0.46, blue: 0.50) // Gray
        }
    }
    
    private func iconForProtocol(_ title: String) -> String {
        // Map to unique icons for each emergency protocol
        switch title {
        case "Code Blue - ACLS":
            return "heart.text.square.fill"
        case "Code Stroke":
            return "brain"
        case "Code STEMI":
            return "waveform.path.ecg.rectangle.fill"
        case "RSI":
            return "lungs.fill"
        case "Shock & ECMO":
            return "bolt.heart.fill"
        case "Anaphylaxis":
            return "allergens"
        case "Emergency Support":
            return "phone.circle.fill"
        default:
            return "cross.case.fill"
        }
    }
}

// MARK: - Search Bar Component
struct SearchBarView: View {
    @Binding var searchText: String
    @FocusState private var isFocused: Bool
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                    .font(.system(size: 16, weight: .medium))
                
                TextField("Search protocols...", text: $searchText)
                    .font(DesignSystem.Typography.body)
                    .focused($isFocused)
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                        isFocused = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                            .font(.system(size: 16))
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                    .fill(colorScheme == .dark ? 
                        Color(UIColor.secondarySystemBackground) :
                        Color(UIColor.secondarySystemBackground)
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                    .stroke(
                        isFocused ? DesignSystem.Colors.primaryBlue : Color(UIColor.separator).opacity(0.5),
                        lineWidth: isFocused ? 2 : 1
                    )
            )
            .animation(DesignSystem.Animation.quick, value: isFocused)
        }
    }
}

// Using UniversalEmergencySupportCard for all protocol pages

#Preview {
    NavigationStack {
        EmergencyHomeView()
            .environmentObject(ProtocolService())
    }
}