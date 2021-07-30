//
//  FPError.swift
//  SwiftMVVM
//
//  Created by David Lee on 2021/7/30.
//

import Foundation

public protocol FPNSError : Error {

    /// The domain of the error.
    static var errorDomain: String { get }

    /// The error code within the given domain.
    var errorCode: Int { get }

    /// The user-info dictionary.
    var errorUserInfo: [String : Any] { get }
}

class FPErrorImpl: FPNSError
{
    static var errorDomain: String = "FPErrorDomain"
    var errorCode: Int = -1
    var errorUserInfo: [String : Any] = [NSLocalizedDescriptionKey: "None"]
}

// error
func FPError2BaseError(with error: Error) -> FPBaseError {
    if let err = error as? FPBaseError {
        return err
    } else {
        return .clientUnExpectError(error)
    }
}

public func FPErrorCreate(code: Int , msg: String) -> Error
{
    let e = FPErrorImpl()
    e.errorCode = code
    e.errorUserInfo[NSLocalizedDescriptionKey] = msg
    
    return e
}
