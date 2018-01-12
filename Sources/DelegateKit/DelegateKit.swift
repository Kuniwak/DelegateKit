extension DelegateSeed {
    public func asAny() -> AnyDelegate<U, P> {
        return .weak(AnyWeakDelegateChain<U, P>(wrapping: self))
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



public protocol DelegateChain: class {
    associatedtype U
    associatedtype P

    var isEmpty: Bool { get }

    func didCall(_ parameters: P)
}



extension DelegateChain {
    public func asAny() -> AnyDelegate<U, P> {
        return .strong(AnyDelegateChain(wrapping: self))
    }
}



public enum AnyDelegate<Unit, Params> {
    case strong(AnyDelegateChain<Unit, Params>)
    case weak(AnyWeakDelegateChain<Unit, Params>)


    public var isEmpty: Bool {
        switch self {
        case let .strong(chain):
            return chain.isEmpty
        case let .weak(chain):
            return chain.isEmpty
        }
    }


    public func didCall(_ parameters: Params) {
        switch self {
        case let .strong(chain):
            chain.didCall(parameters)
        case let .weak(chain):
            chain.didCall(parameters)
        }
    }


    public func asAny() -> AnyDelegate<Unit, Params> {
        return self
    }
}



public class AnyDelegateChain<Unit, Params>: DelegateChain {
    public typealias U = Unit
    public typealias P = Params


    private let didCallFunc: (Params) -> Void
    private let isEmptyFunc: () -> Bool


    public var isEmpty: Bool {
        return self.isEmptyFunc()
    }


    public init<Delegate: DelegateChain>(
        wrapping delegate: Delegate
    ) where Delegate.U == Unit, Delegate.P == Params {
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



public protocol DelegateSeed: class {
    associatedtype U
    associatedtype P

    func didCall(_ parameters: P)
}



public class ComposeDelegate<Unit, Source, Domain>: DelegateChain {
    public typealias U = Unit
    public typealias P = Source


    private let domain: AnyDelegate<Unit, Domain>
    private let block: (Source) -> Domain


    public var isEmpty: Bool {
        return self.domain.isEmpty
    }


    public init<Delegate: DelegateChain>(
        _ delegate: Delegate,
        _ block: @escaping (Source) -> Domain
    ) where Delegate.U == U, Delegate.P == Domain {
        self.domain = delegate.asAny()
        self.block = block
    }


    public func didCall(_ parameters: Source) {
        self.domain.didCall(self.block(parameters))
    }
}



extension DelegateChain {
    public func compose<AnotherParams>(
        _ block: @escaping (AnotherParams) -> P
    ) -> ComposeDelegate<U, AnotherParams, P> {
        return ComposeDelegate<U, AnotherParams, P>(self, block)
    }
}
