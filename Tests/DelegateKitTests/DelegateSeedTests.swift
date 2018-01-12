import XCTest
import DelegateKit




class DelegateSeedTests: XCTestCase {
    func testExample() {
        let spy = DelegateSeedSpy()

        let holder = DelegateSeedHolder()
        holder.delegates.append(spy.asAny())

        holder.notifyToDelegates()

        XCTAssertEqual(spy.callArgs, [.didCall])
    }


    func testMemoryLeak() {
        var spy: DelegateSeedSpy? = DelegateSeedSpy()
        let weakSpy = spy!.asAny()

        let holder = DelegateSeedHolder()
        holder.delegates.append(weakSpy)

        spy = nil
        XCTAssertTrue(weakSpy.isEmpty)
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}



class DelegateSeedSpy: DelegateSeed {
    // This code means that the delegate can take a Void parameter.
    typealias P = Void


    private(set) var callArgs: [CallArgs] = []


    func didCall(_ parameters: Void) {
        self.callArgs.append(.didCall)
    }


    enum CallArgs {
        case didCall
    }
}



class DelegateSeedHolder {
    // This is a declaration for the delegate. It means the delegate is a DelegateSeed1 and the delegate have
    // no type parameters and the delegate take no parameters.
    var delegates: [AnyDelegate<Void>] = []


    func notifyToDelegates() {
        for delegate in self.delegates {
            delegate.didCall(())
        }
    }
}
