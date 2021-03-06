//
//  FPRouteManager.swift
//  SwiftMVVM
//
//  Created by David Lee on 2021/7/30.
//

import Foundation

let FPRouteURLScheme = "fp.route.url.scheme.key"
let FPRouteTargetKey = "fp.route.target.key"
let FPRouteErrorDomain = "fp.route.error.domain.key"
let FPRouteAdditionParam = "fp.route.addtion.params.key"

public class FPRouteManager
{
    // dispatch once
    static var shared: FPRouteManager = FPRouteManager()
    
    // reg
    private (set) var regManager: FPRouteRegManager?
    private var pluginManager: FPRoutePlugInManager?
    
    private init() {
        regManager = FPRouteRegManager()
        pluginManager = FPRoutePlugInManager()
    }
    
    /// open url
    /// - Parameters:
    ///   - url: url
    ///   - completion: callback
    func open(withURL url: URL, completion: FPRouteCompletion)
    {
        self.open(withURL: url
                  , addition: nil
                  , completion: completion)
    }
    
    /// open domain
    /// - Parameters:
    ///   - domain: domain key, which domain want to jump
    ///   - path: path key , which path want to jump
    ///   - param: input param
    ///   - completion: callback
    func open(withDomain domain: String
              , path: String
              , param: FPRouteInputParams
              , completion: FPRouteCompletion)
    {
        self.open(withScheme: nil
                  , domain: domain
                  , path: path
                  , param: param
                  , completion: completion)
    }
    
    /// open url
    /// - Parameters:
    ///   - url: url
    ///   - addition: addition params
    ///   - completion: callback
    func open(withURL url: URL
              , addition: FPRouteInputParams
              , completion: FPRouteCompletion)
    {
        var path = url.path
        if path.hasPrefix("/") {
            path = path.replacingOccurrences(of: "/", with: "")
        }
        
        var params = url.parametersFromQueryString
        if let a = addition , a.count > 0 {
            params = params?.customMergeing(other: a, combine: { first, _ in
                return first
            })
        }
        
        self.open(withScheme: url.scheme
                  , domain: url.host ?? ""
                  , path: path
                  , param: params
                  , completion: completion)
    }
    
    /// ping domain
    /// - Parameters:
    ///   - domain:domain key, which domain want to jump
    ///   - path: path key , which path want to jump
    ///   - param: input params
    ///   - completion: callback
    func ping(with domain: String
              , path: String
              , param: FPRouteInputParams
              , completion: FPRouteRegManager.FPRouteRegCompletion)
    {
        self.regManager?.checkRegs(with: domain, path: path, params: param) {
            decision , error  in
            completion(decision , error)
        }
    }
    
    private func open(withScheme scheme: String?
                      , domain: String
                      , path: String
                      , param: FPRouteInputParams
                      , completion: FPRouteCompletion)
    {
        let plugin: AnyClass? = self.pluginManager?.pluginWith(domain: domain, path: path)
        if let cls = plugin {
            self.regManager?.checkRegs(with: domain
                                       , path: path
                                       , params: param) { [weak self] decision , error in
                switch decision {
                case .FPRouteDecisionAllow:
                    self?.performRequest(with: cls
                                         , scheme: scheme
                                         , domain: domain
                                         , path: path
                                         , params: param
                                         , completion: completion)
                    
                case .FPRouteDecisionDeny:
                    completion(nil , error)
                    break
                }
                
            }
        } else {
            let err = FPErrorFactory(code: FPRouteErrorCode.FPRouteErrorNotFindPlugin.rawValue
                                     , msg: "not find plugin")
            completion(nil , err)
        }
    }
    
    private func performRequest(with plugin: AnyClass
                                , scheme: String?
                                , domain: String
                                , path: String
                                , params: FPRouteInputParams
                                , completion: FPRouteCompletion)
    {
        // flag
        var handleInstance = false
        if class_conformsToProtocol(plugin, FBRouteClassProtocol.self) {
            
            // route from
            handleInstance = self.pluginRouteFrom(    plugin: plugin as! FBRouteClassProtocol.Type
                                                      , scheme: scheme ?? ""
                                                      , domain: domain
                                                      , path: path
                                                      , params: params
                                                      , completion: completion)
            
            // route to
            if handleInstance == false {
                handleInstance = plugin.routeTo(  path: path
                                                  , params: params
                                                  , completion:completion)
                
            }
        }
        
        if handleInstance == false
           , class_conformsToProtocol(plugin, FBRouteInstanceProtocol.self) {
            let cls: FBRouteInstanceProtocol.Type = plugin as! FBRouteInstanceProtocol.Type
            let instance = cls.init(params:params)
            let key = FPRouteTargetKey
            completion([key: instance] , nil)
            
        } else {
            let s = scheme ?? ""
            let msg = "Plugin not implemented method:" + s + "//:" + domain + "/" + path
            let err = FPErrorFactory(code: FPRouteErrorCode.FPRouteErrorNotFindPlugin.rawValue, msg: msg)
            completion(nil , err)
        }
    }
    
    private func pluginRouteFrom( plugin: FBRouteClassProtocol.Type
                                  , scheme: String
                                  , domain: String
                                  , path: String
                                  , params: FPRouteInputParams
                                  , completion: FPRouteCompletion) -> Bool
    {
        let routeString = scheme + "//:" + domain + "/" + path
        let url = URL.init(string: routeString)
        
        if let u = url {
            let handledRouteFrom = plugin.routeFrom(  url: u
                                                      , path: path
                                                      , params: params
                                                      , completion: completion)
            return handledRouteFrom
        } else {
            let msg = "url scheme error:" + routeString
            let err = FPErrorFactory(code: FPRouteErrorCode.FPRouteErrorURLError.rawValue
                                     , msg: msg)
            completion(nil , err)
            return true
        }
    }
}
