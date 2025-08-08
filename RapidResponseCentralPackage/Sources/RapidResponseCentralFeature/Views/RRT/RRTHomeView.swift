import SwiftUI

struct RRTHomeView: View {
    @State private var searchText = ""
    @State private var selectedProtocol: EmergencyProtocol?
    @EnvironmentObject private var protocolService: ProtocolService
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    searchBar
                    protocolGrid
                    infoSection
                }
                .padding(.vertical)
            }
            .navigationTitle("RRT PROTOCOLS")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "gear")
                    }
                }
            }
            .navigationDestination(for: EmergencyProtocol.self) { proto in
                ProtocolDetailView(protocol: proto)
            }
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            TextField("Search RRT protocols...", text: $searchText)
                .textFieldStyle(.plain)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    private var protocolGrid: some View {
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
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(filteredProtocols) { proto in
                        NavigationLink(value: proto) {
                            RRTCard(
                                title: proto.title,
                                icon: proto.icon,
                                color: proto.category.color
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
    
    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("RAPID RESPONSE TEAM")
                .font(.headline)
            
            Text("Evidence-based protocols for the six most common RRT activations. Each protocol features systematic assessment algorithms, differential diagnosis, and treatment pathways.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                Image(systemName: "phone.fill")
                    .foregroundColor(.blue)
                Text("Transfer Center: 856-886-5111")
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    private var filteredProtocols: [EmergencyProtocol] {
        if searchText.isEmpty {
            return protocolService.rrtProtocols
        } else {
            return protocolService.rrtProtocols.filter { proto in
                proto.title.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}

struct RRTCard: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            // Icon
            BoxiconView(iconName: icon, size: 44, color: color)
            
            // Title
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
                .padding(.horizontal, 8)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 140)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}

struct RRTHomeView_Previews: PreviewProvider {
    static var previews: some View {
        RRTHomeView()
    }
}