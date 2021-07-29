//
//  FPRouteRegManager.swift
//  SwiftMVVM
//
//  Created by David Lee on 2021/7/29.
//

import Foundation

class FPRouteRegManager
{
    lazy private var rootReg: FPRouteRegTree = FPRouteRegTree()
    
    /// add rules
    /// - Parameters:
    ///   - reg: rule handler object
    ///   - domain: url domain
    ///   - path: url path
    func addReg(reg: FPRouteRegTreeDelegate , domain: String , path: String)
    {
        let leftNode = self.leafNodeAt(domain: domain, path: path)
        if var regs = leftNode.regs {
            regs.append(reg)
        } else {
            leftNode.regs = [reg]
        }
    }
    
    /// match rules
    /// - Parameters:
    ///   - domain: url domain
    ///   - path: url path
    /// - Returns: current reg object
    func matchRegs(with domain: String , path: String) -> [FPRouteRegTreeDelegate]? {
        
        var treePath = [domain];
        let array = path.components(separatedBy: ".")
        treePath.append(contentsOf: array)
        
        // domain
        var leafNode = self.rootReg
        while treePath.count > 0 , let subRegTree = leafNode.children?[domain] {
            leafNode = subRegTree
            treePath.remove(at: 0)
        }
        
        var regs = leafNode.regs
        var currentNode: FPRouteRegTree? = leafNode
        if regs == nil , let node = currentNode {
            currentNode = node.father
            regs = node.regs
        }
        
        return regs
    }
    
    /// check reg domain
    /// - Parameters:
    ///   - domain: url domain
    ///   - path: url path
    ///   - params: params
    ///   - completion: callback
    func checkRegsWithDomain(domain: String
                             , path: String
                             , params: [String: Any]
                             , completion:@escaping (FPRouteDecision , FPRouteError) -> Void)
    {
        let regs = self.matchRegs(with: domain, path: path);
        if regs?.count == 0 {
            completion(.FPRouteDecisionAllow , .FPRouteErrorNone)
        } else {
            
            if let r = regs , r.count > 0 {
                self .checkRegs(with: r
                                , domain: domain
                                , path: path
                                , params: params
                                , completion: completion)
            } else {
                completion(.FPRouteDecisionAllow , .FPRouteErrorNoRegs)
            }
        }
    }
    
    //
    // MARK: private function
    //
    private func leafNodeAt(domain: String , path: String) -> FPRouteRegTree
    {
        var treePath = [domain];
        let array = path.components(separatedBy: ".")
        treePath.append(contentsOf: array)
        
        return leafNodeAt(pathsSeg: treePath, fromNode: self.rootReg)
    }
    
    private func leafNodeAt(pathsSeg: [String] , fromNode: FPRouteRegTree) -> FPRouteRegTree
    {
        var nextPathSeg = pathsSeg
        
        // domain
        let domain = nextPathSeg.first!
        nextPathSeg.remove(at: 0)
        
        // path
        var children: [String: FPRouteRegTree]? = nil
        if let c = fromNode.children {
            children = c
            fromNode.children = nil
        } else {
            children = [:]
        }
        
        assert(children != nil)
        
        // next
        var nextNode: FPRouteRegTree? = nil
        if children![domain] == nil {
            let newNode = FPRouteRegTree()
            children![domain] = newNode
            newNode.father = fromNode
        }
        
        fromNode.children = children
        nextNode = children![domain]
        
        assert(nextNode != nil)
        
        if nextPathSeg.count == 0 {
            return nextNode!
        } else {
            return self.leafNodeAt(pathsSeg: nextPathSeg, fromNode: nextNode!)
        }
    }
    
    private func checkRegs(with regs: [FPRouteRegTreeDelegate]
                           , domain: String
                           , path: String
                           , params: [String: Any]
                           , completion: (FPRouteDecision , FPRouteError) -> Void)
    {
        if regs.count > 0 {
            var nextRegs = regs
            nextRegs.remove(at: 0)
            
            let reg = regs.first
            reg?.regWithDomain(domain: domain
                               , path: path
                               , param: params)  {
                
                [weak self] decision, error in
                switch (decision) {
                case .FPRouteDecisionDeny:
                    completion(.FPRouteDecisionDeny, error);
                    
                case .FPRouteDecisionAllow:
                    if (nextRegs.count == 0) {
                        completion(.FPRouteDecisionAllow, .FPRouteErrorNone);
                    } else {
                        self?.checkRegs(with: nextRegs
                                        , domain: domain
                                        , path: path
                                        , params: params
                                        , completion: completion)
                    }
                } // switch (decision)
            } // reg?.regWithDomain
        } // if regs.count
    }
    
    
} // class

