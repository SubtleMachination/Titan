//
//  FRSkeletonModule.swift
//  Atlas Editor
//
//  Created by Dusty Artifact on 2/26/16.
//  Copyright © 2016 Dusty Artifact. All rights reserved.
//

import Foundation

class FRSkeletonModule
{
	var density:DensityMap
	var skeletonBounds:TileRect
	var skeleton:SkeletonMap
	
	init(density:DensityMap, bounds:TileRect)
	{
		self.density = density
		self.skeletonBounds = bounds
		self.skeleton = SkeletonMap(bounds:bounds)
	}
	
	func activate() -> SkeletonMap
	{
		for x in skeletonBounds.left...skeletonBounds.right
		{
			for y in skeletonBounds.down...skeletonBounds.up
			{
				let coord = DiscreteTileCoord(x:x, y:y)
				if ((density.density(coord:coord)) > 0)
				{
					recalculateSkeletonAt(coord:coord)
				}
			}
		}
		
		return skeleton
	}
	
	func recalculateSkeletonAt(coord:DiscreteTileCoord)
	{
		let node = SkeletonNode(center:coord, strength:density.density(coord:coord))
		skeleton.addNode(node:node)
	}
}
