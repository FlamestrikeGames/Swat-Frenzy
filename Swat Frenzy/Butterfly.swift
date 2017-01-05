//
//  Butterfly.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 1/4/17.
//  Copyright © 2017 FlamestrikeGames. All rights reserved.
//

import UIKit
import SpriteKit

class Butterfly: Enemy {
    
    init() {
        super.init(image: "mosquito")
        initializeAtlas(enemyName: "Mosquito")
        
        name = "butterfly"
        damage = 10
        stunDuration = 0.0
        aliveDuration = 8.0
        soundEffectFile = "mosquito.wav"
        goldValue = 0
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func beginMovement(vcFrameSize: CGSize, uiHeight: CGFloat) {
        var x: CGFloat = 0
        var y: CGFloat = 0
        run(
            SKAction.repeat(
                SKAction.sequence([
                    SKAction.run {
                        x = BaseScene.sharedInstance().random(min: self.size.width, max: vcFrameSize.width - self.size.width)
                        y = BaseScene.sharedInstance().random(min: self.size.height * 2,
                                                              max: vcFrameSize.height - (self.size.height * 2) - uiHeight)
                        // change direction if moving left
                        if x < self.position.x && self.xScale > 0 || x > self.position.x && self.xScale < 0 {
                            self.xScale *= -1
                        }
                    },
                    SKAction.run ({
                        self.run(SKAction.move(to: CGPoint(x: x, y: y), duration: 2.0),
                                 withKey: "move"
                        )
                    }),
                    SKAction.wait(forDuration: 2.0)
                    ]), count: 4
                )
        )
    }
    
    override func createCircleTimer() {
        let circle = SKShapeNode(circleOfRadius: size.width / 2)
        circle.fillColor = .clear
        circle.strokeColor = .magenta
        addChild(circle)
    }
    
}
