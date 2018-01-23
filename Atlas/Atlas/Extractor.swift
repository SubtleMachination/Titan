//
//  FillSquare2.swift
//  Atlas
//
//  Created by Dusty Artifact on 3/10/17.
//  Copyright © 2017 Overmind. All rights reserved.
//

import Foundation

class Extractor
{
	let raw:TileMap
	let atomic:AtomicMap<Int>
	let info:TilesetData
	var allValues:Set<Int>
	var allPathables:Set<Int>
	var allObstacles:Set<Int>
	
	init(raw:TileMap, info:TilesetData)
	{
		self.raw = raw
		self.info = info
		
		self.allValues = Set<Int>()
		self.allPathables = Set<Int>()
		self.allObstacles = Set<Int>()
		
		let bounds = raw.getBounds()
		let offset = DiscreteTileCoord(x:bounds.left, y:bounds.down)

		self.atomic = AtomicMap<Int>(xMax:bounds.width(), yMax:bounds.height(), filler:0, offset:DiscreteTileCoord(x:0, y:0))
		for (coord, value) in raw.allTerrainData()
		{
			let atomicCoord = coord - offset
			if (value > 0)
			{
				self.atomic[atomicCoord] = value
				self.allValues.insert(value)
				if let isObstacle = info.isObstacle(value)
				{
					if (isObstacle)
					{
						self.allObstacles.insert(value)
					}
					else
					{
						self.allPathables.insert(value)
					}
				}
			}
		}
	}
	
	func extractMotifs()
	{
		let bounds = TileRect(left:0, right:self.atomic.xMax-1, up:self.atomic.yMax-1, down:0)
		let densityMap = FRDensityModule(base:atomic, densityBounds:bounds, validSet:allValues).activate()
		let skeleton = FRSkeletonModule(density:densityMap, bounds:bounds).activate()
		let regions = FRDensitySubdivisionModule(skeleton:skeleton, bounds:bounds).activate()
		var analysisRegions = [FRAnalysisRegion]()
		for region in regions
		{
			let shape = Shape()
			var mapping = [DiscreteTileCoord:Int]()
			for coord in region.coords
			{
				shape.addNode(coord)
				let value = raw.terrainTileUIDAt(coord)
				mapping[coord] = value
			}
			let analysisRegion = FRAnalysisRegion(shape:shape, values:mapping, tileData:self.info)
			analysisRegions.append(analysisRegion)
		}
		
		for analysisRegion in analysisRegions
		{
			analysisRegion.extractMotifs()
		}
	}
}
