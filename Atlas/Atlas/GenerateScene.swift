//
//  GenerateScene.swift
//  Atlas
//
//  Created by Dusty Artifact on 2/18/17.
//  Copyright © 2017 Overmind. All rights reserved.
//

import SpriteKit
import GameplayKit

class GenerateScene: SKScene, ActorDelegate
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
	var writeThroughMap:AtomicMap<Int>
	var archive:Archive
	
	var cursor:DiscreteTileCoord
	var cursorState:CursorState
	var cursorBrush:Int
	
	//////////////////////////////////////////////////////////////////////////////////////////
	// Agent
	//////////////////////////////////////////////////////////////////////////////////////////
	var agent:Agent?
	var canvas:Shape
	
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
		
//		let mapName = "TARGET_1"
//		let mapName = "Rust_1a"
		let mapName = "SampleSource01"
		var mapBounds = TileRect(left:0, right:32, up:32, down:0)
		map = TileMap(bounds:mapBounds, title:mapName)
		map.swapTilesetData(rustTilesetData)
		map.setAllTerrainTiles(0, directly:true)
		
		canvas = Shape()
		
		if let importedMap = TileMapIO().importSimpleModel(mapName)
		{
			map = importedMap
			mapBounds = map.getBounds()
			
			for (coord, value) in map.allTerrainData()
			{
				if (value == 99)
				{
					canvas.addNode(coord)
				}
			}
		}
		else
		{
			map.setAllTerrainTiles(0, directly:true)
			
			var center = DiscreteTileCoord(x:16, y:16)
			canvas.addNode(center)
			
			for _ in 0...9
			{
				if let nextCenter = canvas.ripple(0, rEnd:1).randomElement()
				{
					center = nextCenter
					let random_radius = randIntBetween(2, stop:4)
					for x in center.x-random_radius...center.x+random_radius
					{
						for y in center.y-random_radius...center.y+random_radius
						{
							let coord = DiscreteTileCoord(x:x, y:y)
							if (mapBounds.innerRect()!.contains(coord))
							{
								canvas.addNode(coord)
								map.directlySetTerrainTileAt(coord, uid:99)
							}
						}
					}
				}
			}
			
			TileMapIO().exportModelToDisk(map)
		}
		
		let extractor = Extractor(raw:map, info:rustTilesetData)
		extractor.extractMotifs()
		
		let viewSize = window
		let tileSize = CGSize(width: 16, height: 16)
		mapView = TileMapView(window:window, viewSize:viewSize, tileSize:tileSize)
		mapView.position = center
		
		mapView.swapTileset(tileset)
		map.registerDirectObserver(mapView)
		
		writeThroughMap = AtomicMap(xMax:mapBounds.width(), yMax:mapBounds.height(), filler:0, offset:DiscreteTileCoord(x:0, y:0))
		
		mapView.reloadMap()
		
		archive = Archive()
		archive.name = "TESTING"
		
		cursor = DiscreteTileCoord(x:0, y:0)
		cursorBrush = 0
		cursorState = CursorState.UP
		
		//////////////////////////////
		// INITIALIZE
		//////////////////////////////
		super.init(size:size)
		//////////////////////////////
		
		self.addChild(mapView)
	}

    override func didMove(to view: SKView)
	{
		agent = Agent(delegate:self, canvas:self.canvas)
//		agent!.activate()
    }
    
    override func update(_ currentTime: TimeInterval)
	{
		// changes per cycle
		for _ in 0...0
		{
			_ = map.applyNextChange()
		}
    }
	
	////////////////////////////////////////////////////////////////////////////////////////
	// ACTOR DELEGATE
	////////////////////////////////////////////////////////////////////////////////////////
	func placeTile(_ coord:DiscreteTileCoord, tile:Int)
	{
		// Instantly alter the literal map
		writeThroughMap[coord] = tile
		
		let change = Change(coord:coord, layer:TileLayer.terrain, value:tile, collaboratorUUID:"Internal")
		
		// Archive the change
		archive.registerChange(change)
		// Queue up the change to the view's map
		map.registerChange(change)
	}
	
	func boardRange() -> TileRect
	{
		return map.getBounds()
	}
	
	func tileValue(_ coord:DiscreteTileCoord) -> Int
	{
		return writeThroughMap[coord]
	}

	
	////////////////////////////////////////////////////////////////////////////////////////
	// Required Boilerplate Crap
	////////////////////////////////////////////////////////////////////////////////////////
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
	
}
