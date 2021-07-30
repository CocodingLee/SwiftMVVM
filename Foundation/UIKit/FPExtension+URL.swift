//
//  FPExtension+URL.swift
//  SwiftMVVM
//
//  Created by David Lee on 2021/7/30.
//

import Foundation

extension URL
{
    public var parametersFromQueryString : FPRouteInputParams
    {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true)
              , let queryItems = components.queryItems else {
            return nil
        }
        
        return queryItems.reduce(into: [String: String]())
        { (result, item) in
            result[item.name] = item.value!.removingPercentEncoding
        }
    }
}
