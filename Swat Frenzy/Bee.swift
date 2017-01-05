//
//  Bee.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 10/17/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import UIKit

class Bee: Enemy {

    init() {
        super.init(image: "bee")
        initializeAtlas(enemyName: "Bee")

        name = "bee"
        damage = 7.5
        stunDuration = 0.4
        aliveDuration = 5.0
        soundEffectFile = "bumblebee.wav"
        goldValue = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
