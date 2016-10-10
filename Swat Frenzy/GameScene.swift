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
    var remainingHealth: SKLabelNode?
    var enemiesLeft: SKLabelNode?
    
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
   
    var mosquitoSoundFX: AVAudioPlayer!
    
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
        
        // Initialize physics
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        // Makes sure that the node is found and is not null
        if let currentHealth = childNode(withName: "remainingHealth") as? SKLabelNode {
            remainingHealth = currentHealth
        }

        if let enemies = childNode(withName: "enemiesLeft") as? SKLabelNode {
            enemiesLeft = enemies
            enemiesLeft?.text = String(enemiesToKill)
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
        var y = (frame.size.height - (enemy.size.height * 3/2) - (remainingHealth?.frame.size.height)!) * random(min: 0, max: 1)
        
        if x < (enemy.size.width * 3/2) {
            x += enemy.size.width * 3/2
        }
        if y < (enemy.size.height * 3/2) {
            y += enemy.size.height * 3/2
        }
        enemy.position = CGPoint(x: x, y: y)
        addChild(enemy)
        
        // Enemy flies toward player
        enemy.run(SKAction.scale(by: 4, duration: 3.0), completion: {
            // Despawn enemy and take damage if action completes
            enemy.removeFromParent()
            self.takeDamage(amount: self.enemyDamage)
        })
        playMosquito()
 /*
        enemy.run(
            SKAction.move(to: CGPoint(x: frame.size.width/2, y: frame.size.height/2), duration: 4)
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

    
    func takeDamage(amount: Int) {
        let newHealth: Int = Int(self.remainingHealth!.text!)! - amount
        self.remainingHealth?.text = String(newHealth)
        // Check if player lost
        if(newHealth <= 0) {
            // Player loses!
            gameOver(won: false)
        }
    }
    
    func gameOver(won: Bool) {
        mosquitoSoundFX.stop()
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
                enemy.position.x >= self.frame.size.width || enemy.position.y >= self.frame.size.height){
                enemy.removeFromParent()
                self.enemiesToKill -= 1
                self.enemiesLeft?.text = String(self.enemiesToKill)
                if(self.enemiesToKill == 0) {
                    // You Win!
                    self.gameOver(won: true)
                }
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
    func playMosquito() {
        let path = Bundle.main.path(forResource: "mosquito.wav", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            let sound = try AVAudioPlayer(contentsOf: url)
            mosquitoSoundFX = sound
            sound.play()
        } catch {
            // couldn't load file :(
        }
    }
    
    
}
