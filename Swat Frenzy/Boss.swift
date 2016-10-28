//
//  Boss.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 10/27/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import UIKit
import AVFoundation

class Boss: Enemy {
    
    init() {
        super.init(image: "boss")
        
        name = "boss"
        damage = 5.0
        stunDuration = 0.0
        aliveDuration = 60.0
        soundEffectFile = "wasp.wav"
        goldValue = 50
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func getSpawnPosition(vcFrameSize: CGSize) -> CGPoint {
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
}
