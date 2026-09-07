import Growth_Test_Support
import Testing

@Suite
struct `Growth policies preserve capacity and report failure` {
    private typealias Policy = Growth.Policy<UInt8>

    @Test
    func `doubling bootstraps zero and doubles ordinary capacities`() throws {
        let zero = try Policy.doubling.capacity(from: .zero)
        let four = try Policy.doubling.capacity(from: 4)
        #expect(zero == .one)
        #expect(four == 8)
    }

    @Test
    func `doubling accepts its last representable result and rejects the next input`() throws {
        let last = UInt.max / 2
        let capacity = try Policy.doubling.capacity(from: .init(Cardinal(last)))
        #expect(capacity.underlying.rawValue == UInt.max - 1)
        #expect(throws: Policy.Error.overflow) {
            _ = try Policy.doubling.capacity(from: .init(Cardinal(last + 1)))
        }
        #expect(throws: Policy.Error.overflow) {
            _ = try Policy.doubling.capacity(from: .init(Cardinal(UInt.max)))
        }
        let subsequent = try Policy.doubling.capacity(from: 4)
        #expect(subsequent == 8)
    }

    @Test(arguments: [UInt(0), 1, UInt(Int.max), UInt.max])
    func `exact policies preserve the entire unsigned count domain`(_ value: UInt) throws {
        let capacity = try Policy.exact.capacity(from: .init(Cardinal(value)))
        #expect(capacity.underlying.rawValue == value)
    }

    @Test
    func `factors preserve exact scaling and the zero bootstrap`() throws {
        let policy = try Policy.factor(.init(numerator: 3, denominator: 2))
        let capacity = try policy.capacity(from: 4)
        let zero = try policy.capacity(from: .zero)
        #expect(capacity == 6)
        #expect(zero == .one)
    }

    @Test
    func `fractional results preserve the nested ratio error instead of rounding`() throws {
        let policy = try Policy.factor(.init(numerator: 3, denominator: 2))
        #expect(throws: Policy.Error.scaling(.inexact)) {
            _ = try policy.capacity(from: 3)
        }
        let next = try policy.capacity(from: 6)
        #expect(next == 9)
    }

    @Test
    func `identity scaling retains the largest unsigned capacity exactly`() throws {
        let policy = try Policy.factor(.identity)
        let capacity = try policy.capacity(from: .init(Cardinal(UInt.max)))
        #expect(capacity.underlying.rawValue == UInt.max)
    }

    @Test
    func `unrepresentable scaled results preserve the ratio overflow domain`() throws {
        let policy = try Policy.factor(.init(numerator: UInt128(UInt.max)))
        let last = try policy.capacity(from: .one)
        #expect(last.underlying.rawValue == UInt.max)
        #expect(throws: Policy.Error.scaling(.overflow)) {
            _ = try policy.capacity(from: 2)
        }
    }

    @Test
    func `factor construction rejects negative zero and subunit scales`() throws {
        let scales: [Ratio<UInt8, UInt8>] = [Ratio(-1), .zero, try .init(numerator: 1, denominator: 2)]
        for scale in scales {
            #expect(throws: Policy.Error.invalidFactor(scale)) {
                _ = try Policy.factor(scale)
            }
        }
    }

    @Test
    func `custom proposals cannot shrink the current capacity`() throws {
        let policy = Policy.custom { _ in .one }
        #expect(throws: Policy.Error.wouldShrink(current: 8, proposed: 1)) {
            _ = try policy.capacity(from: 8)
        }
        let zero = try policy.capacity(from: .zero)
        let one = try policy.capacity(from: .one)
        #expect(zero == .one && one == .one)
    }

    @Test
    func `custom policies propagate their typed errors unchanged`() {
        let expected = Policy.Error.scaling(.unrepresentable)
        let policy = Policy.custom { _ throws(Policy.Error) in throw expected }
        #expect(throws: expected) {
            _ = try policy.capacity(from: 4)
        }
    }

    @Test
    func `custom nonshrinking policies support noncopyable element domains`() throws {
        struct Element: ~Copyable {}
        let policy = Growth.Policy<Element>.custom { $0 }
        let capacity = try policy.capacity(from: 17)
        #expect(capacity == 17)
    }

    @Test
    func `checked policies can be evaluated in another task`() async throws {
        let policy = try Policy.factor(.init(numerator: 3, denominator: 2))
        let capacity = try await Task.detached { try policy.capacity(from: 8) }.value
        #expect(capacity == 12)
    }
}
