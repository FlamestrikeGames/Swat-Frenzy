//
//  LevelSelectViewController.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 10/12/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import UIKit
import AVFoundation

class LevelSelectViewController: UICollectionViewController {
    let maxLevels = 9
    var currentLevel: Int!
    var backgroundSoundFX: AVAudioPlayer!

    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var backButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 15.0
        let width = (view.frame.size.width - 2*space - 150) / 3.0
        let height = (view.frame.size.height - 2*space - 60) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: width,height: height)
        
        // up right down left
        flowLayout.sectionInset = UIEdgeInsetsMake(30, 75, 30, 75)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Unlocks new level if just completed one
        let userDef = UserDefaults.standard
        
        if let curLevel = userDef.value(forKey: "currentLevel") {
            currentLevel = curLevel as! Int
        } else {
            currentLevel = 1
            userDef.set(1, forKey: "currentLevel")
        }
        collectionView?.reloadData()
        playBackgroundMusic(fileName: "introMusic.wav", volume: 0.5)
    }
    
    @IBAction func backButtonTouch(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return maxLevels
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomLevelCell", for: indexPath) as! CustomLevelCell
        
        cell.setLevel(level: indexPath.row + 1)
        var imageName: String
        switch(indexPath.row+1) {
        case 1: imageName = "background"
        case 2: imageName = "woodsBackground"
        case 3: imageName = "houseBackground"
        case 4: imageName = "insideHouse1"
        case 5: imageName = "insideHouse2"
        case 6: imageName = "basement"
        case 7: imageName = "gardenBackground"
        case 8: imageName = "waspNestBackground"
        case 9: imageName = "bossBackground"

        default: imageName = "background"
            
        }
        let image = UIImage(named: imageName)
        
        if(currentLevel < indexPath.row + 1) {
            cell.isUserInteractionEnabled = false
            //  Display that the cell is locked
            cell.lockedLabel.isHidden = false
            cell.backgroundImage.image = nil
        } else {
            cell.isUserInteractionEnabled = true
            cell.lockedLabel.isHidden = true
            cell.setBackground(background: image!)
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        viewController.level = indexPath.row + 1
        
        backgroundSoundFX.stop()
        
        present(viewController, animated: true, completion: nil)
    }
    
    func playBackgroundMusic(fileName: String, volume: Float) {
        let path = Bundle.main.path(forResource: fileName, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            let sound = try AVAudioPlayer(contentsOf: url)
            backgroundSoundFX = sound
            // Repeats on negative number
            backgroundSoundFX.numberOfLoops = -1
            sound.play()
            sound.volume = volume
        } catch {
            // couldn't load file :(
        }
    }
}
