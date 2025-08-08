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
        // Check if it's a healthicon or boxicon
        if iconName.hasPrefix("healthicon-") {
            // Try to load healthicon PNG image
            let healthiconName = iconName.replacingOccurrences(of: "healthicon-", with: "")
            if let uiImage = loadHealthicon(healthiconName) {
                Image(uiImage: uiImage)
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(color)
                    .frame(width: size, height: size)
            } else {
                // Fallback to SF Symbol
                Image(systemName: fallbackSystemImage(for: iconName))
                    .font(.system(size: size * 0.8, weight: .medium))
                    .foregroundColor(color)
                    .frame(width: size, height: size)
            }
        } else {
            // Use SF Symbol fallback for boxicons
            Image(systemName: fallbackSystemImage(for: iconName))
                .font(.system(size: size * 0.8, weight: .medium))
                .foregroundColor(color)
                .frame(width: size, height: size)
        }
    }
    
    private func loadHealthicon(_ iconName: String) -> UIImage? {
        // Try to load healthicon PNG from Assets
        // First try filled/devices
        if let image = UIImage(named: "Assets/healthicons/png/filled/devices/\(iconName)") {
            return image
        }
        // Try filled/body
        if let image = UIImage(named: "Assets/healthicons/png/filled/body/\(iconName)") {
            return image
        }
        // Try filled/conditions
        if let image = UIImage(named: "Assets/healthicons/png/filled/conditions/\(iconName)") {
            return image
        }
        // Try filled/blood
        if let image = UIImage(named: "Assets/healthicons/png/filled/blood/\(iconName)") {
            return image
        }
        return nil
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
    
    private func fallbackSystemImage(for iconName: String) -> String {
        // Handle healthicon names
        if iconName.hasPrefix("healthicon-") {
            let healthName = iconName.replacingOccurrences(of: "healthicon-", with: "")
            switch healthName {
            case "defibrillator":
                return "bolt.heart.fill"
            case "neurology":
                return "brain.head.profile"
            case "heart_organ":
                return "heart.text.square.fill"
            case "endotracheal_tube":
                return "lungs.fill"
            case "ecmo":
                return "heart.circle.fill"
            case "stethoscope":
                return "stethoscope"
            case "oxygen_tank":
                return "wind"
            case "blood_pressure_monitor":
                return "waveform.path.ecg"
            case "blood_bag":
                return "drop.fill"
            // Calls protocol healthicons
            case "intravenous_drip":
                return "drop.triangle.fill"
            case "heart_rate":
                return "waveform.path.ecg.rectangle"
            case "blood_pressure_2":
                return "gauge.with.dots.needle.bottom.50percent"
            case "diabetes_mellitus":
                return "drop.circle"
            case "glucose_meter":
                return "testtube.2"
            case "hormone_replacement_therapy":
                return "pills.circle"
            case "lungs":
                return "lungs"
            case "oxygen_mask":
                return "facemask"
            case "inhaler":
                return "wind.circle"
            case "stomach":
                return "figure.wave"
            case "intestinal_blockage":
                return "cross.vial"
            case "vomiting":
                return "drop.triangle"
            case "body_pain":
                return "bandage"
            case "medicines":
                return "pills"
            case "palliative_care":
                return "heart.text.square"
            // Labs protocol healthicons
            case "blood_cells":
                return "circle.hexagongrid.circle.fill"
            case "blood_pressure_gauge":
                return "gauge.with.needle"
            case "blood_drop":
                return "drop"
            case "salt":
                return "cube.transparent"
            case "water":
                return "drop.fill"
            case "kidney", "kidney_alt", "kidneys":
                return "oval.portrait.fill"
            case "calcium", "calcium_supplement":
                return "cube.fill"
            case "minerals_alt":
                return "atom"
            case "phosphorus":
                return "chart.dots.scatter"
            case "diabetes_test", "diabetes_test_alt":
                return "testtube.2"
            case "liver":
                return "hexagon.fill"
            case "respiratory_ventilator", "ventilator":
                return "wind.snow.circle"
            case "acid_rain":
                return "cloud.rain.fill"
            default:
                return "cross.circle.fill"
            }
        }
        
        // Map common Boxicon names to system image names
        let cleanName = iconName.replacingOccurrences(of: "bx-", with: "")
        
        switch cleanName {
        // Medical Emergency Icons
        case "heart", "heart-fill":
            return "heart.fill"
        case "pulse", "heartbeat":
            return "waveform.path.ecg"
        case "brain":
            return "brain.head.profile"
        case "ambulance":
            return "cross.case.fill"
        case "hospital":
            return "cross.circle.fill"
        case "wind", "lungs":
            return "wind"
        case "test-tube", "lab":
            return "testtube.2"
        case "donate-blood", "blood":
            return "drop.fill"
        case "water", "drop":
            return "drop.triangle.fill"
        case "bone", "fracture":
            return "figure.walk"
        case "food-menu", "poison":
            return "cross.vial.fill"
        case "plus-medical", "medical":
            return "plus.circle.fill"
        case "calculator", "calc":
            return "function"
        case "shock", "electric":
            return "bolt.fill"
        case "baby", "child":
            return "figure.and.child.holdinghands"
        case "pregnant", "pregnancy":
            return "person.fill"
        case "temperature", "fever":
            return "thermometer"
        case "pain", "injury":
            return "bandage.fill"
        case "allergy", "reaction":
            return "allergens"
        case "burn", "fire":
            return "flame.fill"
        case "dizzy", "vertigo":
            return "tornado"
        case "eye", "vision":
            return "eye.fill"
        case "trauma", "accident":
            return "staroflife.fill"
        case "breathing", "respiratory":
            return "lungs.fill"
        case "medication", "pills":
            return "pills.fill"
        case "injection", "syringe":
            return "syringe.fill"
        case "emergency", "alert":
            return "alarm.fill"
        case "glucose", "diabetes":
            return "drop.circle.fill"
        case "seizure", "epilepsy":
            return "waveform.path.ecg.rectangle.fill"
        case "support", "help":
            return "person.2.fill"
        case "phone-call", "call":
            return "phone.fill"
        case "message", "chat":
            return "message.fill"
        case "clipboard", "documentation":
            return "doc.text.fill"
        case "calendar", "schedule":
            return "calendar"
        case "list-check", "checklist":
            return "checklist"
        default:
            // Try to find a reasonable match based on keywords
            if cleanName.contains("heart") {
                return "heart.fill"
            } else if cleanName.contains("emergency") || cleanName.contains("alert") {
                return "alarm.fill"
            } else if cleanName.contains("medical") || cleanName.contains("health") {
                return "cross.circle.fill"
            } else {
                return "stethoscope"
            }
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