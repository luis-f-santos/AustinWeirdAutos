//
//  CustomTabController.swift
//  AustinWeirdAutos
//
//  Created by Luis Santos on 12/4/19.
//  Copyright © 2019 Luis Santos. All rights reserved.
//

import UIKit

class CustomTabController: UITabBarController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let feedController = FeedViewController()
        let feedController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedViewController")

        let feedNavController = UINavigationController(rootViewController: feedController)
        feedNavController.tabBarItem.title = "Feed"
        feedNavController.tabBarItem.image = UIImage(named: "empty-heart")
        feedController.navigationController?.isNavigationBarHidden = true
        
        
        let userListController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserListViewController")
        
        let userNavController = UINavigationController(rootViewController: userListController)
        userNavController.tabBarItem.title = "UserList"
        userNavController.tabBarItem.image = UIImage(named: "empty-heart")
        userListController.navigationController?.isNavigationBarHidden = true

        
        viewControllers = [userNavController, feedNavController]
        
    }

}
