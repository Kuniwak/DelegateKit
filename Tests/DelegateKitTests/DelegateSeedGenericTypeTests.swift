import XCTest
import DelegateKit




class DelegateSeedGenericTypeTests: XCTestCase {
    func testExample() {
        let spy = GenericDelegateSpy<Void>()

        let holder = GenericDelegateHolder<Void>()
        holder.delegates.add(spy.asWeak().asAny())

        holder.notifyToDelegates(.x(()))

        XCTAssertEqual(spy.callArgs, [.didCall])
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}



enum AnyGeneric<T> {
    case x(T)
}



class GenericDelegateSpy<T>: DelegateSeed {
    typealias P = AnyGeneric<T>


    private(set) var callArgs: [CallArgs] = []


    func didCall(_ parameters: AnyGeneric<T>) {
        self.callArgs.append(.didCall)
    }


    enum CallArgs {
        case didCall
    }
}



class GenericDelegateHolder<T> {
    let delegates = DelegateBag<AnyGeneric<T>>()


    func notifyToDelegates(_ x: AnyGeneric<T>) {
        self.delegates.didCall(x)
    }
}
