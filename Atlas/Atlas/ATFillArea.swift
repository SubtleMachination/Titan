//
//  FillSquare2.swift
//  Atlas
//
//  Created by Dusty Artifact on 3/10/17.
//  Copyright © 2017 Overmind. All rights reserved.
//

import Foundation

class ATFillArea: Task
{
	// Parameters
	var area:Set<DiscreteTileCoord>
	var remainingArea:Set<DiscreteTileCoord>
	var value:Int
	
	var cursor:DiscreteTileCoord
	var direction:Direction
	
	var estimatedTiles:Int
	
	init(delegate:ActorDelegate, area:Set<DiscreteTileCoord>, value:Int)
	{
		// Parameters
		self.area = area
		self.remainingArea = area
		self.value = value
		
		self.cursor = DiscreteTileCoord(x:0, y:0)
		self.direction = Direction.RIGHT
		
		self.estimatedTiles = 0
		
		super.init(delegate:delegate)
	}
	
	override func initialize()
	{
		for coord in self.area
		{
			let currentValue = delegate.tileValue(coord)
			if (currentValue != value)
			{
				self.remainingArea.insert(coord)
			}
		}
		
		self.estimatedTiles = remainingArea.count
		
		if let randomElement = remainingArea.randomElement()
		{
			self.cursor = randomElement
		}
	}
	
	override func evaluate() -> Double
	{
		if (self.remainingArea.count == 0)
		{
			return 1.0
		}
		else
		{
			return 1.0 - (Double(self.remainingArea.count) / Double(self.estimatedTiles))
		}
	}
	
	override func decide() -> Task?
	{
		var task:Task?
		
		var nextSequence = [DiscreteTileCoord]()
		for _ in 1...4
		{
			if !(nextSequence.count > 0)
			{
				nextSequence = getNextSequence()
				switchDirection()
			}
		}
		
		if (nextSequence.count == 1)
		{
			let nextCoord = nextSequence[0]
			task = ATPlaceTile(delegate:delegate, coord:nextCoord, value:self.value)
			self.remainingArea.remove(nextCoord)
		}
		else if (nextSequence.count > 1)
		{
			var assignments = [TileAssignment]()
			for coord in nextSequence
			{
				assignments.append(TileAssignment(coord:coord, value:self.value))
				self.remainingArea.remove(coord)
			}

			task = ATPlaceTiles(delegate:delegate, sequence:assignments)
		}
		else
		{
			if let nextCoord = findClosestRemainingTile()
			{
				self.cursor = nextCoord
				task = ATPlaceTile(delegate:delegate, coord:nextCoord, value:self.value)
				self.remainingArea.remove(nextCoord)
			}
		}
		
		return task
		
	}
	
	////////////////////////////////////////////////////////////////////////////////////
	// Utility
	////////////////////////////////////////////////////////////////////////////////////
	// Given the current cursor and direction, get the next sequence of uninterrupted remaining tiles
	func getNextSequence() -> [DiscreteTileCoord]
	{
		var tempCoord = self.cursor
		
		var sequence = [DiscreteTileCoord]()
		
		if (self.direction == Direction.UP || self.direction == Direction.DOWN)
		{
			if (remainingArea.contains(tempCoord))
			{
				sequence.append(tempCoord)
			}
				
			tempCoord == nudgeInDirection(coord:tempCoord)
			if (remainingArea.contains(tempCoord))
			{
				sequence.append(tempCoord)
				self.cursor = tempCoord
			}
		}
		else
		{
			var terminus_reached = false
			
			while (!terminus_reached)
			{
				if (remainingArea.contains(tempCoord))
				{
					sequence.append(tempCoord)
					self.cursor = tempCoord
					tempCoord = nudgeInDirection(coord:tempCoord)
				}
				else
				{
					terminus_reached = true
				}
			}
		}
		
		return sequence
	}
	
	func nudgeInDirection(coord:DiscreteTileCoord) -> DiscreteTileCoord
	{
		var nudgedCoord = coord
		
		switch (self.direction)
		{
			case Direction.UP:
				nudgedCoord = coord.up()
				break
			case Direction.RIGHT:
				nudgedCoord = coord.right()
				break
			case Direction.DOWN:
				nudgedCoord = coord.down()
				break
			case Direction.LEFT:
				nudgedCoord = coord.left()
				break
		}
		
		return nudgedCoord
	}
	
	// Locate the closest remaining tile to the current cursor
	func findClosestRemainingTile() -> DiscreteTileCoord?
	{
		var closestTile:DiscreteTileCoord?
		
		if (remainingArea.contains(self.cursor)) {
			// If the current cursor is valid, use that
			closestTile = self.cursor
		}
			
		if (closestTile == nil)
		{
			// Check the immediate neighbors next
			let neighborhood = self.cursor.neighborhood()
			for coord in neighborhood
			{
				if (remainingArea.contains(coord))
				{
					closestTile = coord
					break
				}
			}
		}
		
		if (closestTile == nil)
		{
			// Check everything else, find the closest (brute-force)
			var closestDistanceSoFar = 10000
			
			for coord in self.remainingArea
			{
				let distance = self.cursor.squareDistance(coord)
				if (closestDistanceSoFar > distance)
				{
					closestDistanceSoFar = distance
					closestTile = coord
				}
			}
		}
		
		return closestTile
	}
	
	func switchDirection()
	{
		switch (self.direction)
		{
			case Direction.RIGHT:
				self.direction = Direction.DOWN
				break
			case Direction.DOWN:
				self.direction = Direction.LEFT
				break
			case Direction.LEFT:
				self.direction = Direction.UP
				break
			case Direction.UP:
				self.direction = Direction.RIGHT
				break
		}
	}
}
