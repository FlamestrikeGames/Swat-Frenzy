//
//  Wasp.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 10/26/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import UIKit

class Wasp: Enemy {
    
    init() {
        super.init(image: "wasp")
        initializeAtlas(enemyName: "Wasp")

        name = "wasp"
        damage = 17.5
        stunDuration = 0.2
        aliveDuration = 5.0
        soundEffectFile = "wasp.wav"
        goldValue = 12
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
