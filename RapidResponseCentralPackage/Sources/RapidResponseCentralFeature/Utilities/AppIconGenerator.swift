import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

// MARK: - App Icon Generator
// This generates a medical-themed app icon using SF Symbols

struct AppIconGenerator {
    static func generateIcon(size: CGSize) -> Image {
        #if canImport(UIKit)
        let renderer = UIGraphicsImageRenderer(size: size)
        let uiImage = renderer.image { context in
            // Background gradient
            let gradientColors = [
                UIColor(red: 0.2, green: 0.4, blue: 0.8, alpha: 1.0).cgColor,
                UIColor(red: 0.1, green: 0.3, blue: 0.6, alpha: 1.0).cgColor
            ]
            
            let gradient = CGGradient(
                colorsSpace: CGColorSpaceCreateDeviceRGB(),
                colors: gradientColors as CFArray,
                locations: [0, 1]
            )!
            
            context.cgContext.drawLinearGradient(
                gradient,
                start: CGPoint(x: 0, y: 0),
                end: CGPoint(x: size.width, y: size.height),
                options: []
            )
            
            // Draw medical cross
            let crossSize = size.width * 0.5
            let crossRect = CGRect(
                x: (size.width - crossSize) / 2,
                y: (size.height - crossSize) / 2,
                width: crossSize,
                height: crossSize
            )
            
            // White cross background
            context.cgContext.setFillColor(UIColor.white.cgColor)
            
            // Vertical bar of cross
            let verticalBar = CGRect(
                x: crossRect.midX - crossSize * 0.15,
                y: crossRect.minY,
                width: crossSize * 0.3,
                height: crossSize
            )
            context.cgContext.fill(verticalBar)
            
            // Horizontal bar of cross
            let horizontalBar = CGRect(
                x: crossRect.minX,
                y: crossRect.midY - crossSize * 0.15,
                width: crossSize,
                height: crossSize * 0.3
            )
            context.cgContext.fill(horizontalBar)
            
            // Add RRC text at bottom
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: size.width * 0.12, weight: .bold),
                .foregroundColor: UIColor.white
            ]
            
            let text = "RRC"
            let textSize = text.size(withAttributes: attributes)
            let textRect = CGRect(
                x: (size.width - textSize.width) / 2,
                y: size.height - textSize.height - size.height * 0.1,
                width: textSize.width,
                height: textSize.height
            )
            
            text.draw(in: textRect, withAttributes: attributes)
        }
        
        return Image(uiImage: uiImage)
        #else
        // For macOS, return a placeholder
        return Image(systemName: "cross.case.fill")
        #endif
    }
    
    static func exportIconSizes() {
        #if canImport(UIKit)
        let iconSizes: [(name: String, size: CGFloat)] = [
            ("Icon-20", 20),
            ("Icon-20@2x", 40),
            ("Icon-20@3x", 60),
            ("Icon-29", 29),
            ("Icon-29@2x", 58),
            ("Icon-29@3x", 87),
            ("Icon-40", 40),
            ("Icon-40@2x", 80),
            ("Icon-40@3x", 120),
            ("Icon-60@2x", 120),
            ("Icon-60@3x", 180),
            ("Icon-76", 76),
            ("Icon-76@2x", 152),
            ("Icon-83.5@2x", 167),
            ("Icon-1024", 1024)
        ]
        
        for (name, size) in iconSizes {
            let iconSize = CGSize(width: size, height: size)
            let renderer = UIGraphicsImageRenderer(size: iconSize)
            
            let uiImage = renderer.image { context in
                // Similar drawing code as above but with the specific size
                let gradientColors = [
                    UIColor(red: 0.2, green: 0.4, blue: 0.8, alpha: 1.0).cgColor,
                    UIColor(red: 0.1, green: 0.3, blue: 0.6, alpha: 1.0).cgColor
                ]
                
                let gradient = CGGradient(
                    colorsSpace: CGColorSpaceCreateDeviceRGB(),
                    colors: gradientColors as CFArray,
                    locations: [0, 1]
                )!
                
                context.cgContext.drawLinearGradient(
                    gradient,
                    start: CGPoint(x: 0, y: 0),
                    end: CGPoint(x: iconSize.width, y: iconSize.height),
                    options: []
                )
                
                // Draw medical cross
                let crossSize = iconSize.width * 0.5
                let crossRect = CGRect(
                    x: (iconSize.width - crossSize) / 2,
                    y: (iconSize.height - crossSize) / 2,
                    width: crossSize,
                    height: crossSize
                )
                
                context.cgContext.setFillColor(UIColor.white.cgColor)
                
                let verticalBar = CGRect(
                    x: crossRect.midX - crossSize * 0.15,
                    y: crossRect.minY,
                    width: crossSize * 0.3,
                    height: crossSize
                )
                context.cgContext.fill(verticalBar)
                
                let horizontalBar = CGRect(
                    x: crossRect.minX,
                    y: crossRect.midY - crossSize * 0.15,
                    width: crossSize,
                    height: crossSize * 0.3
                )
                context.cgContext.fill(horizontalBar)
                
                // Only add text for larger sizes
                if size >= 76 {
                    let attributes: [NSAttributedString.Key: Any] = [
                        .font: UIFont.systemFont(ofSize: iconSize.width * 0.12, weight: .bold),
                        .foregroundColor: UIColor.white
                    ]
                    
                    let text = "RRC"
                    let textSize = text.size(withAttributes: attributes)
                    let textRect = CGRect(
                        x: (iconSize.width - textSize.width) / 2,
                        y: iconSize.height - textSize.height - iconSize.height * 0.1,
                        width: textSize.width,
                        height: textSize.height
                    )
                    
                    text.draw(in: textRect, withAttributes: attributes)
                }
            }
            
            // Save to documents directory for retrieval
            if let data = uiImage.pngData() {
                let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let iconPath = documentsPath.appendingPathComponent("\(name).png")
                try? data.write(to: iconPath)
                print("Saved icon: \(iconPath)")
            }
        }
        #endif
    }
}

// MARK: - Preview Helper
struct AppIconPreview: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("App Icon Preview")
                .font(.title)
                .bold()
            
            AppIconGenerator.generateIcon(size: CGSize(width: 180, height: 180))
                .frame(width: 180, height: 180)
                .cornerRadius(40)
                .shadow(radius: 10)
            
            Text("Rapid Response Central")
                .font(.headline)
            
            Button("Export All Icon Sizes") {
                AppIconGenerator.exportIconSizes()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
}

#Preview {
    AppIconPreview()
}