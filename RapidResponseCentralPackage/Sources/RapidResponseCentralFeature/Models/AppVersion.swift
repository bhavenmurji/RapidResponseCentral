import Foundation

// MARK: - App Version Management

public struct AppVersion: Hashable, Sendable {
    public static let current = AppVersion(
        major: 2,
        minor: 1,
        patch: 0,
        build: buildNumber
    )
    
    public let major: Int
    public let minor: Int
    public let patch: Int
    public let build: String
    
    public var versionString: String {
        "\(major).\(minor).\(patch)"
    }
    
    public var fullVersionString: String {
        "\(versionString) (\(build))"
    }
    
    public var displayString: String {
        "v\(versionString)"
    }
    
    // Build number based on current timestamp for uniqueness
    private static var buildNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmm"
        return formatter.string(from: Date())
    }
    
    public init(major: Int, minor: Int, patch: Int, build: String) {
        self.major = major
        self.minor = minor
        self.patch = patch
        self.build = build
    }
}

// MARK: - Version History

public struct VersionHistory {
    public static let releaseNotes: [AppVersion: [String]] = [
        AppVersion(major: 2, minor: 1, patch: 0, build: "202507301833"): [
            "🎯 Complete protocol implementation with all Emergency, RRT, Calls, and Labs protocols",
            "🎨 Replaced emoji icons with professional Boxicons for better visual consistency",
            "⚡ Enhanced async loading with improved performance and crash prevention",
            "🔄 Added comprehensive version tracking and build management",
            "📱 Optimized UI for better navigation and protocol access",
            "🩺 Added 20+ new clinical protocols across all categories"
        ],
        AppVersion(major: 2, minor: 0, patch: 1, build: "202507301800"): [
            "🚑 Initial RRT protocols implementation (7 protocols)",
            "🔧 Fixed async loading crash on app launch",
            "📝 Added search functionality for RRT protocols",
            "💾 Implemented Git version control and backup system"
        ],
        AppVersion(major: 2, minor: 0, patch: 0, build: "202507301200"): [
            "🚀 Initial release with basic app structure",
            "📱 7-tab navigation implementation",
            "🔲 Placeholder views for future modules"
        ]
    ]
    
    public static func releaseNotesFor(version: AppVersion) -> [String] {
        // Find matching version (ignoring build number for lookup)
        let matchingVersion = releaseNotes.keys.first { versionKey in
            versionKey.major == version.major &&
            versionKey.minor == version.minor &&
            versionKey.patch == version.patch
        }
        
        return matchingVersion.map { releaseNotes[$0] ?? [] } ?? []
    }
}

// MARK: - Feature Flags

public struct FeatureFlags {
    public static let enableMEDataChat = false
    public static let enableStudyModule = false
    public static let enableBoxicons = true
    public static let enableAdvancedProtocols = true
    public static let enablePerformanceMetrics = true
    
    // Protocol feature flags
    public static let enableEmergencyProtocols = true
    public static let enableRRTProtocols = true
    public static let enableCallsProtocols = true
    public static let enableLabsProtocols = true
    public static let enableCalculators = true
}