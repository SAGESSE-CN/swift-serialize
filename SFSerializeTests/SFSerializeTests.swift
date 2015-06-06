//
//  SFSerializeTests.swift
//  SFSerializeTests
//
//  Created by sagesse on 6/2/15.
//  Copyright (c) 2015 Sagesse. All rights reserved.
//

import UIKit
import XCTest

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
    
    func testA() {
        let s: Dictionary<String, Int>? = unserialize(json: ["ss":"22"])
        
        XCTAssert(s != nil)
    }
    
    func testSerialize() {
        
        var t = T4()
        var t3 = T2.T3()
        
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
            
            // 测试反序列化
            if var tt: T4 = unserialize(json: json) {
                
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
                
            }
        }
    }
    
    func testUnserialize() {
        for bundle in NSBundle.allBundles() {
            if let path = bundle.pathForResource("test", ofType: "json") {
                if var s: T1 = unserialize(jsonData: NSData(contentsOfFile: path)) {
                    
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
                    
                } else {
                    XCTAssert(false, "unserialize fail")
                }
                
                return 
            }
        }
        
        XCTAssert(false, "not found test.json")
    }
}
