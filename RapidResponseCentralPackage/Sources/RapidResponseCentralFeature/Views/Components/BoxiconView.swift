import SwiftUI

// MARK: - Boxicon View Component

struct BoxiconView: View {
    let iconName: String
    let size: CGFloat
    let color: Color
    
    init(iconName: String, size: CGFloat = 24, color: Color = .primary) {
        self.iconName = iconName
        self.size = size
        self.color = color
    }
    
    var body: some View {
        Group {
            if let svgImage = loadBoxicon(iconName) {
                svgImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                    .foregroundColor(color)
            } else {
                // Fallback to system image if Boxicon not found
                Image(systemName: fallbackSystemImage(for: iconName))
                    .font(.system(size: size * 0.8))
                    .foregroundColor(color)
            }
        }
    }
    
    private func loadBoxicon(_ iconName: String) -> Image? {
        // Try to load from bundle's Boxicon assets
        let iconFileName = iconName.hasPrefix("bx-") ? iconName : "bx-\(iconName)"
        
        if let path = Bundle.main.path(forResource: iconFileName, ofType: "svg", inDirectory: "Assets/Boxicons/svg/basic") {
            // For now, we'll use a system image as SVG loading requires additional setup
            // In a full implementation, you'd use a library like SVGKit or create custom SVG parsing
            return nil
        }
        
        return nil
    }
    
    private func fallbackSystemImage(for boxiconName: String) -> String {
        // Map common Boxicon names to system image names
        switch boxiconName {
        case "bx-heart":
            return "heart.fill"
        case "bx-pulse":
            return "waveform.path.ecg"
        case "bx-brain":
            return "brain.head.profile"
        case "bx-ambulance":
            return "cross.case.fill"
        case "bx-hospital":
            return "cross.fill"
        case "bx-wind":
            return "wind"
        case "bx-test-tube":
            return "testtube.2"
        case "bx-donate-blood":
            return "drop.fill"
        case "bx-water":
            return "drop.fill"
        case "bx-bone":
            return "figure.walk"
        case "bx-food-menu":
            return "list.bullet"
        case "bx-plus-medical":
            return "plus.circle.fill"
        case "bx-calculator":
            return "function"
        default:
            return "circle.fill"
        }
    }
}

// MARK: - Boxicon Helper Functions

extension BoxiconView {
    /// Create a medical-themed Boxicon with appropriate color
    static func medical(_ iconName: String, size: CGFloat = 24) -> BoxiconView {
        let color: Color = {
            switch iconName {
            case "bx-heart", "bx-donate-blood":
                return .red
            case "bx-pulse":
                return .green
            case "bx-brain":
                return .purple
            case "bx-ambulance", "bx-hospital":
                return .blue
            case "bx-wind":
                return .cyan
            case "bx-test-tube":
                return .orange
            default:
                return .blue
            }
        }()
        
        return BoxiconView(iconName: iconName, size: size, color: color)
    }
    
    /// Create a neutral-colored Boxicon
    static func neutral(_ iconName: String, size: CGFloat = 24) -> BoxiconView {
        BoxiconView(iconName: iconName, size: size, color: .primary)
    }
    
    /// Create a colored Boxicon with custom color
    static func colored(_ iconName: String, color: Color, size: CGFloat = 24) -> BoxiconView {
        BoxiconView(iconName: iconName, size: size, color: color)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        HStack(spacing: 20) {
            BoxiconView.medical("bx-heart", size: 40)
            BoxiconView.medical("bx-pulse", size: 40)
            BoxiconView.medical("bx-brain", size: 40)
            BoxiconView.medical("bx-ambulance", size: 40)
        }
        
        HStack(spacing: 20) {
            BoxiconView.medical("bx-hospital", size: 40)
            BoxiconView.medical("bx-wind", size: 40)
            BoxiconView.medical("bx-test-tube", size: 40)
            BoxiconView.medical("bx-donate-blood", size: 40)
        }
        
        Text("Medical Boxicons with Fallback System Images")
            .font(.caption)
            .foregroundColor(.secondary)
    }
    .padding()
}