// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LastFMKit",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v9)
    ],
    products: [
        .library(
            name: "LastFMKit",
            targets: ["LastFMKit"]),
        .executable(
            name: "lastfm-cli",
            targets: ["LastFMCLI"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
        .package(url: "https://github.com/apple/swift-log", from: "1.5.0"),
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.3.0")
    ],
    targets: [
        .target(
            name: "LastFMKit",
            dependencies: [
                .product(name: "Logging", package: "swift-log")
            ]),
        .executableTarget(
            name: "LastFMCLI",
            dependencies: [
                "LastFMKit",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]),
        .testTarget(
            name: "LastFMKitTests",
            dependencies: ["LastFMKit"],
            resources: [
                .process("Resources")
            ])
    ]
)