import SwiftUI

public struct MoreMenuView: View {
    @Binding var selectedTab: AppTab
    @Environment(\.dismiss) private var dismiss
    
    public init(selectedTab: Binding<AppTab>) {
        self._selectedTab = selectedTab
    }
    
    public var body: some View {
        NavigationStack {
            List {
                Section {
                    Button(action: {
                        selectedTab = .chat
                        dismiss()
                    }) {
                        Label {
                            Text("Chat")
                                .foregroundColor(.primary)
                        } icon: {
                            Image(systemName: "message.fill")
                                .foregroundColor(.indigo)
                        }
                    }
                    
                    Button(action: {
                        selectedTab = .study
                        dismiss()
                    }) {
                        Label {
                            Text("Study")
                                .foregroundColor(.primary)
                        } icon: {
                            Image(systemName: "book.fill")
                                .foregroundColor(.orange)
                        }
                    }
                }
                
                Section {
                    NavigationLink(destination: SettingsView()) {
                        Label {
                            Text("Settings")
                        } icon: {
                            Image(systemName: "gear")
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("More")
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
    MoreMenuView(selectedTab: .constant(.emergencies))
}