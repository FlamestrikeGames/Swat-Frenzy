//
//  LevelNineScene.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 10/27/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import SpriteKit

class LevelNineScene: BaseScene {
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        currentLevel = 9
        enemiesToKill = 35
        enemiesLeft?.text = String(enemiesToKill!)
        enemySprite?.texture = SKTexture(imageNamed: "wasp")
        
        gameLayer.run(SKAction.wait(forDuration: 3.0), completion: {
            // Spawn boss
            self.spawnBoss()
            self.gameLayer.run(SKAction.repeat(
                SKAction.sequence([
                    SKAction.run({
                        let enemy = Wasp()
                        enemy.playEnemySound()
                        self.spawnEnemy(enemy: enemy)
                    }),
                    SKAction.wait(forDuration: 10.0),
                    SKAction.run({
                        let enemy = Wasp()
                        enemy.playEnemySound()
                        self.spawnEnemy(enemy: enemy)
                    }),
                    SKAction.wait(forDuration: 10.0)
                    ]),
                count: self.enemiesToKill! + 10
                )
            )
        })
    }
    
    override func initializeBackground() {
        let background = SKSpriteNode(imageNamed: "bossBackground")
        let aspectRatio = background.frame.size.width / background.frame.size.height
        background.size = CGSize(width: self.frame.size.width, height: self.frame.size.width / aspectRatio)
        background.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        background.zPosition = -200
        addChild(background)
    }
    
    func spawnBoss() {
        let boss = Boss()
        boss.xScale = 1.5
        boss.yScale = 1.5
        boss.playEnemySound()
        boss.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: boss.frame.size.width,
                                                              height: boss.frame.size.height))
        boss.physicsBody?.isDynamic = true
        boss.physicsBody?.categoryBitMask = PhysicsCategory.Boss
        boss.physicsBody?.contactTestBitMask = PhysicsCategory.Weapon
        boss.physicsBody?.collisionBitMask = PhysicsCategory.None
        boss.physicsBody?.affectedByGravity = false
        boss.physicsBody?.usesPreciseCollisionDetection = true
        
        let spawnPosition = boss.getSpawnPosition(vcFrameSize: frame.size)
        boss.position = spawnPosition
        gameLayer.addChild(boss)
        
        let bossWidth = boss.frame.size.width
        let bossHeight = boss.frame.size.height
        
        // after finishing moving, take boss damage (every 1.5s)      
        boss.run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run({
                    boss.run(
                        SKAction.move(to: CGPoint(x: self.random(min: bossWidth / 2,
                                                                 max: self.frame.size.width - bossWidth / 2),
                                                  y: self.random(min: bossHeight / 2,
                                                                 max: self.frame.size.height - (bossHeight / 2) - 50)),
                                      duration: 1.5)
                    )
                }),
                SKAction.wait(forDuration: 1.5),
                SKAction.run({
                    boss.run(SKAction.playSoundFileNamed("whack.wav", waitForCompletion: false))
                    self.player.takeDamage(amount: Int(boss.damage))
                    self.takeHit()
                    self.resizeHealthBar()
                })
            ])
        ))
    }
    
    override func initializeMusic() {
        // Play background music
        playBackgroundMusic(fileName: "boss.wav", volume: 0.5)
    }
    


}
