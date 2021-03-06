//
//  FPRoute.swift
//  SwiftMVVMTests
//
//  Created by David Lee on 2021/7/29.
//

import XCTest
@testable import SwiftMVVM

class FPRoute: XCTestCase {
    
    func testFPRoutePlugInManager() {
        let routeManager = FPRoutePlugInManager();
        
        do {
            let cls1: AnyClass? = routeManager.pluginWith(domain: "domain.fp.biz", path: "path.fp.biz1")
            XCTAssertTrue(cls1 != nil , "FPRoutePlugInManager pluginWith")
        }
        
        do {
            let cls2: AnyClass? = routeManager.pluginWith(domain: "domain.fp.biz", path: "path.fp.biz2")
            XCTAssertTrue(cls2 != nil , "FPRoutePlugInManager pluginWith")
        }
        
        do {
            let cls2: AnyClass? = routeManager.pluginWith(domain: "domain.fp.biz", path: "path.fp.biz3")
            XCTAssertTrue(cls2 != nil , "FPRoutePlugInManager pluginWith")
        }
        
        do {
            let cls3: AnyClass? = routeManager.pluginWith(domain: "domain.fp.biz", path: "path.fp.biz2222")
            XCTAssertTrue(cls3 == nil , "FPRoutePlugInManager pluginWith")
        }
        
        do {
            let cls4: AnyClass? = routeManager.pluginWith(domain: "domain", path: "path.fp.biz2222")
            XCTAssertTrue(cls4 == nil , "FPRoutePlugInManager pluginWith")
        }
        
    }
    
    func testFPRouteRegManager() {
        let regManager = FPRouteRegManager()
        let vc1 = FPBiz1ViewController()
        
        // add
        let domain = "domain.fp.biz"
        let path = "path.fp.biz1"
        
        regManager.addReg(reg: vc1, domain: domain, path: path)
        
        // mach
        let regs = regManager.matchRegs(with: domain, path: path)
        if let r = regs , r.count > 0 {
            let route: FPRouteRegTreeDelegate = r.first!
            route.regWithDomain(domain: domain
                                , path: path
                                , param: [:]) { decision, error in
                XCTAssertTrue(decision == .FPRouteDecisionAllow
                                && error == nil
                              ,  "FPRouteRegTreeDelegate handled")
            }
        }
        
        // check
        regManager.checkRegs(with: domain
                             , path: path
                             , params: [:]) { decision, error in
            XCTAssertTrue(decision == .FPRouteDecisionAllow
                            && error == nil
                          ,  "FPRouteRegTreeDelegate handled")
        }
    }
    
}
