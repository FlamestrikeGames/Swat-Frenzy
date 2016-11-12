//
//  Spider.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 10/21/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import UIKit
import SpriteKit

class Spider: Enemy {
    
    init() {
        super.init(image: "spider")
        initializeAtlas(enemyName: "Spider")

        name = "spider"
        damage = 15.0
        stunDuration = 0.25
        aliveDuration = 4
        soundEffectFile = "spider.wav"
        goldValue = 8
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func getSpawnPosition(vcFrameSize: CGSize) -> CGPoint {
        var x = (vcFrameSize.width - (size.width * 3/2)) * BaseScene.sharedInstance().random(min: 0, max: 1)
        let y = (vcFrameSize.height - (size.height * 3/2) - 25)
        
        if x < (size.width * 3/2) {
            x += size.width * 3/2
        }
        return CGPoint(x: x, y:y)
    }
    
    override func beginMovement(vcFrameSize: CGSize) {
        let moveX = BaseScene.sharedInstance().random(min: size.width, max: vcFrameSize.width - size.width)
        let moveY = BaseScene.sharedInstance().random(min: size.height * 2, max: vcFrameSize.height - (size.height * 4))
        let moveDuration = 0.5 + ((abs(self.position.x - moveX) + abs(self.position.y - moveY)) / 1000)
        run(SKAction.move(to: CGPoint(x: moveX,y: moveY), duration: TimeInterval(moveDuration)),
            withKey: "move"
        )
    }
}
