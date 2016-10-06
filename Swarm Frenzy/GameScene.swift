//
//  GameScene.swift
//  Swarm Frenzy
//
//  Created by Eddie Chou on 10/5/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    // triggers once we move into the game scene
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        
        // runs this action forever
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(spawnEnemy),
                SKAction.wait(forDuration: 6.0)])))
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    // Spawns an enemy
    func spawnEnemy() {
        
        let enemy = SKSpriteNode(imageNamed: "fly")
        enemy.name = "fly"
        enemy.position = CGPoint(x: frame.size.width * random(min: 0, max: 1), y: frame.size.height * random(min: 0, max: 1))
        
        addChild(enemy)
        // Enemy flies toward player.
        enemy.run(
            SKAction.scale(by: 15, duration: 4)
        )
        
        enemy.run(
            SKAction.move(to: CGPoint(x: frame.size.width/2, y: frame.size.height/2), duration: 4)
        )
    }
}
