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
    var boardTimer: Timer?
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
            // Start timer
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(EndlessScene.increaseTimer), userInfo: nil, repeats: true)
            self.boardTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(EndlessScene.spawnSpinningBoard), userInfo: nil, repeats: true)
            // Spawn enemies
            
            let spawnSequence = SKAction.sequence([
                SKAction.run{
                self.spawnRandomEnemy()
                }, SKAction.wait(forDuration: 1.0)])
            
            self.gameLayer.run(SKAction.repeatForever(
                
                SKAction.sequence([
                    SKAction.repeat(spawnSequence, count: 9),
                    SKAction.run {
                        let enemy = Butterfly()
                        enemy.playEnemySound()
                        self.spawnEnemy(enemy: enemy)
                    }
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
    
    func spawnSpinningBoard() {
        // spawn new board
        let randWidth = random(min: self.frame.size.width / 5, max: self.frame.size.width / 2)
        let randLength = random(min: self.frame.size.width / 30, max: self.frame.size.width / 10)
        
        let randX = random(min: randWidth / 2, max: self.frame.size.width - randWidth / 2)
        let randY = random(min: randWidth / 2, max: self.frame.size.height - self.uiBackground!.frame.size.height - randWidth / 2)
        initializeBoard(location: CGPoint(x: randX, y: randY), randW: randWidth, randL: randLength)
    }
    
    func initializeBoard(location: CGPoint, randW: CGFloat, randL: CGFloat) {
        let board = SKSpriteNode(imageNamed: "woodenBoard")
        board.size = CGSize(width: randW, height: randL)
        board.position = location
        board.zPosition = -9
        gameLayer.addChild(board)
        
        board.physicsBody = SKPhysicsBody(rectangleOf: board.frame.size)
        board.physicsBody?.isDynamic = true
        board.physicsBody?.categoryBitMask = PhysicsCategory.Board
        board.physicsBody?.contactTestBitMask = PhysicsCategory.Weapon
        board.physicsBody?.collisionBitMask = PhysicsCategory.None
        board.physicsBody?.affectedByGravity = false
        board.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(M_PI_4), duration: 0.75)))
        board.run(SKAction.wait(forDuration: 4.0), completion: {
            board.removeFromParent()
        })
    }
    
    override func killEnemy(enemy: SKSpriteNode) {
        enemy.removeAllActions()
        enemy.removeAllChildren()
        enemy.removeFromParent()
    }
    
    override func gameOver(won: Bool) {
        let userDef = UserDefaults.standard
        player.goldAmount += goldGained
        userDef.set(player.goldAmount, forKey: "goldAmount")
        
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        let gameOverScene = EndlessGameOverScene(size: self.size, score: scoreTime)
        gameOverScene.player = player
        self.view?.presentScene(gameOverScene, transition: reveal)
    }
    
    override func showPauseMenu() {
        super.showPauseMenu()
        timer?.invalidate()
        boardTimer?.invalidate()
    }
    
    override func removePauseMenu() {
        super.removePauseMenu()
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(EndlessScene.increaseTimer), userInfo: nil, repeats: true)
        self.boardTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(EndlessScene.spawnSpinningBoard), userInfo: nil, repeats: true)

    }
    
    
}
