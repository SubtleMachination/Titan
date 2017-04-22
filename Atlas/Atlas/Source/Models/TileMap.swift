//
//  Map.swift
//  Atlas 2.1
//
//  Created by Dusty Artifact on 12/12/15.
//  Copyright © 2015 Runemark. All rights reserved.
//

import Foundation

protocol DirectMapObserver
{
    func terrainChangedAt(_ coord:DiscreteTileCoord, old:Int, new:Int, collaboratorID:String?)
    func doodadChangedAt(_ coord:DiscreteTileCoord, old:Int, new:Int, collaboratorID:String?)
    func registerModelDelegate(_ delegate:DirectModelDelegate)
}

protocol DirectModelDelegate
{
    func getBounds() -> TileRect
    func terrainTileUIDAt(_ coord:DiscreteTileCoord) -> Int
    func doodadTileUIDAt(_ coord:DiscreteTileCoord) -> Int
    func setTerrainTileAt(_ coord:DiscreteTileCoord, uid:Int, collaboratorID:String?)
    func setDoodadTileAt(_ coord:DiscreteTileCoord, uid:Int, collaboratorID:String?)
    func terrainTileExistsAt(_ coord:DiscreteTileCoord) -> Bool
    func doodadTileExistsAt(_ coord:DiscreteTileCoord) -> Bool
    
    func registerChange(_ change:Change)
    
    func allTerrainObstacles() -> Set<Int>
    func allTerrainPathables() -> Set<Int>
}

class TileMap : DirectModelDelegate
{
    fileprivate var terrainTiles:[DiscreteTileCoord:Int]
    fileprivate var doodadTiles:[DiscreteTileCoord:Int]
    fileprivate var bounds:TileRect
    fileprivate var tilesetData:TilesetData?
    
    fileprivate var directObservers:[DirectMapObserver]
    
    fileprivate var changes:ChangeQueue
    fileprivate var title:String
    
    init(bounds:TileRect, title:String)
    {
        self.bounds = bounds
        self.title = title
        terrainTiles = [DiscreteTileCoord:Int]()
        doodadTiles = [DiscreteTileCoord:Int]()
        
        directObservers = [DirectMapObserver]()
        
        changes = ChangeQueue(capacity:-1)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////
    // Observers
    //////////////////////////////////////////////////////////////////////////////////////////
    
    func registerDirectObserver(_ observer:DirectMapObserver)
    {
        observer.registerModelDelegate(self)
        directObservers.append(observer)
    }
    
    func notifyDirectObserversOfTerrainChange(_ coord:DiscreteTileCoord, old:Int, new:Int, collaboratorID:String?)
    {
        for observer in directObservers
        {
            observer.terrainChangedAt(coord, old:old, new:new, collaboratorID:collaboratorID)
        }
    }
    
    func notifyDirectObserversOfDoodadChange(_ coord:DiscreteTileCoord, old:Int, new:Int, collaboratorID:String?)
    {
        for observer in directObservers
        {
            observer.doodadChangedAt(coord, old:old, new:new, collaboratorID:collaboratorID)
        }
    }
    
    func notifyRemoteObserversOfTerrainChange(_ coord:DiscreteTileCoord, new:Int)
    {
        
    }
    
    func removeAllObservers()
    {
        directObservers.removeAll()
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////
    // Model Access Methods
    //////////////////////////////////////////////////////////////////////////////////////////
    
    func mapTitle() -> String
    {
        return title
    }
    
    func registerChange(_ change:Change)
    {
        changes.pushChange(change)
    }
    
    func applyNextChange() -> Change?
    {
        if let nextChange = changes.popChange()
        {
            let coord = nextChange.coord
            let value = nextChange.value
            let collaboratorID = nextChange.collaboratorUUID
            
            if (nextChange.layer == TileLayer.terrain)
            {
                setTerrainTileAt(coord, uid:value, collaboratorID:collaboratorID)
            }
            else if (nextChange.layer == TileLayer.doodad)
            {
                setDoodadTileAt(coord, uid:value, collaboratorID:collaboratorID)
            }
            
            return nextChange
        }
        else
        {
            return nil
        }
    }
    
    
    //////////////////////////////////////////////////////////////////////////////////////////
    // Model Access Methods
    //////////////////////////////////////////////////////////////////////////////////////////
    
    func withinBounds(_ coord:DiscreteTileCoord) -> Bool
    {
        return bounds.contains(coord)
    }
    
    func terrainTileExistsAt(_ coord:DiscreteTileCoord) -> Bool
    {
        if let _ = terrainTiles[coord]
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func doodadTileExistsAt(_ coord:DiscreteTileCoord) -> Bool
    {
        if let _ = doodadTiles[coord]
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func terrainTileUIDAt(_ coord:DiscreteTileCoord) -> Int
    {
        if let uid = terrainTiles[coord]
        {
            return uid
        }
        else
        {
            return 0
        }
    }
    
    func doodadTileUIDAt(_ coord:DiscreteTileCoord) -> Int
    {
        if let uid = doodadTiles[coord]
        {
            return uid
        }
        else
        {
            return 0
        }
    }
    
    func getBounds() -> TileRect
    {
        return bounds
    }
	
	func expandUp()
	{
		// Change the bounds
		bounds = bounds.expandAbove()
	}
	
	func expandRight()
	{
		// Change the bounds
		bounds = bounds.expandRight()
	}
	
	func expandLeft()
	{
		// Change the bounds
		bounds = bounds.expandRight()
		// Shift the position of every tile
		var terrainClone = [DiscreteTileCoord: Int]()
		for (coord, value) in terrainTiles
		{
			terrainClone[coord] = value
		}
		
		clearAllTiles()
		
		for (coord, value) in terrainClone
		{
			terrainTiles[coord.right()] = value
		}
	}
	
	func expandDown()
	{
		// Change the bounds
		bounds = bounds.expandAbove()
		// Shift the position of every tile
		var terrainClone = [DiscreteTileCoord: Int]()
		for (coord, value) in terrainTiles
		{
			terrainClone[coord] = value
		}
		
		clearAllTiles()
		
		for (coord, value) in terrainClone
		{
			terrainTiles[coord.up()] = value
		}
	}
    
    func directlySetTerrainTileAt(_ coord:DiscreteTileCoord, uid:Int)
    {
        terrainTiles[coord] = uid
    }
    
    func directlySetDoodadTileAt(_ coord:DiscreteTileCoord, uid:Int)
    {
        doodadTiles[coord] = uid
    }
    
    func setTerrainTileAt(_ coord:DiscreteTileCoord, uid:Int, collaboratorID:String?)
    {
        if withinBounds(coord)
        {
            if let oldType = terrainTiles[coord]
            {
                if (oldType != uid)
                {
                    if (uid == 0)
                    {
                        terrainTiles.removeValue(forKey: coord)
                    }
                    else if (oldType != uid)
                    {
                        terrainTiles[coord] = uid
                    }
                    
                    removeDoodadAt(coord, collaboratorID:collaboratorID)
                    notifyDirectObserversOfTerrainChange(coord, old:oldType, new:uid, collaboratorID:collaboratorID)
                }
            }
            else
            {
                if (uid > 0)
                {
                    terrainTiles[coord] = uid
                    removeDoodadAt(coord, collaboratorID:collaboratorID)
                    notifyDirectObserversOfTerrainChange(coord, old:0, new:uid, collaboratorID:collaboratorID)
                }
            }
        }
    }
    
    // Doodads can only be placed on non-void, non-obstacle terrain
    // If a doodad already exists at the coordinate, it will be replaced instantly
    func canPlaceDoodadAt(_ coord:DiscreteTileCoord) -> Bool
    {
        var canPlace = false
        
        let underlyingTerrainUID = terrainTileUIDAt(coord)
        if (underlyingTerrainUID > 0)
        {
            if let underlyingTerrainIsObstacle = tilesetData?.isObstacle(underlyingTerrainUID)
            {
                if (!underlyingTerrainIsObstacle)
                {
                    canPlace = true
                }
            }
        }
        
        return canPlace
    }
    
    func setDoodadTileAt(_ coord:DiscreteTileCoord, uid:Int, collaboratorID:String?)
    {
        if (withinBounds(coord))
        {
            if let oldType = doodadTiles[coord]
            {
                if (oldType != uid)
                {
                    if (uid == 0)
                    {
                        doodadTiles.removeValue(forKey: coord)
                    }
                    else if (oldType != uid)
                    {
                        doodadTiles[coord] = uid
                    }
                    
                    notifyDirectObserversOfDoodadChange(coord, old:oldType, new:uid, collaboratorID:collaboratorID)
                }
            }
            else
            {
                // There did not used to be any tile here
                if (uid > 0)
                {
                    doodadTiles[coord] = uid
                    notifyDirectObserversOfDoodadChange(coord, old:0, new:uid, collaboratorID:collaboratorID)
                }
            }
        }
    }
    
    func removeDoodadAt(_ coord:DiscreteTileCoord, collaboratorID:String?)
    {
        if (doodadTileExistsAt(coord))
        {
            setDoodadTileAt(coord, uid:0, collaboratorID:collaboratorID)
        }
    }
    
    func randomCoord() -> DiscreteTileCoord
    {
        let random_x = randIntBetween(bounds.left, stop:bounds.right)
        let random_y = randIntBetween(bounds.down, stop:bounds.up)
        
        return DiscreteTileCoord(x:random_x, y:random_y)
    }
    
    func clearAllTerrainTiles()
    {
        terrainTiles.removeAll()
    }
    
    func clearAllDoodadTiles()
    {
        terrainTiles.removeAll()
    }
    
    func clearAllTiles()
    {
        clearAllTerrainTiles()
        clearAllDoodadTiles()
    }
    
    func setAllTerrainTiles(_ uid:Int, directly:Bool)
    {
        for x in bounds.left...bounds.right
        {
            for y in bounds.down...bounds.up
            {
                let coord = DiscreteTileCoord(x:x, y:y)
                
                if (directly)
                {
                    directlySetTerrainTileAt(coord, uid:uid)
                }
                else
                {
                    // Enqueue change
                    let change = Change(coord:coord, layer:TileLayer.terrain, value:uid, collaboratorUUID:nil)
                    registerChange(change)
                }
            }
        }
    }
    
    func allTerrainData() -> [DiscreteTileCoord:Int]
    {
        return terrainTiles
    }
    
    func randomizeAllTerrainTiles(_ uids:Set<Int>, directly:Bool)
    {
        for x in bounds.left...bounds.right
        {
            for y in bounds.down...bounds.up
            {
                let coord = DiscreteTileCoord(x:x, y:y)
                if let randomUID = uids.randomElement()
                {
                    if (directly)
                    {
                        directlySetTerrainTileAt(coord, uid:randomUID)
                    }
                    else
                    {
                        // Enqueue change
                        let change = Change(coord:coord, layer:TileLayer.terrain, value:randomUID, collaboratorUUID:nil)
                        registerChange(change)
                    }
                }
            }
        }
    }
    
    func randomizeAllDoodadTiles(_ uids:Set<Int>, directly:Bool)
    {
        for x in bounds.left...bounds.right
        {
            for y in bounds.down...bounds.up
            {
                let coord = DiscreteTileCoord(x:x, y:y)
                
                if (canPlaceDoodadAt(coord))
                {
                    if let randomUID = uids.randomElement()
                    {
                        if (directly)
                        {
                            directlySetDoodadTileAt(coord, uid:randomUID)
                        }
                        else
                        {
                            // Enqueue change
                            let change = Change(coord:coord, layer:TileLayer.doodad, value:randomUID, collaboratorUUID:nil)
                            registerChange(change)
                        }
                    }
                }
            }
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////
    // Tileset Data
    //////////////////////////////////////////////////////////////////////////////////////////
    func swapTilesetData(_ newTilesetData:TilesetData)
    {
        self.tilesetData = newTilesetData
    }
    
    func allTerrainObstacles() -> Set<Int>
    {
        if let tilesetData = tilesetData
        {
            return tilesetData.allTerrainObstacles()
        }
        else
        {
            return Set<Int>()
        }
    }
    
    func allTerrainPathables() -> Set<Int>
    {
        if let tilesetData = tilesetData
        {
            return tilesetData.allTerrainPathables()
        }
        else
        {
            return Set<Int>()
        }
    }
}
