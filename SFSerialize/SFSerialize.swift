//
//  SFSerialize.swift
//
//  Created by sagesse on 6/2/15.
//  Copyright (c) 2015 Sagesse. All rights reserved.
//

import UIKit

// Class                支持, 自动推断类型
// Aggregate            支持, 自动推断元素
// IndexContainer       支持, 自动推断元素 + 代理
// KeyContainer         支持, 自动推断KV类型 + 代理 
// ObjCObject           支持, 自动推断类型
// Optional             部分支持(@objc导出), 自动推断V类型 + 代理 
// Enum                 部分支持(@objc导出)
// Struct               不支持, 原因: 无KVC
// Tuple                不支持, 原因: 无KVC
// Container            不支持, 原因: 未知类型
// MembershipContainer  不支持, 原因: 未知类型

///
/// 反序列化(普通)
/// 
/// :param: jsonPath json文件的路径
/// :returns: nil表示转换失败
///
public func unserialize<T>(#jsonPath: String) -> T? {
    
    return unserialize(jsonData: NSData(contentsOfFile: jsonPath))
}

///
/// 反序列化(普通)
///
/// :param: jsonData json的原始数据
/// :returns: nil表示转换失败
///
public func unserialize<T>(#jsonData: NSData!) -> T? {
    
    if jsonData == nil {
        return nil
    }
    
    return unserialize(json: NSJSONSerialization.JSONObjectWithData(jsonData, options: .AllowFragments, error: nil))
}

///
/// 反序列化(普通)
///
/// :param: json json数据 
/// :returns: nil表示转换失败
///
public func unserialize<T>(#json: AnyObject!) -> T? {
    return _sf_unserialize(json, T.self) as? T
}


/// MARK: - /// base

///
/// 用名字获取类(class)
///
private func _sf_class(#name:String) -> Any.Type? {
    
    // 这是组.
    if name.hasPrefix("(") && name.hasSuffix(")") {
        return (Any).self
    }
    
    // 检查前缀
    for (k, v) in nm.prefixs {
        if name.hasPrefix(k) {
            return v
        }
    }
    
    // 偿试匹配
    return nm.load().types[name] as? Any.Type
}

///
/// 反射完整的类型
///
private func _sf_reflect(ob:Any) -> [(String, MirrorType)] {
    
    let mt = reflect(ob)
    var rs = [(String, MirrorType)]()
    let type = ob.dynamicType as? NSObject.Type
    
    for i in 0 ..< mt.count {
        // super字段表示存在基类
        let n = mt[i]
        if (n.0 == "super") {
            // 只处理NSObject为父类的
            if let spt = type?.superclass() as? NSObject.Type {
                // 先创建一个子对象
                var spr = _sf_reflect(spt())
                for m in rs {
                    spr.append(m)
                }
                rs = spr
            }
        } else {
            // ok
            rs.append(n)
        }
    }
    
    return rs
}

/// MARK: - /// convert

///
/// swift类型=>oc类型
///
private func _sf_convertOfType(type: Any.Type!) -> NSObject.Type? {
    
    // 空
    if (type == nil) {
        return nil
    }
    
    // 不需要提供特殊转换
    if type is NSObject.Type {
        return type as? NSObject.Type
    }
    
    // 需要转换
    switch type {
        
    case is String.Type:
        
        // String = NSString + 二次转换(as)
        return NSString.self
        
    case is Int.Type,
         is UInt.Type,
         is Float.Type,
         is Double.Type,
         is CGFloat.Type,
         is Bool.Type:
        
        // Bool, Int, UInt, Float, Double, CGFloat = NSNumber + 二次转换(as)
        return NSNumber.self
        
    case is Int8.Type,
         is Int16.Type,
         is Int32.Type,
         is Int64.Type,
         is UInt8.Type,
         is UInt16.Type,
         is UInt32.Type,
         is UInt64.Type:
        
        // Int8/16/32/64, UInt8/16/32/64, Float80 =  NSNumber + 二次转换(显式)
        return NSNumber.self
        
    default:
        
        // 失败
        return nil
    }
}

///
/// 偿试转换为指定类型
///
private func _sf_convertOfValue(src:AnyObject, dstType: Any.Type) -> AnyObject? {
    
    // oc类型
    if let type = dstType as? NSObject.Type {
        // 如果T的类型为src, 不用解析
        // NOTE: 如果T为NSObject(所有的都将被匹配)
        // 如: NSNull, NSNumber, NSString, NSArray, NSDictionary
        if src.isKindOfClass(type) {
            return src
        }
    }
    
    // 需要转换
    switch dstType {
        
    case is String.Type:        return _sf_convertOfString(src) as? String
    case is NSString.Type:      return _sf_convertOfString(src)
        
    case is Int.Type:           return _sf_convertOfNumber(src) as? Int
    case is UInt.Type:          return _sf_convertOfNumber(src) as? UInt
    case is Float.Type:         return _sf_convertOfNumber(src) as? Float
    case is Float32.Type:       return _sf_convertOfNumber(src) as? Float32
    case is Float64.Type:       return _sf_convertOfNumber(src) as? Float64
    case is CGFloat.Type:       return _sf_convertOfNumber(src) as? CGFloat
    case is Bool.Type:          return _sf_convertOfNumber(src) as? Bool
    case is NSNumber.Type:      return _sf_convertOfNumber(src)
        
    default:
        return nil
    }
}

///
/// 强制转换为字符串
///
private func _sf_convertOfString(src:AnyObject) -> NSString? {
    if let s = src as? NSString {
        return s
    } else if let n = src as? NSNumber {
        return n.stringValue
    } else {
        return nil
    }
}

///
/// 强制转换为number
///
private func _sf_convertOfNumber(src:AnyObject) -> NSNumber? {
    if let n = src as? NSNumber {
        return n
    } else if let s = src as? NSString {
        let sc = NSScanner(string: s as! String)
        var n:Double = 0
        if sc.scanDouble(&n) {
            return n
        }
        return nil
    } else {
        return nil
    }
}


/// MARK: - /// unserialize of json

private func _sf_unserialize(src: AnyObject!, dstType: Any.Type) -> AnyObject? {
  
    // 检查参数
    if src == nil || src is NSNull {
        return nil
    }
    
    // oc类型
    if let type = dstType as? NSObject.Type {
        
        // 如果T的类型为src, 不用解析
        // NOTE: 如果T为NSObject(所有的都将被匹配)
        // 如: NSNull, NSNumber, NSString, NSArray, NSDictionary
        if src.isKindOfClass(type) {
            return src
        }
        
        // 如果T的类型为null, 返回nil 防止错误
        if type is NSNull.Type {
            return nil
        }
        
        // 如果T的类型为字符串, 试着转换
        if type is NSString.Type {
            // NSNumber 可以试着转为字符串
            // NSString 己经偿试过转换了
            return _sf_convertOfString(src)
        }
        
        // 如果T的类型为数字, 试着转换
        if type is NSNumber.Type {
            // NSNumber 己经偿试过转换了
            // NSString 可以试着转为数字
            return _sf_convertOfNumber(src)
        }
        
        // 如果T的类型为数组, 不用解析
        if type is NSArray.Type {
            // NSArray 己经偿试过转换了
            // 错误的.
            return nil
        }
        
        // 如果T的类型为字典, 不用解析 
        if type is NSDictionary.Type {
            // NSDictionary 己经偿试过转换了
            // 错误的.
            return nil
        }
        
        // 如果T的类型以上都不是, 那肯定是自定义类型了. 进行反射
        // 但前提是src类型为NSDictionary, 否则解释不了.
        if !src.isKindOfClass(NSDictionary.self) {
            return nil
        }
        
        // 进行反射:)
        var o = type()
        let rs = _sf_reflect(o)
        
        // 遍历
        for (n, sm) in rs {
            
            let val = (src as! NSDictionary)[n] as? NSObject
            // 如果没有这个键, 或者是null, 忽略
            if (val == nil || val!.isKindOfClass(NSNull.self)) {
                continue
            }

            // Class                支持, 自动推断类型
            // Aggregate            支持, 自动推断元素
            // IndexContainer       支持, 自动推断元素 + 代理
            // KeyContainer         支持, 自动推断KV类型 + 代理 
            // ObjCObject           支持, 自动推断类型
            // Optional             部分支持(@objc导出), 自动推断V类型 + 代理 
            // Enum                 部分支持(@objc导出)
            // Struct               不支持, 原因: 无KVC
            // Tuple                不支持, 原因: 无KVC
            // Container            不支持, 原因: 未知类型
            // MembershipContainer  不支持, 原因: 未知类型
            switch sm.disposition {
                
            case .Class: // 自定义类
                
                // 偿试解析
                if let v: AnyObject = _sf_unserialize(val, sm.valueType) {
                    o.setValue(v, forKey: n)
                }
                
            case .Aggregate: // 基本类型
                
                // 数组/字典, 都转换不了
                // 其他的可以由底层库直接转换
                if !(val is NSArray) && !(val is NSDictionary) {
                    o.setValue(val, forKey: n)
                }
                
            case .IndexContainer: // 数组
                
                // 必须是数组类型, 否则忽略
                if !(val is NSArray) {
                    continue
                }
                
                // 偿试解析
                if let v: AnyObject = _sf_unserialize(val, "\(sm.valueType)") {
                    // 成功
                    o.setValue(v, forKey: n)
                } else {
                    // 需要启动第二套方案(代理)?
                }
                
            case .KeyContainer: // 字典
                
                // 必须是字典类型, 否则忽略
                if !(val is NSDictionary) {
                    continue
                }
                
                // 偿试解析
                if let v: AnyObject = _sf_unserialize(val, "\(sm.valueType)") {
                    // 成功
                    o.setValue(v, forKey: n)
                } else {
                    // 需要启动第二套方案(代理)?
                }
                
            case .Optional: // 可选类型
                
                // 偿试解析
                if let v: AnyObject = _sf_unserialize(val, "\(sm.valueType)") {
                    // 成功
                    o.setValue(v, forKey: n)
                } else {
                    // 需要启动第二套方案(代理)?
                }
                
            case .ObjCObject: // oc类型
                
                // NSNumber的情况只能在这里处理
                if sm.valueType is NSNumber.Type {
                    // 数组/字典, 都转换不了
                    if !(val is NSArray) && !(val is NSDictionary) {
                        o.setValue(val, forKey: n)
                    }
                } else {
                    // 还有没有测试过的
                    println("\(n): No Support ObjCObject \(sm.valueType)")
                }
                
            case .Enum:                 println("\(n): No Support Enum \(sm.valueType)")
            case .Struct:               println("\(n): No Support Struct \(sm.valueType)")
            case .Tuple:                println("\(n): No Support Tuple \(sm.valueType)")
            case .Container:            println("\(n): No Support Container \(sm.valueType)")
            case .MembershipContainer:  println("\(n): No Support MembershipContainer \(sm.valueType)")
            }
        }
        
        // 结束
        return o
    }
    
    // 其他类型.
    if let v:AnyObject = _sf_convertOfValue(src, dstType) {
        return v
    }
    
    // 获取.
    let dstTypeName = "\(dstType)"
    
    // 如果有数组/字典/可选
    if (dstTypeName.hasPrefix("Swift.Array")
        || dstTypeName.hasPrefix("Swift.Optional")
        || dstTypeName.hasPrefix("Swift.Dictionary")) {
            _sf_unserialize(src, dstTypeName)
    }
    
    return nil
}

///
/// 反序列化(对象)
///
private func _sf_unserialize(src: AnyObject!, dstTypeName: String) -> AnyObject? {
    
    // 空
    if src == nil {
        return nil
    }
    
    // 如果是Array, ex
    if dstTypeName.hasPrefix("Swift.Array") {
        
        // 获取元素类型.
        // a0: Swift.Array<protocol<>> - 错误的, 无法使用dynamic导出
        // a1: Swift.Array<Swift.Int>
        // o2: Swift.Array<Swift.AnyObject>
        // a3: Swift.Array<Swift.Optional<Swift.Int>> - 错误的, 无法使用dynamic导出 
        // a4: Swift.Array<Swift.Dictionary<Swift.Int, Swift.Int>>
        if let b = dstTypeName.rangeOfString("<") {
            if let e = dstTypeName.rangeOfString(">", options: NSStringCompareOptions.BackwardsSearch) {
                // 新的类型.
                let etype = dstTypeName.substringWithRange(Range(start: b.endIndex, end: e.startIndex))
                // 继续处理.
                return _sf_unserializeOfArray(src, etype)
            }
        }
        
        // 转换失败
        return nil
    }
    
    // 如果是Optional, ex
    if dstTypeName.hasPrefix("Swift.Optional") {
        
        // 其实是忽略.
        // o0: Swift.Optional<protocol<>> - 错误的, 无法使用dynamic导出 
        // o1: Swift.Optional<Swift.Int> - 错误的, 无法使用dynamic导出 
        // o2: Swift.Optional<Swift.AnyObject>
        // o3: Swift.Optional<Swift.Array<Swift.Int>>
        // o4: Swift.Optional<Swift.Dictionary<Swift.Int, Swift.Int>>
        if let b = dstTypeName.rangeOfString("<") {
            if let e = dstTypeName.rangeOfString(">", options: NSStringCompareOptions.BackwardsSearch) {
                // 新的类型.
                let vtype = dstTypeName.substringWithRange(Range(start: b.endIndex, end: e.startIndex))
                // 继续处理.
                return _sf_unserialize(src, vtype)
            }
        }
        
        // 转换失败
        return nil
    }
    
    // 如果是Dictionary, ex
    if dstTypeName.hasPrefix("Swift.Dictionary") {
        
        // 获取K/V类型
        // d0: Swift.Dictionary<Swift.Int, protocol<>> - 错误的, 无法使用dynamic导出 
        // d1: Swift.Dictionary<Swift.Int, Swift.AnyObject>
        // d2: Swift.Dictionary<Swift.Int, Swift.Optional<Swift.AnyObject>> - 错误的, 无法使用dynamic导出 
        // d3: Swift.Dictionary<Swift.Int, Swift.Array<Swift.AnyObject>>
        // d4: Swift.Dictionary<Swift.Int, Swift.Dictionary<Swift.Int, Swift.AnyObject>>
        if let b = dstTypeName.rangeOfString("<") {
            if let e = dstTypeName.rangeOfString(">", options: NSStringCompareOptions.BackwardsSearch) {
                if let m = dstTypeName.rangeOfString(", ", options: NSStringCompareOptions.allZeros, range: Range(start: b.endIndex, end: e.startIndex)) {
                    // 获取Key类型
                    var ktype = dstTypeName.substringWithRange(Range(start: b.endIndex, end: m.startIndex))
                    // 获取Value类型
                    var vtype = dstTypeName.substringWithRange(Range(start: m.endIndex, end: e.startIndex))
                    // 继续处理.
                    return _sf_unserializeOfDictionary(src, ktype, vtype)
                }
            }
        }
        
        // 转换失败
        return nil
    }
    
    // 是否是识别的类
    if let type = _sf_class(name: dstTypeName) {
        return _sf_unserialize(src, type)
    }
    
    // 暂时处理不了...
    return nil
}

///
/// 反序列化(数组)
///
private func _sf_unserializeOfArray(src: AnyObject!, elementTypeName: String) -> AnyObject? {
    
    // 必须是数组
    if let arr = src as? NSArray {
        var rs = Array<AnyObject>()
        for o in arr {
            // 可能还需要再次解释
            if let s:AnyObject = _sf_unserialize(o, elementTypeName) {
                rs.append(s)
            }
        }
        return rs
    }
    
    // 转换失败
    return nil
}

///
/// 反序列化(字典)
///
private func _sf_unserializeOfDictionary(src: AnyObject, keyTypeName: String, valueTypeName: String) -> AnyObject? {
    
    // 必须是字典
    if let dic = src as? NSDictionary {
        // 获取到key的class
        if let kt = _sf_convertOfType(_sf_class(name: keyTypeName)) {
            var rs = Dictionary<NSObject, AnyObject>()
            for (k, v) in dic {
                // 转换为对应的值
                if let k = _sf_convertOfValue(k, kt) as? NSObject {
                    // 继续处理.
                    if let v:AnyObject = _sf_unserialize(v, valueTypeName) {
                        rs[k] = v
                    }
                }
            }
            return rs
        }
    }
    
    // 转换失败
    return nil
}

/// MARK: - /// util

//好像不需要呢.
//extension NSObject {
//    
//    ///
//    /// 获取类型, 为数组获取元素类型
//    ///
//    class func classOfArray(name:String) -> AnyClass? {
//        return nil
//    }
//    
//    ///
//    /// 获取类型, 为可选获取真实类型
//    ///
//    class func classOfOptional(name:String) -> AnyClass? {
//        return nil
//    }
//    
//    ///
//    /// 获取类型, 为字典获取key的类型
//    ///
//    class func classOfDictionaryKey(name:String) -> AnyClass? {
//        return nil
//    }
//    
//    ///
//    /// 获取类型, 为字典获取Value的类型
//    ///
//    class func classOfDictionaryValue(name:String) -> AnyClass? {
//        return nil
//    }
//}

extension NSString {
    
    ///
    /// 修正一个bug(xcode 6.3.1/iPad Retina)
    ///
    func longValue() -> CLong { return CLong(self.doubleValue) }
}

/// 映射表
private struct nm {
    
    /// 类型.
    static var types : [String:AnyClass] = [:]
    
    /// 前缀.
    static var prefixs : [String:Any.Type] = [
        
        "\(Any.self)"       : Any.self,
        "\(AnyClass.self)"  : AnyClass.self,
        "\(AnyObject.self)" : AnyObject.self,
        
        "\(Int.self)"       : Int.self,
        "\(Int8.self)"      : Int8.self,
        "\(Int16.self)"     : Int16.self,
        "\(Int32.self)"     : Int32.self,
        "\(Int64.self)"     : Int64.self,
        "\(UInt.self)"      : UInt.self,
        "\(UInt8.self)"     : UInt8.self,
        "\(UInt16.self)"    : UInt16.self,
        "\(UInt32.self)"    : UInt32.self,
        "\(UInt64.self)"    : UInt64.self,
        "\(Float.self)"     : Float.self,
        "\(Double.self)"    : Double.self,
        //"\(Float80.self)"   : Float80.self,
        
        "\(String.self)"    : String.self,
        
        "Swift.Array"       : Array<Any>.self,
        "Swift.Optional"    : Optional<Any>.self,
        "Swift.Dictionary"  : Dictionary<Int, Any>.self
    ]
    
    /// 加载
    static func load() -> nm.Type {
        var cnt = UInt32(objc_getClassList(nil, 0))
        // 如果数量发生变化, 重新加载.
        if Int(cnt) > self.types.count {
            let vp = objc_copyClassList(&cnt)
            for i in 0 ..< cnt {
                if let cls:AnyClass = vp[Int(i)] {
                    self.types["\(cls)"] = cls
                }
            }
        }
        // ok
        return self
    }
}

