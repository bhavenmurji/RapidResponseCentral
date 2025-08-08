import SwiftUI

public struct EmergencyHomeView: View {
    @EnvironmentObject private var protocolService: ProtocolService
    @State private var searchText = ""
    @State private var selectedProtocol: EmergencyProtocol?
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        TextField("Search emergency protocols...", text: $searchText)
                            .textFieldStyle(.plain)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Emergency Cards Grid
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(filteredEmergencyProtocolList) { proto in
                            NavigationLink(destination: ProtocolDetailView(protocol: proto)) {
                                EmergencyCard(
                                    title: proto.title,
                                    icon: proto.icon,
                                    color: colorForCategory(proto.category)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Emergency Support Card at the bottom
                    EmergencySupportCard()
                        .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("EMERGENCIES")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "gear")
                    }
                }
            }
        }
    }
    
    private var filteredEmergencyProtocolList: [EmergencyProtocol] {
        if searchText.isEmpty {
            return protocolService.protocols
        }
        return protocolService.protocols.filter { 
            $0.title.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    private func colorForCategory(_ category: ProtocolCategory) -> Color {
        category.color
    }
}

struct EmergencyCard: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            BoxiconView(iconName: icon, size: 28)
                .foregroundColor(color)
            
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, minHeight: 100)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct EmergencySupportCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "phone.fill")
                    .foregroundColor(.red)
                Text("Emergency Support")
                    .font(.headline)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
            
            Text("Quick access to critical phone numbers")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    EmergencyHomeView()
}