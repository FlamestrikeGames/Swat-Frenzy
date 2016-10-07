//
//  GameScene.swift
//  Swat Frenzy
//
//  Created by Eddie Chou on 10/5/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var remainingHealth: SKLabelNode?
    var loseMessage: SKLabelNode?
    
    // This optional variable will help us to easily access our weapon
    var weapon: SWBlade?
    
    // This will help us to update the position of the blade
    // Set the initial value to 0
    var weaponPosition = CGPoint.zero
    var isWeaponDisplayed = false;
   
    // Triggers once we move into the game scene
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black

        initializeUI()
      
        // Runs this action forever
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(spawnEnemy),
                SKAction.wait(forDuration: 3.0)])))
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func initializeUI() {
        // Makes sure that the node is found and is not null
        if let currentHealth = childNode(withName: "remainingHealth") as? SKLabelNode {
            remainingHealth = currentHealth
        }
        if let message = childNode(withName: "loseMessage") as? SKLabelNode {
            loseMessage = message
        }
    }
    
    // Spawns an enemy
    func spawnEnemy() {
        
        let enemy = SKSpriteNode(imageNamed: "fly")
        enemy.name = "fly"
        
        // Spawns enemy within the screen
        var x = (frame.size.width - (enemy.size.width * 3/2)) * random(min: 0, max: 1)
        var y = (frame.size.height - (enemy.size.height * 3/2)) * random(min: 0, max: 1)
        
        if x < (enemy.size.width * 3/2) {
            x += enemy.size.width * 3/2
        }
        if y < (enemy.size.height * 3/2) {
            y += enemy.size.height * 3/2
        }
        enemy.position = CGPoint(x: x, y: y)
        addChild(enemy)
        
        // Enemy flies toward player.
        enemy.run(SKAction.scale(by: 4, duration: 2), completion: {
            // Despawn enemy and take damage
            enemy.removeFromParent()
            self.takeDamage(amount:50)
        })
 /*
        enemy.run(
            SKAction.move(to: CGPoint(x: frame.size.width/2, y: frame.size.height/2), duration: 4)
        )
 */
    }
    
    func takeDamage(amount: Int) {
        let newHealth: Int = Int(self.remainingHealth!.text!)! - amount
        self.remainingHealth?.text = String(newHealth)
        // Check if player lost
        if(newHealth <= 0) {
            // Player loses!
            self.removeAllActions()
            loseMessage?.isHidden = false
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        /* For weapon animation. */
        let firstTouch = touches.first! as UITouch
        let touchLocation = firstTouch.location(in: self)
        weaponPosition = touchLocation
        presentWeaponAtPosition(position: weaponLocation)
        
        for touch: AnyObject in touches {
            
            let touchLocation = touch.location(in: self)
            let touchedNode = self.atPoint(touchLocation)
            
            if(touchedNode.name == "fly") {
                touchedNode.removeFromParent()
            }
        }
    }
    
    // For swipes
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Update weapon position
        let firstTouch = touches.first! as UITouch
        weaponPosition = firstTouch.location(in: self)
        
        
        // To kill enemies enemies
        // To-do: May have to check type of child.
        let touch = touches.first! as UITouch
        let location = touch.location(in: self)
        
        for node : SKNode in children {
            if let enemy = node as? SKSpriteNode {
                if enemy.frame.contains(location) {
                    enemy.removeFromParent()
                }
            }
        }
    }
    
    // Initializes weapon at touch location
    func presentWeaponAtPosition(position: CGPoint) {
        weapon = SWBlade(position: position, target: self, color: UIColor.red)
        self.addChild(weapon!)
        isWeaponDisplayed = true
    }
    
    // This will help us to remove our blade and reset the delta value
    func removeWeapon() {
        isWeaponDisplayed = false
        weapon!.removeFromParent()
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
    
    
}
