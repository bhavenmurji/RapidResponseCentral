import SwiftUI

public struct LabsHomeView: View {
    @Binding var navigationPath: NavigationPath
    @State private var searchText = ""
    @EnvironmentObject private var protocolService: ProtocolService
    
    public init(navigationPath: Binding<NavigationPath> = .constant(NavigationPath())) {
        self._navigationPath = navigationPath
    }
    
    private var filteredProtocols: [EmergencyProtocol] {
        let protocols = protocolService.labsProtocols
        
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
            
            // Protocol Grid - 3 columns x 6 rows (SMART DR style)
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 8),
                GridItem(.flexible(), spacing: 8),
                GridItem(.flexible(), spacing: 8)
            ], spacing: 8) {
                ForEach(Array(filteredProtocols.enumerated()), id: \.element.id) { index, proto in
                    NavigationLink(value: proto) {
                        VStack(spacing: 6) {
                            // Large circular icon with Health Icons
                            ZStack {
                                Circle()
                                    .fill(iconBackgroundColor(for: proto))
                                    .frame(width: 42, height: 42)
                                
                                HealthIconView(proto.title, size: 24, color: .white)
                            }
                            
                            Text(proto.title)
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundColor(.primary)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .minimumScaleFactor(0.7)
                        }
                        .padding(8)
                        .frame(height: 85)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(UIColor.secondarySystemBackground))
                                .shadow(color: Color.black.opacity(0.03), radius: 3, x: 0, y: 1)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 14)
            
            Spacer(minLength: 4)
            
            // Emergency Support Card - at bottom
            UniversalEmergencySupportCard()
                .padding(.horizontal)
                .padding(.bottom, 4)
        }
        .navigationBarHidden(true)
    }
}

// Helper functions for Labs icons and colors
private func iconBackgroundColor(for proto: EmergencyProtocol) -> Color {
    // Use different colors for different lab types
    let title = proto.title.lowercased()
    if title.contains("anemia") || title.contains("coagulopathy") || title.contains("thrombocytopenia") {
        return Color(red: 0.85, green: 0.11, blue: 0.11) // Blood red
    } else if title.contains("sodium") || title.contains("natremia") {
        return Color(red: 0.0, green: 0.48, blue: 0.85) // Ocean blue
    } else if title.contains("kalemia") || title.contains("potassium") {
        return Color(red: 0.95, green: 0.47, blue: 0.0) // Electric orange
    } else if title.contains("calcemia") || title.contains("calcium") {
        return Color(red: 0.90, green: 0.90, blue: 0.90) // Bone white
    } else if title.contains("magnesium") {
        return Color(red: 0.40, green: 0.73, blue: 0.42) // Mineral green
    } else if title.contains("phosphate") {
        return Color(red: 0.61, green: 0.35, blue: 0.71) // Purple
    } else if title.contains("glycemia") || title.contains("glucose") {
        return Color(red: 1.0, green: 0.60, blue: 0.0) // Sugar orange
    } else if title.contains("renal") {
        return Color(red: 0.55, green: 0.27, blue: 0.07) // Kidney brown
    } else if title.contains("hepatic") {
        return Color(red: 0.60, green: 0.20, blue: 0.20) // Liver maroon
    } else if title.contains("abg") || title.contains("acid") {
        return Color(red: 0.20, green: 0.60, blue: 0.86) // pH blue
    } else if title.contains("ventilator") {
        return Color(red: 0.0, green: 0.75, blue: 0.75) // Cyan
    } else {
        return Color(red: 0.46, green: 0.46, blue: 0.50) // Default gray
    }
}

private func iconForLabsProtocol(_ title: String) -> String {
    let lowerTitle = title.lowercased()
    
    // Unique icons for each Labs protocol
    if lowerTitle.contains("anemia") {
        return "drop.circle"
    } else if lowerTitle.contains("coagulopathy") {
        return "drop.degreesign"
    } else if lowerTitle.contains("thrombocytopenia") {
        return "circles.hexagongrid.fill"
    } else if lowerTitle.contains("hypernatremia") {
        return "plus.diamond.fill"
    } else if lowerTitle.contains("hyponatremia") {
        return "minus.diamond.fill"
    } else if lowerTitle.contains("hyperkalemia") {
        return "bolt.circle.fill"
    } else if lowerTitle.contains("hypokalemia") {
        return "bolt.slash.circle.fill"
    } else if lowerTitle.contains("hypocalcemia") {
        return "square.stack.3d.down.right.fill"
    } else if lowerTitle.contains("hypercalcemia") {
        return "square.stack.3d.up.fill"
    } else if lowerTitle.contains("hypomagnesemia") {
        return "sparkles"
    } else if lowerTitle.contains("hypophosphatemia") {
        return "atom"
    } else if lowerTitle.contains("hyperglycemia") {
        return "arrow.up.circle.fill"
    } else if lowerTitle.contains("hypoglycemia") {
        return "arrow.down.circle.fill"
    } else if lowerTitle.contains("renal failure") {
        return "drop.degreesign.fill"
    } else if lowerTitle.contains("hepatic") {
        return "square.grid.3x3.fill"
    } else if lowerTitle.contains("abg") {
        return "waveform.path.ecg.rectangle"
    } else if lowerTitle.contains("acid-base") {
        return "chart.xyaxis.line"
    } else if lowerTitle.contains("ventilator") {
        return "fan.oscillation"
    } else {
        return "flask.fill"
    }
}

#Preview {
    LabsHomeView()
}