//
//  BaseScene.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 10/5/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import SpriteKit
import AVFoundation

class BaseScene: SKScene, SKPhysicsContactDelegate {
    /* INITIALIZATION */
    var enemiesLeft: SKLabelNode?
    var enemySprite: SKSpriteNode?
    var enemySprite2: SKSpriteNode?
    var healthBar: SKSpriteNode?
    var healthBaseWidth: CGFloat?
    var goldLabel: SKLabelNode?
    var uiBackground: SKSpriteNode?
    var objective: SKLabelNode?
    
    var enemiesToKill: Int?
    var currentLevel: Int?
    var goldGained: Int = 0
    
    var player: Player!
    
    // This optional variable will help us to easily access our weapon
    var weapon: SWBlade?
    
    // This will help us to update the position of the blade
    // Set the initial value to 0
    var weaponPosition = CGPoint.zero
    var weaponStartPosition = CGPoint.zero
    var isWeaponDisplayed = false
    var weaponPhysicsEnabled = false
   
    var backgroundSoundFX: AVAudioPlayer!
    
    struct PhysicsCategory {
        static let None      : UInt32 = 0
        static let All       : UInt32 = UInt32.max
        static let Enemy     : UInt32 = 0b1         // 1
        static let Weapon    : UInt32 = 0b10        // 2
        static let Board     : UInt32 = 0b100       // 4
        static let Boss      : UInt32 = 0b1000      // 8
    }
    
    let gameLayer = SKNode()
    let pauseLayer = SKNode()
    

    // MARK: - Initialization
    
    // Triggers once we move into the game scene
    override func didMove(to view: SKView) {
        addChild(gameLayer)
        initializeMusic()
        initializeUI()
        initializePauseMenu()
    }
    
    func initializeBackground(withName: String, withAlpha: CGFloat) {
        let background = SKSpriteNode(imageNamed: withName)
        let aspectRatio = background.frame.size.width / background.frame.size.height
        background.size = CGSize(width: self.frame.size.width, height: self.frame.size.width / aspectRatio)
        var positionY = self.frame.size.height / 2
        // adjusts background position to the bottom of the screen
        if background.size.height < self.frame.size.height {
            positionY -= ((self.frame.size.height / 2) - (background.size.height / 2))
        }
        background.position = CGPoint(x: self.frame.size.width / 2, y: positionY)
        background.zPosition = -200
        background.alpha = withAlpha

        gameLayer.addChild(background)
    }
    
    func initializeMusic() {
        // Play background music
        playBackgroundMusic(fileName: "arcadeMusic.wav", volume: 0.5)
    }
    
    func initializeUI() {
        // Initialize physics
        physicsWorld.contactDelegate = self
        
        // Makes sure that the node is found and is not null
        if let enemies = childNode(withName: "enemiesLeft") as? SKLabelNode {
            enemiesLeft = enemies
        }
        
        if let health = childNode(withName: "healthBar") as? SKSpriteNode {
            healthBar = health
            healthBaseWidth = health.frame.size.width
        }
        
        if let gold = childNode(withName: "goldAmount") as? SKLabelNode {
            goldLabel = gold
            goldLabel?.text = String(goldGained)
        }
        
        if let enemySpriteNode = childNode(withName: "enemySprite") as? SKSpriteNode {
            enemySprite = enemySpriteNode
        }
        
        if let enemySpriteNode2 = childNode(withName: "enemySprite2") as? SKSpriteNode {
            enemySprite2 = enemySpriteNode2
        }
        
        if let uiBG = childNode(withName: "UIBackground") as? SKSpriteNode {
            uiBackground = uiBG
        }
        
        objective = SKLabelNode(fontNamed: "Marker Felt")
        objective?.text = ""
        objective?.fontSize = 40.0
        objective?.fontColor = SKColor.white
        objective?.position = CGPoint(x: size.width/2, y: size.height/2)
        objective?.name = "objective"
        objective?.zPosition = 0
        addChild(objective!)
        
        objective?.alpha = 0.0
        objective?.run(SKAction.fadeIn(withDuration: 1.5), completion: {
            self.objective?.run(SKAction.fadeOut(withDuration: 1.5), completion: {
                self.objective?.removeFromParent()
            })
        })
    }
    
    // MARK: - Game Logic
    // Spawns an enemy
    func spawnEnemy(enemy: Enemy) {
        // Initialize enemy physics body
        enemy.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: enemy.frame.size.width,
                                                              height: enemy.frame.size.height))
        enemy.physicsBody?.isDynamic = true
        enemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        enemy.physicsBody?.contactTestBitMask = PhysicsCategory.Weapon
        enemy.physicsBody?.collisionBitMask = PhysicsCategory.None
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.usesPreciseCollisionDetection = true
        
        // Spawns enemy within the screen

        let spawnPosition = enemy.getSpawnPosition(vcFrameSize: frame.size, uiHeight: self.uiBackground!.frame.height)
        enemy.position = spawnPosition
        gameLayer.addChild(enemy)
        
        // Spawn attack timer circle
        enemy.createCircleTimer()
        
        // Enemy flies toward player
        if(enemy.name != "butterfly") {
            enemy.run(SKAction.scale(by: 2, duration: enemy.aliveDuration), completion: {
                // Despawn enemy and take damage if action completes
                if(enemy.position.x <= 0 || enemy.position.y <= 0 || enemy.position.x >= self.frame.size.width || enemy.position.y >= self.frame.size.height - self.uiBackground!.frame.height) {
                    self.killEnemy(enemy: enemy)
                } else {
                    self.removeEnemyAndTakeDamage(enemy: enemy)
                }
            })
        } else {
            // butterfly
            enemy.run(SKAction.scale(by: 1.5, duration: enemy.aliveDuration), completion: {
                // if it's still alive, gain health and despawn butterfly
                enemy.dropHeart()
                self.player.gainHealth(amount: 5)
                self.resizeHealthBar()
                enemy.removeAllActions()
                enemy.removeAllChildren()
                enemy.removeFromParent()
                
            })
        }

        
        enemy.beginMovement(vcFrameSize: frame.size, uiHeight: uiBackground!.frame.height)
        enemy.animateEnemy()
    }

    func killEnemy(enemy: SKSpriteNode) {
        enemy.removeAllActions()
        enemy.removeAllChildren()
        enemy.removeFromParent()
        enemiesToKill! -= 1
        enemiesLeft?.text = String(enemiesToKill!)
        if(enemiesToKill! == 0) {
            // You Win!
            self.gameOver(won: true)
        }

    }
    
    func removeEnemyAndTakeDamage(enemy: Enemy) {
        enemy.removeAllActions()
        enemy.removeAllChildren()
        enemy.removeFromParent()
        self.player.takeDamage(amount: Int(enemy.damage))
        // Play whack sound
        self.run(SKAction.playSoundFileNamed("whack.wav", waitForCompletion: false))
        self.takeHit()
        self.resizeHealthBar()
    }
    
    func takeHit() {
        // display red screen
        let takeHitGraphic = SKSpriteNode(color: .red, size: frame.size)
        takeHitGraphic.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        takeHitGraphic.alpha = 0.5
        gameLayer.addChild(takeHitGraphic)
        
        takeHitGraphic.run(
            SKAction.wait(forDuration: 0.10), completion: {
                takeHitGraphic.removeFromParent()
            }
        )
    }
    
    func resizeHealthBar() {
        let newWidth = (healthBaseWidth! * CGFloat(Float(player.currentHealth) / Float(player.maxHealth)))
        healthBar?.run(
            SKAction.resize(toWidth: newWidth, duration: 0.2), completion: {
                if( newWidth <= self.healthBaseWidth! * 0.33) {
                    self.healthBar?.color = .red
                } else if newWidth <= self.healthBaseWidth! * 0.66 {
                    self.healthBar?.color = .yellow
                } else {
                    self.healthBar?.color = .green
                }
            }
        )
        // Check if player lost
        if(player.currentHealth <= 0) {
            // Player loses!
            gameOver(won: false)
        }
    }
    
    func gameOver(won: Bool) {
        backgroundSoundFX.stop()
        
        for child in gameLayer.children {
            if let enemy = child as? Enemy {
                enemy.pauseEnemySound()
            }
        }

        // Save gold to user defaults if player won
        if (won) {
            let userDef = UserDefaults.standard
            player.goldAmount += goldGained
            userDef.set(player.goldAmount, forKey: "goldAmount")
            let maxLevel = userDef.value(forKey: "currentLevel") as? Int
            if(maxLevel != nil && maxLevel! < currentLevel!+1) {
                userDef.set(currentLevel!+1, forKey: "currentLevel")
            }
        }
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        let gameOverScene = GameOverScene(size: self.size, won: won, level: currentLevel!)
        gameOverScene.player = player
        self.view?.presentScene(gameOverScene, transition: reveal)
    }

    // MARK: - Physics
    func didBegin(_ contact: SKPhysicsContact) {
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
            (secondBody.categoryBitMask & PhysicsCategory.Board != 0)) {
            let boardBody = secondBody.node as! SKSpriteNode
            // If weapon collides with board
            // play thunk audio
            boardBody.run(SKAction.playSoundFileNamed("thunk.wav", waitForCompletion: false))
            
            // flash the board red
            boardBody.run(SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0.1), completion: {
                boardBody.run(SKAction.colorize(with: .black, colorBlendFactor: 0.0, duration: 0.1))
            })
        }  else if ((firstBody.categoryBitMask & PhysicsCategory.Weapon != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Boss != 0)) {
            // If weapon collides with boss
            let bossBody = secondBody.node as! SKSpriteNode
            bossBody.run(SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0.1), completion: {
                bossBody.run(SKAction.colorize(with: .black, colorBlendFactor: 0.0, duration: 0.1))
            })
            // do something when hitting boss
        }
    }
    
    func weaponDidCollideWithEnemy(weapon:SWBlade, enemy: Enemy) {
        // Remove move action from enemy
        enemy.removeAction(forKey: "singleMove")
        enemy.removeAction(forKey: "repeatMove")
        
        // Play slap sound and release particles
        run(SKAction.playSoundFileNamed("slap.wav", waitForCompletion: false))
        enemy.releaseHitParticles()
        
        // If enemy is a butterfly, take damage immediately, remove butterfly from parent, return
        if(enemy.name == "butterfly") {
            removeEnemyAndTakeDamage(enemy: enemy)
            removeWeapon()
            return
        }
        
        // Check if it drops a coin
        let coinDrop = Helper.random(min: 1, max: 100)
        let heartDrop = Helper.random(min: 1, max: 100)
        if coinDrop <= 80 {
            // Drop coin
            enemy.dropCoin()
            
            // Increase gold amount
            goldGained += enemy.goldValue
            goldLabel?.text = String(goldGained)
        }
        if (player.currentHealth < player.maxHealth && heartDrop <= 10) {
            enemy.dropHeart()
            // Gain health
            player.gainHealth(amount: 5)
            resizeHealthBar()
        }
        
        // Calculate difference in x, y for direction of move
        var dx = enemy.position.x - weaponStartPosition.x
  //      print("dx initial power: ", dx)
        var dy = enemy.position.y - weaponStartPosition.y
        let playerPower = CGFloat(player.power) * 5.0 / 3.0
  //      print("playerPower is: ", player.power)
        if dx < 0 {
            dx -= playerPower
        } else {
            dx += playerPower
        }
  //      print("dx with playerpower: ", dx)
        if dy < 0 {
            dy -= playerPower
        } else {
            dy += playerPower
            
        }
        dx *= 0.2
        dy *= 0.2
  //      print("dx final power: ", dx)
        enemy.physicsBody?.friction = 1.0
        
        
        enemy.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
        // Waits stunDuration and then stops the enemy in place and checks if it is off the screen
        enemy.run(SKAction.wait(forDuration: enemy.stunDuration), completion: {
            enemy.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            // If the enemy center is off the screen
            if(enemy.position.x <= 0 || enemy.position.y <= 0 || enemy.position.x >= self.frame.size.width || enemy.position.y >= self.frame.size.height - self.uiBackground!.frame.height) {
                self.killEnemy(enemy: enemy)
            }
        })
        removeWeapon()
    }
    
    // MARK: - Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* For weapon animation. */
        let firstTouch = touches.first! as UITouch
        let touchLocation = firstTouch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        if (touchedNode.name == "pauseButton" && !gameLayer.isPaused) {
            showPauseMenu()
        } else if touchedNode.name == "levelSelect" {
            backgroundSoundFX.stop()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DismissSelf"), object: nil)
        } else if touchedNode.name == "resume" {
            removePauseMenu()
        } else if touchedNode.name == "restartLevel" {
            restartLevel()
        } else {
            weaponPosition = touchLocation
            weaponStartPosition = touchLocation
            presentWeaponAtPosition(position: weaponPosition)
        }
    }
    
    // For swipes
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Update weapon position
        let firstTouch = touches.first! as UITouch
        let touchLocation = firstTouch.location(in: self)
        
        // Moves weapon to new position using SKAction
        moveToPosition(oldPosition: weaponPosition, newPosition: touchLocation)
        weaponPosition = touchLocation
        // Creates physics on weapon the first time it is moved
        if(!weaponPhysicsEnabled && isWeaponDisplayed) {
            weapon?.enablePhysics(categoryBitMask: PhysicsCategory.Weapon, contactTestBitmask: PhysicsCategory.Enemy, collisionBitmask: PhysicsCategory.None)
            weapon!.physicsBody?.usesPreciseCollisionDetection = true
            weaponPhysicsEnabled = true
        }
    }
 
    // Remove the Weapon if the touches have been cancelled or ended
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeWeapon()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent!) {
        removeWeapon()
    }
    
    // MARK: - Weapon
    // Initializes weapon at touch location
    func presentWeaponAtPosition(position: CGPoint) {
        weapon = SWBlade(position: position, target: self, color: UIColor.red)
        gameLayer.addChild(weapon!)
        isWeaponDisplayed = true
    }
    
    // This will help us to remove our blade and reset the delta value
    func removeWeapon() {
        if(isWeaponDisplayed) {
            isWeaponDisplayed = false
            weaponPhysicsEnabled = false
            weapon!.removeFromParent()
        }
    }
    
    func moveToPosition(oldPosition: CGPoint, newPosition: CGPoint) {
        let xDistance = fabs(oldPosition.x - newPosition.x)
        let yDistance = fabs(oldPosition.y - newPosition.y)
        let distance = sqrt(xDistance * xDistance + yDistance * yDistance)
        let sceneDiagonal = sqrt(self.frame.size.width * self.frame.size.width + self.frame.size.height * self.frame.size.height)
        weapon?.run(SKAction.move(to: newPosition, duration: Double(distance / sceneDiagonal / 2)))
    }
    
    // MARK: - Audio
    
    func playBackgroundMusic(fileName: String, volume: Float) {
        let path = Bundle.main.path(forResource: fileName, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            let sound = try AVAudioPlayer(contentsOf: url)
            backgroundSoundFX = sound
            // Repeats on negative number
            backgroundSoundFX.numberOfLoops = -1
            sound.play()
            sound.volume = volume
        } catch {
            // couldn't load file :(
        }
    }
    
    // MARK: - Pause Menu
    func initializePauseMenu() {
        let menuBackground = SKSpriteNode(imageNamed: "menuBackground")
        menuBackground.size = CGSize(width: self.frame.size.width / 3, height: self.frame.size.height / 1.5)
        menuBackground.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        menuBackground.zPosition = 50
        pauseLayer.addChild(menuBackground)
        
        let mainMenuLabel = SKLabelNode(fontNamed: "Marker Felt")
        mainMenuLabel.fontColor = Colors.blueColor
        mainMenuLabel.text = "Level Select"
        mainMenuLabel.position = CGPoint(x: self.frame.size.width / 2,
                                         y: self.frame.size.height / 2  - mainMenuLabel.frame.height * 3)
        mainMenuLabel.zPosition = 51
        
        let border = SKShapeNode(rectOf: CGSize(width: mainMenuLabel.frame.size.width + 20,
                                                height: mainMenuLabel.frame.size.height + 10),
                                 cornerRadius: 15.0)
        border.fillColor = .clear
        border.strokeColor = .black
        border.name = "levelSelect"
        border.lineWidth = 2.0
        border.position.y += mainMenuLabel.frame.size.height / 2
        mainMenuLabel.addChild(border)
        
        pauseLayer.addChild(mainMenuLabel)
        
        let resumeLabel = SKLabelNode(fontNamed: "Marker Felt")
        resumeLabel.fontColor = Colors.blueColor
        resumeLabel.text = "Resume"
        resumeLabel.position = CGPoint(x: self.frame.size.width / 2,
                                       y: menuBackground.position.y + resumeLabel.frame.height)
        resumeLabel.zPosition = 51
        
        let border2 = SKShapeNode(rectOf: CGSize(width: resumeLabel.frame.size.width + 20,
                                                 height: resumeLabel.frame.size.height + 10),
                                  cornerRadius: 15.0)
        border2.fillColor = .clear
        border2.strokeColor = .black
        border2.name = "resume"
        border2.position.y += resumeLabel.frame.size.height / 2
        border2.lineWidth = 2.0

        resumeLabel.addChild(border2)
        pauseLayer.addChild(resumeLabel)
        
        let restartLevel = SKLabelNode(fontNamed: "Marker Felt")
        restartLevel.fontColor = Colors.blueColor
        restartLevel.text = "Restart"
        restartLevel.position = CGPoint(x: self.frame.size.width / 2,
                                        y: self.frame.size.height / 2 - restartLevel.frame.height)
        restartLevel.zPosition = 51
        
        let border3 = SKShapeNode(rectOf: CGSize(width: restartLevel.frame.size.width + 20,
                                                height: restartLevel.frame.size.height + 10),
                                 cornerRadius: 15.0)
        border3.fillColor = .clear
        border3.strokeColor = .black
        border3.name = "restartLevel"
        border3.position.y += restartLevel.frame.size.height / 2
        border3.lineWidth = 2.0

        restartLevel.addChild(border3)
        
        pauseLayer.addChild(restartLevel)
    }

    func showPauseMenu() {
        gameLayer.isPaused = true
        backgroundSoundFX.pause()
        for child in gameLayer.children {
            if let enemy = child as? Enemy {
                enemy.pauseEnemySound()
            }
            
        }
        self.physicsWorld.speed = 0.0
        addChild(pauseLayer)
    }
    
    func removePauseMenu() {
        gameLayer.isPaused = false
        backgroundSoundFX.play()
        pauseLayer.removeFromParent()
        for child in gameLayer.children {
            if let enemy = child as? Enemy {
                enemy.startEnemySound()
            }
        }
        self.physicsWorld.speed = 1.0
    }
    
    func restartLevel() {
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        var scene: BaseScene?
        switch(currentLevel!) {
        case 1: scene = LevelOneScene(fileNamed: "BaseScene")
        case 2: scene = LevelTwoScene(fileNamed: "BaseScene")
        case 3: scene = LevelThreeScene(fileNamed: "BaseScene")
        case 4: scene = LevelFourScene(fileNamed: "BaseScene")
        case 5: scene = LevelFiveScene(fileNamed: "BaseScene")
        case 6: scene = LevelSixScene(fileNamed: "BaseScene")
        case 7: scene = LevelSevenScene(fileNamed: "BaseScene")
        case 8: scene = LevelEightScene(fileNamed: "BaseScene")
        case 9: scene = LevelNineScene(fileNamed: "BaseScene")
        case 10: scene = EndlessScene(fileNamed: "BaseScene")
            
        default: scene = BaseScene(fileNamed: "BaseScene")
            break
            
        }
        scene?.scaleMode = .aspectFill
        player.currentHealth = player.maxHealth
        scene?.player = player
        self.view?.presentScene(scene!, transition:reveal)
    }
}
