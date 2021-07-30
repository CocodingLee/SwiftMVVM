//
//  FPExtension+DispatchTime.swift
//  SwiftMVVM
//
//  Created by David Lee on 2021/7/30.
//

import Foundation

extension DispatchTime: ExpressibleByIntegerLiteral
{
    public init(integerLiteral value: Int) {
        self = DispatchTime.now() + .seconds(value)
    }
}

extension DispatchTime: ExpressibleByFloatLiteral
{
    public init(floatLiteral value: Double) {
        self = DispatchTime.now() + .milliseconds(Int(value * 1000))
    }
}
