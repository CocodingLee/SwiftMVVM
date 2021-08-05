//
//  FPBaseView.swift
//  SwiftMVVM
//
//  Created by David Lee on 2021/8/5.
//

import Foundation

protocol FPBaseView {
    func bindViewModel(viewModel: AnyObject?)
    func updateViewWith(item: AnyObject?)
}
