//
//  FillSquare2.swift
//  Atlas
//
//  Created by Dusty Artifact on 3/10/17.
//  Copyright © 2017 Overmind. All rights reserved.
//

import Foundation

class ATPlaceTiles: Task
{
	var sequence:[TileAssignment]
	var progressIndex:Int
	
	init(delegate:ActorDelegate, sequence:[TileAssignment])
	{
		self.sequence = sequence
		self.progressIndex = 0
		
		super.init(delegate:delegate)
	}
	
	override func evaluate() -> Double
	{
		return Double(self.progressIndex) / Double(self.sequence.count)
	}
	
	override func decide() -> Task?
	{
		let nextAssignment = self.sequence[self.progressIndex]
		let nextTask = ATPlaceTile(delegate:delegate, coord:nextAssignment.coord, value:nextAssignment.value)
		
		self.progressIndex += 1
		
		return nextTask
	}
}
