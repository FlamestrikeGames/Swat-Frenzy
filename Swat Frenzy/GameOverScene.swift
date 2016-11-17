//
//  GameOverScene.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 10/7/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class GameOverScene: SKScene {
    
    var level: Int!
    var backgroundSoundFX: AVAudioPlayer!
    var player: Player!
    
    init(size: CGSize, won:Bool, level: Int) {
        
        super.init(size: size)
        
        self.level = level
        backgroundColor = won ? SKColor.green : SKColor.red
        
        let winMessage = initializeVictoryMessage(forLevel: level)
        
        let message = won ? winMessage :
                            ["You suffered a horrible death! Try increasing your stats first!"]
        
        let label = SKLabelNode(fontNamed: "Helvetica Neue Bold")
        label.text = message.first
        label.fontSize = 20
        label.fontColor = SKColor.black
        label.position = CGPoint(x: size.width/2, y: size.height/1.5)
        addChild(label)
        
        if (message.count > 1) {
            let label2 = SKLabelNode(fontNamed: "Helvetica Neue Bold")
            label2.fontSize = 20
            label2.fontColor = SKColor.black
            label2.text = message[1]
            label2.position = CGPoint(x: size.width/2, y: size.height/1.7)
            addChild(label2)
            if(message.count > 2) {
                let label3 = SKLabelNode(fontNamed: "Helvetica Neue Bold")
                label3.text = message[2]
                label3.fontSize = 20
                label3.fontColor = SKColor.black
                label3.position = CGPoint(x: size.width/2, y: size.height/2)
                addChild(label3)
            }
        }
        
        if(level != 9 && won) {
            let nextLevelButton = SKLabelNode(fontNamed: "Helvetica Neue Bold")
            nextLevelButton.text = "Next Level"
            nextLevelButton.fontColor = SKColor.blue
            nextLevelButton.position = CGPoint(x: size.width * 4/5, y: size.height/6)
            nextLevelButton.name = "nextLevel"
            addChild(nextLevelButton)
        }

        
        let replayButton = SKLabelNode(fontNamed: "Helvetica Neue Bold")
        replayButton.text = "Replay Level"
        replayButton.fontColor = SKColor.blue
        replayButton.position = CGPoint(x: size.width/2, y: size.height/6)
        replayButton.name = "replay"
        addChild(replayButton)
        
        let levelSelect = "Level Select"
        let levelSelectButton = SKLabelNode(fontNamed: "Helvetica Neue Bold")
        levelSelectButton.text = levelSelect
        levelSelectButton.fontColor = SKColor.blue
        levelSelectButton.position = CGPoint(x: size.width * 1/5, y: size.height/6)
        levelSelectButton.name = "levelSelect"
        addChild(levelSelectButton)
        
        if(won) {
            playBackgroundMusic(fileName: "win.wav", volume: 1.0)
        } else {
            playBackgroundMusic(fileName: "lose.wav", volume: 1.0)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
         for touch: AnyObject in touches {
         
            let touchLocation = touch.location(in: self)
            let touchedNode = self.atPoint(touchLocation)
            if(touchedNode.name == "replay" || touchedNode.name == "nextLevel") {
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                var scene: BaseScene?
                if(touchedNode.name == "nextLevel") {
                    level = level + 1
                }
                switch(level) {
                case 1: scene = LevelOneScene(fileNamed: "BaseScene")
                case 2: scene = LevelTwoScene(fileNamed: "BaseScene")
                case 3: scene = LevelThreeScene(fileNamed: "BaseScene")
                case 4: scene = LevelFourScene(fileNamed: "BaseScene")
                case 5: scene = LevelFiveScene(fileNamed: "BaseScene")
                case 6: scene = LevelSixScene(fileNamed: "BaseScene")
                case 7: scene = LevelSevenScene(fileNamed: "BaseScene")
                case 8: scene = LevelEightScene(fileNamed: "BaseScene")
                case 9: scene = LevelNineScene(fileNamed: "BaseScene")
                    
                default: scene = BaseScene(fileNamed: "BaseScene")
                    break
                    
                }
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
    
    func initializeVictoryMessage(forLevel: Int) -> [String]{
        switch(forLevel) {
        case 1: return ["Your friend John calls you from his house in panic!", "He exclaims, \"HELP! THE BUGS ARE EVERYWHERE AGH!\"", "You instantly head towards John's house in the woods."]
        case 2: return ["You flex at the flies triumphantly as you head through the woods.", "John's house is in sight!"]
        case 3: return ["Poor bees. What has gotten into them?", "John's house looks like it could fall over at any moment!", "What's going on here?"]
        case 4: return ["You head towards John's bedroom while yelling for him.", "Where could he be!?"]
        case 5: return ["You hear a girl scream from the basement.", "You rush down the stairs!"]
        case 6: return ["It was John all along.", "He says shakily, \"Th.. the backyard... They are everywhere... It's impossible.\"", "You reassure him that you will take care of it and head outside."]
        case 7: return ["A giant wasp's nest is in sight.", "You head over with caution."]
        case 8: return ["A monstrous wasp appears before you and begins to attack!"]
        case 9: return ["You have defeated all the enemies!", "Your friend has been saved.", "The end."]
        default: return ["All enemies swatted! You win!"]
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
