//
//  ActorDelegate.swift
//  Atlas Core
//
//  Created by Dusty Artifact on 7/5/16.
//  Copyright © 2016 Suddenly Games. All rights reserved.
//

import Foundation

enum CursorState
{
	case UP, DOWN
}

enum CursorDirection
{
	case UP, DOWN, LEFT, RIGHT
}

protocol ActorDelegate
{
    // Mutation
	func changeCursorState(state:CursorState)
	func changeCursorBrush(brush:Int)
	func moveCursor(direction:CursorDirection)
	
    func placeTile(_ coord:DiscreteTileCoord, tile:Int)
    
    // Information
    func boardRange() -> TileRect
    func tileValue(_ coord:DiscreteTileCoord) -> Int
}
