import Ratio
import Cardinal
import Growth_Test_Support
import enum Memory.Memory
import Tagged
import Testing

@Suite struct `Growth.Policy Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

extension `Growth.Policy Tests`.Unit {
    @Test
    func `doubling doubles and floors at one`() {
        let policy = Growth.Policy<UInt8>.doubling
        #expect(
            policy.capacity(from: Growth.Policy<UInt8>.Count(Cardinal(4)))
                == Growth.Policy<UInt8>.Count(Cardinal(8))
        )
        #expect(
            policy.capacity(from: Growth.Policy<UInt8>.Count(Cardinal(0)))
                == Growth.Policy<UInt8>.Count(Cardinal(1))
        )
    }

    @Test
    func `exact returns the request unchanged`() {
        let policy = Growth.Policy<UInt8>.exact
        #expect(
            policy.capacity(from: Growth.Policy<UInt8>.Count(Cardinal(16)))
                == Growth.Policy<UInt8>.Count(Cardinal(16))
        )
    }
}

extension `Growth.Policy Tests`.`Edge Case` {
    @Test
    func `pageAligned rounds up to the boundary`() throws {
        let policy = try Growth.Policy<UInt8>.paged(Memory.Alignment(16))
        #expect(
            policy.capacity(from: Growth.Policy<UInt8>.Count(Cardinal(17)))
                == Growth.Policy<UInt8>.Count(Cardinal(32))
        )
        #expect(
            policy.capacity(from: Growth.Policy<UInt8>.Count(Cardinal(0)))
                == Growth.Policy<UInt8>.Count(Cardinal(16))
        )
    }
}

extension `Growth.Policy Tests`.Unit {
    @Test
    func `rational factor scales counts exactly and floors at one`() throws {
        let policy = Growth.Policy<UInt8>.factor(try .init(numerator: 3, denominator: 2))
        #expect(policy.capacity(from: .init(Cardinal(4))) == .init(Cardinal(6)))
        #expect(policy.capacity(from: .zero) == .one)
    }
}
