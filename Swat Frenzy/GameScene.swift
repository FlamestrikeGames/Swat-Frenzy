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
    
    // This optional variable will help us to easily access our blade
    var blade:SWBlade?
    
    // This will help us to update the position of the blade
    // Set the initial value to 0
    var delta = CGPoint.zero
   
    // This will help us to initialize our blade
    func presentBladeAtPosition(position:CGPoint) {
        blade = SWBlade(position: position, target: self, color: UIColor.white)
        self.addChild(blade!)
    }
    
    // This will help us to remove our blade and reset the delta value
    func removeBlade() {
        delta = CGPoint.zero
        blade!.removeFromParent()
    }

    
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
        let any_object = touches.first! as UITouch
        let touchLocation = any_object.location(in: self)
        presentBladeAtPosition(position: touchLocation)
        
        for touch: AnyObject in touches {
            
            let touchLocation = touch.location(in: self)
            let touchedNode = self.atPoint(touchLocation)
            
            if(touchedNode.name == "fly") {
                touchedNode.removeFromParent()
            }
        }
    }
    
    /* Swipes. */
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
//        /* Get deltas for weapon animation. */
//        for touch: UITouch in touches {
//            let any_object = touch as UITouch
//            let currentPoint = any_object.location(in: self)
//            let previousPoint = any_object.previousLocation(in: self)
//            delta = CGPoint(x: currentPoint.x - previousPoint.x, y: currentPoint.y - previousPoint.y)
//        }
        let any_object = touches.first! as UITouch
        delta = any_object.location(in: self)
        
        
        /* Killing enemies. */
        let touch = touches.first! as UITouch
        let location = touch.location(in: self)
        
        for enemy : SKNode in children {
            if enemy.frame.contains(location)
            {
                enemy.removeFromParent()
            }
        }
    }
    
    // Remove the Blade if the touches have been cancelled or ended
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeBlade()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent!) {
        removeBlade()
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        // if the blade is available
        if blade != nil {
            // Here you add the delta value to the blade position
            let newPosition = CGPoint(x: delta.x, y: delta.y)
            // Set the new position
            blade!.position = newPosition
            // it's important to reset delta at this point,
            // You are telling the blade to only update his position when touchesMoved is called
            delta = CGPoint.zero
        }
    }
    
    
}
