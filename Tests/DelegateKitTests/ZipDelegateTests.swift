import XCTest
import DelegateKit



class ZipDelegateTests: XCTestCase {
    func testExample() {
        let spy = ZipDelegateSpy()
        let zipped = zip(spy.asWeak())

        let holder1 = ZipDelegateHolder()
        holder1.delegate = zipped.delegate1

        let holder2 = ZipDelegateHolder()
        holder2.delegate = zipped.delegate2

        holder1.notifyToDelegate(0)
        holder2.notifyToDelegate(1)

        XCTAssertEqual(
            spy.callArgs,
            [.didCall((0, 1))]
        )
    }


    func testMemoryLeak() {
        var spy: ZipDelegateSpy? = ZipDelegateSpy()
        let zipped = zip(spy!.asWeak())

        let holder1 = ZipDelegateHolder()
        holder1.delegate = zipped.delegate1

        let holder2 = ZipDelegateHolder()
        holder2.delegate = zipped.delegate2

        spy = nil
        XCTAssertTrue(zipped.isEmpty)
    }


    static var allTests = [
        ("testExample", testExample),
        ("testMemoryLeak", testMemoryLeak),
    ]
}



class ZipDelegateSpy: DelegateSeed {
    typealias P = (Int, Int)


    private(set) var callArgs: [CallArgs] = []


    func didCall(_ parameters: (Int, Int)) {
        self.callArgs.append(.didCall(parameters))
    }


    enum CallArgs: Equatable {
        case didCall((Int, Int))


        static func ==(lhs: CallArgs, rhs: CallArgs) -> Bool {
            switch (lhs, rhs) {
                case let (.didCall(l1, l2), .didCall(r1, r2)):
                return l1 == r1 && l2 == r2
            }
        }
    }
}



class ZipDelegateHolder {
    var delegate: AnyDelegate<Int>?


    func notifyToDelegate(_ int: Int) {
        self.delegate?.didCall(int)
    }
}