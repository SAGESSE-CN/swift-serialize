//
//  SFSerializeTests.swift
//  SFSerializeTests
//
//  Created by sagesse on 6/2/15.
//  Copyright (c) 2015 Sagesse. All rights reserved.
//

import UIKit
import XCTest

import SFSerialize

@objc class FT<T:NSObject> : NSObject {
    var s: T?
}

class T2 : NSObject {
    @objc var i0 = 0
}

class T1 : NSObject
{
    @objc var t0: Int = 0
    @objc var t1: String?
    @objc var t2: Float = 0
    @objc var t3: T2?
    @objc var t4: [Int]?
    @objc var t5: [Int] = []
    @objc var t6: [Int:Int] = [:]
    @objc var t7: [[Float]]?
    @objc var t8: Bool = false
}

class SFSerializeTests: XCTestCase {
    
//    struct  SA       {          }
//    enum    EA : Int { case A   }
//    class   CA       {          }
//    
//    /*@objc*/ class A /*: NSObject*/ {
//        
//        static var tn1  = 0
//        
//        var t0  = FT<NSObject>()
//        var t1  : A1.B1.C1?//Any = 0
//        var t2  : String = ""
//        var t3  : NSArray = NSArray()
//        var t4  : NSDictionary = NSDictionary()
//        var t5  : [Int] = []
//        //var t5  : [AnyObject] = []
//        var t6  : [Int:Int] = [:]
//        var t7  : (Int) = (0)
//        var t8  : (Int,Int) = (1,2)
//        var t9  : SA = SA()
//        var t10 : EA = EA.A
//        var t11 : CA = CA()
//        var t12 : Any?
//        var t13 : String?
//        var t14 : NSArray?
//        var t15 : NSDictionary?
//        var t16 : [Int]?
//        var t17 : [Int:Int]?
//        var t18 : (Int)?
//        var t19 : (Int,Int)?
//        var t20 : SA?
//        var t21 : EA?
//        var t22 : CA?
//    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        
        let path = "/Users/sagesse/a.json"
      
        if var s:T1 = unserialize(jsonPath: path) {
            
            println(s)
            
        }
        
//        var a:AnyObject = A()
//        var lm =  reflect(a)
//        for i in 0 ..< lm.count {
//            
//            let mt = lm[i]
//            
//            var s = "\(mt.1.valueType)"
//            
//            println("\(mt.0) type is \(s), \(mt.1)")
//            
//        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
