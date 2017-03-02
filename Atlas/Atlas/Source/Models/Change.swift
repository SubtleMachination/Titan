//
//  Change.swift
//  Atlas
//
//  Created by Dusty Artifact on 2/26/17.
//  Copyright © 2017 Overmind. All rights reserved.
//

import Foundation

enum ChangeType
{
	case CURSOR_CHANGE
	case MAP_CHANGE
}

class Change
{
	var changeType:ChangeType
	var collaboratorUUID:String?
	
	init(changeType:ChangeType, collaboratorUUID:String) {
		self.changeType = changeType
		self.collaboratorUUID = collaboratorUUID
	}
	
	
}

class MapChange: Change
{
	var coord:DiscreteTileCoord
	var layer:TileLayer
	var value:Int
	
	init(changeType:ChangeType, collaboratorUUID:String, coord:DiscreteTileCoord, layer:TileLayer, value:Int)
	{
		self.coord = coord
		self.layer = layer
		self.value = value
		
		super.init(changeType:changeType, collaboratorUUID:collaboratorUUID)
	}
}

class CursorChange: Change
{
	var cursorPosition:DiscreteTileCoord
	var cursorState:CursorState
	var cursorBrush:Int
	
	init(changeType:ChangeType, collaboratorUUID:String, cursorPosition:DiscreteTileCoord, cursorState:CursorState, cursorBrush:Int)
	{
		self.cursorPosition = cursorPosition
		self.cursorState = cursorState
		self.cursorBrush = cursorBrush
		
		super.init(changeType:changeType, collaboratorUUID:collaboratorUUID)
	}
}

