// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "FDTake",
    platforms: [.iOS(.v10)],
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
