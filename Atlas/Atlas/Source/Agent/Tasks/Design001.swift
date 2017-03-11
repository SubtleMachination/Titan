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
		
		let area = TileRect(left:1, right:20, up:20, down:1)
		ATFillSquare(delegate:delegate, area:area, value:1).execute()
		
//		var sequence = [TileAssignment]()
//		for x in 1...25
//		{
//			let coord = DiscreteTileCoord(x:x, y:5)
//			let assignment = TileAssignment(coord:coord, value:1)
//			sequence.append(assignment)
//		}
//		
//		ATPlaceTiles(delegate:delegate, sequence:sequence).execute()
	}
}