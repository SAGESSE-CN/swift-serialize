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

### Serialize Support
AnyObject

### Deserialize Support
Type 					| Description
----------------------- | -----------------------------------------------
**Class**				| Support, automatic inference type
**Aggregate**			| Support, automatic inference type
**IndexContainer**		| Support, automatic inference element type
**KeyContainer**		| Support, automatic inference key/value type
**ObjCObject**			| Support, automatic inference type
**Optional**			| Part Support, Please use `@objc` check
**Enum**				| Part Support, Please use `@objc` check
**Struct**				| Unsupport, reason: Not KVC
**Tuple**				| Unsupport, reason: Not KVC
**Container**			| Unsupport, reason: Unknown
**MembershipContainer**	| Unsupport, reason: Unknown

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
let ae1 = [e1]
let de1 = [1:e1]

// serialize
let json = serialize(e1)
let ajson = serialize(ae1)
let djson = serialize(de1)
let data = serializeToData(e1)

// deserialize
let e2: Example? = deserialize(json: json)
let e3: AnyObject? = deserialize(json: json, type: Example.self)
let ae2: [Example]? = deserialize(json: ajson)
let de2: [Int:Example]? = deserialize(json: djson)

```

**Tip1:** If you don't know a type is available, please use the `@objc` to check it. 

**Tip2:** If `Optional<SomeType>` can't support, you can use `SomeType` replace it. example: Int, CGFloat, Double ...
