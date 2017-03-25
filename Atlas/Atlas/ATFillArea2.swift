//
//  FillSquare2.swift
//  Atlas
//
//  Created by Dusty Artifact on 3/10/17.
//  Copyright © 2017 Overmind. All rights reserved.
//

import Foundation

class ATFillArea2: Task
{
	// Parameters
	var area:Set<DiscreteTileCoord>
	var value:Int
	
	init(delegate:ActorDelegate, area:Set<DiscreteTileCoord>, value:Int)
	{
		// Parameters
		self.area = area
		self.value = value
		
		super.init(delegate:delegate)
	}
	
	override func execute()
	{
		var remainingArea = Set<DiscreteTileCoord>()
		
		for coord in self.area
		{
			if delegate.tileValue(coord) != self.value
			{
				remainingArea.insert(coord)
			}
		}
		
		var cursor = DiscreteTileCoord(x:0, y:0)
		if let randomStartingCursor = remainingArea.randomElement()
		{
			cursor = randomStartingCursor
		}
		
		var horizontal_mode = Direction.RIGHT
		var mode = Axis.HORIZONTAL
		
		while(remainingArea.count > 0)
		{
			var directions = [Direction]()
			var horizontal_directions = [Direction]()
			
			if (horizontal_mode == Direction.RIGHT)
			{
				horizontal_directions = [Direction.RIGHT, Direction.LEFT]
			}
			else if (horizontal_mode == Direction.LEFT)
			{
				horizontal_directions = [Direction.LEFT, Direction.RIGHT]
			}
			
			if (mode == Axis.HORIZONTAL)
			{
				directions = horizontal_directions + [Direction.DOWN, Direction.UP]
			}
			else if (mode == Axis.VERTICAL)
			{
				directions = [Direction.DOWN, Direction.UP] + horizontal_directions
			}
			
			var successfulDirection:Direction?
			var successfulDirectionFound = false
			
			for direction in directions
			{
				if (!successfulDirectionFound && canGoDirection(cursor:cursor, direction:direction, remaining:remainingArea))
				{
					successfulDirection = direction
					let sequence = getNextSequence(cursor:cursor, direction:direction, remaining:remainingArea)
					
					if (sequence.count > 0)
					{
						for coord in sequence
						{
							remainingArea.remove(coord)
							ATPlaceTile(delegate:delegate, coord:coord, value:self.value).execute()
							cursor = coord
						}
					}
					else
					{
						successfulDirectionFound = true
					}
				}
			}
			
			if let direction = successfulDirection
			{
				if (direction == Direction.UP || direction == Direction.DOWN)
				{
					mode = Axis.HORIZONTAL
				}
				else
				{
					mode = Axis.VERTICAL
					if (direction == Direction.LEFT)
					{
						horizontal_mode = Direction.RIGHT
					}
					else if (direction == Direction.RIGHT)
					{
						horizontal_mode = Direction.LEFT
					}
				}
			}
		}
	}
	
	////////////////////////////////////////////////////////////////////////////////////
	// Utility
	////////////////////////////////////////////////////////////////////////////////////
	
	func canGoDirection(cursor:DiscreteTileCoord, direction:Direction, remaining:Set<DiscreteTileCoord>) -> Bool
	{
		let newCoord = nudgeInDirection(coord:cursor, direction:direction)
		return remaining.contains(newCoord)
	}
	
	// Given the current cursor and direction, get the next sequence of uninterrupted remaining tiles
	func getNextSequence(cursor:DiscreteTileCoord, direction:Direction, remaining:Set<DiscreteTileCoord>) -> [DiscreteTileCoord]
	{
		var tempCoord = cursor
		
		var sequence = [DiscreteTileCoord]()
		
		if (direction == Direction.UP || direction == Direction.DOWN)
		{
			if (remaining.contains(tempCoord))
			{
				sequence.append(tempCoord)
			}
			
			tempCoord = nudgeInDirection(coord:tempCoord, direction:direction)
			if (remaining.contains(tempCoord))
			{
				sequence.append(tempCoord)
			}
		}
		else
		{
			var terminus_reached = false
			
			while (!terminus_reached)
			{
				if (remaining.contains(tempCoord))
				{
					sequence.append(tempCoord)
					tempCoord = nudgeInDirection(coord:tempCoord, direction:direction)
				}
				else
				{
					terminus_reached = true
				}
			}
		}
		
		return sequence
	}
	
	func nudgeInDirection(coord:DiscreteTileCoord, direction:Direction) -> DiscreteTileCoord
	{
		var nudgedCoord = coord
		
		switch (direction)
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
	func findClosestRemainingTile(cursor:DiscreteTileCoord, remaining:Set<DiscreteTileCoord>) -> DiscreteTileCoord?
	{
		var closestTile:DiscreteTileCoord?
		
		if (remaining.contains(cursor)) {
			// If the current cursor is valid, use that
			closestTile = cursor
		}
		
		if (closestTile == nil)
		{
			// Check the immediate neighbors next
			let neighborhood = cursor.neighborhood()
			for coord in neighborhood
			{
				if (remaining.contains(coord))
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
			
			for coord in remaining
			{
				let distance = cursor.squareDistance(coord)
				if (closestDistanceSoFar > distance)
				{
					closestDistanceSoFar = distance
					closestTile = coord
				}
			}
		}
		
		return closestTile
	}
}
