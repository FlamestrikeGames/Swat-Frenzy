//
//  LevelSelectViewController.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 10/12/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import UIKit

class LevelSelectViewController: UICollectionViewController {
    let maxLevels = 12
    var currentLevel: Int = 1
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 15.0
        let width = (view.frame.size.width - 3*space - 60) / 4.0
        let height = (view.frame.size.height - 2*space - 20) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: width,height: height)
        
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 30, 10, 30)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Unlocks new level if just completed one
        let userDef = UserDefaults.standard
        
        if let curLevel = userDef.value(forKey: "currentLevel") {
            currentLevel = curLevel as! Int
        } else {
            userDef.set(1, forKey: "currentLevel")
        }
        collectionView?.reloadData()
    }
    
    //override func collectionView
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return maxLevels
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomLevelCell", for: indexPath) as! CustomLevelCell
        
        cell.setLevel(level: indexPath.row + 1)
        
        if(currentLevel < indexPath.row + 1) {
            cell.isUserInteractionEnabled = false
            //  Display that the cell is locked
            cell.lockedLabel.isHidden = false
        } else {
            cell.isUserInteractionEnabled = true
            cell.lockedLabel.isHidden = true
        }
        return cell
 
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        
        viewController.level = indexPath.row + 1
        
        present(viewController, animated: true, completion: nil)

    }
}
