import SwiftUI

// MARK: - Universal Emergency Support Card for ALL Protocol Pages
public struct UniversalEmergencySupportCard: View {
    @StateObject private var supportState = EmergencySupportState.shared
    @State private var dragOffset: CGSize = .zero
    
    private let pages = [
        EmergencyPage.rrtAndContacts,  // Combined first page
        EmergencyPage.additionalContacts
    ]
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 0) {
            // Main swipeable content area
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        pageContent(for: pages[index])
                            .frame(width: geometry.size.width)
                    }
                }
                .offset(x: -CGFloat(supportState.currentPage) * geometry.size.width + dragOffset.width)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            dragOffset = value.translation
                        }
                        .onEnded { value in
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                let threshold = geometry.size.width * 0.25
                                if value.translation.width > threshold && supportState.currentPage > 0 {
                                    supportState.currentPage -= 1
                                } else if value.translation.width < -threshold && supportState.currentPage < pages.count - 1 {
                                    supportState.currentPage += 1
                                }
                                dragOffset = .zero
                            }
                        }
                )
            }
            .frame(height: 140)  // Reduced height for more compact display
            
            // Enhanced page indicators
            pageIndicators
                .padding(.vertical, 8)
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    // MARK: - Page Content Views
    private func pageContent(for page: EmergencyPage) -> some View {
        VStack(spacing: 8) {
            // Swipe indicator at top right
            HStack {
                Spacer()
                
                if supportState.currentPage < pages.count - 1 {
                    Text("Swipe →")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                } else if supportState.currentPage > 0 {
                    Text("← Swipe")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
            }
            
            // Content layout based on page type
            if page == .rrtAndContacts {
                // Two-column layout for first page
                HStack(alignment: .top, spacing: 16) {
                    // Left side - RRT Steps
                    VStack(alignment: .leading, spacing: 4) {
                        Text("RRT INITIAL STEPS")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.secondary)
                        
                        ForEach(page.items.filter { $0.isStep }, id: \.self) { item in
                            contentRow(for: item)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Divider()
                        .frame(width: 1)
                        .background(Color.gray.opacity(0.3))
                    
                    // Right side - Phone Numbers
                    VStack(alignment: .leading, spacing: 4) {
                        Text("CRITICAL NUMBERS")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.secondary)
                        
                        ForEach(page.items.filter { !$0.isStep }, id: \.self) { item in
                            contentRow(for: item)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            } else {
                // Single column for additional contacts
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(page.items, id: \.self) { item in
                        contentRow(for: item)
                    }
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
    }
    
    @ViewBuilder
    private func contentRow(for item: EmergencyItem) -> some View {
        if item.isStep {
            // RRT Steps - just text with smaller font
            Text(item.text)
                .font(.system(size: 10, weight: .regular))
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
        } else {
            // Phone number row - more compact
            HStack(spacing: 4) {
                Text(item.text)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if let number = item.number {
                    Text(number)
                        .font(.system(size: 10, weight: .medium, design: .monospaced))
                        .foregroundColor(.blue)
                        .onTapGesture {
                            makePhoneCall(number)
                        }
                }
            }
        }
    }
    
    private var pageIndicators: some View {
        HStack(spacing: 6) {
            ForEach(0..<pages.count, id: \.self) { index in
                Capsule()
                    .fill(index == supportState.currentPage ? Color.red : Color(.systemGray4))
                    .frame(width: index == supportState.currentPage ? 24 : 8, height: 6)
                    .animation(.spring(response: 0.3, dampingFraction: 0.8), value: supportState.currentPage)
            }
        }
    }
    
    private func makePhoneCall(_ number: String) {
        #if os(iOS)
        let cleanNumber = number.replacingOccurrences(of: "-", with: "")
        if let phoneURL = URL(string: "tel://\(cleanNumber)") {
            UIApplication.shared.open(phoneURL)
        }
        #endif
    }
}

// MARK: - Data Models
private enum EmergencyPage {
    case rrtAndContacts  // Combined RRT steps and critical contacts
    case additionalContacts
    
    var icon: String {
        switch self {
        case .rrtAndContacts: return "staroflife.fill"
        case .additionalContacts: return "phone.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .rrtAndContacts: return .red
        case .additionalContacts: return .blue
        }
    }
    
    var label: String {
        switch self {
        case .rrtAndContacts: return "EMERGENCY"
        case .additionalContacts: return "CONTACTS"
        }
    }
    
    var title: String {
        switch self {
        case .rrtAndContacts: return "RRT Steps & Critical Numbers"
        case .additionalContacts: return "Additional Contacts"
        }
    }
    
    var items: [EmergencyItem] {
        switch self {
        case .rrtAndContacts:
            return [
                // RRT Steps (left side - steps 1-4)
                EmergencyItem(text: "1. Intro: Hi, I'm Dr __ on RRTs", isStep: true),
                EmergencyItem(text: "2. Fresh Vitals", isStep: true),
                EmergencyItem(text: "3. IV access + 15L O2", isStep: true),
                EmergencyItem(text: "4. ABCDE + GCS + POC GLU", isStep: true),
                // Critical Phone Numbers (right side)
                EmergencyItem(text: "ICU NP", number: "79628"),
                EmergencyItem(text: "Anesthesia", number: "79361"),
                EmergencyItem(text: "Transfer Center", number: "51111"),
                EmergencyItem(text: "Sevaro/Neuro", number: "856-347-3098")
            ]
        case .additionalContacts:
            return [
                EmergencyItem(text: "X-Ray", number: "79444"),
                EmergencyItem(text: "CT", number: "79445"),
                EmergencyItem(text: "Lab", number: "79333"),
                EmergencyItem(text: "Pharmacy", number: "79420"),
                EmergencyItem(text: "Code Team", number: "77777"),
                EmergencyItem(text: "Blood Bank", number: "79340"),
                EmergencyItem(text: "PGY3", number: "79363"),
                EmergencyItem(text: "PGY2", number: "79362"),
                EmergencyItem(text: "PGY1", number: "79360")
            ]
        }
    }
}

private struct EmergencyItem: Hashable {
    let text: String
    let number: String?
    let bullet: Color?
    let isStep: Bool
    
    init(text: String, number: String? = nil, bullet: Color? = nil, isStep: Bool = false) {
        self.text = text
        self.number = number
        self.bullet = bullet
        self.isStep = isStep
    }
}

#Preview {
    VStack {
        Spacer()
        UniversalEmergencySupportCard()
            .padding()
        Spacer()
    }
    .background(Color(.systemGray6))
}