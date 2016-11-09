//
//  LevelFourScene.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 10/16/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import SpriteKit

class LevelFourScene: BaseScene {
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        initializeBackground(withName: "insideHouse1", withAlpha: 0.7)
        initializeBoard()
        
        currentLevel = 4
        enemiesToKill = 20
        enemiesLeft?.text = String(enemiesToKill!)
        enemySprite?.texture = SKTexture(imageNamed: "mosquito")

        
        // Let user get ready for level to start
        gameLayer.run(SKAction.wait(forDuration: 3.0), completion: {
            // Spawn enemies
            self.gameLayer.run(SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.run({
                        let enemy = Mosquito()  
                        enemy.playEnemySound()
                        self.spawnEnemy(enemy: enemy)
                    }),
                    SKAction.wait(forDuration: 1.5)
                    ])
                )
            )
        })
    }
    
    func initializeBoard() {
        let board = SKSpriteNode(imageNamed: "woodenBoard")
        board.size = CGSize(width: self.frame.size.width, height: self.frame.size.height / 12)
        board.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        board.zPosition = -100
        let angle = tan(((self.frame.size.height - (board.size.height)) / 2.0) /
                        (self.frame.size.width / 2.0))
        gameLayer.addChild(board)
        
        board.physicsBody = SKPhysicsBody(rectangleOf: board.frame.size)
        board.physicsBody?.isDynamic = true
        board.physicsBody?.categoryBitMask = PhysicsCategory.Board
        board.physicsBody?.contactTestBitMask = PhysicsCategory.Weapon
        board.physicsBody?.collisionBitMask = PhysicsCategory.None
        board.physicsBody?.affectedByGravity = false
        board.zRotation = CGFloat(angle)
    }
}
