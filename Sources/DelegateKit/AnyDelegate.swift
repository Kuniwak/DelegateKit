public class AnyDelegate<Unit, Params> {
    private let chain: Chain<Unit, Params>


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


    public init(_ chain: Chain<Unit, Params>) {
        self.chain = chain
    }


    public func asAny() -> AnyDelegate<Unit, Params> {
        return self
    }


    public enum Chain<Unit, Params> {
        case head(AnyWeakDelegateChain<Unit, Params>)
        case body(AnyStrongDelegateChain<Unit, Params>)
    }
}
