import SwiftUI

public struct ChatHomeView: View {
    public init() {}
    
    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Main content in ScrollView
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        Image(systemName: "message.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                            .padding()
                        
                        Text("Clinical AI Assistant")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Coming Soon")
                            .foregroundColor(.secondary)
                            .padding()
                    }
                    .frame(minHeight: 300)
                    .padding(.vertical)
                }
                
                // Emergency Support Card - Fixed at bottom, outside ScrollView
                EmergencySupportCard()
                    .padding(.horizontal)
                    .padding(.bottom, 8)
            }
            .navigationTitle("Chat")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    ChatHomeView()
}