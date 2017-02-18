//
//  GenModule1.swift
//  Atlas Core
//
//  Created by Dusty Artifact on 7/5/16.
//  Copyright © 2016 Suddenly Games. All rights reserved.
//

import Foundation

class Agent
{
	let delegate:ActorDelegate
	
	init(delegate:ActorDelegate)
	{
		self.delegate = delegate
	}
	
	func activate()
	{
		for x in 0..<10
		{
			for y in 0..<10
			{
				print("placeTile: ")
				let coord = DiscreteTileCoord(x:x, y:y)
				PlaceTile(delegate:delegate, coord:coord, tile:0).trigger()
			}
			
		}
		
	}
}
