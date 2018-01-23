//
//  FRAnalysisRegion.swift
//  Atlas
//
//  Created by Dusty Artifact on 5/2/17.
//  Copyright © 2017 Overmind. All rights reserved.
//

import Foundation

public enum Pathability
{
	case PATHABLE, OBSTACLE
}

class FRAnalysisRegion
{
	let shape:Shape
	let values:[DiscreteTileCoord:Int]
	var pathables:Set<DiscreteTileCoord>
	var obstacles:Set<DiscreteTileCoord>
	
	let tileData:TilesetData
	
	init(shape:Shape, values:[DiscreteTileCoord:Int], tileData:TilesetData)
	{
		self.shape = shape
		self.values = values
		self.tileData = tileData
		self.obstacles = Set<DiscreteTileCoord>()
		self.pathables = Set<DiscreteTileCoord>()
	}
	
	func extractMotifs()
	{
		print("Extracting")
		
		// Extract the positioning of obstacles in relation to the overall shape
		extractPathabilityMotifs()
		// Extract the texture motifs of the obstacles themselves
	}
	
//	func tileDensity(region: Set<DiscreteTileCoord>, tiles:[Int]) -> Double
//	{
//		let totalTiles = region.count
//		for coord in region
//		{
//			
//		}
//	}
	
	func extractPathabilityMotifs()
	{
		extractPathInfo()
		
//		let obstacleCount = obstacles.count
//		let pathableCount = pathables.count
		
//		let dominantBase = (pathableCount >= obstacleCount) ? Pathability.PATHABLE : Pathability.OBSTACLE
		
		let pools = self.shape.ripplePools()
		for pool in pools
		{
			print(pool.count)
		}
	}
	
	func extractPathInfo()
	{
		for (coord, value) in values
		{
			if (tileData.isObstacle(value)!)
			{
				self.obstacles.insert(coord)
			}
			else
			{
				self.pathables.insert(coord)
			}
		}
	}
}
