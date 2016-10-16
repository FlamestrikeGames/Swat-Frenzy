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
        
        enemiesToKill = 10          // How many enemies to kill before player wins
        enemyDamage = 10            // How much damage to take per hit
        enemyStunDuration = 0.5     // How long the swat impulse lasts before stopping the enemy in place
        enemyDuration = 3.5         // How long the enemy stays on the screen for
        currentLevel = 1            // What level this is
        
        enemiesLeft?.text = String(enemiesToKill!)
        
        // Spawn enemies
        run(SKAction.repeat(
            SKAction.sequence([
                SKAction.wait(forDuration: 2.5),
                SKAction.run({self.spawnEnemy(level: self.currentLevel!)})
                ]), count: enemiesToKill! + (100/enemyDamage!)))
    }
    
}
