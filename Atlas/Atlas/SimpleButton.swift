//
//  SimpleButton.swift
//  Hexbreaker
//
//  Created by Dusty Artifact on 12/18/15.
//  Copyright © 2015 Runemark. All rights reserved.
//

import Foundation
import SpriteKit

protocol ButtonResponder
{
	func buttonPressed(id:String)
}

class SimpleButton : SKNode
{
	var iconSize:CGSize
	var touchable:CGRect
	var icon:SKSpriteNode
	
	var identifier:String
	
	var responder:ButtonResponder?
	
	init(iconSize:CGSize, touchable:CGSize, iconName:String, identifier:String)
	{
		self.iconSize = iconSize
		self.touchable = CGRect(x:(CGFloat(-1.0*touchable.width)/CGFloat(2.0)), y:(CGFloat(-1.0*touchable.height)/CGFloat(2.0)), width:touchable.width, height:touchable.height)
		
		self.identifier = identifier
		
		self.icon = SKSpriteNode(imageNamed:"\(iconName).png")
		icon.resizeNode(iconSize.width, y:iconSize.height)
		icon.position = CGPoint(x:0.0, y:0.0)
		
		super.init()
		
		self.addChild(icon)
	}
	
	func changeColor(color:NSColor, blend:CGFloat)
	{
		self.icon.color = color;
		self.icon.colorBlendFactor = blend;
	}
	
	func registerResponder(responder:ButtonResponder)
	{
		self.responder = responder
	}
	
	func click(event:NSEvent)
	{
		let location = event.location(in:self)
		if (touchable.contains(location))
		{
			responder?.buttonPressed(id:identifier)
		}
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
}
