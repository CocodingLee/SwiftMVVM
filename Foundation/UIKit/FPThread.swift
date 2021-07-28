//
//  FPThread.swift
//  SwiftMVVM
//
//  Created by David Lee on 2021/7/28.
//

import Foundation

extension DispatchTime: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = DispatchTime.now() + .seconds(value)
    }
}

extension DispatchTime: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = DispatchTime.now() + .milliseconds(Int(value * 1000))
    }
}

func FPAsyncOnMain(block: @escaping () -> Void) -> Void
{
    if Thread.isMainThread {
        block()
    } else {
        DispatchQueue.main.async {
            block()
        }
    }
}

func FPAsyncForceOnMain(block: @escaping () -> Void) -> Void
{
    DispatchQueue.main.async {
        block()
    }
}

func FPAsyncForceOnMainDelay(delay:Int , block: @escaping () -> Void) -> Void
{
    DispatchQueue.main.asyncAfter(deadline:DispatchTime(integerLiteral: delay) , execute: {
        block()
    })
}

