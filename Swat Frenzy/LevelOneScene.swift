//
//  LevelOneScene.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 10/12/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import SpriteKit

class LevelOneScene: BaseScene {
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        currentLevel = 1
        enemiesToKill = 10
        enemiesLeft?.text = String(enemiesToKill!)
        
        // Spawn enemies
        run(SKAction.repeat(
            SKAction.sequence([
                SKAction.wait(forDuration: 2.5),
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
