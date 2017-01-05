//
//  LevelThreeScene.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 10/12/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import SpriteKit

class LevelThreeScene: BaseScene {
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        initializeBackground(withName: "houseBackground", withAlpha: 1.0)
        objective?.text = "Swat 30 Bees off the screen!"

        currentLevel = 3
        enemiesToKill = 30
        enemiesLeft?.text = String(enemiesToKill!)
        enemySprite?.texture = SKTexture(imageNamed: "bee")
        
        // Let user get ready for level to start
        gameLayer.run(SKAction.wait(forDuration: 3.0), completion: {
            // Spawn enemies
            self.gameLayer.run(SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.run({
                        let enemy = Bee()
                        enemy.playEnemySound()
                        self.spawnEnemy(enemy: enemy)
                        let enemy2 = Bee()
                        enemy2.playEnemySound()
                        self.spawnEnemy(enemy: enemy2)
                        
                    }),
                    SKAction.wait(forDuration: 2),
                    SKAction.run {
                        let spawnChance = Helper.random(min: 1, max: 10)
                        if spawnChance == 1 {
                            let enemy = Butterfly()
                            enemy.playEnemySound()
                            self.spawnEnemy(enemy: enemy)
                        }
                    },
                    SKAction.wait(forDuration: 0.25)
                    ])
                )
            )
        })
    }
}
