//
//  Mosquito.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 10/21/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import UIKit

class Mosquito: Enemy {
    
    init() {
        super.init(image: "mosquito")
        
        name = "mosquito"
        damage = 20.0
        stunDuration = 0.25
        aliveDuration = 3.5
        soundEffectFile = "mosquito.wav"
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
