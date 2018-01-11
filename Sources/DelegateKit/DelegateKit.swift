public protocol DelegateSeed: class {
    associatedtype U
    associatedtype P
    func didCall(_ parameters: P)
}



extension DelegateSeed {
    public func asWeakAny() -> WeakAnyDelegate<U, P> {
        return WeakAnyDelegate(wrapping: self)
    }
}



public class WeakAnyDelegate<Unit, Params>: DelegateSeed {
    public typealias U = Unit
    public typealias P = Params


    private let didCallFunc: (Params) -> Void


    public init<Delegate: DelegateSeed>(
        wrapping delegate: Delegate
    ) where Delegate.U == Unit, Delegate.P == Params {
        self.didCallFunc = { [weak weakDelegate = delegate] params in
            weakDelegate?.didCall(params)
        }
    }


    public func didCall(_ parameters: Params) {
        self.didCallFunc(parameters)
    }
}
