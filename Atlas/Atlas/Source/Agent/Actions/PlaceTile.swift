//
//  PlaceTileMod.swift
//  Atlas Core
//
//  Created by Dusty Artifact on 7/5/16.
//  Copyright © 2016 Suddenly Games. All rights reserved.
//

import Foundation

class PlaceTile
{
    let delegate:ActorDelegate
    
    var coord:DiscreteTileCoord
    var tile:Int
    
    init(delegate:ActorDelegate, coord:DiscreteTileCoord, tile:Int)
    {
        self.delegate = delegate
        self.coord = coord
        self.tile = tile
    }
    
    func trigger()
    {
        delegate.placeTile(coord, tile:tile)
    }
}
