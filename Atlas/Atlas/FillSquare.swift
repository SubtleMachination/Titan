////
////  FillSquare.swift
////  Atlas
////
////  Created by Dusty Artifact on 3/10/17.
////  Copyright © 2017 Overmind. All rights reserved.
////
//
//import Foundation
//
//class FillRect
//{
//	// Delegate
//	let delegate:ActorDelegate
//	
//	// General Action Resources
//	var completion:Double
//	var nextAction:
//	
//	let area:TileRect
//	
//	let fill:Int
//	
//	var remainingCoords:Set<DiscreteTileCoord>
//	var estimate:Int
//	
//	init(delegate:ActorDelegate, fill:Int, area:TileRect)
//	{
//		// Delegate
//		self.delegate = delegate
//		
//		// General Action Resources
//		self.completion = 0.0
//		self.nextAction = "action:default"
//		
//		// Parameters
//		self.fill = fill
//		self.area = area
//		
//		// Task-Specific Logic
//		self.remainingCoords = Set<DiscreteTileCoord>()
//		self.estimate = 0
//	}
//	
//	////////////////////////////////////////////////////////////////////////
//	// IDEA Logic
//	////////////////////////////////////////////////////////////////////////
//	
//	func act()
//	{
//		
//	}
//	
//	func decide() -> String
//	{
//		
//	}
//	
//	func evaluate() -> Double
//	{
//		// Scan the area and determine remaining work
//		return (estimate == 0) ? 1.0 : Double(remainingCoords.count) / Double(estimate)
//	}
//	
//	func initialize()
//	{
//		for coord in area.orderedCoordinateList()
//		{
//			if (delegate.tileValue(coord) != fill)
//			{
//				remainingCoords.insert(coord)
//			}
//		}
//		
//		self.estimate = remainingCoords.count
//	}
//	
//	func trigger()
//	{
//		
//		initialize()
//		
//		while (completion < 1.0)
//		{
//			self.completion = evaluate()
//			self.nextAction = decide()
//		}
//		
//		
////		availableCoords.randomElement()
////		
////		let randomX = randIntBetween(left, stop:right)
////		let randomY = randIntBetween(bottom, stop:top)
////		let randomCoord = DiscreteTileCoord(
////		
////		// Apply an arbitrary style to an arbitrary shape
////		for coord in shape.shapeMass() {
////			PlaceTile(delegate:delegate, coord:coord, tile:1).trigger()
////		}
//	}
//	
//	////////////////////////////////////////////////////////////////////////
//	// Utility
//	////////////////////////////////////////////////////////////////////////
//	
//}
