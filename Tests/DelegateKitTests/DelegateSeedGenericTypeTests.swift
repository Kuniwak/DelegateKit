import XCTest
import DelegateKit




class DelegateSeedGenericTypeTests: XCTestCase {
    func testExample() {
        let spy = GenericDelegateSpy<Void>()

        let holder = GenericDelegateHolder<Void>()
        holder.delegates.append(spy.asAny())

        holder.notifyToDelegates(())

        XCTAssertEqual(spy.callArgs, [.didCall])
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}


enum GenericDelegate {}



enum AnyGeneric<T> {
    case x(T)
}



class GenericDelegateSpy<T>: DelegateSeed {
    typealias U = GenericDelegate
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
    var delegates: [AnyDelegate<GenericDelegate, AnyGeneric<T>>] = []


    func notifyToDelegates(_ x: T) {
        for delegate in self.delegates {
            delegate.didCall(.x(x))
        }
    }
}
