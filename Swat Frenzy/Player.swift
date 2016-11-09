//
//  Player.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 10/17/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import SpriteKit

class Player {
    var maxHealth: Int = 50
    var currentHealth: Int

    var goldAmount: Int
    var power: Int = 1
    
    init(gold: Int, bonusPower: Int, bonusHealth: Int) {
        goldAmount = gold
        maxHealth += bonusHealth
        currentHealth = maxHealth
        power += bonusPower
    }
    
    func gainHealth(amount: Int) {
        currentHealth += amount
        if (currentHealth > maxHealth) {
            currentHealth = maxHealth
        }
    }
    
    func takeDamage(amount: Int) {
        currentHealth -= amount
    }
}
