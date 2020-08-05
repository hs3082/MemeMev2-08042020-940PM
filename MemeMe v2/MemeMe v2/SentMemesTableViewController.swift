//
//  SentMemesTableViewController.swift
//  MemeMe v1
//
//  Created by Howard Snyder on 7/28/20.
//  Copyright © 2020 Howard Snyder. All rights reserved.
//

import Foundation
import UIKit

//class SentMemesTableViewController: UIViewController{
//    var memes: [Meme]! {
//        let object = UIApplication.shared.delegate
//        let appDelegate = object as! AppDelegate
//        return appDelegate.memes
//    }
    
//}


class SentMemesTableViewController: UITableViewController {

    var memes: [Meme]!

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.tabBarController?.tabBar.isHidden = false
            
            print("Table View will Load")
            
            // create an IBOutlet for the table view first
            // then reload the tableview in viewWillAppear instead of viewDidLoad
            tableView.reloadData()
            
        }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Meme", style: .plain, target: self, action: #selector(addMeme))
        
        //tableView.delegate = self
        
    }
    
    @objc func addMeme() {
    let controller = (storyboard?.instantiateViewController(identifier: "MemeEditorViewController"))!
    present(controller, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Return number of memes in array
        
        if memes == nil
        {
            print("No memes to show")
            return 0
        }
        
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // 1. Dequeue a reusable cell from the table, using the correct “reuse identifier” MemeCell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell")!

        // 2. Find the model object that corresponds to that row
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        // 3. Set the images and labels in the cell with the data from the model object
        cell.textLabel?.text = meme.topText
        cell.imageView?.image = meme.memedImage
        
        // If the cell has a detail label, we will put the evil scheme in.
        
        
        // 4. return the cell.
        return cell

    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
    {
        // Instantiate detailed view controller from storyboard
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        // Set villain property
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        
        // Pass to next screen
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
}

