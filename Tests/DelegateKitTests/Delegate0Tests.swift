import XCTest
import DelegateKit




class Delegate0Tests: XCTestCase {
    func testExample1() {
        let spy = Delegate0Unit1Spy()

        let holder = Delegate0Holder1()
        holder.delegates.append(spy.asWeakAny())

        holder.notifyToDelegates()

        XCTAssertEqual(spy.callArgs, [.didCall])
    }


    func testExample2() {
        let spy = Delegate0Unit2Spy()

        let holder = Delegate0Holder2()
        holder.delegates.append(spy.asWeakAny())

        holder.notifyToDelegates()

        XCTAssertEqual(spy.callArgs, [.didCall])
    }


    static var allTests = [
        ("testExample1", testExample1),
        ("testExample2", testExample2),
    ]
}


// These are unique types that identify delegate types.
enum Delegate0Unit1 {}
enum Delegate0Unit2 {}



class Delegate0Unit1Spy: DelegateSeed {
    // This code means that the class implement Delegate0 represents Delegate0Unit1.
    typealias U = Delegate0Unit1
    typealias P = Void


    private(set) var callArgs: [CallArgs] = []


    func didCall(_ parameters: Void) {
        self.callArgs.append(.didCall)
    }


    enum CallArgs {
        case didCall
    }
}



class Delegate0Unit2Spy: DelegateSeed {
    typealias U = Delegate0Unit2
    typealias P = Void


    private(set) var callArgs: [CallArgs] = []


    func didCall(_ parameters: Void) {
        self.callArgs.append(.didCall)
    }


    enum CallArgs {
        case didCall
    }
}



class Delegate0Holder1 {
    // This is a declaration for the delegate. It means the delegate is a Delegate0Unit1 and the delegate have
    // no type parameters and the delegate take no parameters.
    var delegates: [WeakAnyDelegate0<Delegate0Unit1, Void>] = []


    func notifyToDelegates() {
        for delegate in self.delegates {
            delegate.didCall(())
        }
    }
}



class Delegate0Holder2 {
    var delegates: [WeakAnyDelegate0<Delegate0Unit2, Void>] = []


    func notifyToDelegates() {
        for delegate in self.delegates {
            delegate.didCall(())
        }
    }
}
