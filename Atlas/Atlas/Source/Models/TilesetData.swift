//
//  TilesetModel.swift
//  Atlas Editor
//
//  Created by Dusty Artifact on 1/11/16.
//  Copyright © 2016 Dusty Artifact. All rights reserved.
//

import Foundation

struct TileData
{
    var obstacle:Bool
    var layer:TileLayer
}

class TilesetData
{
    fileprivate var index:[Int:TileData]
    
    fileprivate var terrainUIDs:Set<Int>
    fileprivate var doodadUIDs:Set<Int>
    fileprivate var obstacleUIDs:Set<Int>
    
    init()
    {
        index = [Int:TileData]()
        terrainUIDs = Set<Int>()
        doodadUIDs = Set<Int>()
        obstacleUIDs = Set<Int>()
    }
    
    func registerUID(_ uid:Int, layerType:TileLayer, obstacle:Bool)
    {
        let data = TileData(obstacle:obstacle, layer:layerType)
        index[uid] = data
        
        if (layerType == .terrain)
        {
            terrainUIDs.insert(uid)
        }
        else if (layerType == .doodad)
        {
            doodadUIDs.insert(uid)
        }
        
        if (obstacle)
        {
            obstacleUIDs.insert(uid)
        }
    }
    
    func clearData()
    {
        index.removeAll()
        terrainUIDs.removeAll()
        doodadUIDs.removeAll()
        obstacleUIDs.removeAll()
    }
    
    func layerTypeForUID(_ uid:Int) -> TileLayer?
    {
        if let info = index[uid]
        {
            return info.layer
        }
        else
        {
            return nil
        }
    }
    
    func isObstacle(_ uid:Int) -> Bool?
    {
        if (uid > 0)
        {
            if let info = index[uid]
            {
                return info.obstacle
            }
            else
            {
                return nil
            }
        }
        else
        {
            return true
        }
    }
    
    func allTerrainObstacles() -> Set<Int>
    {
        return terrainUIDs.intersection(obstacleUIDs)
    }
    
    func allTerrainPathables() -> Set<Int>
    {
        return terrainUIDs.subtracting(obstacleUIDs)
    }
    
    func allTerrain() -> Set<Int>
    {
        return terrainUIDs
    }
    
    func allObstacles() -> Set<Int>
    {
        return obstacleUIDs
    }
}
