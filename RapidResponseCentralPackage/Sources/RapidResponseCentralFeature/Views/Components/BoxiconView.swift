import SwiftUI

// MARK: - Boxicon View Component

/*
 ICON USAGE GUIDELINES FOR RAPID RESPONSE CENTRAL
 ================================================
 
 VISUAL STORYTELLING PRINCIPLES:
 - Icons create instant visual recognition and positional memory
 - Each protocol should have a UNIQUE, semantically meaningful icon
 - Colors should align with medical protocol categories
 - Fallback SF Symbols ensure universal accessibility
 
 ICON NAMING CONVENTIONS:
 - Emergency Protocols: "healthicon-[medical_device/condition]"
 - RRT Protocols: "healthicon-[assessment_type]"
 - Calls Protocols: "healthicon-[treatment_focus]"
 - Labs Protocols: "healthicon-[lab_component]"
 - Generic Medical: "bx-[medical_term]"
 
 CATEGORY COLOR MAPPING:
 - Cardiac (.red): Heart conditions, blood pressure, circulation
 - Neurological (.purple): Brain, mental status, seizures
 - Respiratory (.blue): Lungs, oxygen, ventilation
 - Labs/Blood (.orange): Blood work, glucose, testing
 - Metabolic (.green): Electrolytes, kidney, liver
 - Emergency (.red): Critical alerts, anaphylaxis
 - Trauma (.yellow): Injuries, pain, physical damage
 - Support (.teal): General medical care, stethoscope
 
 UNIQUE PROTOCOL ICONS:
 Emergency Tab:
 - Code Blue ACLS: healthicon-defibrillator (red bolt.heart.fill)
 - Code Stroke: healthicon-neurology (purple brain.head.profile)
 - Code STEMI: healthicon-heart_organ (red heart.text.square.fill)
 - RSI: healthicon-endotracheal_tube (blue lungs.fill)
 - Shock/ECMO: healthicon-ecmo (red heart.circle.fill)
 - Anaphylaxis: healthicon-anaphylaxis (red exclamationmark.triangle.fill)
 - Emergency Support: healthicon-emergency_support (red phone.badge.plus)
 
 RRT Tab:
 - Chest Pain: healthicon-stethoscope (teal stethoscope)
 - Shortness of Breath: healthicon-oxygen_tank (blue wind)
 - Altered Mental Status: healthicon-neurological_assessment (purple brain.head.profile)
 - Tachycardia: healthicon-blood_pressure_monitor (red waveform.path.ecg)
 - Hypotension & Hemorrhage: healthicon-blood_bag (red drop.fill)
 - Falls Assessment: healthicon-trauma (yellow bandage.fill)
 
 ACCESSIBILITY FEATURES:
 - All healthicons have SF Symbol fallbacks
 - High contrast color choices for medical urgency
 - Size adapts from 16px (small) to 40px (cards)
 - Template rendering mode preserves color theming
 
 PERFORMANCE OPTIMIZATIONS:
 - Static icon mappings for O(1) lookup
 - Cached SF Symbol fallbacks
 - Template rendering reduces memory footprint
 - Semantic color computation at creation time
 */

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
        // Use the centralized HealthiconLoader
        return HealthiconLoader.loadIcon(iconName)
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
            // Emergency Protocol Icons
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
            case "anaphylaxis":
                return "exclamationmark.triangle.fill"
            case "emergency_support":
                return "phone.badge.plus"
            case "trauma":
                return "bandage.fill"
            case "neurological_assessment":
                return "brain.head.profile"
            
            // RRT Protocol Icons
            case "chest_pain":
                return "heart.text.square"
            case "respiratory_distress":
                return "lungs.fill"
            case "cardiac_monitoring":
                return "waveform.path.ecg.rectangle"
            case "neurological_assessment":
                return "brain.head.profile"
            case "hypotension":
                return "gauge.low"
            case "acute_kidney_injury":
                return "drop.circle"
            case "electrolyte_imbalance":
                return "atom"
            case "oxygenation":
                return "wind.circle"
            case "pain_crisis":
                return "bandage.fill"
            case "rapid_deterioration":
                return "alarm.waves.left.and.right"
                
            // Calls Protocol Icons
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
                
            // Labs Protocol Icons
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
            
            // Additional Medical Icons
            case "iv_fluid":
                return "drop.triangle"
            case "syringe":
                return "syringe"
            case "thermometer":
                return "thermometer"
            case "pulse_oximeter":
                return "waveform.path"
            case "wheelchair":
                return "figure.roll"
            case "ambulance":
                return "cross.case"
            case "hospital_bed":
                return "bed.double"
            case "medical_chart":
                return "doc.text.fill"
            case "prescription":
                return "doc.text.image"
            case "medical_cross":
                return "cross.fill"
                
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
            
        // Additional Protocol-Specific Icons
        case "anesthesia":
            return "lungs.fill"
        case "intubation":
            return "tube.horizontal"
        case "ventilator":
            return "wind.snow"
        case "monitor":
            return "tv"
        case "ecg", "ekg":
            return "waveform.path.ecg"
        case "defibrillator":
            return "bolt.heart"
        case "oxygen":
            return "wind.circle"
        case "mask":
            return "facemask"
        case "iv", "intravenous":
            return "drop.triangle"
        case "fluid":
            return "drop.triangle.fill"
        case "transfusion":
            return "drop.circle"
        case "surgery":
            return "cross.vial"
        case "laboratory":
            return "flask"
        case "microscope":
            return "scope"
        case "xray":
            return "camera.viewfinder"
        case "scan", "ct", "mri":
            return "viewfinder.circle"
        case "ultrasound":
            return "waveform"
            
        default:
            // Try to find a reasonable match based on keywords
            if cleanName.contains("heart") {
                return "heart.fill"
            } else if cleanName.contains("emergency") || cleanName.contains("alert") {
                return "alarm.fill"
            } else if cleanName.contains("medical") || cleanName.contains("health") {
                return "cross.circle.fill"
            } else if cleanName.contains("respiratory") || cleanName.contains("lung") {
                return "lungs.fill"
            } else if cleanName.contains("cardiac") || cleanName.contains("cardio") {
                return "heart.fill"
            } else if cleanName.contains("neuro") || cleanName.contains("brain") {
                return "brain.head.profile"
            } else if cleanName.contains("trauma") || cleanName.contains("injury") {
                return "bandage.fill"
            } else {
                return "stethoscope"
            }
        }
    }
}

// MARK: - Boxicon Helper Functions

extension BoxiconView {
    /// Create a medical-themed Boxicon with appropriate color based on protocol category
    static func medical(_ iconName: String, size: CGFloat = 24) -> BoxiconView {
        let color: Color = {
            // Healthicon color assignments
            if iconName.hasPrefix("healthicon-") {
                let healthName = iconName.replacingOccurrences(of: "healthicon-", with: "")
                switch healthName {
                // Cardiac - Red theme
                case "defibrillator", "heart_organ", "ecmo", "blood_pressure_monitor", "blood_bag", "intravenous_drip", "heart_rate":
                    return .red
                // Neurological - Purple theme  
                case "neurology", "neurological_assessment":
                    return .purple
                // Respiratory - Blue theme
                case "endotracheal_tube", "oxygen_tank", "lungs", "oxygen_mask", "inhaler", "respiratory_ventilator", "ventilator":
                    return .blue
                // Labs/Blood - Orange theme
                case "blood_cells", "blood_pressure_gauge", "blood_drop", "diabetes_test", "diabetes_test_alt", "glucose_meter":
                    return .orange
                // Metabolic - Green theme
                case "salt", "water", "kidney", "kidney_alt", "kidneys", "calcium", "calcium_supplement", "minerals_alt", "phosphorus", "liver":
                    return .green
                // Emergency - Red theme
                case "anaphylaxis", "emergency_support":
                    return .red
                // Trauma - Yellow theme
                case "trauma", "body_pain":
                    return .yellow
                // General medical - Teal theme
                case "stethoscope", "medicines", "palliative_care":
                    return .teal
                default:
                    return .blue
                }
            }
            
            // Boxicon color assignments
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

// MARK: - Icon Constants for Type Safety

public struct ProtocolIcons {
    // Emergency Protocol Icons
    public static let codeBlue = "healthicon-defibrillator"
    public static let codeStroke = "healthicon-neurology"
    public static let codeSTEMI = "healthicon-heart_organ"
    public static let rsi = "healthicon-endotracheal_tube"
    public static let shock = "healthicon-ecmo"
    public static let anaphylaxis = "healthicon-anaphylaxis"
    public static let emergencySupport = "healthicon-emergency_support"
    
    // RRT Protocol Icons
    public static let chestPain = "healthicon-stethoscope"
    public static let shortnessOfBreath = "healthicon-oxygen_tank"
    public static let alteredMentalStatus = "healthicon-neurological_assessment"
    public static let tachycardia = "healthicon-blood_pressure_monitor"
    public static let hypotensionHemorrhage = "healthicon-blood_bag"
    public static let fallsAssessment = "healthicon-trauma"
    
    // Calls Protocol Icons
    public static let acuteHF = "healthicon-intravenous_drip"
    public static let rightHF = "healthicon-heart_rate"
    public static let hypertensiveEmergency = "healthicon-blood_pressure_2"
    public static let dka = "healthicon-diabetes_mellitus"
    public static let hypoglycemia = "healthicon-glucose_meter"
    public static let adrenalCrisis = "healthicon-hormone_replacement_therapy"
    public static let pneumothorax = "healthicon-lungs"
    public static let respiratoryFailure = "healthicon-oxygen_mask"
    public static let asthma = "healthicon-inhaler"
    public static let giBleeding = "healthicon-stomach"
    public static let bowelObstruction = "healthicon-intestinal_blockage"
    public static let antiemetic = "healthicon-vomiting"
    public static let acutePain = "healthicon-body_pain"
    public static let opiateConversion = "healthicon-medicines"
    public static let eolCare = "healthicon-palliative_care"
    
    // Labs Protocol Icons
    public static let anemia = "healthicon-blood_cells"
    public static let coagulopathy = "healthicon-blood_pressure_gauge"
    public static let thrombocytopenia = "healthicon-blood_drop"
    public static let hypernatremia = "healthicon-salt"
    public static let hyponatremia = "healthicon-water"
    public static let hyperkalemia = "healthicon-kidney"
    public static let hypokalemia = "healthicon-kidney_alt"
    public static let hypocalcemia = "healthicon-calcium"
    public static let hypercalcemia = "healthicon-calcium_supplement"
    public static let hypomagnesemia = "healthicon-minerals_alt"
    public static let hypophosphatemia = "healthicon-phosphorus"
    public static let hyperglycemia = "healthicon-diabetes_test"
    public static let hypoglycemiaLabs = "healthicon-diabetes_test_alt"
    public static let renalFailure = "healthicon-kidneys"
    public static let hepaticEncephalopathy = "healthicon-liver"
    public static let abgAnalysis = "healthicon-respiratory_ventilator"
    public static let acidBase = "healthicon-acid_rain"
    public static let ventilatorAdjustment = "healthicon-ventilator"
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        // Emergency Protocol Icons
        HStack(spacing: 20) {
            BoxiconView.medical("healthicon-defibrillator", size: 40)
            BoxiconView.medical("healthicon-neurology", size: 40)
            BoxiconView.medical("healthicon-heart_organ", size: 40)
            BoxiconView.medical("healthicon-endotracheal_tube", size: 40)
        }
        
        // RRT Protocol Icons
        HStack(spacing: 20) {
            BoxiconView.medical("healthicon-stethoscope", size: 40)
            BoxiconView.medical("healthicon-oxygen_tank", size: 40)
            BoxiconView.medical("healthicon-neurological_assessment", size: 40)
            BoxiconView.medical("healthicon-blood_pressure_monitor", size: 40)
        }
        
        // Labs Protocol Icons
        HStack(spacing: 20) {
            BoxiconView.medical("healthicon-blood_cells", size: 40)
            BoxiconView.medical("healthicon-kidney", size: 40)
            BoxiconView.medical("healthicon-diabetes_test", size: 40)
            BoxiconView.medical("healthicon-liver", size: 40)
        }
        
        Text("RRC Medical Protocol Icons")
            .font(.caption)
            .foregroundColor(.secondary)
        
        Text("Healthicons with SF Symbol Fallbacks")
            .font(.caption2)
            .foregroundColor(Color.secondary)
    }
    .padding()
}