//
//  FPExtension+UIColor.swift
//  SwiftMVVM
//
//  Created by David Lee on 2021/8/3.
//

import Foundation
import UIKit

extension UIColor
{
    convenience init(rgb: UInt , alpha: CGFloat) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
    convenience init(rgb: UInt) {
        self.init(
            rgb:rgb,
            alpha: CGFloat(1.0)
        )
    }
}

extension UIWindow
{
    static func fpSafeArea() -> UIEdgeInsets {
        if #available(iOS 11.0, *) {
            
            if let win = UIApplication.shared.delegate?.window
               , let e = win?.safeAreaInsets {
                return e
            }
        }
        
        return UIEdgeInsets.zero
    }
}
