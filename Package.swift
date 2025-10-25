// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "IOSDiary",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "IOSDiary",
            targets: ["IOSDiary"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "IOSDiary",
            dependencies: []),
        .testTarget(
            name: "IOSDiaryTests",
            dependencies: ["IOSDiary"]),
    ]
)