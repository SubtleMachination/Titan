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
		for x in 0..<32
		{
			for y in 0..<32
			{
				let coord = DiscreteTileCoord(x:x, y:y)
				PlaceTile(delegate:delegate, coord:coord, tile:1).trigger()
			}
			
		}
	}
}
