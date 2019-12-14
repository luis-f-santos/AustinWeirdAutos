//
//  UserListViewController.swift
//  AustinWeirdAutos
//
//  Created by Luis Santos on 10/26/19.
//  Copyright © 2019 Luis Santos. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper


class UserListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var users = [User]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
            
        
        DataService.ds.REF_USERS.observe(.value, with: { (snapshot) in
            
            self.users = []
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let key = snap.key
                        let user = User(userKey: key, postData: postDict)
                        self.users.append(user)
                    }
                }
            }
            self.tableView.reloadData()
        })

        
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? UserCell {
            
            cell.setSelected(false, animated: false)
        }
        
        var selectedUser: User!
        selectedUser = users[indexPath.row]
        performSegue(withIdentifier: "toOwnerPostsList", sender: selectedUser)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toOwnerPostsList" {
            if let ownerPostsListVC = segue.destination as? OwnerPostsListViewController {
                if let user = sender as? User {
                    ownerPostsListVC.user = user
                    
                }
            }
            
        }
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("LUIS: ID removed from keychain \(keychainResult)")
        try! Auth.auth().signOut()
        dismiss(animated: true, completion: nil)
    }
    
    
    //        let user1: Dictionary<String, AnyObject> = [
    //            "firstName": "senora" as AnyObject,
    //            "lastName": "profunda" as AnyObject,
    //            "phoneNumber": "512-2363-3434" as AnyObject
    //        ]
    //        let user2: Dictionary<String, AnyObject> = [
    //            "firstName": "dona" as AnyObject,
    //            "lastName": "picheta" as AnyObject,
    //            "phoneNumber": "512-3-3434" as AnyObject
    //        ]
    //        let user3: Dictionary<String, AnyObject> = [
    //            "firstName": "dona" as AnyObject,
    //            "lastName": "picopato" as AnyObject,
    //            "phoneNumber": "512-9922-3434" as AnyObject
    //        ]
    //
    //        let post1  = User(userKey: "abcde", postData: user1)
    //        let post2  = User(userKey: "abcde", postData: user2)
    //        let post3  = User(userKey: "abcde", postData: user3)
    //
    //        self.users.append(post1)
    //        self.users.append(post2)
    //        self.users.append(post3)
    
    
    
}
