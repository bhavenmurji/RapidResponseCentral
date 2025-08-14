import SwiftUI
import os.log
import QuartzCore
import Darwin.Mach

// MARK: - Performance Monitoring Data Structures

public struct PerformanceMetrics {
    var concurrentSpeedup: Double = 1.0
    var sequentialTime: Double = 0.0
    var concurrentTime: Double = 0.0
    var totalOperations: Int = 0
    var memoryUsage: Double = 0.0
    var cpuUsage: Double = 0.0
    var timestamp: Date = Date()
    var operationsPerSecond: Double = 0.0
    var concurrencyEfficiency: Double = 100.0
}

// MARK: - Performance Monitor Manager

@MainActor
public class PerformanceMonitorManager: ObservableObject {
    
    @Published public var metrics: PerformanceMetrics = PerformanceMetrics()
    @Published public var isMonitoring: Bool = false
    @Published public var testResults: [PerformanceTestResult] = []
    
    private let performanceLogger = Logger(subsystem: "com.rapidresponsecentral.performance", category: "PerformanceMonitorManager")
    private var monitoringTimer: Timer?
    
    public init() {}
    
    public func startMonitoring() {
        guard !isMonitoring else { return }
        
        isMonitoring = true
        performanceLogger.info("🚀 Starting real-time performance monitoring")
        
        // Start monitoring timer
        monitoringTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.updateMetrics()
            }
        }
        
        // Run initial performance comparison
        Task {
            await runPerformanceComparison()
        }
    }
    
    public func stopMonitoring() {
        guard isMonitoring else { return }
        
        isMonitoring = false
        monitoringTimer?.invalidate()
        monitoringTimer = nil
        performanceLogger.info("⏹️ Stopping performance monitoring")
    }
    
    // MARK: - Performance Comparison Tests
    
    private func runPerformanceComparison() async {
        performanceLogger.info("🧪 Running concurrent vs sequential performance tests")
        
        // Test 1: File operation simulation
        let fileOpResults = await testFileOperations()
        testResults.append(fileOpResults)
        
        // Test 2: Protocol loading simulation
        let protocolResults = await testProtocolLoading()
        testResults.append(protocolResults)
        
        // Test 3: Network request simulation  
        let networkResults = await testNetworkRequests()
        testResults.append(networkResults)
        
        // Update overall metrics
        calculateOverallMetrics()
    }
    
    private func testFileOperations() async -> PerformanceTestResult {
        let operationCount = 8
        let operationDuration = 0.05 // 50ms each
        
        // Sequential test
        let sequentialStart = CACurrentMediaTime()
        for i in 0..<operationCount {
            await simulateOperation("FileOp_Seq_\(i)", duration: operationDuration)
        }
        let sequentialTime = CACurrentMediaTime() - sequentialStart
        
        // Concurrent test
        let concurrentStart = CACurrentMediaTime()
        let tasks = (0..<operationCount).map { i in
            Task {
                await simulateOperation("FileOp_Con_\(i)", duration: operationDuration)
            }
        }
        
        await withTaskGroup(of: Void.self) { group in
            for task in tasks {
                group.addTask { await task.value }
            }
        }
        let concurrentTime = CACurrentMediaTime() - concurrentStart
        
        let result = PerformanceTestResult(
            testName: "File Operations",
            operationCount: operationCount,
            sequentialTime: sequentialTime,
            concurrentTime: concurrentTime,
            speedup: sequentialTime / concurrentTime
        )
        
        performanceLogger.info("📁 File Operations Test: \(String(format: "%.2f", result.speedup))x speedup")
        return result
    }
    
    private func testProtocolLoading() async -> PerformanceTestResult {
        let operationCount = 7  // Number of emergency protocols
        let operationDuration = 0.03 // 30ms each
        
        // Sequential test
        let sequentialStart = CACurrentMediaTime()
        for i in 0..<operationCount {
            await simulateOperation("Protocol_Seq_\(i)", duration: operationDuration)
        }
        let sequentialTime = CACurrentMediaTime() - sequentialStart
        
        // Concurrent test
        let concurrentStart = CACurrentMediaTime()
        let tasks = (0..<operationCount).map { i in
            Task {
                await simulateOperation("Protocol_Con_\(i)", duration: operationDuration)
            }
        }
        
        await withTaskGroup(of: Void.self) { group in
            for task in tasks {
                group.addTask { await task.value }
            }
        }
        let concurrentTime = CACurrentMediaTime() - concurrentStart
        
        let result = PerformanceTestResult(
            testName: "Protocol Loading",
            operationCount: operationCount,
            sequentialTime: sequentialTime,
            concurrentTime: concurrentTime,
            speedup: sequentialTime / concurrentTime
        )
        
        performanceLogger.info("🏥 Protocol Loading Test: \(String(format: "%.2f", result.speedup))x speedup")
        return result
    }
    
    private func testNetworkRequests() async -> PerformanceTestResult {
        let operationCount = 5
        let operationDuration = 0.1 // 100ms each
        
        // Sequential test
        let sequentialStart = CACurrentMediaTime()
        for i in 0..<operationCount {
            await simulateOperation("Network_Seq_\(i)", duration: operationDuration)
        }
        let sequentialTime = CACurrentMediaTime() - sequentialStart
        
        // Concurrent test
        let concurrentStart = CACurrentMediaTime()
        let tasks = (0..<operationCount).map { i in
            Task {
                await simulateOperation("Network_Con_\(i)", duration: operationDuration)
            }
        }
        
        await withTaskGroup(of: Void.self) { group in
            for task in tasks {
                group.addTask { await task.value }
            }
        }
        let concurrentTime = CACurrentMediaTime() - concurrentStart
        
        let result = PerformanceTestResult(
            testName: "Network Requests",
            operationCount: operationCount,
            sequentialTime: sequentialTime,
            concurrentTime: concurrentTime,
            speedup: sequentialTime / concurrentTime
        )
        
        performanceLogger.info("🌐 Network Requests Test: \(String(format: "%.2f", result.speedup))x speedup")
        return result
    }
    
    private func simulateOperation(_ name: String, duration: TimeInterval) async {
        let startTime = CACurrentMediaTime()
        
        // Simulate CPU-bound work with some variability
        var counter = 0
        let targetTime = startTime + duration
        
        while CACurrentMediaTime() < targetTime {
            counter += 1
            
            // Add computational work to make the delay realistic
            if counter % 1000 == 0 {
                let tempArray = Array(repeating: counter, count: 50)
                _ = tempArray.reduce(0, +)
            }
        }
        
        let elapsed = CACurrentMediaTime() - startTime
        performanceLogger.debug("✅ \(name) completed in \(String(format: "%.3f", elapsed))s")
    }
    
    private func calculateOverallMetrics() {
        guard !testResults.isEmpty else { return }
        
        let totalSequentialTime = testResults.reduce(0.0) { $0 + $1.sequentialTime }
        let totalConcurrentTime = testResults.reduce(0.0) { $0 + $1.concurrentTime }
        let totalOperations = testResults.reduce(0) { $0 + $1.operationCount }
        
        metrics.sequentialTime = totalSequentialTime
        metrics.concurrentTime = totalConcurrentTime
        metrics.concurrentSpeedup = totalSequentialTime / totalConcurrentTime
        metrics.totalOperations = totalOperations
        metrics.operationsPerSecond = Double(totalOperations) / totalConcurrentTime
        metrics.concurrencyEfficiency = (metrics.concurrentSpeedup / Double(ProcessInfo.processInfo.activeProcessorCount)) * 100
        
        performanceLogger.info("📊 Overall Performance Results:")
        performanceLogger.info("   Total Sequential Time: \(String(format: "%.3f", totalSequentialTime))s")
        performanceLogger.info("   Total Concurrent Time: \(String(format: "%.3f", totalConcurrentTime))s")
        performanceLogger.info("   Overall Speedup: \(String(format: "%.2f", self.metrics.concurrentSpeedup))x")
        performanceLogger.info("   Efficiency: \(String(format: "%.1f", self.metrics.concurrencyEfficiency))%")
    }
    
    // MARK: - System Metrics
    
    private func updateMetrics() {
        // Update memory usage
        metrics.memoryUsage = getCurrentMemoryUsage()
        
        // Update CPU usage
        metrics.cpuUsage = getCurrentCPUUsage()
        
        // Update timestamp
        metrics.timestamp = Date()
    }
    
    private func getCurrentMemoryUsage() -> Double {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_,
                         task_flavor_t(MACH_TASK_BASIC_INFO),
                         $0,
                         &count)
            }
        }
        
        return kerr == KERN_SUCCESS ? Double(info.resident_size) / 1024.0 / 1024.0 : 0.0
    }
    
    private func getCurrentCPUUsage() -> Double {
        var cpuInfo: processor_info_array_t!
        var numCpuInfo: mach_msg_type_number_t = 0
        var numCpus: natural_t = 0
        
        let result = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &numCpus, &cpuInfo, &numCpuInfo)
        
        guard result == KERN_SUCCESS else { return 0.0 }
        
        let cpuLoad = cpuInfo.withMemoryRebound(to: processor_cpu_load_info.self, capacity: Int(numCpus)) { $0 }
        
        var totalTicks: UInt32 = 0
        var idleTicks: UInt32 = 0
        
        for i in 0..<Int(numCpus) {
            let cpu = cpuLoad[i]
            totalTicks += cpu.cpu_ticks.0 + cpu.cpu_ticks.1 + cpu.cpu_ticks.2 + cpu.cpu_ticks.3
            idleTicks += cpu.cpu_ticks.2
        }
        
        return Double(totalTicks - idleTicks) / Double(totalTicks) * 100.0
    }
}

// MARK: - Performance Test Result

public struct PerformanceTestResult {
    let testName: String
    let operationCount: Int
    let sequentialTime: Double
    let concurrentTime: Double
    let speedup: Double
    let timestamp: Date
    
    init(testName: String, operationCount: Int, sequentialTime: Double, concurrentTime: Double, speedup: Double) {
        self.testName = testName
        self.operationCount = operationCount
        self.sequentialTime = sequentialTime
        self.concurrentTime = concurrentTime
        self.speedup = speedup
        self.timestamp = Date()
    }
}

// MARK: - Performance Monitor View

public struct PerformanceMonitorView: View {
    @StateObject private var manager = PerformanceMonitorManager()
    @Environment(\.dismiss) private var dismiss
    
    public var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 24) {
                    // Header with status
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Real-time Performance Monitor")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("Monitoring concurrent vs sequential execution patterns")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        VStack(spacing: 4) {
                            Circle()
                                .fill(manager.isMonitoring ? .green : .red)
                                .frame(width: 12, height: 12)
                            
                            Text(manager.isMonitoring ? "ACTIVE" : "INACTIVE")
                                .font(.caption2)
                                .fontWeight(.medium)
                        }
                    }
                    
                    // Main Performance Metrics
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                        MetricCard(
                            title: "Speedup",
                            value: "\(String(format: "%.2f", manager.metrics.concurrentSpeedup))x",
                            subtitle: "Concurrent vs Sequential",
                            color: manager.metrics.concurrentSpeedup > 2.0 ? .green : .blue
                        )
                        
                        MetricCard(
                            title: "Efficiency",
                            value: "\(String(format: "%.0f", manager.metrics.concurrencyEfficiency))%",
                            subtitle: "CPU utilization",
                            color: manager.metrics.concurrencyEfficiency > 70 ? .green : .orange
                        )
                        
                        MetricCard(
                            title: "Operations/sec",
                            value: "\(String(format: "%.0f", manager.metrics.operationsPerSecond))",
                            subtitle: "Throughput rate",
                            color: .purple
                        )
                        
                        MetricCard(
                            title: "Memory",
                            value: "\(String(format: "%.0f", manager.metrics.memoryUsage))MB",
                            subtitle: "Current usage",
                            color: manager.metrics.memoryUsage > 200 ? .red : .blue
                        )
                    }
                    
                    // Performance Comparison Timeline
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Performance Comparison")
                            .font(.headline)
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Sequential")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text("\(String(format: "%.3f", manager.metrics.sequentialTime))s")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.red)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "arrow.right")
                                .foregroundStyle(.secondary)
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("Concurrent")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text("\(String(format: "%.3f", manager.metrics.concurrentTime))s")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.green)
                            }
                        }
                        
                        // Progress bar showing improvement
                        GeometryReader { geometry in
                            let improvementRatio = min(manager.metrics.concurrentSpeedup / 4.0, 1.0) // Cap at 4x for visual
                            
                            HStack(spacing: 0) {
                                Rectangle()
                                    .fill(Color.green)
                                    .frame(width: geometry.size.width * improvementRatio)
                                
                                Rectangle()
                                    .fill(Color(.systemGray4))
                                    .frame(width: geometry.size.width * (1.0 - improvementRatio))
                            }
                        }
                        .frame(height: 8)
                        .cornerRadius(4)
                        
                        Text("Time saved: \(String(format: "%.3f", manager.metrics.sequentialTime - manager.metrics.concurrentTime))s")
                            .font(.caption)
                            .foregroundStyle(.green)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Test Results
                    if !manager.testResults.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Test Results")
                                .font(.headline)
                            
                            ForEach(Array(manager.testResults.enumerated()), id: \.offset) { index, result in
                                TestResultRow(result: result)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    
                    // Performance Insights
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Performance Insights")
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            if manager.metrics.concurrentSpeedup > 3.0 {
                                InsightRow(
                                    icon: "🚀",
                                    text: "Excellent concurrency performance: \(String(format: "%.1f", manager.metrics.concurrentSpeedup))x speedup",
                                    color: .green
                                )
                            }
                            
                            if manager.metrics.concurrencyEfficiency > 80 {
                                InsightRow(
                                    icon: "⚡",
                                    text: "High CPU efficiency: \(String(format: "%.0f", manager.metrics.concurrencyEfficiency))% utilization",
                                    color: .green
                                )
                            }
                            
                            if manager.metrics.memoryUsage > 200 {
                                InsightRow(
                                    icon: "⚠️",
                                    text: "High memory usage: \(String(format: "%.0f", manager.metrics.memoryUsage))MB",
                                    color: .orange
                                )
                            }
                            
                            let timeSaved = manager.metrics.sequentialTime - manager.metrics.concurrentTime
                            if timeSaved > 0.1 {
                                InsightRow(
                                    icon: "⏱️",
                                    text: "Time saved: \(String(format: "%.2f", timeSaved))s with concurrent patterns",
                                    color: .blue
                                )
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                .padding()
            }
            .navigationTitle("Performance")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(manager.isMonitoring ? "Stop" : "Start") {
                        if manager.isMonitoring {
                            manager.stopMonitoring()
                        } else {
                            manager.startMonitoring()
                        }
                    }
                    .foregroundStyle(manager.isMonitoring ? .red : .green)
                }
            }
        }
        .onAppear {
            manager.startMonitoring()
        }
        .onDisappear {
            manager.stopMonitoring()
        }
    }
}

// MARK: - Supporting Views

struct MetricCard: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(color)
            
            Text(subtitle)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(16)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct TestResultRow: View {
    let result: PerformanceTestResult
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(result.testName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text("\(result.operationCount) operations")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(String(format: "%.2f", result.speedup))x")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.green)
                
                Text("\(String(format: "%.3f", result.concurrentTime))s")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct InsightRow: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 8) {
            Text(icon)
                .font(.caption)
            
            Text(text)
                .font(.caption)
                .foregroundStyle(color)
            
            Spacer()
        }
    }
}

