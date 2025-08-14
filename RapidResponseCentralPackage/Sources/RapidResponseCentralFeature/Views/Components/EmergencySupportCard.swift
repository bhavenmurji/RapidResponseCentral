import SwiftUI

// MARK: - Emergency Support Card
public struct EmergencySupportCard: View {
    @State private var currentPage: Int = 0
    @State private var showingPhoneNumbers: Bool = false
    
    private let maxPages = 4
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 0) {
            // Main content with swipe functionality
            TabView(selection: $currentPage) {
                // Page 1: RRT Initial Steps with Key Contacts
                rrtInitialStepsView
                    .tag(0)
                
                // Page 2: Emergency Phone Numbers
                emergencyPhoneNumbersView
                    .tag(1)
                    
                // Page 3: Critical Contacts & Residents
                criticalContactsView
                    .tag(2)
                    
                // Page 4: Imaging, Labs & Floor Units
                imagingLabsFloorsView
                    .tag(3)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 120)
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Emergency contacts carousel. Page \(currentPage + 1) of \(maxPages). Swipe left or right to navigate.")
            
            // Page indicator
            pageIndicator
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.red.opacity(0.3), lineWidth: 1.5)
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    // MARK: - RRT Initial Steps View
    private var rrtInitialStepsView: some View {
        HStack(spacing: 12) {
            // Left Column - Initial Steps
            VStack(alignment: .leading, spacing: 4) {
                Text("RRT Initial Steps")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.red)
                    .padding(.bottom, 2)
                
                VStack(alignment: .leading, spacing: 2) {
                    rrtStepItem("1. \"Hi I'm Dr __, on RRTs\"")
                    rrtStepItem("2. Fresh vitals")
                    rrtStepItem("3. IV access + 15L O2")
                    rrtStepItem("4. ABCDE + GCS + POC GLU")
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
                .frame(height: 100)
            
            // Right Column - Key Phone Numbers
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text("Key Contacts")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                    
                    Spacer()
                    
                    HStack(spacing: 2) {
                        Text("Swipe")
                            .font(.system(size: 9))
                            .foregroundColor(.secondary)
                            .italic()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 9))
                            .foregroundColor(.blue)
                            .symbolEffect(.pulse, options: .repeating)
                    }
                }
                .padding(.bottom, 1)
                
                VStack(alignment: .leading, spacing: 2) {
                    phoneNumberItem("ICU NP", "79628", .purple)
                    phoneNumberItem("Anesthesia", "79361", .blue)
                    phoneNumberItem("Sevaro/Neuro", "856-347-3098", .green)
                    phoneNumberItem("Transfer Ctr", "65111", .orange)
                    phoneNumberItem("Psych Consult", "797-4850", .red)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
    }
    
    // MARK: - Emergency Phone Numbers View
    private var emergencyPhoneNumbersView: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Additional Emergency Numbers")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                        .font(.caption2)
                        .foregroundColor(.blue)
                        .symbolEffect(.pulse, options: .repeating)
                    Text("Swipe")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .italic()
                }
            }
            .padding(.bottom, 2)
            
            HStack(spacing: 12) {
                // Left Column
                VStack(alignment: .leading, spacing: 3) {
                    phoneNumberItem("Pharmacy", "73030", .indigo)
                    phoneNumberItem("Lab", "73020", .cyan)
                    phoneNumberItem("Radiology", "73565", .mint)
                    phoneNumberItem("Security", "73205", .gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Right Column
                VStack(alignment: .leading, spacing: 3) {
                    phoneNumberItem("CT Scan", "74470/74366", .blue)
                    phoneNumberItem("MRI", "74019", .purple)
                    phoneNumberItem("Echo", "72292", .orange)
                    phoneNumberItem("EEG", "73493", .red)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(12)
    }
    
    // MARK: - Helper Views
    private func rrtStepItem(_ step: String) -> some View {
        Text(step)
            .font(.system(size: 10))
            .fontWeight(.medium)
            .foregroundColor(.primary)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
    }
    
    private func phoneNumberItem(_ title: String, _ number: String, _ color: Color) -> some View {
        HStack(spacing: 2) {
            Circle()
                .fill(color)
                .frame(width: 4, height: 4)
            
            Text(title)
                .font(.system(size: 10))
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            
            Spacer(minLength: 2)
            
            Text(number)
                .font(.system(size: 10))
                .foregroundColor(.secondary)
                .fontDesign(.monospaced)
                .lineLimit(1)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if number != "Call" {
                makePhoneCall(number)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title), phone number \(number)")
        .accessibilityHint("Double tap to call")
        .accessibilityAddTraits(.isButton)
    }
    
    private var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(0..<maxPages, id: \.self) { index in
                Capsule()
                    .fill(index == currentPage ? Color.red : Color(.systemGray4))
                    .frame(width: index == currentPage ? 20 : 8, height: 8)
                    .animation(.spring(response: 0.3, dampingFraction: 0.8), value: currentPage)
            }
        }
        .padding(.vertical, 8)
    }
    
    // MARK: - Critical Contacts & Residents View
    private var criticalContactsView: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Critical Contacts & Residents")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.orange)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                        .font(.caption2)
                        .foregroundColor(.blue)
                    Text("Swipe")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .italic()
                    Image(systemName: "chevron.right")
                        .font(.caption2)
                        .foregroundColor(.blue)
                }
            }
            .padding(.bottom, 2)
            
            HStack(spacing: 12) {
                // Left Column - Critical Staff
                VStack(alignment: .leading, spacing: 2) {
                    phoneNumberItem("ICU Resident", "79271", .purple)
                    phoneNumberItem("ICU Lounge", "16976", .blue)
                    phoneNumberItem("Anesthesiologist", "79361", .red)
                    phoneNumberItem("Nurse Anesthesiologist", "79362", .orange)
                    phoneNumberItem("Guest Services", "73860", .green)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Right Column - Critical Departments
                VStack(alignment: .leading, spacing: 2) {
                    phoneNumberItem("Nursing Supervisor", "79516/79700", .orange)
                    phoneNumberItem("Nursing Admin", "73900", .yellow)
                    phoneNumberItem("Respiratory", "73565", .cyan)
                    phoneNumberItem("IV Team", "73940", .mint)
                    phoneNumberItem("Security", "73205", .gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(12)
    }
    
    // MARK: - Imaging, Labs & Floor Units View
    private var imagingLabsFloorsView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Imaging, Labs & Floor Units")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.caption2)
                            .foregroundColor(.blue)
                        Text("Swipe")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .italic()
                    }
                }
                
                // Imaging Section
                VStack(alignment: .leading, spacing: 1) {
                    Text("Imaging")
                        .font(.system(size: 10))
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 1) {
                            phoneNumberItem("CT Scan", "74470", .blue)
                            phoneNumberItem("X-RAY", "73788", .cyan)
                            phoneNumberItem("MRI", "74019", .purple)
                        }
                        VStack(alignment: .leading, spacing: 1) {
                            phoneNumberItem("Reading Rm", "73780", .indigo)
                            phoneNumberItem("IR", "79775", .orange)
                            phoneNumberItem("Echo", "72292", .pink)
                        }
                    }
                }
                
                // Labs Section
                VStack(alignment: .leading, spacing: 1) {
                    Text("Laboratory")
                        .font(.system(size: 10))
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 1) {
                            phoneNumberItem("Lab", "73020", .red)
                            phoneNumberItem("Chemistry", "73125", .orange)
                            phoneNumberItem("Blood Bank", "73193", .red)
                        }
                        VStack(alignment: .leading, spacing: 1) {
                            phoneNumberItem("Hematology", "73136", .pink)
                            phoneNumberItem("Micro", "73160", .green)
                        }
                    }
                }
                
                // Floor Units Section
                VStack(alignment: .leading, spacing: 1) {
                    Text("Floor Units")
                        .font(.system(size: 10))
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 1) {
                            phoneNumberItem("ICU", "73801", .red)
                            phoneNumberItem("7A Med Surg", "73150", .green)
                            phoneNumberItem("6A Cardiology", "73831", .cyan)
                            phoneNumberItem("5A Telemetry", "73911", .indigo)
                            phoneNumberItem("4A Ortho", "72490", .mint)
                        }
                        VStack(alignment: .leading, spacing: 1) {
                            phoneNumberItem("3A Oncology", "73891", .orange)
                            phoneNumberItem("2A Neuro", "73821", .purple)
                            phoneNumberItem("1C ED", "75001", .red)
                            phoneNumberItem("L&D", "73921", .pink)
                            phoneNumberItem("PACU", "72350", .blue)
                        }
                    }
                }
            }
        }
        .padding(12)
        .frame(height: 110)
    }
    
    // MARK: - Phone Call Action
    private func makePhoneCall(_ number: String) {
        #if os(iOS)
        let cleanNumber = number.replacingOccurrences(of: "-", with: "")
        if let phoneURL = URL(string: "tel://\(cleanNumber)") {
            if UIApplication.shared.canOpenURL(phoneURL) {
                UIApplication.shared.open(phoneURL)
            }
        }
        #endif
    }
}

// MARK: - Preview
#if DEBUG
struct EmergencySupportCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            EmergencySupportCard()
                .padding()
            Spacer()
        }
        .background(Color(.systemGray6))
    }
}
#endif