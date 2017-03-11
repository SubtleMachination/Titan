//
//  FillSquare2.swift
//  Atlas
//
//  Created by Dusty Artifact on 3/10/17.
//  Copyright © 2017 Overmind. All rights reserved.
//

import Foundation

class ATPlaceTile: Task
{
	var coord:DiscreteTileCoord
	var value:Int
	
	init(delegate:ActorDelegate, coord:DiscreteTileCoord, value:Int)
	{
		self.coord = coord
		self.value = value
		
		super.init(delegate:delegate)
	}
	
	// ATOMIC TASK: no IDEA logic necessary
	override func execute() {
		delegate.placeTile(coord, tile:value)
	}
}
