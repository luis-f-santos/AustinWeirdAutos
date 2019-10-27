//
//  UserListViewController.swift
//  AustinWeirdAutos
//
//  Created by Luis Santos on 10/26/19.
//  Copyright © 2019 Luis Santos. All rights reserved.
//

import UIKit

class UserListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var users = [User]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.users = []
        tableView.dataSource = self
        tableView.delegate = self
        
        let user1: Dictionary<String, AnyObject> = [
            "firstName": "senora" as AnyObject,
            "lastName": "profunda" as AnyObject,
            "phoneNumber": "512-2363-3434" as AnyObject
        ]
        let user2: Dictionary<String, AnyObject> = [
            "firstName": "dona" as AnyObject,
            "lastName": "picheta" as AnyObject,
            "phoneNumber": "512-3-3434" as AnyObject
        ]
        let user3: Dictionary<String, AnyObject> = [
            "firstName": "dona" as AnyObject,
            "lastName": "picopato" as AnyObject,
            "phoneNumber": "512-9922-3434" as AnyObject
        ]
        
        let post1  = User(userKey: "abcde", postData: user1)
        let post2  = User(userKey: "abcde", postData: user2)
        let post3  = User(userKey: "abcde", postData: user3)

        self.users.append(post1)
        self.users.append(post2)
        self.users.append(post3)

        
        
//        if let postDict = snap.value as? Dictionary<String, AnyObject> {
//
//            let key = snap.key
//            let post = Post(postKey: key, postData: postDict)
//            self.posts.append(post)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let user = users[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCell {
            
            cell.configureUserCell(user: user)
            return cell
            
        } else {
            
            return UserCell()
        }
    }
}
