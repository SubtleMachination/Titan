//
//  SimpleButton.swift
//  Hexbreaker
//
//  Created by Dusty Artifact on 12/18/15.
//  Copyright © 2015 Runemark. All rights reserved.
//

import Foundation
import SpriteKit

protocol MapExpanderResponder
{
	func expandUp()
	func expandDown()
	func expandLeft()
	func expandRight()
}

class MapExpanderPane : SKNode, ButtonResponder
{
	var responder:MapExpanderResponder?
	var buttons:[SimpleButton]
	
	override init()
	{
		buttons = [SimpleButton]()
		
		let buttonWidth = 16.0
		
		let buttonSize = CGSize(width:buttonWidth, height:buttonWidth)
		let up_button = SimpleButton(iconSize:buttonSize, touchable:buttonSize, iconName:"square", identifier:"up")
		up_button.position = CGPoint(x:0, y:buttonWidth)
		
		let down_button = SimpleButton(iconSize:buttonSize, touchable:buttonSize, iconName:"square", identifier:"down")
		down_button.position = CGPoint(x:0, y:-1*buttonWidth)
		
		let left_button = SimpleButton(iconSize:buttonSize, touchable:buttonSize, iconName:"square", identifier:"left")
		left_button.position = CGPoint(x:-1*buttonWidth, y:0)
		
		let right_button = SimpleButton(iconSize:buttonSize, touchable:buttonSize, iconName:"square", identifier:"right")
		right_button.position = CGPoint(x:buttonWidth, y:0)
		
		buttons.append(up_button)
		buttons.append(down_button)
		buttons.append(left_button)
		buttons.append(right_button)
		
		super.init()
		
		up_button.registerResponder(responder:self)
		down_button.registerResponder(responder:self)
		left_button.registerResponder(responder:self)
		right_button.registerResponder(responder:self)
		
		self.addChild(up_button)
		self.addChild(down_button)
		self.addChild(left_button)
		self.addChild(right_button)
	}
	
	func registerResponder(responder:MapExpanderResponder)
	{
		self.responder = responder
	}
	
	func click(event:NSEvent)
	{
		for button in buttons
		{
			button.click(event:event)
		}
	}
	
	func buttonPressed(id: String) {
		switch(id)
		{
		case "up":
			responder?.expandUp()
			break
		case "down":
			responder?.expandDown()
			break
		case "left":
			responder?.expandLeft()
			break
		case "right":
			responder?.expandRight()
			break
		default:
			break
		}
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
}
