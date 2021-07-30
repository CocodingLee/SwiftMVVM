//
//  FPExtension+Dictionary.swift
//  SwiftMVVM
//
//  Created by David Lee on 2021/7/30.
//

import Foundation

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
