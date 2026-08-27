// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-growth",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "Growth",
            targets: ["Growth"]
        ),
        .library(
            name: "Growth Standard Library Integration",
            targets: ["Growth Standard Library Integration"]
        ),
        .library(
            name: "Growth Apple Foundation Integration",
            targets: ["Growth Apple Foundation Integration"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-molecules/swift-index.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "Growth",
            dependencies: [
                .product(name: "Index", package: "swift-index")
            ]
        ),
        .target(
            name: "Growth Standard Library Integration",
            dependencies: ["Growth"]
        ),
        .target(
            name: "Growth Apple Foundation Integration",
            dependencies: [
                "Growth",
                "Growth Standard Library Integration",
            ]
        ),
        .testTarget(
            name: "Growth Tests",
            dependencies: ["Growth"]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = [
        .enableExperimentalFeature("RawLayout")
    ]

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
