import XCTest
import DelegateKit



class ComposeDelegateTests: XCTestCase {
    func testExample() {
        let spy = ComposeDelegateUnitSpy()

        let holder = ComposeDelegateHolder()
        holder.delegates.append(
            AnyWeakDelegateChain(wrapping: spy)
                .compose { (number: Int) -> String in "NUMBER: \(number)" }
                .asAny()
        )

        holder.notifyToDelegates(123)

        XCTAssertEqual(spy.callArgs, [.didCall("NUMBER: 123")])
    }


    func testMemoryLeak() {
        var spy: ComposeDelegateUnitSpy! = ComposeDelegateUnitSpy()
        let weakSpy = AnyWeakDelegateChain(wrapping: spy)
            .compose { (number: Int) -> String in "NUMBER: \(number)" }
            .asAny()

        let holder = ComposeDelegateHolder()
        holder.delegates.append(weakSpy)

        spy = nil
        XCTAssertTrue(weakSpy.isEmpty)
    }


    static var allTests = [
        ("testExample", testExample),
        ("testMemoryLeak", testMemoryLeak),
    ]
}



enum ComposeDelegateUnit {}



class ComposeDelegateUnitSpy: DelegateSeed {
    typealias U = ComposeDelegateUnit
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



class ComposeDelegateHolder {
    var delegates: [AnyDelegate<ComposeDelegateUnit, Int>] = []


    func notifyToDelegates(_ source: Int) {
        for delegate in self.delegates {
            delegate.didCall(source)
        }
    }
}
