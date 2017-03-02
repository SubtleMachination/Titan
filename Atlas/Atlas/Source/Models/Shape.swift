//
//  Shape.swift
//  Atlas Editor
//
//  Created by Dusty Artifact on 6/13/16.
//  Copyright © 2016 Dusty Artifact. All rights reserved.
//

import Foundation

class Shape
{
	var boundingBox:TileRect?
	var nodes:Set<DiscreteTileCoord>
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// INITIALIZATION
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	init()
	{
		self.nodes = Set<DiscreteTileCoord>()
	}
	
	convenience init(other:Shape)
	{
		self.init()
		for node in other.nodes
		{
			addNode(node)
		}
	}
	
	func clear()
	{
		boundingBox = nil
		nodes.removeAll()
	}
	
	func contains(_ coord:DiscreteTileCoord) -> Bool
	{
		let mass = shapeMass()
		return mass.contains(coord)
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// SKELETON SYNC
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	func recalculateAtomic() -> AtomicMap<Int>
	{
		let mass = shapeMass()
		
		let width = boundingBox!.width()
		let height = boundingBox!.height()
		let offset = DiscreteTileCoord(x:boundingBox!.left, y:boundingBox!.down)
		// Initialize a blank atomic map
		let atomicMap = AtomicMap<Int>(xMax:width, yMax:height, filler:0, offset:offset)
		
		// Fill it with the shape mass
		for tile in mass
		{
			atomicMap[tile.x, tile.y] = 1
		}
		
		return atomicMap
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// NODE MANIPULATION
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	func addNode(_ node:DiscreteTileCoord)
	{
		addNodeDirectly(node)
	}
	
	func addNodeDirectly(_ node:DiscreteTileCoord)
	{
		nodes.insert(node)
		updateBoundingBoxWithAddedNode(node)
	}
	
	func removeNode(_ node:DiscreteTileCoord)
	{
		removeNodeDirectly(node)
	}
	
	func removeNodeDirectly(_ node:DiscreteTileCoord)
	{
		nodes.remove(node)
		recalculateBoundingBox()
	}
	
	func removeMass(_ mass:Set<DiscreteTileCoord>)
	{
		let originalMass = shapeMass()
		let massToRemove = originalMass.intersection(mass)
		if (massToRemove.count > 0)
		{
			let newMass = originalMass.subtracting(mass)
			regenerateFromMass(newMass)
		}
	}
	
	func regenerateFromMass(_ mass:Set<DiscreteTileCoord>)
	{
		clear()
		for coord in mass
		{
			addNode(coord)
		}
	}
	
	func massBounds(_ mass:Set<DiscreteTileCoord>) -> TileRect?
	{
		var bounds:TileRect?
		for coord in mass
		{
			if bounds != nil
			{
				if (coord.x < bounds!.left)
				{
					bounds!.left = coord.x
				}
				else if (coord.x > bounds!.right)
				{
					bounds!.right = coord.x
				}
				
				if (coord.y > bounds!.up)
				{
					bounds!.up = coord.y
				}
				else if (coord.y < bounds!.down)
				{
					bounds!.down = coord.y
				}
			}
			else
			{
				bounds = TileRect(left:coord.x, right:coord.x, up:coord.y, down:coord.y)
			}
		}
		
		return bounds
	}
	
	func augmentWithRandomNodesOfRadius(_ nodeRadius:Int, nodeCount:Int)
	{
		let candidates = candidatesToAddMass(nodeRadius, tight:true)
		let selectedCandidates = candidates.randomSubset(nodeCount)
		
		for selected in selectedCandidates
		{
			addNode(selected)
		}
	}
	
	func createNode(_ center:DiscreteTileCoord, radius:Int) -> TileRect
	{
		return TileRect(left:center.x-radius, right:center.x+radius, up:center.y+radius, down:center.y-radius)
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// ADDITIONAL UTILITY
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	func exposedEdge() -> Set<DiscreteTileCoord>
	{
		var edge = Set<DiscreteTileCoord>()
		
		let leadingEdge = ripple(0, rEnd:0)
		for node in leadingEdge
		{
			let neighbors = node.directNeighborhood()
			var isExposed = false
			for neighbor in neighbors
			{
				if (!isExposed)
				{
					if (!nodes.contains(neighbor))
					{
						edge.insert(node)
						isExposed = true
					}
				}
			}
		}
		
		return edge
	}
	
	func directNeighbors() -> Set<DiscreteTileCoord>
	{
		var neighbors = Set<DiscreteTileCoord>()
		let mass = shapeMass()
		for coord in exposedEdge()
		{
			for neighbor in coord.directNeighborhood()
			{
				if (!mass.contains(neighbor))
				{
					neighbors.insert(neighbor)
				}
			}
		}
		
		return neighbors
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// EXTRUSION AND INTRUSION SETS
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	//////////////////////////////////////////////////////////////////////////////////////////
	// CANDIDATES TO ADD MASS
	func candidatesToAddMass(_ nodeRadius:Int, tight:Bool) -> Set<DiscreteTileCoord>
	{
		let candidates = Set<DiscreteTileCoord>()
		if (nodeRadius == 1)
		{
			return ripple(1, rEnd:1)
		}
		else if (nodeRadius > 1)
		{
			let min = 0 - (nodeRadius - 1)
			let max = (tight) ? (nodeRadius - 1) : nodeRadius
			
			return ripple(min, rEnd:max)
		}
		
		return candidates
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////
	// SHAPE MASS
	func shapeMass() -> Set<DiscreteTileCoord>
	{
		return nodes
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////
	// RIPPLE POOL (INCLUDES BOTH EXTRUSIONS AND INTRUSIONS)
	// @param rStart Int the starting radius of inset. Must be 1 or more.
	//  -1: 1-tile inset
	//   0: actual edge of shape
	//   1: 1-tile offset
	func ripple(_ rStart:Int, rEnd:Int) -> Set<DiscreteTileCoord>
	{
		var pool = Set<DiscreteTileCoord>()
		
		if (rStart <= rEnd)
		{
			// is there an extrusion component?
			if (rStart > 0 || rEnd > 0)
			{
				let extrusionStart = max(1, rStart)
				let extrusionEnd = max(rStart, rEnd)
				
				pool.formUnion(extrusionPool(extrusionStart, rEnd:extrusionEnd))
			}
			
			// is there an intrusion component?
			if (rStart < 1 || rEnd < 1)
			{
				let intrusionStart = min(0, rEnd)
				let intrusionEnd = -1*min(rStart, rEnd)
				
				pool.formUnion(intrusionPool(intrusionStart, rEnd:intrusionEnd))
			}
		}
		
		return pool
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////
	// EXTRUSION POOL
	// @param rStart Int the starting radius of inset. Must be 1 or more.
	//  1: 1-tile offset
	//  2: 2-tile offset...
	// @param rEnd Int the ending radius of the inset. Must be 1 or more.
	//  1: 1-tile offset
	//  2: 2-tile offset...
	func extrusionPool(_ rStart:Int, rEnd:Int) -> Set<DiscreteTileCoord>
	{
		var pool = Set<DiscreteTileCoord>()
		
		if (rStart <= rEnd && rStart > 0)
		{
			var mass = shapeMass()
			if (mass.count > 0)
			{
				for index in 1...rEnd
				{
					for coord in mass
					{
						let neighborhood = coord.neighborhood().filter({ (neighbor) -> Bool in
							return !mass.contains(neighbor)
						})
						pool.formUnion(neighborhood)
					}
					
					if (index < rEnd)
					{
						mass.formUnion(pool)
					}
					
					if (index < rStart)
					{
						pool.removeAll()
					}
				}
			}
		}
		
		return pool
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////
	// INTRUSION POOL
	// @param rStart Int the starting radius of inset. Must be 0 or more.
	//  0: actual edge of the shape
	//  1: 1-tile inset of the shape...
	// @param rEnd Int the ending radius of the inset. Must be 0 or more.
	//  1: 1-tile inset of the shape
	//  2: 2-tile inset of the shape...
	func intrusionPool(_ rStart:Int, rEnd:Int) -> Set<DiscreteTileCoord>
	{
		var pool = Set<DiscreteTileCoord>()
		var layerPool = Set<DiscreteTileCoord>()
		
		if (rStart <= rEnd && rStart >= 0)
		{
			var mass = shapeMass()
			if (mass.count > 0)
			{
				for index in 0...rEnd
				{
					// All tiles within the mass which have an open edge
					layerPool = Set(mass.filter({
						$0.neighborhood().filter({
							!mass.contains($0)
						}).count > 0
					}))
					
					if (index < rEnd)
					{
						mass.subtract(layerPool)
					}
					
					if (index >= rStart)
					{
						pool.formUnion(layerPool)
					}
				}
			}
		}
		
		return pool
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// BOUNDING BOX
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	//////////////////////////////////////////////////////////////////////////////////////////
	// Recalculate Bounding Box
	//  recalculates the true bounding box from scratch
	func recalculateBoundingBox()
	{
		boundingBox = nil
		for node in nodes
		{
			updateBoundingBoxWithAddedNode(node)
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////
	// Update Bounding Box with Added Node
	//  incrementally recalculates the bounding box using the newest added node
	func updateBoundingBoxWithAddedNode(_ node:DiscreteTileCoord)
	{
		if let _ = boundingBox
		{
			if (node.x < boundingBox!.left)
			{
				boundingBox!.left = node.x
			}
			if (node.x > boundingBox!.right)
			{
				boundingBox!.right = node.x
			}
			if (node.y > boundingBox!.up)
			{
				boundingBox!.up = node.y
			}
			if (node.y < boundingBox!.down)
			{
				boundingBox!.down = node.y
			}
		}
		else
		{
			boundingBox = node.toTileRect()
		}
	}
}
