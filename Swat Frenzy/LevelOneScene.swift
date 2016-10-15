//
//  LevelOneScene.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 10/12/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import SpriteKit
import AVFoundation

class LevelOneScene: BaseScene {
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        enemiesToKill = 2          // How many enemies to kill before player wins
        enemyDamage = 50           // How much damage to take per hit
        enemyStunDuration = 0.5     // How long the swat impulse lasts before stopping the enemy in place
        currentLevel = 1
        
        enemiesLeft?.text = String(enemiesToKill!)
        
        // Spawn enemies
        run(SKAction.repeat(
            SKAction.sequence([
                SKAction.wait(forDuration: 2.0),
                SKAction.run({self.spawnEnemy(level: 1)})
                ]), count: enemiesToKill! + (100/enemyDamage!)))
    }
    
}
