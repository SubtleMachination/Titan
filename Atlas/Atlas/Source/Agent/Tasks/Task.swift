//
//  Task.swift
//  Atlas
//
//  Created by Dusty Artifact on 3/10/17.
//  Copyright © 2017 Overmind. All rights reserved.
//

import Foundation

class Task
{
	let delegate:ActorDelegate
	var completion:Double
	
	init(delegate:ActorDelegate)
	{
		self.completion = 0.0
		self.delegate = delegate
	}
	
	func execute()
	{
		initialize()
		
		while (completion < 1.0)
		{
			// 1 - DECIDE
			let nextTask = decide()
			// 2 - ACT
			act(task:nextTask)
			// 3 - EVALUATE
			completion = evaluate()
		}
	}
	
	func initialize()
	{
		// Noop
	}
	
	func evaluate() -> Double
	{
		return 1.0
	}
	
	func decide() -> Task?
	{
		return nil
	}
	
	func act(task:Task?)
	{
		if task != nil
		{
			task!.execute()
		}
		else
		{
			completion = 1.0
		}
	}
}
