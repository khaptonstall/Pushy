// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Pushy",
    platforms: [
        .macOS(.v10_13),
    ],
    products: [
        .executable(name: "pushy", targets: ["Pushy"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.2"),
    ],
    targets: [
        .executableTarget(
            name: "Pushy",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .testTarget(
            name: "PushyTests",
            dependencies: ["Pushy"]
        ),
    ]
)
