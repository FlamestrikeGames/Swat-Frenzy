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
        
        name = "wasp"
        damage = 20.0
        stunDuration = 0.1
        aliveDuration = 4.0
        soundEffectFile = "wasp.wav"
        goldValue = 6
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
