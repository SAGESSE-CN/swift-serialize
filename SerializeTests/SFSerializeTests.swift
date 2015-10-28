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

class SFSerializeTests: XCTestCase {
    
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
    
    /// 测试枚举
    func testEnum() {
        
        let t = Test()
        let o = serialize(t)
        
        // 暂时不支持 - swift 2.0
        XCTAssert(o == nil)
    }
    
    
//    func testA() {
//        let s: Dictionary<String, Int>? = deserialize(json: ["ss":"22"])
//        
//        XCTAssert(s != nil)
//    }
    
    
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
        
        if let json = serialize(t) as? NSDictionary {
            
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
            if let tt: T4 = deserialize(json: json) {
                
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
            
            let t0: T00? = deserialize(json: d)
            
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
                
                @objc enum IType : Int {
                    
                    case Prop       = 0 ///< 道具
                    case Dress      = 1 ///< 时装
                    case Furniture  = 2 ///< 家具
                    case Map        = 3 ///< 地图
                    case Platform   = 4 ///< DJ台
                }
            }
            
            let t01 : T01? = deserialize(json: json)
            
            XCTAssert(t01 != nil)
            XCTAssert(t01?.name == "兔子耳朵")
            XCTAssert(t01?.classtype == .Dress)
        }
        
        
        for bundle in NSBundle.allBundles() {
            if let path = bundle.pathForResource("SFSerializeTests", ofType: "json") {
                if let s: T1 = deserialize(jsonData: NSData(contentsOfFile: path)) {
                    
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
        }
        
        XCTAssert(false, "not found SFSerializeTests.json")
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
        let json = serialize(e1)
        let jsonData = serializeToData(e1)
        let jsonStr = NSString(data: jsonData!, encoding: NSUTF8StringEncoding)
        
        // {"val_string":"hello swift","val_bool":true,"val_dictionary":{"12":13,"14":15,"10":11},"val_array":[7,8,9],"val_int":123,"val_double":456}
        print(jsonStr)
        
        // deserialize
        let e2: Example? = deserialize(json: json)
        let e3: AnyObject? = deserialize(json: json, type: Example.self)
        
        // e1 == e2 == e3
    }
}
