import XCTest
import DelegateKit




class DelegateSeedTests: XCTestCase {
    func testExample1() {
        let spy = DelegateUnit1Spy()

        let holder = DelegateUnit1Holder()
        holder.delegates.append(spy.asAny())

        holder.notifyToDelegates()

        XCTAssertEqual(spy.callArgs, [.didCall])
    }


    func testExample2() {
        let spy = DelegateUnit2Spy()

        let holder = DelegateUnit2Holder()
        holder.delegates.append(spy.asAny())

        holder.notifyToDelegates()

        XCTAssertEqual(spy.callArgs, [.didCall])
    }


    func testMemoryLeak() {
        var spy: DelegateUnit1Spy? = DelegateUnit1Spy()
        let weakSpy = spy!.asAny()

        let holder = DelegateUnit1Holder()
        holder.delegates.append(weakSpy)

        spy = nil
        XCTAssertTrue(weakSpy.isEmpty)
    }


    static var allTests = [
        ("testExample1", testExample1),
        ("testExample2", testExample2),
    ]
}


// These are unique types that identify delegate types.
enum DelegateUnit1 {}
enum DelegateUnit2 {}



class DelegateUnit1Spy: DelegateSeed {
    // This code means that the class implement Delegate represents DelegateUnit1.
    typealias U = DelegateUnit1
    typealias P = Void


    private(set) var callArgs: [CallArgs] = []


    func didCall(_ parameters: Void) {
        self.callArgs.append(.didCall)
    }


    enum CallArgs {
        case didCall
    }
}



class DelegateUnit2Spy: DelegateSeed {
    typealias U = DelegateUnit2
    typealias P = Void


    private(set) var callArgs: [CallArgs] = []


    func didCall(_ parameters: Void) {
        self.callArgs.append(.didCall)
    }


    enum CallArgs {
        case didCall
    }
}



class DelegateUnit1Holder {
    // This is a declaration for the delegate. It means the delegate is a DelegateUnit1 and the delegate have
    // no type parameters and the delegate take no parameters.
    var delegates: [AnyDelegate<DelegateUnit1, Void>] = []


    func notifyToDelegates() {
        for delegate in self.delegates {
            delegate.didCall(())
        }
    }
}



class DelegateUnit2Holder {
    var delegates: [AnyDelegate<DelegateUnit2, Void>] = []


    func notifyToDelegates() {
        for delegate in self.delegates {
            delegate.didCall(())
        }
    }
}
