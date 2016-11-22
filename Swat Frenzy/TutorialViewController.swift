//
//  TutorialViewController.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 11/19/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showAnimate()
    }
    
    @IBAction func dismissTutorial(_ sender: Any) {
        removeAnimate()
    }
    
    func showAnimate() {
        view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 0.95
            self.view.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    
    func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.view.alpha = 0.0
        }, completion: {
            (finished: Bool) in
            if finished {
                self.view.removeFromSuperview()
            }
        })
    }
}
