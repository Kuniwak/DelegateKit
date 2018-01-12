public protocol DelegateChain {
    associatedtype P

    var isEmpty: Bool { get }

    func didCall(_ parameters: P)
}



extension DelegateChain {
    public func asAny() -> AnyDelegate<P> {
        return AnyDelegate(.body(AnyStrongDelegateChain(wrapping: self)))
    }
}



public class AnyStrongDelegateChain<Params>: DelegateChain {
    public typealias P = Params


    private let didCallFunc: (Params) -> Void
    private let isEmptyFunc: () -> Bool


    public var isEmpty: Bool {
        return self.isEmptyFunc()
    }


    public init<Delegate: DelegateChain>(
        wrapping delegate: Delegate
    ) where Delegate.P == Params {
        self.didCallFunc = { params in
            delegate.didCall(params)
        }

        self.isEmptyFunc = {
            return delegate.isEmpty
        }
    }


    public func didCall(_ parameters: Params) {
        self.didCallFunc(parameters)
    }
}
