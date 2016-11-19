//
//  Fly.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 10/16/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import UIKit

class Fly: Enemy {
        
    init() {
        super.init(image: "fly")
        initializeAtlas(enemyName: "Fly")

        name = "fly"
        damage = 5.0
        stunDuration = 0.6
        aliveDuration = 5.0
        soundEffectFile = "fly.wav"
        goldValue = 1
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
