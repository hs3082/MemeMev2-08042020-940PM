//
//  SentMemesCollectionViewController.swift
//  MemeMe v1
//
//  Created by Howard Snyder on 7/28/20.
//  Copyright © 2020 Howard Snyder. All rights reserved.
//

import Foundation
import UIKit



//var memes: [Meme]! {
//    let object = UIApplication.shared.delegate
//    let appDelegate = object as! AppDelegate
//    return appDelegate.memes
//}


class SentMemesCollectionViewController: UICollectionViewController {

    
    // Meme data model
    var memes: [Meme]!
    
    // Flow layout object
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
     
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
        print("Collection View Will Appear")

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Meme", style: .plain, target: self, action: #selector(addMeme))
     
    }
     
        @objc func addMeme() {
        let controller = (storyboard?.instantiateViewController(identifier: "MemeEditorViewController"))!
        present(controller, animated: true, completion: nil)
        }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // To Do
        if memes == nil
        {
            print("No memes to show")
            return 0
        }
        

        return self.memes.count
        
    }
    
     override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {

        // 1. Dequeue a reusable cell from the table, using the correct “reuse identifier”
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell

        // 2. Find the model object that corresponds to that row
        let meme = self.memes[(indexPath as NSIndexPath).row]

        // 3. Set the images and labels in the cell with the data from the model object
        cell.nameLabel?.text = meme.topText
        cell.memeImageView?.image = meme.memedImage

        // If the cell has a detail label, we will put the evil scheme in.

        // 4. return the cell.
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath)
    {
        // Instantiate detailed view controller from storyboard
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        // Set villain property
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        
        // Pass to next screen
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
}

//SentMemesTableVC.swift

