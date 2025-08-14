import SwiftUI

public struct CallsHomeView: View {
    @Binding var navigationPath: NavigationPath
    @State private var searchText = ""
    @EnvironmentObject private var protocolService: ProtocolService
    
    public init(navigationPath: Binding<NavigationPath> = .constant(NavigationPath())) {
        self._navigationPath = navigationPath
    }
    
    private var filteredProtocols: [EmergencyProtocol] {
        let protocols = protocolService.callsProtocols
        
        if searchText.isEmpty {
            return protocols
        } else {
            return protocols.filter { proto in
                proto.title.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Universal Protocol Timer Banner - appears when protocol is active
            UniversalProtocolTimerBanner()
            
            // Consistent Protocol Menu Header
            ProtocolMenuHeader(
                searchText: $searchText,
                protocolCount: filteredProtocols.count,
                protocolType: "protocols"
            )
            
            // Protocol Grid - 3 columns x 5 rows (SMART DR style)
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 10),
                GridItem(.flexible(), spacing: 10),
                GridItem(.flexible(), spacing: 10)
            ], spacing: 10) {
                ForEach(Array(filteredProtocols.enumerated()), id: \.element.id) { index, proto in
                    NavigationLink(value: proto) {
                        VStack(spacing: 8) {
                            // Large circular icon with Health Icons
                            ZStack {
                                Circle()
                                    .fill(iconBackgroundColor(for: proto))
                                    .frame(width: 48, height: 48)
                                
                                HealthIconView(proto.title, size: 26, color: .white)
                            }
                            
                            Text(proto.title)
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(.primary)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .minimumScaleFactor(0.75)
                        }
                        .padding(10)
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(UIColor.secondarySystemBackground))
                                .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 16)
            
            Spacer(minLength: 6)
            
            // Emergency Support Card - at bottom
            UniversalEmergencySupportCard()
                .padding(.horizontal)
                .padding(.bottom, 6)
        }
        .navigationBarHidden(true)
    }
}

// Helper functions for Calls icons and colors
private func iconBackgroundColor(for proto: EmergencyProtocol) -> Color {
    // Use different colors for different protocols to aid identification
    let title = proto.title.lowercased()
    if title.contains("heart") || title.contains("hf") {
        return Color(red: 0.95, green: 0.26, blue: 0.21) // Red
    } else if title.contains("hypertensive") {
        return Color(red: 0.91, green: 0.12, blue: 0.39) // Pink
    } else if title.contains("dka") || title.contains("hypoglycemia") {
        return Color(red: 1.0, green: 0.60, blue: 0.0) // Orange
    } else if title.contains("adrenal") {
        return Color(red: 0.61, green: 0.35, blue: 0.71) // Purple
    } else if title.contains("pneumothorax") || title.contains("respiratory") || title.contains("asthma") {
        return Color(red: 0.13, green: 0.59, blue: 0.95) // Blue
    } else if title.contains("gi") || title.contains("bowel") {
        return Color(red: 0.30, green: 0.69, blue: 0.31) // Green
    } else if title.contains("pain") || title.contains("opiate") {
        return Color(red: 0.95, green: 0.47, blue: 0.0) // Dark Orange
    } else if title.contains("eol") {
        return Color(red: 0.46, green: 0.46, blue: 0.50) // Gray
    } else {
        return Color(red: 0.0, green: 0.58, blue: 0.83) // Default blue
    }
}

private func iconForCallsProtocol(_ title: String) -> String {
    let lowerTitle = title.lowercased()
    
    // Unique icons for each Calls protocol
    if lowerTitle.contains("acute hf") {
        return "heart.circle.fill"
    } else if lowerTitle.contains("right hf") {
        return "heart.text.square.fill"
    } else if lowerTitle.contains("hypertensive") {
        return "gauge.high"
    } else if lowerTitle.contains("dka") {
        return "drop.fill"
    } else if lowerTitle.contains("hypoglycemia") {
        return "minus.circle.fill"
    } else if lowerTitle.contains("adrenal") {
        return "exclamationmark.shield.fill"
    } else if lowerTitle.contains("pneumothorax") {
        return "lungs"
    } else if lowerTitle.contains("respiratory failure") {
        return "lungs.fill"
    } else if lowerTitle.contains("asthma") {
        return "wind.circle.fill"
    } else if lowerTitle.contains("gi bleeding") {
        return "drop.triangle.fill"
    } else if lowerTitle.contains("bowel obstruction") {
        return "xmark.octagon.fill"
    } else if lowerTitle.contains("antiemetic") {
        return "pills.fill"
    } else if lowerTitle.contains("acute pain") {
        return "bolt.horizontal.circle.fill"
    } else if lowerTitle.contains("opiate") {
        return "cross.vial.fill"
    } else if lowerTitle.contains("eol") {
        return "heart.square.fill"
    } else {
        return "stethoscope"
    }
}

#Preview {
    CallsHomeView()
}