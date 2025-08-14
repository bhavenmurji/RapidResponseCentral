import SwiftUI

// MARK: - Simplified Medical Protocol Icons
/// Clean, large icons using SF Symbols with colored backgrounds
public struct SimpleMedicalIcon: View {
    let protocolName: String
    let size: CGFloat
    @Environment(\.colorScheme) private var colorScheme
    
    public init(_ protocolName: String, size: CGFloat = 36) {
        self.protocolName = protocolName
        self.size = size
    }
    
    public var body: some View {
        ZStack {
            // Background with rounded corners
            RoundedRectangle(cornerRadius: size * 0.22)
                .fill(backgroundGradient)
                .frame(width: size, height: size)
            
            // Icon
            Image(systemName: iconName)
                .font(.system(size: size * 0.5, weight: .semibold))
                .foregroundColor(.white)
                .symbolRenderingMode(.hierarchical)
        }
    }
    
    private var iconName: String {
        let lowerName = protocolName.lowercased()
        
        // Emergency protocols
        if lowerName.contains("code blue") || lowerName.contains("acls") {
            return "heart.fill"
        } else if lowerName.contains("code stroke") || lowerName.contains("tnk") {
            return "brain"
        } else if lowerName.contains("stemi") {
            return "waveform.path.ecg"
        } else if lowerName.contains("rsi") || lowerName.contains("airway") {
            return "lungs.fill"
        } else if lowerName.contains("shock") || lowerName.contains("ecmo") {
            return "drop.circle.fill"
        } else if lowerName.contains("anaphylaxis") {
            return "exclamationmark.triangle.fill"
        }
        
        // RRT protocols
        else if lowerName.contains("chest pain") {
            return "bolt.heart.fill"
        } else if lowerName.contains("shortness") || lowerName.contains("breath") || lowerName.contains("hypox") {
            return "wind"
        } else if lowerName.contains("altered mental") || lowerName.contains("neurological") {
            return "brain.head.profile"
        } else if lowerName.contains("tachycardia") {
            return "waveform.path.ecg.rectangle.fill"
        } else if lowerName.contains("hypotension") || lowerName.contains("hemorrhage") {
            return "drop.triangle.fill"
        } else if lowerName.contains("fall") {
            return "figure.fall"
        }
        
        // Calls protocols - unique icons
        else if lowerName.contains("heart failure") || lowerName.contains("acute hf") || lowerName.contains("decompensated") {
            return "heart.circle.fill"
        } else if lowerName.contains("right heart") || lowerName.contains("right hf") {
            return "heart.text.square.fill"
        } else if lowerName.contains("hypertensive") {
            return "gauge.high"
        } else if lowerName.contains("dka") || lowerName.contains("hhs") || lowerName.contains("diabetic") {
            return "drop.fill"
        } else if lowerName.contains("hypoglycemia") {
            return "minus.circle.fill"
        } else if lowerName.contains("adrenal") {
            return "exclamationmark.shield.fill"
        } else if lowerName.contains("pneumothorax") {
            return "lungs"
        } else if lowerName.contains("respiratory failure") {
            return "lungs.fill"
        } else if lowerName.contains("asthma") {
            return "wind.circle.fill"
        } else if lowerName.contains("gi bleeding") || lowerName.contains("bleeding") {
            return "drop.triangle.fill"
        } else if lowerName.contains("bowel obstruction") || lowerName.contains("obstruction") {
            return "xmark.octagon.fill"
        } else if lowerName.contains("antiemetic") || lowerName.contains("nausea") {
            return "pills.fill"
        } else if lowerName.contains("acute pain") || lowerName.contains("pain management") {
            return "bolt.horizontal.circle.fill"
        } else if lowerName.contains("opiate") || lowerName.contains("opioid") {
            return "cross.vial.fill"
        } else if lowerName.contains("eol") || lowerName.contains("end of life") || lowerName.contains("palliative") {
            return "heart.square.fill"
        }
        
        // Labs protocols - unique icons  
        else if lowerName.contains("anemia") {
            return "drop.circle"
        } else if lowerName.contains("coagulopathy") || lowerName.contains("inr") {
            return "drop.degreesign"
        } else if lowerName.contains("thrombocytopenia") {
            return "circles.hexagongrid.fill"
        } else if lowerName.contains("hypernatremia") {
            return "plus.diamond.fill"
        } else if lowerName.contains("hyponatremia") {
            return "minus.diamond.fill"
        } else if lowerName.contains("hyperkalemia") {
            return "bolt.circle.fill"
        } else if lowerName.contains("hypokalemia") {
            return "bolt.slash.circle.fill"
        } else if lowerName.contains("hypocalcemia") {
            return "square.stack.3d.down.right.fill"
        } else if lowerName.contains("hypercalcemia") {
            return "square.stack.3d.up.fill"
        } else if lowerName.contains("hypomagnesemia") || lowerName.contains("magnesium") {
            return "sparkles"
        } else if lowerName.contains("hypophosphatemia") || lowerName.contains("phosphate") {
            return "atom"
        } else if lowerName.contains("hyperglycemia") {
            return "arrow.up.circle.fill"
        } else if lowerName.contains("hypoglycemia") && !lowerName.contains("calls") {
            return "arrow.down.circle.fill"
        } else if lowerName.contains("renal failure") || lowerName.contains("renal") {
            return "drop.degreesign.fill"
        } else if lowerName.contains("hepatic") || lowerName.contains("encephalopathy") {
            return "square.grid.3x3.fill"
        } else if lowerName.contains("abg") || lowerName.contains("arterial blood") {
            return "waveform.path.ecg.rectangle"
        } else if lowerName.contains("acid-base") || lowerName.contains("acidosis") {
            return "chart.xyaxis.line"
        } else if lowerName.contains("ventilator") || lowerName.contains("vent adjustment") {
            return "fan.oscillation"
        }
        
        // Emergency support
        else if lowerName.contains("emergency support") || lowerName.contains("rrt") {
            return "phone.fill"
        }
        
        // Default
        else {
            return "cross.case.fill"
        }
    }
    
    private var backgroundGradient: LinearGradient {
        let category = getCategory(for: protocolName)
        
        switch category {
        case .cardiac:
            return MedicalIconSystem.Gradients.red(for: colorScheme)
        case .neurological:
            return MedicalIconSystem.Gradients.purple(for: colorScheme)
        case .respiratory:
            return MedicalIconSystem.Gradients.blue(for: colorScheme)
        case .trauma:
            return MedicalIconSystem.Gradients.orange(for: colorScheme)
        case .infectious:
            return MedicalIconSystem.Gradients.green(for: colorScheme)
        case .allergic:
            return MedicalIconSystem.Gradients.yellow(for: colorScheme)
        case .support:
            return MedicalIconSystem.Gradients.teal(for: colorScheme)
        }
    }
    
    private func getCategory(for name: String) -> ProtocolCategory {
        let lowerName = name.lowercased()
        
        if lowerName.contains("cardiac") || lowerName.contains("heart") || 
           lowerName.contains("code blue") || lowerName.contains("stemi") ||
           lowerName.contains("hypotension") || lowerName.contains("shock") ||
           lowerName.contains("tachycardia") || lowerName.contains("anemia") ||
           lowerName.contains("coagulopathy") || lowerName.contains("thrombocytopenia") ||
           lowerName.contains("hypertensive") {
            return .cardiac
        } else if lowerName.contains("neuro") || lowerName.contains("brain") ||
                  lowerName.contains("stroke") || lowerName.contains("altered mental") {
            return .neurological
        } else if lowerName.contains("respiratory") || lowerName.contains("breath") ||
                  lowerName.contains("lung") || lowerName.contains("airway") ||
                  lowerName.contains("pneumothorax") || lowerName.contains("rsi") ||
                  lowerName.contains("hypox") {
            return .respiratory
        } else if lowerName.contains("trauma") || lowerName.contains("fall") {
            return .trauma
        } else if lowerName.contains("sepsis") || lowerName.contains("infectious") ||
                  lowerName.contains("dka") || lowerName.contains("hypoglycemia") ||
                  lowerName.contains("adrenal") || lowerName.contains("electrolyte") ||
                  lowerName.contains("sodium") || lowerName.contains("kalemia") ||
                  lowerName.contains("calcemia") {
            return .infectious
        } else if lowerName.contains("anaphylaxis") || lowerName.contains("allergic") {
            return .allergic
        } else if lowerName.contains("support") || lowerName.contains("rrt") {
            return .support
        } else {
            return .cardiac // Default
        }
    }
}