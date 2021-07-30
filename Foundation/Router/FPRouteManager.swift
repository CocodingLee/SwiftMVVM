//
//  FPRouteManager.swift
//  SwiftMVVM
//
//  Created by David Lee on 2021/7/30.
//

import Foundation

public enum FPRouteKey: String {
    case FPRouteURLScheme = "fp.route.url.scheme.key"
    case FPRouteTargetKey = "fp.route.target.key"
    case FPRouteErrorDomain = "fp.route.error.domain.key"
    case FPRouteAdditionParam = "fp.route.addtion.params.key"
}

extension URL
{
    public var parametersFromQueryString : FPRouteInputParams {
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

extension Dictionary
{
    func customMergeing(other: Dictionary, combine: (_ v1: Value, _ v2: Value) -> Value) -> [Key: Value] {
        var result = self
        // 找出不同的key，并将相应的 value 添加到 result 中
        let key1 = Set(self.keys)
        let key2 = Set(other.keys)
        let diff = key2.subtracting(key1)
        for key in diff {
            result[key] = other[key]
        }
        
        // 找出相同的key，并将相应的 value 添加到 result 中
        let common = key1.intersection(key2)
        for key in common {
            result[key] = combine(self[key]!, other[key]!)
        }
        return result
    }
}


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
    func open(with url: URL, completion: FPRoutePCompletion)
    {
        self.open(with: url
                  , addition: nil
                  , completion: completion)
    }
    
    /// open domain
    /// - Parameters:
    ///   - domain: domain key, which domain want to jump
    ///   - path: path key , which path want to jump
    ///   - param: input param
    ///   - completion: callback
    func open(with domain: String
              , path: String
              , param: FPRouteInputParams
              , completion: FPRoutePCompletion)
    {
        self.openScheme(with: nil
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
    func open(with url: URL
              , addition: FPRouteInputParams
              , completion: FPRoutePCompletion)
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
        
        self.openScheme(with: url.scheme
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
    
    private func openScheme(with scheme: String?
                            , domain: String
                            , path: String
                            , param: FPRouteInputParams
                            , completion: FPRoutePCompletion)
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
            let err = FPErrorCreate(code: FPRouteErrorCode.FPRouteErrorNotFindPlugin.rawValue
                                    , msg: "not find plugin")
            completion(nil , err)
        }
    }
    
    private func performRequest(with plugin: AnyClass
                                , scheme: String?
                                , domain: String
                                , path: String
                                , params: FPRouteInputParams
                                , completion: FPRoutePCompletion)
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
            let key = FPRouteKey.FPRouteTargetKey.rawValue
            completion([key: instance] , nil)
            
        } else {
            let s = scheme ?? ""
            let msg = "Plugin not implemented method:" + s + "//:" + domain + "/" + path
            let err = FPErrorCreate(code: FPRouteErrorCode.FPRouteErrorNotFindPlugin.rawValue, msg: msg)
            completion(nil , err)
        }
    }
    
    private func pluginRouteFrom( plugin: FBRouteClassProtocol.Type
                                  , scheme: String
                                  , domain: String
                                  , path: String
                                  , params: FPRouteInputParams
                                  , completion: FPRoutePCompletion) -> Bool
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
            let err = FPErrorCreate(code: FPRouteErrorCode.FPRouteErrorURLError.rawValue
                                    , msg: msg)
            completion(nil , err)
            return true
        }
    }
}
