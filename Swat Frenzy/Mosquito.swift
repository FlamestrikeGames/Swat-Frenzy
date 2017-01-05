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
        initializeAtlas(enemyName: "Mosquito")
        
        name = "mosquito"
        damage = 10.0
        stunDuration = 0.35
        aliveDuration = 5.0
        soundEffectFile = "mosquito.wav"
        goldValue = 4
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
