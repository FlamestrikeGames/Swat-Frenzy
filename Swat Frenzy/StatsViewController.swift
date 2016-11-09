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
    
    @IBOutlet weak var costToIncHealth: UILabel!
    @IBOutlet weak var costToIncPower: UILabel!
    @IBOutlet weak var currentPlayerMaxHealth: UILabel!
    @IBOutlet weak var currentPlayerPower: UILabel!
    @IBOutlet weak var playerGold: UILabel!
    @IBOutlet weak var addHealthButton: UIButton!
    @IBOutlet weak var addPowerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeValues()
        checkValues()
        // disable button if not enough gold
        playerGold.text = String(player.goldAmount)

    }
    
    @IBAction func backButtonTouch(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addHealth(_ sender: AnyObject) {
        player.maxHealth += 1
        UserDefaults.standard.set(player.maxHealth - 50, forKey: "bonusHealth")
        currentPlayerMaxHealth.text = String(player.maxHealth)
        updateValues(forLabel: costToIncHealth)
    }
    @IBAction func addPower(_ sender: AnyObject) {
        player.power += 1
        UserDefaults.standard.set(player.power - 1, forKey: "bonusPower")
        currentPlayerPower.text = String(player.power)
        updateValues(forLabel: costToIncPower)
    }
    
    func initializeValues() {
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
        if player.goldAmount < Int(costToIncHealth.text!)! {
            addHealthButton.isUserInteractionEnabled = false
        }
        if player.goldAmount < Int(costToIncPower.text!)! {
            addPowerButton.isUserInteractionEnabled = false
        }
    }
    

    
}
