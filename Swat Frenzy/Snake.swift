//
//  Snake.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 10/25/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import UIKit
import SpriteKit

class Snake: Enemy {
    
    init() {
        super.init(image: "snake")
        initializeAtlas(enemyName: "Snake")

        name = "snake"
        damage = 15.0
        stunDuration = 0.25
        aliveDuration = 5.0
        soundEffectFile = "hiss.wav"
        goldValue = 10
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func getSpawnPosition(vcFrameSize: CGSize, uiHeight: CGFloat) -> CGPoint {
        var x = (vcFrameSize.width - (size.width * 3/2)) * BaseScene.sharedInstance().random(min: 0, max: 1)
        let y = size.height * 3/2 + size.height * BaseScene.sharedInstance().random(min: 0, max: 1)
        
        if x < (size.width * 3/2) {
            x += size.width * 3/2
        }
        return CGPoint(x: x, y:y)
    }
    
    override func beginMovement(vcFrameSize: CGSize, uiHeight: CGFloat) {
        let moveX = BaseScene.sharedInstance().random(min: size.width*2, max: vcFrameSize.width - size.width*2)
        let moveY = BaseScene.sharedInstance().random(min: vcFrameSize.height / 2,
                                                      max: vcFrameSize.height - (size.height) - 50 - uiHeight)
        let moveDuration = 0.5 + ((abs(self.position.x - moveX) + abs(self.position.y - moveY)) / 1000)
        
        
        // change direction if moving left
        if moveX < self.position.x {
            self.xScale *= -1
        }
        run(SKAction.move(to: CGPoint(x: moveX,y: moveY), duration: TimeInterval(moveDuration)),
            withKey: "move"
        )
    }
}
