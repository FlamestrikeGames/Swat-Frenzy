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
        enemy.run(SKAction.scale(by: 3, duration: 2), completion: {
            // Despawn enemy and take damage
            enemy.removeFromParent()
            self.takeDamage(amount:10)
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
        for touch: AnyObject in touches {
            
            let touchLocation = touch.location(in: self)
            let touchedNode = self.atPoint(touchLocation)
            
            if(touchedNode.name == "fly") {
                touchedNode.removeFromParent()
            }
        }
    }
    
    
}
