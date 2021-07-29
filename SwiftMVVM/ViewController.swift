//
//  ViewController.swift
//  SwiftMVVM
//
//  Created by David Lee on 2021/7/26.
//

import UIKit

class View: UIView {
    let dispodeBag = FPDisposedBag()
    var liveData: FPLiveData<Bool>?
    
    func configure1() {
        liveData?.add(observer: self){ [weak self] wvalue in
            guard let self = self else { return }
            print(">>>>>>>>; view:", self.tag, "Observer 1")
        }.disposed(by: dispodeBag)
    }

    func configure2() {
        liveData?.add(observer: self) { [weak self] value in
            guard let self = self else { return }
            print(">>>>>>>> view:", self.tag, "Observer 2")
        }.disposed(by: dispodeBag)
    }

    func configure3() {
        liveData?.add(observer: self) { [weak self] value in
            guard let self = self else { return }
            print(">>>>>>>> view:", self.tag, "Observer 3")
        }.disposed(by: dispodeBag)
    }
}

class ViewController: FPBaseViewController {

    let dispodeBag = FPDisposedBag()
    let liveData = FPLiveData<Bool>()
    
    override func viewDidLoad() {
        self.navigationTitle = "首页"
        self.accessibilityId = "dsddd"
        
        super.viewDidLoad()
    }
    
    
    override func bindViewModel() -> Void {
        
        let view1 = View()
        view1.tag = 1
        view1.liveData = liveData
        view1.configure1()
        view1.configure2()

        let view2 = View()
        view2.tag = 2
        view2.liveData = liveData
        view2.configure3()

        print(">>>>>>>> Async Request. Now:", Date())
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] in
            self?.liveData.publish(value: false)
            print(">>>>>>>> Done. Now:", Date())
        }

        print("<<<<<<<<<< Remove all observers from View 2")
        liveData.remove(observer: view2)
        
        liveData.publish(value: true)
    }
    
    override func setupSubViews() -> Void {
        
    }
    
    override func fetchDataFromServer() -> Void {
        
    }
}

