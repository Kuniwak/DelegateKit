import XCTest
import DelegateKit




class DelegateBagTests: XCTestCase {
    func testExample() {
        let spy = DelegateBagSpy()

        let holder = DelegateBagHolder()
        holder.delegates.add(spy.asAny())

        holder.notifyToDelegates(.a)

        XCTAssertEqual(spy.callArgs, [.didCall(.a)])
    }


    func testMemoryLeak() {
        var spy: DelegateBagSpy? = DelegateBagSpy()
        let weakSpy = spy!.asAny()

        let holder = DelegateBagHolder()
        holder.delegates.add(weakSpy)

        spy = nil
        XCTAssertTrue(weakSpy.isEmpty)
    }


    static var allTests = [
        ("testExample", testExample),
        ("testMemoryLeak", testMemoryLeak),
    ]
}



class DelegateBagSpy: DelegateSeed {
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



class DelegateBagHolder {
    typealias Event = DelegateBagSpy.Event


    var delegates = DelegateBag<Event>()


    func notifyToDelegates(_ event: Event) {
        self.delegates.didCall(event)
    }
}
