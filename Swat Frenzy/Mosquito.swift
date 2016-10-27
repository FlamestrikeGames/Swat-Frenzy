//
//  Mosquito.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 10/21/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import UIKit
import AVFoundation

class Mosquito: Enemy {
    
    init() {
        super.init(image: "mosquito")
        
        name = "mosquito"
        damage = 20.0
        stunDuration = 0.25
        aliveDuration = 3.5
        soundEffectFile = "mosquito.wav"
        goldValue = 3
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func playEnemySound() {
        let path = Bundle.main.path(forResource: soundEffectFile, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            let sound = try AVAudioPlayer(contentsOf: url)
            enemySoundPlayer = sound
            startEnemySound()
            enemySoundPlayer.volume = 0.1

        } catch {
            // couldn't load file :(
        }
    }
}
