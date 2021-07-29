//
//  AppDelegate.swift
//  SwiftMVVM
//
//  Created by David Lee on 2021/7/26.
//

import UIKit

//@main
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    
    //
    // 参考：https://juejin.cn/post/6844904073557180429
    //
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        let tmp = FPRuntime.classes(conformToProtocol: FBRouteProtocol.self)
        print(tmp)
        
        
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        let vc = ViewController()
        let root = UINavigationController(rootViewController: vc)
        window?.rootViewController = root
        window?.makeKeyAndVisible()
        
        
        return true
    }
}

