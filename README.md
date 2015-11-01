# Serialize (swift 2.0/2.1)
[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat
)](https://developer.apple.com/swift)
[![Build Status](https://travis-ci.org/sagesse-cn/swift-serialize.svg?branch=master)](https://travis-ci.org/sagesse-cn/swift-serialize)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)

* serialize swift object to json
* deserialize json for swift custom class

-- 文档未更新...(Document is not updated...)

### Serialize Support
AnyObject (Most)

### Deserialize Support
Type 					| Description
----------------------- | -----------------------------------------------
**MembershipContainer**	| Unsupport, reason: Unknown
**Class**				| Support, automatic inference type
**Enum**				| Support Int Only 
**Struct**				| Unsupport, reason: Not KVC
**Tuple**				| Unsupport, reason: Not KVC
**Optional**			| Part Support, Please use `@objc` check
**Collection**          | Support, automatic inference element type
**Dictionary**          | Support, automatic inference key/value type
**Set**                 | Support, automatic inference element type, (is a unique array)

## Ext plan
* [X] NSDate
* [X] NSURL
* [X] NSData(Base64)
* [X] UIImage(Base64)

## Usage

* [X] **Use Source**
* [X] **Use Framework** 
* [X] **Use Cocoapods** 

Cocoapods Podfile: 
```Shell
platform :ios, '8.0'
pod "swift-serialize"
use_frameworks!
```

```swift
// if use framework or cocoapods, need import library
import Serialize

// If it is a custom class that inherits from NSObject, please
class Example : NSObject {
    
    // base type
    var val_int: Int = 0
    var val_bool: Bool = false
    var val_double: Double = 0
    var val_string: String?
    var val_array: [Int] = []
    var val_dictionary: [Int:Int] = [:]
    
    // invalid type
    //var val_int_invalid: Int?
    //var val_bool_invalid: Bool?
    //var val_doulbe_invalid: Double?
    //var val_array_invalid: [Int?]?
    //var val_dictionary_invalid: [Int:Int?]
    
    // custom type
    var val_custom: Custom?
    var val_custom_array: [Custom]?
    var val_custom_dictionary: [String:Custom]?
    
    class Custom : NSObject {
        var val: Example?
    }
}

let e1 = Example()

e1.val_int = 123
e1.val_bool = true
e1.val_double = 456.0
e1.val_string = "hello swift"
e1.val_array = [7, 8, 9]
e1.val_dictionary = [10 : 11, 12 : 13, 14 : 15]

// serialize
let json = Serialize.serialize(e1)
let jsonData = try! Serialize.serializeToJSONData(e1)
let jsonString = try! Serialize.serializeToJSONString(e1)

// 138
print(jsonData!.length)

// {"val_string":"hello swift","val_bool":true,"val_dictionary":{"12":13,"14":15,"10":11},"val_array":[7,8,9],"val_int":123,"val_double":456}
print(jsonString!)

// deserialize
let e2: Example? = Serialize.deserialize(json!)
let e3: Example? = Serialize.deserialize(json!, Example.self) as? Example

print(e1 == e2)
print(e2 == e3)
```

**Tip1:** If you don't know a type is available, please use the `@objc` to check it. 

**Tip2:** If `Optional<SomeType>` can't support, you can use `SomeType` replace it. example: Int, CGFloat, Double ...
