// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RapidResponseCentralFeature",
    platforms: [
        .iOS(.v18),
        .macOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "RapidResponseCentralFeature",
            targets: ["RapidResponseCentralFeature"]
        ),
    ],
    dependencies: [
        // SwiftFlow package - uncomment when available
        // .package(url: "https://github.com/hlung/SwiftFlow.git", from: "0.1.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "RapidResponseCentralFeature"
            // dependencies: [
            //     .product(name: "SwiftFlow", package: "SwiftFlow")
            // ]
        ),
        .testTarget(
            name: "RapidResponseCentralFeatureTests",
            dependencies: [
                "RapidResponseCentralFeature"
            ]
        ),
    ]
)
