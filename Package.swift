// swift-tools-version:5.7

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
    dependencies: [],
    targets: [
        .target(
            name: "FDTake",
            dependencies: []
        ),
        .testTarget(
            name: "FDTakeTests",
            dependencies: ["FDTake"]
        )
    ]
)
