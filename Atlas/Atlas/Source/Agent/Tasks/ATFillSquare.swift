//
//  FillSquare2.swift
//  Atlas
//
//  Created by Dusty Artifact on 3/10/17.
//  Copyright © 2017 Overmind. All rights reserved.
//

import Foundation

class ATFillSquare: Task
{
	// Parameters
	var area:TileRect
	var value:Int
	
	var remainingTiles:Shape
	var estimatedTiles:Int
	
	init(delegate:ActorDelegate, area:TileRect, value:Int)
	{
		// Parameters
		self.area = area
		self.value = value
		
		self.remainingTiles = Shape()
		self.estimatedTiles = 0
		
		super.init(delegate:delegate)
	}
	
	override func initialize() {
		
		for coord in area.allCoords()
		{
			if (delegate.tileValue(coord) != self.value)
			{
				remainingTiles.addNode(coord)
			}
		}
		
		self.estimatedTiles = self.remainingTiles.count()
	}
	
	override func evaluate() -> Double
	{
		if (self.estimatedTiles == 0)
		{
			return 1.0
		}
		else
		{
			return 1.0 - (Double(self.remainingTiles.count()) / Double(self.estimatedTiles))
		}
	}
	
	override func decide() -> Task?
	{
		var task:Task?
		
		
		////////////////////////////////////////////////////////////////////////
		// OUTER RING INWARD
		////////////////////////////////////////////////////////////////////////
		var sequence = [TileAssignment]()
		for coord in remainingTiles.intrusionPool(0, rEnd:0)
		{
			let assignment = TileAssignment(coord:coord, value:1)
			remainingTiles.removeNode(coord)
			sequence.append(assignment)
		}
		
		print(sequence.count)
		
		task = ATPlaceTiles(delegate:delegate, sequence:sequence)
		
		////////////////////////////////////////////////////////////////////////
		// PURE RANDOM
		////////////////////////////////////////////////////////////////////////
		
//		if let nextCoord = randomRemainingTile()
//		{
//			self.remainingTiles.removeNode(nextCoord)
//			return ATPlaceTile(delegate:delegate, coord:nextCoord, value:self.value)
//		}
		
		return task
		
	}
	
	////////////////////////////////////////////////////////////////////////////////////
	// Utility
	////////////////////////////////////////////////////////////////////////////////////
	
	func randomRemainingTile() -> DiscreteTileCoord?
	{
		return self.remainingTiles.shapeMass().randomElement()
	}
}
