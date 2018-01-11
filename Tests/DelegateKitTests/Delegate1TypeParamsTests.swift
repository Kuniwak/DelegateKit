import XCTest
import DelegateKit




class Delegate1TypeParamsTests: XCTestCase {
    func testExample1() {
        let spy = Delegate1Unit1Spy<Void>()

        let holder = Delegate1Holder1<Void>()
        holder.delegates.append(spy.asWeakAny())

        holder.notifyToDelegates(())

        XCTAssertEqual(spy.callArgs, [.didCall])
    }
    func testExample2() {
        let spy = Delegate1Unit2Spy<Void>()

        let holder = Delegate1Holder2<Void>()
        holder.delegates.append(spy.asWeakAny())

        holder.notifyToDelegates(())

        XCTAssertEqual(spy.callArgs, [.didCall])
    }


    static var allTests = [
        ("testExample1", testExample1),
        ("testExample2", testExample2),
    ]
}


// These are unique types that identify delegate types.
enum Delegate1Unit1 {}
enum Delegate1Unit2 {}



enum AnyGeneric<T> {
    case x(T)
}



class Delegate1Unit1Spy<T>: DelegateSeed {
    // This code means that the class implement Delegate1 represents Delegate1Unit1.
    typealias U = Delegate1Unit1
    typealias P = AnyGeneric<T>


    private(set) var callArgs: [CallArgs] = []


    func didCall(_ parameters: AnyGeneric<T>) {
        self.callArgs.append(.didCall)
    }


    enum CallArgs {
        case didCall
    }
}



class Delegate1Unit2Spy<T>: DelegateSeed {
    typealias U = Delegate1Unit2
    typealias P = AnyGeneric<T>


    private(set) var callArgs: [CallArgs] = []


    func didCall(_ parameters: AnyGeneric<T>) {
        self.callArgs.append(.didCall)
    }


    enum CallArgs {
        case didCall
    }
}



class Delegate1Holder1<T> {
    var delegates: [WeakAnyDelegate0<Delegate1Unit1, AnyGeneric<T>>] = []


    func notifyToDelegates(_ x: T) {
        for delegate in self.delegates {
            delegate.didCall(.x(x))
        }
    }
}



class Delegate1Holder2<T> {
    var delegates: [WeakAnyDelegate0<Delegate1Unit2, AnyGeneric<T>>] = []


    func notifyToDelegates(_ x: T) {
        for delegate in self.delegates {
            delegate.didCall(.x(x))
        }
    }
}
