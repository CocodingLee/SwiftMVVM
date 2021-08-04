//
//  FPBaseViewModel.swift
//  SwiftMVVM
//
//  Created by David Lee on 2021/7/27.
//

import Foundation
import UIKit

class FPBaseViewModel
{
    weak var weakViewController: UIViewController?
    
    // 
    // is first time to load data
    // use by load more
    var firstTimeLoadData = true
}
