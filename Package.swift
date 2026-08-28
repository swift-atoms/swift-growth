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
            name: "Growth Test Support",
            targets: ["Growth Test Support"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-molecules/swift-index.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-affine.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-memory.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "Growth",
            dependencies: [
                .product(name: "Index", package: "swift-index"),
                .product(name: "Affine", package: "swift-affine"),
                .product(name: "Memory Alignment", package: "swift-memory"),
                .product(
                    name: "Memory Standard Library Integration",
                    package: "swift-memory"
                ),
            ]
        ),
        .target(
            name: "Growth Test Support",
            dependencies: [
                "Growth",
                .product(name: "Index Test Support", package: "swift-index"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Growth Tests",
            dependencies: [
                "Growth",
                "Growth Test Support",
                .product(name: "Memory Alignment", package: "swift-memory"),
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
