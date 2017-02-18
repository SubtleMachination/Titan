//
//  ChangeQueue.swift
//  Atlas Editor
//
//  Created by Dusty Artifact on 1/25/16.
//  Copyright © 2016 Dusty Artifact. All rights reserved.
//

import Foundation
import SpriteKit

struct Change
{
    var coord:DiscreteTileCoord
    var layer:TileLayer
    var value:Int
    var collaboratorUUID:String?
}

class ChangeQueue
{
    var changes:Stack<Change>
    let capacity:Int
    
    init(capacity:Int)
    {
        changes = Stack<Change>()
        self.capacity = capacity
    }
    
    func pushChange(_ newChange:Change)
    {
        if (capacity < 0 || changes.arrayCount() < capacity)
        {
            changes.append(newChange)
        }
    }
    
    func popChange() -> Change?
    {
        var change:Change?
        
        if (changes.arrayCount() > 0)
        {
            change = changes.removeFirst()
        }
        
        return change
    }
}
