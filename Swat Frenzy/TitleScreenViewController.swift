//
//  ViewController.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 10/5/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import UIKit

class TitleScreenViewController: UIViewController {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var tutorialButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.blueColor

        let borderColor = Colors.greenColor.cgColor
        let bordWidth: CGFloat = 4.0
        let buttonInsets = UIEdgeInsetsMake(0, 10, 0, 10)
        
        playButton.layer.borderColor = borderColor
        playButton.layer.borderWidth = bordWidth
        playButton.layer.cornerRadius = 25.0
        playButton.titleEdgeInsets = buttonInsets
        playButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        tutorialButton.layer.borderColor = borderColor
        tutorialButton.layer.borderWidth = bordWidth
        tutorialButton.layer.cornerRadius = 20.0
        tutorialButton.titleEdgeInsets = buttonInsets
        tutorialButton.titleLabel?.adjustsFontSizeToFitWidth = true

        resetButton.layer.borderColor = borderColor
        resetButton.layer.borderWidth = bordWidth
        resetButton.layer.cornerRadius = 15.0
        resetButton.titleEdgeInsets = buttonInsets
        resetButton.titleLabel?.adjustsFontSizeToFitWidth = true

    }

    @IBAction func displayTutorial(_ sender: Any) {
        let tutorialVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tutorialViewController") as! TutorialViewController
        self.addChildViewController(tutorialVC)
        tutorialVC.view.frame = view.frame
        view.addSubview(tutorialVC.view)
        tutorialVC.didMove(toParentViewController: self)
    }
    
    @IBAction func resetGameProgress(_ sender: Any) {
        let alert = UIAlertController(title: "Reset Progress", message: "Are you sure you want to reset?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "No", style: .cancel,
                                         handler: nil)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: {
            action in
            self.resetProgress()
        })
        
        alert.addAction(cancelAction)
        alert.addAction(yesAction)
        present(alert, animated: true, completion: nil)
    }
    
    func resetProgress() {
        let userDef = UserDefaults.standard
        userDef.set(0, forKey: "goldAmount")
        userDef.set(0, forKey: "bonusPower")
        userDef.set(0, forKey: "bonusHealth")
        userDef.set(1, forKey: "currentLevel")
    }
}

