//
//  FPRouteProtocol.swift
//  SwiftMVVM
//
//  Created by David Lee on 2021/7/27.
//

import Foundation

// 当前路由业务类型值
public enum FPRouteDecision: Int , CaseIterable
{
    case FPRouteDecisionDeny  = 0
    case FPRouteDecisionAllow
};

public enum FPRouteError: Error {
    case FPRouteErrorNone
    case FPRouteErrorNoRegs
    
    //
    case FPRouteErrorNotFindPlugin
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
    init (params: [String: Any]?)
    
}

/// route to static type
@objc public protocol FBRouteClassProtocol: FBRouteBaseProtocol
{
    static func routeFrom(url: URL
                          , path: String
                          , params: [String: Any]?
                          , completion:([String: Any]? , Error) -> Void )
    
    static func routeTo(path: String
                        , params:[String: Any]
                        , completion:([String: Any]? , Error) -> Void)
}
