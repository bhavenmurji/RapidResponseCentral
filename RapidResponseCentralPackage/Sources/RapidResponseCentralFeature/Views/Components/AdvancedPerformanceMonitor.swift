import SwiftUI
import os.log
import QuartzCore
import Darwin.Mach

// MARK: - Advanced Performance Monitor for Production Use
// Integrates directly into RapidResponseCentral for real-time performance tracking

@MainActor
public class AdvancedPerformanceMonitorManager: ObservableObject {
    
    @Published public var isMonitoring: Bool = false
    @Published public var currentMetrics: RealtimeMetrics = RealtimeMetrics()
    @Published public var performanceAlerts: [PerformanceAlert] = []
    @Published public var sessionReport: PerformanceSessionReport?
    
    private let logger = Logger(subsystem: "com.rapidresponsecentral.performance", category: "AdvancedMonitor")
    private var displayLink: CADisplayLink?
    private var monitoringTimer: Timer?
    private var sessionStartTime: Date?
    private var frameMetrics: [FrameMetric] = []
    private var memoryMeasurements: [MemoryMeasurement] = []
    
    public init() {}
    
    // MARK: - Public Interface
    
    public func startMonitoring() {
        guard !isMonitoring else { return }
        
        isMonitoring = true
        sessionStartTime = Date()
        performanceAlerts.removeAll()
        frameMetrics.removeAll()
        memoryMeasurements.removeAll()
        
        logger.info("🚀 Starting advanced performance monitoring")
        
        setupDisplayLink()
        setupMemoryMonitoring()
        
        // Initial metrics collection
        updateCurrentMetrics()
    }
    
    public func stopMonitoring() {
        guard isMonitoring else { return }
        
        isMonitoring = false
        cleanupMonitoring()
        generateSessionReport()
        
        logger.info("⏹️ Stopping advanced performance monitoring")
    }
    
    public func trackUserInteraction(_ interactionType: UserInteractionType) {
        guard isMonitoring else { return }
        
        logger.debug("👆 User interaction: \(interactionType.rawValue)")
        
        // Track interaction-specific performance
        let startTime = CACurrentMediaTime()
        
        // Schedule performance check after interaction
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.checkInteractionPerformance(interactionType, startTime: startTime)
        }
    }
    
    // MARK: - Display Link Frame Monitoring
    
    private func setupDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(frameUpdate))
        displayLink?.add(to: .main, forMode: .default)
        displayLink?.preferredFrameRateRange = CAFrameRateRange(minimum: 60, maximum: 120)
    }
    
    @objc private func frameUpdate() {
        guard isMonitoring else { return }
        
        let timestamp = CACurrentMediaTime()
        let frameDuration = displayLink?.duration ?? 0
        
        let frameMetric = FrameMetric(
            timestamp: timestamp,
            duration: frameDuration,
            targetDuration: displayLink?.targetTimestamp ?? timestamp
        )
        
        frameMetrics.append(frameMetric)
        
        // Keep only last 300 frames (5 seconds at 60fps)
        if frameMetrics.count > 300 {
            frameMetrics.removeFirst()
        }
        
        // Check for performance issues
        checkFramePerformance(frameMetric)
    }
    
    private func setupMemoryMonitoring() {
        monitoringTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.updateMemoryMetrics()
                self?.updateCurrentMetrics()
            }
        }
    }
    
    private func updateMemoryMetrics() {
        let memoryUsage = getCurrentMemoryUsage()
        let cpuUsage = getCurrentCPUUsage()
        
        let measurement = MemoryMeasurement(
            timestamp: Date(),
            memoryMB: memoryUsage,
            cpuPercent: cpuUsage
        )
        
        memoryMeasurements.append(measurement)
        
        // Keep only last 300 measurements (5 minutes)
        if memoryMeasurements.count > 300 {
            memoryMeasurements.removeFirst()
        }
        
        // Check for memory issues
        checkMemoryPerformance(measurement)
    }
    
    // MARK: - Performance Analysis
    
    private func checkFramePerformance(_ frame: FrameMetric) {
        let fps = 1.0 / frame.duration
        
        // Alert for dropped frames
        if fps < 45.0 && frameMetrics.count > 10 {
            let recentFPS = calculateRecentFPS()
            if recentFPS < 50.0 {
                addAlert(.frameDrops, severity: .medium, message: "FPS dropped to \(String(format: "%.1f", recentFPS))")
            }
        }
        
        // Alert for severe jank
        if frame.duration > 0.033 { // >33ms = severe jank
            addAlert(.severeJank, severity: .high, message: "Severe frame jank: \(String(format: "%.1f", frame.duration * 1000))ms")
        }
    }
    
    private func checkMemoryPerformance(_ measurement: MemoryMeasurement) {
        // Alert for high memory usage
        if measurement.memoryMB > 150.0 {
            addAlert(.highMemoryUsage, severity: .medium, message: "Memory usage: \(String(format: "%.0f", measurement.memoryMB))MB")
        }
        
        // Alert for memory leaks
        if memoryMeasurements.count >= 60 { // 1 minute of data
            let memoryTrend = calculateMemoryTrend()
            if memoryTrend > 5.0 { // >5MB increase per minute
                addAlert(.memoryLeak, severity: .high, message: "Potential memory leak: +\(String(format: "%.1f", memoryTrend))MB/min")
            }
        }
        
        // Alert for high CPU usage
        if measurement.cpuPercent > 70.0 {
            addAlert(.highCPUUsage, severity: .medium, message: "CPU usage: \(String(format: "%.1f", measurement.cpuPercent))%")
        }
    }
    
    private func checkInteractionPerformance(_ interaction: UserInteractionType, startTime: Double) {
        let responseTime = (CACurrentMediaTime() - startTime) * 1000 // Convert to ms
        
        let threshold = interaction.performanceThreshold
        if responseTime > threshold {
            addAlert(.slowInteraction, severity: .medium, 
                    message: "\(interaction.rawValue) response: \(String(format: "%.0f", responseTime))ms (target: \(String(format: "%.0f", threshold))ms)")
        }
    }
    
    // MARK: - Metrics Calculation
    
    private func updateCurrentMetrics() {
        currentMetrics = RealtimeMetrics(
            fps: calculateRecentFPS(),
            memoryMB: memoryMeasurements.last?.memoryMB ?? 0,
            cpuPercent: memoryMeasurements.last?.cpuPercent ?? 0,
            frameJankPercent: calculateJankPercentage(),
            sessionDuration: sessionStartTime?.timeIntervalSinceNow.magnitude ?? 0,
            alertCount: performanceAlerts.count
        )
    }
    
    private func calculateRecentFPS() -> Double {
        guard frameMetrics.count >= 10 else { return 60.0 }
        
        let recentFrames = Array(frameMetrics.suffix(60)) // Last 1 second
        let avgDuration = recentFrames.map { $0.duration }.reduce(0, +) / Double(recentFrames.count)
        
        return 1.0 / avgDuration
    }
    
    private func calculateJankPercentage() -> Double {
        guard frameMetrics.count >= 10 else { return 0.0 }
        
        let recentFrames = Array(frameMetrics.suffix(60))
        let jankFrames = recentFrames.filter { $0.duration > 0.0167 }.count // >16.67ms
        
        return Double(jankFrames) / Double(recentFrames.count) * 100.0
    }
    
    private func calculateMemoryTrend() -> Double {
        guard memoryMeasurements.count >= 60 else { return 0.0 }
        
        let recent60 = Array(memoryMeasurements.suffix(60))
        let first20Avg = Array(recent60.prefix(20)).map { $0.memoryMB }.reduce(0, +) / 20.0
        let last20Avg = Array(recent60.suffix(20)).map { $0.memoryMB }.reduce(0, +) / 20.0
        
        return last20Avg - first20Avg
    }
    
    // MARK: - Alert Management
    
    private func addAlert(_ type: AlertType, severity: AlertSeverity, message: String) {
        // Prevent duplicate alerts within 10 seconds
        let now = Date()
        let recentAlerts = performanceAlerts.filter { 
            now.timeIntervalSince($0.timestamp) < 10.0 && $0.type == type 
        }
        
        if recentAlerts.isEmpty {
            let alert = PerformanceAlert(
                type: type,
                severity: severity,
                message: message,
                timestamp: now
            )
            
            performanceAlerts.append(alert)
            logger.warning("⚠️ Performance alert: \(message)")
            
            // Keep only last 20 alerts
            if performanceAlerts.count > 20 {
                performanceAlerts.removeFirst()
            }
        }
    }
    
    // MARK: - Session Report Generation
    
    private func generateSessionReport() {
        guard let startTime = sessionStartTime else { return }
        
        let duration = Date().timeIntervalSince(startTime)
        let avgFPS = frameMetrics.isEmpty ? 60.0 : frameMetrics.map { 1.0 / $0.duration }.reduce(0, +) / Double(frameMetrics.count)
        let maxMemory = memoryMeasurements.map { $0.memoryMB }.max() ?? 0
        let avgCPU = memoryMeasurements.isEmpty ? 0.0 : memoryMeasurements.map { $0.cpuPercent }.reduce(0, +) / Double(memoryMeasurements.count)
        
        sessionReport = PerformanceSessionReport(
            sessionDuration: duration,
            averageFPS: avgFPS,
            maxMemoryMB: maxMemory,
            averageCPU: avgCPU,
            totalFrames: frameMetrics.count,
            jankFrames: frameMetrics.filter { $0.duration > 0.0167 }.count,
            alertsGenerated: performanceAlerts.count,
            performanceGrade: calculateOverallGrade(avgFPS: avgFPS, maxMemory: maxMemory, avgCPU: avgCPU)
        )
        
        logger.info("📊 Session report generated: \(self.sessionReport?.performanceGrade.rawValue ?? "Unknown") grade")
    }
    
    private func calculateOverallGrade(avgFPS: Double, maxMemory: Double, avgCPU: Double) -> PerformanceGrade {
        var score = 0.0
        
        // FPS Score (40% weight)
        if avgFPS >= 55.0 { score += 40 }
        else if avgFPS >= 45.0 { score += 30 }
        else if avgFPS >= 30.0 { score += 20 }
        else { score += 10 }
        
        // Memory Score (30% weight)
        if maxMemory <= 100.0 { score += 30 }
        else if maxMemory <= 150.0 { score += 20 }
        else if maxMemory <= 200.0 { score += 15 }
        else { score += 5 }
        
        // CPU Score (30% weight)
        if avgCPU <= 20.0 { score += 30 }
        else if avgCPU <= 40.0 { score += 20 }
        else if avgCPU <= 60.0 { score += 15 }
        else { score += 5 }
        
        if score >= 85 { return .excellent }
        else if score >= 65 { return .good }
        else if score >= 45 { return .fair }
        else { return .poor }
    }
    
    // MARK: - System Metrics
    
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
        
        guard totalTicks > 0 else { return 0.0 }
        return Double(totalTicks - idleTicks) / Double(totalTicks) * 100.0
    }
    
    // MARK: - Cleanup
    
    private func cleanupMonitoring() {
        displayLink?.invalidate()
        displayLink = nil
        
        monitoringTimer?.invalidate()
        monitoringTimer = nil
    }
    
    deinit {
        // Cleanup is handled by stopMonitoring() which should be called before deallocation
        // Timer cleanup must be done from MainActor context
    }
}

// MARK: - Data Models

public struct RealtimeMetrics {
    let fps: Double
    let memoryMB: Double
    let cpuPercent: Double
    let frameJankPercent: Double
    let sessionDuration: TimeInterval
    let alertCount: Int
    
    init() {
        self.fps = 60.0
        self.memoryMB = 0.0
        self.cpuPercent = 0.0
        self.frameJankPercent = 0.0
        self.sessionDuration = 0.0
        self.alertCount = 0
    }
    
    init(fps: Double, memoryMB: Double, cpuPercent: Double, frameJankPercent: Double, sessionDuration: TimeInterval, alertCount: Int) {
        self.fps = fps
        self.memoryMB = memoryMB
        self.cpuPercent = cpuPercent
        self.frameJankPercent = frameJankPercent
        self.sessionDuration = sessionDuration
        self.alertCount = alertCount
    }
}

public struct PerformanceAlert {
    let type: AlertType
    let severity: AlertSeverity
    let message: String
    let timestamp: Date
}

public struct PerformanceSessionReport {
    let sessionDuration: TimeInterval
    let averageFPS: Double
    let maxMemoryMB: Double
    let averageCPU: Double
    let totalFrames: Int
    let jankFrames: Int
    let alertsGenerated: Int
    let performanceGrade: PerformanceGrade
}

private struct FrameMetric {
    let timestamp: Double
    let duration: Double
    let targetDuration: Double
}

private struct MemoryMeasurement {
    let timestamp: Date
    let memoryMB: Double
    let cpuPercent: Double
}

// MARK: - Enums

public enum UserInteractionType: String, CaseIterable {
    case cardTap = "Card Tap"
    case navigation = "Navigation"
    case buttonPress = "Button Press"
    case search = "Search"
    case scrolling = "Scrolling"
    case protocolStart = "Protocol Start"
    case tabSwitch = "Tab Switch"
    
    var performanceThreshold: Double {
        switch self {
        case .cardTap, .buttonPress: return 100.0 // 100ms
        case .navigation: return 300.0 // 300ms
        case .search: return 150.0 // 150ms
        case .scrolling: return 16.67 // 60fps = 16.67ms
        case .protocolStart: return 500.0 // 500ms
        case .tabSwitch: return 200.0 // 200ms
        }
    }
}

public enum AlertType: String {
    case frameDrops = "Frame Drops"
    case severeJank = "Severe Jank"
    case highMemoryUsage = "High Memory"
    case memoryLeak = "Memory Leak"
    case highCPUUsage = "High CPU"
    case slowInteraction = "Slow Interaction"
}

public enum AlertSeverity: String {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case critical = "Critical"
}

public enum PerformanceGrade: String {
    case excellent = "Excellent"
    case good = "Good"
    case fair = "Fair"
    case poor = "Poor"
    
    var color: Color {
        switch self {
        case .excellent: return .green
        case .good: return .blue
        case .fair: return .orange
        case .poor: return .red
        }
    }
}

// MARK: - Advanced Performance Monitor View

public struct AdvancedPerformanceMonitorView: View {
    @StateObject private var monitor = AdvancedPerformanceMonitorManager()
    @Environment(\.dismiss) private var dismiss
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header Status
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Advanced Performance Monitor")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("Real-time production monitoring")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        Circle()
                            .fill(monitor.isMonitoring ? .green : .red)
                            .frame(width: 12, height: 12)
                            .animation(.easeInOut, value: monitor.isMonitoring)
                    }
                    .padding(.horizontal)
                    
                    // Real-time Metrics
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                        MetricTile(
                            title: "FPS",
                            value: String(format: "%.1f", monitor.currentMetrics.fps),
                            subtitle: "Current",
                            color: monitor.currentMetrics.fps >= 55 ? .green : .orange,
                            icon: "speedometer"
                        )
                        
                        MetricTile(
                            title: "Memory",
                            value: String(format: "%.0f MB", monitor.currentMetrics.memoryMB),
                            subtitle: "Usage",
                            color: monitor.currentMetrics.memoryMB <= 100 ? .green : .orange,
                            icon: "memorychip"
                        )
                        
                        MetricTile(
                            title: "CPU",
                            value: String(format: "%.1f%%", monitor.currentMetrics.cpuPercent),
                            subtitle: "Usage",
                            color: monitor.currentMetrics.cpuPercent <= 30 ? .green : .orange,
                            icon: "cpu"
                        )
                        
                        MetricTile(
                            title: "Jank",
                            value: String(format: "%.1f%%", monitor.currentMetrics.frameJankPercent),
                            subtitle: "Frame drops",
                            color: monitor.currentMetrics.frameJankPercent <= 5 ? .green : .red,
                            icon: "exclamationmark.triangle"
                        )
                    }
                    .padding(.horizontal)
                    
                    // Performance Alerts
                    if !monitor.performanceAlerts.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Recent Alerts")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            ForEach(Array(monitor.performanceAlerts.suffix(5).enumerated()), id: \.offset) { index, alert in
                                AlertRow(alert: alert)
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                    
                    // Session Report
                    if let report = monitor.sessionReport {
                        SessionReportView(report: report)
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Performance")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") { dismiss() }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(monitor.isMonitoring ? "Stop" : "Start") {
                        if monitor.isMonitoring {
                            monitor.stopMonitoring()
                        } else {
                            monitor.startMonitoring()
                        }
                    }
                    .foregroundStyle(monitor.isMonitoring ? .red : .green)
                }
            }
        }
        .onAppear {
            monitor.startMonitoring()
        }
        .onDisappear {
            monitor.stopMonitoring()
        }
    }
}

// MARK: - Supporting Views

struct MetricTile: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(color)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(color)
                
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text(subtitle)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct AlertRow: View {
    let alert: PerformanceAlert
    
    var body: some View {
        HStack {
            Image(systemName: severityIcon)
                .foregroundStyle(severityColor)
                .font(.system(size: 14))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(alert.type.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                
                Text(alert.message)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text(timeAgo)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
    
    private var severityIcon: String {
        switch alert.severity {
        case .low: return "info.circle"
        case .medium: return "exclamationmark.triangle"
        case .high: return "exclamationmark.triangle.fill"
        case .critical: return "exclamationmark.circle.fill"
        }
    }
    
    private var severityColor: Color {
        switch alert.severity {
        case .low: return .blue
        case .medium: return .orange
        case .high: return .red
        case .critical: return .red
        }
    }
    
    private var timeAgo: String {
        let interval = Date().timeIntervalSince(alert.timestamp)
        if interval < 60 { return "\(Int(interval))s ago" }
        else { return "\(Int(interval / 60))m ago" }
    }
}

struct SessionReportView: View {
    let report: PerformanceSessionReport
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Session Report")
                .font(.headline)
            
            VStack(spacing: 8) {
                HStack {
                    Text("Overall Grade:")
                    Spacer()
                    Text(report.performanceGrade.rawValue)
                        .fontWeight(.semibold)
                        .foregroundStyle(report.performanceGrade.color)
                }
                
                HStack {
                    Text("Session Duration:")
                    Spacer()
                    Text(formatDuration(report.sessionDuration))
                }
                
                HStack {
                    Text("Average FPS:")
                    Spacer()
                    Text(String(format: "%.1f", report.averageFPS))
                }
                
                HStack {
                    Text("Peak Memory:")
                    Spacer()
                    Text(String(format: "%.0f MB", report.maxMemoryMB))
                }
                
                HStack {
                    Text("Jank Frames:")
                    Spacer()
                    Text("\(report.jankFrames)/\(report.totalFrames) (\(String(format: "%.1f", Double(report.jankFrames) / Double(report.totalFrames) * 100))%)")
                }
            }
            .font(.caption)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}