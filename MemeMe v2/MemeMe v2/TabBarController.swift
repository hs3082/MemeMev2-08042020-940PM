//
//  TabBarController.swift
//  MemeMe v1
//
//  Created by Howard Snyder on 7/26/20.
//  Copyright © 2020 Howard Snyder. All rights reserved.
//


    import Foundation
    import UIKit

    class TabBarController: UITabBarController {
        override func viewDidLoad() {
            super.viewDidLoad()
            self.tabBar.unselectedItemTintColor = UIColor.purple
            self.tabBar.tintColor = UIColor.yellow
            self.tabBar.barTintColor = UIColor.black
        
    }
}
