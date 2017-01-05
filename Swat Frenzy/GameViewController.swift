//
//  GameViewController.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 10/5/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    var level: Int!
    var player: Player!
    
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
            case 1: scene = LevelOneScene(fileNamed: "BaseScene")
            case 2: scene = LevelTwoScene(fileNamed: "BaseScene")
            case 3: scene = LevelThreeScene(fileNamed: "BaseScene")
            case 4: scene = LevelFourScene(fileNamed: "BaseScene")
            case 5: scene = LevelFiveScene(fileNamed: "BaseScene")
            case 6: scene = LevelSixScene(fileNamed: "BaseScene")
            case 7: scene = LevelSevenScene(fileNamed: "BaseScene")
            case 8: scene = LevelEightScene(fileNamed: "BaseScene")
            case 9: scene = LevelNineScene(fileNamed: "BaseScene")
            case 10: scene = EndlessScene(fileNamed: "BaseScene")

          
            default: scene = BaseScene(fileNamed: "BaseScene")
                     break

            }
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.showsPhysics = false
            skView.ignoresSiblingOrder = true
            scene?.scaleMode = .aspectFill
            scene?.player = player
            skView.presentScene(scene)
        }
    }
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
}
