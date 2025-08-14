import SwiftUI

// MARK: - Design System for RapidResponseCentral
// Modern medical app design system following iOS 18 guidelines

public struct DesignSystem {
    
    // MARK: - Colors
    public struct Colors {
        // Primary Brand Colors
        public static let primaryBlue = Color(red: 0.0, green: 0.478, blue: 0.996)
        public static let primaryRed = Color(red: 1.0, green: 0.231, blue: 0.188)
        
        // Adaptive Colors for Dark Mode
        public static let adaptiveText = Color(UIColor.label)
        public static let adaptiveSecondaryText = Color(UIColor.secondaryLabel)
        public static let adaptiveTertiaryText = Color(UIColor.tertiaryLabel)
        public static let adaptiveBackground = Color(UIColor.systemBackground)
        public static let adaptiveSecondaryBackground = Color(UIColor.secondarySystemBackground)
        public static let adaptiveTertiaryBackground = Color(UIColor.tertiarySystemBackground)
        public static let adaptiveGroupedBackground = Color(UIColor.systemGroupedBackground)
        public static let adaptiveSeparator = Color(UIColor.separator)
        public static let adaptiveFill = Color(UIColor.systemFill)
        public static let adaptiveSecondaryFill = Color(UIColor.secondarySystemFill)
        
        // Medical Category Colors with Gradients
        public static let cardiac = LinearGradient(
            colors: [Color(red: 0.91, green: 0.12, blue: 0.39), 
                    Color(red: 0.98, green: 0.29, blue: 0.51)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        public static let respiratory = LinearGradient(
            colors: [Color(red: 0.20, green: 0.60, blue: 0.86),
                    Color(red: 0.42, green: 0.73, blue: 0.91)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        public static let neurological = LinearGradient(
            colors: [Color(red: 0.58, green: 0.39, blue: 0.87),
                    Color(red: 0.70, green: 0.55, blue: 0.91)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        public static let trauma = LinearGradient(
            colors: [Color(red: 0.95, green: 0.35, blue: 0.15),
                    Color(red: 0.98, green: 0.52, blue: 0.35)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        public static let infectious = LinearGradient(
            colors: [Color(red: 0.13, green: 0.59, blue: 0.95),
                    Color(red: 0.35, green: 0.71, blue: 0.97)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        // Status Colors - Clinical Context Enhanced
        public static let success = Color(red: 0.20, green: 0.78, blue: 0.35)  // Stable/Normal
        public static let warning = Color(red: 1.0, green: 0.58, blue: 0.0)    // Caution/Monitor
        public static let critical = Color(red: 1.0, green: 0.18, blue: 0.33)  // Emergency/Urgent
        public static let info = Color(red: 0.0, green: 0.478, blue: 0.996)    // Information
        
        // Clinical Severity Colors
        public static let severityLow = Color(red: 0.30, green: 0.85, blue: 0.40)
        public static let severityModerate = Color(red: 1.0, green: 0.75, blue: 0.20)
        public static let severityHigh = Color(red: 1.0, green: 0.45, blue: 0.20)
        public static let severityCritical = Color(red: 0.95, green: 0.15, blue: 0.25)
        
        // Action Colors
        public static let actionPrimary = Color(red: 0.0, green: 0.478, blue: 0.996)
        public static let actionSecondary = Color(red: 0.35, green: 0.35, blue: 0.85)
        public static let actionDestructive = Color(red: 1.0, green: 0.231, blue: 0.188)
        
        // Background Colors (Deprecated - Use adaptive versions)
        public static let backgroundPrimary = adaptiveBackground
        public static let backgroundSecondary = adaptiveSecondaryBackground
        public static let backgroundTertiary = adaptiveTertiaryBackground
        
        // Dark Mode Specific Gradients
        public static func cardiacGradient(for scheme: ColorScheme) -> LinearGradient {
            LinearGradient(
                colors: scheme == .dark ? 
                    [Color(red: 0.71, green: 0.08, blue: 0.31), Color(red: 0.88, green: 0.19, blue: 0.41)] :
                    [Color(red: 0.91, green: 0.12, blue: 0.39), Color(red: 0.98, green: 0.29, blue: 0.51)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        
        public static func respiratoryGradient(for scheme: ColorScheme) -> LinearGradient {
            LinearGradient(
                colors: scheme == .dark ?
                    [Color(red: 0.15, green: 0.45, blue: 0.71), Color(red: 0.32, green: 0.58, blue: 0.81)] :
                    [Color(red: 0.20, green: 0.60, blue: 0.86), Color(red: 0.42, green: 0.73, blue: 0.91)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        
        public static func neurologicalGradient(for scheme: ColorScheme) -> LinearGradient {
            LinearGradient(
                colors: scheme == .dark ?
                    [Color(red: 0.48, green: 0.29, blue: 0.77), Color(red: 0.60, green: 0.45, blue: 0.81)] :
                    [Color(red: 0.58, green: 0.39, blue: 0.87), Color(red: 0.70, green: 0.55, blue: 0.91)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        
        // Glass Morphism
        public static func glassTint(for scheme: ColorScheme) -> Color {
            scheme == .dark ? Color.white.opacity(0.05) : Color.white.opacity(0.1)
        }
        
        public static func glassBackground(for scheme: ColorScheme) -> Color {
            scheme == .dark ? 
                Color(UIColor.systemBackground).opacity(0.7) :
                Color(UIColor.systemBackground).opacity(0.8)
        }
    }
    
    // MARK: - Typography (Enhanced for Better Readability)
    public struct Typography {
        // Headers - Increased sizes for better hierarchy
        public static let largeTitle = Font.system(size: 36, weight: .bold, design: .rounded)
        public static let title1 = Font.system(size: 30, weight: .bold, design: .rounded)
        public static let title2 = Font.system(size: 24, weight: .semibold, design: .rounded)
        public static let title3 = Font.system(size: 21, weight: .semibold, design: .rounded)
        
        // Body - Optimized for medical context readability
        public static let headline = Font.system(size: 18, weight: .semibold, design: .default)
        public static let body = Font.system(size: 17, weight: .regular, design: .default)
        public static let callout = Font.system(size: 16, weight: .medium, design: .default)
        public static let subheadline = Font.system(size: 15, weight: .medium, design: .default)
        public static let footnote = Font.system(size: 14, weight: .regular, design: .default)
        public static let caption1 = Font.system(size: 13, weight: .medium, design: .default)
        public static let caption2 = Font.system(size: 12, weight: .regular, design: .default)
        
        // Medical Specific - Enhanced for clinical use
        public static let protocolTitle = Font.system(size: 26, weight: .bold, design: .rounded)
        public static let cardTitle = Font.system(size: 18, weight: .bold, design: .rounded)
        public static let nodeLabel = Font.system(size: 14, weight: .semibold, design: .monospaced)
        public static let timerDisplay = Font.system(size: 22, weight: .bold, design: .monospaced)
        public static let urgentAlert = Font.system(size: 20, weight: .heavy, design: .rounded)
        public static let medicationDose = Font.system(size: 16, weight: .semibold, design: .monospaced)
    }
    
    // MARK: - Spacing
    public struct Spacing {
        public static let xxs: CGFloat = 2
        public static let xs: CGFloat = 4
        public static let sm: CGFloat = 8
        public static let md: CGFloat = 12
        public static let lg: CGFloat = 16
        public static let xl: CGFloat = 20
        public static let xxl: CGFloat = 24
        public static let xxxl: CGFloat = 32
    }
    
    // MARK: - Corner Radius
    public struct CornerRadius {
        public static let small: CGFloat = 8
        public static let medium: CGFloat = 12
        public static let large: CGFloat = 16
        public static let extraLarge: CGFloat = 20
        public static let rounded: CGFloat = 24
    }
    
    // MARK: - Shadows
    public struct Shadows {
        public struct ShadowStyle: Sendable {
            let color: Color
            let radius: CGFloat
            let x: CGFloat
            let y: CGFloat
        }
        
        nonisolated(unsafe) public static let small = ShadowStyle(
            color: Color.black.opacity(0.08),
            radius: 4,
            x: 0,
            y: 2
        )
        
        nonisolated(unsafe) public static let medium = ShadowStyle(
            color: Color.black.opacity(0.12),
            radius: 8,
            x: 0,
            y: 4
        )
        
        nonisolated(unsafe) public static let large = ShadowStyle(
            color: Color.black.opacity(0.15),
            radius: 12,
            x: 0,
            y: 6
        )
        
        nonisolated(unsafe) public static let glass = ShadowStyle(
            color: Color.black.opacity(0.25),
            radius: 20,
            x: 0,
            y: 10
        )
    }
    
    // MARK: - Animation (Enhanced with Medical Context)
    public struct Animation {
        public static let springBounce = SwiftUI.Animation.spring(
            response: 0.4,
            dampingFraction: 0.6,
            blendDuration: 0.25
        )
        
        public static let smooth = SwiftUI.Animation.easeInOut(duration: 0.3)
        public static let quick = SwiftUI.Animation.easeInOut(duration: 0.2)
        public static let slow = SwiftUI.Animation.easeInOut(duration: 0.5)
        
        // Medical-specific animations
        public static let urgent = SwiftUI.Animation.easeInOut(duration: 0.6).repeatForever(autoreverses: true)
        public static let pulse = SwiftUI.Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)
        public static let heartbeat = SwiftUI.Animation.interpolatingSpring(stiffness: 100, damping: 10)
        public static let gentle = SwiftUI.Animation.easeInOut(duration: 0.4)
    }
    
    // MARK: - Clinical Context Indicators
    public struct ClinicalIndicators {
        public static let urgencyHigh = "exclamationmark.triangle.fill"
        public static let urgencyMedium = "exclamationmark.circle.fill"
        public static let urgencyLow = "info.circle.fill"
        public static let timerActive = "timer"
        public static let medicationRequired = "pills.fill"
        public static let assessmentNeeded = "stethoscope"
        public static let interventionRequired = "syringe.fill"
        public static let monitoringActive = "waveform.ecg"
    }
}

// MARK: - Reusable View Modifiers

public struct CardStyle: ViewModifier {
    let isSelected: Bool
    
    public func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                    .fill(DesignSystem.Colors.backgroundSecondary)
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                            .stroke(
                                isSelected ? DesignSystem.Colors.primaryBlue : Color.clear,
                                lineWidth: 2
                            )
                    )
            )
            .shadow(
                color: DesignSystem.Shadows.medium.color,
                radius: DesignSystem.Shadows.medium.radius,
                x: DesignSystem.Shadows.medium.x,
                y: DesignSystem.Shadows.medium.y
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(DesignSystem.Animation.springBounce, value: isSelected)
    }
}

public struct GlassStyle: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .background(
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
            )
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.3),
                                Color.white.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(
                color: DesignSystem.Shadows.glass.color,
                radius: DesignSystem.Shadows.glass.radius,
                x: DesignSystem.Shadows.glass.x,
                y: DesignSystem.Shadows.glass.y
            )
    }
}

// MARK: - Extensions

extension View {
    public func cardStyle(isSelected: Bool = false) -> some View {
        modifier(CardStyle(isSelected: isSelected))
    }
    
    public func glassStyle() -> some View {
        modifier(GlassStyle())
    }
}

// MARK: - Haptic Feedback

@MainActor
public struct HapticFeedback {
    public static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    public static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    public static func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}