//
//  Boss.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 10/27/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import UIKit
import AVFoundation
import SpriteKit

class Boss: Enemy {
    
    var currentHealth: Int = 10000
    
    init() {
        super.init(image: "boss")
        initializeAtlas(enemyName: "Boss")
        
        name = "boss"
        damage = 2.0
        stunDuration = 0.0
        aliveDuration = 300.0
        soundEffectFile = "wasp.wav"
        goldValue = 750
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func getSpawnPosition(vcFrameSize: CGSize, uiHeight: CGFloat) -> CGPoint {
        let x = (vcFrameSize.width / 2)
        let y = (vcFrameSize.height / 2)
        return CGPoint(x: x, y:y)
    }
    
    override func playEnemySound() {
        let path = Bundle.main.path(forResource: soundEffectFile, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            let sound = try AVAudioPlayer(contentsOf: url)
            enemySoundPlayer = sound
            enemySoundPlayer.numberOfLoops = -1
            startEnemySound()
            enemySoundPlayer.volume = 0.5
            
        } catch {
            // couldn't load file :(
        }
    }
    
    func takeDamage(amount: Int) {
        currentHealth -= amount
    }
    
    override func createCircleTimer() {
        let circle = SKShapeNode(circleOfRadius: size.height / 2 - 10)
        circle.fillColor = .clear
        circle.strokeColor = .green
        addChild(circle)
        
        circle.run(SKAction.repeatForever(
            SKAction.sequence([
            SKAction.wait(forDuration: 0.25),
            SKAction.run({circle.strokeColor = .yellow}),
            SKAction.wait(forDuration: 0.25),
            SKAction.run({circle.strokeColor = .red}),
            SKAction.wait(forDuration: 0.25),
            SKAction.run({circle.strokeColor = .green})
            ])
            )
        )
    }
    
    override func animateEnemy() {
        run(SKAction.repeatForever(SKAction.animate(with: enemyAnimationFrames, timePerFrame: 0.1875, resize: false, restore: true)), withKey: "animateEnemy")
    }
}
