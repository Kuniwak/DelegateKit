import XCTest
import DelegateKit




class DelegateSeedTests: XCTestCase {
    func testExample() {
        let spy = DelegateSeedSpy()

        let holder = DelegateSeedHolder()
        holder.delegates.append(spy.asAny())

        holder.notifyToDelegates(.a)

        XCTAssertEqual(spy.callArgs, [.didCall(.a)])
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
    typealias P = Event


    private(set) var callArgs: [CallArgs] = []


    func didCall(_ parameters: Event) {
        self.callArgs.append(.didCall(parameters))
    }


    enum Event {
        case a
        case b
        case c
    }


    enum CallArgs: Equatable {
        case didCall(Event)

        static func ==(lhs: CallArgs, rhs: CallArgs) -> Bool {
            switch (lhs, rhs) {
            case let (.didCall(l), .didCall(r)):
                return l == r
            }
        }
    }
}



class DelegateSeedHolder {
    typealias Event = DelegateSeedSpy.Event

    // This is a declaration for the delegate. It means the delegate is a DelegateSeed1 and the delegate have
    // no type parameters and the delegate take no parameters.
    var delegates: [AnyDelegate<Event>] = []


    func notifyToDelegates(_ event: Event) {
        for delegate in self.delegates {
            delegate.didCall(event)
        }
    }
}
