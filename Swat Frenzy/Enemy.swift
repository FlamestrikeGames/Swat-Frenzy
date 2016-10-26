//
//  Enemy.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 10/16/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import SpriteKit

class Enemy: SKSpriteNode {
    
    var damage: Double = 1.0
    var stunDuration: Double = 1.0
    var aliveDuration: Double = 1.0
    var soundEffectFile: String = "coin.wav"
    var goldValue: Int = 1
    
    struct PhysicsCategory {
        static let None      : UInt32 = 0
        static let All       : UInt32 = UInt32.max
        static let Enemy     : UInt32 = 0b1       // 1
        static let Weapon    : UInt32 = 0b10      // 2
        static let Board     : UInt32 = 0b100     // 3
    }
    
    init(image: String) {
        let texture = SKTexture(imageNamed: image)
        super.init(texture: texture, color: .clear, size: texture.size())
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func playEnemySound() {
        let enemySound = SKAudioNode(fileNamed: soundEffectFile)
        enemySound.autoplayLooped = false
        addChild(enemySound)
        enemySound.run(SKAction.play())
    }
    
    func getSpawnPosition(vcFrameSize: CGSize) -> CGPoint {
        var x = (vcFrameSize.width - (size.width * 3/2)) * BaseScene.sharedInstance().random(min: 0, max: 1)
        var y = (frame.size.height - (size.height * 3/2) - 25) * BaseScene.sharedInstance().random(min: 0, max: 1)
        
        if x < (size.width * 3/2) {
            x += size.width * 3/2
        }
        if y < (size.height * 3/2) {
            y += size.height * 3/2
        }
        
        return CGPoint(x: x, y:y)
    }
    
    func createCircleTimer() {
        let circle = SKShapeNode(circleOfRadius: size.width / 2 + 5)
        circle.fillColor = .clear
        circle.strokeColor = .green
        addChild(circle)
        
        circle.run(SKAction.sequence([
            SKAction.wait(forDuration: aliveDuration / 3.0),
            SKAction.run({circle.strokeColor = .yellow}),
            SKAction.wait(forDuration: aliveDuration / 3.0),
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
        coin.position = CGPoint(x: position.x, y: position.y - 20)
        coin.xScale = 0.3
        coin.yScale = 0.3
        
        coin.physicsBody = SKPhysicsBody(circleOfRadius: coin.frame.size.width / 2)
        coin.physicsBody?.affectedByGravity = true
        coin.physicsBody?.isDynamic = true
        coin.physicsBody?.categoryBitMask = PhysicsCategory.None
        coin.physicsBody?.contactTestBitMask = PhysicsCategory.None
        coin.physicsBody?.collisionBitMask = PhysicsCategory.None
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
    
    func dropHeart() {
        let heart = SKSpriteNode(imageNamed: "heart")
        heart.position = CGPoint(x: position.x, y: position.y + 30)
        heart.xScale = 0.8
        heart.yScale = 0.8
        parent?.addChild(heart)
        
        // Play heal sound
        run(SKAction.playSoundFileNamed("heal.wav", waitForCompletion: false))
        
        // Heart moves up and disappears
        heart.run(SKAction.move(to: CGPoint(x: position.x, y: position.y + 80), duration: 0.5), completion: {
            heart.removeFromParent()
            }
        )
    }

}
