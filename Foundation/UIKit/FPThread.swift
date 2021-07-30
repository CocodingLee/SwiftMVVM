//
//  FPThread.swift
//  SwiftMVVM
//
//  Created by David Lee on 2021/7/28.
//

import Foundation

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

