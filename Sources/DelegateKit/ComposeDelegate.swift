public class ComposeDelegate<Source, Domain>: DelegateChain {
    public typealias P = Source


    private let domain: AnyDelegate<Domain>
    private let block: (Source) -> Domain


    public var isEmpty: Bool {
        return self.domain.isEmpty
    }


    public init<Delegate: DelegateChain>(
        _ delegate: Delegate,
        _ block: @escaping (Source) -> Domain
    ) where Delegate.P == Domain {
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
    ) -> ComposeDelegate<AnotherParams, P> {
        return ComposeDelegate<AnotherParams, P>(self, block)
    }
}
