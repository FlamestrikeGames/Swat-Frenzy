//
//  EndlessScene.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 1/3/17.
//  Copyright © 2017 FlamestrikeGames. All rights reserved.
//

import SpriteKit

class EndlessScene: BaseScene {
    
    var timer: Timer?
    var scoreTime: Int = 0

    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        initializeBackground(withName: "bossBackground", withAlpha: 1.0)
 
        objective?.text = "Survive as long as possible!"
        
        currentLevel = 10
        enemiesToKill = 0
        enemiesLeft?.text = "Time: " + String(scoreTime)
        enemySprite?.alpha = 0
        
        gameLayer.run(SKAction.wait(forDuration: 3.0), completion: {
            // Spawn enemies
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(EndlessScene.increaseTimer), userInfo: nil, repeats: true)
            self.gameLayer.run(SKAction.repeatForever(
                
                SKAction.sequence([
                    SKAction.run({
                        self.spawnRandomEnemy()
                    }),
                    SKAction.wait(forDuration: 1.0),
                    SKAction.run({
                        self.spawnRandomEnemy()
                    }),
                    SKAction.wait(forDuration: 1.0)
                    ])
                )
            )
        })
    }
    
    func increaseTimer() {
        scoreTime += 1
        enemiesLeft?.text = "Time: " + String(scoreTime)
    }
    
    func spawnRandomEnemy(){
        let randNum = arc4random_uniform(6)
        var enemy: Enemy
        switch(randNum) {
        case 0: enemy = Fly()
        case 1: enemy = Bee()
        case 2: enemy = Mosquito()
        case 3: enemy = Spider()
        case 4: enemy = Snake()
        case 5: enemy = Wasp()
        default: enemy = Fly()
            break
        }
        
        enemy.playEnemySound()
        self.spawnEnemy(enemy: enemy)
    }
    
    override func killEnemy(enemy: SKSpriteNode) {
        enemy.removeAllActions()
        enemy.removeAllChildren()
        enemy.removeFromParent()
    }
    
    override func showPauseMenu() {
        super.showPauseMenu()
        timer?.invalidate()
    }
    
    override func removePauseMenu() {
        super.removePauseMenu()
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(EndlessScene.increaseTimer), userInfo: nil, repeats: true)

    }
}
