import Foundation

// MARK: - Emergency Contacts Model

public struct EmergencyContact: Identifiable, Sendable {
    public let id = UUID()
    public let category: ContactCategory
    public let name: String
    public let role: String
    public let phoneNumber: String
    public let phoneExtension: String?
    public let availability: String?
    public let notes: String?
    
    public enum ContactCategory: String, CaseIterable, Sendable {
        case codeTeam = "Code Team"
        case specialists = "Specialist Consults"
        case departments = "Departments"
        case pharmacy = "Pharmacy"
        case laboratory = "Laboratory"
        case radiology = "Radiology"
        case administration = "Administration"
        
        public var icon: String {
            switch self {
            case .codeTeam: return "🚨"
            case .specialists: return "🩺"
            case .departments: return "🏥"
            case .pharmacy: return "💊"
            case .laboratory: return "🧪"
            case .radiology: return "🩻"
            case .administration: return "📋"
            }
        }
    }
    
    public var formattedPhoneNumber: String {
        // Format for display (assuming US numbers)
        let cleaned = phoneNumber.filter { $0.isNumber }
        if cleaned.count == 10 {
            let areaCode = String(cleaned.prefix(3))
            let prefix = String(cleaned.dropFirst(3).prefix(3))
            let lineNumber = String(cleaned.dropFirst(6))
            return "(\(areaCode)) \(prefix)-\(lineNumber)"
        } else if cleaned.count == 7 {
            let prefix = String(cleaned.prefix(3))
            let lineNumber = String(cleaned.dropFirst(3))
            return "\(prefix)-\(lineNumber)"
        }
        return phoneNumber
    }
    
    public var callableNumber: String {
        // Clean number for tel: URL
        return phoneNumber.filter { $0.isNumber || $0 == "+" }
    }
    
    public init(
        category: ContactCategory,
        name: String,
        role: String,
        phoneNumber: String,
        phoneExtension: String? = nil,
        availability: String? = nil,
        notes: String? = nil
    ) {
        self.category = category
        self.name = name
        self.role = role
        self.phoneNumber = phoneNumber
        self.phoneExtension = phoneExtension
        self.availability = availability
        self.notes = notes
    }
}

// MARK: - Virtua Voorhees Default Contacts

public struct VirtuaContacts {
    public static let defaultContacts: [EmergencyContact] = [
        // Code Team
        EmergencyContact(
            category: .codeTeam,
            name: "Code Blue",
            role: "Adult Cardiac Arrest",
            phoneNumber: "99",
            availability: "24/7"
        ),
        EmergencyContact(
            category: .codeTeam,
            name: "Stroke Alert",
            role: "Acute Stroke Response",
            phoneNumber: "99",
            availability: "24/7"
        ),
        EmergencyContact(
            category: .codeTeam,
            name: "Rapid Response",
            role: "Clinical Deterioration",
            phoneNumber: "99",
            availability: "24/7"
        ),
        
        // Specialist Consults
        EmergencyContact(
            category: .specialists,
            name: "Sevaro Teleneurology",
            role: "Remote Neurology Consult",
            phoneNumber: "8562473098",
            availability: "24/7"
        ),
        EmergencyContact(
            category: .specialists,
            name: "Transfer Center",
            role: "Patient Transfers & Specialty Consults",
            phoneNumber: "8568865111",
            availability: "24/7"
        ),
        EmergencyContact(
            category: .specialists,
            name: "Interventional Cardiology",
            role: "STEMI/Cath Lab Activation",
            phoneNumber: "8568865111",
            notes: "Via Transfer Center"
        ),
        
        // Departments
        EmergencyContact(
            category: .departments,
            name: "Emergency Department",
            role: "Main ED",
            phoneNumber: "8562473575",
            availability: "24/7"
        ),
        EmergencyContact(
            category: .departments,
            name: "ICU",
            role: "Intensive Care Unit",
            phoneNumber: "8562473401",
            availability: "24/7"
        ),
        EmergencyContact(
            category: .departments,
            name: "Pharmacy",
            role: "Inpatient Pharmacy",
            phoneNumber: "8562473200",
            availability: "24/7"
        ),
        EmergencyContact(
            category: .departments,
            name: "Laboratory",
            role: "Stat Lab Results",
            phoneNumber: "8562473300",
            availability: "24/7"
        ),
        EmergencyContact(
            category: .departments,
            name: "Radiology",
            role: "Stat Imaging",
            phoneNumber: "8562473400",
            availability: "24/7"
        )
    ]
}