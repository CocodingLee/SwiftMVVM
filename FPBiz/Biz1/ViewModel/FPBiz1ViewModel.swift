//
//  FPBiz1ViewModel.swift
//  SwiftMVVM
//
//  Created by David Lee on 2021/7/27.
//

import Foundation

class FPBiz1ViewModel: FPBaseViewModel
{
    // Combine
    // RxSwift
    // LiveData
    private(set) var model = FPLiveData<FPBiz1Model?>()
    private(set) var error = FPLiveData<Error?>()
    
    func load(i1: String , i2: String) -> Void {
        let req = FPHTTPsPostRequest()
        req.prefixPath = ""
        req.subPath = ""
        req.parameters = ["name1":i1 , "name2":i2]
        req.queryParameters = ["name1":"n1" , "name2":"n2"]
        
        // 网络请求
        FPNetworkModel.fetch(request: req , resposeType: FPBiz1Model.self) { [weak self] req, result in
            switch result {
            case .success(let model):
                self?.model.publish(value: model)
            case .failure(let error):
                self?.error.publish(value: error)
            }
        }
    }
}


class FPBiz1ForXXViewModel: FPBaseViewModel
{
    private(set) var model = FPLiveData<FPBiz1Model?>()
    private(set) var error = FPLiveData<Error?>()
    
    func load(i1: String , i2: String) -> Void {
        let req = FPHTTPsPostRequest()
        req.prefixPath = ""
        req.subPath = ""
        req.parameters = ["name":i1 , "name":i2]
        req.queryParameters = ["name":"n1" , "name":"n2"]
        
        // 网络请求
        FPNetworkModel.fetch(request: req , resposeType: FPBiz1Model.self) { [weak self] req, result in
            switch result {
            case .success(let model):
                self?.model.publish(value: model)
            case .failure(let error):
                self?.error.publish(value: error)
            }
        }
    }
}
