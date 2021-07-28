//
//  FPBiz1ViewModel.swift
//  SwiftMVVM
//
//  Created by David Lee on 2021/7/27.
//

import Foundation

class FPBiz1ViewModel
{
    func load(i1: String , i2: String) -> Void {
        let req = FPHTTPsPostRequest()
        req.prefixPath = ""
        req.subPath = ""
        req.parameters = ["name":i1 , "name":i2]
        req.queryParameters = ["name":"n1" , "name":"n2"]
        
        // 网络请求
        FPNetworkModel.fetch(request: req , resposeType: FPBiz1Model.self) { req, result in
            
        }
    }
}
