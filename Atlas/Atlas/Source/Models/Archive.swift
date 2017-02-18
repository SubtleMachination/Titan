//
//  Archive.swift
//  Atlas Core
//
//  Created by Dusty Artifact on 7/2/16.
//  Copyright © 2016 Suddenly Games. All rights reserved.
//

import Foundation

class Archive
{
    var operations:[Change]
    var head:Int = 0
    var name:String?
    
    init()
    {
        operations = [Change]()
    }
    
    func registerChange(_ change:Change)
    {
        operations.append(change)
    }
    
    func nextOperation() -> Change?
    {
        var nextOp:Change?
        if (head >= 0 && head < operations.count)
        {
            nextOp = operations[head]
            head += 1
        }
        
        return nextOp
    }
}
