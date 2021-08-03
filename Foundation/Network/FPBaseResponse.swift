//
//  FPBaseResponse.swift
//  SwiftMVVM
//
//  Created by David Lee on 2021/7/28.
//

import Foundation

enum FPNetworkErrorCode: Int , CaseIterable
{
    case clientNone = 0
    case clientNetworkError
    case clientHTTPConvertError
    
    
    case serverNone = 20000
    // server no content resp
    case serverRespNoContent
    // server error
    case serverRespBizError
}

enum FPNetworkResult<Resp: Decodable , Failure>
{
    case success(Resp)
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
