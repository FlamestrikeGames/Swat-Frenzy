//
//  ViewController.swift
//  Swat Frenzy
//
//  Created by Eddie Chou on 10/5/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import UIKit

class TitleScreenViewController: UIViewController {

    @IBAction func resetGameProgress(_ sender: Any) {
        let userDef = UserDefaults.standard
        userDef.set(0, forKey: "goldAmount")
        userDef.set(0, forKey: "bonusPower")
        userDef.set(0, forKey: "bonusHealth")
        userDef.set(1, forKey: "currentLevel")
    }
}

