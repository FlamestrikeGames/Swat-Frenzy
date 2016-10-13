//
//  CustomLevelCell.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 10/12/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import UIKit

class CustomLevelCell: UICollectionViewCell {
    
    @IBOutlet weak var levelLabel: UILabel!
    
    func setLevel(level: Int) {
        levelLabel.text = "Level " + String(level)
    }
}
