public protocol DelegateSeed: class {
    associatedtype U
    associatedtype P

    func didCall(_ parameters: P)
}



extension DelegateSeed {
    public func asAny() -> AnyDelegate<U, P> {
        return AnyDelegate(.head(AnyWeakDelegateChain<U, P>(wrapping: self)))
    }
}



public class AnyWeakDelegateChain<Unit, Params>: DelegateChain {
    public typealias U = Unit
    public typealias P = Params


    private let didCallFunc: (Params) -> Void
    private let isEmptyFunc: () -> Bool


    public var isEmpty: Bool {
        return self.isEmptyFunc()
    }


    public init<Delegate: DelegateSeed>(
        wrapping delegate: Delegate
    ) where Delegate.U == Unit, Delegate.P == Params {
        self.didCallFunc = { [weak weakDelegate = delegate] params in
            weakDelegate?.didCall(params)
        }

        self.isEmptyFunc = { [weak weakDelegate = delegate] in
            return weakDelegate == nil
        }
    }


    public func didCall(_ parameters: Params) {
        self.didCallFunc(parameters)
    }
}
