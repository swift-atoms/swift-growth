import Growth
import Index
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
