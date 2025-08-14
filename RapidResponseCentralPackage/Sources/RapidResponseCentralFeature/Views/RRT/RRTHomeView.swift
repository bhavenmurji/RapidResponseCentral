import SwiftUI

struct RRTHomeView: View {
    @Binding var navigationPath: NavigationPath
    @State private var selectedProtocol: EmergencyProtocol?
    @State private var searchText = ""
    @EnvironmentObject private var protocolService: ProtocolService
    
    public init(navigationPath: Binding<NavigationPath> = .constant(NavigationPath())) {
        self._navigationPath = navigationPath
    }
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    private var filteredProtocols: [EmergencyProtocol] {
        let protocols = protocolService.rrtProtocols
        
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
            
            protocolGrid()
            
            Spacer(minLength: 8)
            
            // Emergency Support Card - at bottom
            UniversalEmergencySupportCard()
                .padding(.horizontal)
                .padding(.bottom, 8)
        }
        .navigationBarHidden(true)
    }
    
    
    private func protocolGrid() -> some View {
        Group {
            if protocolService.isLoading {
                VStack(spacing: 16) {
                    ProgressView()
                        .scaleEffect(1.5)
                    Text("Loading RRT Protocols...")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(height: 200)
            } else {
                // RRT Cards - 2 columns x 3 rows (SMART DR style)
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ], spacing: 12) {
                    ForEach(Array(filteredProtocols.enumerated()), id: \.element.id) { index, proto in
                        NavigationLink(value: proto) {
                            VStack(spacing: 10) {
                                // Large circular icon with Health Icons
                                ZStack {
                                    Circle()
                                        .fill(iconBackgroundColor(for: proto.category))
                                        .frame(width: 56, height: 56)
                                    
                                    HealthIconView(proto.title, size: 30, color: .white)
                                }
                                
                                Text(proto.title)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.primary)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.center)
                                    .minimumScaleFactor(0.85)
                            }
                            .padding(12)
                            .frame(height: 120)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color(UIColor.secondarySystemBackground))
                                    .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 2)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
    
    
    private func iconBackgroundColor(for category: ProtocolCategory) -> Color {
        switch category {
        case .cardiac:
            return Color(red: 0.95, green: 0.26, blue: 0.21) // Bright red
        case .neurological:
            return Color(red: 0.61, green: 0.35, blue: 0.71) // Purple
        case .respiratory:
            return Color(red: 0.13, green: 0.59, blue: 0.95) // Blue
        case .trauma:
            return Color(red: 1.0, green: 0.60, blue: 0.0) // Orange
        case .infectious:
            return Color(red: 0.30, green: 0.69, blue: 0.31) // Green
        case .allergic:
            return Color(red: 0.91, green: 0.12, blue: 0.39) // Pink
        case .support:
            return Color(red: 0.46, green: 0.46, blue: 0.50) // Gray
        }
    }
    
    private func iconForRRTProtocol(_ title: String) -> String {
        // Map to unique icons for each RRT protocol
        switch title {
        case "Sepsis":
            return "bacteria.fill"
        case "Respiratory Distress":
            return "wind"
        case "Cardiac Monitoring":
            return "waveform.path.ecg"
        case "Neurological Assessment":
            return "brain.head.profile"
        case "Hypotension":
            return "arrow.down.heart.fill"
        case "Acute Kidney Injury":
            return "drop.degreesign"
        case "Electrolyte Imbalance":
            return "atom"
        case "Oxygenation":
            return "circle.hexagongrid.circle.fill"
        case "Pain Crisis":
            return "bolt.horizontal.fill"
        case "Rapid Deterioration":
            return "exclamationmark.triangle.fill"
        default:
            return "stethoscope"
        }
    }
}

struct RRTCard: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                BoxiconView(iconName: icon, size: 20)
                    .foregroundColor(color)
                Spacer()
            }
            
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
            
            Spacer()
        }
        .padding(8)
        .frame(maxWidth: .infinity, minHeight: 80)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    private func mapRRTIcon(_ icon: String) -> String {
        // Map to appropriate medical SF Symbols
        switch icon {
        case "bx-pulse": return "waveform.path.ecg"
        case "bx-heart": return "heart.fill"
        case "bx-water": return "drop.fill"
        case "bx-brain": return "brain"
        case "bx-lungs": return "lungs.fill"
        case "bx-kidney": return "circle.grid.cross.fill"
        case "bx-dna": return "allergens"
        case "bx-droplet": return "drop.triangle.fill"
        case "bx-wind": return "wind"
        case "bx-trending-down": return "chart.line.downtrend.xyaxis"
        default: return "stethoscope"
        }
    }
}

struct RRTHomeView_Previews: PreviewProvider {
    static var previews: some View {
        RRTHomeView()
    }
}