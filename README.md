# SFSerialize
swift object serialization/unserialization of json 

# Unserialize Support
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

# Usage
```swift
// serialize.
let json: AnyObject? = serialize(object)
let data: NSData? = serializeToData(object)

// unserialize.
// Type for Array/Dictionary/Optional/NSObject and subclass
// The NSObject and subclass, suggest add `@objc` check, Sample refer SFSerializeTests
let object: Type = unserialize(json: json)
let object: AnyObject = unserialize(json: json, type: Type.self)
```
