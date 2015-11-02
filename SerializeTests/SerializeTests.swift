//
//  SFSerializeTests.swift
//  SFSerializeTests
//
//  Created by sagesse on 6/2/15.
//  Copyright (c) 2015 Sagesse. All rights reserved.
//

import UIKit
import XCTest

import Serialize

// 如果是自定义的类, 请继承于NSObject
class Example : NSObject {
    
    // 基础类型
    var val_int: Int = 0
    var val_bool: Bool = false
    var val_double: Double = 0
    var val_string: String?
    var val_array: [Int] = []
    var val_dictionary: [Int:Int] = [:]
    
    // 无效的类型
    //var val_int_invalid: Int?
    //var val_bool_invalid: Bool?
    //var val_doulbe_invalid: Double?
    //var val_array_invalid: [Int?]?
    //var val_dictionary_invalid: [Int:Int?]
    
    // 自定义类型
    var val_custom: Custom?
    var val_custom_array: [Custom]?
    var val_custom_dictionary: [String:Custom]?
    
    class Custom : NSObject {
        var val: Example?
    }
}

class T1 : NSObject
{
    @objc var t_stoi: Int = 0
    @objc var t_ftoi: Int = 0
    @objc var t_btoi: Int = 0
    @objc var t_atoi: Int = 0
    @objc var t_dtoi: Int = 0
    @objc var t_ntoi: Int = 0
          var t_oooi: Int?      // 错误的, 这将不能被kvc
    
    @objc var t_stob: Bool = false
    @objc var t_ftob: Bool = false
    @objc var t_btob: Bool = false
    @objc var t_atob: Bool = false
    @objc var t_dtob: Bool = false
    @objc var t_ntob: Bool = false
          var t_ooob: Bool?      // 错误的, 这将不能被kvc
    
    @objc var t_stos: String = ""
    @objc var t_ftos: String = ""
    @objc var t_btos: String = ""
    @objc var t_atos: String = ""
    @objc var t_dtos: String = ""
    @objc var t_ntos: String = ""
    
    @objc var t_stoos: String?
    @objc var t_ftoos: String?
    @objc var t_btoos: String?
    @objc var t_atoos: String?
    @objc var t_dtoos: String?
    @objc var t_ntoos: String?
    
    @objc var t_stoa: [Int] = []
    @objc var t_ftoa: [Int] = []
    @objc var t_btoa: [Int] = []
    @objc var t_atoa: [Int] = []
    @objc var t_dtoa: [Int] = []
    @objc var t_ntoa: [Int] = []
    
    @objc var t_stooa: [String]?
    @objc var t_ftooa: [String]?
    @objc var t_btooa: [String]?
    @objc var t_atooa: [String]?
    @objc var t_dtooa: [String]?
    @objc var t_ntooa: [String]?
    
    @objc var t_stod: [Int:Int] = [:]
    @objc var t_ftod: [Int:Int] = [:]
    @objc var t_btod: [Int:Int] = [:]
    @objc var t_atod: [Int:Int] = [:]
    @objc var t_dtod: [Int:Int] = [:]
    @objc var t_ntod: [Int:Int] = [:]
    
    @objc var t_stood: [Int:Int]?
    @objc var t_ftood: [Int:Int]?
    @objc var t_btood: [Int:Int]?
    @objc var t_atood: [Int:Int]?
    @objc var t_dtood: [Int:Int]?
    @objc var t_ntood: [Int:Int]?
    
    @objc var t_atoset = Set<Int>()
    @objc var t_atooset = Set<Int>?()
    
    @objc var t_dtot2: T2?
          var t_dtot3: T2.T3?
}

class T2 : NSObject {
    @objc var t_m : Double = 0
    
    class T3 : NSObject {
        @objc var t_m : String?
    }
}

class T4 : NSObject {
    var i : Int = 0
    var f : Float = 0
    var s : String = ""
    var oi : Int?
    var of : Float?
    var os : String?
    var a : [String] = []
    var oa : [Int]?
    var t3 : T2.T3?
    var d : [Int:Int] = [:]
    var od : [Int:Int]?
    var odn : [Int:Int]?
    
    var set = Set<Int>()
}

struct s1 {
}
enum e1 {
    case zero
}
class c1 {
}

class Test : NSObject {
    
    enum EI : Int {
        case S1 = 1
    }
    enum ES : String {
        case S1  = "te"
    }
    
    
    var ei = EI.S1
    // var es = ES.S1 // 错误 !!会发生异常
}

class SE1 : Buildable, Codeable {
    
    var a: Optional<Int> = nil
    var b: Optional<String> = nil
    var c: Optional<Array<Int>> = nil
    
    var u1: Optional<NSURL> = nil
    var u2: Optional<NSURL> = nil
    
   required init() {
    }
    
    func valueForSerialize(key: String) -> Any? {
        return nil
    }
    
    func setValue(value: Any?, forSerialize key: String) {
        switch key {
        case "a": assign(&a, value)
        case "b": assign(&b, value)
        case "c": assign(&c, value)
        case "u1": assign(&u1, value)
        case "u2": assign(&u2, value)
        default: break
        }
    }
}

extension SE1 : Hashable {
     var hashValue: Int {
        return unsafeAddressOf(self).hashValue
    }
}
func ==(lhs: SE1, rhs: SE1) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

class SE2 : Buildable, Codeable {
    
    var a: Optional<Int> = nil
    var b: Optional<String> = nil
    var c: Optional<Array<Int>> = nil
    
    var u1: Optional<NSURL> = nil
    var u2: Optional<NSURL> = nil
    
    required init() {
    }
    
    func valueForSerialize(key: String) -> Any? {
        return nil
    }
    
    func setValue(value: Any?, forSerialize key: String) {
        switch key {
        case "a": assign(&a, value)
        case "b": assign(&b, value)
        case "c": assign(&c, value)
        case "u1": assign(&u1, value)
        case "u2": assign(&u2, value)
        default: break
        }
    }
}

class SE3<T> : Buildable, Codeable {
    
    var a: Optional<Int> = nil
    var b: Optional<String> = nil
    var c: Optional<Array<Int>> = nil
    
    var u1: Optional<T> = nil
    var u2: Optional<T> = nil
    
    required init() {
    }
    
    func valueForSerialize(key: String) -> Any? {
        return nil
    }
    
    func setValue(value: Any?, forSerialize key: String) {
        switch key {
        case "a": assign(&a, value)
        case "b": assign(&b, value)
        case "c": assign(&c, value)
        case "u1": assign(&u1, value)
        case "u2": assign(&u2, value)
        default: break
        }
    }
}

class SerializeTests: XCTestCase {
    
    class E1 : NSObject, Codeable {
              var a: Optional<Int> = nil
        @objc var b: Optional<String> = nil
        @objc var c: Optional<Array<Int>> = nil
        
        @objc var u1: Optional<NSURL> = nil
        @objc var u2: Optional<NSURL> = nil
        
        func valueForSerialize(key: String) -> Any? {
            return nil
        }
        
        func setValue(value: Any?, forSerialize key: String) {
            switch key {
            case "a": assign(&a, value)
            default: break
            }
        }
    }
    
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /// 测试依赖
    func testDepends() {
        let i:Int = 0
        let f:Float = 0
        let d:Double = 0
        let s = s1()
        let e = e1.zero
        let c = c1()
        
        // 基础类型没有显示style
        XCTAssert(Mirror(reflecting: i).displayStyle == nil)
        XCTAssert(Mirror(reflecting: f).displayStyle == nil)
        XCTAssert(Mirror(reflecting: d).displayStyle == nil)
        //
        XCTAssert(Mirror(reflecting: s).displayStyle == .Struct)
        XCTAssert(Mirror(reflecting: e).displayStyle == .Enum)
        XCTAssert(Mirror(reflecting: c).displayStyle == .Class)
    }
    
    /// 测试解包
    func testUnwraps() {
        
        let o: Int?? = 0
        let n: Int?? = nil
        
        XCTAssert(unwraps(o).dynamicType is Int.Type)
        XCTAssert(unwraps(n).dynamicType is Optional<Optional<Int>>.Type)
    }
    
    func testA() {
        let s: Dictionary<String, Int>? = Serialize.deserialize(["ss":"22"])
        
        XCTAssert(s != nil)
    }
    
    
    func testSerialize() {
        
        let t = T4()
        let t3 = T2.T3()
        
        t3.t_m = "333"
        
        t.i = 2233
        t.f = 22.33
        t.s = "2233"
        t.oi = 2233
        t.of = 22.33
        t.os = "2233"
        t.a = ["1","2","3"]
        t.oa = [1,2,3]
        t.d = [1:2,3:4,5:6,7:8]
        t.od = [1:2,3:4,5:6,7:8]
        t.t3 = t3
        t.set = [1,2,3]
        
        if let json = Serialize.serialize(t) as? NSDictionary {
            
            XCTAssert(json["i"] as? Int == 2233)
            XCTAssert(json["f"] as? Float == 22.33)
            XCTAssert(json["s"] as? String == "2233")
            XCTAssert(json["oi"] as? Int == 2233)
            XCTAssert(json["of"] as? Float == 22.33)
            XCTAssert(json["os"] as? String == "2233")
            XCTAssert(json["a"] as? Array<String> != nil)
            XCTAssert(json["a"]?.count == 3)
            XCTAssert(json["oa"] as? Array<Int> != nil)
            XCTAssert(json["oa"]?.count == 3)
            XCTAssert(json["t3"] != nil)
            XCTAssert((json["t3"] as? NSDictionary)?["t_m"] != nil)
            XCTAssert(json["d"] != nil)
            XCTAssert(json["od"] != nil)
            XCTAssert(json["d"]?.count == 4)
            XCTAssert(json["od"]?.count == 4)
            XCTAssert(json["odn"] == nil)
            XCTAssert(json["set"]?.count == 3)
            
            // 测试反序列化
            if let tt: T4 = Serialize.deserialize(json) {
                
                XCTAssert(tt.i == 2233)
                XCTAssert(tt.f == 22.33)
                XCTAssert(tt.s == "2233")
                XCTAssert(tt.oi == nil) // 无法反序列化, 没有kvc
                XCTAssert(tt.of == nil) // 无法反序列化, 没有kvc
                XCTAssert(tt.os == "2233")
                XCTAssert(tt.a.count == 3)
                XCTAssert(tt.oa != nil)
                XCTAssert(tt.oa?.count == 3)
                XCTAssert(tt.t3 != nil)
                XCTAssert(tt.t3?.t_m == "333")
                XCTAssert(tt.d.count == 4)
                XCTAssert(tt.od != nil)
                XCTAssert(tt.od?.count == 4)
                XCTAssert(tt.odn == nil)
                XCTAssert(tt.set.count == 3)
                
            }
        }
    }
    
    func testDeserialize() {
       
        if true {
            class T00 : NSObject {
                @objc var dress = NSArray()
                @objc var djs = NSDictionary()
            }
            
            let d = ["dress":[[11000003, 11100079, 11200001, 11300054, 11400112, 11600042],
                [11800028, 101]],
                "djs":["222":233]
            ]
            
            let t0: T00? = Serialize.deserialize(d)
            
            XCTAssert(t0 != nil)
            XCTAssert(t0?.dress.count != 0)
            XCTAssert(t0?.djs.count != 0)
        }
        
        if true {
            
            let json = [
                "name":"兔子耳朵",
                "classtype":1
            ]
            
            class T01 : NSObject {
                @objc var name = "unknow"
                @objc var classtype: IType = .Prop
                
                @objc enum IType : Int, Serializeable {
                    
                    case Prop       = 0 ///< 道具
                    case Dress      = 1 ///< 时装
                    case Furniture  = 2 ///< 家具
                    case Map        = 3 ///< 地图
                    case Platform   = 4 ///< DJ台
                    
                    func serialize() -> AnyObject? {
                        return rawValue.serialize()
                    }
                    static func deserialize(o: AnyObject) -> IType? {
                        return IType(rawValue: 1)
                    }
                }
            }
            
            let t01 : T01? = Serialize.deserialize(json)
            
            XCTAssert(t01 != nil)
            XCTAssert(t01?.name == "兔子耳朵")
            XCTAssert(t01?.classtype == .Dress)
        }
        
        for bundle in NSBundle.allBundles() {
            // 未找到, 忽略
            guard let path = bundle.pathForResource("SerializeTests", ofType: "json") else {
                continue
            }
            // 加载失败
            guard let data = NSData(contentsOfFile: path) else {
                XCTAssert(false, "load json fail")
                return
            }
            
            if let s: T1 = try! Serialize.deserialize(JSONData: data) {
                
                // 检查
                XCTAssert(s.t_stoi == 22)
                XCTAssert(s.t_ftoi == 22)
                XCTAssert(s.t_btoi != 0)
                XCTAssert(s.t_atoi == 0)
                XCTAssert(s.t_dtoi == 0)
                XCTAssert(s.t_ntoi == 0)
                XCTAssert(s.t_oooi == nil)
                
                XCTAssert(s.t_stob == true)
                XCTAssert(s.t_ftob == true)
                XCTAssert(s.t_btob == true)
                XCTAssert(s.t_atob == false)
                XCTAssert(s.t_dtob == false)
                XCTAssert(s.t_ntob == false)
                XCTAssert(s.t_ooob == nil)
                
                XCTAssert(s.t_stos == "22.33")
                XCTAssert(s.t_ftos == "22.33")
                XCTAssert(s.t_btos == "1") ///只能转成数字
                XCTAssert(s.t_atos == "")
                XCTAssert(s.t_dtos == "")
                XCTAssert(s.t_ntos == "")
                
                XCTAssert(s.t_stoos == "22.33")
                XCTAssert(s.t_ftoos == "22.33")
                XCTAssert(s.t_btoos == "1") ///只能转成数字
                XCTAssert(s.t_atoos == nil)
                XCTAssert(s.t_dtoos == nil)
                XCTAssert(s.t_ntoos == nil)
                
                XCTAssert(s.t_stoa.count == 0)
                XCTAssert(s.t_ftoa.count == 0)
                XCTAssert(s.t_btoa.count == 0)
                XCTAssert(s.t_atoa.count == 2)
                XCTAssert(s.t_dtoa.count == 0)
                XCTAssert(s.t_ntoa.count == 0)
                
                XCTAssert(s.t_stooa == nil)
                XCTAssert(s.t_ftooa == nil)
                XCTAssert(s.t_btooa == nil)
                XCTAssert(s.t_atooa != nil)
                XCTAssert(s.t_dtooa == nil)
                XCTAssert(s.t_ntooa == nil)
                XCTAssert(s.t_atooa?.count == 2)
                
                XCTAssert(s.t_stod.count == 0)
                XCTAssert(s.t_ftod.count == 0)
                XCTAssert(s.t_btod.count == 0)
                XCTAssert(s.t_atod.count == 0)
                XCTAssert(s.t_dtod.count == 1)
                XCTAssert(s.t_ntod.count == 0)
                
                XCTAssert(s.t_stood == nil)
                XCTAssert(s.t_ftood == nil)
                XCTAssert(s.t_btood == nil)
                XCTAssert(s.t_atood == nil)
                XCTAssert(s.t_dtood != nil)
                XCTAssert(s.t_ntood == nil)
                XCTAssert(s.t_dtood?.count == 1)
                
                XCTAssert(s.t_dtot2 != nil)
                XCTAssert(s.t_dtot2?.t_m == 22.33)
                XCTAssert(s.t_dtot3 != nil)
                XCTAssert(s.t_dtot3?.t_m == "22.33")
                
                XCTAssert(s.t_atoset.count == 2)
                XCTAssert(s.t_atooset?.count == 2)
                
            } else {
                XCTAssert(false, "deserialize fail")
            }
            
            return
        }
        
        XCTAssert(false, "not found SerializeTests.json")
    }
    
    func testSwiftAssign() {
        
        struct D {
            var i1: Int = 0
            var i2: Int = 0
            var i3: Int = 0
            
            var i4: Int? = 0
            var i5: Int? = 0
            var i6: Int? = 0
            
            var i7: Int?? = 0
            var i8: Int?? = 0
            var i9: Int?? = 0
        }
        
        var v = D()
        
        let v1:Any = 1
        let v2:Any = Optional<Int>(1)
        let v3:Any = Optional<Optional<Int>>(1)
        let v4:Any = Optional<Int>()
        let v5:Any = [1,2]
        
        assign(&v.i1, v1)
        assign(&v.i2, v4)
        assign(&v.i3, v5)
        assign(&v.i4, v2)
        assign(&v.i5, v4)
        assign(&v.i6, v5)
        assign(&v.i7, v3)
        assign(&v.i8, v4)
        assign(&v.i9, v5)
       
        XCTAssert(v.i1 == 1)
        XCTAssert(v.i2 == 0)
        XCTAssert(v.i3 == 0)
        XCTAssert(v.i4 == 1)
        XCTAssert(v.i5 == nil)
        XCTAssert(v.i6 == nil)
        XCTAssert(v.i7! == 1)
        XCTAssert(v.i8 == nil)
        XCTAssert(v.i9 == nil)
    }
    
    func testSwiftKVC() {
        struct D : Codeable {
            var i1: Int = 0
            var i2: Int = 0
            var i3: Int = 0
            
            var i4: Int? = 0
            var i5: Int? = 0
            var i6: Int? = 0
            
            var i7: Int?? = 0
            var i8: Int?? = 0
            var i9: Int?? = 0
            
            func valueForSerialize(key: String) -> Any? {
                return nil
            }
            mutating func setValue(value: Any?, forSerialize key: String) {
                switch key {
                case "i1": assign(&self.i1, value)
                case "i2": assign(&self.i2, value)
                case "i3": assign(&self.i3, value)
                case "i4": assign(&self.i4, value)
                case "i5": assign(&self.i5, value)
                case "i6": assign(&self.i6, value)
                case "i7": assign(&self.i7, value)
                case "i8": assign(&self.i8, value)
                case "i9": assign(&self.i9, value)
                default: break
                }
            }
        }
        
        let v1:Any = 1
        let v2:Any = Optional<Int>(1)
        let v3:Any = Optional<Optional<Int>>(1)
        
        var d = D()
        
        d.setValue(v1, forSerialize: "i1")
        d.setValue(v2, forSerialize: "i2")
        d.setValue(v3, forSerialize: "i3")
        d.setValue(v1, forSerialize: "i4")
        d.setValue(v2, forSerialize: "i5")
        d.setValue(v3, forSerialize: "i6")
        d.setValue(v1, forSerialize: "i7")
        d.setValue(v2, forSerialize: "i8")
        d.setValue(v3, forSerialize: "i9")
        
        XCTAssert(d.i1 == 1)
        XCTAssert(d.i2 == 0)
        XCTAssert(d.i3 == 0)
        XCTAssert(d.i4 == nil)
        XCTAssert(d.i5 == 1)
        XCTAssert(d.i6 == nil)
        XCTAssert(d.i7 == nil)
        XCTAssert(d.i8 == nil)
        XCTAssert(d.i9! == 1)
    }
    
    func testOCBuildtInType() {
        
        let v = Serialize.serialize(1)
        
        XCTAssert(v as? NSNumber == NSNumber(integer: 1))
        
        // NSURL
        // NSDate
        // NSData
        // UIImage
        // CGFloat
        
        let s = NSSet.deserialize([1,2,3])
        
        XCTAssert(s != nil)
        XCTAssert(s == NSSet(array: [1,2,3]))
        
        let a = NSArray.deserialize([1,2,3])
        
        XCTAssert(a != nil)
        XCTAssert(a == [1,2,3])
        
        let d = NSDictionary.deserialize([1:1,2:2,3:3])
        
        XCTAssert(d != nil)
        XCTAssert(d == [1:1,2:2,3:3])
    }
    
    func testSwiftBuildtInType() {
        
        XCTAssert(Int(1).serialize() as! NSNumber == 1)
        XCTAssert(Int8(1).serialize() as! NSNumber == 1)
        XCTAssert(Int16(1).serialize() as! NSNumber == 1)
        XCTAssert(Int32(1).serialize() as! NSNumber == 1)
        XCTAssert(Int64(1).serialize() as! NSNumber == 1)
        XCTAssert(UInt(1).serialize() as! NSNumber == 1)
        XCTAssert(UInt8(1).serialize() as! NSNumber == 1)
        XCTAssert(UInt16(1).serialize() as! NSNumber == 1)
        XCTAssert(UInt32(1).serialize() as! NSNumber == 1)
        XCTAssert(UInt64(1).serialize() as! NSNumber == 1)
        XCTAssert(Float(1).serialize() as! NSNumber == 1)
        XCTAssert(Double(1).serialize() as! NSNumber == 1)
        XCTAssert(Bool(1).serialize() as! NSNumber == 1)
        XCTAssert(String("1").serialize() as! NSString == "1")
        
        XCTAssert(Int.deserialize(1) == 1)
        XCTAssert(Int.deserialize("1") == 1)
        XCTAssert(Int.deserialize("1.1") == 1)
        XCTAssert(Int.deserialize("x") == nil)
        XCTAssert(Int8.deserialize(1) == 1)
        XCTAssert(Int8.deserialize("1") == 1)
        XCTAssert(Int8.deserialize("1.1") == 1)
        XCTAssert(Int8.deserialize("x") == nil)
        XCTAssert(Int16.deserialize(1) == 1)
        XCTAssert(Int16.deserialize("1") == 1)
        XCTAssert(Int16.deserialize("1.1") == 1)
        XCTAssert(Int16.deserialize("x") == nil)
        XCTAssert(Int32.deserialize(1) == 1)
        XCTAssert(Int32.deserialize("1") == 1)
        XCTAssert(Int32.deserialize("1.1") == 1)
        XCTAssert(Int32.deserialize("x") == nil)
        XCTAssert(Int64.deserialize(1) == 1)
        XCTAssert(Int64.deserialize("1") == 1)
        XCTAssert(Int64.deserialize("1.1") == 1)
        XCTAssert(Int64.deserialize("x") == nil)
        XCTAssert(UInt.deserialize(1) == 1)
        XCTAssert(UInt.deserialize("1") == 1)
        XCTAssert(UInt.deserialize("1.1") == 1)
        XCTAssert(UInt.deserialize("x") == nil)
        XCTAssert(UInt8.deserialize(1) == 1)
        XCTAssert(UInt8.deserialize("1") == 1)
        XCTAssert(UInt8.deserialize("1.1") == 1)
        XCTAssert(UInt8.deserialize("x") == nil)
        XCTAssert(UInt16.deserialize(1) == 1)
        XCTAssert(UInt16.deserialize("1") == 1)
        XCTAssert(UInt16.deserialize("1.1") == 1)
        XCTAssert(UInt16.deserialize("x") == nil)
        XCTAssert(UInt32.deserialize(1) == 1)
        XCTAssert(UInt32.deserialize("1") == 1)
        XCTAssert(UInt32.deserialize("1.1") == 1)
        XCTAssert(UInt32.deserialize("x") == nil)
        XCTAssert(UInt64.deserialize(1) == 1)
        XCTAssert(UInt64.deserialize("1") == 1)
        XCTAssert(UInt64.deserialize("1.1") == 1)
        XCTAssert(UInt64.deserialize("x") == nil)
        
        XCTAssert(Float.deserialize(1) == 1.0)
        XCTAssert(Float.deserialize("1") == 1.0)
        XCTAssert(Float.deserialize("1.1") == 1.1)
        XCTAssert(Float.deserialize("x") == nil)
        XCTAssert(Double.deserialize(1) == 1.0)
        XCTAssert(Double.deserialize("1") == 1.0)
        XCTAssert(Double.deserialize("1.1") == 1.1)
        XCTAssert(Double.deserialize("x") == nil)
        
        XCTAssert(Bool.deserialize(1) == true)
        XCTAssert(Bool.deserialize("0") == false)
        XCTAssert(Bool.deserialize("1.1") == true)
        XCTAssert(Bool.deserialize("x") == nil)
        
        XCTAssert(String.deserialize(1) == "1")
        XCTAssert(String.deserialize("0") == "0")
        XCTAssert(String.deserialize("1.1") == "1.1")
        XCTAssert(String.deserialize("x") == "x")
        XCTAssert(String.deserialize([1]) == nil)
        
        XCTAssert(CGFloat(1).serialize() as! NSNumber == 1)
        XCTAssert(CGFloat.deserialize(1) == 1.0)
        XCTAssert(CGFloat.deserialize("1") == 1.0)
        XCTAssert(CGFloat.deserialize("1.1") == 1.1)
        XCTAssert(CGFloat.deserialize("x") == nil)
        
        let a = Array<Array<Int>>.deserialize([[1,2,3]])
        
        XCTAssert(a != nil)
        XCTAssert(a![0].count != 0)
        XCTAssert(a![0] == [1,2,3])
    }
    
    func testSet() {
        
        let si = Set<Int>([1,2]).serialize()
        // 序列化结果应为[1,2], 类型应为NSArray
        XCTAssert(si != nil, "serialize fail")
        XCTAssert(si! is NSArray, "type error")
        XCTAssertEqual(si as? NSArray, [2,1], "value error")
        
        let sn = Set<Int>().serialize()
        // 序列化结果应为NSArray
        XCTAssert(sn == nil, "serialize fail")
        
        let di = Set<Int>.deserialize([1,2])
        // 反序列化结果应为123, 类型应为Set<Int>
        XCTAssert(di != nil, "serialize fail")
        XCTAssertEqual(di!, [2,1], "value error")
        
        let dn = Set<Int>.deserialize("error")
        // 反序列化结果应为nil
        XCTAssert(dn == nil, "serialize fail")
    }
    
    func testArray() {
        
        let si = Array<Int>([1,2]).serialize()
        // 序列化结果应为[1,2], 类型应为NSArray
        XCTAssert(si != nil, "serialize fail")
        XCTAssert(si! is NSArray, "type error")
        XCTAssertEqual(si as? NSArray, [1,2], "value error")
        
        let sn = Array<Int>().serialize()
        // 序列化结果应为NSArray
        XCTAssert(sn == nil, "serialize fail")
        
        let di = Array<Int>.deserialize([1,2])
        // 反序列化结果应为123, 类型应为Array<Int>
        XCTAssert(di != nil, "serialize fail")
        XCTAssertEqual(di!, [1,2], "value error")
        
        let dn = Array<Int>.deserialize("error")
        // 反序列化结果应为nil
        XCTAssert(dn == nil, "serialize fail")
    }
    
    func testDictionary() {
        
        let si = Dictionary<Int, Int>(dictionaryLiteral: (1,2),(2,3)).serialize()
        // 序列化结果应为["1":2,"2":3], 类型应为NSDictionary
        XCTAssert(si != nil, "serialize fail")
        XCTAssert(si! is NSDictionary, "type error")
        XCTAssertEqual(si as? NSDictionary, ["1":2,"2":3], "value error")
        
        let sn = Dictionary<Int, Int>().serialize()
        // 序列化结果应为NSArray
        XCTAssert(sn == nil, "serialize fail")

        let di = Dictionary<Int, Int>.deserialize(["1":2,2:3])
        // 反序列化结果应为123, 类型应为Array<Int>
        XCTAssert(di != nil, "serialize fail")
        XCTAssertEqual(di!, [1:2,2:3], "value error")
        
        let dn = Dictionary<Int, Int>.deserialize("error")
        // 反序列化结果应为nil
        XCTAssert(dn == nil, "serialize fail")
    }
    
    func testOptional() {
        
        let si = Optional<Int>(123).serialize()
        // 序列化结果应为123, 类型应为NSNumber
        XCTAssert(si != nil, "serialize fail")
        XCTAssert(si! is NSNumber, "type error")
        XCTAssert(si as! NSNumber == 123, "value error")
        
        let sn = Optional<Int>().serialize()
        // 序列化结果应为nil
        XCTAssert(sn == nil, "serialize fail")
        
        let di = Optional<Int>.deserialize(123)
        // 反序列化结果应为123, 类型应为Int
        XCTAssert(di != nil, "serialize fail")
        XCTAssert(di! == 123, "value error")
        
        let dn = Optional<Int>.deserialize("error")
        // 反序列化结果应为nil
        XCTAssert(dn == nil, "serialize fail")
    }
    
    func testSwitfCustomType() {
        
        let td = [
            "a":1,
            "b":"str",
            "c":["1",1],
            "u1":"http://www.baidu.com",
            "u2":"file://www.baidu.com"
        ]
        
        let e1: SE1? = Serialize.deserialize(td)
        
        XCTAssert(e1?.a == 1)
        XCTAssert(e1?.b == "str")
        XCTAssert(e1!.c! == [1,1])
        
        XCTAssert(e1?.u1 == NSURL(string: "http://www.baidu.com"))
        XCTAssert(e1?.u2 == NSURL(string: "file://www.baidu.com"))
        
        let e2: SE2? = Serialize.deserialize(td)
        
        XCTAssert(e2?.a == 1)
        XCTAssert(e2?.b == "str")
        XCTAssert(e2!.c! == [1,1])
        
        XCTAssert(e2?.u1 == NSURL(string: "http://www.baidu.com"))
        XCTAssert(e2?.u2 == NSURL(string: "file://www.baidu.com"))
        
        let e3: SE3<NSURL>? = Serialize.deserialize(td)
        
        XCTAssert(e3?.a == 1)
        XCTAssert(e3?.b == "str")
        XCTAssert(e3!.c! == [1,1])
        
        XCTAssert(e3?.u1 == NSURL(string: "http://www.baidu.com"))
        XCTAssert(e3?.u2 == NSURL(string: "file://www.baidu.com"))
        
        let e4: SE3<String>? = Serialize.deserialize(td)
        
        XCTAssert(e4?.a == 1)
        XCTAssert(e4?.b == "str")
        XCTAssert(e4!.c! == [1,1])
        
        XCTAssert(e4?.u1 == "http://www.baidu.com")
        XCTAssert(e4?.u2 == "file://www.baidu.com")
        
        let e5 = Array<SE3<NSURL>>.deserialize([td, td, td, td])
        
        XCTAssert(e5 != nil)
        XCTAssert(e5?.count == 4)

        for e in e5! {
            XCTAssert(e.a == 1)
            XCTAssert(e.b == "str")
            XCTAssert(e.c! == [1,1])
           
            XCTAssert(e.u1 == NSURL(string: "http://www.baidu.com"))
            XCTAssert(e.u2 == NSURL(string: "file://www.baidu.com"))
        }
        
        let e6 = Set<SE1>.deserialize([td, td, td, td])
        
        XCTAssert(e6 != nil)
        XCTAssert(e6?.count == 4)
        
        for e in e6! {
            XCTAssert(e.a == 1)
            XCTAssert(e.b == "str")
            XCTAssert(e.c! == [1,1])
           
            XCTAssert(e.u1 == NSURL(string: "http://www.baidu.com"))
            XCTAssert(e.u2 == NSURL(string: "file://www.baidu.com"))
        }
        
        let e7 = Dictionary<Int, SE1>.deserialize(["1":td, 2:td, 1:td, [2]:td])
        
        XCTAssert(e7 != nil)
        XCTAssert(e7?.count == 2)
        
        for (_,e) in e7! {
            XCTAssert(e.a == 1)
            XCTAssert(e.b == "str")
            XCTAssert(e.c! == [1,1])
           
            XCTAssert(e.u1 == NSURL(string: "http://www.baidu.com"))
            XCTAssert(e.u2 == NSURL(string: "file://www.baidu.com"))
        }
        
        let e8 = Optional<SE1>.deserialize(td)
        
        XCTAssert(e8 != nil)
        XCTAssert(e8!!.a == 1)
        XCTAssert(e8!!.b == "str")
        XCTAssert(e8!!.c! == [1,1])
        
        XCTAssert(e8!!.u1 == NSURL(string: "http://www.baidu.com"))
        XCTAssert(e8!!.u2 == NSURL(string: "file://www.baidu.com"))
    }
    
    func testOCCustomType() {
        
        let e = E1.deserialize([
            "a":1,
            "b":"str",
            "c":["1",1],
            "u1":"http://www.baidu.com",
            "u2":"file://www.baidu.com"
            ])
        
        XCTAssert(e?.a == 1)
        XCTAssert(e?.b == "str")
        XCTAssert(e!.c! == [1,1])
        
        XCTAssert(e?.u1 == NSURL(string: "http://www.baidu.com"))
        XCTAssert(e?.u2 == NSURL(string: "file://www.baidu.com"))
    }
    
    func testExample() {
        
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
    }
}
