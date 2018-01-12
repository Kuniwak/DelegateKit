public protocol DelegateSeed: class {
    associatedtype P

    func didCall(_ parameters: P)
}



extension DelegateSeed {
    public func asAny() -> AnyDelegate<P> {
        return AnyDelegate(.head(AnyWeakDelegateChain<P>(wrapping: self)))
    }


    public func asWeak() -> AnyWeakDelegateChain<P> {
        return AnyWeakDelegateChain(wrapping: self)
    }
}



public class AnyWeakDelegateChain<Params>: DelegateChain {
    public typealias P = Params


    private let didCallFunc: (Params) -> Void
    private let isEmptyFunc: () -> Bool


    public var isEmpty: Bool {
        return self.isEmptyFunc()
    }


    public init<Delegate: DelegateSeed>(
        wrapping delegate: Delegate
    ) where Delegate.P == Params {
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
