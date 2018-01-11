import XCTest
import DelegateKit




class Delegate0Tests: XCTestCase {
    func testExample1() {
        let spy = MultipleObserversDelegateSpy1()

        let holder = MultipleObserversDelegateHolder1()
        holder.delegates.append(spy.asWeakAny())

        holder.notifyToDelegates()

        XCTAssertEqual(spy.callArgs, [.didCall])
    }


    func testExample2() {
        let spy = MultipleObserversDelegateSpy2()

        let holder = MultipleObserversDelegateHolder2()
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



class MultipleObserversDelegateSpy1: Delegate0 {
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



class MultipleObserversDelegateSpy2: Delegate0 {
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



class MultipleObserversDelegateHolder1 {
    var delegates: [WeakAnyDelegate0<Delegate0Unit1, Void>] = []


    func notifyToDelegates() {
        for delegate in self.delegates {
            delegate.didCall(())
        }
    }
}



class MultipleObserversDelegateHolder2 {
    var delegates: [WeakAnyDelegate0<Delegate0Unit2, Void>] = []


    func notifyToDelegates() {
        for delegate in self.delegates {
            delegate.didCall(())
        }
    }
}
