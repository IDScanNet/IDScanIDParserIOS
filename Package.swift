// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IDScanIDParser",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(
            name: "IDScanPDFParser",
            targets: ["IDScanPDFParser"]),
        .library(
            name: "IDScanMRZParser",
            targets: ["IDScanMRZParser"]),
    ],
    targets: [
        .binaryTarget(
            name: "IDScanPDFParser",
            path: "Libs/IDScanPDFParser.xcframework"
        ),
        .binaryTarget(
            name: "IDScanMRZParser",
            path: "Libs/IDScanMRZParser.xcframework"
        ),
        .testTarget(
            name: "IDScanIDParserTests",
            dependencies: [
                "IDScanPDFParser",
                "IDScanMRZParser"
            ]
        ),
    ]
)
