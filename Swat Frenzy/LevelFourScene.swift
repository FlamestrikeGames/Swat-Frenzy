//
//  LevelFourScene.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 10/16/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import SpriteKit

class LevelFourScene: BaseScene {
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
      
        currentLevel = 4
        enemiesToKill = 20
        enemiesLeft?.text = String(enemiesToKill!)
        
        // Spawn enemies
        run(SKAction.repeat(
            SKAction.sequence([
                SKAction.wait(forDuration: 2.5),
                SKAction.run({
                    let enemy = Bee()
                    self.playAudio(fileName: "bumblebee.m4a", audioPlayer: 1, volume: 1.0)
                    self.spawnEnemy(enemy: enemy)
                })
                ]),
            count: enemiesToKill! + 10
            )
        )
    }
    
}
