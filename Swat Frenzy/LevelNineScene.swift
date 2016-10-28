//
//  LevelNineScene.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 10/27/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import SpriteKit

class LevelNineScene: BaseScene {
    
    var enemyHealthBarSprite: SKSpriteNode?
    var enemyHealthBar: SKSpriteNode?
    var enemyHealthBaseWidth: CGFloat?
    
    var boss = Boss()
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        currentLevel = 9
        enemiesToKill = 35
        //enemiesLeft?.text = String(enemiesToKill!)
        //enemySprite?.texture = SKTexture(imageNamed: "wasp")
        enemySprite?.isHidden = true
        enemiesLeft?.isHidden = true
        
        initializeEnemyHealthBar()
        
        
        gameLayer.run(SKAction.wait(forDuration: 3.0), completion: {
            // Spawn boss
            self.spawnBoss()
            self.gameLayer.run(SKAction.repeat(
                SKAction.sequence([
                    SKAction.wait(forDuration: 3.0),
                    SKAction.run({
                        let enemy = Wasp()
                        enemy.playEnemySound()
                        self.spawnEnemy(enemy: enemy)
                    })
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
                    self.boss.run(
                        SKAction.move(to: CGPoint(x: self.random(min: bossWidth / 2,
                                                                 max: self.frame.size.width - bossWidth / 2),
                                                  y: self.random(min: bossHeight / 2,
                                                                 max: self.frame.size.height - (bossHeight / 2) - 50)),
                                      duration: 1.5)
                    )
                }),
                SKAction.wait(forDuration: 1.5),
                SKAction.run({
                    self.boss.run(SKAction.playSoundFileNamed("whack.wav", waitForCompletion: false))
                    self.player.takeDamage(amount: Int(self.boss.damage))
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
    
    override func killEnemy(enemy: SKSpriteNode) {
        enemy.removeAllActions()
        enemy.removeAllChildren()
        enemy.removeFromParent()
    }
    
    func initializeEnemyHealthBar() {
        if let health = childNode(withName: "enemyHealthBar") as? SKSpriteNode {
            enemyHealthBar = health
            enemyHealthBar?.alpha = 1.0
            enemyHealthBaseWidth = health.frame.size.width
        }
        
        if let enemySprite = childNode(withName: "enemyHealthBarSprite") as? SKSpriteNode {
            enemyHealthBarSprite = enemySprite
            enemyHealthBarSprite?.texture = SKTexture(imageNamed: "boss")
            enemyHealthBarSprite?.alpha = 1.0
        }
    }
    
    func resizeEnemyHealthBar() {
        let newWidth = (enemyHealthBaseWidth! * CGFloat(Float(boss.currentHealth) / 500.0))
        enemyHealthBar?.run(
            SKAction.resize(toWidth: newWidth, duration: 0.2), completion: {
                if( newWidth <= self.enemyHealthBaseWidth! * 0.33) {
                    self.enemyHealthBar?.color = .red
                } else if newWidth <= self.enemyHealthBaseWidth! * 0.66 {
                    self.enemyHealthBar?.color = .yellow
                } else {
                    self.enemyHealthBar?.color = .green
                }
            }
        )
        // Check if player won
        if(boss.currentHealth <= 0) {
            // Player wins!
            gameOver(won: true)
        }
    }
    
    override func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if(isWeaponDisplayed) {
            removeWeapon()
        } else {
            return
        }
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // If enemy collides with weapon
        if ((firstBody.categoryBitMask & PhysicsCategory.Enemy != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Weapon != 0)) {
            // FirstBody is always the enemy
            weaponDidCollideWithEnemy(weapon: secondBody.node as! SWBlade, enemy: firstBody.node as! Enemy)
        } else if ((firstBody.categoryBitMask & PhysicsCategory.Weapon != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Boss != 0)) {
            // If weapon collides with boss
            let bossBody = secondBody.node as! SKSpriteNode
            bossBody.run(SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0.1), completion: {
                bossBody.run(SKAction.colorize(with: .black, colorBlendFactor: 0.0, duration: 0.1))
            })
            // do something when hitting boss
            // play damage sound
            bossBody.run(SKAction.playSoundFileNamed("slap.wav", waitForCompletion: false))
            boss.takeDamage(amount: 10)
            resizeEnemyHealthBar()
            
            let heartDrop = random(min: 1, max: 100)
            if (player.currentHealth < 100 && heartDrop <= 25) {
                boss.dropHeart()
                // Gain health
                player.gainHealth(amount: 5)
                resizeHealthBar()
            }
        }
    }


}
