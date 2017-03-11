//
//  Change.swift
//  Atlas
//
//  Created by Dusty Artifact on 2/26/17.
//  Copyright © 2017 Overmind. All rights reserved.
//

import Foundation

struct Change
{
	var coord:DiscreteTileCoord
	var layer:TileLayer
	var value:Int
	var collaboratorUUID:String?
}
