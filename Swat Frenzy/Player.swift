//
//  Player.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 10/17/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import SpriteKit

class Player {
    var currentHealth: Int = 100
    var goldAmount: Int = 0
    
    init(goldAmount: Int) {
        self.goldAmount = goldAmount
    }
    
    func gainHealth(amount: Int) {
        currentHealth += amount
        if (currentHealth > 100) {
            currentHealth = 100
        }
        // play animation to regain health
        // play sound of healing
    }
    
    func takeDamage(amount: Int) {
        currentHealth -= amount
    }
}
