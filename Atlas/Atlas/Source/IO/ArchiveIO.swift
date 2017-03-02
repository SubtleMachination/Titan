//
//  TilesetIO.swift
//  Atlas Editor
//
//  Created by Dusty Artifact on 1/5/16.
//  Copyright © 2016 Dusty Artifact. All rights reserved.
//

import Foundation

// ARCHIVE FORMAT

// x1:y1:v1
// x2:y2:v2
// x3:y3:v3
// ...

class ArchiveIO
{
    let fileIO:FileIO
    
    init()
    {
        fileIO = FileIO()
    }
    
    func importArchive(_ name:String) -> Archive?
    {
        var archive:Archive?
        
        if let stringContents = fileIO.importStringFromFileInDocs(name, fileExtension:"archive", pathFromDocs:"Archives")
        {
            archive = importArchiveFromFileContents(stringContents)
        }
        
        return archive
    }
    
    func allArchives() -> [String]
    {
        return fileIO.filesInDocsFolder("Archives")
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////
    // Archive Import
    //////////////////////////////////////////////////////////////////////////////////////////
    
    func importArchiveFromFileContents(_ fileContents:String) -> Archive
    {
        let archive = Archive()
        
        let rows = fileContents.components(separatedBy: "\n")
        
        for row in rows
        {
            let rowData = row.components(separatedBy: ":")
            if (row.contains("name"))
            {
                if (rowData.count == 2)
                {
                    let name = rowData[1]
                    archive.name = name
                }
            }
            else if let change = stringToChange(row)
            {
                archive.registerChange(change)
            }
        }
        
        return archive
    }
	
	func stringToChangeType(changeTypeString:String) -> ChangeType?
	{
		var changeType:ChangeType?
		switch(changeTypeString)
		{
			case "MAP_CHANGE":
				changeType = ChangeType.MAP_CHANGE
				break
			case "CURSOR_CHANGE":
				changeType = ChangeType.CURSOR_CHANGE
				break
			default:
				break
		}
		if (changeTypeString == "MAP_CHANGE")
		{
			return ChangeType.MAP_CHANGE
		} else if (changeTypeString == "CURSOR_CHANGE")
		{
			return ChangeType.CURSOR_CHANGE
		}

	}
	
	func stringToCoordinate(coordString:String) -> DiscreteTileCoord
	{
		let coordinates = coordString.components(separatedBy:",")
		if (coordinates)
	}
	
	// type:MAP	collaborator:Internal
    func stringToChange(_ string:String) -> Change?
    {
        var change:Change?
        let data = string.components(separatedBy: "\t")
        if (data.count == 5)
        {
			// Generic Change Attributes
			var changeType:String?
			var collaborator:String?
			
			// Map Change Attributes
			var layer:String?
			var tileValue:String?
			
			// Cursor Change Attributes
			var cursorState:String?
			var cursorBrush:String?
			
			// Attributes Shared in All Changes
			var position:String?
			
			for datum in data
			{
				let elements = datum.components(separatedBy:":")
				if (elements.count == 2)
				{
					let key = elements[0]
					let val = elements[1]
					
					switch(key)
					{
						case "type":
							changeType = val
							break
						case "collaborator":
							collaborator = val
							break
						case "layer":
							layer = val
							break
						case "val":
							tileValue = val
							break
						case "state":
							cursorState = val
							break
						case "brush":
							cursorBrush = val
							break
						case "pos":
							position = val
							break
						default:
							break
					}
				}
			}
			
			if (changeType != nil && collaborator != nil)
			{
				let changeTypeLiteral = stringToChangeType(changeTypeString:changeType!)
				
				switch(changeType)
				{
					case "MAP":
						if (position != nil && layer != nil && tileValue != nil)
						{
							let positionLiteral = stringToCoordinate(position!)
							let layerLiteral = stringToTileLayer
							change = MapChange(changeType:changeTypeLiteral, collaboratorUUID:collaborator!, coord:positionLiteral, layer:layer!, value:tileValue!)
						}
					case "CURSOR":
					
					
				}
			}
            let x = Int(data[0])
            let y = Int(data[1])
            let v = Int(data[2])
            if (x != nil && y != nil && v != nil)
            {
                let coord = DiscreteTileCoord(x:x!, y:y!)
                change = Change(coord:coord, layer:TileLayer.terrain, value:v!, collaboratorUUID:"Internal")
            }
        }
        
        return change
    }
    
    func exportArchive(_ archive:Archive)
    {
        
        if let name = archive.name
        {
            let archiveString = archiveToString(archive)
            fileIO.exportToFileInDocs(name, fileExtension:"archive", pathFromDocs:"Archives", contents:archiveString)
        }
        else
        {
            print("Archive has no name")
        }
    }
    
    func archiveToString(_ archive:Archive) -> String
    {
        var archiveString = ""
        if let name = archive.name
        {
            archiveString += "name:\(name)\n"
        }
        
        var changeStrings = [String]()
        for change in archive.operations
        {
            changeStrings.append(changeToStirng(change))
        }
        
        archiveString += changeStrings.joined(separator: "\n")
        
        return archiveString
    }
	
	func collaboratorToString(collaboratorUUID:String?) -> String
	{
		if let collaborator = collaboratorUUID
		{
			return collaborator
		}
		else
		{
			return "Unknown"
		}
	}
	
	func posToString(coord:DiscreteTileCoord) -> String
	{
		return "pos:\(coord.x),\(coord.y)"
	}
    
    func changeToStirng(_ change:Change) -> String
    {
		var changeString = ""
		switch (change.changeType) {
			case ChangeType.MAP_CHANGE:
				let mapChange = change as! MapChange
				let typeString = "type:MAP"
				let coordString = posToString(coord:mapChange.coord)
				let layerString = "layer:\(mapChange.layer)"
				let valueString = "val:\(mapChange.value)"
				changeString = [typeString, coordString, layerString, valueString].joined(separator:"\t")
				break
			case ChangeType.CURSOR_CHANGE:
				let cursorChange = change as! CursorChange
				let typeString = "type:CURSOR"
				let coordString = posToString(coord:cursorChange.cursorPosition)
				let stateString = "state:\(cursorChange.cursorState)"
				let brushString = "brush:\(cursorChange.cursorBrush)"
				changeString = [typeString, coordString, stateString, brushString].joined(separator:"\t")
				break
		}

		changeString = "collaborator:" + collaboratorToString(collaboratorUUID:change.collaboratorUUID) + "\t" + changeString
		
        return changeString
    }
}

