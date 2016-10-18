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
        
        // Let user get ready for level to start
        run(SKAction.wait(forDuration: 3.0), completion: {
            // Spawn enemies
            self.run(SKAction.repeat(
                SKAction.sequence([
                    SKAction.run({
                        let enemy = Bee()
                        self.playAudio(fileName: "bumblebee.m4a", audioPlayer: 1, volume: 1.0)
                        self.spawnEnemy(enemy: enemy)
                    }),
                    SKAction.wait(forDuration: 1.5)
                    ]),
                count: self.enemiesToKill! + 10
                )
            )
        })
    }
    
}
