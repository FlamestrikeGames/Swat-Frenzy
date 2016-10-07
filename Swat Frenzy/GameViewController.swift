//
//  GameViewController.swift
//  Swat Frenzy
//
//  Created by Eddie Chou on 10/5/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import UIKit
import SpriteKit

import AVFoundation

class GameViewController: UIViewController {
    
    override func viewWillLayoutSubviews() {
        super.viewDidLoad()
        
        let skView = self.view as! SKView
        if skView.scene == nil {
            let scene = GameScene(fileNamed: "GameScene.sks")
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.showsPhysics = true
            skView.ignoresSiblingOrder = true
            scene?.scaleMode = .aspectFill
            skView.presentScene(scene)
        }
    }
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
}