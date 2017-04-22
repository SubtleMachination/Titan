//
//  TileMapIO.swift
//  Atlas Editor
//
//  Created by Dusty Artifact on 2/17/16.
//  Copyright © 2016 Dusty Artifact. All rights reserved.
//

import Foundation

class TileMapIO
{
    let fileIO:FileIO
    
    init()
    {
        fileIO = FileIO()
    }
	
	func importSimpleModel(_ modelName:String) -> TileMap?
	{
		var model:TileMap?
		
		if let stringContents = fileIO.importStringFromFileInDocs(modelName, fileExtension:"map", pathFromDocs:"Maps")
		{
			model = importModelFromDisk(stringContents, fileName:modelName)
		}
		
		return model
	}
    
    func importModel(_ modelName:String) -> TileMap?
    {
        var model:TileMap?
        
        if let stringContents = fileIO.importStringFromFileInDocs(modelName, fileExtension:"map", pathFromDocs:"Sources")
        {
            model = importModelFromFileContents(stringContents)
        }
        
        return model
    }
    
    func importAtomicMap(_ modelName:String) -> AtomicMap<Int>?
    {
        var map:AtomicMap<Int>?
        
        if let stringContents = fileIO.importStringFromFileInDocs(modelName, fileExtension:"map", pathFromDocs:"Sources")
        {
            map = importMapFromFileContents(stringContents)
        }
        
        return map
    }
    
    func removeModel(_ modelName:String)
    {
        fileIO.removeFileInDocs(modelName, fileExtension:"map", pathFromDocs:"Sources")
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////
    // Model Import
    //////////////////////////////////////////////////////////////////////////////////////////
    
    func importModelFromFileContents(_ fileContents:String) -> TileMap?
    {
        var map:TileMap?
        
        let rows = fileContents.components(separatedBy: "\n")

        var title:String?
        var bounds:TileRect?
        var mapData = [DiscreteTileCoord:Int]()

        for row in rows
        {
            let rowData = row.components(separatedBy: ":")
            if (rowData.count == 2)
            {
                let name = rowData[0]
                let value = rowData[1]

                if (name == "title")
                {
                    title = value
                }
                else if (name == "size")
                {
                    let sizeData = value.components(separatedBy: "x")
                    if (sizeData.count == 4)
                    {
                        let left = Int(sizeData[0])
                        let right = Int(sizeData[1])
                        let up = Int(sizeData[2])
                        let down = Int(sizeData[3])
                        
                        if (left != nil && right != nil && up != nil && down != nil)
                        {
                            bounds = TileRect(left:left!, right:right!, up:up!, down:down!)
                        }
                    }
                }
                else
                {
                    let coordinateData = name.components(separatedBy: ",")
                    if (coordinateData.count == 2)
                    {
                        let x = Int(coordinateData[0])
                        let y = Int(coordinateData[1])

                        if let x = x
                        {
                            if let y = y
                            {
                                let coordinate = DiscreteTileCoord(x:x, y:y)

                                if let tileValue = Int(value)
                                {
                                    mapData[coordinate] = tileValue
                                }
                            }
                        }
                    }
                }
            }
        }

        if let title = title
        {
            if let bounds = bounds
            {
                map = TileMap(bounds:bounds, title:title)
                
                for (coord, value) in mapData
                {
                    map!.directlySetTerrainTileAt(coord, uid:value)
                }
            }
        }
        
        return map
    }
	
	func importModelFromDisk(_ fileContents:String, fileName:String) -> TileMap
	{
		var mapData = [DiscreteTileCoord:Int]()
		var width = 0

		let rows = fileContents.components(separatedBy:"\n")
		let rowCount = rows.count
		let height = rowCount-1
		var currentRow = rowCount-1

		for row in rows
		{
			let columns = row.components(separatedBy:"\t")
			var currentCol = 0
			if (width == 0)
			{
				width = columns.count-1
			}
			for cell in columns
			{
				if let value = Int(cell)
				{
					let coord = DiscreteTileCoord(x:currentCol, y:currentRow)
					mapData[coord] = value
					currentCol += 1
				}
			}
			currentRow -= 1
		}
		

		let model = TileMap(bounds:TileRect(left:0, right:width, up:height, down:0), title:fileName)
		
		for (coord, value) in mapData
		{
			model.directlySetTerrainTileAt(coord, uid:value)
		}
		
		return model
	}
	
    func importMapFromFileContents(_ fileContents:String) -> AtomicMap<Int>?
    {
        var map:AtomicMap<Int>?
        
        let rows = fileContents.components(separatedBy: "\n")
        
        var bounds:TileRect?
        var mapData = [DiscreteTileCoord:Int]()
        
        for row in rows
        {
            let rowData = row.components(separatedBy: ":")
            if (rowData.count == 2)
            {
                let name = rowData[0]
                let value = rowData[1]
                
                if (name == "title")
                {
                    // Do nothing
                }
                if (name == "size")
                {
                    let sizeData = value.components(separatedBy: "x")
                    if (sizeData.count == 4)
                    {
                        let left = Int(sizeData[0])
                        let right = Int(sizeData[1])
                        let up = Int(sizeData[2])
                        let down = Int(sizeData[3])
                        
                        if (left != nil && right != nil && up != nil && down != nil)
                        {
                            bounds = TileRect(left:left!, right:right!, up:up!, down:down!)
                        }
                    }
                }
                else
                {
                    let coordinateData = name.components(separatedBy: ",")
                    if (coordinateData.count == 2)
                    {
                        let x = Int(coordinateData[0])
                        let y = Int(coordinateData[1])
                        
                        if let x = x
                        {
                            if let y = y
                            {
                                let coordinate = DiscreteTileCoord(x:x, y:y)
                                
                                if let tileValue = Int(value)
                                {
                                    mapData[coordinate] = tileValue
                                }
                            }
                        }
                    }
                }
            }
        }
        
        if let bounds = bounds
        {
            map = AtomicMap<Int>(xMax:bounds.width(), yMax:bounds.height(), filler:0, offset:DiscreteTileCoord(x:0, y:0))
            
            for (coord, value) in mapData
            {
                map![coord] = value
            }
        }
        
        return map
    }
	
	func exportModelToDisk(_ model:TileMap)
	{
		var modelString = ""
		let bounds = model.getBounds()
		let tileData = model.allTerrainData()
		
		for row in (bounds.down...bounds.up).reversed()
		{
			var rowString = ""
			for col in bounds.left...bounds.right
			{
				let coord = DiscreteTileCoord(x:col, y:row)
				var value = 0
				if let _ = tileData[coord]
				{
					value = tileData[coord]!
				}
				let stringValue = String(value)
				rowString += stringValue
				if (col < bounds.right)
				{
					rowString += "\t"
				}
			}
			
			modelString.append(rowString)
			if (row > bounds.down)
			{
				modelString += "\n"
			}
		}
		
		fileIO.exportToFileInDocs(model.mapTitle(), fileExtension:"map", pathFromDocs:"Maps", contents:modelString)
	}
    
    func exportModel(_ model:TileMap)
    {
        let modelString = modelToString(model)
        fileIO.exportToFileInDocs(model.mapTitle(), fileExtension:"map", pathFromDocs:"Maps", contents:modelString)
    }
    
    func modelToString(_ model:TileMap) -> String
    {
        var modelString = "title:\(model.mapTitle())\n"
        let bounds = model.getBounds()
        modelString += "size:\(bounds.left)x\(bounds.right)x\(bounds.up)x\(bounds.down)"
        
        for (coord, value) in model.allTerrainData()
        {
            modelString += "\n\(coord.x),\(coord.y):\(value)"
        }
        
        return modelString
    }
}
