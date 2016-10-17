//
//  LevelFiveScene.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 10/16/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import SpriteKit

class LevelFiveScene: BaseScene {
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        currentLevel = 5
        enemiesToKill = 25
        enemiesLeft?.text = String(enemiesToKill!)
        
        // Spawn enemies
        run(SKAction.repeat(
            SKAction.sequence([
                SKAction.wait(forDuration: 2.0),
                SKAction.run({
                    let enemy = Bee()
                    self.playAudio(fileName: "bumblebee.m4a", audioPlayer: 1, volume: 1.0)
                    self.spawnEnemy(enemy: enemy)
                }),
                SKAction.wait(forDuration: 2.0),
                SKAction.run({
                    let enemy = Fly()
                    self.playAudio(fileName: "mosquito.wav", audioPlayer: 1, volume: 1.0)
                    self.spawnEnemy(enemy: enemy)
                })
                ]),
            count: enemiesToKill! + 10
            )
        )
    }
    
}
