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
    
    var currentCellinEdit: Int?
    var editingIndexPath: IndexPath?
    
    var posts = [Post]()
    var user: User!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        if let userName = user?.firstName {
            userNameLbl.text = userName
        }

        
        
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
            cell.allowCellEditing = allowCellEditing
            cell.clearEditingLock = clearEditingIndexPath
            //cell.editLbl.tag = indexPath.row
            return cell
            
        } else {
            
            return OwnerPostCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "OwnerPostCell") as? OwnerPostCell {
            
            cell.isSelected = false
        }
        
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if(indexPath == editingIndexPath){
            
            editingIndexPath = nil
            if let currentCell = tableView.cellForRow(at: indexPath) as? OwnerPostCell {
                
                currentCell.resetCellLabelsUI()
            }
            
        }
    }
    
    func clearEditingIndexPath() -> () {
        editingIndexPath = nil
    }
    
    func allowCellEditing(_ editLbl: UILabel) -> (Bool) {
        
        if let editingCellIndexPath = editingIndexPath {
            
            if let currentCell = tableView.cellForRow(at: editingCellIndexPath) as? OwnerPostCell {
                let midX = currentCell.center.x
                let midY = currentCell.center.y
                
                let animation = CABasicAnimation(keyPath: "position")
                animation.duration = 0.06
                animation.repeatCount = 4
                animation.autoreverses = true
                animation.fromValue = CGPoint(x: midX - 10, y: midY)
                animation.toValue = CGPoint(x: midX + 10, y: midY)
                currentCell.layer.add(animation, forKey: "position")
                
            }
            
            return false
            
        }else { //currentCell is nil so assign the new editing Index
            
            let point = tableView.convert(editLbl.bounds.origin, from: editLbl)
            if let indexPath = tableView.indexPathForRow(at: point){
                editingIndexPath = indexPath
            }
            
            return true
            
        }
        
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil )
        
    }


    
    @IBAction func circledPlusTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "toCreatePostVC", sender: user)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCreatePostVC" {
            if let createPostVC = segue.destination as? CreatePostViewController {
                if let user = sender as? User {
                    createPostVC.currentUser = user
                    
                }
            }
            
        }
    }
    
}
