//
//  Enemy.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 10/16/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import SpriteKit
import AVFoundation

class Enemy: SKSpriteNode {
    
    var damage: Double = 1.0
    var stunDuration: Double = 1.0
    var aliveDuration: Double = 1.0
   // var soundEffect: AVAudioPlayer
    
    init(image: String) {
        let texture = SKTexture(imageNamed: image)
        super.init(texture: texture, color: .clear, size: texture.size())
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
