import SwiftUI

// MARK: - Comprehensive Hospital Contacts Card System
public struct HospitalContactsCard: View {
    @State private var currentPage: Int = 0
    @State private var dragOffset: CGSize = .zero
    @State private var searchText: String = ""
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header with search
            HStack {
                Text(pageTitles[currentPage])
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                // Page indicators
                HStack(spacing: 4) {
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Color.red : Color.gray.opacity(0.3))
                            .frame(width: 5, height: 5)
                    }
                }
                
                Spacer()
                
                // Swipe hint
                HStack(spacing: 2) {
                    if currentPage > 0 {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 9))
                    }
                    Text("Swipe")
                        .font(.system(size: 9))
                    if currentPage < 2 {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 9))
                    }
                }
                .foregroundColor(.secondary)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.red.opacity(0.05))
            
            // Swipeable content
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    // Card 1: RRT Initial Steps
                    RRTStepsView()
                        .frame(width: geometry.size.width)
                    
                    // Card 2: Critical Contacts & Residents
                    CriticalContactsView(searchText: $searchText)
                        .frame(width: geometry.size.width)
                    
                    // Card 3: Imaging, Labs & Floor Units
                    DepartmentsView(searchText: $searchText)
                        .frame(width: geometry.size.width)
                }
                .offset(x: -CGFloat(currentPage) * geometry.size.width + dragOffset.width)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            dragOffset = value.translation
                        }
                        .onEnded { value in
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                let threshold = geometry.size.width * 0.2
                                if value.translation.width > threshold && currentPage > 0 {
                                    currentPage -= 1
                                } else if value.translation.width < -threshold && currentPage < 2 {
                                    currentPage += 1
                                }
                                dragOffset = .zero
                            }
                        }
                )
            }
            .frame(height: 160) // Optimized height for content
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.08), radius: 4, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.red.opacity(0.2), lineWidth: 1)
        )
    }
    
    private var pageTitles: [String] {
        ["RRT Initial Steps", "Critical Contacts & Residents", "Departments & Services"]
    }
}

// MARK: - RRT Initial Steps View
struct RRTStepsView: View {
    private let steps = [
        (num: "1", text: "\"Hi I'm Dr __, on RRTs\"", icon: "person.wave.2"),
        (num: "2", text: "Fresh vitals", icon: "waveform.path.ecg"),
        (num: "3", text: "IV access + 15L O2", icon: "iv.fluid.bag"),
        (num: "4", text: "ABCDE + GCS + POC GLU", icon: "checklist")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ForEach(steps, id: \.num) { step in
                HStack(spacing: 8) {
                    // Step number
                    Text(step.num)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 18, height: 18)
                        .background(Circle().fill(Color.red))
                    
                    // Icon
                    Image(systemName: step.icon)
                        .font(.system(size: 12))
                        .foregroundColor(.red)
                        .frame(width: 20)
                    
                    // Text
                    Text(step.text)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.primary)
                    
                    Spacer()
                }
            }
            
            Divider()
                .padding(.vertical, 4)
            
            // Quick critical numbers
            HStack(spacing: 12) {
                ContactChip(name: "Code", number: "77777", color: .red)
                ContactChip(name: "RRT", number: "79628", color: .orange)
                ContactChip(name: "Security", number: "73205", color: .blue)
            }
        }
        .padding(10)
    }
}

// MARK: - Critical Contacts View (Card 2)
struct CriticalContactsView: View {
    @Binding var searchText: String
    
    private let contacts: [(category: String, items: [(name: String, number: String)])] = [
        ("Residents", [
            ("OB Resident", "79364"),
            ("GYN Resident", "79629"),
            ("GYNonc Resident", "79328")
        ]),
        ("Critical Services", [
            ("ICU RRT Charge RN", "79280"),
            ("Anesthesiologist", "79361"),
            ("Pharmacy", "73030")
        ]),
        ("Nursing", [
            ("Nursing Supervisor", "79516 / 79700"),
            ("Nursing Admin", "73900"),
            ("IV Team", "73940")
        ]),
        ("Support", [
            ("Respiratory", "73565"),
            ("Security", "73205")
        ])
    ]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 4) {
                ForEach(contacts, id: \.category) { section in
                    // Category header
                    Text(section.category)
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundColor(.secondary)
                        .padding(.top, section.category == contacts.first?.category ? 0 : 4)
                    
                    // Contact items
                    ForEach(section.items, id: \.name) { item in
                        ContactRow(name: item.name, number: item.number)
                    }
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
        }
    }
}

// MARK: - Departments View (Card 3)
struct DepartmentsView: View {
    @Binding var searchText: String
    
    private let departments: [(category: String, items: [(name: String, number: String)])] = [
        ("Imaging & Diagnostics", [
            ("CT Scan", "74470 / 74386"),
            ("X-RAY", "73788"),
            ("Reading Room", "73780"),
            ("IR", "79775 / 72336"),
            ("MRI", "74019"),
            ("Echo", "72292")
        ]),
        ("Laboratory", [
            ("Lab", "73020"),
            ("Chemistry", "73125"),
            ("Blood Bank", "73193"),
            ("Hematology", "73136"),
            ("Micro", "73160")
        ]),
        ("Floor Units", [
            ("7A Med Surg", "73150"),
            ("6A/6B Cardiology", "73931 / 73941"),
            ("5A/5B Adult Surg", "73911 / 72510"),
            ("4A Med Surg", "72490"),
            ("4B Mother Baby", "72820"),
            ("3B Mother Baby", "72790"),
            ("3C High Risk OB", "73835"),
            ("2B Mother Baby", "72050"),
            ("NICU", "73831"),
            ("PICU", "73891 / 73981"),
            ("ICU", "73801"),
            ("L&D", "73821"),
            ("PACU", "72350 / 72083"),
            ("1A Women's Health", "73881"),
            ("1B Pediatrics", "73921"),
            ("1C Adult ED", "75001"),
            ("OB Triage", "72645")
        ]),
        ("Additional Services", [
            ("Physical Therapy", "73080"),
            ("Room Service", "73488")
        ])
    ]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 2) {
                ForEach(departments, id: \.category) { section in
                    // Compact category header
                    Text(section.category)
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(.secondary)
                        .padding(.top, 2)
                    
                    // Two-column layout for floor units
                    if section.category == "Floor Units" {
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 4),
                            GridItem(.flexible(), spacing: 4)
                        ], spacing: 2) {
                            ForEach(section.items, id: \.name) { item in
                                CompactContactRow(name: item.name, number: item.number)
                            }
                        }
                    } else {
                        // Single column for other sections
                        ForEach(section.items, id: \.name) { item in
                            CompactContactRow(name: item.name, number: item.number)
                        }
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
        }
    }
}

// MARK: - Contact Row Component
struct ContactRow: View {
    let name: String
    let number: String
    
    var body: some View {
        HStack {
            Text(name)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.primary)
            
            Spacer()
            
            Button(action: { makeCall(number) }) {
                Text(number)
                    .font(.system(size: 10, weight: .semibold, design: .monospaced))
                    .foregroundColor(.blue)
            }
        }
        .padding(.vertical, 2)
    }
    
    private func makeCall(_ number: String) {
        #if os(iOS)
        let cleanNumber = number.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "/", with: "")
            .components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
        
        let firstNumber = String(cleanNumber.prefix(5))
        if let phoneURL = URL(string: "tel://\(firstNumber)") {
            UIApplication.shared.open(phoneURL)
        }
        #endif
    }
}

// MARK: - Compact Contact Row
struct CompactContactRow: View {
    let name: String
    let number: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(name)
                .font(.system(size: 8, weight: .medium))
                .foregroundColor(.primary)
                .lineLimit(1)
            
            Text(number)
                .font(.system(size: 8, weight: .semibold, design: .monospaced))
                .foregroundColor(.blue)
                .lineLimit(1)
        }
        .padding(3)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(4)
    }
}

// MARK: - Contact Chip Component
struct ContactChip: View {
    let name: String
    let number: String
    let color: Color
    
    var body: some View {
        Button(action: { makeCall(number) }) {
            HStack(spacing: 4) {
                Text(name)
                    .font(.system(size: 9, weight: .semibold))
                Text(number)
                    .font(.system(size: 9, weight: .bold, design: .monospaced))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color)
            .cornerRadius(6)
        }
    }
    
    private func makeCall(_ number: String) {
        #if os(iOS)
        if let phoneURL = URL(string: "tel://\(number)") {
            UIApplication.shared.open(phoneURL)
        }
        #endif
    }
}

#Preview {
    VStack {
        HospitalContactsCard()
            .padding()
    }
    .background(Color.gray.opacity(0.1))
}