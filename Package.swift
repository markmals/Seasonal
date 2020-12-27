// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Seasonal",
    products: [ .library(name: "Seasonal", targets: ["Seasonal"])],
    targets: [
        .target(name: "Seasonal"),
        .testTarget(name: "SeasonalTests", dependencies: ["Seasonal"])
    ]
)
