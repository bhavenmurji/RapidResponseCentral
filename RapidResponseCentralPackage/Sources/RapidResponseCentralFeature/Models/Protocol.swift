import Foundation
import SwiftUI

// NOTE: Core protocol models have been moved to AlgorithmModels.swift
// This file contains legacy models for compatibility

// MARK: - Legacy Protocol Node Model

public struct ProtocolNode: Identifiable, Sendable {
    public let id: String
    public let title: String
    public let content: String
    public let actions: [NodeAction]
    public let nextNodes: [String]
    public let urgencyLevel: UrgencyLevel
    public let checklistItems: [ChecklistItem]
    
    public init(
        id: String,
        title: String,
        content: String,
        actions: [NodeAction] = [],
        nextNodes: [String] = [],
        urgencyLevel: UrgencyLevel = .normal,
        checklistItems: [ChecklistItem] = []
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.actions = actions
        self.nextNodes = nextNodes
        self.urgencyLevel = urgencyLevel
        self.checklistItems = checklistItems
    }
}

public struct NodeAction: Identifiable, Sendable {
    public let id = UUID()
    public let type: ActionType
    public let label: String
    public let detail: String?
    
    public enum ActionType: Sendable {
        case medication(dose: String)
        case procedure
        case phoneCall(number: String, contact: String)
        case calculator(type: String)
    }
    
    public init(type: ActionType, label: String, detail: String? = nil) {
        self.type = type
        self.label = label
        self.detail = detail
    }
}

public struct ChecklistItem: Identifiable, Sendable {
    public let id = UUID()
    public let text: String
    public var isCompleted: Bool = false
    
    public init(text: String, isCompleted: Bool = false) {
        self.text = text
        self.isCompleted = isCompleted
    }
}

public enum UrgencyLevel: String, Sendable {
    case critical = "critical"
    case urgent = "urgent"
    case normal = "normal"
    case stable = "stable"
    
    public var color: Color {
        switch self {
        case .critical: return .red
        case .urgent: return .orange
        case .normal: return .blue
        case .stable: return .green
        }
    }
}