//
//  EditorScene.swift
//  Atlas
//
//  Created by Dusty Artifact on 2/18/17.
//  Copyright © 2017 Overmind. All rights reserved.
//

import SpriteKit
import GameplayKit

class EditorScene: SKScene, NavigationResponder, MapExpanderResponder, TilePaletteResponder
{
	////////////////////////////////////////////////////////////////////////////////////////
	// View
	////////////////////////////////////////////////////////////////////////////////////////
	var window:CGSize
	var center:CGPoint
	
	var mapView:TileMapView
	var tileset:Tileset
	
	//////////////////////////////////////////////////////////////////////////////////////////
	// Model
	//////////////////////////////////////////////////////////////////////////////////////////
	var map:TileMap
	var needsExport:Bool = false
	var cursorBrush:Int
	
	//////////////////////////////////////////////////////////////////////////////////////////
	// Control Panel
	//////////////////////////////////////////////////////////////////////////////////////////
	
	var navigation:NavigationPane
	var expander:MapExpanderPane
	var tileSelection:TilePalette
	
	override init(size:CGSize)
	{
		window = size
		center = CGPoint(x:window.width/2.0, y:window.height/2.0)
		
		//////////////////////////////////////////////////////////////////////////////////////////
		// Model Declaration
		//////////////////////////////////////////////////////////////////////////////////////////
		tileset = TilesetIO().importTileset("Rust")
		tileset.importAtlas("Rust")
		
		let rustTilesetData = TilesetIO().importTilesetData("Rust")
		
		var mapBounds = TileRect(left:0, right:4, up:4, down:0)
//		let mapName = "Rust_1a"
		let mapName = "display_map_1combo"
		map = TileMap(bounds:mapBounds, title:mapName)
		if let importedMap = TileMapIO().importSimpleModel(mapName)
		{
			map = importedMap
			mapBounds = map.getBounds()
		}
		else
		{
			map.setAllTerrainTiles(0, directly:true)
			for x in mapBounds.left...mapBounds.right
			{
				for y in mapBounds.down...mapBounds.up
				{
					if (coinFlip())
					{
						let coord = DiscreteTileCoord(x:x, y:y)
						map.directlySetTerrainTileAt(coord, uid:1)
					}
				}
			}
		}
		
		map.swapTilesetData(rustTilesetData)
		
		
		let viewBorderWidth = CGFloat(200.0)
		let viewSize = CGSize(width:window.width - viewBorderWidth, height:window.height - viewBorderWidth)
		let tileSize = CGSize(width: 32, height: 32)
		mapView = TileMapView(window:window, viewSize:viewSize, tileSize:tileSize)
		mapView.position = center - CGPoint(x:0, y:viewBorderWidth/4)
		
		mapView.swapTileset(tileset)
		map.registerDirectObserver(mapView)
		
		mapView.reloadMap()
		
		cursorBrush = 0
		
		//////////////////////////////////////////////////////////////////////////////////////////
		// Control Panel
		//////////////////////////////////////////////////////////////////////////////////////////
		
		navigation = NavigationPane()
		navigation.position = CGPoint(x:viewBorderWidth/4.0, y:viewBorderWidth/4.0)
		
		expander = MapExpanderPane()
		expander.position = navigation.position + CGPoint(x:0.0, y:viewBorderWidth)
		
		tileSelection = TilePalette(width:viewSize.width, height:viewBorderWidth/2.0, tileset:tileset)
		tileSelection.position = CGPoint(x:center.x, y:window.height - viewBorderWidth/2.0)
		
		//////////////////////////////
		// INITIALIZE
		//////////////////////////////
		super.init(size:size)
		//////////////////////////////
		
		self.addChild(mapView)
		self.addChild(navigation)
		self.addChild(expander)
		self.addChild(tileSelection)
		
		// Register Control Elements
		navigation.registerResponder(responder:self)
		expander.registerResponder(responder:self)
		tileSelection.registerResponder(responder:self)
	}
	
	override func mouseDown(with event:NSEvent) {
		navigation.click(event:event)
		expander.click(event:event)
		tileSelection.click(event:event)
		attemptTilePlacement(event:event)
	}
	
	override func didMove(to view: SKView)
	{
		
	}
	
	override func update(_ currentTime: TimeInterval)
	{
		// changes per cycle
		for _ in 0...0
		{
			_ = map.applyNextChange()
		}
		
		if (needsExport)
		{
			TileMapIO().exportModelToDisk(map)
			needsExport = false
		}
	}
	
	func attemptTilePlacement(event:NSEvent)
	{
		let locationInMapView = event.location(in:mapView)
		if (mapView.pointIsWithinView(loc:locationInMapView))
		{
			if let coord = mapView.tileAtLocation(locationInMapView)
			{
				placeTile(coord, tile:cursorBrush)
				needsExport = true
			}
		}
	}
	
	////////////////////////////////////////////////////////////////////////////////////////
	// CONTROL METHDOS
	////////////////////////////////////////////////////////////////////////////////////////
	func placeTile(_ coord:DiscreteTileCoord, tile:Int)
	{
		print(coord.debug())
		let change = Change(coord:coord, layer:TileLayer.terrain, value:tile, collaboratorUUID:"Internal")
		
		// Queue up the change to the view's map
		map.registerChange(change)
	}
	
	func boardRange() -> TileRect
	{
		return map.getBounds()
	}
	
	////////////////////////////////////////////////////////////////////////////////////////
	// Expander Responder
	////////////////////////////////////////////////////////////////////////////////////////

	func expandUp()
	{
		print("expand up")
		map.expandUp()
		mapView.completelyRedrawView()
	}
	
	func expandDown()
	{
		print("expand down")
		map.expandDown()
		mapView.completelyRedrawView()
	}
	
	func expandLeft()
	{
		print("expand left")
		map.expandLeft()
		mapView.completelyRedrawView()
	}
	
	func expandRight()
	{
		print("expand right")
		map.expandRight()
		mapView.completelyRedrawView()
	}
	
	////////////////////////////////////////////////////////////////////////////////////////
	// Navigation Responder
	////////////////////////////////////////////////////////////////////////////////////////

	func up()
	{
		moveMapDown()
	}
	
	func down()
	{
		moveMapUp()
	}
	
	func left()
	{
		moveMapRight()
	}
	
	func right()
	{
		moveMapLeft()
	}
	
	func changeSelection(value:Int)
	{
		cursorBrush = value
	}
	
	////////////////////////////////////////////////////////////////////////////////////////
	// Navigation
	////////////////////////////////////////////////////////////////////////////////////////
	
	func moveMapUp()
	{
		moveMap(x:0, y:1)
	}
	
	func moveMapDown()
	{
		moveMap(x:0, y:-1)
	}
	
	func moveMapLeft()
	{
		moveMap(x:-1, y:0)
	}
	
	func moveMapRight()
	{
		moveMap(x:1, y:0)
	}
	
	func moveMap(x:Int, y:Int)
	{
		mapView.translateViewByTileDelta(DiscreteTileCoord(x:x, y:y))
	}
	
	////////////////////////////////////////////////////////////////////////////////////////
	// Required Boilerplate Crap
	////////////////////////////////////////////////////////////////////////////////////////
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
	
}
