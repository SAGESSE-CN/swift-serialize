# Serialize (swift 5.0)

[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat)](https://developer.apple.com/swift)
[![Build Status](https://travis-ci.org/sagesse-cn/swift-serialize.svg?branch=master)](https://travis-ci.org/sagesse-cn/swift-serialize)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](http://mit-license.org)

* serialize swift object to json

* deserialize json for swift custom class

  

## 建议在 Swift 4.0 以及之后的版本中使用原生的 JSONDecoder 和 JSONEncoder



### Serialize Support

AnyObject (Most)

### Deserialize Support
Type                    | Description
----------------------- | -----------------------------------------------
**Class**               | 支持, 自动推断类型, 部分需要实现`Serializeable`或者`ValueProvider`
**Enum**                | 支持, 需要实现`Serializeable`或者`ValueProvider`
**Struct**              | 支持, 需要实现`Serializeable`或者`ValueProvider`
**Tuple**               | 不支持, 无法序列化/反序列化(临时类型), 无法映射(NSArray, NSDictionary)
**Optional**            | 支持, 自动推断元素
**Collection**          | 支持, 自动推断元素
**Dictionary**          | 支持, 自动推断KV类型
**Set**                 | 支持, 自动推断元素(映射为数组)

## 特殊支持
* [X] NSDate
* [X] NSURL
* [X] NSData(Base64)
* [X] UIImage(Base64)

## Usage
* [X] **Use Source**
* [X] **Use Framework**
* [X] **Use CocoaPods**

CocoaPods Podfile:
```Shell
platform :ios, '8.0'
pod "swift-serialize"
use_frameworks!
```

```swift
let e1 = Example()

e1.val_int = 123
e1.val_bool = true
e1.val_double = 456.0
e1.val_string = "hello swift"
e1.val_array = [7, 8, 9]
e1.val_dictionary = [10 : 11, 12 : 13, 14 : 15]

// serialize
let json = serialize(e1)
let jsonData = try! Serialize.serializeToJSONData(e1)
let jsonString = try! Serialize.serializeToJSONString(e1)

print(jsonData!.length)
print(jsonString!)

// deserialize
let e2: Example? = Serialize.deserialize(json!)
let e3: Example? = Serialize.deserialize(json as Any, Example.self) as? Example

print(e1 == e2)
print(e2 == e3)
```

## 如何让struct/class支持Serialize

#### 方法1: 使用`ValueProvider`

`ValueProvider`需要实现`setValue:forSerialize:`和`valueForSerialize:`方法.

`InitProvider`只在反序列化的时候使用, 如果你不需要反序列化可以跳过.

序列化: 将直接获取成员因此并没有调用`valueForSerialize:`, 该函数作为保留函数.

反序列化: 将使用`setValue:forSerialize:`, 需要在方法里对每一个成员进行更新, 可以使用`assign`简化类型转换的代码

```swift
class Example : InitProvider, ValueProvider {
    var a: Optional<Int> = nil
    var b: Optional<String> = nil
    var c: Optional<Array<Int>> = nil

    var u1: Optional<NSURL> = nil
    var u2: Optional<NSURL> = nil

    required init() {}

    func valueForSerialize(key: String) -> Any? {
        return nil
    }

    func setValue(value: Any?, forSerialize key: String) {
        switch key {
            case "a": assign(&a, value)
            case "b": assign(&b, value)
            case "c": assign(&c, value)
            default: break
        }
    }
}
```

#### 方法2: 使用`Serializeable`

`Serializeable`需要实现`serialize`和`deserialize:`

```swift
class Example : Serializeable {
    var a: Optional<Int> = nil
    var b: Optional<String> = nil
    var c: Optional<Array<Int>> = nil

    var u1: Optional<NSURL> = nil
    var u2: Optional<NSURL> = nil

    required init() {}

    func serialize() -> AnyObject? {
        let dic = NSMutableDictionary()
        if let o = a.serialize() {
            dic["a"] = o
        }
        if let o = b.serialize() {
            dic["b"] = o
        }
        if let o = c.serialize() {
            dic["c"] = o
        }
        return dic.count != 0 ? dic : nil
    }
    static func deserialize(o: AnyObject) -> Self? {
        // 只处理NSDictionary的
        guard let dic = o as? NSDictionary where dic.count != 0 else {
            return nil
        }
        var tmp = self.init()

        if let v = Optional<Int>.deserialize(dic["a"] ?? NSNull()) {
            tmp.a = v
        }
        if let v = Optional<String>.deserialize(dic["b"] ?? NSNull()) {
            tmp.b = v
        }
        if let v = Optional<Array<Int>>.deserialize(dic["c"] ?? NSNull()) {
            tmp.c = v
        }
        return tmp
    }
}
```

#### 方法3: 继承于`NSObject`

`NSObject`只会使用`Serializeable`, 他己经实现了`serialize`和`deserialize:`.

大部分情况下都可以直接用系统的KVC(NSKeyValueCoding), 但也有一些情况是没有办法使用系统的KVC的.

你可以使用`@objc`来检查是否原生支持, 对于那些没有支持的, 你需要实现`ValueProvider`

```swift
class Example : NSObject, ValueProvider {

    // base type
    @objc var val_int: Int = 0
    @objc var val_bool: Bool = false
    @objc var val_double: Double = 0
    @objc var val_string: String?
    @objc var val_array: [Int] = []
    @objc var val_dictionary: [Int:Int] = [:]

    // 原生KVC不支持的类型
    var val_int_t: Int?
    var val_bool_t: Bool?
    var val_doulbe_t: Double?
    var val_array_t: [Int?]?
    var val_dictionary_t: [Int:Int?]

    // custom type
    @objc var val_custom: Custom?
    @objc var val_custom_array: [Custom]?
    @objc var val_custom_dictionary: [String:Custom]?

    class Custom : NSObject {
        var val: Example?
    }
    func valueForSerialize(key: String) -> Any? {
        return nil
    }
    func setValue(value: Any?, forSerialize key: String) {
        switch key {
            case "val_int_t": assign(&val_int_t, value)
            case "val_bool_t": assign(&val_doulbe_t, value)
            case "val_array_t": assign(&val_array_t, value)
            case "val_dictionary_t": assign(&val_dictionary_t, value)
            default: break
        }
    }
}
```

#### 关于系统的KVC不支持的类型
Type                    | Description
----------------------- | -----------------------------------------------
**enum**                | 除了`@objc enum E : Int`其他全部不支持
**tuple**               | 全部不支持
**struct**              | 全部不支持
**class**               | 自定义的类都不支持, 除了继承于`NSObject`
**optional**            | 大部分支持, 需要使用`@objc`来检查
