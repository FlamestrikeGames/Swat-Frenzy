//
//  CustomLevelCell.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 10/12/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import UIKit

class CustomLevelCell: UICollectionViewCell {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var lockedLabel: UILabel!
    
    func initializeBackground() {
        backgroundImage.layer.cornerRadius = 10.0
        backgroundImage.layer.masksToBounds = true
    }
    
    func setLevel(level: Int) {
        levelLabel.text = "Level " + String(level)
    }
    
    func setBackground(background: UIImage) {

        backgroundImage.image = background
    }
}
