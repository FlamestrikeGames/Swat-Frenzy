//
//  GameViewController.swift
//  Swat Frenzy
//
//  Created by Eddie Chou on 10/5/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    var level: Int!
    
    override func viewWillLayoutSubviews() {
        super.viewDidLoad()
        
        let skView = self.view as! SKView
        if skView.scene == nil {
            var scene: BaseScene?
            switch(level) {
            case 1: scene = LevelOneScene(fileNamed: "BaseScene.sks")
                
            default: scene = BaseScene(fileNamed: "BaseScene.sks")
                     break

            }
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.showsPhysics = false
            skView.ignoresSiblingOrder = true
            scene?.scaleMode = .aspectFill
            scene?.viewController = self
            skView.presentScene(scene)
        }
    }
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
}
