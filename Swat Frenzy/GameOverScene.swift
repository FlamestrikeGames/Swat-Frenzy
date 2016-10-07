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
        
        backgroundColor = SKColor.red
        
        let message = won ? "All enemies swatted! You win!" :
                            "You suffered a horrible death!"
        
        let label = SKLabelNode(fontNamed: "Helvetica Neue Bold")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.black
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        
        if(!won) {
            run(SKAction.sequence([
                SKAction.wait(forDuration: 3.0),
                SKAction.run {
                    let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                    let scene = GameScene(fileNamed: "GameScene.sks")
                    self.view?.presentScene(scene!, transition:reveal)
                }
                ])
            )
        }
        

        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
