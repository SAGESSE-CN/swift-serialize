# Serialize 
[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat
)](https://developer.apple.com/swift)
[![Build Status](https://travis-ci.org/sagesse-cn/swift-serialize.svg?branch=master)](https://travis-ci.org/sagesse-cn/swift-serialize)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)

* 把swift对象序列化为json
* 把json数组反序列化为swift自定义类型

### Serialize Support
AnyObject

### Deserialize Support
类型 					| 描述
----------------------- | -----------------------------------------------
**Class**				| 支持, 自动推断类型
**Aggregate**			| 支持, 自动推断类型
**IndexContainer**		| 支持, 自动推断元素类型
**KeyContainer**		| 支持, 自动推断键/值类型
**ObjCObject**			| 支持, 自动推断类型
**Optional**			| 部分支持, 请使用`@objc`检查是否支持
**Enum**				| 部分支持, 请使用`@objc`检查是否支持
**Struct**				| 不支持, 原因: 没有KVC
**Tuple**				| 不支持, 原因: 没有KVC
**Container**			| 不支持, 原因: 未知
**MembershipContainer**	| 不支持, 原因: 未知

## Usage

[x] **使用源文件**
[x] **使用Framework**
[ ] **使用Cocoapods**

**Tip1:** 如果你不知道这个类型是否可用, 你可以使用`@objc`检查它. 

**Tip2:** 可选类型支持并没有全部支持, 如果`Optional<SomeType>`不支持, 你可以使用`SomeType`来替换掉他. 示例: Int, CGFloat, Double ...


```swift
// serialize.
let json: AnyObject? = serialize(object)
let data: NSData? = serializeToData(object)

// deserialize.
// Type for Array/Dictionary/Optional/NSObject and subclass
// The NSObject and subclass, suggest add `@objc` check, Sample refer SerializeTests
let object: Type? = deserialize(json: json)
let object: AnyObject? = deserialize(json: json, type: Type.self)
```
