//
//  LiveData.swift
//  SwiftMVVMTests
//
//  Created by David Lee on 2021/8/3.
//

import XCTest
@testable import SwiftMVVM

class FPLiveDataTest: XCTestCase {
    
    func testLiveData() {
        
        let dispodeBag = FPDisposedBag()
        var liveData: FPLiveData<Bool>?

        func configure1() {
            liveData?.add(observer: self){ [weak self] wvalue in
                guard let self = self else { return }
                //print(">>>>>>>>; view:", self.tag, "Observer 1")
            }.disposed(by: dispodeBag)
        }

        func configure2() {
            liveData?.add(observer: self) { [weak self] value in
                guard let self = self else { return }
                //print(">>>>>>>> view:", self.tag, "Observer 2")
            }.disposed(by: dispodeBag)
        }

        func configure3() {
            liveData?.add(observer: self) { [weak self] value in
                guard let self = self else { return }
                //print(">>>>>>>> view:", self.tag, "Observer 3")
            }.disposed(by: dispodeBag)
        }
    }
}


