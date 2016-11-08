//
//  Serialize.swift
//
//  Created by sagesse on 6/2/15.
//  Copyright (c) 2015 Sagesse. All rights reserved.
//

import UIKit

// Optional             支持, 自动推断元素
// Collection           支持, 自动推断元素
// Dictionary           支持, 自动推断KV类型
// Set                  支持, 自动推断元素(映射为数组)
// Struct               支持, 需要实现`Serializeable`或者`Codeable`
// Enum                 支持, 需要实现`Serializeable`或者`Codeable`
// Class                支持, 自动推断类型, 部分需要实现`Serializeable`或者`Codeable`
// Tuple                不支持, 原因: 无法映射(NSArray, NSDictionary), 无法序列化/反序列化(临时类型)


// MARK: - Public Protocol

///
/// 构建协议
///
public protocol Buildable {
    ///
    ///  允许其直接创建对象
    ///
    init()
}

///
/// 序列化/反序列化协议
///
public protocol Serializeable {
    ///
    /// 序列化
    ///
    /// - returns: 如果为nil和NSNull, 表示序列化失败 \
    ///            内部类型: NSNull, NSNumber, NSString, NSArray, NSDictionary
    ///
    func serialize() -> Any?
    ///
    /// 反序列化
    ///
    /// - parameter o: 原始数据 \
    ///                内部类型: NSNull, NSNumber, NSString, NSArray, NSDictionary
    ///
    /// - returns: 如果为nil和NSNull, 表示反序列化失败
    ///
    static func deserialize(_ o: Any) -> Self?
}

///
/// 键值编码
///
public protocol Codeable {
    ///
    /// 序列化/反序列化的时候获取值(暂时未使用, 因为可以直接获取到值)
    ///
    func valueForSerialize(_ key: String) -> Any?
    ///
    /// 序列化/反序列化的时候更新值
    /// - parameter value: 新的值
    /// - note: example
    /// ```swift
    /// struct Example : Codeable, Buildable {
    ///     init() {}
    ///     var value1: Int = 0
    ///     var value2: String = ""
    ///     var value3: Array<Int> = []
    ///     mutating func setValue(value: Any?, forSerialize key: String) {
    ///         switch key {
    ///         case "value1": assign(&self.value1, value)
    ///         case "value2": assign(&self.value2, value)
    ///         case "value3": assign(&self.value3, value)
    ///         default: break
    ///         }
    ///     }
    ///     func valueForSerialize(key: String) -> Any? {
    ///         return nil
    ///     }
    /// }
    ///
    mutating func setValue(_ value: Any?, forSerialize key: String)
}

// MARK: - Public Package

///
/// 打包函数为模块避免作用域冲突
///
public struct Serialize {
    ///
    /// 序列化
    ///
    /// - parameter o: 需要序列化的对象
    /// - returns: 如果返回nil, 序列化失败 \
    ///            内部类型: NSNull, NSNumber, NSString, NSArray, NSDictionary
    ///
    public static func serialize(_ o: Any) -> Any? {
        return _serialize(o)
    }
    ///
    /// 序列化(未实现)
    ///
    /// - parameter o: 需要序列化的对象
    /// - parameter t: 指定对象的KEY
    /// - returns: 如果返回nil, 序列化失败 \
    ///            内部类型: NSNull, NSNumber, NSString, NSArray, NSDictionary
    ///
    public static func serialize(_ o: Any, _ t: Any.Type) -> AnyObject? {
        return _serialize(o, t)
    }
    ///
    /// 序列化为json(Data)
    ///
    /// - parameter o: 需要序列化的对象
    /// - returns: 如果返回nil, 序列化失败
    ///
    public static func serializeToJSONData(_ o: Any) throws -> Data? {
        if let json = _serialize(o) {
            return try JSONSerialization.data(withJSONObject: json, options: .init(rawValue: 0))
        }
        return nil
    }
    ///
    /// 序列化为json(NSString)
    ///
    /// - parameter o: 需要序列化的对象
    /// - returns: 如果返回nil, 序列化失败
    ///
    public static func serializeToJSONString(_ o: Any) throws -> String? {
        if let data = try serializeToJSONData(o) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    ///
    /// 反序列化
    ///
    /// - parameter o: 解释后的数据(JSON/XML/...) \
    ///                内部类型: NSNull, NSNumber, NSString, NSArray, NSDictionary
    /// - parameter T: 目标类型
    /// - returns: 如果返回nil, 反序列化失败
    ///
    public static func deserialize<T>(_ o: Any) -> T?  {
        return _deserialize(o, T.self) as? T
    }
    ///
    /// 反序列化
    ///
    /// - parameter o: 解释后的数据(JSON/XML/...) \
    ///                内部类型: NSNull, NSNumber, NSString, NSArray, NSDictionary
    /// - parameter t: 目标类型
    /// - returns: 如果返回nil, 反序列化失败
    ///
    public static func deserialize(_ o: Any, _ t: Any.Type) -> Any? {
        return _deserialize(o, t)
    }
    ///
    /// 反序列化
    ///
    /// - parameter data: json原始数据(Data)
    /// - parameter T: 目标类型
    /// - returns: 如果返回nil, 反序列化失败
    ///
    public static func deserialize<T>(JSONData data: Data) throws -> T? {
        return try deserialize(JSONData: data, T.self) as? T
    }
    ///
    /// 反序列化
    ///
    /// - parameter data: json原始数据(Data)
    /// - parameter t: 目标类型
    /// - returns: 如果返回nil, 反序列化失败
    ///
    public static func deserialize(JSONData data: Data, _ t: Any.Type) throws -> Any? {
        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        return _deserialize(json, t)
    }
    ///
    /// 反序列化
    ///
    /// - parameter str: json字符串数据(NSString)
    /// - parameter T: 目标类型
    /// - returns: 如果返回nil, 反序列化失败
    ///
    public static func deserialize<T>(JSONString str: String) throws -> T? {
        return try deserialize(JSONString: str, T.self) as? T
    }
    
    ///
    /// 反序列化
    ///
    /// - parameter str: json字符串数据(NSString)
    /// - parameter t: 目标类型
    /// - returns: 如果返回nil, 反序列化失败
    ///
    public static func deserialize(JSONString str: String, _ type: Any.Type) throws -> Any? {
        guard let data = str.data(using: .utf8) else {
            throw NSError(domain: "String decode fail", code: -1, userInfo: nil)
        }
        return try deserialize(JSONData: data, type)
    }
}

// MARK: - Util Function

///
/// 赋值
///
public func assign<T>(_ o: inout T, _ i: Any?) {
    // 检查`i`是否可以转换为`T`
    if let i = i as? T {
        // 转换成功
        o = i
    } else {
        // 转换失败
        // 如果`T`支持空值, 更新为空值, 否则忽略
        if let t = T.self as? ExpressibleByNilLiteral.Type {
            // 一定可以转回去的, 所以可以强转
            o = t.init(nilLiteral: ()) as! T
        }
    }
}

///
/// 解包
///
public func unwraps(_ v: Any) -> Any {
    // 获取类型
    var t = v
    var m = Mirror(reflecting: v)
    // 这是可选?
    while m.displayStyle == .optional && m.children.count != 0 {
        t = m.children.first!.value
        m = Mirror(reflecting: t)
    }
    // 完成
    return t
}

///
/// 安全的下转
/// 主要解决在继承时返回Self类型, 时的转换问题
///
public func downcast<T>(o: Any) -> T? {
    return o as? T
}


// MARK: - Private Function

///
/// 序列化(内部函数)
///
/// - parameter o: 需要序列化的对象
/// - returns: 如果返回nil, 序列化失败 \
///            内部类型: NSNull, NSNumber, NSString, NSArray, NSDictionary
///
func _serialize(_ o: Any) -> Any? {
    // 如果支持Serializeable, 让它自己处理
    if let o = o as? Serializeable {
        return o.serialize()
    }
    // 反射
    let m: Mirror = Mirror(reflecting: o)
    // 只处理`Struct`和`Class`
    guard m.displayStyle == .struct || m.displayStyle == .class else {
        // 其他忽略
        return nil
    }
    // 序列化的结果是NSDictionary
    let dic = NSMutableDictionary()
    // 反射
    var t: Mirror! = m
    while t != nil {
        // 遍历元素
        for c in m.children {
            // 名字不能为空.
            guard let k = c.label else {
                // skip
                continue
            }
            // 反序列化()
            if let v = _serialize(c.value) {
                dic[k] = v
            }
        }
        t = t.superclassMirror
    }
    // 完成
    return dic
}

///
/// 序列化(内部函数, 未实现)
///
/// - parameter o: 需要序列化的对象
/// - parameter t: 指定对象的KEY
/// - returns: 如果返回nil, 序列化失败 \
///            内部类型: NSNull, NSNumber, NSString, NSArray, NSDictionary
///
func _serialize(_ o: Any, _ t: Any.Type) -> AnyObject? {
    return nil
}

///
/// 反序列化(内部函数)
///
/// - parameter o: 解释后的数据(JSON/XML/...) \
///                内部类型: NSNull, NSNumber, NSString, NSArray, NSDictionary
/// - parameter t: 目标类型
/// - returns: 如果返回nil, 反序列化失败
///
func _deserialize(_ o: Any, _ t: Any.Type) -> Any? {
    // 如果是NSNull, 不需要处理.
    if o is NSNull {
        return nil
    }
    // 如果是NSObject, 由库处理
    if let t = t as? NSObject.Type {
        // 如果T的类型为src, 不用解析
        // NOTE: 如果T为NSObject(所有的都将被匹配)
        // 如: NSNull, NSNumber, NSString, NSArray, NSDictionary
        if (o as AnyObject).isKind(of: t) {
            return o
        }
        // 直接让他自己去处理
        return t.deserialize(o)
    }
    // 如果支持Codeable和Buildable(必须的否则无法创建对象), 由库处理
    if let t = t as? (Buildable & Codeable.Type) {
        // 只处理NSDictionary的
        guard let dic = o as? NSDictionary, dic.count != 0 else {
            return nil
        }
        // 创建对象
        var tmp = t.init()
        // 反射
        var m: Mirror! = Mirror(reflecting: tmp)
        while m != nil {
            // 遍历元素
            for c in m.children {
                // 名字不能为空.
                guard let k = c.label, let v = dic[k] else {
                    // skip
                    continue
                }
                // 反序列化()
                let r = _deserialize(v, type(of: c.value))
                // 更新value
                tmp.setValue(r, forSerialize: k)
            }
            m = m?.superclassMirror
        }
        // 完成
        return tmp
    }
    // 如果支持Serializeable, 它自己处理
    if let t = t as? Serializeable.Type {
        return t.deserialize(o)
    }
    // 失败.
    return nil
}

// MARK: - Swift Buildt-in Template Extension

extension Set : Serializeable {
    ///
    /// 序列化
    ///
    /// - returns: 如果`Element`支持序列化, 对其序列化(结果为NSArray), 否则为nil
    ///
    public func serialize() -> Any? {
        // 序列化的结果为NSArray
        let arr = NSMutableArray()
        for e in self {
            // 为每个元素进行序列化
            if let o = _serialize(e) {
                arr.add(o)
            }
        }
        // 如果没有元素, 视为失败
        return arr.count != 0 ? arr : nil
    }
    ///
    /// 序列化
    ///
    /// - parameter o: 支持NSArray
    /// - returns: 如果`Element`支持反序列化, 对其反序列化, 否则为nil
    ///
    public static func deserialize(_ o: Any) -> Set? {
        // 参数必须是NSArray
        guard let arr = o as? NSArray else {
            return nil
        }
        // 如果`Element`是AnyObject不需要处理
        if Element.self == AnyObject.self {
            return o as? Set<Element>
        }
        // 结果为Set<Element>
        var tmp = Set<Element>()
        for e in arr {
            // 为每个元素反序列化
            if let o = _deserialize(e, Element.self) as? Element {
                tmp.insert(o)
            }
        }
        return tmp
    }
}
extension Array : Serializeable {
    ///
    /// 序列化
    ///
    /// - returns: 如果`Element`支持序列化, 对其序列化(结果为NSArray), 否则为nil
    ///
    public func serialize() -> Any? {
        // 序列化的结果为NSArray
        let arr = NSMutableArray()
        for e in self {
            // 为每个元素进行序列化
            if let o = _serialize(e) {
                arr.add(o)
            }
        }
        // 如果没有元素, 视为失败
        return arr.count != 0 ? arr : nil
    }
    ///
    /// 序列化
    ///
    /// - parameter o: 支持NSArray
    /// - returns: 如果`Element`支持反序列化, 对其反序列化, 否则为nil
    ///
    public static func deserialize(_ o: Any) -> Array? {
        // 参数必须是NSArray
        guard let arr = o as? NSArray else {
            return nil
        }
        // 如果`Element`是AnyObject不需要处理
        if Element.self == AnyObject.self {
            return o as? Array<Element>
        }
        // 结果为Array<Element>
        var tmp = Array<Element>()
        for e in arr {
            // 为每个元素反序列化
            if let o = _deserialize(e, Element.self) as? Element {
                tmp.append(o)
            }
        }
        return tmp
    }
}
extension Dictionary : Serializeable {
    ///
    /// 序列化
    ///
    /// - returns: 如果`Key`支持转换为NSString \
    ///            如果`Value`支持序列化, 对其序列化(结果为NSDictionary), 否则为nil
    ///
    public func serialize() -> Any? {
        // 序列化的结果是NSDictionary
        let dic = NSMutableDictionary()
        for (k, v) in self {
            // 第一步序列化key
            if let k = _serialize(k) {
                // 只支持转换为`NSString`
                guard let k = NSString.deserialize(k) else {
                    continue
                }
                // 第二步为每个`Value`进行序列化
                if let v = _serialize(v) {
                    dic[k] = v
                }
            }
        }
        // 如果没有元素, 视为失败
        return dic.count != 0 ? dic : nil
    }
    ///
    /// 反序列化
    ///
    /// - parameter o: 只支持NSDictionary
    /// - returns: 如果`Key`支持从NSNumber/NSString转换
    ///            如果`Value`支持反序列化, 对其反序列化, 否则为nil
    ///
    public static func deserialize(_ o: Any) -> Dictionary? {
        // 参数必须是NSDictionary
        guard let dic = o as? NSDictionary else {
            return nil
        }
        // 如果`Element`是AnyObject不需要处理
        if Value.self == AnyObject.self {
            return o as? Dictionary<Key, Value>
        }
        // 反序列化的结果是Dictionary
        var tmp = Dictionary<Key, Value>()
        for (k, v) in dic {
            // 第一步反序列化`Key`
            if let k = _deserialize(k, Key.self) as? Key {
                // 第二步反序列化`Value`
                if let v = _deserialize(v, Value.self) as? Value {
                    tmp[k] = v
                }
            }
        }
        return tmp
    }
}

extension Optional : Serializeable {
    ///
    /// 序列化
    ///
    /// - returns: 如果`Wrapped`支持序列化, 对其序列, 否则为nil
    ///
    public func serialize() -> Any? {
        // 如果为空就没有意义了
        guard let o = self else {
            return nil
        }
        // 如果`Wrapped`支持序列化.
        // 继续序列化
        return _serialize(o)
    }
    ///
    /// 反序列化
    ///
    /// - parameter o: 支持任意参数
    /// - returns: 如果`Wrapped`支持反序列化, 对其反序列, 否则为nil
    ///
    public static func deserialize(_ o: Any) -> Optional? {
        // 如果`Wrapped`支持反序列化.
        // 继续反序列化
        if let tmp = _deserialize(o, Wrapped.self) as? Wrapped {
            // 这个结果会被打包两次, 变成Optional<Optional<Wrapped>>, 好郁闷
            return tmp
        }
        // 否则失败.
        return nil
    }
}

// MARK: - Swift Buildt-in Type Extension

extension Int : Serializeable {
    ///
    /// 序列化
    ///
    public func serialize() -> Any? {
        return NSNumber(value: self)
    }
    ///
    /// 反序列化
    ///
    public static func deserialize(_ o: Any) -> Int? {
        // 如果可以的话转换一下..
        if let number = NSNumber.deserialize(o) {
            return number.intValue
        }
        return nil
    }
}
extension Int8 : Serializeable {
    ///
    /// 序列化
    ///
    public func serialize() -> Any? {
        return NSNumber(value: self)
    }
    ///
    /// 反序列化
    ///
    public static func deserialize(_ o: Any) -> Int8? {
        // 如果可以的话转换一下..
        if let number = NSNumber.deserialize(o) {
            return number.int8Value
        }
        return nil
    }
}
extension Int16 : Serializeable {
    ///
    /// 序列化
    ///
    public func serialize() -> Any? {
        return NSNumber(value: self)
    }
    ///
    /// 反序列化
    ///
    public static func deserialize(_ o: Any) -> Int16? {
        // 如果可以的话转换一下..
        if let number = NSNumber.deserialize(o) {
            return number.int16Value
        }
        return nil
    }
}
extension Int32 : Serializeable {
    ///
    /// 序列化
    ///
    public func serialize() -> Any? {
        return NSNumber(value: self)
    }
    ///
    /// 反序列化
    ///
    public static func deserialize(_ o: Any) -> Int32? {
        // 如果可以的话转换一下..
        if let number = NSNumber.deserialize(o) {
            return number.int32Value
        }
        return nil
    }
}
extension Int64 : Serializeable {
    ///
    /// 序列化
    ///
    public func serialize() -> Any? {
        return NSNumber(value: self)
    }
    ///
    /// 反序列化
    ///
    public static func deserialize(_ o: Any) -> Int64? {
        // 如果可以的话转换一下..
        if let number = NSNumber.deserialize(o) {
            return number.int64Value
        }
        return nil
    }
}
extension UInt : Serializeable {
    ///
    /// 序列化
    ///
    public func serialize() -> Any? {
        return NSNumber(value: self)
    }
    ///
    /// 反序列化
    ///
    public static func deserialize(_ o: Any) -> UInt? {
        // 如果可以的话转换一下..
        if let number = NSNumber.deserialize(o) {
            return number.uintValue
        }
        return nil
    }
}
extension UInt8 : Serializeable {
    ///
    /// 序列化
    ///
    public func serialize() -> Any? {
        return NSNumber(value: self)
    }
    ///
    /// 反序列化
    ///
    public static func deserialize(_ o: Any) -> UInt8? {
        // 如果可以的话转换一下..
        if let number = NSNumber.deserialize(o) {
            return number.uint8Value
        }
        return nil
    }
}
extension UInt16 : Serializeable {
    ///
    /// 序列化
    ///
    public func serialize() -> Any? {
        return NSNumber(value: self)
    }
    ///
    /// 反序列化
    ///
    public static func deserialize(_ o: Any) -> UInt16? {
        // 如果可以的话转换一下..
        if let number = NSNumber.deserialize(o) {
            return number.uint16Value
        }
        return nil
    }
}
extension UInt32 : Serializeable {
    ///
    /// 序列化
    ///
    public func serialize() -> Any? {
        return NSNumber(value: self)
    }
    ///
    /// 反序列化
    ///
    public static func deserialize(_ o: Any) -> UInt32? {
        // 如果可以的话转换一下..
        if let number = NSNumber.deserialize(o) {
            return number.uint32Value
        }
        return nil
    }
}
extension UInt64 : Serializeable {
    ///
    /// 序列化
    ///
    public func serialize() -> Any? {
        return NSNumber(value: self)
    }
    ///
    /// 反序列化
    ///
    public static func deserialize(_ o: Any) -> UInt64? {
        // 如果可以的话转换一下..
        if let number = NSNumber.deserialize(o) {
            return number.uint64Value
        }
        return nil
    }
}
extension Float : Serializeable {
    ///
    /// 序列化
    ///
    public func serialize() -> Any? {
        return NSNumber(value: self)
    }
    ///
    /// 反序列化
    ///
    public static func deserialize(_ o: Any) -> Float? {
        // 如果可以的话转换一下..
        if let number = NSNumber.deserialize(o) {
            return number.floatValue
        }
        return nil
    }
}
extension Double : Serializeable {
    ///
    /// 序列化
    ///
    public func serialize() -> Any? {
        return NSNumber(value: self)
    }
    ///
    /// 反序列化
    ///
    public static func deserialize(_ o: Any) -> Double? {
        // 如果可以的话转换一下..
        if let number = NSNumber.deserialize(o) {
            return number.doubleValue
        }
        return nil
    }
}
extension Bool : Serializeable {
    ///
    /// 序列化
    ///
    public func serialize() -> Any? {
        return NSNumber(value: self)
    }
    ///
    /// 反序列化
    ///
    public static func deserialize(_ o: Any) -> Bool? {
        // 如果可以的话转换一下..
        if let number = NSNumber.deserialize(o) {
            return number.boolValue
        }
        return nil
    }
}
extension String : Serializeable {
    ///
    /// 序列化
    ///
    public func serialize() -> Any? {
        return self
    }
    ///
    /// 反序列化
    ///
    public static func deserialize(_ o: Any) -> String? {
        // 如果可以的话转换一下..
        if let str = NSString.deserialize(o) {
            return str as String
        }
        return nil
    }
}

// MARK: - OC Buildt-in Type Extension

extension NSObject : Serializeable {
    ///
    /// 序列化
    ///
    /// - returns: 序列化为NSDictionary, 出错则为空
    ///
    public func serialize() -> Any? {
        // 序列化的结果是NSDictionary
        let dic = NSMutableDictionary()
        // 反射
        var m: Mirror! = Mirror(reflecting: self)
        while m != nil {
            // 遍历元素
            for v in m.children {
                // 名字不能为空.
                guard let k = v.label else {
                    continue
                }
                // 序列化value
                if let v = _serialize(v.value) {
                    dic[k] = v
                }
            }
            m = m?.superclassMirror
        }
        // ok
        return dic.count != 0 ? dic : nil
    }
    ///
    /// 反序列化
    ///
    /// - parameter o: 只支持NSDictionary
    ///
    public class func deserialize(_ o: Any) -> Self? {
        // 只处理NSDictionary的
        guard let dic = o as? NSDictionary, dic.count != 0 else {
            return nil
        }
        // 创建对象
        let tmp = self.init()
        // 反射
        var m: Mirror! = Mirror(reflecting: tmp)
        while m != nil {
            // 遍历元素
            for c in m.children {
                // 名字不能为空.
                guard let k = c.label, let v = dic[k] else {
                    // skip
                    continue
                }
                // 反序列化()
                let r = _deserialize(v, type(of: c.value))
                // 检查是不是原生支持kvc
                if tmp.responds(to: Selector(k)) {
                    // 必须不为空
                    guard let r = r else {
                        continue
                    }
                    // 原生支持.
                    // 去掉所有Optional
                    if let o = unwraps(r) as? NSObject {
                        tmp.setValue(o, forKey: k)
                    } else if Mirror(reflecting: r).displayStyle == .enum {
                        // 如果是Enum, 还需要做多一个处理. 因为Enum不能转为AnyObject
                        if let o = (r as? Serializeable)?.serialize() {
                            tmp.setValue(o, forKey: k)
                        }
                    }
                } else {
                    // 原生不支持(例如: Enum, Struct, Tuple, Optional).
                    // 检查是否可以使用`Codeable`协议
                    if var tmp = tmp as? Codeable {
                        tmp.setValue(r, forSerialize: k)
                    }
                }
            }
            m = m.superclassMirror
        }
        // 完成
        return tmp
    }
}

extension NSNull {
    ///
    /// 序列化
    ///
    public override func serialize() -> Any? {
        return nil
    }
    ///
    /// 反序列化, 提供一些转换
    ///
    public override class func deserialize(_ o: Any) -> NSNull? {
        return nil
    }
}

extension NSNumber {
    ///
    /// 反序列化, 提供一些转换
    ///
    public override class func deserialize(_ o: Any) -> NSNumber? {
        // 是number
        if let number = o as? NSNumber {
            return number
        }
        // 是string
        if let str = o as? NSString {
            // 方法1:
            // // String and NSString
            // let sc = NSScanner(string: s as String)
            // var n: Double = 0
            // if sc.scanDouble(&n) {
            //     return n
            // }
            // 方法2:
            // 可能要指定一些格式
            let nf = NumberFormatter()
            // 使用转换器直接转换
            return nf.number(from: str as String)
        }
        // 未知
        return nil
    }
}

extension NSString {
    ///
    /// 反序列化, 提供一些转换
    ///
    public override class func deserialize(_ o: Any) -> NSString? {
        // 是string
        if let str = o as? NSString {
            return str
        }
        // 是number
        if let number = o as? NSNumber {
            return number.stringValue as NSString
        }
        // 未知
        return nil
    }
}

extension NSSet {
    ///
    /// 序列化
    ///
    public override func serialize() -> Any? {
        return self.allObjects
    }
    ///
    /// 反序列化, 提供一些转换
    ///
    public override class func deserialize(_ o: Any) -> NSSet? {
        if let arr = o as? NSArray {
            return NSSet(array: arr as [AnyObject])
        }
        return nil
    }
}

extension NSArray {
    ///
    /// 反序列化, 提供一些转换
    ///
    public override class func deserialize(_ o: Any) -> NSArray? {
        return o as? NSArray
    }
}

extension NSDictionary {
    ///
    /// 反序列化, 提供一些转换
    ///
    public override class func deserialize(_ o: Any) -> NSDictionary? {
        return o as? NSDictionary
    }
}

extension NSURL {
    ///
    /// 序列化
    ///
    public override func serialize() -> Any? {
        return self.absoluteString
    }
    ///
    /// 反序列化, 提供一些转换
    ///
    public override class func deserialize(_ o: Any) -> NSURL? {
        if let str = NSString.deserialize(o) {
            return NSURL(string: str as String)
        }
        return nil
    }
}

extension NSDate {
    ///
    /// 序列化 => 日期 => NSString
    ///
    public override func serialize() -> Any? {
        // 可能需要更多格式
        let df = DateFormatter()
        //
        df.dateStyle = .medium
        df.timeStyle = .medium
        // 格式化
        return df.string(from: self as Date)
    }
    ///
    /// 反序列化 <= 时间戳/日期 <= NSString
    ///
    public override class func deserialize(_ o: Any) -> NSDate? {
        // 字符串
        if let str = o as? NSString {
            // 可能需要更多格式
            let df = DateFormatter()
            //
            df.dateStyle = .medium
            df.timeStyle = .medium
            // 格式化
            return df.date(from: str as String) as NSDate?
        }
        // 数字
        if let number = o as? NSNumber {
            // 直接认为是时间戳
            return NSDate(timeIntervalSince1970: number.doubleValue)
        }
        // 其他都失败
        return nil
    }
}

extension NSData {
    ///
    /// 序列化
    ///
    /// - returns: base64转换为NSString, 任意步骤失败结果为nil
    ///
    public override func serialize() -> Any? {
        // 直接base编码
        return base64EncodedString()
    }
    ///
    /// 反序列化
    ///
    /// - parameter o: 只支持NSString
    /// - returns: 如果`o`是base64编码的字符串, 对其反序列化, 否则为nil
    ///
    public override class func deserialize(_ o: Any) -> NSData? {
        // 这是字符串
        if let str = o as? NSString {
            // 直接解码
            return NSData(base64Encoded: str as String)
        }
        return nil
    }
}

// MARK: - CG Buildt-in Extension

extension CGFloat : Serializeable {
    ///
    /// 序列化
    ///
    public func serialize() -> Any? {
        return Double(native).serialize()
    }
    ///
    /// 反序列化
    ///
    public static func deserialize(_ o: Any) -> CGFloat? {
        if let number = Double.deserialize(o) {
            return CGFloat(number)
        }
        return nil
    }
}

// MARK: - UIKit Buildt-in Extension

extension UIImage {
    ///
    /// 序列化
    ///
    /// - returns: 先序列化为Data(PNG), 然后再base64转换为NSString, 任意步骤失败结果为nil
    ///
    public override func serialize() -> Any? {
        // 直接压缩传输
        return UIImagePNGRepresentation(self).serialize()
    }
    ///
    /// 反序列化
    ///
    /// - parameter o: 只支持NSString
    /// - returns: 如果`o`是base64编码的字符串, 对其反序列化, 否则为nil
    ///
    public override class func deserialize(_ o: Any) -> UIImage? {
        if let data = NSData.deserialize(o) {
            return UIImage(data: data as Data)
        }
        return nil
    }
}

// MARK: - swift 3.0 support

extension URL: Serializeable {
    public func serialize() -> Any? {
        return (self as NSURL).serialize()
    }
    public static func deserialize(_ o: Any) -> URL? {
        return NSURL.deserialize(o) as? URL
    }
}
extension Date: Serializeable {
    public func serialize() -> Any? {
        return (self as NSDate).serialize()
    }
    public static func deserialize(_ o: Any) -> Date? {
        return NSDate.deserialize(o) as? Date
    }
}
extension Data: Serializeable {
    public func serialize() -> Any? {
        return (self as NSData).serialize()
    }
    public static func deserialize(_ o: Any) -> Data? {
        return NSData.deserialize(o) as? Data
    }
}
