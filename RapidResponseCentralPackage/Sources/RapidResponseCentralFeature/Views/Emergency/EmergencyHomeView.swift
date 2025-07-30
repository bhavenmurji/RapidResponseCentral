import SwiftUI

struct EmergencyHomeView: View {
    @State private var searchText = ""
    @State private var selectedProtocol: EmergencyProtocol?
    @StateObject private var protocolService = ProtocolService()
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        TextField("Search protocols...", text: $searchText)
                            .textFieldStyle(.plain)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Emergency Cards Grid
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(filteredProtocolList) { proto in
                            NavigationLink(destination: ProtocolDetailView(proto: proto)) {
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
    
    private var filteredProtocolList: [EmergencyProtocol] {
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
        VStack(spacing: 8) {
            // Icon or Emoji
            if icon.count == 1 {
                // It's an emoji
                Text(icon)
                    .font(.system(size: 50))
            } else {
                // It's a system icon
                Image(systemName: icon)
                    .font(.system(size: 40))
                    .foregroundColor(color)
            }
            
            // Title
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 120)
        .padding()
        .background(Color(.systemBackground))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

// RRTHomeView has been moved to Views/RRT/RRTHomeView.swift

struct CallsHomeView: View {
    var body: some View {
        NavigationStack {
            ComingSoonView(title: "Calls")
                .navigationTitle("CALLS")
        }
    }
}

struct LabsHomeView: View {
    var body: some View {
        NavigationStack {
            ComingSoonView(title: "Labs")
                .navigationTitle("LABS")
        }
    }
}

struct CalculatorsHomeView: View {
    var body: some View {
        NavigationStack {
            ComingSoonView(title: "Medical Calculators")
                .navigationTitle("CALCULATORS")
        }
    }
}

struct ChatHomeView: View {
    var body: some View {
        NavigationStack {
            ComingSoonView(title: "MEData Chat")
                .navigationTitle("CHAT")
        }
    }
}

struct StudyHomeView: View {
    var body: some View {
        NavigationStack {
            ComingSoonView(title: "FamMed Central")
                .navigationTitle("STUDY")
        }
    }
}

struct MoreHomeView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Resources") {
                    NavigationLink(destination: CalculatorsHomeView()) {
                        Label("Medical Calculators", systemImage: "function")
                    }
                    NavigationLink(destination: ChatHomeView()) {
                        Label("MEData Chat", systemImage: "message.fill")
                    }
                    NavigationLink(destination: StudyHomeView()) {
                        Label("FamMed Central", systemImage: "book.fill")
                    }
                }
                
                Section("Settings") {
                    NavigationLink(destination: SettingsView()) {
                        Label("Settings", systemImage: "gear")
                    }
                }
            }
            .navigationTitle("MORE")
        }
    }
}

struct ComingSoonView: View {
    let title: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "hammer.fill")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text(title)
                .font(.title)
                .fontWeight(.bold)
            
            Text("Coming Soon")
                .font(.title2)
                .foregroundColor(.secondary)
            
            Text("This feature is under development")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("colorScheme") private var colorScheme = 0 // 0: System, 1: Light, 2: Dark
    @AppStorage("textSizeAdjustment") private var textSizeAdjustment = 0 // -2 to +2
    @State private var showingTextSizePreview = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("Appearance") {
                    Picker("Theme", selection: $colorScheme) {
                        Label("System", systemImage: "gear").tag(0)
                        Label("Light", systemImage: "sun.max").tag(1)
                        Label("Dark", systemImage: "moon.fill").tag(2)
                    }
                    
                    Button(action: { showingTextSizePreview = true }) {
                        HStack {
                            Text("Text Size")
                            Spacer()
                            Text(textSizeLabel)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section("Notifications") {
                    Toggle("Timer Alerts", isOn: .constant(true))
                    Toggle("Medication Reminders", isOn: .constant(true))
                    Toggle("Study Reminders", isOn: .constant(false))
                }
                
                Section("Defaults") {
                    HStack {
                        Text("Hospital")
                        Spacer()
                        Menu {
                            Button("Virtua Voorhees") {}
                            Button("Virtua Mount Holly") {}
                            Button("Virtua Marlton") {}
                        } label: {
                            HStack {
                                Text("Virtua Voorhees")
                                    .foregroundColor(.secondary)
                                Image(systemName: "chevron.down")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    HStack {
                        Text("Department")
                        Spacer()
                        Menu {
                            Button("Emergency") {}
                            Button("ICU") {}
                            Button("Medicine Floor") {}
                        } label: {
                            HStack {
                                Text("Emergency")
                                    .foregroundColor(.secondary)
                                Image(systemName: "chevron.down")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                
                Section("Data & Privacy") {
                    Button("Export All Logs") {
                        // TODO: Implement export
                    }
                    
                    Button("Clear Cache") {
                        // TODO: Implement clear cache
                    }
                    .foregroundColor(.red)
                    
                    Link("Privacy Policy", destination: URL(string: "https://meddata.com/privacy")!)
                }
                
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("2.0.1")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("© 2024 MEData")
                        Spacer()
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
        .sheet(isPresented: $showingTextSizePreview) {
            TextSizeAdjustmentView(textSizeAdjustment: $textSizeAdjustment)
        }
        .preferredColorScheme(colorSchemeValue)
    }
    
    private var textSizeLabel: String {
        switch textSizeAdjustment {
        case -2: return "X-Small"
        case -1: return "Small"
        case 0: return "Normal"
        case 1: return "Large"
        case 2: return "X-Large"
        default: return "Normal"
        }
    }
    
    private var colorSchemeValue: ColorScheme? {
        switch colorScheme {
        case 1: return .light
        case 2: return .dark
        default: return nil
        }
    }
}

struct TextSizeAdjustmentView: View {
    @Binding var textSizeAdjustment: Int
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("TEXT SIZE")
                    .font(.headline)
                    .padding(.top)
                
                VStack(spacing: 16) {
                    TextSizeOption(label: "Small", size: -1, selected: textSizeAdjustment, action: { textSizeAdjustment = -1 })
                    TextSizeOption(label: "Normal", size: 0, selected: textSizeAdjustment, action: { textSizeAdjustment = 0 })
                    TextSizeOption(label: "Large", size: 1, selected: textSizeAdjustment, action: { textSizeAdjustment = 1 })
                    TextSizeOption(label: "X-Large", size: 2, selected: textSizeAdjustment, action: { textSizeAdjustment = 2 })
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Preview:")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Epinephrine 1mg IV/IO")
                                .font(.dynamicBody(adjustment: textSizeAdjustment))
                                .fontWeight(.semibold)
                        }
                        Text("Give every 3-5 minutes during arrest")
                            .font(.dynamicCaption(adjustment: textSizeAdjustment))
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                
                Spacer()
                
                HStack(spacing: 16) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray5))
                    .foregroundColor(.primary)
                    .cornerRadius(10)
                    
                    Button("Apply") {
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
    }
}

struct TextSizeOption: View {
    let label: String
    let size: Int
    let selected: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text("A")
                    .font(.system(size: CGFloat(16 + size * 2)))
                    .frame(width: 30)
                
                Text(label)
                    .font(.body)
                
                Spacer()
                
                if selected == size {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(selected == size ? Color.blue.opacity(0.1) : Color(.systemGray6))
            .cornerRadius(10)
        }
        .buttonStyle(.plain)
    }
}

// Font extensions for dynamic text sizing
extension Font {
    static func dynamicBody(adjustment: Int) -> Font {
        switch adjustment {
        case -2: return .caption2
        case -1: return .caption
        case 1: return .body
        case 2: return .title3
        default: return .body
        }
    }
    
    static func dynamicCaption(adjustment: Int) -> Font {
        switch adjustment {
        case -2: return .caption2
        case -1: return .caption2
        case 1: return .caption
        case 2: return .body
        default: return .caption
        }
    }
}

#Preview {
    EmergencyHomeView()
}