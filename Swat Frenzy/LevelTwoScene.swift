//
//  LevelTwoScene.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 10/12/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import SpriteKit

class LevelTwoScene: BaseScene {
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        initializeBackground(withName: "woodsBackground", withAlpha: 1.0)
        objective?.text = "Swat 30 Flies off the screen!"

        currentLevel = 2
        enemiesToKill = 30
        enemiesLeft?.text = String(enemiesToKill!)
        enemySprite?.texture = SKTexture(imageNamed: "fly")
        
        // Let user get ready for level to start
        gameLayer.run(SKAction.wait(forDuration: 3.0), completion: {
            // Spawn enemies
            self.gameLayer.run(SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.run({
                        let enemy = Fly()
                        enemy.playEnemySound()
                        self.spawnEnemy(enemy: enemy)
                    }),
                    SKAction.wait(forDuration: 1.0),
                    SKAction.run {
                        let spawnChance = self.random(min: 0, max: 10)
                        if spawnChance <= 1 {
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
