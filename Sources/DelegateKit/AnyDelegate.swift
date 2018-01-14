public class AnyDelegate<Params>: DelegateChain {
    private let chain: Chain<Params>


    public var isEmpty: Bool {
        switch self.chain {
        case let .head(head):
            return head.isEmpty
        case let .body(body):
            return body.isEmpty
        }
    }


    public func didCall(_ parameters: Params) {
        switch self.chain {
        case let .head(chain):
            chain.didCall(parameters)
        case let .body(chain):
            chain.didCall(parameters)
        }
    }


    public init(_ chain: Chain<Params>) {
        self.chain = chain
    }


    public func asAny() -> AnyDelegate<Params> {
        return self
    }


    public enum Chain<Params> {
        case head(AnyWeakDelegateChain<Params>)
        case body(AnyStrongDelegateChain<Params>)
    }
}
