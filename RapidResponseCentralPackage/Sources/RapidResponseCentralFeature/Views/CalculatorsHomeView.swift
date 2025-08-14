import SwiftUI

public struct CalculatorsHomeView: View {
    @EnvironmentObject private var protocolService: ProtocolService
    @State private var searchText = ""
    @State private var selectedCategory: String? = nil
    @State private var animateCards = false
    @Environment(\.colorScheme) private var colorScheme
    
    private let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]
    
    // Calculator categories
    private let categories = [
        "Stroke & Neuro",
        "Cardiac",
        "Sepsis & Infection",
        "Respiratory",
        "Renal & Electrolytes",
        "General"
    ]
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
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
                    // Consistent Protocol Menu Header
                    ProtocolMenuHeader(
                        searchText: $searchText,
                        protocolCount: filteredCalculators.count,
                        protocolType: "calculators"
                    )
                    
                    // Main content - fit everything on screen
                    VStack(spacing: 6) {
                        
                        // Calculators Grid - 3 columns, compact cards
                        ScrollView(.vertical, showsIndicators: false) {
                            LazyVGrid(columns: columns, spacing: 6) {
                                ForEach(Array(filteredCalculators.enumerated()), id: \.element.id) { index, calculator in
                                    NavigationLink(destination: CalculatorDetailView(calculator: calculator)) {
                                        CompactCalculatorCard(
                                            title: calculator.title,
                                            icon: calculator.icon,
                                            category: calculator.category
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .opacity(animateCards ? 1 : 0)
                                    .offset(y: animateCards ? 0 : 20)
                                    .animation(
                                        DesignSystem.Animation.springBounce
                                            .delay(Double(index) * 0.03),
                                        value: animateCards
                                    )
                                }
                            }
                            .padding(.horizontal, 12)
                        }
                    }
                    
                    // Emergency Support Card - Fixed at bottom
                    EmergencySupportCard()
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                        .shadow(
                            color: Color.black.opacity(0.1),
                            radius: 8,
                            x: 0,
                            y: -4
                        )
                }
            }
            .navigationTitle("Calcs")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                withAnimation {
                    animateCards = true
                }
            }
        }
    }
    
    private var filteredCalculators: [EmergencyProtocol] {
        let calculators = protocolService.calculatorsProtocols
        
        if searchText.isEmpty {
            return calculators
        } else {
            return calculators.filter { calc in
                calc.title.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}

// MARK: - Compact Calculator Card Component
struct CompactCalculatorCard: View {
    let title: String
    let icon: String
    let category: ProtocolCategory
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 6) {
            // Circular icon with Health Icons
            ZStack {
                Circle()
                    .fill(categoryColor.opacity(0.9))
                    .frame(width: 36, height: 36)
                
                HealthIconView(title, size: 20, color: .white)
            }
            
            Text(title)
                .font(.system(size: 9, weight: .semibold))
                .foregroundColor(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.7)
        }
        .padding(6)
        .frame(height: 75)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(UIColor.secondarySystemBackground))
                .shadow(
                    color: Color.black.opacity(0.03),
                    radius: 2,
                    x: 0,
                    y: 1
                )
        )
    }
    
    private var categoryColor: Color {
        switch category {
        case .cardiac:
            return .red
        case .neurological:
            return .purple
        case .respiratory:
            return .blue
        case .infectious:
            return .orange
        case .trauma:
            return .pink
        case .allergic:
            return .green
        case .support:
            return .gray
        }
    }
}

// Keep the original CalculatorCard for compatibility
struct CalculatorCard: View {
    let title: String
    let icon: String
    let category: ProtocolCategory
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(categoryColor)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(categoryColor.opacity(0.15))
                    )
                
                Spacer()
                
                Image(systemName: "function")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(DesignSystem.Typography.body)
                    .fontWeight(.semibold)
                    .foregroundColor(colorScheme == .dark ? .white : .primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text(category.rawValue.capitalized)
                    .font(DesignSystem.Typography.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(DesignSystem.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                .fill(colorScheme == .dark ? 
                      Color(UIColor.secondarySystemBackground) : 
                      Color.white)
                .shadow(
                    color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.08),
                    radius: 8,
                    x: 0,
                    y: 2
                )
        )
    }
    
    private var categoryColor: Color {
        switch category {
        case .cardiac:
            return .red
        case .neurological:
            return .purple
        case .respiratory:
            return .blue
        case .infectious:
            return .orange
        case .trauma:
            return .pink
        case .allergic:
            return .green
        case .support:
            return .gray
        }
    }
}

#Preview {
    CalculatorsHomeView()
        .environmentObject(ProtocolService())
}