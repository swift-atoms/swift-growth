public import Ratio
public import Cardinal
public import Tagged

extension Growth {

    public struct Policy<Element: ~Copyable>: Sendable {
        public typealias Count = Tagged::Tagged<Element, Cardinal::Cardinal>

        @usableFromInline
        let _apply: @Sendable (Count) throws(Error) -> Count

        @inlinable
        package init(
            apply: @escaping @Sendable (Count) throws(Error) -> Count
        ) {
            self._apply = apply
        }
    }
}

extension Growth.Policy where Element: ~Copyable {

    @inlinable
    public func capacity(from current: Count) throws(Error) -> Count {
        let proposed = try _apply(current)
        guard proposed >= current else {
            throw .wouldShrink(current: current, proposed: proposed)
        }
        return proposed
    }

    @inlinable
    public static func custom(
        _ apply: @escaping @Sendable (Count) throws(Error) -> Count
    ) -> Self {
        Self(apply: apply)
    }
}

extension Growth.Policy where Element: ~Copyable {

    @inlinable
    public static var doubling: Self {
        Self { current throws(Error) in
            do throws(Cardinal.Error) {
                return Count.max(Count(try current.underlying.add.exact(current.underlying)), .one)
            } catch {
                throw .overflow
            }
        }
    }

    @inlinable
    public static func factor(
        _ scale: Ratio<Element, Element>
    ) throws(Error) -> Self {
        guard scale.value >= .one else { throw .invalidFactor(scale) }
        return Self { current throws(Error) in
            do throws(Ratio<Element, Element>.Error) {
                return Count.max(try scale.applying(to: current), .one)
            } catch {
                throw .scaling(error)
            }
        }
    }

    @inlinable
    public static var exact: Self {
        Self { $0 }
    }
}
