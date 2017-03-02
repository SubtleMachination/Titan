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
		// STAGE 1: Create a Shape
		let shape = Shape()
		
		for x in 0..<25
		{
			for y in 0..<25 {
				let coord = DiscreteTileCoord(x:x, y:y)
				shape.addNode(coord)
			}
		}
		
		// STAGE 2: Apply Pattern to the Shape
		ApplyStyleToShape(delegate:delegate, shape:shape).trigger()	}
}
