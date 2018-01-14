# DelegateKit

[![Build Status](https://www.bitrise.io/app/ace33f6d21f75201/status.svg?token=8bfU4elsHpZ2HBqpEZ3mzA)](https://www.bitrise.io/app/ace33f6d21f75201)

Delegate によるデータの流れを Rx 風に加工できるようにする**実験的**ライブラリ。



## 目標

- 目標1: UIKit などの Delegate と似た構文で利用できること
    - 学習コストが高い Rx に対して優位になるのではと期待
- 目標2: 複数の Delegate オブジェクトが1つの Delegate スロットを監視できること
    - Delegate の欠点の克服を期待
- 目標3: Delegate に Rx 風の演算子を提供すること
    - Rx の有利な点を持ち込めれば便利なのではと期待



## 実験結果
### 目標1: UIKit などの Delegate と似た構文
結構変わってしまった。


#### 宣言部分

```swift
import DelegateKit

// 次のような従来の Delegate は、次のような定義構文へと変化した:
//
// protocol TraditionalDelegate: class {
//     func didA()
//     func didB()
//     func didC()
// }


// Delegate のメソッドはそれぞれ enum の case へと対応する
enum Event {
    case a
    case b
    case c
}


// Delegate の実装者は、受け取れるイベントの宣言と didCall メソッドの実装を要求される。
class DelegateSpy: DelegateKit.DelegateSeed {
    // 受け取れるイベントの宣言。
    typealias P = Event

    // イベント通知者から呼び出されるメソッド。
    func didCall(_ parameters: Event) {
        print(parameters)
    }
}


// Delegate の保持者は強参照で AnyDelegate を保持する。
class ExampleDelegateHolder {
    // 循環参照の回避は AnyDelegate 側でおこなわれているので、強参照で保持する。
    var delegate: DelegateKit.AnyDelegate<Event>?
    
    
    func notifyToDelegate(_ event: Event) {
        self.delegate?.didCall(event)
    }
}
```


#### 呼び出し部分

```swift
let spy = DelegateSpy()
let holder = ExampleDelegateHolder()

holder.delegate = spy
    .asWeak()
    .asAny()

let event = Event.a
holder.notifyToDelegate(event)
```



### 目標2: 複数の Delegate オブジェクトによる監視
これは比較的簡単にできた。


#### 宣言部分
```swift
class ExampleDelegatesHolder {
    // 複数の監視者を許可する場合は、DelegateBag をプロパティとしてもつ。
    let delegates = DelegateKit.DelegateBag<Event>()
    
    
    func notifyToDelegate(_ event: Event) {
        self.delegates.didCall(event)
    }
}
```


#### 呼び出し部分

```swift
let spy1 = DelegateSpy()
let spy2 = DelegateSpy()

let holder = ExampleDelegatesHolder()
holder.delegates.add(spy1.asWeak().asAny())
holder.delegates.add(spy2.asWeak().asAny())

let event = Event.a
holder.notifyToDelegates(event)

XCTAssertEqual(spy1.callArgs, [.didCall(event)])
XCTAssertEqual(spy2.callArgs, [.didCall(event)])
```



### 目標3: Rx 風の演算子

致命的な欠点がある。Rx とは演算子の適用順序が逆になる。

```swift
let spy = MapDelegateSpy()

let holder = MapDelegateHolder()
holder.delegate = spy
    .asWeak()
    .map { (number: Int) -> String in "NUMBER: \(number)" }
    .map { (number: Int) -> Int in number * 2 }
    .asAny()

holder.notifyToDelegates(1)

XCTAssertEqual(spy.callArgs, [.didCall("NUMBER: 2")])
```

この違いは、出力元と出力先の間の演算子の組み立ての方向によって起きているようだ:

- Rx は出力元（Observable）から出力先を組み立てていく
    - この場合は `Source().map(a).map(b)` は a の後に b が適用される
- Delegate は出力先（Delegate）から出力元を組み立てていく
    - この場合は `Dest().map(a).map(b)` は b の後に a が適用される
    
    
    
## 結論

Delegate から組み立てていくと、逆方向イベントフローになることがわかった。Observable or EventEmitter 方式などに代表される順方向イベントフローが優れているとわかった。
