//
//  FPError.swift
//  SwiftMVVM
//
//  Created by David Lee on 2021/7/30.
//

import Foundation

// domain
public let FPDOMAIN = "FPErrorDomain"

public protocol FPNSError : Error
{
    /// The domain of the error.
    static var errorDomain: String { get }

    /// The error code within the given domain.
    var errorCode: Int { get }

    /// The user-info dictionary.
    var errorUserInfo: [String : Any] { get }
}

class FPErrorImpl: FPNSError
{
    static var errorDomain: String = FPDOMAIN
    var errorCode: Int = -1
    var errorUserInfo: [String : Any] = [NSLocalizedDescriptionKey: "None"]
}

public func FPErrorFactory(code: Int , msg: String?) -> FPNSError
{
    let e = FPErrorImpl()
    e.errorCode = code
    e.errorUserInfo[NSLocalizedDescriptionKey] = msg ?? ""
    
    return e
}

public func FPErrorFactory(code: Int , msg: String? , domain: String = FPDOMAIN) -> FPNSError
{
    let e = FPErrorImpl()
    e.errorCode = code
    e.errorUserInfo[NSLocalizedDescriptionKey] = msg ?? ""
    
    return e
}
