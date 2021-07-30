//
//  FPBaseResponse.swift
//  SwiftMVVM
//
//  Created by David Lee on 2021/7/28.
//

import Foundation

enum FPErrorCode: Int , CaseIterable {
    case clientNone = 0
    
    case serverNone = 20000
    case serverRespNoContent
}

//
// UI will updata by the FPBaseError
//
enum FPBaseError: Error {
    // default value
    case errorNone
    // network server error
    case networkServerError(code:Int , msg:String)
    // network client error
    case networkClientError(code:FPErrorCode , msg:String)
    
    
    // network no content
    case networkNoContent
    // network no network error
    case networkNotFound
    
    
    // API error
    case clientAPIInvokeError(apiName: String)
    // unexpect
    case clientUnExpectError(Error)
}

enum FPNetworkResult<Resp: Decodable , Failure> where Failure: Error {
    case success(Resp)
    // TODO:String需要改成结构体
    case failure(Failure)
    
    //
    // decode result data
    //
    func parse(data: Data) throws -> Resp {
        let decoder = JSONDecoder()
        let r = try decoder.decode(Resp.self, from: data)
        return r
    }
}
