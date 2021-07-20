// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DevKit",
    platforms: [
        .macOS(.v10_11), .iOS(.v9), .watchOS(.v2)
    ],
    products: [
        .library(
            name: "DevKit",
            targets: ["DevKit"]),
    ],
    targets: [
        .target(
            name: "DevKit",
            dependencies: [])
    ]
)
