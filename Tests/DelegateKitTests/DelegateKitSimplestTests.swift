import XCTest



class DelegateKitSimplestTests: XCTestCase {
    func testExample() {
        let spy = SimplestExampleDelegateSpy()

        let holder = SimplestDelegateHolder()
        holder.delegate = spy

        holder.notifyToDelegate()

        XCTAssertEqual(spy.callArgs, [.doSomething])
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}



protocol SimplestExampleDelegate: class {
    func doSomething()
}



class SimplestExampleDelegateSpy: SimplestExampleDelegate {
    private(set) var callArgs: [CallArgs] = []


    func doSomething() {
        self.callArgs.append(.doSomething)
    }


    enum CallArgs {
        case doSomething
    }
}



class SimplestDelegateHolder {
    weak var delegate: SimplestExampleDelegate?


    func notifyToDelegate() {
        self.delegate?.doSomething()
    }
}
