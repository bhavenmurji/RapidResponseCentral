import SwiftUI

// MARK: - Dark Mode Preview Helper
/// Helper view for previewing components in both light and dark modes
public struct DarkModePreview<Content: View>: View {
    let content: Content
    let title: String
    
    public init(_ title: String = "", @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            if !title.isEmpty {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
            }
            
            VStack(spacing: 0) {
                // Light Mode
                VStack {
                    HStack {
                        Image(systemName: "sun.max.fill")
                            .foregroundColor(.orange)
                        Text("Light Mode")
                            .font(.headline)
                        Spacer()
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    
                    content
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .preferredColorScheme(.light)
                }
                
                Divider()
                
                // Dark Mode
                VStack {
                    HStack {
                        Image(systemName: "moon.fill")
                            .foregroundColor(.blue)
                        Text("Dark Mode")
                            .font(.headline)
                        Spacer()
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    
                    content
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .preferredColorScheme(.dark)
                }
            }
        }
    }
}

// MARK: - Preview Extension for Easy Dark Mode Testing
extension View {
    /// Wraps the view in a preview showing both light and dark modes
    public func darkModePreview(_ title: String = "") -> some View {
        DarkModePreview(title) {
            self
        }
    }
}

// MARK: - Theme Manager for Runtime Theme Switching
@MainActor
public class ThemeManager: ObservableObject {
    @Published public var selectedTheme: Theme = .system
    
    public enum Theme: String, CaseIterable {
        case light = "Light"
        case dark = "Dark"
        case system = "System"
        
        public var colorScheme: ColorScheme? {
            switch self {
            case .light:
                return .light
            case .dark:
                return .dark
            case .system:
                return nil
            }
        }
        
        public var icon: String {
            switch self {
            case .light:
                return "sun.max.fill"
            case .dark:
                return "moon.fill"
            case .system:
                return "circle.lefthalf.filled"
            }
        }
    }
    
    public init() {}
    
    public func applyTheme() {
        // This would typically update the app's window appearance
        // For now, it's a placeholder for future implementation
    }
}

// MARK: - Theme Switcher Component
public struct ThemeSwitcher: View {
    @StateObject private var themeManager = ThemeManager()
    
    public init() {}
    
    public var body: some View {
        Menu {
            ForEach(ThemeManager.Theme.allCases, id: \.self) { theme in
                Button(action: {
                    themeManager.selectedTheme = theme
                    themeManager.applyTheme()
                }) {
                    Label(theme.rawValue, systemImage: theme.icon)
                }
            }
        } label: {
            Image(systemName: themeManager.selectedTheme.icon)
                .font(.system(size: 20))
                .symbolRenderingMode(.hierarchical)
        }
    }
}

#Preview("Dark Mode Components") {
    VStack(spacing: 20) {
        // Theme Switcher
        HStack {
            Text("Theme:")
                .font(.headline)
            Spacer()
            ThemeSwitcher()
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
        
        // Sample Card
        ModernProtocolCard(
            title: "Code Blue",
            icon: "bx-heart",
            category: .cardiac,
            isUrgent: true
        )
        .frame(height: 120)
        
        // Sample Card (Non-urgent)
        ModernProtocolCard(
            title: "Sepsis Protocol",
            icon: "bx-virus",
            category: .infectious,
            isUrgent: false
        )
        .frame(height: 120)
        
        Spacer()
    }
    .padding()
    .darkModePreview("Emergency Cards")
}