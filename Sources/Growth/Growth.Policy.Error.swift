public import Ratio

extension Growth.Policy where Element: ~Copyable {
    public enum Error: Swift.Error, Sendable, Hashable {
        case overflow
        case invalidFactor(Ratio<Element, Element>)
        case scaling(Ratio<Element, Element>.Error)
        case wouldShrink(current: Count, proposed: Count)
    }
}
