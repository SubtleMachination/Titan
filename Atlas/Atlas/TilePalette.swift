//
//  SimpleButton.swift
//  Hexbreaker
//
//  Created by Dusty Artifact on 12/18/15.
//  Copyright © 2015 Runemark. All rights reserved.
//

import Foundation
import SpriteKit

protocol TilePaletteResponder
{
	func changeSelection(value:Int)
}

class TilePalette : SKNode, ButtonResponder
{
	var responder:TilePaletteResponder?
	var buttons:[String:SimpleButton]
	var selectors:[String:SKSpriteNode]
	
	init(width:CGFloat, height:CGFloat, tileset:Tileset)
	{
		buttons = [String:SimpleButton]()
		selectors = [String:SKSpriteNode]()
		
		let terrainUUIDs:[Int] = tileset.allTerrainUIDSPlusEmpty().sorted()
		let doodadUUIDs:[Int] = tileset.allDoodadUIDS().sorted()
		
		let buttonWidth = 32.0
		let buttonMargin = buttonWidth / 2.0
		
		let buttonSize = CGSize(width:buttonWidth, height:buttonWidth)
		
		let buttonsWide = Int(floor((Double(width) - buttonMargin) / (buttonWidth + buttonMargin)))
		let buttonsTall = Int(floor((Double(height) - buttonMargin) / (buttonWidth + buttonMargin)))
		
		func tileViewOrderPosition(sortedIndex:Int) -> DiscreteTileCoord
		{
			let column = sortedIndex % buttonsWide
			let row = Int(floor(Double(sortedIndex) / Double(buttonsWide)))
			return DiscreteTileCoord(x:column, y:row)
		}
		
		func tilePosition(viewOrderPos:DiscreteTileCoord) -> CGPoint
		{
			let row = viewOrderPos.y;
			let col = viewOrderPos.x;
			
			let shift = buttonMargin + 0.5*buttonWidth
			let resetWidth = Double(width) / 2.0
			let resetHeight = Double(height) / 2.0
			
			let xPos = shift + Double(col)*(buttonWidth + buttonMargin) - resetWidth
			let yPos = shift + Double(row)*(buttonWidth + buttonMargin) - resetHeight
			
			return CGPoint(x:xPos, y:yPos)
		}
		
		for (index, terrainUUID) in terrainUUIDs.enumerated()
		{
			let viewOrderPos = tileViewOrderPosition(sortedIndex:index)
			let value = String(terrainUUID)
			
			var textureName = "square"
			if let name = tileset.baseTextureNameForUID(terrainUUID)
			{
				textureName = name
			}
			
			let button = SimpleButton(iconSize:buttonSize, touchable:buttonSize*1.2, iconName:textureName, identifier:value)
			if (terrainUUID == 0)
			{
				button.changeColor(color:NSColor.black, blend:1.0)
			}
			
			button.position = tilePosition(viewOrderPos:viewOrderPos)
			buttons[value] = button
			
			let selector = SKSpriteNode(imageNamed:"square.png")
			selector.resizeNode(buttonSize.width*1.1, y:buttonSize.height*1.1)
			selector.position = button.position
			selectors[value] = selector
		}
		
		super.init()
		
		for (_, selector) in selectors
		{
			self.addChild(selector)
		}
		
		for (_, button) in buttons
		{
			button.registerResponder(responder:self)
			
			self.addChild(button)
		}
	}
	
	func registerResponder(responder:TilePaletteResponder)
	{
		self.responder = responder
	}
	
	func click(event:NSEvent)
	{
		for (_, button) in buttons
		{
			button.click(event:event)
		}
	}
	
	func clearSelections()
	{
		for (_, selector) in selectors
		{
			selector.color = NSColor.white
		}
	}
	
	func changeSelection(value:String)
	{
		clearSelections()
		highlightSelection(value:value)
	}
	
	func highlightSelection(value:String)
	{
		if (selectors.keys.contains(value))
		{
			self.selectors[value]!.color = NSColor.green
			self.selectors[value]!.colorBlendFactor = CGFloat(1.0)
		}
	}
	
	func buttonPressed(id: String)
	{
		print("button pressed")
		if let tileId = Int(id)
		{
			changeSelection(value:id)
			responder?.changeSelection(value:tileId)
		}
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
}
