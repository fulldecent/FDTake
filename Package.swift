// swift-tools-version: 6.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FDTake",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "FDTake",
            targets: ["FDTake"]
        )
    ],
    targets: [
        .target(
            name: "FDTake",
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ]
        ),
        .testTarget(
            name: "FDTakeTests",
            dependencies: ["FDTake"],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ]
        )
    ]
)
