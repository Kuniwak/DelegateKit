public class ZipDelegate<Params1, Params2> {
    public let delegate1: AnyDelegate<Params1>
    public let delegate2: AnyDelegate<Params2>


    public var isEmpty: Bool {
        return self.isEmptyFunc()
    }


    private let isEmptyFunc: () -> Bool


    public init<Delegate: DelegateChain>(
        _ delegate: Delegate
    ) where Delegate.P == (Params1, Params2) {
        var _t1: Params1?
        var _t2: Params2?

        self.delegate1 = AnonymouseDelegate<Params1> { t1 in
            _t1 = t1

            if let t2 = _t2 {
                delegate.didCall((t1, t2))
            }
        }.asAny()

        self.delegate2 = AnonymouseDelegate<Params2> { t2 in
            _t2 = t2

            if let t1 = _t1 {
                delegate.didCall((t1, t2))
            }
        }.asAny()

        self.isEmptyFunc = {
            return delegate.isEmpty
        }
    }
}



public func zip<Params1, Params2, Delegate: DelegateChain>(
    _ delegate: Delegate
) -> ZipDelegate<Params1, Params2> where Delegate.P == (Params1, Params2) {
    return ZipDelegate(delegate)
}
