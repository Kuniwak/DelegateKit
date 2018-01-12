import XCTest
import DelegateKit




class DelegateSeedTests: XCTestCase {
    func testExample() {
        let spy = DelegateSeedSpy()

        let holder = DelegateSeedHolder()
        holder.delegates.add(spy.asAny())

        holder.notifyToDelegates(.a)

        XCTAssertEqual(spy.callArgs, [.didCall(.a)])
    }


    func testMemoryLeak() {
        var spy: DelegateSeedSpy? = DelegateSeedSpy()
        let weakSpy = spy!.asAny()

        let holder = DelegateSeedHolder()
        holder.delegates.add(weakSpy)

        spy = nil
        XCTAssertTrue(weakSpy.isEmpty)
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}



class DelegateSeedSpy: DelegateSeed {
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


    var delegates = DelegateBag<Event>()


    func notifyToDelegates(_ event: Event) {
        self.delegates.didCall(event)
    }
}
