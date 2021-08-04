//
//  ViewModel.swift
//  SwiftMVVM
//
//  Created by David Lee on 2021/8/3.
//

import Foundation

class MVVMItem: Decodable
{
    var name: String?
    var subName: String?
}

class MVVMModel: Decodable
{
    var data:[MVVMItem]?
}

class ViewModel: FPBaseViewModel
{
    private(set) var contents = FPLiveData<MVVMModel?>()
    private(set) var error = FPLiveData<Error?>()
    
    func load() -> Void {
        let req = FPHTTPsPostRequest()
        req.prefixPath = "https://sfp.xxx.xx"
        req.subPath = "content"
        req.parameters = ["name1":"n1" , "name2":"n2"]
        req.queryParameters = ["name1":"n1" , "name2":"n2"]
        
        // 网络请求
        FPNetworkModel.fetch(request: req , resposeType: MVVMModel.self) { [weak self] req, result in
            switch result {
            case .success(let model):
                self?.firstTimeLoadData = false
                self?.contents.publish(value: model)
            case .failure(let error):
                self?.error.publish(value: error)
            }
        }
    }
}
