public import Ratio
public import Cardinal
public import Index
public import enum Memory.Memory
public import Ordinal
public import Tagged

extension Growth {

    public struct Policy<Element: ~Copyable>: Sendable {
        public typealias Count = Tagged::Tagged<Element, Cardinal::Cardinal>

        @usableFromInline
        let _apply: @Sendable (Count) -> Count

        @inlinable
        package init(
            apply: @escaping @Sendable (Count) -> Count
        ) {
            self._apply = apply
        }
    }
}

extension Growth.Policy where Element: ~Copyable {

    @inlinable
    public func capacity(from current: Count) -> Count {
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
        _ scale: Ratio<Element, Element>
    ) -> Self {
        Self { Count.max($0 * scale, .one) }
    }

    @inlinable
    public static var exact: Self {
        Self { $0 }
    }

    @inlinable
    public static func paged(_ alignment: Memory.Alignment) -> Self {
        Self { current in
            let nonzero = current == .zero ? Count.one : current
            return Count(Cardinal(alignment.alignUp(nonzero.underlying.rawValue)))
        }
    }
}
