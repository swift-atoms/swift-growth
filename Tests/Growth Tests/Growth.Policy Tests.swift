import Growth_Test_Support
import Memory_Alignment
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
        #expect(policy.capacity(from: 4) == Index<UInt8>.Count(8))
        #expect(policy.capacity(from: 0) == Index<UInt8>.Count(1))
    }

    @Test
    func `exact returns the request unchanged`() {
        let policy = Growth.Policy<UInt8>.exact
        #expect(policy.capacity(from: 16) == Index<UInt8>.Count(16))
    }
}

extension `Growth.Policy Tests`.`Edge Case` {
    @Test
    func `pageAligned rounds up to the boundary`() throws {
        let policy = try Growth.Policy<UInt8>.paged(Memory.Alignment(16))
        #expect(policy.capacity(from: 17) == Index<UInt8>.Count(32))
        #expect(policy.capacity(from: 0) == Index<UInt8>.Count(16))
    }
}
