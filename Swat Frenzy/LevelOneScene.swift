//
//  LevelOneScene.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 10/12/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import SpriteKit

class LevelOneScene: BaseScene {
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        initializeBackground(withName: "entranceToWoods", withAlpha: 1.0)
        objective?.text = "Swat 20 Flies off the screen!"
        
        currentLevel = 1
        enemiesToKill = 20
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
                    SKAction.wait(forDuration: 1.25)
                    ])
                )
            )
        })
    }
}
