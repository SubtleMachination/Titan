//
//  ViewController.swift
//  Atlas
//
//  Created by Dusty Artifact on 2/18/17.
//  Copyright © 2017 Overmind. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController {

    @IBOutlet var skView: SKView!
	
	var scene:SKScene?
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let skView = self.view as! SKView
		scene = GameScene(size:(skView.frame.size))
		
		skView.showsFPS = true
		skView.showsNodeCount = true
		
		scene!.scaleMode = .aspectFill
		skView.presentScene(scene)
	}
}

