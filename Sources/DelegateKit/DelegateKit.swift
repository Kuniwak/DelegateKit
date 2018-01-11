public protocol DelegateSeed: class {
    associatedtype U
    associatedtype P
    func didCall(_ parameters: P)
}



extension DelegateSeed {
    public func asWeakAny() -> WeakAnyDelegate0<U, P> {
        return WeakAnyDelegate0(wrapping: self)
    }
}



public class WeakAnyDelegate0<Unit, Params>: DelegateSeed {
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


public protocol Delegate1: class {
    associatedtype U
    associatedtype P
    func didCall(_ parameters: P)
}



extension Delegate1 {
    public func asWeakAny() -> WeakAnyDelegate1<U, P> {
        return WeakAnyDelegate1(wrapping: self)
    }
}



public class WeakAnyDelegate1<Unit, Params>: Delegate1 {
    public typealias U = Unit
    public typealias P = Params


    private let didCallFunc: (Params) -> Void


    public init<Delegate: Delegate1>(
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
