//
//  FPRoutePlugInManager.swift
//  SwiftMVVM
//
//  Created by David Lee on 2021/7/29.
//

import Foundation

class FPRoutePlugInManager
{
    lazy private var domain2Plugins = [String: [String: AnyClass]]()
    init() {
        scanPlugIn()
    }
    
    func pluginWith(domain: String , path: String) -> AnyClass? {
        let lowerDomain = domain.lowercased()
        let lowerPath = path.lowercased()
        
        let plugin = domain2Plugins[lowerDomain]
        if let p = plugin , p.count > 0 {
            let cls: AnyClass? = p[lowerPath]
            return cls
        }
        
        return nil
    }
    
    private func scanPlugIn()
    {
        let tmp = FPRuntime.classes(conformToProtocol: FBRouteBaseProtocol.self)
        for c in tmp {
            let sd = c.supportedDomain ?? ""
            let domain = sd.lowercased()
            
            var path2Plugin : [String: AnyClass]? = nil
            if let plugin = domain2Plugins[domain] {
                path2Plugin = plugin
            } else {
                path2Plugin = [String: AnyClass]()
            }
            
            assert(path2Plugin != nil)
            
            let paths = c.supportedPath ?? []
            if paths.count <= 0 {
                path2Plugin!["*"] = c
            } else {
                for p in paths {
                    let pp = p.lowercased()
                    path2Plugin![pp] = c
                }
            }
            
            domain2Plugins[domain] = path2Plugin
        }
    }
}
