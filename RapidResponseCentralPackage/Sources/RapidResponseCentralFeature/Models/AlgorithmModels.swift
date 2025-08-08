import Foundation
import SwiftUI

// MARK: - Algorithm Models for 50/50 Split View

public struct ProtocolAlgorithm: Sendable, Hashable {
    public let nodes: [AlgorithmNode]
    
    public init(nodes: [AlgorithmNode]) {
        self.nodes = nodes
    }
}

public struct AlgorithmNode: Identifiable, Sendable, Hashable {
    public let id: String
    public let title: String
    public let nodeType: NodeType
    public let critical: Bool
    public let content: String
    public let connections: [String]
    
    public init(
        id: String,
        title: String,
        nodeType: NodeType,
        critical: Bool,
        content: String,
        connections: [String]
    ) {
        self.id = id
        self.title = title
        self.nodeType = nodeType
        self.critical = critical
        self.content = content
        self.connections = connections
    }
}

public enum NodeType: String, Sendable, Hashable {
    case decision = "Decision"
    case assessment = "Assessment"
    case intervention = "Intervention"
    case medication = "Medication"
    case endpoint = "Endpoint"
    case action = "Action"
}

// MARK: - Updated Protocol Card Models

public struct ProtocolCard: Identifiable, Sendable, Hashable {
    public let id: String
    public let type: CardType
    public let title: String
    public let sections: [CardSection]
    
    public init(
        id: String,
        type: CardType,
        title: String,
        sections: [CardSection]
    ) {
        self.id = id
        self.type = type
        self.title = title
        self.sections = sections
    }
}

public enum CardType: String, Sendable, Hashable {
    case dynamic = "Dynamic"
    case assessment = "Assessment"
    case actions = "Actions"
}

public struct CardSection: Identifiable, Sendable, Hashable {
    public let id = UUID()
    public let title: String
    public let items: [String]
    
    public init(title: String, items: [String]) {
        self.title = title
        self.items = items
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(items)
    }
    
    public static func == (lhs: CardSection, rhs: CardSection) -> Bool {
        return lhs.title == rhs.title && lhs.items == rhs.items
    }
}

// MARK: - Updated Protocol Categories

public enum ProtocolCategory: String, CaseIterable, Sendable, Hashable {
    case cardiac = "Cardiac"
    case neurological = "Neurological"
    case respiratory = "Respiratory"
    case trauma = "Trauma"
    case infectious = "Infectious"
    case allergic = "Allergic"
    case support = "Support"
    
    public var color: Color {
        switch self {
        case .cardiac: return .red
        case .neurological: return .orange
        case .respiratory: return .blue
        case .trauma: return .yellow
        case .infectious: return .purple
        case .allergic: return .pink
        case .support: return .green
        }
    }
}

// MARK: - Updated Emergency Protocol

public struct EmergencyProtocol: Identifiable, Sendable, Hashable {
    public let id: String
    public let title: String
    public let icon: String
    public let category: ProtocolCategory
    public let algorithm: ProtocolAlgorithm
    public let cards: [ProtocolCard]
    
    public init(
        id: String,
        title: String,
        icon: String,
        category: ProtocolCategory,
        algorithm: ProtocolAlgorithm,
        cards: [ProtocolCard]
    ) {
        self.id = id
        self.title = title
        self.icon = icon
        self.category = category
        self.algorithm = algorithm
        self.cards = cards
    }
}

// MARK: - Performance Analytics Models

public struct ProtocolMetrics: Sendable, Hashable {
    public let totalProtocols: Int
    public let criticalProtocols: Int
    public let emergencyProtocols: Int
    public let rrtProtocols: Int
    public let loadTime: TimeInterval
    
    public init(
        totalProtocols: Int,
        criticalProtocols: Int,
        emergencyProtocols: Int,
        rrtProtocols: Int,
        loadTime: TimeInterval
    ) {
        self.totalProtocols = totalProtocols
        self.criticalProtocols = criticalProtocols
        self.emergencyProtocols = emergencyProtocols
        self.rrtProtocols = rrtProtocols
        self.loadTime = loadTime
    }
}

public struct ProtocolPerformanceEvent: Sendable, Hashable {
    public let protocolId: String
    public let eventType: ProtocolEventType
    public let timestamp: Date
    public let duration: TimeInterval?
    public let metadata: [String: String]
    
    public init(
        protocolId: String,
        eventType: ProtocolEventType,
        timestamp: Date = Date(),
        duration: TimeInterval? = nil,
        metadata: [String: String] = [:]
    ) {
        self.protocolId = protocolId
        self.eventType = eventType
        self.timestamp = timestamp
        self.duration = duration
        self.metadata = metadata
    }
}

public enum ProtocolEventType: String, Sendable, Hashable {
    case protocolAccessed = "protocol_accessed"
    case algorithmNodeViewed = "algorithm_node_viewed"
    case cardSectionExpanded = "card_section_expanded"
    case timerStarted = "timer_started"
    case medicationAdministered = "medication_administered"
    case protocolCompleted = "protocol_completed"
}

// MARK: - Visual Aid Models

public struct VisualAid: Identifiable, Sendable, Hashable {
    public let id: String
    public let imageName: String
    public let title: String
    public let description: String?
    public let annotations: [EducationalAnnotation]
    public let layout: VisualAidLayout
    public let interactionType: InteractionType
    
    public init(
        id: String,
        imageName: String,
        title: String,
        description: String? = nil,
        annotations: [EducationalAnnotation] = [],
        layout: VisualAidLayout,
        interactionType: InteractionType
    ) {
        self.id = id
        self.imageName = imageName
        self.title = title
        self.description = description
        self.annotations = annotations
        self.layout = layout
        self.interactionType = interactionType
    }
}

public enum VisualAidLayout: String, Sendable, Hashable {
    case aspectRatio = "aspectRatio"
    case fixed = "fixed"
    case responsive = "responsive"
}

public enum InteractionType: String, Sendable, Hashable {
    case none = "none"
    case tap = "tap"
    case zoom = "zoom"
    case swipe = "swipe"
}

public struct EducationalAnnotation: Identifiable, Sendable, Hashable {
    public let id: String
    public let label: String
    public let description: String
    public let position: AnnotationPosition
    public let type: AnnotationType
    public let color: AnnotationColor
    
    public init(
        id: String,
        label: String,
        description: String,
        position: AnnotationPosition,
        type: AnnotationType,
        color: AnnotationColor
    ) {
        self.id = id
        self.label = label
        self.description = description
        self.position = position
        self.type = type
        self.color = color
    }
}

public struct AnnotationPosition: Sendable, Hashable {
    public let x: Double
    public let y: Double
    
    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
}

public enum AnnotationType: String, Sendable, Hashable {
    case callout = "callout"
    case pointer = "pointer"
    case highlight = "highlight"
}

public enum AnnotationColor: String, Sendable, Hashable {
    case success = "success"
    case danger = "danger"
    case warning = "warning"
    case info = "info"
    
    public var color: Color {
        switch self {
        case .success: return .green
        case .danger: return .red
        case .warning: return .orange
        case .info: return .blue
        }
    }
}

public struct EducationalContent: Identifiable, Sendable, Hashable {
    public let id: String
    public let title: String
    public let description: String?
    public let contentType: ContentType
    public let visualAids: [VisualAid]
    public let keyPoints: [KeyPoint]
    
    public init(
        id: String,
        title: String,
        description: String? = nil,
        contentType: ContentType,
        visualAids: [VisualAid] = [],
        keyPoints: [KeyPoint] = []
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.contentType = contentType
        self.visualAids = visualAids
        self.keyPoints = keyPoints
    }
}

public enum ContentType: String, Sendable, Hashable {
    case rhythmRecognition = "rhythmRecognition"
    case procedureGuide = "procedureGuide"
    case anatomyReference = "anatomyReference"
    case medicationGuide = "medicationGuide"
    
    public var icon: String {
        switch self {
        case .rhythmRecognition: return "waveform.path.ecg"
        case .procedureGuide: return "list.clipboard"
        case .anatomyReference: return "figure.walk"
        case .medicationGuide: return "pills"
        }
    }
    
    public var color: Color {
        switch self {
        case .rhythmRecognition: return .red
        case .procedureGuide: return .blue
        case .anatomyReference: return .green
        case .medicationGuide: return .purple
        }
    }
}

public struct KeyPoint: Identifiable, Sendable, Hashable {
    public let id = UUID()
    public let text: String
    public let description: String
    public let importance: ImportanceLevel
    
    public init(text: String, description: String, importance: ImportanceLevel) {
        self.text = text
        self.description = description
        self.importance = importance
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(text)
        hasher.combine(description)
        hasher.combine(importance)
    }
    
    public static func == (lhs: KeyPoint, rhs: KeyPoint) -> Bool {
        return lhs.text == rhs.text && lhs.description == rhs.description && lhs.importance == rhs.importance
    }
}

public enum ImportanceLevel: String, Sendable, Hashable {
    case critical = "critical"
    case important = "important"
    case helpful = "helpful"
    
    public var icon: String {
        switch self {
        case .critical: return "exclamationmark.triangle.fill"
        case .important: return "info.circle.fill"
        case .helpful: return "lightbulb.fill"
        }
    }
    
    public var color: Color {
        switch self {
        case .critical: return .red
        case .important: return .orange
        case .helpful: return .blue
        }
    }
}

public enum ContentSizing {
    case rhythmChart
    case procedureImage
    case anatomyDiagram
    case medicationChart
    
    public var minHeight: CGFloat {
        switch self {
        case .rhythmChart: return 120
        case .procedureImage: return 200
        case .anatomyDiagram: return 250
        case .medicationChart: return 150
        }
    }
    
    public var maxHeight: CGFloat {
        switch self {
        case .rhythmChart: return 200
        case .procedureImage: return 400
        case .anatomyDiagram: return 500
        case .medicationChart: return 300
        }
    }
}