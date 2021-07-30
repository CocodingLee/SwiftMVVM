//
//  FPBaseModel.swift
//  SwiftMVVM
//
//  Created by David Lee on 2021/7/27.
//

import Foundation

class FPNetworkModel {
    
    // TODO:集成到mobileX
    // http base
    class func fetch<Req:FPBaseRequest, Resp:Decodable>(request: Req,
                                                        resposeType: Resp.Type,
                                                        completion: @escaping (Req , FPNetworkResult<Resp , FPBaseError>) -> Void)
    -> Void {
        
        #if MOCK_HTTP_DATA
        
        // 虚假请求
        let httpClient = MockFPNetwork()
        var httpRequest: MobileX_HTTPRequest!
        
        #else
        // 真实网络请求
        let httpClient = MockFPNetwork()
        var httpRequest: MobileX_HTTPRequest!
        
        #endif
        
        do {
            httpRequest = try request.asHTTPRequest()
        } catch {
            // callback
            FPAsyncOnMain {
                let err = FPError2BaseError(with: error)
                completion(request, .failure(err))
            }
        }
        
        // fetch data
        httpClient.fetch(input: httpRequest) { httpResponse in
            var result: FPNetworkResult<Resp , FPBaseError> = .failure(FPBaseError.errorNone)
            var statusCode: Int?
            
            switch httpResponse {
            case .success(let respose):
                statusCode = respose.code
                if let sc = statusCode , 200...299 ~= sc {
                    let data = respose.body?.content
                    if data != nil {
                        
                        do {
                            let r = try result.parse(data: data!)
                            result = .success(r)
                        } catch {
                            let err = FPError2BaseError(with: error)
                            completion(request, .failure(err))
                        }
                        
                    } else {
                        result = .failure(.networkClientError( code: .serverRespNoContent
                                                               , msg: "server response has no content"))
                    } // if data != nil
                    
                } else {
                    result = .failure(.networkServerError( code: statusCode ?? -1
                                                           , msg: "server response status code error , not in contain"))
                } //  if let sc = statusCode , 200...299 ~= sc
            
            case .failure(let error):
                let err = (error as NSError)
                result = .failure(.networkServerError(code:err.code , msg:err.description))
            }
            
            // callback
            FPAsyncOnMain {
                completion(request , result)
            }
        } // httpClient.fetch(input: httpRequest)
        
    } // func fetch<Req:FPBaseRequest, Resp:Decodable>
}
