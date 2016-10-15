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
    
    func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewDidLoad()
        
        // Define identifier
        let notificationName = Notification.Name("DismissSelf")
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.dismissSelf), name: notificationName, object: nil)
        
        let skView = self.view as! SKView
        if skView.scene == nil {
            var scene: BaseScene?
            switch(level) {
            case 1: scene = LevelOneScene(fileNamed: "BaseScene.sks")
            case 2: scene = LevelTwoScene(fileNamed: "BaseScene.sks")
                
            default: scene = BaseScene(fileNamed: "BaseScene.sks")
                     break

            }
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.showsPhysics = false
            skView.ignoresSiblingOrder = true
            scene?.scaleMode = .aspectFill
            skView.presentScene(scene)
        }
    }
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
}
