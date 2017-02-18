//
//  SynchronizedArray.swift
//  Atlas Editor
//
//  Created by Dusty Artifact on 1/27/16.
//  Copyright © 2016 Dusty Artifact. All rights reserved.
//

import Foundation

open class Stack<T>
{
    fileprivate var array: [T] = []
    
    open func append(_ newElement: T)
    {
        self.array.append(newElement)
    }
    
    open func removeFirst() -> T
    {
        var firstElement:T!
        
        firstElement = self.array.removeFirst()
        
        return firstElement
    }
    
    open func arrayCount() -> Int
    {
        var arrayCount:Int = 0

        arrayCount = self.array.count
        
        return arrayCount
    }
}
