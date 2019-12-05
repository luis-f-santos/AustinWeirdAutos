//
//  CustomTabController.swift
//  AustinWeirdAutos
//
//  Created by Luis Santos on 12/4/19.
//  Copyright © 2019 Luis Santos. All rights reserved.
//

import UIKit

class CustomTabController: UITabBarController {
    
    var userID: String!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let feedController = FeedViewController()
        
        var userViewController = UIViewController()
        
        if let uid = userID {
            
            if let myUserViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserPostsViewController") as? UserPostsViewController {
                
                myUserViewController.userID = uid
                userViewController = myUserViewController
            }
            
            
            
        } else {
            
            if let myUserListController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserListViewController") as? UserListViewController {
                
                userViewController = myUserListController
            }
            
        }
        
        
        
        let userNavController = UINavigationController(rootViewController: userViewController)
        userNavController.tabBarItem.title = "Home"
        userNavController.tabBarItem.image = UIImage(named: "empty-heart")
        userViewController.navigationController?.isNavigationBarHidden = true
        
        
        let feedController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedViewController")

        let feedNavController = UINavigationController(rootViewController: feedController)
        feedNavController.tabBarItem.title = "Feed"
        feedNavController.tabBarItem.image = UIImage(named: "empty-heart")
        feedController.navigationController?.isNavigationBarHidden = true
        
        
        

        
        viewControllers = [userNavController, feedNavController]
        
    }

}
