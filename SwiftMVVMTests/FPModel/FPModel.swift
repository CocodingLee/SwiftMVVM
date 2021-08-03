//
//  FPModel.swift
//  SwiftMVVMTests
//
//  Created by David Lee on 2021/8/3.
//

import XCTest
@testable import SwiftMVVM

class FPModel: XCTestCase {
    
    func testFPModelLoad() {
        let viewModel = FPBiz1ViewModel()
        viewModel.load(i1: "name1", i2: "name2")
    }
}
