import XCTest
import DelegateKit



class MapDelegateTests: XCTestCase {
    func testExample() {
        let spy = MapDelegateSpy()

        let holder = MapDelegateHolder()
        holder.delegate = spy
                .asWeak()
                .compose { (number: Int) -> String in "NUMBER: \(number)" }
                .asAny()

        holder.notifyToDelegates(123)

        XCTAssertEqual(spy.callArgs, [.didCall("NUMBER: 123")])
    }


    func testMemoryLeak() {
        var spy: MapDelegateSpy! = MapDelegateSpy()
        let weakSpy = spy
            .asWeak()
            .compose { (number: Int) -> String in "NUMBER: \(number)" }
            .asAny()

        let holder = MapDelegateHolder()
        holder.delegate = weakSpy

        spy = nil
        XCTAssertTrue(weakSpy.isEmpty)
    }


    static var allTests = [
        ("testExample", testExample),
        ("testMemoryLeak", testMemoryLeak),
    ]
}



class MapDelegateSpy: DelegateSeed {
    typealias P = String


    private(set) var callArgs: [CallArgs] = []


    func didCall(_ parameters: String) {
        self.callArgs.append(.didCall(parameters))
    }


    enum CallArgs: Equatable {
        case didCall(String)

        static func ==(lhs: CallArgs, rhs: CallArgs) -> Bool {
            switch (lhs, rhs) {
            case let (.didCall(l), .didCall(r)):
                return l == r
            }
        }
    }
}



class MapDelegateHolder {
    var delegate: AnyDelegate<Int>?


    func notifyToDelegates(_ source: Int) {
        self.delegate?.didCall(source)
    }
}
