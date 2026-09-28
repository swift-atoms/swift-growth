import Growth
import Ratio
import Cardinal
import Tagged
import Testing

@Suite struct `Growth Checked Factor Migration Tests` {
    @Test
    func `factor scales current capacity`() throws {
        let scale = Ratio<UInt8, UInt8>(3)
        let policy = try Growth.Policy<UInt8>.factor(scale)
        let count = Tagged<UInt8, Cardinal>(_unchecked: Cardinal(UInt(4)))
        #expect(try policy.capacity(from: count).underlying.rawValue == UInt(12))
    }

    @Test
    func `factor floors capacity at one`() throws {
        let scale = Ratio<UInt8, UInt8>(3)
        let policy = try Growth.Policy<UInt8>.factor(scale)
        let count = Tagged<UInt8, Cardinal>(_unchecked: Cardinal(UInt(0)))
        #expect(try policy.capacity(from: count).underlying.rawValue == UInt(1))
    }

    @Test
    func `zero factor is rejected rather than resetting capacity`() {
        let scale = Ratio<UInt8, UInt8>.zero
        #expect(throws: Growth.Policy<UInt8>.Error.invalidFactor(scale)) {
            try Growth.Policy<UInt8>.factor(scale)
        }
    }
}
