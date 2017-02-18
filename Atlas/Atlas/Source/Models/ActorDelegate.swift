//
//  ActorDelegate.swift
//  Atlas Core
//
//  Created by Dusty Artifact on 7/5/16.
//  Copyright © 2016 Suddenly Games. All rights reserved.
//

import Foundation

protocol ActorDelegate
{
    // Mutation
    func placeTile(_ coord:DiscreteTileCoord, tile:Int)
    
    // Information
    func boardRange() -> TileRect
    func tileValue(_ coord:DiscreteTileCoord) -> Int
}
