import Foundation
import SwiftUI
import os.log
import os.signpost

// MARK: - Protocol Cache Actor

/// Actor-isolated protocol caching system for thread-safe medical protocol management
/// Ensures critical medical data integrity while maximizing concurrent performance
@globalActor
public actor ProtocolCacheActor {
    public static let shared = ProtocolCacheActor()
    
    private init() {}
    
    private var protocolCache: [String: [EmergencyProtocol]] = [:]
    private var validationCache: [String: ValidationResult] = [:]
    private var lastUpdated: [String: Date] = [:]
    private var preloadingTasks: [String: Task<[EmergencyProtocol], Error>] = [:]
    
    private let logger = Logger(subsystem: "com.rapidresponsecentral.cache", category: "ProtocolCache")
    private let signposter = OSSignposter(subsystem: "com.rapidresponsecentral.cache", category: "CacheOperations")
    
    // MARK: - Cache Management
    
    public func getProtocols(for serviceKey: String) -> [EmergencyProtocol]? {
        let signpostID = signposter.makeSignpostID()
        let signpostState = signposter.beginInterval("CacheAccess", id: signpostID)
        defer { signposter.endInterval("CacheAccess", signpostState) }
        
        if let cached = protocolCache[serviceKey] {
            logger.info("📋 Cache hit for \(serviceKey): \(cached.count) protocols")
            return cached
        }
        
        logger.info("💾 Cache miss for \(serviceKey)")
        return nil
    }
    
    public func setProtocols(_ protocols: [EmergencyProtocol], for serviceKey: String) {
        let signpostID = signposter.makeSignpostID()
        let signpostState = signposter.beginInterval("CacheStore", id: signpostID)
        defer { signposter.endInterval("CacheStore", signpostState) }
        
        protocolCache[serviceKey] = protocols
        lastUpdated[serviceKey] = Date()
        
        logger.info("✅ Cached \(protocols.count) protocols for \(serviceKey)")
    }
    
    public func getValidationResult(for protocolId: String) -> ValidationResult? {
        return validationCache[protocolId]
    }
    
    public func setValidationResult(_ result: ValidationResult, for protocolId: String) {
        validationCache[protocolId] = result
        logger.debug("🔍 Validation result cached for \(protocolId): \(result.isValid)")
    }
    
    public func startPreloading(for serviceKey: String, task: Task<[EmergencyProtocol], Error>) {
        preloadingTasks[serviceKey] = task
        logger.info("⚡ Started preloading task for \(serviceKey)")
    }
    
    public func getPreloadingTask(for serviceKey: String) -> Task<[EmergencyProtocol], Error>? {
        return preloadingTasks[serviceKey]
    }
    
    public func clearCache(for serviceKey: String? = nil) {
        if let serviceKey = serviceKey {
            protocolCache.removeValue(forKey: serviceKey)
            lastUpdated.removeValue(forKey: serviceKey)
            preloadingTasks.removeValue(forKey: serviceKey)?.cancel()
            logger.info("🗑️ Cleared cache for \(serviceKey)")
        } else {
            protocolCache.removeAll()
            validationCache.removeAll()
            lastUpdated.removeAll()
            preloadingTasks.values.forEach { $0.cancel() }
            preloadingTasks.removeAll()
            logger.info("🗑️ Cleared entire cache")
        }
    }
    
    public func getCacheStats() -> CacheStats {
        return CacheStats(
            totalCachedServices: protocolCache.count,
            totalProtocols: protocolCache.values.map { $0.count }.reduce(0, +),
            totalValidations: validationCache.count,
            activePreloadingTasks: preloadingTasks.count
        )
    }
}

// MARK: - Supporting Types

public struct ValidationResult: Sendable {
    public let isValid: Bool
    public let validatedAt: Date
    public let errors: [ValidationError]
    public let performanceMetrics: ValidationMetrics
    
    public init(isValid: Bool, errors: [ValidationError] = [], performanceMetrics: ValidationMetrics) {
        self.isValid = isValid
        self.validatedAt = Date()
        self.errors = errors
        self.performanceMetrics = performanceMetrics
    }
}

public struct ValidationError: Sendable {
    public let nodeId: String
    public let message: String
    public let severity: Severity
    
    public enum Severity: String, Sendable {
        case critical = "critical"
        case warning = "warning"
        case info = "info"
    }
    
    public init(nodeId: String, message: String, severity: Severity) {
        self.nodeId = nodeId
        self.message = message
        self.severity = severity
    }
}

public struct ValidationMetrics: Sendable {
    public let totalNodes: Int
    public let validNodes: Int
    public let executionTime: TimeInterval
    public let memoryUsage: Int64
    
    public init(totalNodes: Int, validNodes: Int, executionTime: TimeInterval, memoryUsage: Int64) {
        self.totalNodes = totalNodes
        self.validNodes = validNodes
        self.executionTime = executionTime
        self.memoryUsage = memoryUsage
    }
}

public struct CacheStats: Sendable {
    public let totalCachedServices: Int
    public let totalProtocols: Int
    public let totalValidations: Int
    public let activePreloadingTasks: Int
    
    public init(totalCachedServices: Int, totalProtocols: Int, totalValidations: Int, activePreloadingTasks: Int) {
        self.totalCachedServices = totalCachedServices
        self.totalProtocols = totalProtocols
        self.totalValidations = totalValidations
        self.activePreloadingTasks = activePreloadingTasks
    }
}

// MARK: - Protocol Validator

public struct ProtocolValidator: Sendable {
    private let logger = Logger(subsystem: "com.rapidresponsecentral.validation", category: "ProtocolValidator")
    
    public init() {}
    
    /// Validates protocol algorithms concurrently for maximum performance
    public func validateProtocols(_ protocols: [EmergencyProtocol]) async -> [String: ValidationResult] {
        let startTime = CACurrentMediaTime()
        
        return await withTaskGroup(of: (String, ValidationResult).self) { group in
            var results: [String: ValidationResult] = [:]
            
            for protocolItem in protocols {
                group.addTask {
                    let validationResult = await self.validateSingleProtocol(protocolItem)
                    return (protocolItem.id, validationResult)
                }
            }
            
            for await (protocolId, result) in group {
                results[protocolId] = result
            }
            
            let totalTime = CACurrentMediaTime() - startTime
            logger.info("🔍 Validated \(protocols.count) protocols in \(String(format: "%.3f", totalTime))s")
            
            return results
        }
    }
    
    private func validateSingleProtocol(_ protocolItem: EmergencyProtocol) async -> ValidationResult {
        let startTime = CACurrentMediaTime()
        let memoryBefore = getCurrentMemoryUsage()
        
        var errors: [ValidationError] = []
        let nodes = protocolItem.algorithm.nodes
        var validNodeCount = 0
        
        // Validate each node concurrently
        await withTaskGroup(of: [ValidationError].self) { group in
            for node in nodes {
                group.addTask {
                    return self.validateNode(node, in: protocolItem)
                }
            }
            
            for await nodeErrors in group {
                errors.append(contentsOf: nodeErrors)
                if nodeErrors.isEmpty {
                    validNodeCount += 1
                }
            }
        }
        
        // Additional protocol-level validations
        errors.append(contentsOf: validateProtocolStructure(protocolItem))
        errors.append(contentsOf: validateCardIntegrity(protocolItem.cards))
        
        let executionTime = CACurrentMediaTime() - startTime
        let memoryAfter = getCurrentMemoryUsage()
        let memoryUsed = memoryAfter - memoryBefore
        
        let metrics = ValidationMetrics(
            totalNodes: nodes.count,
            validNodes: validNodeCount,
            executionTime: executionTime,
            memoryUsage: memoryUsed
        )
        
        let isValid = errors.allSatisfy { $0.severity != .critical }
        
        return ValidationResult(
            isValid: isValid,
            errors: errors,
            performanceMetrics: metrics
        )
    }
    
    private func validateNode(_ node: AlgorithmNode, in protocolItem: EmergencyProtocol) -> [ValidationError] {
        var errors: [ValidationError] = []
        
        // Validate node connections
        for connectionId in node.connections {
            let hasConnection = protocolItem.algorithm.nodes.contains { $0.id == connectionId }
            if !hasConnection {
                errors.append(ValidationError(
                    nodeId: node.id,
                    message: "Invalid connection to node '\(connectionId)'",
                    severity: .critical
                ))
            }
        }
        
        // Validate critical nodes have appropriate content
        if node.critical && node.content.isEmpty {
            errors.append(ValidationError(
                nodeId: node.id,
                message: "Critical node missing content",
                severity: .critical
            ))
        }
        
        // Validate decision nodes have multiple connections
        if node.nodeType == .decision && node.connections.count < 2 {
            errors.append(ValidationError(
                nodeId: node.id,
                message: "Decision node should have multiple pathways",
                severity: .warning
            ))
        }
        
        return errors
    }
    
    private func validateProtocolStructure(_ protocolItem: EmergencyProtocol) -> [ValidationError] {
        var errors: [ValidationError] = []
        
        // Check for orphaned nodes
        let connectedNodes = Set(protocolItem.algorithm.nodes.flatMap { $0.connections })
        let allNodeIds = Set(protocolItem.algorithm.nodes.map { $0.id })
        let rootNodes = allNodeIds.subtracting(connectedNodes)
        
        if rootNodes.count > 1 {
            errors.append(ValidationError(
                nodeId: "protocol_structure",
                message: "Multiple root nodes detected: \(rootNodes.joined(separator: ", "))",
                severity: .warning
            ))
        }
        
        return errors
    }
    
    private func validateCardIntegrity(_ cards: [ProtocolCard]) -> [ValidationError] {
        var errors: [ValidationError] = []
        
        // Ensure we have all required card types
        let cardTypes = Set(cards.map { $0.type })
        let requiredTypes: Set<CardType> = [.dynamic, .assessment, .actions]
        let missingTypes = requiredTypes.subtracting(cardTypes)
        
        for missingType in missingTypes {
            errors.append(ValidationError(
                nodeId: "card_integrity",
                message: "Missing required card type: \(missingType.rawValue)",
                severity: .warning
            ))
        }
        
        return errors
    }
    
    private func getCurrentMemoryUsage() -> Int64 {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size) / 4
        
        let result: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }
        
        return result == KERN_SUCCESS ? Int64(info.resident_size) : 0
    }
}

// MARK: - Background Preloader

public struct BackgroundPreloader: Sendable {
    private let logger = Logger(subsystem: "com.rapidresponsecentral.preloader", category: "BackgroundPreloader")
    
    public init() {}
    
    /// Preloads protocols in background with priority-based scheduling
    public func startPreloading() async {
        logger.info("🚀 Starting background protocol preloading")
        
        let priorities: [(String, TaskPriority)] = [
            ("emergency", .high),
            ("rrt", .medium),
            ("calls", .low),
            ("labs", .low)
        ]
        
        await withTaskGroup(of: Void.self) { group in
            for (serviceKey, priority) in priorities {
                group.addTask(priority: priority) {
                    await self.preloadService(serviceKey)
                }
            }
        }
        
        logger.info("✅ Background preloading completed")
    }
    
    private func preloadService(_ serviceKey: String) async {
        let task = Task<[EmergencyProtocol], Error> {
            // Simulate protocol loading - replace with actual service calls
            try await Task.sleep(nanoseconds: 100_000_000) // 100ms
            return []
        }
        
        await ProtocolCacheActor.shared.startPreloading(for: serviceKey, task: task)
        
        do {
            let protocols = try await task.value
            await ProtocolCacheActor.shared.setProtocols(protocols, for: serviceKey)
            logger.debug("✅ Preloaded \(protocols.count) protocols for \(serviceKey)")
        } catch {
            logger.error("❌ Failed to preload \(serviceKey): \(error.localizedDescription)")
        }
    }
}