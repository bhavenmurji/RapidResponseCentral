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
    
    public var color: Color {
        switch self {
        case .cardiac: return .red
        case .neurological: return .orange
        case .respiratory: return .blue
        case .trauma: return .yellow
        case .infectious: return .purple
        case .allergic: return .pink
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