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
    
    var level: Int!
    
    init(size: CGSize, won:Bool, level: Int) {
        
        super.init(size: size)
        
        self.level = level
        backgroundColor = won ? SKColor.green : SKColor.red
        
        let message = won ? "All enemies swatted! You win!" :
                            "You suffered a horrible death!"
        
        let label = SKLabelNode(fontNamed: "Helvetica Neue Bold")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.black
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        
        let replayMessage = "Replay Level"
        let replayButton = SKLabelNode(fontNamed: "Helvetica Neue Bold")
        replayButton.text = replayMessage
        replayButton.fontColor = SKColor.blue
        replayButton.position = CGPoint(x: size.width/2, y: size.height/4)
        replayButton.name = "replay"
        addChild(replayButton)
        
        let levelSelect = "Level Select"
        let levelSelectButton = SKLabelNode(fontNamed: "Helvetica Neue Bold")
        levelSelectButton.text = levelSelect
        levelSelectButton.fontColor = SKColor.blue
        levelSelectButton.position = CGPoint(x: size.width/2, y: size.height/7)
        levelSelectButton.name = "levelSelect"
        addChild(levelSelectButton)
        
        if(won) {
            self.run(SKAction.playSoundFileNamed("win.wav", waitForCompletion: false))
        } else {
            self.run(SKAction.playSoundFileNamed("lose.wav", waitForCompletion: false))

        }
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
                    
                default: scene = BaseScene(fileNamed: "BaseScene")
                    break
                    
                }
                scene?.scaleMode = .aspectFill
                self.view?.presentScene(scene!, transition:reveal)
            } else if(touchedNode.name == "levelSelect") {
                // Post notification
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DismissSelf"), object: nil)
            }
         }
    }
}
