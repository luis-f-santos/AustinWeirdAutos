//
//  UserPostsViewController.swift
//  AustinWeirdAutos
//
//  Created by Luis Santos on 11/2/19.
//  Copyright © 2019 Luis Santos. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class UserPostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyTableView: UIView!
    
    var posts = [Post]()
    var userID: String!
    var didDataLoad = false
    var selectedPostImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            
            self.posts = []
            self.didDataLoad = true
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        if let userID = postDict["userID"] as? String {
                            
                            if(userID  == self.userID){
                                
                                let key = snap.key
                                let post = Post(postKey: key, postData: postDict)
                                self.posts.append(post)
                            }
                        }
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
        
        print("LUIS: numberofRowsInSection ran")
        if(self.didDataLoad){
            if posts.count == 0 {
                tableView.backgroundView = emptyTableView
                tableView.separatorStyle = .none

            }else {
                tableView.backgroundView = nil
                tableView.separatorStyle = .singleLine
            }
        }
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "UserPostCell") as? UserPostCell {
            
            cell.configureUserPostCell(post: post)
            return cell
            
        } else {
            return UserPostCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? UserPostCell {
            cell.setSelected(false, animated: false)
            self.selectedPostImageView = cell.previewImage
        }
        
        self.definesPresentationContext = true
        var postSelected: Post!
        postSelected = posts[indexPath.row]
        performSegue(withIdentifier: "toUserPostPopover", sender: postSelected)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toUserPostPopover" {
            if let userPostPopoverVC = segue.destination as? UserPostPopoverViewController{
                if let post = sender as? Post {
                    userPostPopoverVC.selectedPost = post
                    userPostPopoverVC.initialImage = self.selectedPostImageView.image!
                    
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
    
}
