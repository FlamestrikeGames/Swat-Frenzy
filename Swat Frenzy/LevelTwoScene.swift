//
//  LevelTwoScene.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 10/12/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import SpriteKit

class LevelTwoScene: BaseScene {
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)

        currentLevel = 2
        enemiesToKill = 20
        enemiesLeft?.text = String(enemiesToKill!)
        
        // Let user get ready for level to start
        run(SKAction.wait(forDuration: 3.0), completion: {
            // Spawn enemies
            self.run(SKAction.repeat(
                SKAction.sequence([
                    SKAction.run({
                        let enemy = Fly()
                        self.playAudio(fileName: enemy.soundEffectFile, audioPlayer: 1, volume: 1.0)
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
