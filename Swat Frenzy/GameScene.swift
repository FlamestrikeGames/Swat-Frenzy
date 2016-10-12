//
//  GameScene.swift
//  Swat Frenzy
//
//  Created by Eddie Chou on 10/5/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    /* INITIALIZATION */
    var currentHealth = 100
    var enemiesLeft: SKLabelNode?
    var healthBar: SKSpriteNode?
    var healthBaseWidth: CGFloat?
    
    var enemiesToKill = 10
    var enemyDamage = 10
    
    // This optional variable will help us to easily access our weapon
    var weapon: SWBlade?
    
    // This will help us to update the position of the blade
    // Set the initial value to 0
    var weaponPosition = CGPoint.zero
    var weaponStartPosition = CGPoint.zero
    var isWeaponDisplayed = false
    var weaponPhysicsEnabled = false
   
    var backgroundSoundFX: AVAudioPlayer!
    var mosquitoSoundFX: AVAudioPlayer!
    var hitSoundFX: AVAudioPlayer!
    
    struct PhysicsCategory {
        static let None      : UInt32 = 0
        static let All       : UInt32 = UInt32.max
        static let Enemy     : UInt32 = 0b1       // 1
        static let Weapon    : UInt32 = 0b10      // 2
    }

    /* GAME LOGIC */
    
    // Triggers once we move into the game scene
    override func didMove(to view: SKView) {
        initializeUI()
        
        // Runs this action forever
        run(SKAction.repeat(
            SKAction.sequence([
                SKAction.wait(forDuration: 2.0),
                SKAction.run(spawnEnemy)
                ]), count: enemiesToKill + (100/enemyDamage)))
    }
    
    func initializeUI() {
        backgroundColor = SKColor.black
        
        // Play background music
        playAudio(fileName: "background.wav", audioPlayer: 3, volume: 0.25)

        
        // Initialize physics
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        // Makes sure that the node is found and is not null
        if let enemies = childNode(withName: "enemiesLeft") as? SKLabelNode {
            enemiesLeft = enemies
            enemiesLeft?.text = String(enemiesToKill)
        }
        
        if let health = childNode(withName: "healthBar") as? SKSpriteNode {
            healthBar = health
            healthBaseWidth = health.frame.size.width
        }
    }
    
    // Spawns an enemy
    func spawnEnemy() {
        let enemy = SKSpriteNode(imageNamed: "fly")
        enemy.name = "fly"
        
        // Initialize enemy physics body
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.frame.size)
        enemy.physicsBody?.isDynamic = true
        enemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        enemy.physicsBody?.contactTestBitMask = PhysicsCategory.Weapon
        enemy.physicsBody?.collisionBitMask = PhysicsCategory.None
        
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
        
        // Enemy flies toward player
        enemy.run(SKAction.scale(by: 2, duration: 3.0), completion: {
            // Despawn enemy and take damage if action completes
            if(enemy.position.x <= 0 || enemy.position.y <= 0 ||
                enemy.position.x >= self.frame.size.width || enemy.position.y >= self.frame.size.height) {
                self.killEnemy(enemy: enemy)
            } else {
                enemy.removeFromParent()
                self.takeDamage(amount: self.enemyDamage)
                self.takeHit(enemy: enemy)
            }

        })
        
        playAudio(fileName: "mosquito.wav", audioPlayer: 1, volume: 1.0)
        
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
        self.enemiesToKill -= 1
        self.enemiesLeft?.text = String(self.enemiesToKill)
        if(self.enemiesToKill == 0) {
            // You Win!
            self.gameOver(won: true)
        }

    }
    
    func takeDamage(amount: Int) {
        // Play whack sound
        playAudio(fileName: "whack.wav", audioPlayer: 2, volume: 0.3)
        currentHealth = currentHealth - amount
        let newWidth = (healthBaseWidth! * CGFloat(Float(currentHealth) / 100.0))
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
        if(currentHealth <= 0) {
            // Player loses!
            gameOver(won: false)
        }
    }
    
    func takeHit(enemy: SKSpriteNode) {
        // display bloodSplat
        let takeHit = SKSpriteNode(color: .red, size: frame.size)
        takeHit.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        takeHit.alpha = 0.5
        addChild(takeHit)
        takeHit.run(
            SKAction.fadeOut(withDuration: 0.2)
        )
    }
    
    func gameOver(won: Bool) {
        mosquitoSoundFX.stop()
        backgroundSoundFX.stop()
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        let gameOverScene = GameOverScene(size: self.size, won: won)
        self.view?.presentScene(gameOverScene, transition: reveal)
    }

    // MARK: Physics
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Enemy != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Weapon != 0)) {
            // Make sure the node can be passed as a SWBlade
            if let body1 = firstBody.node as? SWBlade {
                weaponDidCollideWithEnemy(weapon: body1, enemy: secondBody.node as! SKSpriteNode)
            } else {
                weaponDidCollideWithEnemy(weapon: secondBody.node as! SWBlade, enemy: firstBody.node as! SKSpriteNode)
            }
        }
    }
    
    func weaponDidCollideWithEnemy(weapon:SWBlade, enemy:SKSpriteNode) {
        // Remove move action from enemy
        enemy.removeAction(forKey: "move")
        
        // Play slap sound
        playAudio(fileName: "slap.wav", audioPlayer: 2, volume: 0.3)

        
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
        enemy.run(SKAction.scale(by: 1, duration: 0.25), completion: {
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
            case 1: mosquitoSoundFX = sound
            case 2: hitSoundFX = sound
            case 3: backgroundSoundFX = sound
                    backgroundSoundFX.numberOfLoops = -1
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
