import SwiftUI

// MARK: - Health Icons Integration
/// Uses the Health Icons library (healthicons.org) for medical-specific iconography
public struct HealthIconView: View {
    let iconName: String
    let size: CGFloat
    let color: Color
    
    public init(_ iconName: String, size: CGFloat = 24, color: Color = .primary) {
        self.iconName = iconName
        self.size = size
        self.color = color
    }
    
    public var body: some View {
        // Try to load health icon from assets, fallback to SF Symbol
        if let _ = UIImage(named: healthIconAssetName) {
            Image(healthIconAssetName)
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: size, height: size)
                .foregroundColor(color)
        } else {
            // Fallback to SF Symbol
            Image(systemName: fallbackSFSymbol)
                .font(.system(size: size * 0.8))
                .foregroundColor(color)
        }
    }
    
    private var healthIconAssetName: String {
        // Map protocol names to health icon assets
        let mapping = protocolToHealthIcon(iconName)
        return "healthicon_\(mapping)"
    }
    
    private var fallbackSFSymbol: String {
        // Fallback SF Symbols mapping
        protocolToSFSymbol(iconName)
    }
    
    private func protocolToHealthIcon(_ name: String) -> String {
        let lowerName = name.lowercased()
        
        // Emergency protocols
        if lowerName.contains("code blue") || lowerName.contains("cardiac arrest") {
            return "defibrillator"
        } else if lowerName.contains("stroke") {
            return "neurological_assessment"
        } else if lowerName.contains("stemi") {
            return "heart_rate"
        } else if lowerName.contains("rsi") || lowerName.contains("intubation") {
            return "endotracheal_tube"
        } else if lowerName.contains("shock") {
            return "blood_pressure_monitor"
        } else if lowerName.contains("ecmo") {
            return "ecmo"
        } else if lowerName.contains("anaphylaxis") {
            return "anaphylaxis"
        }
        
        // RRT protocols
        else if lowerName.contains("sepsis") {
            return "bacteria"
        } else if lowerName.contains("respiratory") || lowerName.contains("breath") || lowerName.contains("hypoxia") {
            return "lungs"
        } else if lowerName.contains("chest pain") || lowerName.contains("cardiac monitoring") {
            return "heart_rate"
        } else if lowerName.contains("altered mental") || lowerName.contains("neurological") {
            return "neurological_assessment"
        } else if lowerName.contains("tachycardia") {
            return "heart_rate"
        } else if lowerName.contains("hypotension") || lowerName.contains("hemorrhage") {
            return "blood_pressure_2"
        } else if lowerName.contains("falls") {
            return "trauma"
        } else if lowerName.contains("kidney") || lowerName.contains("aki") {
            return "kidney"
        } else if lowerName.contains("electrolyte") {
            return "salt"
        } else if lowerName.contains("oxygenation") {
            return "oxygen_mask"
        } else if lowerName.contains("pain") {
            return "body_pain"
        } else if lowerName.contains("deterioration") {
            return "emergency_support"
        }
        
        // Calls protocols - each with unique icon (EXACT TITLES)
        else if lowerName.contains("acute decompensated heart failure") {
            return "heart_organ"
        } else if lowerName.contains("right heart failure") || lowerName.contains("pulmonary hypertension") {
            return "heart_rate"
        } else if lowerName.contains("hypertensive emergencies") {
            return "blood_pressure_gauge"
        } else if lowerName.contains("dka/hhs") {
            return "diabetes_mellitus"
        } else if name == "Hypoglycemia" {
            return "glucose_meter"
        } else if lowerName.contains("adrenal crisis") {
            return "hormone_replacement_therapy"
        } else if name == "Pneumothorax" {
            return "respiratory_ventilator"
        } else if lowerName.contains("acute respiratory failure") {
            return "lungs"
        } else if lowerName.contains("asthma & copd exacerbation") {
            return "inhaler"
        } else if lowerName.contains("gi bleeding") {
            return "blood_drop"
        } else if lowerName.contains("bowel obstruction") {
            return "intestinal_blockage"
        } else if lowerName.contains("antiemetic & fluids") {
            return "vomiting"
        } else if lowerName.contains("acute pain assessment") {
            return "body_pain"
        } else if lowerName.contains("opiate conversion") {
            return "medicines"
        } else if lowerName.contains("end-of-life care") || lowerName.contains("eol") {
            return "palliative_care"
        }
        
        // Labs protocols (EXACT TITLES)
        else if name == "Anemia" {
            return "blood_cells"
        } else if lowerName.contains("coagulopathy/inr") {
            return "blood_bag"
        } else if name == "Thrombocytopenia" {
            return "blood_drop"
        } else if name == "Hypernatremia" || name == "Hyponatremia" {
            return "salt"
        } else if name == "Hyperkalemia" || name == "Hypokalemia" {
            return "minerals_alt"
        } else if name == "Hypocalcemia" || name == "Hypercalcemia" {
            return "calcium"
        } else if name == "Hypomagnesemia" {
            return "minerals_alt"
        } else if name == "Hypophosphatemia" {
            return "phosphorus"
        } else if lowerName.contains("hyperglycemia/dka/hhs") {
            return "diabetes_test"
        } else if name == "Hypoglycemia" {
            return "glucose_meter"
        } else if lowerName.contains("aki/renal failure") {
            return "kidney_alt"
        } else if lowerName.contains("hepatic encephalopathy") {
            return "liver"
        } else if lowerName.contains("abg w/ winter") {
            return "oxygen_tank"
        } else if lowerName.contains("acid-base disorders") {
            return "acid_rain"
        } else if lowerName.contains("ventilator adj") {
            return "ventilator"
        }
        
        // Default
        else {
            return "stethoscope"
        }
    }
    
    private func protocolToSFSymbol(_ name: String) -> String {
        let lowerName = name.lowercased()
        
        // Emergency protocols
        if lowerName.contains("code blue") {
            return "heart.text.square.fill"
        } else if lowerName.contains("stroke") {
            return "brain"
        } else if lowerName.contains("stemi") {
            return "waveform.path.ecg.rectangle.fill"
        } else if lowerName.contains("rsi") {
            return "lungs.fill"
        } else if lowerName.contains("shock") {
            return "bolt.heart.fill"
        } else if lowerName.contains("anaphylaxis") {
            return "allergens"
        }
        
        // RRT protocols
        else if lowerName.contains("sepsis") {
            return "bacteria.fill"
        } else if lowerName.contains("respiratory") || lowerName.contains("breath") || lowerName.contains("hypoxia") {
            return "wind.circle.fill"
        } else if lowerName.contains("chest pain") {
            return "waveform.path.ecg"
        } else if lowerName.contains("cardiac") {
            return "waveform.path.ecg"
        } else if lowerName.contains("altered mental") || lowerName.contains("neurological") {
            return "brain.head.profile"
        } else if lowerName.contains("tachycardia") {
            return "waveform"
        } else if lowerName.contains("hypotension") || lowerName.contains("hemorrhage") {
            return "arrow.down.heart.fill"
        } else if lowerName.contains("falls") {
            return "figure.fall"
        } else if lowerName.contains("kidney") || lowerName.contains("aki") {
            return "drop.degreesign"
        } else if lowerName.contains("electrolyte") {
            return "atom"
        } else if lowerName.contains("oxygen") {
            return "circle.hexagongrid.circle.fill"
        } else if lowerName.contains("pain") {
            return "bolt.horizontal.fill"
        } else if lowerName.contains("deterioration") {
            return "exclamationmark.triangle.fill"
        }
        
        // Calls protocols fallbacks
        else if lowerName.contains("acute decompensated heart failure") {
            return "heart.circle.fill"
        } else if lowerName.contains("right heart failure") {
            return "heart.text.square.fill"
        } else if lowerName.contains("hypertensive emergencies") {
            return "gauge.with.dots.needle.33percent"
        } else if lowerName.contains("dka/hhs") {
            return "drop.circle.fill"
        } else if name == "Hypoglycemia" {
            return "minus.circle.fill"
        } else if lowerName.contains("adrenal crisis") {
            return "waveform.badge.exclamationmark"
        } else if name == "Pneumothorax" {
            return "lungs.fill"
        } else if lowerName.contains("acute respiratory failure") {
            return "wind.circle.fill"
        } else if lowerName.contains("asthma & copd exacerbation") {
            return "allergens.fill"
        } else if lowerName.contains("gi bleeding") {
            return "drop.fill"
        } else if lowerName.contains("bowel obstruction") {
            return "xmark.circle.fill"
        } else if lowerName.contains("antiemetic & fluids") {
            return "drop.degreesign.fill"
        } else if lowerName.contains("acute pain assessment") {
            return "bolt.horizontal.fill"
        } else if lowerName.contains("opiate conversion") {
            return "pills.fill"
        } else if lowerName.contains("end-of-life care") || lowerName.contains("eol") {
            return "heart.text.square"
        }
        
        // Labs protocols fallbacks
        else if name == "Anemia" {
            return "drop.circle"
        } else if lowerName.contains("coagulopathy/inr") {
            return "timer.circle.fill"
        } else if name == "Thrombocytopenia" {
            return "circle.hexagongrid.circle"
        } else if name == "Hypernatremia" || name == "Hyponatremia" {
            return "atom"
        } else if name == "Hyperkalemia" || name == "Hypokalemia" {
            return "bolt.badge.clock.fill"
        } else if name == "Hypocalcemia" || name == "Hypercalcemia" {
            return "rhombus.fill"
        } else if name == "Hypomagnesemia" {
            return "atom"
        } else if name == "Hypophosphatemia" {
            return "atom"
        } else if lowerName.contains("hyperglycemia/dka/hhs") {
            return "arrow.up.circle.fill"
        } else if lowerName.contains("aki/renal failure") {
            return "drop.degreesign"
        } else if lowerName.contains("hepatic encephalopathy") {
            return "brain.fill"
        } else if lowerName.contains("abg w/ winter") {
            return "chart.line.uptrend.xyaxis"
        } else if lowerName.contains("acid-base disorders") {
            return "testtube.2"
        } else if lowerName.contains("ventilator adj") {
            return "wind.circle"
        }
        
        // Default
        else {
            return "stethoscope"
        }
    }
}

// MARK: - Health Icon Grid Item
public struct HealthIconGridItem: View {
    let title: String
    let iconName: String
    let backgroundColor: Color
    let iconSize: CGFloat
    
    public init(
        title: String,
        iconName: String,
        backgroundColor: Color,
        iconSize: CGFloat = 28
    ) {
        self.title = title
        self.iconName = iconName
        self.backgroundColor = backgroundColor
        self.iconSize = iconSize
    }
    
    public var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(backgroundColor)
                    .frame(width: iconSize * 2, height: iconSize * 2)
                
                HealthIconView(iconName, size: iconSize, color: .white)
            }
            
            Text(title)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.75)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        // Emergency icons
        HStack(spacing: 20) {
            HealthIconGridItem(
                title: "Code Blue",
                iconName: "Code Blue",
                backgroundColor: .red
            )
            HealthIconGridItem(
                title: "Code Stroke",
                iconName: "Stroke",
                backgroundColor: .purple
            )
            HealthIconGridItem(
                title: "Anaphylaxis",
                iconName: "Anaphylaxis",
                backgroundColor: .pink
            )
        }
        
        // RRT icons
        HStack(spacing: 20) {
            HealthIconGridItem(
                title: "Sepsis",
                iconName: "Sepsis",
                backgroundColor: .orange
            )
            HealthIconGridItem(
                title: "Respiratory",
                iconName: "Respiratory",
                backgroundColor: .blue
            )
            HealthIconGridItem(
                title: "Pain Crisis",
                iconName: "Pain",
                backgroundColor: .green
            )
        }
    }
    .padding()
}