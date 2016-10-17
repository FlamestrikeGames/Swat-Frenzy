//
//  LevelThreeScene.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 10/12/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import SpriteKit

class LevelThreeScene: BaseScene {
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        currentLevel = 3
        enemiesToKill = 15
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
