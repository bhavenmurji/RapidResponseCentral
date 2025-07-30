import Foundation
import SwiftUI

@MainActor
final class ProtocolService: ObservableObject {
    @Published private(set) var protocols: [EmergencyProtocol] = []
    @Published private(set) var rrtProtocols: [EmergencyProtocol] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    private let emergencyProtocolService = EmergencyProtocolService()
    private let rrtProtocolService = RRTProtocolService()
    
    init() {
        loadProtocols()
    }
    
    private func loadProtocols() {
        isLoading = true
        defer { isLoading = false }
        
        // Load emergency protocols from dedicated service
        protocols = emergencyProtocolService.protocols
        
        // Load RRT protocols from dedicated service
        rrtProtocols = rrtProtocolService.protocols
    }
    
    func getProtocol(for id: String) -> EmergencyProtocol? {
        // Search in both emergency and RRT protocols
        if let foundProtocol = protocols.first(where: { $0.id == id }) {
            return foundProtocol
        }
        return rrtProtocols.first { $0.id == id }
    }
    
    func getProtocol(by title: String) -> EmergencyProtocol? {
        // Search in both emergency and RRT protocols
        if let foundProtocol = protocols.first(where: { $0.title == title }) {
            return foundProtocol
        }
        return rrtProtocols.first { $0.title == title }
    }
    
    func getRRTProtocol(for id: String) -> EmergencyProtocol? {
        return rrtProtocols.first { $0.id == id }
    }
    
    func getAllProtocols() -> [EmergencyProtocol] {
        return protocols + rrtProtocols
    }
    
    func refreshProtocols() {
        loadProtocols()
    }
}