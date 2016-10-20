//
//  BaseScene.swift
//  Swat Frenzy
//
//  Created by Eddie Chou on 10/5/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import SpriteKit
import AVFoundation

class BaseScene: SKScene, SKPhysicsContactDelegate {
    /* INITIALIZATION */
    var enemiesLeft: SKLabelNode?
    var healthBar: SKSpriteNode?
    var healthBaseWidth: CGFloat?
    var goldLabel: SKLabelNode?
    
    var enemiesToKill: Int?
    var currentLevel: Int?
    
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
    var enemySoundFX: AVAudioPlayer!
    var hitSoundFX: AVAudioPlayer!
    var coinSoundFX: AVAudioPlayer!
    
    struct PhysicsCategory {
        static let None      : UInt32 = 0
        static let All       : UInt32 = UInt32.max
        static let Enemy     : UInt32 = 0b1       // 1
        static let Weapon    : UInt32 = 0b10      // 2
        static let Board     : UInt32 = 0b100     // 3
    }
    

    /* GAME LOGIC */
    
    // Triggers once we move into the game scene
    override func didMove(to view: SKView) {
        initializePlayer()
        initializeBackground()
        initializeMusic()
        initializeUI()
    }
    
    func initializePlayer() {
        var gold: Int
        // Retrieve from userDefaults
        let userDef = UserDefaults.standard
        
        if let currentGold = userDef.value(forKey: "goldAmount") {
            gold = currentGold as! Int
        } else {
            gold = 0
        }
        player = Player(goldAmount: gold)
    }
    
    func initializeBackground() {
        let background = SKSpriteNode(imageNamed: "background")
        let aspectRatio = background.frame.size.width / background.frame.size.height
        background.size = CGSize(width: self.frame.size.width, height: self.frame.size.width / aspectRatio)
        background.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        background.zPosition = -200
        addChild(background)
    }
    
    func initializeMusic() {
        // Play background music
        playAudio(fileName: "background.wav", audioPlayer: 3, volume: 0.25)
    }
    
    func initializeUI() {
        // Initialize physics
        //physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        // Makes sure that the node is found and is not null
        if let enemies = childNode(withName: "enemiesLeft") as? SKLabelNode {
            enemiesLeft = enemies
            //enemiesLeft?.text = String(enemiesToKill!)
        }
        
        if let health = childNode(withName: "healthBar") as? SKSpriteNode {
            healthBar = health
            healthBaseWidth = health.frame.size.width
        }
        
        if let gold = childNode(withName: "goldAmount") as? SKLabelNode {
            goldLabel = gold
            goldLabel?.text = String(player.goldAmount)
        }
    }
    
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
        var x = (frame.size.width - (enemy.size.width * 3/2)) * random(min: 0, max: 1)
        var y = (frame.size.height - (enemy.size.height * 3/2) - (enemiesLeft?.frame.size.height)!) * random(min: 0, max: 1)
        
        if x < (enemy.size.width * 3/2) {
            x += enemy.size.width * 3/2
        }
        if y < (enemy.size.height * 3/2) {
            y += enemy.size.height * 3/2
        }
        enemy.position = CGPoint(x: x, y: y)
        addChild(enemy)
        
        // Spawn attack timer circle
        let circle = SKShapeNode(circleOfRadius: enemy.size.width / 2 + 5)
        circle.fillColor = .clear
        circle.strokeColor = .green
        enemy.addChild(circle)
    
        circle.run(SKAction.sequence([
                SKAction.wait(forDuration: enemy.aliveDuration / 3.0),
                SKAction.run({circle.strokeColor = .yellow}),
                SKAction.wait(forDuration: enemy.aliveDuration / 3.0),
                SKAction.run({circle.strokeColor = .red})
                ])
        )
        
        // Enemy flies toward player
        enemy.run(SKAction.scale(by: 2, duration: enemy.aliveDuration), completion: {
            // Despawn enemy and take damage if action completes
            if(enemy.position.x <= 0 || enemy.position.y <= 0 ||
                enemy.position.x >= self.frame.size.width || enemy.position.y >= self.frame.size.height) {
                self.killEnemy(enemy: enemy)
            } else {
                enemy.removeFromParent()
                self.takeDamage(amount: Int(enemy.damage))
                self.takeHit()
            }

        })
        
        enemy.run(
            SKAction.move(to: CGPoint(x: random(min: enemy.size.width, max: frame.size.width - enemy.size.width),
                                      y: random(min: enemy.size.height * 2,
                                                max: frame.size.height - (enemy.size.height * 2))),
                          duration: TimeInterval(random(min: 1, max: 3))),
            withKey: "move"
        )
 
        /*
        let path = UIBezierPath()
        path.move(to: enemy.position)
        path.addArc(withCenter: enemy.position, radius: 30, startAngle: 90, endAngle: 180, clockwise: true)
        enemy.run(
            SKAction.follow(path.cgPath, duration: 3)
         //   SKAction.follow(path: path.cgPath, duration: TimeInterval(2)))

        )
 */
    }
    
    /* HELPER FUNCTIONS */
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }

    func killEnemy(enemy: SKSpriteNode) {
        enemy.removeAllActions()
        enemy.removeFromParent()
        enemiesToKill! -= 1
        enemiesLeft?.text = String(enemiesToKill!)
        if(enemiesToKill! == 0) {
            // You Win!
            self.gameOver(won: true)
        }

    }
    
    func takeDamage(amount: Int) {
        // Play whack sound
        playAudio(fileName: "whack.wav", audioPlayer: 2, volume: 0.3)
        player.currentHealth = player.currentHealth - amount
        let newWidth = (healthBaseWidth! * CGFloat(Float(player.currentHealth) / 100.0))
        healthBar?.run(
            SKAction.resize(toWidth: newWidth, duration: 0.25), completion: {
                if( newWidth <= self.healthBaseWidth! * 0.33) {
                    self.healthBar?.color = .red
                } else if newWidth <= self.healthBaseWidth! * 0.66 {
                    self.healthBar?.color = .yellow
                }
            }
        )
        
        // Check if player lost
        if(player.currentHealth <= 0) {
            // Player loses!
            gameOver(won: false)
        }
    }
    
    func takeHit() {
        // display red screen
        let takeHit = SKSpriteNode(color: .red, size: frame.size)
        takeHit.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        takeHit.alpha = 0.5
        addChild(takeHit)
        
        takeHit.run(
            SKAction.wait(forDuration: 0.10), completion: {
                takeHit.removeFromParent()
            }
        )
 
    }
    
    func dropCoin(location: CGPoint) {
        // Create sprite at location
        let coin = SKSpriteNode(imageNamed: "coin")
        coin.position = CGPoint(x: location.x, y: location.y - 20)
        coin.xScale = 0.3
        coin.yScale = 0.3
        
        coin.physicsBody = SKPhysicsBody(circleOfRadius: coin.frame.size.width / 2)
        coin.physicsBody?.affectedByGravity = true
        coin.physicsBody?.isDynamic = true
        coin.physicsBody?.categoryBitMask = PhysicsCategory.None
        coin.physicsBody?.contactTestBitMask = PhysicsCategory.None
        coin.physicsBody?.collisionBitMask = PhysicsCategory.None
        coin.physicsBody?.friction = 0
        addChild(coin)
        
        // Play coin sound
        playAudio(fileName: "coin.wav", audioPlayer: 4, volume: 0.5)
        
        // Increase gold amount
        player.goldAmount += 1
        goldLabel?.text = String(player.goldAmount)
        
        // Coin drops to ground (from gravity)
        coin.run(SKAction.wait(forDuration: 1.0), completion: {
            coin.removeFromParent()
            }
        )
    }
    
    func gameOver(won: Bool) {
        enemySoundFX.stop()
        backgroundSoundFX.stop()
        // Save gold to user defaults if player won
        if (won) {
            let userDef = UserDefaults.standard
            userDef.set(player.goldAmount, forKey: "goldAmount")
            let maxLevel = userDef.value(forKey: "currentLevel") as? Int
            if(maxLevel != nil && maxLevel! < currentLevel!+1) {
                userDef.set(currentLevel!+1, forKey: "currentLevel")
            }
            self.playAudio(fileName: "win.wav", audioPlayer: 1, volume: 0.4)
        } else {
            self.playAudio(fileName: "lose.wav", audioPlayer: 1, volume: 0.4)
        }
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        let gameOverScene = GameOverScene(size: self.size, won: won, level: currentLevel!)
        self.view?.presentScene(gameOverScene, transition: reveal)
    }

    // MARK: Physics
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
            
            // flash the board red
            boardBody.run(SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0.1), completion: {
                boardBody.run(SKAction.colorize(with: .black, colorBlendFactor: 0.0, duration: 0.1))
            })
        }
    }
    
    func weaponDidCollideWithEnemy(weapon:SWBlade, enemy: Enemy) {
        // Remove move action from enemy
        enemy.removeAction(forKey: "move")
        
        // Play slap sound
        playAudio(fileName: "slap.wav", audioPlayer: 2, volume: 0.1)

        
        // Check if it drops a coin
        let coinDropped = random(min: 1, max: 100)
        if coinDropped <= 75 {
            // Drop coin
            dropCoin(location: enemy.position)
        }
        
        // Calculate difference in x, y for direction of move
        enemy.physicsBody?.linearDamping = 1.0
        var dx = (enemy.position.x - weaponStartPosition.x) * 0.5
        var dy = (enemy.position.y - weaponStartPosition.y) * 0.5
        // Limit impulse speeds so it doesn't blast off the screen
        if dx > 50.0 {
            dx = 50.0
        }
        if dy > 50.0 {
            dy = 50.0
        }

        enemy.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
        // Waits 0.25s and then stops the enemy in place and checks if it is off the screen
        enemy.run(SKAction.wait(forDuration: enemy.stunDuration), completion: {
            enemy.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            // If the enemy center is off the screen
            if(enemy.position.x <= 0 || enemy.position.y <= 0 ||
                enemy.position.x >= self.frame.size.width || enemy.position.y >= self.frame.size.height) {
                self.killEnemy(enemy: enemy)
            }
        })
        removeWeapon()
    }
    
    // MARK: Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* For weapon animation. */
        let firstTouch = touches.first! as UITouch
        let touchLocation = firstTouch.location(in: self)
        weaponPosition = touchLocation
        weaponStartPosition = touchLocation
        presentWeaponAtPosition(position: weaponPosition)
    }
    
    // For swipes
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Update weapon position
        let firstTouch = touches.first! as UITouch
        weaponPosition = firstTouch.location(in: self)
        
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
    
    override func update(_ currentTime: CFTimeInterval) {
        // If the weapon is available (When user touches screen)
        if weapon != nil && isWeaponDisplayed {
            // Update the weapon position
            weapon!.position = CGPoint(x: weaponPosition.x, y:weaponPosition.y)
        }
    }
    
    // MARK: Weapon
    // Initializes weapon at touch location
    func presentWeaponAtPosition(position: CGPoint) {
        weapon = SWBlade(position: position, target: self, color: UIColor.red)
        self.addChild(weapon!)
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
    
    // MARK: Audio
    
    func playAudio(fileName: String, audioPlayer: Int, volume: Float) {
        let path = Bundle.main.path(forResource: fileName, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            let sound = try AVAudioPlayer(contentsOf: url)
            switch(audioPlayer) {
            case 1: enemySoundFX = sound
            case 2: hitSoundFX = sound
            case 3: backgroundSoundFX = sound
                    // Repeats on negative number
                    backgroundSoundFX.numberOfLoops = -1
            case 4: coinSoundFX = sound
            default:
                break
            }
            sound.play()
            sound.volume = volume
        } catch {
            // couldn't load file :(
        }
        
    }
    
}
