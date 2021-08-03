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
                                                        completion: @escaping (Req , FPNetworkResult<Resp , FPNSError>) -> Void)
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
                
                // todo - liyanwei
                //let err = FPError2BaseError(with: error)
                //completion(request, .failure(err))
            }
        }
        
        // fetch data
        httpClient.fetch(input: httpRequest) { httpResponse in
            
            let err = FPErrorFactory(code: FPNetworkErrorCode.clientNone.rawValue, msg: "")
            var result: FPNetworkResult<Resp , FPNSError> = .failure(err)
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
                            let err = (error as NSError)
                            let fpError = FPErrorFactory(code: err.code, msg: err.description)
                            completion(request, .failure(fpError))
                        }
                        
                    } else {
                        let err = FPErrorFactory(code: FPNetworkErrorCode.serverRespNoContent.rawValue
                                                 , msg: "server response has no content")
                        result = .failure(err)
                    } // if data != nil
                    
                } else {
                    let msg = "server response status code error = \(statusCode ?? 0), not in contain"
                    let err = FPErrorFactory(code: FPNetworkErrorCode.serverRespBizError.rawValue
                                             , msg: msg)
                    result = .failure(err)
                } //  if let sc = statusCode , 200...299 ~= sc
            
            case .failure(let error):
                let err = (error as NSError)
                
                let msg = "server response status code error = \(err.code), not in contain ; \(err.description)"
                let fpError = FPErrorFactory(code: FPNetworkErrorCode.clientNetworkError.rawValue
                                             , msg: msg)
                result = .failure(fpError)
            }
            
            // callback
            FPAsyncOnMain {
                completion(request , result)
            }
        } // httpClient.fetch(input: httpRequest)
        
    } // func fetch<Req:FPBaseRequest, Resp:Decodable>
}
