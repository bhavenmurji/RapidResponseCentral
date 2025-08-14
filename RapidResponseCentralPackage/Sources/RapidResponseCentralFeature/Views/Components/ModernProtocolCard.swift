import SwiftUI

// MARK: - Modern Protocol Card with Glassmorphism and Animations
public struct ModernProtocolCard: View {
    let title: String
    let icon: String
    let category: ProtocolCategory
    let isUrgent: Bool
    let cardHeight: CGFloat
    
    @State private var isPressed = false
    @State private var shimmerPhase: CGFloat = 0
    @Environment(\.colorScheme) private var colorScheme
    
    public init(title: String, icon: String, category: ProtocolCategory, isUrgent: Bool = false, cardHeight: CGFloat = 140) {
        self.title = title
        self.icon = icon
        self.category = category
        self.isUrgent = isUrgent
        self.cardHeight = cardHeight
    }
    
    public var body: some View {
        ZStack {
            // Background gradient
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                .fill(
                    LinearGradient(
                        colors: gradientColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    // Shimmer effect for urgent cards
                    isUrgent ? 
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0),
                                    Color.white.opacity(0.3),
                                    Color.white.opacity(0)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .offset(x: shimmerPhase)
                        .animation(
                            Animation.linear(duration: 2)
                                .repeatForever(autoreverses: false),
                            value: shimmerPhase
                        )
                    : nil
                )
            
            // Glass overlay
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                .fill(
                    Material.ultraThinMaterial.opacity(colorScheme == .dark ? 0.3 : 0.5)
                )
            
            // Content
            VStack(alignment: .leading, spacing: 8) {
                // Icon row
                HStack {
                    // Icon with pulse animation for urgent
                    ZStack {
                        if isUrgent {
                            Circle()
                                .fill(Color.white.opacity(0.2))
                                .frame(width: 56, height: 56)  // Larger to accommodate 42px icon
                                .scaleEffect(isPressed ? 0.9 : 1.0)
                        }
                        
                        // Use SimpleMedicalIcon for clean, large icons
                        SimpleMedicalIcon(
                            title,
                            size: 42  // Large size for better visibility
                        )
                        .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
                    }
                    
                    Spacer()
                    
                    if isUrgent {
                        PulsingDot()
                    }
                }
                
                Spacer()
                
                // Title with improved typography
                Text(title)
                    .font(DesignSystem.Typography.cardTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
                    .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
                
                // Category tag
                HStack {
                    Text(category.rawValue.uppercased())
                        .font(DesignSystem.Typography.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.2))
                        )
                    
                    Spacer()
                }
            }
            .padding(DesignSystem.Spacing.md)
        }
        .frame(height: cardHeight)
        .shadow(
            color: shadowColor,
            radius: isPressed ? 4 : 8,
            x: 0,
            y: isPressed ? 2 : 4
        )
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(DesignSystem.Animation.springBounce, value: isPressed)
        .onAppear {
            if isUrgent {
                shimmerPhase = 200
            }
        }
        .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity) {
            // Never triggers
        } onPressingChanged: { pressing in
            withAnimation(DesignSystem.Animation.quick) {
                isPressed = pressing
            }
            if pressing {
                HapticFeedback.impact(.medium)
            }
        }
    }
    
    private var gradientColors: [Color] {
        // Use gradient from MedicalIconSystem
        let gradient = MedicalIconSystem.gradient(for: category, scheme: colorScheme)
        // Extract colors from gradient (this is a workaround to get colors from LinearGradient)
        switch category {
        case .cardiac:
            return [MedicalIconSystem.Colors.red1(for: colorScheme), MedicalIconSystem.Colors.red2(for: colorScheme)]
        case .neurological:
            return [MedicalIconSystem.Colors.purple1(for: colorScheme), MedicalIconSystem.Colors.purple2(for: colorScheme)]
        case .respiratory:
            return [MedicalIconSystem.Colors.blue1(for: colorScheme), MedicalIconSystem.Colors.blue2(for: colorScheme)]
        case .trauma:
            return [MedicalIconSystem.Colors.orange1(for: colorScheme), MedicalIconSystem.Colors.orange2(for: colorScheme)]
        case .infectious:
            return [MedicalIconSystem.Colors.green1(for: colorScheme), MedicalIconSystem.Colors.green2(for: colorScheme)]
        case .allergic:
            return [MedicalIconSystem.Colors.pink1(for: colorScheme), MedicalIconSystem.Colors.pink2(for: colorScheme)]
        case .support:
            return [MedicalIconSystem.Colors.teal1(for: colorScheme), MedicalIconSystem.Colors.teal2(for: colorScheme)]
        }
    }
    
    private var shadowColor: Color {
        colorScheme == .dark ?
            gradientColors.first?.opacity(0.2) ?? Color.black.opacity(0.3) :
            gradientColors.first?.opacity(0.3) ?? Color.black.opacity(0.2)
    }
}

// MARK: - Pulsing Dot for Urgent Cards
struct PulsingDot: View {
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 1.0
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.red)
                .frame(width: 8, height: 8)
            
            Circle()
                .stroke(Color.red, lineWidth: 1)
                .frame(width: 8, height: 8)
                .scaleEffect(scale)
                .opacity(opacity)
        }
        .onAppear {
            withAnimation(
                Animation.easeInOut(duration: 1.0)
                    .repeatForever(autoreverses: false)
            ) {
                scale = 2.5
                opacity = 0
            }
        }
    }
}

// MARK: - Compact Modern Card for Lists
public struct CompactModernCard: View {
    let title: String
    let subtitle: String?
    let icon: String
    let accentColor: Color
    
    @State private var isPressed = false
    
    public var body: some View {
        HStack(spacing: DesignSystem.Spacing.md) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                    .fill(
                        LinearGradient(
                            colors: [
                                accentColor.opacity(0.8),
                                accentColor
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 44, height: 44)
                
                BoxiconView(iconName: icon, size: 22)
                    .foregroundColor(.white)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(DesignSystem.Typography.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(DesignSystem.Typography.caption1)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            // Chevron
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color(UIColor.tertiaryLabel))
        }
        .padding(DesignSystem.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                .fill(Color(UIColor.secondarySystemBackground))
                .shadow(
                    color: Color.black.opacity(0.05),
                    radius: 4,
                    x: 0,
                    y: 2
                )
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(DesignSystem.Animation.quick, value: isPressed)
        .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity) {
            // Never triggers
        } onPressingChanged: { pressing in
            withAnimation(DesignSystem.Animation.quick) {
                isPressed = pressing
            }
            if pressing {
                HapticFeedback.impact(.light)
            }
        }
    }
}

#Preview("Modern Protocol Card") {
    VStack(spacing: 16) {
        ModernProtocolCard(
            title: "Code Blue",
            icon: "bx-heart",
            category: .cardiac,
            isUrgent: true
        )
        
        ModernProtocolCard(
            title: "Code Stroke",
            icon: "bx-brain",
            category: .neurological,
            isUrgent: false
        )
    }
    .padding()
    .background(Color(UIColor.systemGroupedBackground))
}