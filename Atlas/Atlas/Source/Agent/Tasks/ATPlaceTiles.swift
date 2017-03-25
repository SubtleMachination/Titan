//
//  FillSquare2.swift
//  Atlas
//
//  Created by Dusty Artifact on 3/10/17.
//  Copyright © 2017 Overmind. All rights reserved.
//

import Foundation

class ATPlaceTiles: Task
{
	var sequence:[TileAssignment]
	
	init(delegate:ActorDelegate, sequence:[TileAssignment])
	{
		self.sequence = sequence
		
		super.init(delegate:delegate)
	}
	
	convenience init(delegate:ActorDelegate, tileSequence:[DiscreteTileCoord], value:Int)
	{
		var actionSequence = [TileAssignment]()
		for element in tileSequence
		{
			actionSequence.append(TileAssignment(coord:element, value:value))
		}
		
		self.init(delegate:delegate, sequence:actionSequence)
	}
	
	override func execute()
	{
		for element in sequence
		{
			delegate.placeTile(element.coord, tile:element.value)
		}
	}
}
