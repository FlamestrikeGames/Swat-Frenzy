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
        damage = 12.5
        stunDuration = 0.3
        aliveDuration = 5.0
        soundEffectFile = "spider.wav"
        goldValue = 8
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func getSpawnPosition(vcFrameSize: CGSize, uiHeight: CGFloat) -> CGPoint {
        var x = (vcFrameSize.width - (size.width * 3/2)) * Helper.random(min: 0, max: 1)
        let y = (vcFrameSize.height - (size.height * 3/2) - uiHeight)
        
        if x < (size.width * 3/2) {
            x += size.width * 3/2
        }
        return CGPoint(x: x, y:y)
    }
    
    override func beginMovement(vcFrameSize: CGSize, uiHeight: CGFloat) {
        let moveX = Helper.random(min: size.width, max: vcFrameSize.width - size.width)
        let moveY = Helper.random(min: size.height * 2,
                                                      max: vcFrameSize.height - (size.height * 4) - uiHeight)
        let moveDuration = 0.5 + ((abs(self.position.x - moveX) + abs(self.position.y - moveY)) / 1000)
        run(SKAction.move(to: CGPoint(x: moveX,y: moveY), duration: TimeInterval(moveDuration)),
            withKey: "move"
        )
    }
}
