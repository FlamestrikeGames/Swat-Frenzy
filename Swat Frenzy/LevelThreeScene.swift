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
        
        currentLevel = 3
        enemiesToKill = 20
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
                    }),
                    SKAction.wait(forDuration: 1.5)
                    ])
                )
            )
        })
    }
}
