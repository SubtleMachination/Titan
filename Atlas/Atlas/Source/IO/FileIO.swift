//
//  IO.swift
//  Atlas Editor
//
//  Created by Dusty Artifact on 1/5/16.
//  Copyright © 2016 Dusty Artifact. All rights reserved.
//

import Foundation

//////////////////////////////////////////////////////////////////////////////////////////
// Import
//////////////////////////////////////////////////////////////////////////////////////////

class FileIO
{
    var fileManager:FileManager
    
    init()
    {
        fileManager = FileManager.default
    }
    
    func filesInDocsFolder(_ pathFromDocs:String?) -> [String]
    {
        var files = [String]()
        
        let docs = docsPath()
        let intermediatePath = (pathFromDocs != nil) ? pathFromDocs! : ""
        let fullPath = "\(docs)/\(intermediatePath)"
        
        do
        {
            try files = fileManager.contentsOfDirectory(atPath: fullPath)
			
        }
        catch let error as NSError
        {
            print("Could not find directory: \(error.localizedDescription)")
        }
        
        return files
    }
    
    func importStringFromFileInBundle(_ fileName:String, fileExtension:String) -> String?
    {
        var stringContents:String?
        
        if let filePath = filePathInBundle(fileName, fileExtension:fileExtension)
        {
            stringContents = stringContentsFromFilePath(filePath)
        }
        
        return stringContents
    }
    
    func importStringFromFileInDocs(_ fileName:String, fileExtension:String, pathFromDocs:String?) -> String?
    {
        var stringContents:String?
        
        let filePath = filePathInDocs(fileName, fileExtension:fileExtension, pathFromDocs:pathFromDocs)
        stringContents = stringContentsFromFilePath(filePath)
        
        return stringContents
    }
    
    func exportToFileInDocs(_ fileName:String, fileExtension:String, pathFromDocs:String?, contents:String)
    {
        let filePath = filePathInDocs(fileName, fileExtension:fileExtension, pathFromDocs:pathFromDocs)
        print("Exporting to: \(filePath)")
        if let pathFromDocs = pathFromDocs
        {
            let intermediatePath = filePathForDirectoryInDocs(pathFromDocs)
            if !fileManager.fileExists(atPath: intermediatePath)
            {
                do
                {
                    try fileManager.createDirectory(atPath: intermediatePath, withIntermediateDirectories:true, attributes:nil)
                }
                catch let error as NSError
                {
                    print("Could not create source directory due to error: \(error.localizedDescription)")
                }
            }
        }
        
        do
        {
            try contents.write(toFile: filePath, atomically:true, encoding:String.Encoding.utf8)
        }
        catch let error as NSError
        {
            print("Unable to write to model file named \(fileName): \(error.localizedDescription)")
        }
    }
    
    func removeFileInDocs(_ fileName:String, fileExtension:String, pathFromDocs:String?)
    {
        let filePath = filePathInDocs(fileName, fileExtension:fileExtension, pathFromDocs:pathFromDocs)
        
        do
        {
            try fileManager.removeItem(atPath: filePath)
        }
        catch let error as NSError
        {
            print("Unable to remove file: \(error.localizedDescription)")
        }
    }
    
    fileprivate func docsPath() -> String
    {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
		let url = paths[0] as String
        return url
    }
    
    // Path from docs is the path from the root docs folder to the desired folder where the file is contained
    // Example: to get access to "Documents/Sources/Crypt000.map" you would use the following parameters:
        // fileName: "Crypt000"
        // fileExtension: "map"
        // pathFromDocs: "Sources"
    fileprivate func filePathInDocs(_ fileName:String, fileExtension:String, pathFromDocs:String?) -> String
    {
        let docs = docsPath()
        let intermediatePath = (pathFromDocs != nil) ? pathFromDocs! + "/" : ""
        return "\(docs)/\(intermediatePath)\(fileName).\(fileExtension)"
    }
    
    fileprivate func filePathForDirectoryInDocs(_ pathFromDocs:String) -> String
    {
        let docs = docsPath()
        return "\(docs)/\(pathFromDocs)"
    }
    
    fileprivate func filePathInBundle(_ fileName:String, fileExtension:String) -> String?
    {
        return Bundle.main.path(forResource: fileName, ofType:fileExtension)
    }
    
    fileprivate func fileExistsInDocsWithName(_ name:String, fileExtension:String, pathFromDocs:String?) -> Bool
    {
        let path = filePathInDocs(name, fileExtension:fileExtension, pathFromDocs:pathFromDocs)
        return fileManager.fileExists(atPath: path)
    }
    
    fileprivate func fileExistsInBundleWithName(_ name:String, fileExtension:String) -> Bool
    {
        if let _ = filePathInBundle(name, fileExtension:fileExtension)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    fileprivate func stringContentsFromFilePath(_ filePath:String) -> String?
    {
        var stringContents:String?
        
        do
        {
            stringContents = try String(contentsOfFile:filePath, encoding:String.Encoding.utf8)
        }
        catch let error as NSError
        {
            print("error loading from path \(filePath)")
            print(error.localizedDescription)
        }
        
        return stringContents
    }
}
