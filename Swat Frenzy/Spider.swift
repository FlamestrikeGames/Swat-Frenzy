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
        
        name = "spider"
        damage = 20.0
        stunDuration = 0.5
        aliveDuration = 4
        soundEffectFile = "spider.wav"
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func playEnemySound() {
        run(SKAction.playSoundFileNamed("spider.wav", waitForCompletion: false))
    }
}
