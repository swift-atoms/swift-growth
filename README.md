# Growth

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Pluggable capacity-growth strategies for owned, resizable regions and buffers — a `Growth` namespace of growth policies (doubling, exact, factor, page-aligned) and a `Growth.Growable` marker for leaves whose backing can grow.

---

## Quick Start

A resizable buffer that runs out of room consults a `Growth.Policy` to decide how large its backing should become. The policy is the *strategy*; the buffer is the *mechanism*. Capacities are typed as `Index<Element>.Count`, re-exported from `Index`, so the count carries its element type in the signature.

```swift
import Growth

// Doubling gives amortized O(1) appends: each growth doubles the capacity.
let policy = Growth.Policy<UInt8>.doubling

let current: Index<UInt8>.Count = 4
let next = policy.newCapacity(from: current)   // 8 — doubled

// At zero capacity, doubling floors at one element.
let firstGrowth = policy.newCapacity(from: 0)  // 1
```

Each leaf picks the strategy that fits its access pattern:

```swift
import Growth

// Exact: grow to precisely what was requested, with no slack.
Growth.Policy<UInt8>.exact.newCapacity(from: 16)        // 16

// Doubling: trade memory for amortized-constant growth.
Growth.Policy<UInt8>.doubling.newCapacity(from: 16)     // 32
```

`pageAligned` rounds the new capacity up to an alignment boundary, drawing `Memory.Alignment` from `Memory Alignment`:

```swift
import Growth
import Memory_Alignment

let policy = try Growth.Policy<UInt8>.pageAligned(Memory.Alignment(16))
policy.newCapacity(from: 17)   // 32 — next multiple of 16
policy.newCapacity(from: 0)    // 16 — zero rounds up to one, then to 16
```

A growable leaf composes both halves: it conforms `Growth.Growable` (it *can* grow) and holds a `Growth.Policy` (it knows *how fast*). The marker is signalled by conformance presence alone, so a fixed or bounded leaf is simply one that does not conform `Growth.Growable`.

---

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-molecules/swift-growth.git", branch: "main")
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

Requires Swift 6.3.1 and macOS 26 / iOS 26 / tvOS 26 / watchOS 26 / visionOS 26 (or the matching Linux / Windows toolchain).

---

## Architecture

Two library products. Depends only on `Index`, `Affine`, and `Memory.Alignment`.

| Product | Target | Purpose |
|---------|--------|---------|
| `Growth` | `Sources/Growth/` | The `Growth` namespace: `Growth.Policy<Element>` with the `doubling`, `exact`, `factor`, and `pageAligned` strategies, plus the `Growth.Growable` marker protocol. Re-exports `Index`. |
| `Growth Test Support` | `Tests/Support/` | Re-exports the main target for test consumers. |

Foundation-free.

---

## Platform Support

| Platform | Status |
|----------|--------|
| macOS 26 | Full support |
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
