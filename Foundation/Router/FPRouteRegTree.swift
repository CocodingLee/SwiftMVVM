//
//  FPRouteRegTreeDelegate.swift
//  SwiftMVVM
//
//  Created by David Lee on 2021/7/29.
//

import Foundation


protocol FPRouteRegTreeDelegate
{
    func regWithDomain (domain: String
                        , path: String
                        , param: [String: Any]
                        , completion: (FPRouteDecision , FPNSError?) -> Void)
}

class FPRouteRegTree
{
    var father: FPRouteRegTree?
    var children: [String: FPRouteRegTree]?
    var regs: [FPRouteRegTreeDelegate]?
}
