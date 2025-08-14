import Foundation
import UIKit
import SwiftUI

// MARK: - Healthicon Resource Loader
// Loads PNG icons from the healthicons directory in the main bundle

public struct HealthiconLoader {
    
    /// Load a healthicon PNG from the bundle resources
    /// - Parameter name: The healthicon name (without extension)
    /// - Returns: UIImage if found, nil otherwise
    public static func loadIcon(_ name: String) -> UIImage? {
        // First try loading from Assets catalog with healthicon_ prefix
        // This is the primary method for production apps
        if let image = UIImage(named: "healthicon_\(name)") {
            return image
        }
        
        // Fallback: try other naming patterns in Assets catalog
        let assetNames = [
            "healthicons/\(name)",
            name
        ]
        
        for assetName in assetNames {
            if let image = UIImage(named: assetName) {
                return image
            }
        }
        
        // If not in Assets catalog, try loading from bundle directories
        // (This is mainly for development/testing)
        let categories = [
            "devices",
            "body", 
            "conditions",
            "blood",
            "diagnostics",
            "medications",
            "people",
            "places",
            "symptoms",
            "specialties"
        ]
        
        // Try both filled and outline styles
        let styles = ["filled", "outline"]
        
        for style in styles {
            for category in categories {
                // Try loading from file path
                if let path = Bundle.main.path(forResource: name, ofType: "png", inDirectory: "healthicons/png/\(style)/\(category)"),
                   let image = UIImage(contentsOfFile: path) {
                    return image
                }
            }
        }
        
        return nil
    }
    
    /// Get the appropriate SF Symbol fallback for a healthicon
    /// - Parameter name: The healthicon name
    /// - Returns: SF Symbol system name
    public static func fallbackSymbol(for name: String) -> String {
        switch name {
        // Emergency Protocol Icons
        case "defibrillator":
            return "bolt.heart.fill"
        case "neurology":
            return "brain.head.profile"
        case "heart_organ":
            return "heart.text.square.fill"
        case "ventilator", "ventilator_alt":
            return "lungs.fill"
        case "ecmo":
            return "heart.circle.fill"
        case "anaphylaxis":
            return "exclamationmark.triangle.fill"
        case "emergency_support", "emergency_operations_center", "emergency_post":
            return "phone.badge.plus"
            
        // RRT Protocol Icons
        case "stethoscope":
            return "stethoscope"
        case "oxygen_tank":
            return "wind"
        case "blood_pressure_monitor":
            return "waveform.path.ecg"
        case "blood_bag":
            return "drop.fill"
        case "trauma", "traumatism":
            return "bandage.fill"
            
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
        case "respiratory_ventilator":
            return "wind.snow.circle"
        case "acid_rain":
            return "cloud.rain.fill"
            
        default:
            return "cross.circle.fill"
        }
    }
}

// MARK: - SwiftUI View Extension

extension Image {
    /// Create an Image from a healthicon with automatic fallback to SF Symbols
    /// - Parameters:
    ///   - healthicon: The healthicon name (without "healthicon-" prefix)
    ///   - fallback: Optional custom fallback SF Symbol name
    /// - Returns: SwiftUI Image
    public static func healthicon(_ name: String, fallback: String? = nil) -> Image {
        let cleanName = name.replacingOccurrences(of: "healthicon-", with: "")
        
        if let uiImage = HealthiconLoader.loadIcon(cleanName) {
            return Image(uiImage: uiImage)
        } else {
            let symbolName = fallback ?? HealthiconLoader.fallbackSymbol(for: cleanName)
            return Image(systemName: symbolName)
        }
    }
}