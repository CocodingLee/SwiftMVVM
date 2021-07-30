//
//  FPRouteProtocol.swift
//  SwiftMVVM
//
//  Created by David Lee on 2021/7/27.
//

import Foundation

/// route to static type
public typealias FPRouteInputParams = [String: Any]?
public typealias FPRoutePCompletion = (FPRouteInputParams , Error?) -> Void

// 当前路由业务类型值
public enum FPRouteDecision: Int , CaseIterable
{
    case FPRouteDecisionDeny  = 0
    case FPRouteDecisionAllow
};


public enum FPRouteErrorCode: Int , CaseIterable {
    case FPRouteErrorNone = 0
    case FPRouteErrorNoRegs
    
    //
    case FPRouteErrorNotFindPlugin
    case FPRouteErrorURLError
}


@objc public protocol FBRouteBaseProtocol {
    static var supportedDomain: String { get }
}

/// route to instace type
@objc public protocol FBRouteInstanceProtocol: FBRouteBaseProtocol
{
    // optional function
    static var supportedPath: [String]  { get }
    
    // instance of route object
    init (params: FPRouteInputParams)
}

@objc public protocol FBRouteClassProtocol: FBRouteBaseProtocol
{
    static func routeFrom(url: URL
                          , path: String
                          , params: FPRouteInputParams
                          , completion: FPRoutePCompletion) -> Bool
    
    static func routeTo(path: String
                        , params: FPRouteInputParams
                        , completion: FPRoutePCompletion) -> Bool
}

extension FBRouteClassProtocol
{
    static func routeFrom(url: URL
                          , path: String
                          , params: FPRouteInputParams
                          , completion: FPRoutePCompletion ) -> Bool
    {
        return false
    }
    
    static func routeTo(path: String
                        , params: FPRouteInputParams
                        , completion: FPRoutePCompletion)  -> Bool
    {
        return false
    }
}
