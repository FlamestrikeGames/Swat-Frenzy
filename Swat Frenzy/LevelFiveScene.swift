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
        
        initializeBoard(location: CGPoint(x: self.frame.size.width / 4, y: self.frame.size.height / 2))
        initializeBoard(location: CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2))
        initializeBoard(location: CGPoint(x: self.frame.size.width * 3 / 4, y: self.frame.size.height / 2))
        
        currentLevel = 5
        enemiesToKill = 25
        enemiesLeft?.text = String(enemiesToKill!)
        
        run(SKAction.wait(forDuration: 3.0), completion: {
            // Spawn enemies
            self.run(SKAction.repeat(
                SKAction.sequence([
                    SKAction.run({
                        let enemy = Fly()
                        self.playAudio(fileName: "mosquito.wav", audioPlayer: 1, volume: 1.0)
                        self.spawnEnemy(enemy: enemy)
                    }),
                    SKAction.wait(forDuration: 1.25),
                    SKAction.run({
                        let enemy = Bee()
                        self.playAudio(fileName: "bumblebee.m4a", audioPlayer: 1, volume: 1.0)
                        self.spawnEnemy(enemy: enemy)
                    }),
                    SKAction.wait(forDuration: 1.0)
                    ]),
                count: self.enemiesToKill! + 10
                )
            )
        })
    }
    
    override func initializeBackground() {
        let background = SKSpriteNode(imageNamed: "woodenBackground")
        let aspectRatio = background.frame.size.width / background.frame.size.height
        background.size = CGSize(width: self.frame.size.width, height: self.frame.size.width / aspectRatio)
        background.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        background.zPosition = -200
        background.alpha = 0.5
        addChild(background)
    }
    
    func initializeBoard(location: CGPoint) {
        let board = SKSpriteNode(imageNamed: "woodenBoard")
        board.size = CGSize(width: self.frame.size.height * 0.8, height: self.frame.size.width / 30)
        board.position = location
        board.zPosition = -100
        board.run(SKAction.rotate(byAngle: CGFloat(M_PI_2), duration: 0.0))
        addChild(board)
 
        board.physicsBody = SKPhysicsBody(rectangleOf: board.frame.size)
        board.physicsBody?.isDynamic = true
        board.physicsBody?.categoryBitMask = PhysicsCategory.Board
        board.physicsBody?.contactTestBitMask = PhysicsCategory.Weapon
        board.physicsBody?.collisionBitMask = PhysicsCategory.None
        board.physicsBody?.affectedByGravity = false
    }
    
}