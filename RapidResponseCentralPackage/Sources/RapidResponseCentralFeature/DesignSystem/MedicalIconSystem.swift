import SwiftUI

// MARK: - Medical Icon Design System
/// Design system for medical protocol icons based on 24dp grid
/// Includes color tokens, gradients, and dark mode support
public struct MedicalIconSystem {
    
    // MARK: - Color Tokens
    public struct Colors {
        // Emergency Blue
        public static let blue1Light = Color(red: 0.36, green: 0.65, blue: 0.86) // #5CA7DB
        public static let blue2Light = Color(red: 0.29, green: 0.56, blue: 0.89) // #4A90E2
        public static let blue1Dark = Color(red: 0.11, green: 0.17, blue: 0.32)  // #1B2B52
        public static let blue2Dark = Color(red: 0.15, green: 0.26, blue: 0.49)  // #27437C
        
        // Emergency Red
        public static let red1Light = Color(red: 0.97, green: 0.42, blue: 0.42) // #F86B6B
        public static let red2Light = Color(red: 0.89, green: 0.26, blue: 0.26) // #E34242
        public static let red1Dark = Color(red: 0.58, green: 0.25, blue: 0.25)
        public static let red2Dark = Color(red: 0.53, green: 0.16, blue: 0.16)
        
        // Emergency Orange
        public static let orange1Light = Color(red: 1.0, green: 0.70, blue: 0.40)  // #FFB366
        public static let orange2Light = Color(red: 1.0, green: 0.60, blue: 0.20)  // #FF9933
        public static let orange1Dark = Color(red: 0.60, green: 0.42, blue: 0.24)
        public static let orange2Dark = Color(red: 0.60, green: 0.36, blue: 0.12)
        
        // Emergency Green
        public static let green1Light = Color(red: 0.56, green: 0.82, blue: 0.31) // #8FD14F
        public static let green2Light = Color(red: 0.44, green: 0.75, blue: 0.24) // #6FBF3C
        public static let green1Dark = Color(red: 0.34, green: 0.49, blue: 0.19)
        public static let green2Dark = Color(red: 0.26, green: 0.45, blue: 0.14)
        
        // Emergency Purple
        public static let purple1Light = Color(red: 0.69, green: 0.61, blue: 0.85) // #B19CD9
        public static let purple2Light = Color(red: 0.61, green: 0.53, blue: 0.77) // #9B88C4
        public static let purple1Dark = Color(red: 0.41, green: 0.37, blue: 0.51)
        public static let purple2Dark = Color(red: 0.37, green: 0.32, blue: 0.46)
        
        // Emergency Pink
        public static let pink1Light = Color(red: 1.0, green: 0.70, blue: 0.85)  // #FFB3D9
        public static let pink2Light = Color(red: 1.0, green: 0.60, blue: 0.80)  // #FF99CC
        public static let pink1Dark = Color(red: 0.60, green: 0.42, blue: 0.51)
        public static let pink2Dark = Color(red: 0.60, green: 0.36, blue: 0.48)
        
        // Emergency Teal
        public static let teal1Light = Color(red: 0.43, green: 0.84, blue: 0.93) // #6DD5ED
        public static let teal2Light = Color(red: 0.31, green: 0.79, blue: 0.89) // #50C9E3
        public static let teal1Dark = Color(red: 0.26, green: 0.50, blue: 0.56)
        public static let teal2Dark = Color(red: 0.19, green: 0.47, blue: 0.53)
        
        // Emergency Yellow
        public static let yellow1Light = Color(red: 1.0, green: 0.88, blue: 0.40)  // #FFE066
        public static let yellow2Light = Color(red: 1.0, green: 0.85, blue: 0.24)  // #FFD93D
        public static let yellow1Dark = Color(red: 0.60, green: 0.53, blue: 0.24)
        public static let yellow2Dark = Color(red: 0.60, green: 0.51, blue: 0.14)
        
        // Emergency Salmon
        public static let salmon1Light = Color(red: 1.0, green: 0.63, blue: 0.48)  // #FFA07A
        public static let salmon2Light = Color(red: 0.98, green: 0.50, blue: 0.45) // #FA8072
        public static let salmon1Dark = Color(red: 0.60, green: 0.38, blue: 0.29)
        public static let salmon2Dark = Color(red: 0.59, green: 0.30, blue: 0.27)
        
        // Stroke colors
        public static let strokeDefault = Color.white
        public static let strokeAlert = Color(red: 0.93, green: 0.04, blue: 0.26) // #EC0B43
        
        // Get color based on scheme
        public static func blue1(for scheme: ColorScheme) -> Color {
            scheme == .dark ? blue1Dark : blue1Light
        }
        
        public static func blue2(for scheme: ColorScheme) -> Color {
            scheme == .dark ? blue2Dark : blue2Light
        }
        
        public static func red1(for scheme: ColorScheme) -> Color {
            scheme == .dark ? red1Dark : red1Light
        }
        
        public static func red2(for scheme: ColorScheme) -> Color {
            scheme == .dark ? red2Dark : red2Light
        }
        
        public static func orange1(for scheme: ColorScheme) -> Color {
            scheme == .dark ? orange1Dark : orange1Light
        }
        
        public static func orange2(for scheme: ColorScheme) -> Color {
            scheme == .dark ? orange2Dark : orange2Light
        }
        
        public static func green1(for scheme: ColorScheme) -> Color {
            scheme == .dark ? green1Dark : green1Light
        }
        
        public static func green2(for scheme: ColorScheme) -> Color {
            scheme == .dark ? green2Dark : green2Light
        }
        
        public static func purple1(for scheme: ColorScheme) -> Color {
            scheme == .dark ? purple1Dark : purple1Light
        }
        
        public static func purple2(for scheme: ColorScheme) -> Color {
            scheme == .dark ? purple2Dark : purple2Light
        }
        
        public static func pink1(for scheme: ColorScheme) -> Color {
            scheme == .dark ? pink1Dark : pink1Light
        }
        
        public static func pink2(for scheme: ColorScheme) -> Color {
            scheme == .dark ? pink2Dark : pink2Light
        }
        
        public static func teal1(for scheme: ColorScheme) -> Color {
            scheme == .dark ? teal1Dark : teal1Light
        }
        
        public static func teal2(for scheme: ColorScheme) -> Color {
            scheme == .dark ? teal2Dark : teal2Light
        }
        
        public static func yellow1(for scheme: ColorScheme) -> Color {
            scheme == .dark ? yellow1Dark : yellow1Light
        }
        
        public static func yellow2(for scheme: ColorScheme) -> Color {
            scheme == .dark ? yellow2Dark : yellow2Light
        }
        
        public static func salmon1(for scheme: ColorScheme) -> Color {
            scheme == .dark ? salmon1Dark : salmon1Light
        }
        
        public static func salmon2(for scheme: ColorScheme) -> Color {
            scheme == .dark ? salmon2Dark : salmon2Light
        }
    }
    
    // MARK: - Gradient Definitions
    public struct Gradients {
        public static func blue(for scheme: ColorScheme) -> LinearGradient {
            LinearGradient(
                colors: [Colors.blue1(for: scheme), Colors.blue2(for: scheme)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        
        public static func red(for scheme: ColorScheme) -> LinearGradient {
            LinearGradient(
                colors: [Colors.red1(for: scheme), Colors.red2(for: scheme)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        
        public static func orange(for scheme: ColorScheme) -> LinearGradient {
            LinearGradient(
                colors: [Colors.orange1(for: scheme), Colors.orange2(for: scheme)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        
        public static func green(for scheme: ColorScheme) -> LinearGradient {
            LinearGradient(
                colors: [Colors.green1(for: scheme), Colors.green2(for: scheme)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        
        public static func purple(for scheme: ColorScheme) -> LinearGradient {
            LinearGradient(
                colors: [Colors.purple1(for: scheme), Colors.purple2(for: scheme)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        
        public static func pink(for scheme: ColorScheme) -> LinearGradient {
            LinearGradient(
                colors: [Colors.pink1(for: scheme), Colors.pink2(for: scheme)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        
        public static func teal(for scheme: ColorScheme) -> LinearGradient {
            LinearGradient(
                colors: [Colors.teal1(for: scheme), Colors.teal2(for: scheme)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        
        public static func yellow(for scheme: ColorScheme) -> LinearGradient {
            LinearGradient(
                colors: [Colors.yellow1(for: scheme), Colors.yellow2(for: scheme)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        
        public static func salmon(for scheme: ColorScheme) -> LinearGradient {
            LinearGradient(
                colors: [Colors.salmon1(for: scheme), Colors.salmon2(for: scheme)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    // MARK: - Icon Tile Shape
    public struct TileShape: Shape {
        let cornerRadius: CGFloat = 4
        
        public func path(in rect: CGRect) -> Path {
            Path(roundedRect: rect, cornerRadius: cornerRadius)
        }
    }
    
    // MARK: - Icon Size Constants
    public struct Sizes {
        public static let standard: CGFloat = 24
        public static let small: CGFloat = 16
        public static let medium: CGFloat = 32
        public static let large: CGFloat = 48
        public static let extraLarge: CGFloat = 64
    }
    
    // MARK: - Helper function to get gradient for protocol category
    public static func gradient(for category: ProtocolCategory, scheme: ColorScheme) -> LinearGradient {
        switch category {
        case .cardiac:
            return Gradients.red(for: scheme)
        case .neurological:
            return Gradients.purple(for: scheme)
        case .respiratory:
            return Gradients.blue(for: scheme)
        case .trauma:
            return Gradients.orange(for: scheme)
        case .infectious:
            return Gradients.green(for: scheme)
        case .allergic:
            return Gradients.pink(for: scheme)
        case .support:
            return Gradients.teal(for: scheme)
        }
    }
}

// MARK: - Icon Base View
/// Base view for medical protocol icons with consistent styling
public struct MedicalIconBase: View {
    let size: CGFloat
    let gradient: LinearGradient
    let content: AnyView
    
    public init(
        size: CGFloat = MedicalIconSystem.Sizes.standard,
        gradient: LinearGradient,
        @ViewBuilder content: () -> some View
    ) {
        self.size = size
        self.gradient = gradient
        self.content = AnyView(content())
    }
    
    public var body: some View {
        ZStack {
            // Background tile
            MedicalIconSystem.TileShape()
                .fill(gradient)
                .frame(width: size, height: size)
            
            // Icon content
            content
                .frame(width: size, height: size)
        }
    }
}