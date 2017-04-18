//
//  PlaceTileMod.swift
//  Atlas Core
//
//  Created by Dusty Artifact on 7/5/16.
//  Copyright © 2016 Suddenly Games. All rights reserved.
//

import Foundation

class Design001
{
	let delegate:ActorDelegate
	
	init(delegate:ActorDelegate)
	{
		self.delegate = delegate
	}
	
	func trigger()
	{
//		let coord = DiscreteTileCoord(x:10, y:10)
//		ATPlaceTile(delegate:delegate, coord:coord, value:1).execute()
		
//		var region = Set<DiscreteTileCoord>()
		let region = Shape()
		
		var center = DiscreteTileCoord(x:16, y:16)
		region.addNode(center)
		
		for _ in 0...9
		{
			if let nextCenter = region.ripple(0, rEnd:1).randomElement()
			{
				center = nextCenter
				let random_radius = randIntBetween(2, stop:4)
				for x in center.x-random_radius...center.x+random_radius
				{
					for y in center.y-random_radius...center.y+random_radius
					{
						let coord = DiscreteTileCoord(x:x, y:y)
						if (delegate.boardRange().innerRect()!.contains(coord))
						{
							region.addNode(coord)
						}
					}
				}
			}
		}
		
		ATFillArea2(delegate:delegate, area:region.shapeMass(), value:1).execute()
		
		let border = region.ripple(1, rEnd:1)
		
		var values = [String:Int]()
		for coord in border
		{
			let up = border.contains(coord.up())
			let down = border.contains(coord.down())
			let left = border.contains(coord.left())
			let right = border.contains(coord.right())
			
			let directions = [up, down, left, right]
			var total_border_directions = 0
			for direction in directions
			{
				if (direction)
				{
					total_border_directions += 1
				}
			}
			
			var value = 5
			if (total_border_directions == 2)
			{
				if (up && down)
				{
					value = 3
				}
				else if (left && right)
				{
					value = 4
				}
			}
			
			values[coord.debug()] = value
		}

		ATFillArea3(delegate:delegate, area:border, values:values).execute()
		
		let innerRegion = region.ripple(-1, rEnd:0)
		
		values.removeAll()
		for coord in innerRegion
		{
			var value = 1
			if ((coord.x + coord.y) % 2 == 0)
			{
				value = 2
			}
			
			values[coord.debug()] = value
		}
		
		ATFillArea3(delegate:delegate, area:innerRegion, values:values).execute()
	}
}
