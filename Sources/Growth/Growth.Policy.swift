public import Affine
public import Index
public import Memory_Alignment

extension Growth {

    public struct Policy<Element: ~Copyable>: Sendable {
        @usableFromInline
        let _apply: @Sendable (Index<Element>.Count) -> Index<Element>.Count

        @inlinable
        package init(
            apply: @escaping @Sendable (Index<Element>.Count) -> Index<Element>.Count
        ) {
            self._apply = apply
        }
    }
}

extension Growth.Policy where Element: ~Copyable {

    @inlinable
    public func capacity(from current: Index<Element>.Count) -> Index<Element>.Count {
        _apply(current)
    }
}

extension Growth.Policy where Element: ~Copyable {

    @inlinable
    public static var doubling: Self {
        Self { max($0 + $0, .one) }
    }

    @inlinable
    public static func factor(
        _ scale: Affine.Discrete.Ratio<Element, Element>
    ) -> Self {
        Self { Index<Element>.Count.max($0 * scale, .one) }
    }

    @inlinable
    public static var exact: Self {
        Self { $0 }
    }

    @inlinable
    public static func paged(_ alignment: Memory.Alignment) -> Self {
        Self { alignment.align.up($0 == .zero ? .one : $0) }
    }
}
