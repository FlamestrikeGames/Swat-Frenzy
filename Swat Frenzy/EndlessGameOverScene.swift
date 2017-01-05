//
//  EndlessGameOverScene.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 1/4/17.
//  Copyright © 2017 FlamestrikeGames. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class EndlessGameOverScene: SKScene {
    
    var backgroundSoundFX: AVAudioPlayer!
    var player: Player!
    
    init(size: CGSize, score:Int) {
        
        super.init(size: size)
        
        backgroundColor = SKColor.green
        
        let label = SKLabelNode(fontNamed: "Helvetica Neue Bold")
        label.text = "You survived \(score) seconds!"
        label.fontSize = 45
        label.fontColor = SKColor.black
        label.position = CGPoint(x: size.width / 2, y: size.height * 9/12)
        addChild(label)
        
        let postToLeaderboard = SKLabelNode(fontNamed: "Helvetica Neue Bold")
        postToLeaderboard.text = "Post score to Leaderboard"
        postToLeaderboard.fontColor = SKColor.blue
        postToLeaderboard.position = CGPoint(x: size.width / 2, y: size.height * 6/12)
        postToLeaderboard.name = "postScore"
        addChild(postToLeaderboard)
        
        let replayButton = SKLabelNode(fontNamed: "Helvetica Neue Bold")
        replayButton.text = "Replay Level"
        replayButton.fontColor = SKColor.blue
        replayButton.position = CGPoint(x: size.width / 2, y: size.height * 4/12)
        replayButton.name = "replay"
        addChild(replayButton)
        
        let leaderboardButton = SKLabelNode(fontNamed: "Helvetica Neue Bold")
        leaderboardButton.text = "Leaderboard"
        leaderboardButton.fontColor = SKColor.blue
        leaderboardButton.position = CGPoint(x: size.width * 4/6, y: size.height * 1/6)
        leaderboardButton.name = "leaderboard"
        addChild(leaderboardButton)
        
        let levelSelect = "Level Select"
        let levelSelectButton = SKLabelNode(fontNamed: "Helvetica Neue Bold")
        levelSelectButton.text = levelSelect
        levelSelectButton.fontColor = SKColor.blue
        levelSelectButton.position = CGPoint(x: size.width * 2/6, y: size.height * 1/6)
        levelSelectButton.name = "levelSelect"
        addChild(levelSelectButton)
        
        playBackgroundMusic(fileName: "lose.wav", volume: 1.0)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            
            let touchLocation = touch.location(in: self)
            let touchedNode = self.atPoint(touchLocation)
            if(touchedNode.name == "replay") {
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                var scene: BaseScene?
                scene = EndlessScene(fileNamed: "BaseScene")
                scene?.scaleMode = .aspectFill
                player.currentHealth = player.maxHealth
                scene?.player = player
                self.view?.presentScene(scene!, transition:reveal)
            } else if(touchedNode.name == "levelSelect") {
                // Post notification
                backgroundSoundFX.stop()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DismissSelf"), object: nil)
            }
        }
    }
    
    func playBackgroundMusic(fileName: String, volume: Float) {
        let path = Bundle.main.path(forResource: fileName, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            let sound = try AVAudioPlayer(contentsOf: url)
            backgroundSoundFX = sound
            // Repeats on negative number
            sound.play()
            sound.volume = volume
        } catch {
            // couldn't load file :(
        }
    }
}
