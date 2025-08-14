import SwiftUI

public struct CustomTabBar: View {
    @Binding var selectedTab: AppTab
    @Namespace private var namespace
    @Environment(\.colorScheme) private var colorScheme
    
    public init(selectedTab: Binding<AppTab>) {
        self._selectedTab = selectedTab
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.visibleTabs, id: \.self) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab,
                    namespace: namespace,
                    action: { 
                        withAnimation(DesignSystem.Animation.springBounce) {
                            selectedTab = tab
                        }
                        HapticFeedback.impact(.light)
                    }
                )
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, 8)
        .background(
            colorScheme == .dark ? Material.regularMaterial : Material.ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 0)
        )
        .overlay(
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.gray.opacity(0.2),
                            Color.clear
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: 1)
                .offset(y: -1),
            alignment: .top
        )
    }
}

struct TabBarButton: View {
    let tab: AppTab
    let isSelected: Bool
    let namespace: Namespace.ID
    let action: () -> Void
    
    @State private var isPressed = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(tabColor.opacity(0.15))
                            .frame(width: 48, height: 48)
                            .matchedGeometryEffect(id: "tabSelection", in: namespace)
                    }
                    
                    Image(systemName: isSelected ? iconNameFilled : iconName)
                        .font(.system(size: 24))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(
                            isSelected ? tabColor : (colorScheme == .dark ? Color.gray : Color.gray.opacity(0.8))
                        )
                        .scaleEffect(isPressed ? 0.85 : (isSelected ? 1.1 : 1.0))
                        .animation(DesignSystem.Animation.springBounce, value: isPressed)
                        .animation(DesignSystem.Animation.springBounce, value: isSelected)
                }
                .frame(height: 32)
                
                Text(tab.rawValue)
                    .font(.system(size: 10, weight: isSelected ? .semibold : .regular))
                    .minimumScaleFactor(0.8)
                    .foregroundColor(isSelected ? tabColor : (colorScheme == .dark ? Color.gray : Color.gray.opacity(0.8)))
                    .scaleEffect(isSelected ? 1.05 : 1.0)
                    .animation(DesignSystem.Animation.quick, value: isSelected)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel(tab.rawValue)
        .accessibilityHint(isSelected ? "Currently selected" : "Double tap to select")
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity) {
            // Never triggers
        } onPressingChanged: { pressing in
            withAnimation(DesignSystem.Animation.quick) {
                isPressed = pressing
            }
        }
    }
    
    private var iconName: String {
        switch tab {
        case .emergencies:
            return "exclamationmark.triangle"
        case .rrt:
            return "person.3"
        case .calls:
            return "phone"
        case .labs:
            return "flask"
        case .calc:
            return "function"
        case .more:
            return "ellipsis.circle"
        case .chat:
            return "message"
        case .study:
            return "book"
        }
    }
    
    private var iconNameFilled: String {
        switch tab {
        case .emergencies:
            return "exclamationmark.triangle.fill"
        case .rrt:
            return "person.3.fill"
        case .calls:
            return "phone.fill"
        case .labs:
            return "flask.fill"
        case .calc:
            return "function"
        case .more:
            return "ellipsis.circle.fill"
        case .chat:
            return "message.fill"
        case .study:
            return "book.fill"
        }
    }
    
    private var tabColor: Color {
        switch tab {
        case .emergencies:
            return DesignSystem.Colors.critical
        case .rrt:
            return DesignSystem.Colors.warning
        case .calls:
            return DesignSystem.Colors.primaryBlue
        case .labs:
            return Color.purple
        case .calc:
            return Color.green
        case .more:
            return Color.gray
        case .chat:
            return Color.indigo
        case .study:
            return Color.orange
        }
    }
}

#Preview {
    CustomTabBar(selectedTab: .constant(.emergencies))
        .frame(height: 49)
}