import SwiftUI

// MARK: - Enhanced Grid Protocol Card with Modern Visual Design
public struct GridProtocolCard: View {
    let title: String
    let icon: String
    let category: ProtocolCategory
    let cardHeight: CGFloat
    let isUrgent: Bool
    
    @State private var isPressed = false
    @State private var shimmerOffset: CGFloat = -1
    @Environment(\.colorScheme) private var colorScheme
    
    public init(title: String, icon: String, category: ProtocolCategory, cardHeight: CGFloat = 100, isUrgent: Bool = false) {
        self.title = title
        self.icon = icon
        self.category = category
        self.cardHeight = cardHeight
        self.isUrgent = isUrgent
    }
    
    public var body: some View {
        ZStack {
            // Large background icon
            Group {
                if icon.contains(".") || icon.contains("_") {
                    Image(systemName: icon)
                        .font(.system(size: cardHeight * 0.5, weight: .bold))
                } else {
                    SimpleMedicalIcon(shortenTitle(title), size: cardHeight * 0.5)
                }
            }
            .foregroundColor(.white.opacity(0.15))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Content overlay
            VStack {
                Spacer()
                
                // Title overlay with background for readability
                Text(shortenTitle(title))
                    .font(.system(size: fontSize, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.6)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .background(
                        Color.black.opacity(0.3)
                            .blur(radius: 8)
                    )
                    .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)
                
                Spacer().frame(height: 4)
            }
            .frame(width: cardHeight, height: cardHeight)
            .padding(4)
            .background(
                ZStack {
                    // Main gradient background
                    RoundedRectangle(cornerRadius: 14)
                        .fill(
                            LinearGradient(
                                colors: enhancedGradientColors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    // Glass morphism overlay
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Material.ultraThinMaterial.opacity(colorScheme == .dark ? 0.15 : 0.1))
                    
                    // Top highlight
                    VStack {
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.15),
                                Color.white.opacity(0)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: cardHeight * 0.3)
                        .mask(
                            RoundedRectangle(cornerRadius: 14)
                        )
                        Spacer()
                    }
                }
            )
            
            // Shimmer effect for premium feel
            if colorScheme == .light && !isPressed {
                GeometryReader { geometry in
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0),
                            Color.white.opacity(0.4),
                            Color.white.opacity(0)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: 60)
                    .offset(x: shimmerOffset * geometry.size.width)
                    .mask(RoundedRectangle(cornerRadius: 14))
                    .allowsHitTesting(false)
                }
                .onAppear {
                    withAnimation(
                        Animation.linear(duration: 3)
                            .repeatForever(autoreverses: false)
                    ) {
                        shimmerOffset = 2
                    }
                }
            }
        }
        .shadow(
            color: shadowColor,
            radius: isPressed ? 2 : 4,
            x: 0,
            y: isPressed ? 1 : 2
        )
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
        .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity) {
            // Never triggers
        } onPressingChanged: { pressing in
            withAnimation(.easeInOut(duration: 0.15)) {
                isPressed = pressing
            }
            if pressing {
                HapticFeedback.impact(.light)
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var iconSize: CGFloat {
        cardHeight * 0.5
    }
    
    private var fontSize: CGFloat {
        cardHeight < 60 ? 8 : cardHeight < 80 ? 9 : cardHeight < 100 ? 10 : 11
    }
    
    private var pulseScale: CGFloat {
        isUrgent ? 1.3 : 1.0
    }
    
    private var categoryLabel: String {
        switch category {
        case .cardiac: return "CARDIAC"
        case .neurological: return "NEURO"
        case .respiratory: return "RESPIRATORY"
        case .trauma: return "TRAUMA"
        case .infectious: return "INFECTIOUS"
        case .allergic: return "ALLERGIC"
        case .support: return "SUPPORT"
        }
    }
    
    private var enhancedGradientColors: [Color] {
        switch category {
        case .cardiac:
            return colorScheme == .dark ?
                [Color(red: 0.65, green: 0.08, blue: 0.18), Color(red: 0.85, green: 0.18, blue: 0.28)] :
                [Color(red: 0.95, green: 0.15, blue: 0.25), Color(red: 1.0, green: 0.35, blue: 0.45)]
        case .neurological:
            return colorScheme == .dark ?
                [Color(red: 0.45, green: 0.25, blue: 0.65), Color(red: 0.55, green: 0.35, blue: 0.75)] :
                [Color(red: 0.60, green: 0.40, blue: 0.85), Color(red: 0.70, green: 0.50, blue: 0.95)]
        case .respiratory:
            return colorScheme == .dark ?
                [Color(red: 0.15, green: 0.40, blue: 0.65), Color(red: 0.25, green: 0.50, blue: 0.75)] :
                [Color(red: 0.25, green: 0.60, blue: 0.90), Color(red: 0.35, green: 0.70, blue: 1.0)]
        case .trauma:
            return colorScheme == .dark ?
                [Color(red: 0.75, green: 0.35, blue: 0.15), Color(red: 0.85, green: 0.45, blue: 0.25)] :
                [Color(red: 0.95, green: 0.45, blue: 0.20), Color(red: 1.0, green: 0.55, blue: 0.30)]
        case .infectious:
            return colorScheme == .dark ?
                [Color(red: 0.15, green: 0.55, blue: 0.35), Color(red: 0.25, green: 0.65, blue: 0.45)] :
                [Color(red: 0.20, green: 0.70, blue: 0.45), Color(red: 0.30, green: 0.80, blue: 0.55)]
        case .allergic:
            return colorScheme == .dark ?
                [Color(red: 0.65, green: 0.25, blue: 0.55), Color(red: 0.75, green: 0.35, blue: 0.65)] :
                [Color(red: 0.90, green: 0.35, blue: 0.70), Color(red: 1.0, green: 0.45, blue: 0.80)]
        case .support:
            return colorScheme == .dark ?
                [Color(red: 0.25, green: 0.50, blue: 0.55), Color(red: 0.35, green: 0.60, blue: 0.65)] :
                [Color(red: 0.30, green: 0.70, blue: 0.75), Color(red: 0.40, green: 0.80, blue: 0.85)]
        }
    }
    
    private var gradientColors: [Color] {
        enhancedGradientColors
    }
    
    private var shadowColor: Color {
        colorScheme == .dark ?
            Color.black.opacity(0.6) :
            gradientColors.first?.opacity(0.4) ?? Color.black.opacity(0.2)
    }
    
    private func shortenTitle(_ title: String) -> String {
        // More aggressive title shortening
        var shortened = title
            // Remove all superfluous words first
            .replacingOccurrences(of: " Evaluation", with: "")
            .replacingOccurrences(of: " Assessment", with: "")
            .replacingOccurrences(of: " Management", with: "")
            .replacingOccurrences(of: " Protocol", with: "")
            .replacingOccurrences(of: " Guidelines", with: "")
            .replacingOccurrences(of: " Criteria", with: "")
            // Specific replacements
            .replacingOccurrences(of: "Chest Pain", with: "Chest Pain")
            .replacingOccurrences(of: "Shortness of Breath/Hypoxia", with: "SOB/Hypoxia")
            .replacingOccurrences(of: "Shortness of Breath", with: "SOB")
            .replacingOccurrences(of: "Altered Mental Status", with: "AMS")
            .replacingOccurrences(of: "Falls Assessment", with: "Falls")
            .replacingOccurrences(of: "Hypotension & Hemorrhage", with: "Hypotension")
            .replacingOccurrences(of: "Acute Heart Failure", with: "Acute HF")
            .replacingOccurrences(of: "Right Heart Failure", with: "Right HF")
            .replacingOccurrences(of: "Hypertensive Emergency", with: "HTN Crisis")
            .replacingOccurrences(of: "Diabetic Ketoacidosis", with: "DKA")
            .replacingOccurrences(of: "Adrenal Crisis", with: "Adrenal")
            .replacingOccurrences(of: "Respiratory Failure", with: "Resp Failure")
            .replacingOccurrences(of: "Acute Exacerbation", with: "Exacerbation")
            .replacingOccurrences(of: "GI Bleeding", with: "GI Bleed")
            .replacingOccurrences(of: "Bowel Obstruction", with: "Bowel Obst")
            .replacingOccurrences(of: "Antiemetic Selection", with: "Antiemetics")
            .replacingOccurrences(of: "Acute Pain", with: "Pain")
            .replacingOccurrences(of: "Opiate Conversion", with: "Opioid Conv")
            .replacingOccurrences(of: "End of Life", with: "EOL")
            .replacingOccurrences(of: "Thrombocytopenia", with: "Low PLT")
            .replacingOccurrences(of: "Coagulopathy", with: "Coags")
            .replacingOccurrences(of: "Hepatic Encephalopathy", with: "Hep Enceph")
            .replacingOccurrences(of: "Renal Failure", with: "Renal")
            .replacingOccurrences(of: "Hypercalcemia", with: "High Ca")
            .replacingOccurrences(of: "Hypocalcemia", with: "Low Ca")
            .replacingOccurrences(of: "Hyperkalemia", with: "High K")
            .replacingOccurrences(of: "Hypokalemia", with: "Low K")
            .replacingOccurrences(of: "Hypernatremia", with: "High Na")
            .replacingOccurrences(of: "Hyponatremia", with: "Low Na")
            .replacingOccurrences(of: "Hyperglycemia", with: "High Gluc")
            .replacingOccurrences(of: "Hypoglycemia", with: "Low Gluc")
            .replacingOccurrences(of: "Hypomagnesemia", with: "Low Mg")
            .replacingOccurrences(of: "Hypophosphatemia", with: "Low Phos")
            .replacingOccurrences(of: "ABG Analysis", with: "ABG")
            .replacingOccurrences(of: "Ventilator Adjustment", with: "Vent")
            .replacingOccurrences(of: "Acid-Base", with: "pH")
        
        // Trim whitespace
        shortened = shortened.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Remove double spaces
        while shortened.contains("  ") {
            shortened = shortened.replacingOccurrences(of: "  ", with: " ")
        }
        
        return shortened
    }
}

#Preview {
    VStack {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 10) {
            GridProtocolCard(title: "Code Blue", icon: "heart", category: .cardiac)
            GridProtocolCard(title: "Code Stroke", icon: "brain", category: .neurological)
            GridProtocolCard(title: "Respiratory", icon: "lungs", category: .respiratory)
            GridProtocolCard(title: "Sepsis", icon: "bacteria", category: .infectious)
            GridProtocolCard(title: "Trauma", icon: "bandage", category: .trauma)
            GridProtocolCard(title: "Allergic", icon: "allergen", category: .allergic)
        }
        .padding()
    }
    .background(Color(.systemGroupedBackground))
}