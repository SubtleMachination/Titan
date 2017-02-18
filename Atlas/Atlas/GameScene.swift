//
//  GameScene.swift
//  Atlas
//
//  Created by Dusty Artifact on 2/18/17.
//  Copyright © 2017 Overmind. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, ActorDelegate
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
	
	//////////////////////////////////////////////////////////////////////////////////////////
	// Agent
	//////////////////////////////////////////////////////////////////////////////////////////
	var agent:Agent?
	
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
		
		map = TileMap(bounds:TileRect(left:0, right:32, up:32, down:0), title:"TESTING")
		map.swapTilesetData(rustTilesetData)
		map.setAllTerrainTiles(0, directly:true)
		
		let viewSize = window
		let tileSize = CGSize(width: 16, height: 16)
		mapView = TileMapView(window:window, viewSize:viewSize, tileSize:tileSize)
		mapView.position = center
		
		mapView.swapTileset(tileset)
		map.registerDirectObserver(mapView)
		
		writeThroughMap = AtomicMap(xMax:33, yMax:33, filler:0, offset:DiscreteTileCoord(x:0, y:0))
		
		mapView.reloadMap()
		
		archive = Archive()
		archive.name = "TESTING"
		
		//////////////////////////////
		// INITIALIZE
		//////////////////////////////
		super.init(size:size)
		//////////////////////////////
		
		self.addChild(mapView)
	}

    override func didMove(to view: SKView)
	{
		agent = Agent(delegate:self)
		agent!.activate()
    }
    
    override func update(_ currentTime: TimeInterval)
	{
		// changes per cycle
		for _ in 0...1
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
