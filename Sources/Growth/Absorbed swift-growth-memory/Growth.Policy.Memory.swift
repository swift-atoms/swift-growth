#if Memory
public import Memory

extension Growth.Policy where Element: ~Copyable {

    @inlinable
    public static func paged(_ alignment: Memory.Alignment) -> Self {
        .custom { current throws(Error) in
            let minimum = current == .zero ? Count.one : current
            let rounded = alignment.alignUp(minimum.underlying.rawValue)
            guard rounded >= minimum.underlying.rawValue else { throw .overflow }
            return Count(Cardinal(rounded))
        }
    }
}
#endif
