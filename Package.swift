// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "PieCharts",
    platforms: [
        .iOS(.v8),
    ],
    products: [
        .library(name: "PieCharts",
                 targets: ["PieCharts"]),
    ],
    targets: [
        .target(name: "PieCharts",
                dependencies: []),
    ]
)
