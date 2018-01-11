public protocol Delegate0: class {
    associatedtype U
    associatedtype P
    func didCall(_ parameters: P)
}



extension Delegate0 {
    public func asWeakAny() -> WeakAnyDelegate0<U, P> {
        return WeakAnyDelegate0(wrapping: self)
    }
}



public class WeakAnyDelegate0<Unit, Params>: Delegate0 {
    public typealias U = Unit
    public typealias P = Params


    private let didCallFunc: (Params) -> Void


    public init<Delegate: Delegate0>(
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
