//
//  AngleUtility.swift
//  Hexed
//
//  Created by Martin Mumford on 10/31/15.
//  Copyright © 2015 Runemark. All rights reserved.
//

import Foundation
import SpriteKit

func angleBetweenCoords(_ p1:DiscreteTileCoord, p2:DiscreteTileCoord) -> Double
{
    let cgPoint1 = CGPoint(x: CGFloat(p1.x), y: CGFloat(p1.y))
    let cgPoint2 = CGPoint(x: CGFloat(p2.x), y: CGFloat(p2.y))
    return angleBetweenPoints(cgPoint1, p2:cgPoint2)
}

func angleBetweenPoints(_ p1:CGPoint, p2:CGPoint) -> Double
{
    let deltaX = Double(p2.x - p1.x)
    let deltaY = Double(p2.y - p1.y)
    
    var angleInDegrees = atan2(deltaY, deltaX) * (180 / Double.pi)
    
    if (angleInDegrees < 0.0)
    {
        angleInDegrees += 360
    }
    
    return angleInDegrees
}

func angleBetweenPoints(_ p1:DiscreteTileCoord, p2:DiscreteTileCoord) -> Double
{
    let point_1 = CGPoint(x: CGFloat(p1.x), y: CGFloat(p1.y))
    let point_2 = CGPoint(x: CGFloat(p2.x), y: CGFloat(p2.y))
    
    return angleBetweenPoints(point_1, p2:point_2)
}

func angleDifference(_ a1:Double, a2:Double) -> Double
{
    var diff = a2 - a1
    
    if (diff < 180)
    {
        diff += 360
    }
    else if (diff > 180)
    {
        diff -= 360
    }
    
    return diff
}

func radialDelta(_ angleInRad:Double, radius:Double) -> CGPoint
{
    let radialDeltaX = cos(angleInRad) * radius
    let radialDeltaY = sin(angleInRad) * radius
    
    return CGPoint(x: CGFloat(radialDeltaX), y: CGFloat(radialDeltaY))
}

func degToRad(_ deg:Double) -> Double
{
    return deg * (Double.pi / 180.0)
}

func radToDeg(_ rad:Double) -> Double
{
    return rad * (180.0 / Double.pi)
}
