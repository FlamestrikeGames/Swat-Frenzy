//
//  Enemy.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 10/16/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import SpriteKit
//import AVFoundation

class Enemy: SKSpriteNode {
    
    var damage: Double = 1.0
    var stunDuration: Double = 1.0
    var aliveDuration: Double = 1.0
    var soundEffectFile: String = "coin.wav"
    
    init(image: String) {
        let texture = SKTexture(imageNamed: image)
        super.init(texture: texture, color: .clear, size: texture.size())
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createCircleTimer() {
        let circle = SKShapeNode(circleOfRadius: size.width / 2 + 5)
        circle.fillColor = .clear
        circle.strokeColor = .green
        addChild(circle)
        
        circle.run(SKAction.sequence([
            SKAction.wait(forDuration: self.aliveDuration / 3.0),
            SKAction.run({circle.strokeColor = .yellow}),
            SKAction.wait(forDuration: self.aliveDuration / 3.0),
            SKAction.run({circle.strokeColor = .red})
            ])
        )
    }
    
    func beginMovement(vcFrameSize: CGSize) {
        run(
            SKAction.move(to: CGPoint(x: BaseScene.sharedInstance().random(min: size.width, max: vcFrameSize.width - size.width),
                                      y: BaseScene.sharedInstance().random(min: size.height * 2,
                                                max: vcFrameSize.height - (size.height * 2))),
                          duration: TimeInterval(BaseScene.sharedInstance().random(min: 1, max: 3))),
            withKey: "move"
        )
    }
    
    func dropCoin() {
        // Create sprite at location
        let coin = SKSpriteNode(imageNamed: "coin")
        coin.position = CGPoint(x: self.position.x, y: self.position.y - 20)
        coin.xScale = 0.3
        coin.yScale = 0.3
        
        coin.physicsBody = SKPhysicsBody(circleOfRadius: coin.frame.size.width / 2)
        coin.physicsBody?.affectedByGravity = true
        coin.physicsBody?.isDynamic = true
        coin.physicsBody?.categoryBitMask = 0
        coin.physicsBody?.contactTestBitMask = 0
        coin.physicsBody?.collisionBitMask = 0
        coin.physicsBody?.friction = 0
        
        parent?.addChild(coin)
        
        // Play coin sound
        run(SKAction.playSoundFileNamed("coin.wav", waitForCompletion: false))
        
        // Coin drops to ground (from gravity)
        coin.run(SKAction.wait(forDuration: 1.0), completion: {
            coin.removeFromParent()
            }
        )
    }
    
    func playEnemySound() {
        let enemySound = SKAudioNode(fileNamed: self.soundEffectFile)
        enemySound.autoplayLooped = false
        addChild(enemySound)
        enemySound.run(SKAction.play())
    }
}
