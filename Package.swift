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
        .library(name: "Growth", targets: ["Growth"]),

        .library(name: "Growth Foundation Integration", targets: ["Growth Foundation Integration"]),
        .library(name: "Growth Test Support", targets: ["Growth Test Support"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-atoms/swift-cardinal.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-ratio.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-tagged.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "Growth",
            dependencies: [
                .product(name: "Ratio", package: "swift-ratio"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Tagged", package: "swift-tagged"),
            ],
            path: "Sources/Growth"
        ),
        
        .target(
            name: "Growth Foundation Integration",
            dependencies: [
                .target(name: "Growth"),
            ],
            path: "Sources/Growth Foundation Integration"
        ),
        .target(
            name: "Growth Test Support",
            dependencies: [
                .target(name: "Growth"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Growth Tests",
            dependencies: [
                .product(name: "Ratio", package: "swift-ratio"),
                .target(name: "Growth"),
                .target(name: "Growth Test Support"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Tagged", package: "swift-tagged"),
                .target(name: "Growth Foundation Integration"),
            ],
            path: "Tests/Growth Tests"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets {
    target.swiftSettings = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableExperimentalFeature("RawLayout"),
    ]
}
