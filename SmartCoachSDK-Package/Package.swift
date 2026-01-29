// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SmartCoachSDK",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "SmartCoachSDK",
            targets: ["SmartCoachSDK", "SmartCoachSDKDocumentation"]
        ),
    ],
    targets: [
        // Binary target - your XCFramework
        .binaryTarget(
            name: "SmartCoachSDK",
            path: "SmartCoachSDK.xcframework"
        ),
        
        // Documentation-only target
        .target(
            name: "SmartCoachSDKDocumentation",
            path: "Sources/SmartCoachSDK"
        ),
    ]
)
