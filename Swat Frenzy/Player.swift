//
//  Player.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 10/17/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

class Player {
    var currentHealth: Int = 100
    var goldAmount: Int = 0
    
    init(goldAmount: Int) {
        self.goldAmount = goldAmount
    }
}
