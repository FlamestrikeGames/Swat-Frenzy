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
        
        enemiesToKill = 10
        enemyDamage = 10
        enemiesLeft?.text = String(enemiesToKill!)
        
        // Runs this action a max number of times
        run(SKAction.repeat(
            SKAction.sequence([
                SKAction.wait(forDuration: 2.0),
                SKAction.run({self.spawnEnemy(level: 1)})
                ]), count: enemiesToKill! + (100/enemyDamage!)))
    }
    
}
