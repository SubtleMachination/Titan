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
    
    func stringToChange(_ string:String) -> Change?
    {
        var change:Change?
        let data = string.components(separatedBy: ":")
        if (data.count == 3)
        {
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
    
    func changeToStirng(_ change:Change) -> String
    {
        return "\(change.coord.x):\(change.coord.y):\(change.value)"
    }
}

