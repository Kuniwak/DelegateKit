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
