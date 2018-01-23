//
//  PlaceTileMod.swift
//  Atlas Core
//
//  Created by Dusty Artifact on 7/5/16.
//  Copyright © 2016 Suddenly Games. All rights reserved.
//

import Foundation

class Motif
{
	var value:Int
	
	init(value:Int)
	{
		self.value = value
	}
}

class Design002
{
	let delegate:ActorDelegate
	let canvas:Shape
	let style:Motif
	
	init(delegate:ActorDelegate, canvas:Shape, style:Motif)
	{
		self.delegate = delegate
		self.canvas = canvas
		self.style = style
	}
	
	func trigger()
	{
		ATFillArea2(delegate:delegate, area:canvas.shapeMass(), value:style.value).execute()
	}
}
