import Foundation
import SwiftUI

// MARK: - Event Logging Models

public final class ProtocolSession: ObservableObject, Identifiable {
    public let id = UUID()
    public let protocolId: String
    public let protocolTitle: String
    public let location: String?
    public let startTime: Date
    @Published public var endTime: Date?
    @Published public var events: [EventLogEntry] = []
    @Published public var isActive: Bool = true
    
    public var duration: TimeInterval {
        let end = endTime ?? Date()
        return end.timeIntervalSince(startTime)
    }
    
    public var formattedDuration: String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    public init(protocolId: String, protocolTitle: String, location: String? = nil) {
        self.protocolId = protocolId
        self.protocolTitle = protocolTitle
        self.location = location
        self.startTime = Date()
    }
    
    public func start() {
        self.isActive = true
        self.endTime = nil
    }
    
    public func endSession() {
        self.endTime = Date()
        self.isActive = false
    }
    
    public func addEvent(_ event: EventLogEntry) {
        events.append(event)
    }
}

public struct EventLogEntry: Identifiable, Sendable {
    public let id = UUID()
    public let timestamp: Date
    public let relativeTime: TimeInterval // Time since session start
    public let type: EventType
    public let description: String
    public let additionalNotes: String?
    
    public enum EventType: String, Sendable {
        case protocolStart = "Protocol start"
        case checkboxAction = "Checkbox action"
        case lapMarker = "Lap marker"
        case nodeNavigation = "Node navigation"
        case algorithmNode = "Algorithm node"
        case phoneCall = "Phone call"
        case medication = "Medication"
        case calculator = "Calculator"
        case customNote = "Custom note"
        
        public var icon: String {
            switch self {
            case .protocolStart: return ""
            case .checkboxAction: return "☑️"
            case .lapMarker: return "⏱️"
            case .nodeNavigation, .algorithmNode: return "→"
            case .phoneCall: return "📞"
            case .medication: return "💊"
            case .calculator: return "🧮"
            case .customNote: return "📝"
            }
        }
    }
    
    public var formattedTime: String {
        let minutes = Int(relativeTime) / 60
        let seconds = Int(relativeTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    public init(
        timestamp: Date = Date(),
        relativeTime: TimeInterval,
        type: EventType,
        description: String,
        additionalNotes: String? = nil
    ) {
        self.timestamp = timestamp
        self.relativeTime = relativeTime
        self.type = type
        self.description = description
        self.additionalNotes = additionalNotes
    }
}

// MARK: - Event Log Export

public struct EventLogExport {
    public let session: ProtocolSession
    
    public init(session: ProtocolSession) {
        self.session = session
    }
    
    public func exportAsText() -> String {
        var output = """
        \(session.protocolTitle.uppercased()) EVENT LOG
        """
        
        if let location = session.location {
            output += "\nLocation: \(location)"
        }
        
        output += """
        
        Date: \(DateFormatter.localizedString(from: session.startTime, dateStyle: .medium, timeStyle: .none))
        Duration: \(session.formattedDuration)
        
        TIME    EVENT
        """
        
        for event in session.events {
            let icon = event.type.icon.isEmpty ? "" : "\(event.type.icon) "
            output += "\n\(event.formattedTime)   \(icon)\(event.description)"
            
            if let notes = event.additionalNotes {
                output += "\n        \(notes)"
            }
        }
        
        output += "\n\nExported: \(DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .medium))"
        
        return output
    }
}