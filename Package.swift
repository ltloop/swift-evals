// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swift-evals",
    platforms: [
        .iOS(.v26),
        .macOS(.v26),
    ],
    products: [
        .library(
            name: "SwiftEvals",
            targets: ["SwiftEvals"]
        ),
    ],
    targets: [
        .target(
            name: "SwiftEvals"
        ),
    ]
)
