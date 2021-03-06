//
//  FPBaseViewController.swift
//  SwiftMVVM
//
//  Created by David Lee on 2021/7/27.
//

import Foundation
import UIKit

class FPBaseViewController: UIViewController
{
    // auto create button
    var autoCreateBackButton = true
    
    // resource recycling bag
    let bag = FPDisposedBag()
    var navigationTitle: String?
    var accessibilityId: String?
    var navigationBarHeight: CGFloat {
        let navHeight = self.navigationController?.navigationBar.frame.size.height ?? 44.0;
        let safeArea = UIWindow.fpSafeArea()
        
        return navHeight + safeArea.top
    }
    
    // setup navigation
    func setupNavigationBar(withTitle:String , accessibilityId:String) {
        let titleLabel = UILabel()
        
        // TODO: navigationItem待完善，使用mobileX的API
        titleLabel.text = withTitle
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textColor = UIColor.darkGray
        titleLabel.accessibilityIdentifier = accessibilityId
        
        navigationItem.titleView = titleLabel
        
        // TODO: navigationBar待完善，使用mobileX的API
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.darkGray]
        
        // TODO: back button待完善，使用mobileX的API
        if self.autoCreateBackButton {
            let backButton = UIButton(type: .custom)
            let img = UIImage.init(named: "back")
            backButton.setImage(img, for: .normal)
            backButton.addTarget(self, action: #selector(backButtonAction(button:)), for: .touchUpInside)
            
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        }
    }
    
    @objc func backButtonAction(button: UIButton) {
        // 这种UI代码都应该被框架代替
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 导航栏
        self.view.backgroundColor = UIColor.white
        
        // setup navigation
        setupNavigationBar(withTitle: self.navigationTitle ?? ""
                           , accessibilityId: self.accessibilityId ?? "")
        // bind model
        bindViewModel()
        // setup views
        setupSubViews()
        // load data
        fetchDataFromServer()
    }
    
    // subclass override
    func bindViewModel() -> Void {
        fatalError("subclass must override this function")
    }
    
    func setupSubViews() -> Void {
        fatalError("subclass must override this function")
    }
    
    func fetchDataFromServer() -> Void {
        fatalError("subclass must override this function")
    }
}
