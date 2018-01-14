import XCTest
import DelegateKit




class DelegateSeedTests: XCTestCase {
    func testExample() {
        let spy = DelegateSeedSpy()

        let holder = DelegateSeedHolder()
        holder.delegate = spy.asWeak().asAny()

        holder.notifyToDelegate(.a)

        XCTAssertEqual(spy.callArgs, [.didCall(.a)])
    }


    func testMemoryLeak() {
        var spy: DelegateSeedSpy? = DelegateSeedSpy()
        let weakSpy = spy!.asWeak().asAny()

        let holder = DelegateSeedHolder()
        holder.delegate = weakSpy

        spy = nil
        XCTAssertTrue(weakSpy.isEmpty)
    }


    static var allTests = [
        ("testExample", testExample),
        ("testMemoryLeak", testMemoryLeak),
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


    var delegate: AnyDelegate<Event>?


    func notifyToDelegate(_ event: Event) {
        self.delegate?.didCall(event)
    }
}
