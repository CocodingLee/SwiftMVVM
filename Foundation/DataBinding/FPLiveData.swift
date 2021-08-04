//
//  LiveData.swift
//  SwiftMVVM
//
//  Created by David Lee on 2021/7/26.
//

import Foundation

class FPDisposedBag {
    var willBeDeInit: [(() -> Void)?] = []
    
    deinit {
        willBeDeInit.forEach { $0?() }
        willBeDeInit = []
    }
}

// weak reference
class FPDisposeable<T> {
    var completion: ((T) -> Void)?
    weak var observer: AnyObject?
    weak var liveData: FPLiveData<T>?
    
    func disposed(by tag:FPDisposedBag) -> Void {
        tag.willBeDeInit.append {
            [weak self] in
            
            guard let o = self?.observer else {
                return
            }
            
            self?.liveData?.remove(observer: o)
        }
    }
    
}

class FPLiveData<T> {
    
    /// A class with generic data holder
    private(set) var value: T? {
        didSet {
            notifyAllObservers()
        }
    }
    
    /// all obs
    private var observers: [FPDisposeable<T>] = []
    
    /// notify
    private func notifyAllObservers() {
        observers.forEach {
            notifyOne(observer: $0)
        }
    }
    
    /// notify the one observer
    /// - Parameter observer: the target observer
    private func notifyOne(observer: FPDisposeable<T>) {
        guard let value = self.value else { return }
        observer.completion?(value)
    }
    
    /// trigger notify all obs
    /// - Parameter value: raw value
    /// - Returns: no return
    func publish(value: T) -> Void {
        self.value = value
    }
    
    func add(observer: AnyObject, completion: @escaping (T) -> Void) -> FPDisposeable<T> {
        let weakWrapper = FPDisposeable<T>()
        weakWrapper.completion = completion
        weakWrapper.observer = observer
        weakWrapper.liveData = self
        
        observers.append(weakWrapper)
        notifyOne(observer: weakWrapper)
        
        return weakWrapper
    }
    
    func remove(observer: AnyObject) {
        observers.removeFirst {
            $0.observer === observer
        }
    }
}

extension Array {
    mutating func removeFirst(where: ((Element) -> Bool)) {
        for i in 0..<count {
            guard `where`(self[i]) else { continue }
            self.remove(at: i)
            break
        }
    }
}
