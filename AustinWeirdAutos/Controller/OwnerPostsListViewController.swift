//
//  OwnerPostsListViewController.swift
//  AustinWeirdAutos
//
//  Created by Luis Santos on 10/27/19.
//  Copyright © 2019 Luis Santos. All rights reserved.
//

import UIKit
import Firebase

class OwnerPostsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var userNameLbl: UILabel!
    
    
    var posts = [Post]()
    var user: User!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        userNameLbl.text = user.firstName
        
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            
            self.posts = []
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        if let userID = postDict["userID"] as? String {
                        
                            if(userID  == self.user.userID){
                                
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
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "OwnerPostCell") as? OwnerPostCell {
            
            cell.configureOwnerPostCell(post: post)
            return cell
            
        } else {
            
            return OwnerPostCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //var selectedUser = user
        if let cell = tableView.dequeueReusableCell(withIdentifier: "OwnerPostCell") as? OwnerPostCell {
            
            cell.isSelected = false
            
        }
        
        
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil )
        
    }


    

}
