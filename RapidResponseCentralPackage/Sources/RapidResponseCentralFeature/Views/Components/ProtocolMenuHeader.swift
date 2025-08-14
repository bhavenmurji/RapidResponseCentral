import SwiftUI

// MARK: - Consistent Protocol Menu Header
public struct ProtocolMenuHeader: View {
    @Binding var searchText: String
    let protocolCount: Int
    let protocolType: String
    
    public init(searchText: Binding<String>, protocolCount: Int, protocolType: String) {
        self._searchText = searchText
        self.protocolCount = protocolCount
        self.protocolType = protocolType
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Timer Banner (placeholder for future active protocol tracking)
            HStack {
                Image(systemName: "timer")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                
                Text("No Active Protocol")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("\(protocolCount) \(protocolType)")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            .padding(.vertical, 6)
            .background(Color(.systemGray6))
            
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("Search protocols...", text: $searchText)
                    .textFieldStyle(.plain)
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(8)
            .background(Color(.systemGray5).opacity(0.5))
            .cornerRadius(8)
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
}