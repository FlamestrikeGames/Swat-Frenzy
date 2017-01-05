//
//  Helper.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 1/5/17.
//  Copyright © 2017 FlamestrikeGames. All rights reserved.
//

import UIKit

class Helper {
    
    static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
}
