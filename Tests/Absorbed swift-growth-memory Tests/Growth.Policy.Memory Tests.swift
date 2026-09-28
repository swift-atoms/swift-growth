#if Memory
import Growth
import Testing

@Suite
struct `Paged growth preserves capacity and alignment` {
    private typealias Policy = Growth.Policy<UInt8>

    @Test(arguments: [1, 2, 4, 16, 512, 4096])
    func `paged capacities round upward to the least aligned positive count`(_ magnitude: Int) throws {
        let alignment = try Memory.Alignment(magnitude)
        let policy = Policy.paged(alignment)
        for value: UInt in [0, 1, UInt(magnitude), UInt(magnitude) + 1, UInt(magnitude) * 3 - 1] {
            let capacity = try policy.capacity(from: .init(Cardinal(value)))
            let result = capacity.underlying.rawValue
            #expect(result >= max(value, 1))
            #expect(alignment.isAligned(result))
            #expect(result - max(value, 1) < UInt(magnitude))
        }
    }

    @Test
    func `byte paging preserves the largest unsigned count`() throws {
        let capacity = try Policy.paged(.byte).capacity(from: .init(Cardinal(UInt.max)))
        #expect(capacity.underlying.rawValue == UInt.max)
    }

    @Test(arguments: [2, 4, 16, 512, 4096])
    func `paged growth accepts the last aligned capacity and rejects wrapping`(_ magnitude: Int) throws {
        let alignment = try Memory.Alignment(magnitude)
        let policy = Policy.paged(alignment)
        let last = UInt.max - UInt(magnitude - 1)
        let capacity = try policy.capacity(from: .init(Cardinal(last)))
        #expect(capacity.underlying.rawValue == last)
        #expect(throws: Policy.Error.overflow) {
            _ = try policy.capacity(from: .init(Cardinal(last + 1)))
        }
        #expect(throws: Policy.Error.overflow) {
            _ = try policy.capacity(from: .init(Cardinal(UInt.max)))
        }
        let next = try policy.capacity(from: .one)
        #expect(next.underlying.rawValue == UInt(magnitude))
    }

    @Test
    func `paging rounds element counts without introducing a byte stride conversion`() throws {
        let policy = Growth.Policy<UInt64>.paged(.`16`)
        let capacity = try policy.capacity(from: 17)
        #expect(capacity == 32)
    }

    @Test
    func `paging supports noncopyable element domains`() throws {
        struct Element: ~Copyable {}
        let policy = Growth.Policy<Element>.paged(.`8`)
        let capacity = try policy.capacity(from: 9)
        #expect(capacity == 16)
    }
}
#endif
