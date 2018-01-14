public class AnonymouseDelegate<Params>: DelegateChain {
    public typealias P = Params


    private let block: (Params) -> Void
    public var isEmpty: Bool = false


    public init(_ block: @escaping (Params) -> Void) {
        self.block = block
    }


    public func didCall(_ parameters: Params) {
        self.block(parameters)
    }
}
