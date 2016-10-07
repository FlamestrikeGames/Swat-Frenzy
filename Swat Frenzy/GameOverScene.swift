//
//  GameOverScene.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 10/7/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import UIKit
import SpriteKit

class GameOverScene: SKScene {
    
    init(size: CGSize, won:Bool) {
        
        super.init(size: size)
        
        backgroundColor = won ? SKColor.green : SKColor.red
        
        let message = won ? "All enemies swatted! You win!" :
                            "You suffered a horrible death!"
        
        let label = SKLabelNode(fontNamed: "Helvetica Neue Bold")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.black
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        
        let replayMessage = "Replay Game"
        let replayButton = SKLabelNode(fontNamed: "Helvetica Neue Bold")
        replayButton.text = replayMessage
        replayButton.fontColor = SKColor.blue
        replayButton.position = CGPoint(x: size.width/2, y: size.height/4)
        replayButton.name = "replay"
        addChild(replayButton)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
         for touch: AnyObject in touches {
         
            let touchLocation = touch.location(in: self)
            let touchedNode = self.atPoint(touchLocation)
            if(touchedNode.name == "replay") {
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                let scene = GameScene(fileNamed: "GameScene.sks")
                self.view?.presentScene(scene!, transition:reveal)
            }
         
         }
        
    }
    
    
}
