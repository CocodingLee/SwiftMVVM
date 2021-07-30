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
    func open(with url: URL
              , completion: ([String: Any] , FPRouteError) -> Void)
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
              , param: [String: Any]?
              , completion: (FPRouteDecision , FPRouteError) -> Void)
    {
        
    }
    
    /// open url
    /// - Parameters:
    ///   - url: url
    ///   - addition: addition params
    ///   - completion: callback
    func open(with url: URL
              , addition: [String: Any]?
              , completion: ([String: Any] , FPRouteError) -> Void) {
        
    }
    
    /// ping domain
    /// - Parameters:
    ///   - domain:domain key, which domain want to jump
    ///   - path: path key , which path want to jump
    ///   - param: input params
    ///   - completion: callback
    func ping(with domain: String
              , path: String
              , param: [String: Any]?
              , completion: (FPRouteDecision , FPRouteError) -> Void) {
        
    }
    
    private func openScheme(with scheme: String
                           , domain: String
                           , path: String
                           , param: [String: Any]?
                           , completion: ([String: Any]? , FPRouteError) -> Void)
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
            completion(nil , .FPRouteErrorNotFindPlugin)
        }
    }
    
    
    private func performRequest(with plugin: AnyClass
                                , scheme: String
                                , domain: String
                                , path: String
                                , params:[String:Any]?
                                , completion: ([String: Any] , FPRouteError) -> Void)
    {
//        NSString *routeString = [NSString stringWithFormat:@"%@://%@/%@", scheme ?: GPRouteURLScheme, domain, path];
//        NSURL *routeURL = [NSURL URLWithString:routeString];
//
//        NSString *toPathSelString = [NSString stringWithFormat:@"route%@WithURL:params:completion:",[self parsePathToSignature:path]];
//        SEL toPathSel = NSSelectorFromString(toPathSelString);
//
//        NSString *fromPathSelString = [NSString stringWithFormat:@"routeFromURL:path:params:completion:"];
//        SEL fromPathSel = NSSelectorFromString(fromPathSelString);
//
//        PluginCompletion pluginCompletion = ^(NSDictionary *ret, NSError *error) {
//            if (completion) {
//                completion(ret, error);
//            }
//        };
//
//        if (class_getClassMethod(plugin, toPathSel)) {
//            ((void (*)(id, SEL, NSURL *, NSDictionary *, PluginCompletion))objc_msgSend)(plugin, toPathSel, routeURL, params, pluginCompletion);
//        } else if (class_getClassMethod(plugin, fromPathSel)) {
//            ((void (*)(id, SEL, NSURL *, NSString *, NSDictionary *, PluginCompletion))objc_msgSend)(plugin, fromPathSel, routeURL,
//                                                                                                     path, params, pluginCompletion);
//        } else if ([plugin instancesRespondToSelector:@selector(initWithParams:)]){
//            SEL init = NSSelectorFromString(@"initWithParams:");
//            id instance = [plugin alloc];
//
//            NSMutableDictionary *initParams = params ? [params mutableCopy] : [NSMutableDictionary new];
//            if (domain) {
//                initParams[GPRouteDomainKey] = domain;
//            }
//            if (path) {
//                initParams[GPRoutePathKey] = path;
//            }
//            initParams[GPRouteURLKey] = routeURL;
//
//            instance = ((id (*)(id, SEL, NSDictionary *))objc_msgSend)(instance, init, initParams);
//            pluginCompletion(@{ GPRouteTargetKey : instance }, nil);
//        } else {
//            if (completion) {
//                NSString *msg = [NSString stringWithFormat:@"Plugin not implemented method:%@", toPathSelString];
//                NSError *error = [NSError errorWithDomain:GPRouteErrorDomain code:-1 userInfo:@{ NSLocalizedDescriptionKey : msg }];
//                completion(nil, error);
//            }
//        }
        
        
        //
        let routeString = scheme + "//" + domain + "/" + path
        var url = URL.init(string: routeString)
    }
}
