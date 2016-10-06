//
//  GameScene.swift
//  Swarm Frenzy
//
//  Created by Eddie Chou on 10/5/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    // 1
    // 1 - Create the sprite
    //let player = SKSpriteNode(imageNamed:"spacemonkey_fly02")
    
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    
    func spawnEnemy() {
        // 2
        let enemy = SKSpriteNode(imageNamed: "fly")
        // 3
        enemy.name = "fly"
        // 4
        enemy.position = CGPoint(x: frame.size.width/2, y: frame.size.height * random(min: 0, max: 1))
        // 5
        addChild(enemy)
    }
}
