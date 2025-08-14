import Foundation
import SwiftUI
import os.log
import os.signpost

@available(iOS 13.0, macOS 10.15, *)
@MainActor
final class ProtocolService: ObservableObject {
    @Published private(set) var protocols: [EmergencyProtocol] = []
    @Published private(set) var rrtProtocols: [EmergencyProtocol] = []
    @Published private(set) var callsProtocols: [EmergencyProtocol] = []
    @Published private(set) var labsProtocols: [EmergencyProtocol] = []
    @Published private(set) var calculatorsProtocols: [EmergencyProtocol] = []
    @Published private(set) var isLoading = false
    @Published private(set) var loadingProgress: Double = 0.0
    @Published private(set) var error: Error?
    @Published private(set) var metrics: [LoadingMetrics] = []
    
    // Service instances
    private let emergencyProtocolService = EmergencyProtocolService()
    private let rrtProtocolService = RRTProtocolService()
    private let callsProtocolService = CallsProtocolService()
    private let labsProtocolService = LabsProtocolService()
    private let calculatorsProtocolService = CalculatorsProtocolService()
    
    // Performance monitoring
    private let performanceLogger = Logger(subsystem: "com.rapidresponsecentral.performance", category: "ProtocolService")
    private let signposter = OSSignposter(subsystem: "com.rapidresponsecentral.performance", category: "ServiceInitialization")
    
    // Lazy loading state
    private var loadedTabs: Set<AppTab> = []
    
    init() {
        // Only load emergency protocols initially (most likely first tab)
        Task {
            await loadTabProtocols(.emergencies)
        }
    }
    
    // Load protocols for specific tab on-demand
    @MainActor
    public func loadTabProtocols(_ tab: AppTab) async {
        guard !loadedTabs.contains(tab) else { return }
        
        loadedTabs.insert(tab)
        performanceLogger.info("📱 Loading protocols for tab: \(tab.rawValue)")
        
        switch tab {
        case .emergencies:
            if protocols.isEmpty {
                protocols = await loadEmergencyProtocols()
            }
        case .rrt:
            if rrtProtocols.isEmpty {
                rrtProtocols = await loadRRTProtocols()
            }
        case .calls:
            if callsProtocols.isEmpty {
                callsProtocols = await loadCallsProtocols()
            }
        case .labs:
            if labsProtocols.isEmpty {
                labsProtocols = await loadLabsProtocols()
            }
        case .calc:
            if calculatorsProtocols.isEmpty {
                calculatorsProtocols = await loadCalculatorsProtocols()
            }
        default:
            break
        }
    }
    
    private func startConcurrentLoading() {
        Task {
            await loadProtocolsConcurrently()
        }
    }
    
    @MainActor
    private func loadProtocolsConcurrently() async {
        isLoading = true
        error = nil
        loadingProgress = 0.0
        
        let signpostID = signposter.makeSignpostID()
        let signpostState = signposter.beginInterval("ConcurrentProtocolLoading", id: signpostID)
        let startTime = CACurrentMediaTime()
        
        performanceLogger.info("🚀 Starting optimized parallel protocol loading")
        
        do {
            // Use TaskGroup for better parallel execution control
            await withTaskGroup(of: (String, [EmergencyProtocol]).self) { group in
                // Add all loading tasks to execute in parallel
                group.addTask { ("emergency", await self.loadEmergencyProtocols()) }
                group.addTask { ("rrt", await self.loadRRTProtocols()) }
                group.addTask { ("calls", await self.loadCallsProtocols()) }
                group.addTask { ("labs", await self.loadLabsProtocols()) }
                group.addTask { ("calculators", await self.loadCalculatorsProtocols()) }
                
                // Collect results as they complete (not waiting for all)
                for await (type, protocols) in group {
                    switch type {
                    case "emergency": self.protocols = protocols
                    case "rrt": self.rrtProtocols = protocols
                    case "calls": self.callsProtocols = protocols
                    case "labs": self.labsProtocols = protocols
                    case "calculators": self.calculatorsProtocols = protocols
                    default: break
                    }
                    // Update progress incrementally
                    self.loadingProgress += 0.20
                }
            }
            
            let duration = CACurrentMediaTime() - startTime
            let totalProtocols = protocols.count + rrtProtocols.count + callsProtocols.count + labsProtocols.count + calculatorsProtocols.count + calculatorsProtocols.count
            
            signposter.endInterval("ConcurrentProtocolLoading", signpostState)
            performanceLogger.info("✅ All protocols loaded concurrently: \(totalProtocols) protocols in \(String(format: "%.3f", duration))s")
            
            // Create performance metrics
            await createPerformanceMetrics(loadingTime: duration)
            
            // Validate critical protocols
            validateCriticalProtocols()
            
        } catch {
            self.error = error
            performanceLogger.error("❌ Concurrent loading failed: \(error.localizedDescription)")
            
            // Fallback to sequential loading
            await loadProtocolsSequentially()
            
            signposter.endInterval("ConcurrentProtocolLoading", signpostState)
        }
        
        isLoading = false
        loadingProgress = 1.0
    }
    
    // Individual service loading methods (run concurrently)
    private func loadEmergencyProtocols() async -> [EmergencyProtocol] {
        await updateProgress(0.25)
        performanceLogger.info("📞 Loading emergency protocols...")
        // Wait a moment for the service to initialize its protocols
        while emergencyProtocolService.protocols.isEmpty && emergencyProtocolService.isLoading {
            try? await Task.sleep(nanoseconds: 100_000_000) // 100ms
        }
        return emergencyProtocolService.protocols
    }
    
    private func loadRRTProtocols() async -> [EmergencyProtocol] {
        await updateProgress(0.50)
        performanceLogger.info("🚨 Loading RRT protocols...")
        // Wait a moment for the service to initialize its protocols
        while rrtProtocolService.protocols.isEmpty && rrtProtocolService.isLoading {
            try? await Task.sleep(nanoseconds: 100_000_000) // 100ms
        }
        return rrtProtocolService.protocols
    }
    
    private func loadCallsProtocols() async -> [EmergencyProtocol] {
        await updateProgress(0.75)
        performanceLogger.info("📞 Loading calls protocols...")
        // Wait a moment for the service to initialize its protocols
        while callsProtocolService.protocols.isEmpty && callsProtocolService.isLoading {
            try? await Task.sleep(nanoseconds: 100_000_000) // 100ms
        }
        return callsProtocolService.protocols
    }
    
    private func loadLabsProtocols() async -> [EmergencyProtocol] {
        await updateProgress(0.80)
        performanceLogger.info("🧪 Loading labs protocols...")
        // Wait a moment for the service to initialize its protocols
        while labsProtocolService.protocols.isEmpty && labsProtocolService.isLoading {
            try? await Task.sleep(nanoseconds: 100_000_000) // 100ms
        }
        return labsProtocolService.protocols
    }
    
    private func loadCalculatorsProtocols() async -> [EmergencyProtocol] {
        await updateProgress(1.0)
        performanceLogger.info("🧮 Loading calculators protocols...")
        // Wait a moment for the service to initialize its protocols
        while calculatorsProtocolService.protocols.isEmpty && calculatorsProtocolService.isLoading {
            try? await Task.sleep(nanoseconds: 100_000_000) // 100ms
        }
        return calculatorsProtocolService.protocols
    }
    
    @MainActor
    private func loadProtocolsSequentially() async {
        performanceLogger.info("🔄 Falling back to sequential protocol loading")
        
        let startTime = CACurrentMediaTime()
        
        // Load from individual services as backup
        protocols = emergencyProtocolService.protocols
        rrtProtocols = rrtProtocolService.protocols
        callsProtocols = callsProtocolService.protocols
        labsProtocols = labsProtocolService.protocols
        
        let duration = CACurrentMediaTime() - startTime
        let totalProtocols = protocols.count + rrtProtocols.count + callsProtocols.count + labsProtocols.count + calculatorsProtocols.count
        
        performanceLogger.info("✅ Sequential loading completed: \(totalProtocols) protocols in \(String(format: "%.3f", duration))s")
        
        await createPerformanceMetrics(loadingTime: duration)
    }
    
    private func updateProgress(_ progress: Double) async {
        await MainActor.run {
            loadingProgress = progress
        }
    }
    
    private func createPerformanceMetrics(loadingTime: TimeInterval) async {
        let services = [
            ("EmergencyProtocolService", protocols),
            ("RRTProtocolService", rrtProtocols),
            ("CallsProtocolService", callsProtocols),
            ("LabsProtocolService", labsProtocols),
            ("CalculatorsProtocolService", calculatorsProtocols)
        ]
        
        var allMetrics: [LoadingMetrics] = []
        
        for (serviceName, protocols) in services {
            let serviceMetrics = LoadingMetrics(
                serviceName: serviceName,
                protocolCount: protocols.count,
                totalLoadingTime: loadingTime / 4, // Approximate per service
                averageLoadingTime: protocols.count > 0 ? (loadingTime / 4) / Double(protocols.count) : 0,
                memoryUsageMB: getCurrentMemoryUsage() / 4, // Approximate per service
                validationResults: [], // Simplified for now
                timestamp: Date()
            )
            allMetrics.append(serviceMetrics)
        }
        
        await MainActor.run {
            self.metrics = allMetrics
        }
    }
    
    private func getCurrentMemoryUsage() -> Double {
        var taskInfo = task_vm_info_data_t()
        var count = mach_msg_type_number_t(MemoryLayout<task_vm_info>.size) / 4
        let result: kern_return_t = withUnsafeMutablePointer(to: &taskInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), $0, &count)
            }
        }
        
        guard result == KERN_SUCCESS else { return 0 }
        return Double(taskInfo.phys_footprint) / 1024 / 1024 // Convert to MB
    }
    
    private func validateCriticalProtocols() {
        let criticalProtocolIds = [
            "code_blue_acls", "anaphylaxis_protocol", "rrt_sepsis",
            "labs_hyperkalemia", "acute_hf", "pneumothorax"
        ]
        let allProtocols = getAllProtocols()
        
        for criticalId in criticalProtocolIds {
            if allProtocols.first(where: { $0.id == criticalId }) != nil {
                performanceLogger.info("✅ Critical protocol validated: \(criticalId)")
            } else {
                performanceLogger.warning("⚠️ Missing critical protocol: \(criticalId)")
            }
        }
    }
    
    // MARK: - Protocol Access Methods
    
    func getProtocol(for id: String) -> EmergencyProtocol? {
        // Search across all protocol collections
        if let foundProtocol = protocols.first(where: { $0.id == id }) {
            return foundProtocol
        }
        if let foundProtocol = rrtProtocols.first(where: { $0.id == id }) {
            return foundProtocol
        }
        if let foundProtocol = callsProtocols.first(where: { $0.id == id }) {
            return foundProtocol
        }
        if let foundProtocol = labsProtocols.first(where: { $0.id == id }) {
            return foundProtocol
        }
        return calculatorsProtocols.first { $0.id == id }
    }
    
    func getProtocol(by title: String) -> EmergencyProtocol? {
        // Search across all protocol collections
        if let foundProtocol = protocols.first(where: { $0.title == title }) {
            return foundProtocol
        }
        if let foundProtocol = rrtProtocols.first(where: { $0.title == title }) {
            return foundProtocol
        }
        if let foundProtocol = callsProtocols.first(where: { $0.title == title }) {
            return foundProtocol
        }
        if let foundProtocol = labsProtocols.first(where: { $0.title == title }) {
            return foundProtocol
        }
        return calculatorsProtocols.first { $0.title == title }
    }
    
    func getRRTProtocol(for id: String) -> EmergencyProtocol? {
        return rrtProtocols.first { $0.id == id }
    }
    
    func getCallsProtocol(for id: String) -> EmergencyProtocol? {
        return callsProtocols.first { $0.id == id }
    }
    
    func getLabsProtocol(for id: String) -> EmergencyProtocol? {
        return labsProtocols.first { $0.id == id }
    }
    
    func getAllProtocols() -> [EmergencyProtocol] {
        return protocols + rrtProtocols + callsProtocols + labsProtocols + calculatorsProtocols
    }
    
    func getProtocolsByCategory(_ category: ProtocolCategory) -> [EmergencyProtocol] {
        return getAllProtocols().filter { $0.category == category }
    }
    
    func getEmergencyProtocols() -> [EmergencyProtocol] {
        return protocols
    }
    
    func refreshProtocols() {
        startConcurrentLoading()
    }
    
    func getLoadingMetrics() -> [LoadingMetrics] {
        return metrics
    }
    
    // MARK: - Performance Analytics
    
    func getProtocolMetrics() -> ProtocolMetrics {
        let totalProtocols = getAllProtocols().count
        let criticalProtocols = getAllProtocols().filter { proto in
            proto.algorithm.nodes.contains { $0.critical }
        }.count
        
        let averageLoadTime = metrics.isEmpty ? 0.0 : 
            metrics.map(\.totalLoadingTime).reduce(0, +) / Double(metrics.count)
        
        return ProtocolMetrics(
            totalProtocols: totalProtocols,
            criticalProtocols: criticalProtocols,
            emergencyProtocols: protocols.count,
            rrtProtocols: rrtProtocols.count,
            loadTime: averageLoadTime
        )
    }
}

// Note: ProtocolMetrics is defined in AlgorithmModels.swift

// MARK: - Simplified LoadingMetrics for Compatibility

struct LoadingMetrics: Sendable {
    let serviceName: String
    let protocolCount: Int
    let totalLoadingTime: TimeInterval
    let averageLoadingTime: TimeInterval
    let memoryUsageMB: Double
    let validationResults: [String] // Simplified
    let timestamp: Date
    
    init(
        serviceName: String,
        protocolCount: Int,
        totalLoadingTime: TimeInterval,
        averageLoadingTime: TimeInterval,
        memoryUsageMB: Double,
        validationResults: [String],
        timestamp: Date
    ) {
        self.serviceName = serviceName
        self.protocolCount = protocolCount
        self.totalLoadingTime = totalLoadingTime
        self.averageLoadingTime = averageLoadingTime
        self.memoryUsageMB = memoryUsageMB
        self.validationResults = validationResults
        self.timestamp = timestamp
    }
}