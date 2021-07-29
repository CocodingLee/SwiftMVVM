//
//  FPBiz1ViewController.swift
//  SwiftMVVM
//
//  Created by David Lee on 2021/7/27.
//

import Foundation

final class FPBiz1ViewController: FPBaseViewController
{
    lazy private var viewModel = FPBiz1ViewModel()
    lazy private var forXXviewModel = FPBiz1ForXXViewModel()
  
    override func viewDidLoad() {
        super.navigationTitle = "Biz1"
        super.accessibilityId = "xxxx.xxx.xx"
        
        super.viewDidLoad()
        
        // self things
    }
    
    override func bindViewModel() -> Void {
        // jump navigation use
        self.viewModel.weakViewController = self
        
        self.viewModel.model.add(observer: self) { model in
            
        }.disposed(by: super.bag)
        
        self.viewModel.error.add(observer: self) { error in
            
        }.disposed(by: super.bag)
        
        // forxxViewModel
        self.forXXviewModel.weakViewController = self
    }
    
    override func setupSubViews() -> Void {
        
    }
    
    override func fetchDataFromServer() -> Void {
        self.viewModel.load(i1: "d1", i2: "d2")
    }
}

// MARK: Route by FBRouteProtocol
extension FPBiz1ViewController: FBRouteProtocol
{
    static var supportedDomain: String {
        FPRouteDomain.url.rawValue
    }
    
    static var supportedPath: [String] {
        ["path.fp.biz1"]
    }
    
    convenience init(params: Dictionary<String, Any>) {
        self.init()
    }
}

// empty view
extension FPBiz1ViewController
{
    
    
    
}
