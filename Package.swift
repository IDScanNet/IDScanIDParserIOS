// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IDScanIDParser",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "IDScanIDParser",
            targets: ["IDScanIDParser"]),
    ],
    targets: [
        .target(
            name: "IDScanIDParser",
            dependencies: [
                "IDScanIDParserNative"
            ],
            path: "Sources"),
        .binaryTarget(
            name: "IDScanIDParserNative",
            path: "Libs/IDScanIDParserNative.xcframework"
        ),
        .testTarget(
            name: "IDParserTests",
            dependencies: ["IDScanIDParser", "IDScanIDParserNative"]
        )
    ]
)
