//
//  OwnerPostsListViewController.swift
//  AustinWeirdAutos
//
//  Created by Luis Santos on 10/27/19.
//  Copyright © 2019 Luis Santos. All rights reserved.
//

import UIKit
import Firebase

class OwnerPostsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate  {

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var userNameLbl: UILabel!
    
    var currentCellinEdit: Int?
    var editingIndexPath: IndexPath?
    var activeTextView: UITextView?
    
    
    var imagePicker: UIImagePickerController!
    var userAddedImage = false
    var addedImage = UIImageView()
    var oldImageView: UIImageView!
    var currentCell = OwnerPostCell()
    
    var posts = [Post]()
    var user: User!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if let userName = user?.firstName {
            userNameLbl.text = userName
        }

        NotificationCenter.default.addObserver(self, selector: #selector(OwnerPostsListViewController.keyboardWillAppear), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(OwnerPostsListViewController.keyboardWillDisappear), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        //Stop listening for keyboard hide/show events
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    @objc func keyboardWillAppear(notification: Notification){
        
        guard let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size else {
            return
        }
        
        var contentInsets:UIEdgeInsets
        contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
        tableView.contentInset = contentInsets
        
        UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.view.layoutIfNeeded()
            
        }, completion: { (completed) in
            
            self.tableView.scrollToRow(at: self.editingIndexPath!, at: UITableView.ScrollPosition.bottom, animated: true)
        })
        

    }
    
    @objc func keyboardWillDisappear(notification: Notification){
        
        tableView.contentInset.bottom = 0
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
            cell.addNewImage = addNewImagetoPost
            return cell
            
        } else {
            
            return OwnerPostCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? OwnerPostCell {
            
            cell.setSelected(false, animated: false)
            
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            userAddedImage = true
            addedImage.image = img
        }
        
        imagePicker.dismiss(animated: true, completion: nil )
        
    }
    
    func clearEditingIndexPath() -> () {
        
        if let editingCellIndexPath = editingIndexPath {
            
            if let myCurrentCell = tableView.cellForRow(at: editingCellIndexPath) as? OwnerPostCell {
                
                
                myCurrentCell.setSelected(false, animated: true)
                editingIndexPath = nil
            
            
                guard let image = addedImage.image, userAddedImage == true else {
                    
                    print("LUIS: New Image has not been added")
                    return
                }
                
                //reseting bool
                userAddedImage = false
            
                if let imageData = UIImageJPEGRepresentation(image, 0.2) {
                    
                    let imageUid = NSUUID().uuidString
                    let metadata = StorageMetadata()
                    metadata.contentType = "image/jpeg"
                    self.showSpinner()
                    
                    DataService.ds.REF_WEIRD_IMAGES.child(imageUid).putData(imageData, metadata: metadata, completion: { (metadata, error) in
                        
                        if error != nil {
                            self.removeSpinner()
                            self.addedImage.image = self.oldImageView.image
                            print("LUIS: Unable to upload image to firebase")
                        } else {
                            
                            print("LUIS: Successfully uploaded image to firebase storage")
                            print("LUIS: Storage Base URL = \(DataService.ds.REF_WEIRD_IMAGES)")
                            self.removeSpinner()
                            
                            if let name = metadata?.name {
                                print("LUIS: metadata.name = \(name)")
                                let forwardSlash = "/"
                                let url = "\(DataService.ds.REF_WEIRD_IMAGES)" + forwardSlash + name
                                let currentDate = Date()
                                let myDateFormatter = DateFormatter()
                                myDateFormatter.dateFormat = "yyyy-MM-dd_HH:mm:ss"
                                
                                let newImageUID = myDateFormatter.string(from: currentDate) + imageUid
                                
                                myCurrentCell.post.saveNewImageURL(imageUrl: url, imageUID: newImageUID)
                                
                            }
                        }
                    })
                }
            }
            
        }
        
        
        
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
            
        } else { //currentCell is nil so assign the new editing Index
            
            let point = tableView.convert(editLbl.bounds.origin, from: editLbl)
            if let indexPath = tableView.indexPathForRow(at: point){
                
                editingIndexPath = indexPath
                
                if let currentCell = tableView.cellForRow(at: editingIndexPath!) as? OwnerPostCell {
                    
                    //currentCell.backgroundColor = UIColor.lightGray
                    currentCell.descriptionText.delegate = self
                    currentCell.setSelected(true, animated: true)
                    currentCell.descriptionText.tintColor = UIColor.black
                    tableView.tintColor = UIColor.black
                    //currentCell.selectionStyle = UITableViewCellSelectionStyle.none
                }
            }
            
            
            return true
        }
        
    }
    
    func addNewImagetoPost() -> () {
        
        if let editingIndexPath = editingIndexPath {
            
            if let myCurrentCell = tableView.cellForRow(at: editingIndexPath) as? OwnerPostCell {
                
                //currentCell = myCurrentCell
                addedImage = myCurrentCell.previewImage
                oldImageView = UIImageView(image: myCurrentCell.previewImage.image)
                present(imagePicker, animated: true, completion: nil)
            }
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        activeTextView = textView
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        activeTextView = nil
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
