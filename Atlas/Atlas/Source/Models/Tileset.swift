//
//  Tileset.swift
//  Atlas Editor
//
//  Created by Dusty Artifact on 1/4/16.
//  Copyright © 2016 Dusty Artifact. All rights reserved.
//

import Foundation
import SpriteKit

struct TileViewInfo
{
    var size:TileViewSize
    var layer:TileLayer
    var alignment:TileViewAlignment?
    var baseString:String
    var sideString:String?
    var extendedSideString:String?
    var topString:String?
    var microString:String
}

enum TileViewAlignment
{
    case vertical, none
}

enum TileViewSize
{
    case short, tall
}

enum TileLayer
{
    case terrain, doodad
}

class Tileset
{
    fileprivate var terrainUIDS:Set<Int>
    fileprivate var doodadUIDS:Set<Int>
    fileprivate var index:[Int:TileViewInfo]
    fileprivate var viewAtlas:SKTextureAtlas?
    
    init()
    {
        index = [Int:TileViewInfo]()
        terrainUIDS = Set<Int>()
        doodadUIDS = Set<Int>()
    }
    
    func importAtlas(_ name:String)
    {
        viewAtlas = SKTextureAtlas(named:name)
    }
    
    func registerUID(_ uid:Int, viewSize:TileViewSize, alignment:TileViewAlignment?, layerType:TileLayer, obstacle:Bool, baseTextureName:String, sideTextureName:String?, extendedSideTextureName:String?, topTextureName:String?, microTextureName:String)
    {
        let viewInfo = TileViewInfo(size:viewSize, layer:layerType, alignment:alignment, baseString:baseTextureName, sideString:sideTextureName, extendedSideString:extendedSideTextureName, topString:topTextureName, microString:microTextureName)
        index[uid] = viewInfo
        
        if (layerType == .terrain)
        {
            terrainUIDS.insert(uid)
        }
        else if (layerType == .doodad)
        {
            doodadUIDS.insert(uid)
        }
    }
    
    func clearData()
    {
        index.removeAll()
        terrainUIDS.removeAll()
        doodadUIDS.removeAll()
    }
    
    func baseTextureNameForUID(_ uid:Int) -> String?
    {
        return index[uid]?.baseString
    }
    
    func sideTextureNameForUID(_ uid:Int) -> String?
    {
        return index[uid]?.sideString
    }
    
    func extendedSideTextureNameForUID(_ uid:Int) -> String?
    {
        return index[uid]?.extendedSideString
    }
    
    func topTextureNameForUID(_ uid:Int) -> String?
    {
        return index[uid]?.topString
    }
    
    func microTextureNameForUID(_ uid:Int) -> String?
    {
        return index[uid]?.microString
    }
    
    func sizeForUID(_ uid:Int) -> TileViewSize?
    {
        if (uid == 0)
        {
            return TileViewSize.short
        }
        else
        {
            return index[uid]?.size
        }
    }
    
    func alignmentForUID(_ uid:Int) -> TileViewAlignment?
    {
        return index[uid]?.alignment
    }
    
    func baseTextureForUID(_ uid:Int) -> SKTexture?
    {
        if let baseTextureName = baseTextureNameForUID(uid)
        {
            if let texture = viewAtlas?.textureNamed(baseTextureName)
            {
                texture.filteringMode = .nearest
                return texture
            }
            else
            {
                return nil
            }
        }
        else
        {
            return nil
        }
    }
    
    func sideTextureForUID(_ uid:Int) -> SKTexture?
    {
        if let sideTextureName = sideTextureNameForUID(uid)
        {
            if let texture = viewAtlas?.textureNamed(sideTextureName)
            {
                texture.filteringMode = .nearest
                return texture
            }
            else
            {
                return nil
            }
        }
        else
        {
            return nil
        }
    }
    
    func extendedSideTextureForUID(_ uid:Int) -> SKTexture?
    {
        if let extendedSideTextureName = extendedSideTextureNameForUID(uid)
        {
            if let texture = viewAtlas?.textureNamed(extendedSideTextureName)
            {
                texture.filteringMode = .nearest
                return texture
            }
            else
            {
                return nil
            }
        }
        else
        {
            return nil
        }
    }
    
    func topTextureForUID(_ uid:Int) -> SKTexture?
    {
        if let topTextureName = topTextureNameForUID(uid)
        {
            if let texture = viewAtlas?.textureNamed(topTextureName)
            {
                texture.filteringMode = .nearest
                return texture
            }
            else
            {
                return nil
            }
        }
        else
        {
            return nil
        }
    }
    
    func microTextureForUID(_ uid:Int) -> SKTexture?
    {
        if let microTextureName = microTextureNameForUID(uid)
        {
            if let texture = viewAtlas?.textureNamed(microTextureName)
            {
                texture.filteringMode = .nearest
                return texture
            }
            else
            {
                return nil
            }
        }
        else
        {
            return nil
        }
    }
    
    func allTerrainUIDS() -> Set<Int>
    {
        return terrainUIDS
    }
    
    func allDoodadUIDS() -> Set<Int>
    {
        return doodadUIDS
    }
    
    func allTerrainUIDSPlusEmpty() -> Set<Int>
    {
        var allUIDS = allTerrainUIDS()
        allUIDS.insert(0)
        return allUIDS
    }
    
    func allDoodadUIDSPlusEmpty() -> Set<Int>
    {
        var allUIDS = allDoodadUIDS()
        allUIDS.insert(0)
        return allUIDS
    }
}
