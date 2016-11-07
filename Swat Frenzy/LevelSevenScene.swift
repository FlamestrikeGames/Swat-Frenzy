//
//  LevelSevenScene.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 10/25/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import SpriteKit

class LevelSevenScene: BaseScene {
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        initializeBackground(withName: "gardenBackground", withAlpha: 1.0)
                
        currentLevel = 7
        enemiesToKill = 30
        enemiesLeft?.text = String(enemiesToKill!)
        enemySprite?.texture = SKTexture(imageNamed: "snake")
        enemySprite2?.texture = SKTexture(imageNamed: "bee")
        enemySprite2?.alpha = 1
        
        initializeBoard(location: CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 4))

        
        gameLayer.run(SKAction.wait(forDuration: 3.0), completion: {
            // Spawn enemies
            self.gameLayer.run(SKAction.repeat(
                SKAction.sequence([
                    SKAction.run({
                        let enemy = Snake()
                        enemy.playEnemySound()
                        self.spawnEnemy(enemy: enemy)
                    }),
                    SKAction.wait(forDuration: 1.0),
                    SKAction.run({
                        let enemy = Bee()
                        enemy.playEnemySound()
                        self.spawnEnemy(enemy: enemy)
                    }),
                    SKAction.wait(forDuration: 1.0)
                    ]),
                count: self.enemiesToKill! + 10
                )
            )
        })
    }
    
    func initializeBoard(location: CGPoint) {
        let board = SKSpriteNode(imageNamed: "woodenBoard")
        board.size = CGSize(width: self.frame.size.width * 0.9, height: self.frame.size.height / 15)
        board.position = location
        board.zPosition = -100
        addChild(board)
        
        board.physicsBody = SKPhysicsBody(rectangleOf: board.frame.size)
        board.physicsBody?.isDynamic = true
        board.physicsBody?.categoryBitMask = PhysicsCategory.Board
        board.physicsBody?.contactTestBitMask = PhysicsCategory.Weapon
        board.physicsBody?.collisionBitMask = PhysicsCategory.None
        board.physicsBody?.affectedByGravity = false
    }
}
