//
//  FPBaseModel.swift
//  SwiftMVVM
//
//  Created by David Lee on 2021/7/27.
//

import Foundation

enum FPBaseError: Error {
    case networkErrorNone
    case networkError(code:Int)
    case networkNotFind
}

class FPBaseViewModel {
    
    // http base
    
    //
    
    // demo 1
    func fetch<Req, Rsp:Any>(input:Req) -> [Rsp:FPBaseError] {
        return [:]
    }
}
