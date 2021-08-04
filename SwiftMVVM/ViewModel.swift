//
//  ViewModel.swift
//  SwiftMVVM
//
//  Created by David Lee on 2021/8/3.
//

import Foundation

class mvvmModel: Decodable
{
    var name: String?
    var subName: String?
}

class viewModel: FPBaseViewModel
{
    private(set) var contents: [mvvmModel]?
}
