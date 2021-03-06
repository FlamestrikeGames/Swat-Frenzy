//
//  LevelEightScene.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 10/26/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import SpriteKit

class LevelEightScene: BaseScene {
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        initializeBackground(withName: "waspNestBackground", withAlpha: 1.0)
        objective?.text = "Swat 60 Wasps off the screen!"

        currentLevel = 8
        enemiesToKill = 60
        enemiesLeft?.text = String(enemiesToKill!)
        enemySprite?.run(SKAction.resize(toWidth: 50, duration: 0.0))
        enemySprite?.texture = SKTexture(imageNamed: "wasp")
        
        gameLayer.run(SKAction.wait(forDuration: 3.0), completion: {
            // Spawn enemies
            self.gameLayer.run(SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.run({
                        let enemy = Wasp()
                        enemy.playEnemySound()
                        self.spawnEnemy(enemy: enemy)
                        let enemy2 = Wasp()
                        enemy2.playEnemySound()
                        self.spawnEnemy(enemy: enemy2)
                    }),
                    SKAction.wait(forDuration: 1.15)
                    ])
                )
            )
        })
    }
}
