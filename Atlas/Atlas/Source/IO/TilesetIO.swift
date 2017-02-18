//
//  TilesetIO.swift
//  Atlas Editor
//
//  Created by Dusty Artifact on 1/5/16.
//  Copyright © 2016 Dusty Artifact. All rights reserved.
//

import Foundation

class TilesetIO
{
    let fileIO:FileIO
    
    init()
    {
        fileIO = FileIO()
    }
    
    // All tilesets are stored in the BUNDLE itself
    func importTileset(_ name:String) -> Tileset
    {
        var tileset = Tileset()
        
        if let stringContents = fileIO.importStringFromFileInBundle(name, fileExtension:"tileset")
        {
            importTilesetFromStringContents(&tileset, contents:stringContents)
        }
        
        return tileset
    }
    
    fileprivate func importTilesetFromStringContents(_ tileset:inout Tileset, contents:String)
    {
        let tileEntryStrings = contents.components(separatedBy: "\n")
        
        for tileEntryString in tileEntryStrings
        {
            let tileEntryDataStrings = tileEntryString.components(separatedBy: "-")
            if (tileEntryDataStrings.count == 2)
            {
                if let uid = Int(tileEntryDataStrings[0])
                {
                    var size:TileViewSize?
                    var layer:TileLayer?
                    var alignment:TileViewAlignment?
                    var obstacle:Bool?
                    var baseTextureName:String?
                    var sideTextureName:String?
                    var extendedSideTextureName:String?
                    var topTextureName:String?
                    var microTextureName:String?
                    
                    let metaDataStrings = tileEntryDataStrings[1].components(separatedBy: ",")
                    
                    for metaDataString in metaDataStrings
                    {
                        let metaDataComponents = metaDataString.components(separatedBy: ":")
                        if (metaDataComponents.count == 2)
                        {
                            let componentName = metaDataComponents[0]
                            let componentValue = metaDataComponents[1]
                            
                            if (componentName == "size")
                            {
                                size = stringToTileViewSize(componentValue)
                            }
                            else if (componentName == "layer")
                            {
                                layer = stringToTileLayerType(componentValue)
                            }
                            else if (componentName == "alignment")
                            {
                                alignment = stringToTileAlignment(componentValue)
                            }
                            else if (componentName == "obstacle")
                            {
                                obstacle = stringToObstacle(componentValue)
                            }
                            else if (componentName == "texture")
                            {
                                baseTextureName = componentValue
                            }
                            else if (componentName == "sideTexture")
                            {
                                sideTextureName = componentValue
                            }
                            else if (componentName == "extendedSideTexture")
                            {
                                extendedSideTextureName = componentValue
                            }
                            else if (componentName == "topTexture")
                            {
                                topTextureName = componentValue
                            }
                            else if (componentName == "micro")
                            {
                                microTextureName = componentValue
                            }
                        }
                    }
                    
                    if (size != nil && layer != nil && obstacle != nil && baseTextureName != nil && microTextureName != nil)
                    {
                        tileset.registerUID(uid, viewSize:size!, alignment:alignment, layerType:layer!, obstacle:obstacle!, baseTextureName:baseTextureName!, sideTextureName:sideTextureName, extendedSideTextureName:extendedSideTextureName, topTextureName:topTextureName, microTextureName:microTextureName!)
                    }
                }
            }
        }
    }
    
    fileprivate func stringToTileViewSize(_ string:String) -> TileViewSize?
    {
        if (string == "short")
        {
            return TileViewSize.short
        }
        else if (string == "tall")
        {
            return TileViewSize.tall
        }
        else
        {
            return nil
        }
    }
    
    fileprivate func stringToTileLayerType(_ string:String) -> TileLayer?
    {
        if (string == "terrain")
        {
            return TileLayer.terrain
        }
        else if (string == "doodad")
        {
            return TileLayer.doodad
        }
        else
        {
            return nil
        }
    }
    
    fileprivate func stringToObstacle(_ string:String) -> Bool?
    {
        if (string == "true")
        {
            return true
        }
        else if (string == "false")
        {
            return false
        }
        else
        {
            return nil
        }
    }
    
    fileprivate func stringToTileAlignment(_ string:String) -> TileViewAlignment?
    {
        if (string == "vertical")
        {
            return TileViewAlignment.vertical
        }
        else if (string == "none")
        {
            return TileViewAlignment.none
        }
        else
        {
            return nil
        }
    }
        
    func importTilesetData(_ name:String) -> TilesetData
    {
        var tilesetData = TilesetData()
        
        if let stringContents = fileIO.importStringFromFileInBundle(name, fileExtension:"tileset")
        {
            importTilesetDataFromStringContents(&tilesetData, contents:stringContents)
        }
        
        return tilesetData
    }
    
    func importTilesetDataFromStringContents(_ tilesetData:inout TilesetData, contents:String)
    {
        let tileEntryStrings = contents.components(separatedBy: "\n")
        
        for tileEntryString in tileEntryStrings
        {
            let tileEntryDataStrings = tileEntryString.components(separatedBy: "-")
            if (tileEntryDataStrings.count == 2)
            {
                if let uid = Int(tileEntryDataStrings[0])
                {
                    var layer:TileLayer?
                    var obstacle:Bool?
                    
                    let metaDataStrings = tileEntryDataStrings[1].components(separatedBy: ",")
                    
                    for metaDataString in metaDataStrings
                    {
                        let metaDataComponents = metaDataString.components(separatedBy: ":")
                        if (metaDataComponents.count == 2)
                        {
                            let componentName = metaDataComponents[0]
                            let componentValue = metaDataComponents[1]
                    
                            if (componentName == "layer")
                            {
                                layer = stringToTileLayerType(componentValue)
                            }
                            else if (componentName == "obstacle")
                            {
                                obstacle = stringToObstacle(componentValue)
                            }
                        }
                    }
                    
                    if (layer != nil && obstacle != nil)
                    {
                        tilesetData.registerUID(uid, layerType:layer!, obstacle:obstacle!)
                    }
                }
            }
        }
    }
}

