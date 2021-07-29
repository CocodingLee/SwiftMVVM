//
//  FPRouteRegTreeDelegate.swift
//  SwiftMVVM
//
//  Created by David Lee on 2021/7/29.
//

import Foundation

// 当前路由业务类型值
enum FPRouteDecision: Int , CaseIterable
{
    case FPRouteDecisionDeny  = 0
    case FPRouteDecisionAllow
};

enum FPRouteError: Error {
    case FPRouteErrorNone
    case FPRouteErrorNoRegs
}

protocol FPRouteRegTreeDelegate
{
    func regWithDomain (domain: String
                        , path: String
                        , param: [String: Any]
                        , completion: (FPRouteDecision , FPRouteError) -> Void)
}

class FPRouteRegTree
{
    var father: FPRouteRegTree?
    var children: [String: FPRouteRegTree]?
    var regs: [FPRouteRegTreeDelegate]?
}
