// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Pylon",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "Pylon",
            targets: ["Pylon"]
        ),
    ],
    targets: [
        
        .target(
            name: "Pylon",
            path: "Sources/Pylon"
        ),
    ]
)
