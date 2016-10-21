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

        currentLevel = 2
        enemiesToKill = 20
        enemiesLeft?.text = String(enemiesToKill!)
        
        // Let user get ready for level to start
        run(SKAction.wait(forDuration: 3.0), completion: {
            // Spawn enemies
            self.run(SKAction.repeat(
                SKAction.sequence([
                    SKAction.run({
                        let enemy = Fly()
                        self.playEnemySound(enemy: enemy)
                        self.spawnEnemy(enemy: enemy)
                    }),
                    SKAction.wait(forDuration: 1.5)
                    ]),
                count: self.enemiesToKill! + 10
                )
            )
        })
    }
    
    override func initializeBackground() {
        let background = SKSpriteNode(imageNamed: "woodsBackground")
        let aspectRatio = background.frame.size.width / background.frame.size.height
        background.size = CGSize(width: self.frame.size.width, height: self.frame.size.width / aspectRatio)
        background.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        background.zPosition = -200
        addChild(background)
    }
}
