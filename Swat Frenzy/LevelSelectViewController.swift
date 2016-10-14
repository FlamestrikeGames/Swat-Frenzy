//
//  LevelSelectViewController.swift
//  Swat Frenzy
//
//  Created by Jonathan Chou on 10/12/16.
//  Copyright © 2016 FlamestrikeGames. All rights reserved.
//

import UIKit

class LevelSelectViewController: UICollectionViewController {
    let numLevels = 10
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 15.0
        let width = (view.frame.size.width - 2*space - 60) / 3.0
        let height = (view.frame.size.height - 2*space - 20) / 4.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: width,height: height)
        
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 30, 10, 30)
    }
    
    //override func collectionView
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numLevels
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomLevelCell", for: indexPath) as! CustomLevelCell
        
        cell.setLevel(level: indexPath.row + 1)
        return cell
 
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        
        viewController.level = indexPath.row + 1
        
        present(viewController, animated: true, completion: nil)

    }
}
