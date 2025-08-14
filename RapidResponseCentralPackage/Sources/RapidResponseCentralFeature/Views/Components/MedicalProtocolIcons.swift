import SwiftUI

// MARK: - Medical Protocol Icon System
/// A comprehensive icon system for medical protocols with SF Symbol fallbacks
public struct MedicalProtocolIcon: View {
    @Environment(\.colorScheme) private var colorScheme
    let protocolName: String
    let size: CGFloat
    let style: IconStyle
    
    public enum IconStyle {
        case filled
        case outlined
        case gradient
        case animated
    }
    
    public init(_ protocolName: String, size: CGFloat = 24, style: IconStyle = .filled) {
        self.protocolName = protocolName
        self.size = size
        self.style = style
    }
    
    public var body: some View {
        Group {
            let lowerName = protocolName.lowercased()
            
            // Emergency Icons - using contains for partial matches
            if lowerName.contains("code blue") {
                CodeBlueIcon(size: size, style: style)
            } else if lowerName.contains("code stroke") {
                CodeStrokeIcon(size: size, style: style)
            } else if lowerName.contains("code stemi") || lowerName.contains("stemi") {
                CodeSTEMIIcon(size: size, style: style)
            } else if lowerName.contains("rsi") || lowerName.contains("rapid sequence") {
                RSIIcon(size: size, style: style)
            } else if lowerName.contains("shock") || lowerName.contains("ecmo") {
                ShockECMOIcon(size: size, style: style)
            } else if lowerName.contains("anaphylaxis") {
                AnaphylaxisIcon(size: size, style: style)
            
            // RRT Icons
            } else if lowerName.contains("sepsis") {
                SepsisIcon(size: size, style: style)
            } else if lowerName.contains("respiratory") {
                RespiratoryDistressIcon(size: size, style: style)
            } else if lowerName.contains("cardiac monitoring") {
                CardiacMonitoringIcon(size: size, style: style)
            } else if lowerName.contains("neurological") {
                NeurologicalAssessmentIcon(size: size, style: style)
            } else if lowerName.contains("hypotension") {
                HypotensionIcon(size: size, style: style)
            } else if lowerName.contains("aki") || lowerName.contains("acute kidney") {
                AKIIcon(size: size, style: style)
            
            // Calls Icons
            } else if lowerName.contains("acute hf") || lowerName.contains("heart failure") {
                AcuteHFIcon(size: size, style: style)
            } else if lowerName.contains("hypertensive") {
                HypertensiveEmergencyIcon(size: size, style: style)
            } else if lowerName.contains("dka") || lowerName.contains("diabetic") {
                DKAIcon(size: size, style: style)
            } else if lowerName.contains("hypoglycemia") {
                HypoglycemiaIcon(size: size, style: style)
            } else if lowerName.contains("adrenal") {
                AdrenalCrisisIcon(size: size, style: style)
            } else if lowerName.contains("pneumothorax") {
                PneumothoraxIcon(size: size, style: style)
            
            // Labs Icons
            } else if lowerName.contains("anemia") {
                AnemiaIcon(size: size, style: style)
            } else if lowerName.contains("coagulopathy") {
                CoagulopathyIcon(size: size, style: style)
            } else if lowerName.contains("electrolyte") {
                ElectrolyteIcon(size: size, style: style)
            } else if lowerName.contains("renal failure") {
                RenalFailureIcon(size: size, style: style)
            } else if lowerName.contains("abg") || lowerName.contains("blood gas") {
                ABGAnalysisIcon(size: size, style: style)
            
            // Emergency Support
            } else if lowerName.contains("emergency support") || lowerName.contains("rrt support") {
                Image(systemName: "lifepreserver.fill")
                    .font(.system(size: size))
                    .symbolRenderingMode(style == .filled ? .monochrome : .hierarchical)
            } else {
                // Fallback to SF Symbol
                Image(systemName: getFallbackIcon(for: protocolName))
                    .font(.system(size: size))
                    .symbolRenderingMode(style == .filled ? .monochrome : .hierarchical)
            }
        }
    }
    
    private func getFallbackIcon(for protocolName: String) -> String {
        switch protocolName.lowercased() {
        case let p where p.contains("cardiac") || p.contains("heart"):
            return "heart.fill"
        case let p where p.contains("neuro") || p.contains("brain"):
            return "brain"
        case let p where p.contains("respiratory") || p.contains("lung"):
            return "lungs.fill"
        case let p where p.contains("renal") || p.contains("kidney"):
            return "drop.triangle.fill"
        case let p where p.contains("lab"):
            return "flask.fill"
        default:
            return "cross.case.fill"
        }
    }
}

// MARK: - Emergency Protocol Icons

struct CodeBlueIcon: View {
    let size: CGFloat
    let style: MedicalProtocolIcon.IconStyle
    @State private var isAnimating = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            // Background gradient
            RoundedRectangle(cornerRadius: size * 0.2)
                .fill(MedicalIconSystem.Gradients.blue(for: colorScheme))
            
            // Simple heart with ECG line
            Image(systemName: "heart.fill")
                .font(.system(size: size * 0.6, weight: .bold))
                .foregroundColor(.white)
                .scaleEffect(isAnimating && style == .animated ? 1.1 : 1.0)
        }
        .frame(width: size, height: size)
        .onAppear {
            if style == .animated {
                withAnimation(Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                    isAnimating = true
                }
            }
        }
    }
}

struct CodeStrokeIcon: View {
    let size: CGFloat
    let style: MedicalProtocolIcon.IconStyle
    @State private var isAnimating = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            // Background gradient using new design system
            MedicalIconSystem.Gradients.orange(for: colorScheme)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            
            VStack(spacing: size * 0.08) {
                // Clock showing 4.5 hours
                ZStack {
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                        .frame(width: size * 0.35, height: size * 0.35)
                    
                    // Clock hands pointing to 4:30
                    Path { path in
                        // Hour hand
                        path.move(to: CGPoint(x: 0, y: 0))
                        path.addLine(to: CGPoint(x: size * 0.08, y: -size * 0.08))
                    }
                    .stroke(Color.white, lineWidth: 2)
                    
                    Path { path in
                        // Minute hand
                        path.move(to: CGPoint(x: 0, y: 0))
                        path.addLine(to: CGPoint(x: 0, y: size * 0.12))
                    }
                    .stroke(Color.white, lineWidth: 2)
                    
                    // 4.5hr label
                    Text("4.5hr")
                        .font(.system(size: size * 0.08, weight: .bold))
                        .foregroundColor(.white)
                        .offset(y: size * 0.25)
                }
                
                // Brain with affected area
                ZStack {
                    Image(systemName: "brain")
                        .font(.system(size: size * 0.4))
                        .foregroundColor(.white)
                    
                    // Stroke area indicator
                    Circle()
                        .fill(Color.yellow.opacity(0.8))
                        .frame(width: size * 0.12, height: size * 0.12)
                        .offset(x: size * 0.08, y: -size * 0.05)
                        .scaleEffect(style == .animated && isAnimating ? 1.3 : 1.0)
                }
                
                // tPA text
                Text("tPA")
                    .font(.system(size: size * 0.14, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .frame(width: size, height: size)
        .onAppear {
            if style == .animated {
                withAnimation(Animation.easeInOut(duration: 1.0).repeatForever()) {
                    isAnimating = true
                }
            }
        }
    }
}

struct CodeSTEMIIcon: View {
    let size: CGFloat
    let style: MedicalProtocolIcon.IconStyle
    @State private var isAnimating = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            // Background gradient using new design system
            MedicalIconSystem.Gradients.red(for: colorScheme)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            
            VStack(spacing: size * 0.06) {
                // ST Elevation ECG
                Path { path in
                    let width = size * 0.8
                    let height = size * 0.25
                    
                    // STEMI pattern with ST elevation
                    path.move(to: CGPoint(x: -width/2, y: 0))
                    path.addLine(to: CGPoint(x: -width/3, y: 0))
                    // Q wave
                    path.addLine(to: CGPoint(x: -width/3, y: height * 0.3))
                    path.addLine(to: CGPoint(x: -width/3 + 2, y: 0))
                    // R wave
                    path.addLine(to: CGPoint(x: -width/4, y: -height))
                    path.addLine(to: CGPoint(x: -width/4 + 2, y: 0))
                    // Elevated ST segment
                    path.addQuadCurve(
                        to: CGPoint(x: 0, y: -height * 0.4),
                        control: CGPoint(x: -width/8, y: -height * 0.5)
                    )
                    // T wave
                    path.addQuadCurve(
                        to: CGPoint(x: width/4, y: 0),
                        control: CGPoint(x: width/8, y: -height * 0.2)
                    )
                    path.addLine(to: CGPoint(x: width/2, y: 0))
                }
                .stroke(Color.yellow, lineWidth: 2.5)
                .frame(height: size * 0.25)
                
                // Heart with catheter
                ZStack {
                    Image(systemName: "heart.fill")
                        .font(.system(size: size * 0.35))
                        .foregroundColor(.white)
                    
                    // Catheter line
                    Path { path in
                        path.move(to: CGPoint(x: -size * 0.15, y: size * 0.1))
                        path.addQuadCurve(
                            to: CGPoint(x: 0, y: -size * 0.05),
                            control: CGPoint(x: -size * 0.08, y: 0)
                        )
                    }
                    .stroke(Color.yellow, lineWidth: 1.5)
                }
                
                // 90 min text
                Text("90 min")
                    .font(.system(size: size * 0.12, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
                    .padding(.horizontal, size * 0.08)
                    .background(
                        Capsule()
                            .fill(Color.black.opacity(0.3))
                    )
            }
        }
        .frame(width: size, height: size)
        .onAppear {
            if style == .animated {
                withAnimation(Animation.easeInOut(duration: 0.8).repeatForever()) {
                    isAnimating = true
                }
            }
        }
    }
}

struct RSIIcon: View {
    let size: CGFloat
    let style: MedicalProtocolIcon.IconStyle
    @State private var isAnimating = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            // Background gradient using new design system
            MedicalIconSystem.Gradients.purple(for: colorScheme)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            
            VStack(spacing: size * 0.08) {
                // Intubation tube
                ZStack {
                    // Tube shape
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: -size * 0.3))
                        path.addLine(to: CGPoint(x: 0, y: -size * 0.1))
                        path.addQuadCurve(
                            to: CGPoint(x: size * 0.1, y: size * 0.1),
                            control: CGPoint(x: 0, y: 0)
                        )
                    }
                    .stroke(Color.white, lineWidth: 3)
                    
                    // Laryngoscope blade
                    Path { path in
                        path.move(to: CGPoint(x: -size * 0.15, y: -size * 0.2))
                        path.addLine(to: CGPoint(x: -size * 0.05, y: 0))
                        path.addLine(to: CGPoint(x: -size * 0.08, y: 0))
                    }
                    .stroke(Color.yellow, lineWidth: 2)
                }
                
                // Medication labels
                HStack(spacing: size * 0.05) {
                    MedicationLabel(text: "Etomidate", size: size * 0.08)
                    MedicationLabel(text: "Sux", size: size * 0.08)
                }
                
                // Sequence indicator
                HStack(spacing: 2) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(index == 0 && isAnimating ? Color.green : Color.white.opacity(0.5))
                            .frame(width: size * 0.06, height: size * 0.06)
                    }
                }
            }
        }
        .frame(width: size, height: size)
        .onAppear {
            if style == .animated {
                withAnimation(Animation.easeInOut(duration: 1.0).repeatForever()) {
                    isAnimating = true
                }
            }
        }
    }
}

struct MedicationLabel: View {
    let text: String
    let size: CGFloat
    
    var body: some View {
        Text(text)
            .font(.system(size: size, weight: .semibold))
            .foregroundColor(.white)
            .padding(.horizontal, size * 0.5)
            .padding(.vertical, size * 0.2)
            .background(
                RoundedRectangle(cornerRadius: size * 0.3)
                    .fill(Color.white.opacity(0.2))
            )
    }
}

struct ShockECMOIcon: View {
    let size: CGFloat
    let style: MedicalProtocolIcon.IconStyle
    @State private var isAnimating = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            // Background gradient using new design system
            MedicalIconSystem.Gradients.pink(for: colorScheme)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            
            VStack(spacing: size * 0.08) {
                // ECMO circuit visualization
                ZStack {
                    // Circuit tubes
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                        .frame(width: size * 0.5, height: size * 0.5)
                    
                    // Flow indicators
                    ForEach(0..<4) { index in
                        Circle()
                            .fill(Color.red)
                            .frame(width: size * 0.08, height: size * 0.08)
                            .offset(
                                x: cos(CGFloat(index) * .pi / 2 + (isAnimating ? .pi * 2 : 0)) * size * 0.25,
                                y: sin(CGFloat(index) * .pi / 2 + (isAnimating ? .pi * 2 : 0)) * size * 0.25
                            )
                    }
                    
                    // Central pump
                    Circle()
                        .fill(Color.white)
                        .frame(width: size * 0.2, height: size * 0.2)
                        .overlay(
                            Text("VA")
                                .font(.system(size: size * 0.08, weight: .bold))
                                .foregroundColor(Color(hex: "#E91E63"))
                        )
                }
                
                // Vasopressor indicators
                HStack(spacing: size * 0.04) {
                    VasopressorIndicator(name: "Epi", size: size * 0.08)
                    VasopressorIndicator(name: "Levo", size: size * 0.08)
                    VasopressorIndicator(name: "Vaso", size: size * 0.08)
                }
            }
        }
        .frame(width: size, height: size)
        .onAppear {
            if style == .animated {
                withAnimation(Animation.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                    isAnimating = true
                }
            }
        }
    }
}

struct VasopressorIndicator: View {
    let name: String
    let size: CGFloat
    
    var body: some View {
        Text(name)
            .font(.system(size: size, weight: .medium))
            .foregroundColor(.white)
            .padding(.horizontal, size * 0.3)
            .background(
                Capsule()
                    .fill(Color.black.opacity(0.3))
            )
    }
}

struct AnaphylaxisIcon: View {
    let size: CGFloat
    let style: MedicalProtocolIcon.IconStyle
    @State private var isAnimating = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            // Background gradient using new design system
            MedicalIconSystem.Gradients.orange(for: colorScheme)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            
            VStack(spacing: size * 0.08) {
                // Bee/allergen symbol
                ZStack {
                    // Hexagon for bee/allergen
                    Hexagon()
                        .fill(Color.yellow)
                        .frame(width: size * 0.25, height: size * 0.25)
                    
                    Text("🐝")
                        .font(.system(size: size * 0.15))
                }
                
                // EpiPen visualization
                ZStack {
                    RoundedRectangle(cornerRadius: size * 0.05)
                        .fill(Color.white)
                        .frame(width: size * 0.15, height: size * 0.4)
                    
                    // Needle indicator
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: size * 0.2))
                        path.addLine(to: CGPoint(x: 0, y: size * 0.25))
                    }
                    .stroke(Color.orange, lineWidth: 2)
                    
                    // Epi label
                    Text("EPI")
                        .font(.system(size: size * 0.08, weight: .bold))
                        .foregroundColor(.orange)
                        .rotationEffect(.degrees(-90))
                }
                .scaleEffect(style == .animated && isAnimating ? 1.1 : 1.0)
                
                // IM 0.3mg text
                Text("IM 0.3mg")
                    .font(.system(size: size * 0.1, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
            }
        }
        .frame(width: size, height: size)
        .onAppear {
            if style == .animated {
                withAnimation(Animation.easeInOut(duration: 0.8).repeatForever()) {
                    isAnimating = true
                }
            }
        }
    }
}

struct Hexagon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        for i in 0..<6 {
            let angle = CGFloat(i) * .pi / 3 - .pi / 6
            let x = center.x + radius * cos(angle)
            let y = center.y + radius * sin(angle)
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        return path
    }
}

// MARK: - RRT Protocol Icons

struct SepsisIcon: View {
    let size: CGFloat
    let style: MedicalProtocolIcon.IconStyle
    @State private var isAnimating = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            // Background gradient using new design system
            MedicalIconSystem.Gradients.salmon(for: colorScheme)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            
            VStack(spacing: size * 0.08) {
                // SOFA score display
                HStack(spacing: size * 0.02) {
                    Text("SOFA")
                        .font(.system(size: size * 0.1, weight: .bold))
                        .foregroundColor(.white)
                    Text("≥ 2")
                        .font(.system(size: size * 0.12, weight: .bold, design: .monospaced))
                        .foregroundColor(.yellow)
                }
                
                // Bacteria visualization
                HStack(spacing: size * 0.08) {
                    ForEach(0..<3) { _ in
                        Circle()
                            .fill(Color.red.opacity(0.8))
                            .frame(width: size * 0.12, height: size * 0.12)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 1)
                            )
                            .scaleEffect(style == .animated && isAnimating ? 1.2 : 0.8)
                    }
                }
                
                // Lactate value
                HStack(spacing: size * 0.04) {
                    Text("Lactate")
                        .font(.system(size: size * 0.09, weight: .medium))
                        .foregroundColor(.white)
                    Text(">2")
                        .font(.system(size: size * 0.11, weight: .bold, design: .monospaced))
                        .foregroundColor(.orange)
                }
                
                // Bundle hour indicator
                Text("1hr Bundle")
                    .font(.system(size: size * 0.09, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, size * 0.08)
                    .padding(.vertical, size * 0.04)
                    .background(
                        Capsule()
                            .fill(Color.red.opacity(0.8))
                    )
            }
        }
        .frame(width: size, height: size)
        .onAppear {
            if style == .animated {
                withAnimation(Animation.easeInOut(duration: 1.0).repeatForever()) {
                    isAnimating = true
                }
            }
        }
    }
}

struct RespiratoryDistressIcon: View {
    let size: CGFloat
    let style: MedicalProtocolIcon.IconStyle
    @State private var isAnimating = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            // Background gradient using new design system
            MedicalIconSystem.Gradients.teal(for: colorScheme)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            
            VStack(spacing: size * 0.06) {
                // SpO2 value
                HStack(spacing: size * 0.04) {
                    Text("SpO₂")
                        .font(.system(size: size * 0.11, weight: .medium))
                        .foregroundColor(.white)
                    Text("<90%")
                        .font(.system(size: size * 0.12, weight: .bold, design: .monospaced))
                        .foregroundColor(.red)
                        .scaleEffect(style == .animated && isAnimating ? 1.1 : 0.9)
                }
                
                // Lungs with distress indicator
                ZStack {
                    Image(systemName: "lungs.fill")
                        .font(.system(size: size * 0.35))
                        .foregroundColor(.white.opacity(0.9))
                    
                    // Distress waves
                    ForEach(0..<3) { index in
                        Circle()
                            .stroke(Color.red.opacity(0.6 - Double(index) * 0.2), lineWidth: 1)
                            .frame(width: size * (0.3 + CGFloat(index) * 0.1), height: size * (0.3 + CGFloat(index) * 0.1))
                            .scaleEffect(style == .animated && isAnimating ? 1.3 : 1.0)
                            .opacity(style == .animated && isAnimating ? 0 : 1)
                    }
                }
                
                // RR value
                HStack(spacing: size * 0.04) {
                    Text("RR")
                        .font(.system(size: size * 0.1, weight: .medium))
                        .foregroundColor(.white)
                    Text(">30")
                        .font(.system(size: size * 0.12, weight: .bold, design: .monospaced))
                        .foregroundColor(.yellow)
                }
                
                // BiPAP indicator
                Text("BiPAP")
                    .font(.system(size: size * 0.1, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, size * 0.08)
                    .padding(.vertical, size * 0.03)
                    .background(
                        Capsule()
                            .fill(Color.blue.opacity(0.6))
                    )
            }
        }
        .frame(width: size, height: size)
        .onAppear {
            if style == .animated {
                withAnimation(Animation.easeInOut(duration: 0.8).repeatForever()) {
                    isAnimating = true
                }
            }
        }
    }
}

struct CardiacMonitoringIcon: View {
    let size: CGFloat
    let style: MedicalProtocolIcon.IconStyle
    @State private var isAnimating = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            // Monitor frame
            RoundedRectangle(cornerRadius: 4)
                .stroke(
                    style == .gradient ?
                    MedicalIconSystem.Gradients.green(for: colorScheme) :
                    LinearGradient(colors: [MedicalIconSystem.Colors.green1(for: colorScheme), MedicalIconSystem.Colors.green1(for: colorScheme)], startPoint: .top, endPoint: .bottom),
                    lineWidth: 2
                )
                .frame(width: size, height: size * 0.8)
            
            // ECG wave
            Path { path in
                let width = size * 0.8
                let height = size * 0.4
                let midY = 0.0
                
                path.move(to: CGPoint(x: -width/2, y: midY))
                path.addLine(to: CGPoint(x: -width/4, y: midY))
                path.addLine(to: CGPoint(x: -width/4 + 2, y: -height/2))
                path.addLine(to: CGPoint(x: -width/4 + 4, y: height/2))
                path.addLine(to: CGPoint(x: -width/4 + 6, y: midY))
                path.addLine(to: CGPoint(x: 0, y: midY))
                path.addLine(to: CGPoint(x: width/8, y: -height/4))
                path.addLine(to: CGPoint(x: width/4, y: midY))
                path.addLine(to: CGPoint(x: width/2, y: midY))
            }
            .stroke(Color.green, lineWidth: 2)
            .offset(x: style == .animated && isAnimating ? size : -size)
            .animation(style == .animated ? Animation.linear(duration: 2.0).repeatForever(autoreverses: false) : nil, value: isAnimating)
        }
        .onAppear {
            if style == .animated {
                isAnimating = true
            }
        }
    }
}

struct NeurologicalAssessmentIcon: View {
    let size: CGFloat
    let style: MedicalProtocolIcon.IconStyle
    
    var body: some View {
        ZStack {
            // Brain
            Image(systemName: "brain")
                .font(.system(size: size * 0.8))
                .foregroundStyle(
                    style == .gradient ?
                    LinearGradient(colors: [.purple, .pink], startPoint: .top, endPoint: .bottom) :
                    LinearGradient(colors: [.purple, .purple], startPoint: .top, endPoint: .bottom)
                )
            
            // Assessment checkmarks
            VStack(spacing: 1) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: size * 0.15))
                    .foregroundColor(.green)
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: size * 0.15))
                    .foregroundColor(.green)
            }
            .offset(x: size * 0.3, y: 0)
        }
    }
}

struct HypotensionIcon: View {
    let size: CGFloat
    let style: MedicalProtocolIcon.IconStyle
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color(hex: "#3F51B5"), Color(hex: "#283593")],
                startPoint: .top,
                endPoint: .bottom
            )
            .clipShape(RoundedRectangle(cornerRadius: size * 0.15))
            
            VStack(spacing: size * 0.08) {
                // Blood pressure display
                VStack(spacing: size * 0.02) {
                    Text("MAP < 65")
                        .font(.system(size: size * 0.12, weight: .bold, design: .monospaced))
                        .foregroundColor(.red)
                    
                    // BP values
                    HStack(spacing: size * 0.02) {
                        Text("SBP")
                            .font(.system(size: size * 0.09, weight: .medium))
                            .foregroundColor(.white)
                        Text("<90")
                            .font(.system(size: size * 0.11, weight: .bold, design: .monospaced))
                            .foregroundColor(.orange)
                    }
                }
                
                // Pressure gauge visualization
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 3)
                        .frame(width: size * 0.4, height: size * 0.4)
                    
                    Circle()
                        .trim(from: 0, to: 0.2)
                        .stroke(Color.red, lineWidth: 4)
                        .frame(width: size * 0.4, height: size * 0.4)
                        .rotationEffect(.degrees(-90))
                    
                    // Needle pointing low
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: 2, height: size * 0.15)
                        .offset(y: -size * 0.075)
                        .rotationEffect(.degrees(-45))
                        .rotationEffect(.degrees(style == .animated && isAnimating ? -5 : 5))
                }
                
                // Fluid/Pressor indicators
                HStack(spacing: size * 0.06) {
                    Text("IVF")
                        .font(.system(size: size * 0.09, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, size * 0.05)
                        .background(
                            Capsule()
                                .fill(Color.blue.opacity(0.6))
                        )
                    
                    Text("Pressors")
                        .font(.system(size: size * 0.09, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, size * 0.05)
                        .background(
                            Capsule()
                                .fill(Color.purple.opacity(0.6))
                        )
                }
            }
        }
        .frame(width: size, height: size)
        .onAppear {
            if style == .animated {
                withAnimation(Animation.easeInOut(duration: 1.0).repeatForever()) {
                    isAnimating = true
                }
            }
        }
    }
}

struct AKIIcon: View {
    let size: CGFloat
    let style: MedicalProtocolIcon.IconStyle
    
    var body: some View {
        ZStack {
            // Kidney shape (using drop as approximation)
            Image(systemName: "drop.fill")
                .font(.system(size: size))
                .foregroundStyle(
                    style == .gradient ?
                    LinearGradient(colors: [.orange, .red], startPoint: .top, endPoint: .bottom) :
                    LinearGradient(colors: [.orange, .orange], startPoint: .top, endPoint: .bottom)
                )
            
            // Alert indicator
            Image(systemName: "exclamationmark")
                .font(.system(size: size * 0.4, weight: .bold))
                .foregroundColor(.white)
        }
    }
}

// MARK: - Calls Protocol Icons

struct AcuteHFIcon: View {
    let size: CGFloat
    let style: MedicalProtocolIcon.IconStyle
    
    var body: some View {
        ZStack {
            // Heart
            Image(systemName: "heart.fill")
                .font(.system(size: size))
                .foregroundStyle(
                    style == .gradient ?
                    LinearGradient(colors: [.red, .purple], startPoint: .top, endPoint: .bottom) :
                    LinearGradient(colors: [.red, .red], startPoint: .top, endPoint: .bottom)
                )
            
            // Fluid/congestion indicator
            Image(systemName: "drop.fill")
                .font(.system(size: size * 0.3))
                .foregroundColor(.blue)
                .offset(x: size * 0.2, y: size * 0.2)
        }
    }
}

struct HypertensiveEmergencyIcon: View {
    let size: CGFloat
    let style: MedicalProtocolIcon.IconStyle
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            // Pressure gauge
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 3)
                .frame(width: size, height: size)
            
            // High pressure indicator (full)
            Circle()
                .trim(from: 0, to: 0.85)
                .stroke(
                    style == .gradient ?
                    LinearGradient(colors: [.red, .pink], startPoint: .leading, endPoint: .trailing) :
                    LinearGradient(colors: [.red, .red], startPoint: .leading, endPoint: .trailing),
                    lineWidth: 3
                )
                .frame(width: size, height: size)
                .rotationEffect(.degrees(-90))
            
            // Up arrow
            Image(systemName: "arrow.up.circle.fill")
                .font(.system(size: size * 0.4))
                .foregroundColor(.red)
                .scaleEffect(style == .animated && isAnimating ? 1.2 : 1.0)
        }
        .onAppear {
            if style == .animated {
                withAnimation(Animation.easeInOut(duration: 0.8).repeatForever()) {
                    isAnimating = true
                }
            }
        }
    }
}

struct DKAIcon: View {
    let size: CGFloat
    let style: MedicalProtocolIcon.IconStyle
    
    var body: some View {
        ZStack {
            // Glucose molecule representation
            Circle()
                .fill(
                    style == .gradient ?
                    LinearGradient(colors: [.orange, .yellow], startPoint: .top, endPoint: .bottom) :
                    LinearGradient(colors: [.orange, .orange], startPoint: .top, endPoint: .bottom)
                )
                .frame(width: size * 0.8, height: size * 0.8)
            
            // Ketone/acid indicator
            Text("K+")
                .font(.system(size: size * 0.3, weight: .bold))
                .foregroundColor(.white)
        }
    }
}

struct HypoglycemiaIcon: View {
    let size: CGFloat
    let style: MedicalProtocolIcon.IconStyle
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            // Glucose meter
            RoundedRectangle(cornerRadius: size * 0.2)
                .fill(
                    style == .gradient ?
                    LinearGradient(colors: [.blue, .cyan], startPoint: .top, endPoint: .bottom) :
                    LinearGradient(colors: [.blue, .blue], startPoint: .top, endPoint: .bottom)
                )
                .frame(width: size, height: size * 0.8)
            
            // Low reading
            Text("LO")
                .font(.system(size: size * 0.3, weight: .bold, design: .monospaced))
                .foregroundColor(.red)
                .opacity(style == .animated && isAnimating ? 0.3 : 1.0)
        }
        .onAppear {
            if style == .animated {
                withAnimation(Animation.easeInOut(duration: 0.5).repeatForever()) {
                    isAnimating = true
                }
            }
        }
    }
}

struct AdrenalCrisisIcon: View {
    let size: CGFloat
    let style: MedicalProtocolIcon.IconStyle
    
    var body: some View {
        ZStack {
            // Adrenal gland representation (triangle)
            Triangle()
                .fill(
                    style == .gradient ?
                    LinearGradient(colors: [.purple, .indigo], startPoint: .top, endPoint: .bottom) :
                    LinearGradient(colors: [.purple, .purple], startPoint: .top, endPoint: .bottom)
                )
                .frame(width: size, height: size * 0.8)
            
            // Crisis indicator
            Image(systemName: "bolt.fill")
                .font(.system(size: size * 0.4))
                .foregroundColor(.yellow)
        }
    }
}

struct PneumothoraxIcon: View {
    let size: CGFloat
    let style: MedicalProtocolIcon.IconStyle
    
    var body: some View {
        ZStack {
            // Collapsed lung
            Image(systemName: "lungs.fill")
                .font(.system(size: size))
                .foregroundStyle(
                    style == .gradient ?
                    LinearGradient(colors: [.gray, .black], startPoint: .top, endPoint: .bottom) :
                    LinearGradient(colors: [.gray, .gray], startPoint: .top, endPoint: .bottom)
                )
            
            // Air leak indicator
            Image(systemName: "wind")
                .font(.system(size: size * 0.4))
                .foregroundColor(.cyan)
                .offset(x: size * 0.25, y: -size * 0.1)
        }
    }
}

// MARK: - Labs Protocol Icons

struct AnemiaIcon: View {
    let size: CGFloat
    let style: MedicalProtocolIcon.IconStyle
    
    var body: some View {
        ZStack {
            // Blood cells (fewer/pale)
            ForEach(0..<3) { index in
                Circle()
                    .stroke(
                        style == .gradient ?
                        LinearGradient(colors: [.red.opacity(0.5), .pink.opacity(0.5)], startPoint: .top, endPoint: .bottom) :
                        LinearGradient(colors: [.red.opacity(0.5), .red.opacity(0.5)], startPoint: .top, endPoint: .bottom),
                        lineWidth: 2
                    )
                    .frame(width: size * 0.3, height: size * 0.3)
                    .offset(
                        x: CGFloat(index - 1) * size * 0.25,
                        y: CGFloat(index % 2) * size * 0.15
                    )
            }
            
            // Low indicator
            Image(systemName: "arrow.down")
                .font(.system(size: size * 0.3, weight: .bold))
                .foregroundColor(.red)
                .offset(y: size * 0.3)
        }
    }
}

struct CoagulopathyIcon: View {
    let size: CGFloat
    let style: MedicalProtocolIcon.IconStyle
    
    var body: some View {
        ZStack {
            // Blood drop
            Image(systemName: "drop.fill")
                .font(.system(size: size))
                .foregroundStyle(
                    style == .gradient ?
                    LinearGradient(colors: [.red, .purple], startPoint: .top, endPoint: .bottom) :
                    LinearGradient(colors: [.red, .red], startPoint: .top, endPoint: .bottom)
                )
            
            // Clotting issue indicator
            Image(systemName: "timer")
                .font(.system(size: size * 0.4))
                .foregroundColor(.yellow)
        }
    }
}

struct ElectrolyteIcon: View {
    let size: CGFloat
    let style: MedicalProtocolIcon.IconStyle
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            // Ion representation
            ForEach(0..<4) { index in
                Circle()
                    .fill(index % 2 == 0 ? Color.blue : Color.orange)
                    .frame(width: size * 0.2, height: size * 0.2)
                    .offset(
                        x: cos(CGFloat(index) * .pi / 2) * size * 0.35,
                        y: sin(CGFloat(index) * .pi / 2) * size * 0.35
                    )
                    .overlay(
                        Text(index % 2 == 0 ? "+" : "-")
                            .font(.system(size: size * 0.1, weight: .bold))
                            .foregroundColor(.white)
                    )
                    .scaleEffect(style == .animated && isAnimating ? 1.2 : 1.0)
            }
        }
        .onAppear {
            if style == .animated {
                withAnimation(Animation.easeInOut(duration: 1.5).repeatForever()) {
                    isAnimating = true
                }
            }
        }
    }
}

struct RenalFailureIcon: View {
    let size: CGFloat
    let style: MedicalProtocolIcon.IconStyle
    
    var body: some View {
        ZStack {
            // Kidney (droplet shape)
            Image(systemName: "drop.fill")
                .font(.system(size: size))
                .foregroundStyle(
                    style == .gradient ?
                    LinearGradient(colors: [.brown, .orange], startPoint: .top, endPoint: .bottom) :
                    LinearGradient(colors: [.brown, .brown], startPoint: .top, endPoint: .bottom)
                )
            
            // Failure X
            Image(systemName: "xmark")
                .font(.system(size: size * 0.4, weight: .bold))
                .foregroundColor(.red)
        }
    }
}

struct ABGAnalysisIcon: View {
    let size: CGFloat
    let style: MedicalProtocolIcon.IconStyle
    
    var body: some View {
        ZStack {
            // Test tube
            RoundedRectangle(cornerRadius: size * 0.1)
                .fill(
                    style == .gradient ?
                    LinearGradient(colors: [.cyan, .blue], startPoint: .top, endPoint: .bottom) :
                    LinearGradient(colors: [.cyan, .cyan], startPoint: .top, endPoint: .bottom)
                )
                .frame(width: size * 0.4, height: size)
            
            // pH scale
            VStack(spacing: 1) {
                Text("pH")
                    .font(.system(size: size * 0.2, weight: .bold))
                    .foregroundColor(.white)
                Text("7.4")
                    .font(.system(size: size * 0.15, design: .monospaced))
                    .foregroundColor(.green)
            }
        }
    }
}

// MARK: - Helper Shapes

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

// MARK: - Preview Provider

#Preview {
    ScrollView {
        VStack(spacing: 20) {
            // Emergency Icons
            Text("Emergency Icons")
                .font(.headline)
            HStack(spacing: 20) {
                VStack {
                    MedicalProtocolIcon("Code Blue", size: 40, style: .gradient)
                    Text("Code Blue").font(.caption)
                }
                VStack {
                    MedicalProtocolIcon("Code Stroke", size: 40, style: .gradient)
                    Text("Code Stroke").font(.caption)
                }
                VStack {
                    MedicalProtocolIcon("Code STEMI", size: 40, style: .animated)
                    Text("Code STEMI").font(.caption)
                }
            }
            
            // RRT Icons
            Text("RRT Icons")
                .font(.headline)
            HStack(spacing: 20) {
                VStack {
                    MedicalProtocolIcon("Sepsis", size: 40, style: .animated)
                    Text("Sepsis").font(.caption)
                }
                VStack {
                    MedicalProtocolIcon("Respiratory Distress", size: 40, style: .gradient)
                    Text("Respiratory").font(.caption)
                }
                VStack {
                    MedicalProtocolIcon("Cardiac Monitoring", size: 40, style: .animated)
                    Text("Cardiac").font(.caption)
                }
            }
            
            // Calls Icons
            Text("Calls Icons")
                .font(.headline)
            HStack(spacing: 20) {
                VStack {
                    MedicalProtocolIcon("DKA", size: 40, style: .gradient)
                    Text("DKA").font(.caption)
                }
                VStack {
                    MedicalProtocolIcon("Hypoglycemia", size: 40, style: .animated)
                    Text("Hypoglycemia").font(.caption)
                }
                VStack {
                    MedicalProtocolIcon("Pneumothorax", size: 40, style: .gradient)
                    Text("Pneumothorax").font(.caption)
                }
            }
            
            // Labs Icons
            Text("Labs Icons")
                .font(.headline)
            HStack(spacing: 20) {
                VStack {
                    MedicalProtocolIcon("Anemia", size: 40, style: .gradient)
                    Text("Anemia").font(.caption)
                }
                VStack {
                    MedicalProtocolIcon("Electrolyte Imbalance", size: 40, style: .animated)
                    Text("Electrolytes").font(.caption)
                }
                VStack {
                    MedicalProtocolIcon("ABG Analysis", size: 40, style: .gradient)
                    Text("ABG").font(.caption)
                }
            }
        }
        .padding()
    }
}