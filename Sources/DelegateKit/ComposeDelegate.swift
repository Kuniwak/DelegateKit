public class ComposeDelegate<Domain, Codomain>: DelegateChain {
    public typealias P = Domain


    private let codomain: AnyDelegate<Codomain>
    private let block: (Domain) -> Codomain


    public var isEmpty: Bool {
        return self.codomain.isEmpty
    }


    public init<Delegate: DelegateChain>(
        _ delegate: Delegate,
        _ block: @escaping (Domain) -> Codomain
    ) where Delegate.P == Codomain {
        self.codomain = delegate.asAny()
        self.block = block
    }


    public func didCall(_ parameters: Domain) {
        self.codomain.didCall(self.block(parameters))
    }
}



extension DelegateChain {
    public func compose<AnotherParams>(
        _ block: @escaping (AnotherParams) -> P
    ) -> ComposeDelegate<AnotherParams, P> {
        return ComposeDelegate<AnotherParams, P>(self, block)
    }
}
