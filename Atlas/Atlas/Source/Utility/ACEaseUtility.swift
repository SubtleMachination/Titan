//
//  ACEase.swift
//  ACFramework
//
//  Created by Martin Mumford on 7/13/15.
//  Copyright © 2015 Runemark Studios. All rights reserved.
//

import Foundation
import SpriteKit

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Curve Types
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public enum CurveType
{
    case linear, quadratic_IN, quadratic_OUT, quadratic_INOUT, cubic_IN, cubic_OUT, cubic_INOUT, quartic_IN, quartic_OUT, quartic_INOUT, quintic_IN, quintic_OUT, quintic_INOUT, sine_IN, sine_OUT, sine_INOUT, circular_IN, circular_OUT, circular_INOUT, exponential_IN, exponential_OUT, exponential_INOUT, elastic_IN, elastic_OUT, elastic_INOUT, back_IN, back_OUT, back_INOUT
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// SKAction Generators
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

func scaleToProportion(_ node:SKNode, scale:CGFloat, duration:CGFloat, type:CurveType) -> SKAction
{
    let initialScale = node.xScale
    let actionBlock = {(node:SKNode, elapsedTime:CGFloat) -> Void in
        let t = elapsedTime/duration
        let d = applyCurve(t, type:type)
        let s = initialScale*(1-d) + scale * d
        node.setScale(s)}
    
    return SKAction.customAction(withDuration: TimeInterval(duration), actionBlock:actionBlock)
}

// Only applies to SKSPriteNode
func scaleToSize(_ node:SKSpriteNode, size:CGSize, duration:CGFloat, type:CurveType) -> SKAction
{
    // CURRENT image size
    let initial_x = node.size.width
    let initial_y = node.size.height
    
    // ORIGINAL image dimensions
    let original_x = initial_x/node.xScale
    let original_y = initial_y/node.yScale
    
    let actionBlock = {(node:SKNode, elapsedTime:CGFloat) -> Void in
        let t = elapsedTime/duration
        let d = applyCurve(t, type:type)
        let new_x = initial_x*(1-d) + size.width * d
        let new_y = initial_y*(1-d) + size.height * d
        
        node.xScale = new_x/original_x
        node.yScale = new_y/original_y}
    
    return SKAction.customAction(withDuration: TimeInterval(duration), actionBlock:actionBlock)
}

func colorBlend(_ nodeToApply:SKSpriteNode, color:NSColor, duration:CGFloat, type:CurveType) -> SKAction
{
    let initialColor = nodeToApply.color
    
    let actionBlock = {(node:SKNode, elapsedTime:CGFloat) -> Void in
        let t = elapsedTime/duration
        let d = applyCurve(t, type:type)
        let newColor = blendColors(initialColor, b:color, blendFactor:Double(d))
        nodeToApply.color = newColor
    }
    
    return SKAction.customAction(withDuration: TimeInterval(duration), actionBlock:actionBlock)
}

func moveTo(_ node:SKNode, destination:CGPoint, duration:CGFloat, type:CurveType) -> SKAction
{
    let initial_x = node.position.x
    let initial_y = node.position.y
    
    let actionBlock = {(node:SKNode, elapsedTime:CGFloat) -> Void in
        let t = elapsedTime/duration
        let d = applyCurve(t, type:type)
        let new_x = initial_x*(1-d) + destination.x * d
        let new_y = initial_y*(1-d) + destination.y * d
        
        node.position.x = new_x
        node.position.y = new_y
    }
    
    return SKAction.customAction(withDuration: TimeInterval(duration), actionBlock:actionBlock)
}

func moveBy(_ node:SKNode, delta:CGPoint, duration:CGFloat, type:CurveType) -> SKAction
{
    let initial_x = node.position.x
    let initial_y = node.position.y
    
    let actionBlock = {(node:SKNode, elapsedTime:CGFloat) -> Void in
        let t = elapsedTime/duration
        let d = applyCurve(t, type:type)
        let new_x = initial_x + (delta.x * d)
        let new_y = initial_y + (delta.y * d)
        
        node.position.x = new_x
        node.position.y = new_y
    }
    
    return SKAction.customAction(withDuration: TimeInterval(duration), actionBlock:actionBlock)
}

func fadeTo(_ node:SKNode, alpha:CGFloat, duration:CGFloat, type:CurveType) -> SKAction
{
    let initialAlpha = node.alpha
    
    let actionBlock = {(node:SKNode, elapsedTime:CGFloat) -> Void in
        let t = elapsedTime/duration
        let d = applyCurve(t, type:type)
        let newAlpha = initialAlpha*(1-d) + alpha * d
        node.alpha = newAlpha}
    
    return SKAction.customAction(withDuration: TimeInterval(duration), actionBlock:actionBlock)
}

func fadeTo(_ start:CGFloat, finish:CGFloat, duration:CGFloat, type:CurveType) -> SKAction
{
    let actionBlock = {(node:SKNode, elapsedTime:CGFloat) -> Void in
        let t = elapsedTime/duration
        let d = applyCurve(t, type:type)
        let newAlpha = start*(1-d) + finish * d
        node.alpha = newAlpha
    }
    
    return SKAction.customAction(withDuration: TimeInterval(duration), actionBlock:actionBlock)
}

func rotateTo(_ start:CGFloat, finish:CGFloat, duration:CGFloat, type:CurveType) -> SKAction
{
    let actionBlock = {(node:SKNode, elapsedTime:CGFloat) -> Void in
        let t = elapsedTime/duration
        let d = applyCurve(t, type:type)
        let newRotation = start*(1-d) + finish * d
        node.zRotation = newRotation
    }
    
    return SKAction.customAction(withDuration: TimeInterval(duration), actionBlock:actionBlock)
}

func rotateBy(_ node:SKNode, delta:CGFloat, duration:CGFloat, type:CurveType) -> SKAction
{
    let initialRotation = node.zRotation
    
    let actionBlock = {(node:SKNode, elapsedTime:CGFloat) -> Void in
        let t = elapsedTime/duration
        let d = applyCurve(t, type:type)
        let newRotation = initialRotation + (delta * d)
        node.zRotation = newRotation
    }
    
    return SKAction.customAction(withDuration: TimeInterval(duration), actionBlock:actionBlock)
}

public func idle(_ duration:CGFloat) -> SKAction
{
    let actionBlock = {(node:SKNode, elapsedTime:CGFloat) -> Void in
        // Does nothing for the specified duration
    }
    
    return SKAction.customAction(withDuration: TimeInterval(duration), actionBlock:actionBlock)
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Curves
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

func applyCurve(_ p:CGFloat, type:CurveType) -> CGFloat
{
    var result = CGFloat(0.0)
    
    switch (type) {
    case .linear:
        result = curveLinear(p)
        break
    case .quadratic_IN:
        result = curveQuadraticEaseIn(p)
        break
    case .quadratic_OUT:
        result = curveQuadraticEaseOut(p)
        break
    case .quadratic_INOUT:
        result = curveQuadraticEaseInOut(p)
        break
    case .cubic_IN:
        result = curveCubicEaseIn(p)
        break
    case .cubic_OUT:
        result = curveCubicEaseOut(p)
        break
    case .cubic_INOUT:
        result = curveCubicEaseInOut(p)
        break
    case .quartic_IN:
        result = curveQuarticEaseIn(p)
        break
    case .quartic_OUT:
        result = curveQuarticEaseOut(p)
        break
    case .quartic_INOUT:
        result = curveQuarticEaseInOut(p)
        break
    case .quintic_IN:
        result = curveQuinticEaseIn(p)
        break
    case .quintic_OUT:
        result = curveQuinticEaseOut(p)
        break
    case .quintic_INOUT:
        result = curveQuinticEaseInOut(p)
        break
    case .sine_IN:
        result = curveSineEaseIn(p)
        break
    case .sine_OUT:
        result = curveSineEaseOut(p)
        break
    case .sine_INOUT:
        result = curveSineEaseInOut(p)
        break
    case .circular_IN:
        result = curveCircularEaseIn(p)
        break
    case .circular_OUT:
        result = curveCircularEaseOut(p)
        break
    case .circular_INOUT:
        result = curveCircularEaseInOut(p)
        break
    case .exponential_IN:
        result = curveExponentialEaseIn(p)
        break
    case .exponential_OUT:
        result = curveExponentialEaseOut(p)
        break
    case .exponential_INOUT:
        result = curveExponentialEaseInOut(p)
        break
    case .elastic_IN:
        result = curveElasticEaseIn(p)
        break
    case .elastic_OUT:
        result = curveElasticEaseOut(p)
        break
    case .elastic_INOUT:
        result = curveElasticEaseInOut(p)
        break
    case .back_IN:
        result = curveBackEaseIn(p)
        break
    case .back_OUT:
        result = curveBackEaseOut(p)
        break
    case .back_INOUT:
        result = curveBackEaseInOut(p)
        break
    }
    
    return result
}

// y = x
func curveLinear(_ p:CGFloat) -> CGFloat
{
    return p
}

// y = x^2
func curveQuadraticEaseIn(_ p:CGFloat) -> CGFloat
{
    return p * p
}

// y = -x^2 + 2x
func curveQuadraticEaseOut(_ p:CGFloat) -> CGFloat
{
    return -(p * (p - 2))
}

// y = (1/2)((2x)^2)             | [0, 0.5)
// y = -(1/2)((2x-1)*(2x-3) - 1) | [0.5, 1]
func curveQuadraticEaseInOut(_ p:CGFloat) -> CGFloat
{
    if (p < 0.5)
    {
        return 2 * p * p;
    }
    else
    {
        return (-2 * p * p) + (4 * p) - 1;
    }
}

// y = x^3
func curveCubicEaseIn(_ p:CGFloat) -> CGFloat
{
    return p * p * p
}

// y = (x - 1)^3 + 1
func curveCubicEaseOut(_ p:CGFloat) -> CGFloat
{
    let f = p - 1
    return f * f * f + 1
}

// y = (1/2)((2x)^3)       | [0, 0.5)
// y = (1/2)((2x-2)^3 + 2) | [0.5, 1]
func curveCubicEaseInOut(_ p:CGFloat) -> CGFloat
{
    if(p < 0.5)
    {
        return 4 * p * p * p
    }
    else
    {
        let f = ((2 * p) - 2)
        return 0.5 * f * f * f + 1
    }
}

// y = x^4
func curveQuarticEaseIn(_ p:CGFloat) -> CGFloat
{
    return p * p * p * p
}

// y = 1 - (x - 1)^4
func curveQuarticEaseOut(_ p:CGFloat) -> CGFloat
{
    let f = p - 1
    return f * f * f * (1 - p) + 1
}


// y = (1/2)((2x)^4)        | [0, 0.5)
// y = -(1/2)((2x-2)^4 - 2) | [0.5, 1]
func curveQuarticEaseInOut(_ p:CGFloat) -> CGFloat
{
    if (p < 0.5)
    {
        return 8 * p * p * p * p
    }
    else
    {
        let f = p - 1
        return -8 * f * f * f * f + 1
    }
}

// y = x^5
func curveQuinticEaseIn(_ p:CGFloat) -> CGFloat
{
    return p * p * p * p * p
}

// y = (x - 1)^5 + 1
func curveQuinticEaseOut(_ p:CGFloat) -> CGFloat
{
    let f = p - 1
    return f * f * f * f * f + 1
}

// y = (1/2)((2x)^5)       | [0, 0.5)
// y = (1/2)((2x-2)^5 + 2) | [0.5, 1]
func curveQuinticEaseInOut(_ p:CGFloat) -> CGFloat
{
    if (p < 0.5)
    {
        return 16 * p * p * p * p * p
    }
    else
    {
        let f = (2 * p) - 2
        return  0.5 * f * f * f * f * f + 1
    }
}

func curveSineEaseIn(_ p:CGFloat) -> CGFloat
{
    return sin((p - 1) * CGFloat(Double.pi / 2.0)) + 1
}

func curveSineEaseOut(_ p:CGFloat) -> CGFloat
{
    return sin(p * CGFloat(Double.pi / 2.0))
}

func curveSineEaseInOut(_ p:CGFloat) -> CGFloat
{
    return 0.5 * (1 - cos(p * CGFloat(Double.pi / 2.0)))
}

func curveCircularEaseIn(_ p:CGFloat) -> CGFloat
{
    return 1 - sqrt(1 - (p * p))
}

func curveCircularEaseOut(_ p:CGFloat) -> CGFloat
{
    return sqrt((2 - p) * p)
}

// y = (1/2)(1 - sqrt(1 - 4x^2))           | [0, 0.5)
// y = (1/2)(sqrt(-(2x - 3)*(2x - 1)) + 1) | [0.5, 1]
func curveCircularEaseInOut(_ p:CGFloat) -> CGFloat
{
    if (p < 0.5)
    {
        return 0.5 * (1 - sqrt(1 - 4 * (p * p)))
    }
    else
    {
        return 0.5 * (sqrt(-((2 * p) - 3) * ((2 * p) - 1)) + 1)
    }
}

// y = -2^(-10x) + 1
func curveExponentialEaseIn(_ p:CGFloat) -> CGFloat
{
    return (p == 1.0) ? p : 1 - pow(2, -10 * p)
}

// y = -2^(-10x) + 1
func curveExponentialEaseOut(_ p:CGFloat) -> CGFloat
{
    return (p == 1.0) ? p : 1 - pow(2, -10 * p)
}

// y = (1/2)2^(10(2x - 1))         | [0,0.5)
// y = -(1/2)*2^(-10(2x - 1))) + 1 | [0.5,1]
func curveExponentialEaseInOut(_ p:CGFloat) -> CGFloat
{
    if (p == 0.0 || p == 1.0)
    {
        return p
    }
    
    if (p < 0.5)
    {
        return 0.5 * pow(2, (20 * p) - 10);
    }
    else
    {
        return -0.5 * pow(2, (-20 * p) + 10) + 1;
    }
}

// y = sin(13pi/2*x)*pow(2, 10 * (x - 1))
func curveElasticEaseIn(_ p:CGFloat) -> CGFloat
{
    return sin(13 * CGFloat(Double.pi / 2.0) * p) * pow(2, 10 * (p - 1))
}

// y = sin(-13pi/2*(x + 1))*pow(2, -10x) + 1
func curveElasticEaseOut(_ p:CGFloat) -> CGFloat
{
    return sin(-13 * CGFloat(Double.pi / 2.0) * (p + 1)) * pow(2, -10 * p) + 1
}

// y = (1/2)*sin(13pi/2*(2*x))*pow(2, 10 * ((2*x) - 1))      | [0,0.5)
// y = (1/2)*(sin(-13pi/2*((2x-1)+1))*pow(2,-10(2*x-1)) + 2) | [0.5, 1]
func curveElasticEaseInOut(_ p:CGFloat) -> CGFloat
{
    if (p < 0.5)
    {
        return 0.5 * sin(13 * CGFloat(Double.pi / 2.0) * (2 * p)) * pow(2, 10 * ((2 * p) - 1))
    }
    else
    {
        return 0.5 * (sin(-13 * CGFloat(Double.pi / 2.0) * ((2 * p - 1) + 1)) * pow(2, -10 * (2 * p - 1)) + 2)
    }
}

// y = x^3-x*sin(x*pi)
func curveBackEaseIn(_ p:CGFloat) -> CGFloat
{
    return p * p * p - p * sin(p * CGFloat(Double.pi))
}

// y = 1-((1-x)^3-(1-x)*sin((1-x)*pi))
func curveBackEaseOut(_ p:CGFloat) -> CGFloat
{
    let f = 1 - p
    return 1 - (f * f * f - f * sin(f * CGFloat(Double.pi)))
}

// y = (1/2)*((2x)^3-(2x)*sin(2*x*pi))           | [0, 0.5)
// y = (1/2)*(1-((1-x)^3-(1-x)*sin((1-x)*pi))+1) | [0.5, 1]
func curveBackEaseInOut(_ p:CGFloat) -> CGFloat
{
    if (p < 0.5)
    {
        let f = 2 * p
        return 0.5 * (f * f * f - f * sin(f * CGFloat(Double.pi)))
    }
    else
    {
        let f = (1 - (2 * p - 1))
        let sinePortion = sin(f * CGFloat(Double.pi))
        return 0.5 * (1 - (f * f * f - f * sinePortion)) + 0.5
    }
}
