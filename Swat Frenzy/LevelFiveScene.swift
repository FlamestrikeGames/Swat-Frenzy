//
//  LevelFiveScene.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 10/16/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import SpriteKit

class LevelFiveScene: BaseScene {
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        initializeBackground(withName: "insideHouse2", withAlpha: 0.7)
        initializeBoard(location: CGPoint(x: self.frame.size.width / 4, y: self.frame.size.height / 2))
        initializeBoard(location: CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2))
        initializeBoard(location: CGPoint(x: self.frame.size.width * 3 / 4, y: self.frame.size.height / 2))
        objective?.text = "Swat 45 Mosquitos off the screen!"

        currentLevel = 5
        enemiesToKill = 45
        enemiesLeft?.text = String(enemiesToKill!)
        enemySprite?.texture = SKTexture(imageNamed: "mosquito")

        
        gameLayer.run(SKAction.wait(forDuration: 3.0), completion: {
            // Spawn enemies
            self.gameLayer.run(SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.run({
                        let enemy = Mosquito()
                        enemy.playEnemySound()
                        self.spawnEnemy(enemy: enemy)
                        let enemy2 = Mosquito()
                        enemy2.playEnemySound()
                        self.spawnEnemy(enemy: enemy2)
                    }),
                    SKAction.wait(forDuration: 1.5),
                    ])
                )
            )
        })
    }
    
    func initializeBoard(location: CGPoint) {
        let board = SKSpriteNode(imageNamed: "woodenBoard")
        board.size = CGSize(width: self.frame.size.height * 0.8, height: self.frame.size.width / 30)
        board.position = location
        board.zPosition = -100
        gameLayer.addChild(board)
 
        board.physicsBody = SKPhysicsBody(rectangleOf: board.frame.size)
        board.physicsBody?.isDynamic = true
        board.physicsBody?.categoryBitMask = PhysicsCategory.Board
        board.physicsBody?.contactTestBitMask = PhysicsCategory.Weapon
        board.physicsBody?.collisionBitMask = PhysicsCategory.None
        board.physicsBody?.affectedByGravity = false
        board.zRotation = CGFloat(M_PI_2)
    }
    
}
