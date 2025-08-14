import SwiftUI

public struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            List {
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(AppVersion.current.displayString)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Build")
                        Spacer()
                        Text(AppVersion.buildNumber ?? "Unknown")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section("Support") {
                    Link(destination: URL(string: "https://github.com/yourusername/rapidresponse")!) {
                        Label("GitHub Repository", systemImage: "link")
                    }
                    
                    Link(destination: URL(string: "mailto:support@rapidresponse.com")!) {
                        Label("Contact Support", systemImage: "envelope")
                    }
                }
                
                Section("Legal") {
                    Button(action: {}) {
                        Text("Privacy Policy")
                    }
                    
                    Button(action: {}) {
                        Text("Terms of Service")
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}