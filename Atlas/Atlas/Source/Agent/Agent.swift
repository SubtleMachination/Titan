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
	let canvas:Shape
	
	init(delegate:ActorDelegate, canvas:Shape)
	{
		self.delegate = delegate
		self.canvas = canvas
	}
	
	func activate()
	{
//		let map = TileMapIO().importSimpleModel("Rust_1a")!
		let style = Motif(value:1)
		
		Design002(delegate:delegate, canvas:canvas, style:style).trigger()
	}
}
