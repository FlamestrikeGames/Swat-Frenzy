//
//  StatsViewController.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 11/8/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {
    var player: Player!
    var timer: Timer?
    
    @IBOutlet weak var costToIncHealth: UILabel!
    @IBOutlet weak var costToIncPower: UILabel!
    @IBOutlet weak var currentPlayerMaxHealth: UILabel!
    @IBOutlet weak var currentPlayerPower: UILabel!
    @IBOutlet weak var playerGold: UILabel!
    @IBOutlet weak var addHealthButton: UIButton!
    @IBOutlet weak var addPowerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.blueColor
        initializeValues()
        checkValues()
    }
    
    @IBAction func backButtonTouch(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addHealth(_ sender: AnyObject) {
        timer?.invalidate()
        if(costToIncHealth.text == "MAX") {
            return
        } else if(player.goldAmount < Int(costToIncHealth.text!)!) {
            return
        }
        player.maxHealth += 1
        UserDefaults.standard.set(player.maxHealth - 50, forKey: "bonusHealth")
        currentPlayerMaxHealth.text = String(player.maxHealth)
        updateValues(forLabel: costToIncHealth)

    }
    @IBAction func addPower(_ sender: AnyObject) {
        timer?.invalidate()
        if(costToIncPower.text == "MAX") {
            return
        } else if(player.goldAmount < Int(costToIncPower.text!)!) {
            return
        }
        player.power += 1
        UserDefaults.standard.set(player.power - 1, forKey: "bonusPower")
        currentPlayerPower.text = String(player.power)
        updateValues(forLabel: costToIncPower)
    }
    
    @IBAction func healthHoldDown(_ sender: UIButton) {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(StatsViewController.increaseHealth), userInfo: nil, repeats: true)

    }
    
    @IBAction func powerHoldDown(_ sender: Any) {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(StatsViewController.increasePower), userInfo: nil, repeats: true)
    }
    
    func initializeValues() {
      //  player.goldAmount = 1000000
        playerGold.text = String(player.goldAmount)
        costToIncHealth.text = String(player.maxHealth - 49)
        costToIncPower.text = String(player.power)
        currentPlayerMaxHealth.text = String(player.maxHealth)
        currentPlayerPower.text = String(player.power)
    }
    
    func updateValues(forLabel: UILabel) {
        player.goldAmount -= Int(forLabel.text!)!
        UserDefaults.standard.set(player.goldAmount, forKey: "goldAmount")
        playerGold.text = String(player.goldAmount)
        forLabel.text = String(Int(forLabel.text!)!+1)
        checkValues()
    }
    
    func checkValues() {
        // check if increased to max
        if(player.maxHealth - 49 > 75) {
            if(costToIncHealth.text != "MAX") {
                timer?.invalidate()
            }
            costToIncHealth.text = "MAX"
            costToIncHealth.textColor = UIColor.red
            addHealthButton.isUserInteractionEnabled = false
            addHealthButton.alpha = 0.2
        } else {
            if costToIncHealth.text != "MAX" {
                if player.goldAmount < Int(costToIncHealth.text!)! {
                    costToIncHealth.textColor = UIColor.red
                    addHealthButton.isUserInteractionEnabled = false
                    addHealthButton.alpha = 0.2
                    timer?.invalidate()
                } else {
                    costToIncHealth.textColor = UIColor.green
                }
            }
        }
        if (player.power >= 100 && costToIncPower.text != "MAX") {
            if(costToIncPower.text != "MAX") {
                timer?.invalidate()
            }
            costToIncPower.text = "MAX"
            costToIncPower.textColor = UIColor.red
            addPowerButton.isUserInteractionEnabled = false
            addPowerButton.alpha = 0.2
            timer?.invalidate()
        } else {
            if costToIncPower.text != "MAX" {
                if player.goldAmount < Int(costToIncPower.text!)! {
                    costToIncPower.textColor = UIColor.red
                    addPowerButton.isUserInteractionEnabled = false
                    addPowerButton.alpha = 0.2
                    timer?.invalidate()
                    
                } else {
                    costToIncPower.textColor = UIColor.green
                }
            }
        }
    }
    
    func increaseHealth() {
        player.maxHealth += 1
        UserDefaults.standard.set(player.maxHealth - 50, forKey: "bonusHealth")
        currentPlayerMaxHealth.text = String(player.maxHealth)
        updateValues(forLabel: costToIncHealth)
    }
    
    func increasePower() {
        player.power += 1
        UserDefaults.standard.set(player.power - 1, forKey: "bonusPower")
        currentPlayerPower.text = String(player.power)
        updateValues(forLabel: costToIncPower)
    }
    

    
}
