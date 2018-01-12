public class DelegateBag<Params> {
    private var delegates: [BagKey: AnyDelegate<Params>?] = [:]


    public var isEmpty: Bool {
        return self.delegates.isEmpty
    }


    public init() {}


    @discardableResult
    public func add(_ delegate: AnyDelegate<Params>) -> BagKey {
        let key = BagKey(index: self.delegates.count)

        self.delegates[key] = delegate

        return key
    }


    public func remove(by key: BagKey) {
        self.delegates[key] = nil
    }


    public struct BagKey: Hashable {
        fileprivate let index: Int


        public var hashValue: Int {
            return self.index
        }


        fileprivate init(index: Int) {
            self.index = index
        }


        public static func ==(lhs: BagKey, rhs: BagKey) -> Bool {
            return lhs.index == rhs.index
        }
    }
}



extension DelegateBag: DelegateSeed {
    public typealias P = Params


    public func didCall(_ parameters: Params) {
        for (_, delegate) in self.delegates {
            delegate?.didCall(parameters)
        }
    }
}