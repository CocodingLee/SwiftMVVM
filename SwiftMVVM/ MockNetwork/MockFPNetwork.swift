//
//  MockFPNetwork.swift
//  SwiftMVVM
//
//  Created by David Lee on 2021/7/28.
//

import Foundation

// mock
class MobileX_HTTPRequest
{
    var path: String?
}

class MobileX_HTTPResponseBody
{
    var content: Data? = nil
}

class MobileX_HTTPResponse
{
    var code: Int = -1
    var body: MobileX_HTTPResponseBody?
}

enum MobileX_HTTPResult<T>
{
    case success(T)
    case failure(Error)
}

// mock

class MockFPNetwork
{
    // http base
    func fetch(input: MobileX_HTTPRequest
               , completion:@escaping (MobileX_HTTPResult<MobileX_HTTPResponse>) -> Void) -> Void {
        
        // 虚假请求
        var data: Data? = nil
        if ((input.path?.contains("https://sfp.xxx.xx/content")) != nil) {
            guard let path = Bundle.main.path(forResource: "mock_first_page", ofType: "json") else { return }
            let localData = NSData.init(contentsOfFile: path)! as Data
            data = localData
        }
        
        DispatchQueue.main.asyncAfter(deadline: 1) {
            let r = MobileX_HTTPResponse()
            
            r.body = MobileX_HTTPResponseBody()
            r.body?.content = data
            r.code = 200
            
            completion(.success(r))
        }
    }
}
