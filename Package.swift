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
            name: "Growth Apple Foundation Integration",
            targets: ["Growth Apple Foundation Integration"]
        ),
        .library(
            name: "Growth Test Support",
            targets: ["Growth Test Support"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-atoms/swift-cardinal.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "Growth",
            dependencies: [
                .product(name: "Cardinal", package: "swift-cardinal")
            ]
        ),
        .target(
            name: "Growth Apple Foundation Integration",
            dependencies: ["Growth"]
        ),
        .target(
            name: "Growth Test Support",
            dependencies: ["Growth"],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Growth Tests",
            dependencies: [
                "Growth",
                "Growth Test Support",
            ]
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
