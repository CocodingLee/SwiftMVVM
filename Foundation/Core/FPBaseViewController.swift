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
    // resource recycling bag
    let bag = FPDisposedBag()
    var navigationTitle: String?
    var accessibilityId: String?
    
    // setup navigation
    func setupNavigationBar(withTitle:String , accessibilityId:String) {
        let titleLabel = UILabel()
        
        // TODO: navigationItem待完善，使用mobileX的API
        titleLabel.text = withTitle
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = UIColor.darkGray
        titleLabel.accessibilityIdentifier = accessibilityId
        
        navigationItem.titleView = titleLabel
        
        // TODO: navigationBar待完善，使用mobileX的API
        navigationController?.navigationBar.barTintColor = UIColor.systemGreen
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.darkGray]
        
        // TODO: back button待完善，使用mobileX的API
        let backButton = UIButton(type: .custom)
        //backButton.setImage(<#T##image: UIImage?##UIImage?#>, for: <#T##UIControl.State#>)
        backButton.addTarget(self, action: #selector(backButtonAction(button:)), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @objc func backButtonAction(button: UIButton) {
        // 这种UI代码都应该被框架代替
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
