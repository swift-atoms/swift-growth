# Growth

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Pluggable capacity-growth strategies for owned, resizable regions and buffers — a `Growth` namespace with doubling and exact policies, plus a `Growth.Growable` marker for leaves whose backing can grow.

---

## Quick Start

A resizable buffer that runs out of room consults a `Growth.Policy` to decide how large its backing should become. The policy is the *strategy*; the buffer is the *mechanism*. Capacities use `Cardinal`, the Institute atom for nonnegative counts.

```swift
import Growth

// Doubling gives amortized O(1) appends: each growth doubles the capacity.
let policy = Growth.Policy<UInt8>.doubling

let current = Cardinal(4)
let next = policy.capacity(from: current)   // 8 — doubled

// At zero capacity, doubling floors at one element.
let firstGrowth = policy.capacity(from: Cardinal(0))  // 1
```

Each leaf picks the strategy that fits its access pattern:

```swift
import Growth

// Exact: grow to precisely what was requested, with no slack.
Growth.Policy<UInt8>.exact.capacity(from: Cardinal(16))        // 16

// Doubling: trade memory for amortized-constant growth.
Growth.Policy<UInt8>.doubling.capacity(from: Cardinal(16))     // 32
```

A growable leaf composes both halves: it conforms `Growth.Growable` (it *can* grow) and holds a `Growth.Policy` (it knows *how fast*). The marker is signalled by conformance presence alone, so a fixed or bounded leaf is simply one that does not conform `Growth.Growable`.

---

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-atoms/swift-growth.git", branch: "main")
]
```

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "Growth", package: "swift-growth"),
    ]
)
```

Requires Swift 6.4 and macOS 27 / iOS 27 / tvOS 27 / watchOS 27 / visionOS 27 (or the matching Linux / Windows toolchain).

---

## Architecture

Three library products. The core depends only on `Cardinal`.

| Product | Target | Purpose |
|---------|--------|---------|
| `Growth` | `Sources/Growth/` | The `Growth` namespace: `Growth.Policy<Element>` with `doubling` and `exact` strategies, plus the `Growth.Growable` marker protocol. Re-exports `Cardinal`. |
| `Growth Apple Foundation Integration` | `Sources/Growth Apple Foundation Integration/` | Re-exports `Growth` and Foundation for Apple-platform consumers. |
| `Growth Test Support` | `Tests/Support/` | Re-exports the main target for test consumers. |

The core and test-support targets are Foundation-free. Foundation is confined to the Apple Foundation integration target.

---

## Platform Support

| Platform | Status |
|----------|--------|
| macOS 27 | Full support |
| Linux | Full support |
| Windows | Full support |
| iOS / tvOS / watchOS / visionOS | Supported |

---

## Community

<!-- BEGIN: discussion -->
<!-- Discussion thread created at publication. -->
<!-- END: discussion -->

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
