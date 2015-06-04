# SFSerialize
swift object serialization/unserialization of json 
# Usage
```swift
// serialize.
let json: AnyObject? = serialize(object)
let data: NSData? = serializeToData(object)

// unserialize.
// Type for Array/Dictionary/Optional/NSObject and subclass
let object: Type = unserialize(json: json)
let object: AnyObject = unserialize(json: json, type: Type.self)
```
