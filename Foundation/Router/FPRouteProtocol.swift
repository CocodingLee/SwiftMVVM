//
//  FPRouteProtocol.swift
//  SwiftMVVM
//
//  Created by David Lee on 2021/7/27.
//

import Foundation

@objc protocol FBRouteProtocol {
    
    /**
     业务域

     @return 当前名称
     */
    static var supportedDomain: String { get }

    /**
     如果不实现这个方法，则默认添加一个Path为*的插件，
     当某个跳转的path未能命中该domain下的任一个插件时，会寻找*插件

     @return 当前支持的路径，业务分支
     */
    //+ (NSArray *)supportedPath;
    static var supportedPath: [String]  { get }

    /**
     初始化

     @param params 参数
     @return 当前实例
     */
    init(params: Dictionary<String, Any>)
}
