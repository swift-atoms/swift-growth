import Growth_Test_Support
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
        #expect(policy.capacity(from: Cardinal(4)) == Cardinal(8))
        #expect(policy.capacity(from: Cardinal(0)) == Cardinal(1))
    }

    @Test
    func `exact returns the request unchanged`() {
        let policy = Growth.Policy<UInt8>.exact
        #expect(policy.capacity(from: Cardinal(16)) == Cardinal(16))
    }

    @Test
    func `custom delegates capacity to its strategy`() {
        let policy = Growth.Policy<UInt8>.custom { current in
            current + Cardinal(3)
        }

        #expect(policy.capacity(from: Cardinal(5)) == Cardinal(8))
    }
}
