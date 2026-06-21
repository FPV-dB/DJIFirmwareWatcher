// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "DJIFirmwareWatcher",
    platforms: [.macOS(.v14)],
    products: [
        .executable(name: "DJIFirmwareWatcher", targets: ["DJIFirmwareWatcher"]),
        .library(name: "DJIFirmwareWatcherCore", targets: ["DJIFirmwareWatcherCore"])
    ],
    targets: [
        .target(name: "DJIFirmwareWatcherCore"),
        .executableTarget(
            name: "DJIFirmwareWatcher",
            dependencies: ["DJIFirmwareWatcherCore"]
        ),
        .testTarget(
            name: "DJIFirmwareWatcherCoreTests",
            dependencies: ["DJIFirmwareWatcherCore"]
        )
    ]
)
