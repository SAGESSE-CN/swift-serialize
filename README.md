# SFSerialize 
[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat
)](https://developer.apple.com/swift)
[![Build Status](https://travis-ci.org/sagesse-cn/swift-serialize.svg?branch=master)](https://travis-ci.org/sagesse-cn/swift-serialize)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)

swift object serialize/deserialize of json 

#### Serialize Support
AnyObject

#### Deserialize Support
Type | Description
---- | ---------
**Class**|Support, automatic inference type
**Aggregate**|Support, automatic inference type
**IndexContainer**|Support, automatic inference element type
**KeyContainer**|Support, automatic inference key/value type
**ObjCObject**|Support, automatic inference type
**Optional**|Part Support (`@objc` export)
**Enum**|Part Support (`@objc` export)
**Struct**|Unsupport, reason: Not KVC
**Tuple**|Unsupport, reason: Not KVC
**Container**|Unsupport, reason: Unknown
**MembershipContainer**|Unsupport, reason: Unknown

## Usage

```swift
// Please copy `SFSerialize.swift` file to your project

// serialize.
let json: AnyObject? = serialize(object)
let data: NSData? = serializeToData(object)

// deserialize.
// Type for Array/Dictionary/Optional/NSObject and subclass
// The NSObject and subclass, suggest add `@objc` check, Sample refer SFSerializeTests
let object: Type? = deserialize(json: json)
let object: AnyObject? = deserialize(json: json, type: Type.self)
```

```swift
// This property can not support
var val: Optional<Int/UInt/Int8/Int16/Int32/Int64/CGFloat/Float/Double>
// Recommended instead of
var val: Int/UInt/Int8/Int16/Int32/Int64/CGFloat/Float/Double
```
