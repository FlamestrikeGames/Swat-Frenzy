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

        name = "fly"
        damage = 10.0
        stunDuration = 0.5
        aliveDuration = 4.0
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
