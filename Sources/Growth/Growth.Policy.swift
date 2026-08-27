@_exported public import Cardinal

extension Growth {

    public struct Policy<Element: ~Copyable>: Sendable {
        @usableFromInline
        let _apply: @Sendable (Cardinal) -> Cardinal

        @inlinable
        package init(
            apply: @escaping @Sendable (Cardinal) -> Cardinal
        ) {
            self._apply = apply
        }
    }
}

extension Growth.Policy where Element: ~Copyable {

    @inlinable
    public func capacity(from current: Cardinal) -> Cardinal {
        _apply(current)
    }
}

extension Growth.Policy where Element: ~Copyable {

    /// Creates a policy from a caller-owned capacity strategy.
    ///
    /// The strategy receives the current capacity and returns the next capacity.
    @inlinable
    public static func custom(
        capacity: @escaping @Sendable (Cardinal) -> Cardinal
    ) -> Self {
        Self(apply: capacity)
    }

    @inlinable
    public static var doubling: Self {
        Self { $0 == Cardinal(0) ? Cardinal(1) : $0 + $0 }
    }

    @inlinable
    public static var exact: Self {
        Self { $0 }
    }
}
