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
        
        name = "bee"
        damage = 15.0
        stunDuration = 0.25
        aliveDuration = 3.0
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
