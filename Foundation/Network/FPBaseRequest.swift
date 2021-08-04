//
//  FPBaseRequest.swift
//  SwiftMVVM
//
//  Created by David Lee on 2021/7/28.
//

import Foundation

enum FPHTTPMethod: String
{
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"
}

enum FPParameterEncoding
{
    case url, json
}

enum FPHTTPsDomain: String
{
    case url = "xxxxxx.xxxxx.xxx"
}

class FPBaseRequest
{
    var path: String = ""
    var method: String = FPHTTPMethod.post.rawValue
    
    var headers: [String: String] = [:]
    var parameters: [String: Any] = [:]
    var queryParameters: [String:String] = [:]
    
    var parameterEcoding: FPParameterEncoding = .json
    var timeout: TimeInterval = 60.0
    
}

extension FPBaseRequest: CustomStringConvertible
{
    var description: String {
        """
        Path: \(path)
        Method: \(method)
        Headers: \(headers)
        Parameters: \(parameters)
        QueryParameters: \(queryParameters)
        Ecoding: \(parameterEcoding)
        """
    }
}

extension FPBaseRequest
{
    func asHTTPRequest() throws -> MobileX_HTTPRequest {
        if (1 != 1) {
            let err = FPErrorFactory(code: FPNetworkErrorCode.clientNetworkError.rawValue
                                     , msg: "call FPBaseRequest - asHTTPRequest")
            throw err
        }
        
        var h = MobileX_HTTPRequest()
        h.path = self.path
        return h
    }
}

//
// -------------------------------------------------
//
// MARK: other request type

class FPHTTPsRequest: FPBaseRequest
{
    let scheme: String = "https"
    let domain: String = FPHTTPsDomain.url.rawValue
    var prefixPath: String = ""
    var subPath: String = ""
    
    override var path: String {
        
        get {
            var p = ""
            if !prefixPath.isEmpty {
                p += "/\(prefixPath)"
            }
            
            if !subPath.isEmpty {
                p += "/\(subPath)"
            }
            
            return p
        }
        
        set {
            super.path = newValue
            fatalError("no need set https path , should use prefix/sub path")
        }  
    }
    
}

// post request
final class FPHTTPsPostRequest: FPHTTPsRequest
{
    override init() {
        super.init()
        method = FPHTTPMethod.post.rawValue
    }
}

final class FPHTTPsGetRequest: FPHTTPsRequest
{
    override init() {
        super.init()
        method = FPHTTPMethod.get.rawValue
    }
}


