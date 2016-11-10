//
//  Enemy.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 10/16/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import SpriteKit
import AVFoundation

class Enemy: SKSpriteNode {
    
    var damage: Double = 1.0
    var stunDuration: Double = 1.0
    var aliveDuration: Double = 1.0
    var soundEffectFile: String = "coin.wav"
    var goldValue: Int = 1
    var enemySoundPlayer: AVAudioPlayer!
    var enemyAnimationFrames: [SKTexture]!
    
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
    
    func initializeAtlas(enemyName: String) {
        let enemyAtlas = SKTextureAtlas(named: enemyName)
        var enemyFrames = [SKTexture]()
        
        let numImages = enemyAtlas.textureNames.count
        for i in 1...numImages/3{
            let enemyTextureName = enemyName + String(i)
            enemyFrames.append(enemyAtlas.textureNamed(enemyTextureName))
        }
        enemyAnimationFrames = enemyFrames
    }

    func playEnemySound() {
        let path = Bundle.main.path(forResource: soundEffectFile, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            let sound = try AVAudioPlayer(contentsOf: url)
            enemySoundPlayer = sound
            startEnemySound()
        } catch {
            // couldn't load file :(
        }
    }
  
    func startEnemySound() {
        enemySoundPlayer.play()
    }
    
    func pauseEnemySound() {
        if(enemySoundPlayer.isPlaying) {
            enemySoundPlayer.pause()
        }
    }
    
    func getSpawnPosition(vcFrameSize: CGSize) -> CGPoint {
        var x = (vcFrameSize.width - (size.width * 3/2)) * BaseScene.sharedInstance().random(min: 0, max: 1)
        var y = (vcFrameSize.height - (size.height * 3/2) - 25) * BaseScene.sharedInstance().random(min: 0, max: 1)
        
        if x < (size.width * 3/2) {
            x += size.width * 3/2
        }
        if y < (size.height * 3/2) {
            y += size.height * 3/2
        }
        
        return CGPoint(x: x, y:y)
    }
    
    func createCircleTimer() {
        let circle = SKShapeNode(circleOfRadius: size.width / 2)
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
        let x = BaseScene.sharedInstance().random(min: size.width, max: vcFrameSize.width - size.width)
        let y = BaseScene.sharedInstance().random(min: size.height * 2, max: vcFrameSize.height - (size.height * 2))
        
        // change direction if moving left
        if x < self.position.x {
            self.xScale *= -1
        }
        run(
            SKAction.move(to: CGPoint(x: x, y: y),
                          duration: TimeInterval(BaseScene.sharedInstance().random(min: 1, max: 3))),
            withKey: "move"
        )
    }
    
    func animateEnemy() {
        run(SKAction.repeatForever(SKAction.animate(with: enemyAnimationFrames, timePerFrame: 0.25, resize: false, restore: true)), withKey: "animateEnemy")
    }
    
    
    func dropCoin() {
        // Create sprite at location
        let coin = SKSpriteNode(imageNamed: "coin")
        coin.position = CGPoint(x: position.x, y: position.y - 20)
        coin.xScale = 1.25
        coin.yScale = 1.25
        
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
        heart.xScale = 1.25
        heart.yScale = 1.25
        heart.zPosition = 5
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
