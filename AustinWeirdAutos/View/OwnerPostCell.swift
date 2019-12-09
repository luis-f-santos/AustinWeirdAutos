//
//  OwnerPostCell.swift
//  AustinWeirdAutos
//
//  Created by Luis Santos on 10/28/19.
//  Copyright © 2019 Luis Santos. All rights reserved.
//

import UIKit
import Firebase


class OwnerPostCell: UITableViewCell {
    
    @IBOutlet weak var previewImage: UIImageView!
    
    @IBOutlet weak var yearLbl: UILabel!
    @IBOutlet weak var makeLbl: UILabel!
    @IBOutlet weak var modelLbl: UILabel!
    @IBOutlet weak var editLbl: UILabel!
    @IBOutlet weak var saveLbl: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var publicLbl: UILabel!
    @IBOutlet weak var progressLbl: UILabel!
    
    var publicState = false
    var completeState = false
    
    var allowCellEditing: ((_ editLbl: UILabel) -> (Bool))?
    var clearEditingLock: (() -> ())?
    
    var post: Post!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureOwnerPostCell(post: Post) {
        
        self.post =  post
        yearLbl.text  = post.year
        makeLbl.text = post.make
        modelLbl.text = post.model
        descriptionText.text = post.description
        saveLbl.isHidden = true
        
        
        if(post.isPublic){
            publicLbl.text = "Public"
            publicState = true
        }

        if(post.isComplete){
            progressLbl.text = "Complete"
            completeState = true
        }
        
        setupTapGestures()

        
        
        //Now only checking if the imageURLs array even exists
        if post.imageURLs.count > 0 {
            
            print("url to download: \(post.imageURLs[0])")
            let ref = Storage.storage().reference(forURL: post.imageURLs[0])
            
            //maxSize = 1Mb
            ref.getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
                
                if error != nil {
                    print("LUIS: Unable to download image from FirebaseStorage")
                } else {
                    
                    print("LUIS: Successfull Downloaded from firebase storage")
                    
                    if let imgData = data {
                        if let img = UIImage(data: imgData){
                            self.previewImage.image = img
                           // FeedViewController.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                        }
                    }
                }
            })
        }

    }
    
    @objc func editLblTapped(sender: UITapGestureRecognizer) {
        
        
        if(allowCellEditing?(editLbl) == false){
            return
        }
        
        publicLbl.isUserInteractionEnabled = true
        publicLbl.layer.borderWidth = 1.0
        publicLbl.layer.borderColor = UIColor.red.cgColor
        publicLbl.backgroundColor = UIColor.clear
        publicLbl.textColor = UIColor.black
        
        progressLbl.isUserInteractionEnabled = true
        progressLbl.layer.borderWidth = 1.0
        progressLbl.layer.borderColor = UIColor.red.cgColor
        progressLbl.backgroundColor = UIColor.clear
        progressLbl.textColor = UIColor.black
        
        saveLbl.isHidden = false
        saveLbl.isUserInteractionEnabled = true
        
        descriptionText.isEditable = true
        descriptionText.layer.borderWidth = 1.0
        descriptionText.layer.borderColor = UIColor.red.cgColor
        
    }
    
    @objc func saveLblTapped(sender: UITapGestureRecognizer) {
        
        if(post.description != descriptionText.text){
            
            post.saveNewDescription(newDescription: descriptionText.text)
        }
        
        if(post.isPublic != publicState) {
            
            post.savePublicStatus(status: publicState)
        }
        
        if(post.isComplete != completeState) {
            
            post.saveProgressStatus(status: completeState)
        }
        
        resetCellLabelsUI()
        clearEditingLock?()
        
    }
    
    @objc func publicLblTapped(sender: UITapGestureRecognizer) {
        
        if(publicState){
            publicState = false
            publicLbl.text = "Not Public"
        }else {
            publicState = true
            publicLbl.text = "Public"
        }
        
    }
    
    @objc func progressLblTapped(sender: UITapGestureRecognizer) {
        
        if(completeState){
            completeState = false
            progressLbl.text = "Mark as Complete"
        }else {
            completeState = true
            progressLbl.text = "Complete"

        }
        
    }
    
    func setupTapGestures(){
        
        let editTap = UITapGestureRecognizer(target: self, action: #selector(editLblTapped))
        editTap.numberOfTapsRequired = 1
        editLbl.addGestureRecognizer(editTap)
        editLbl.isUserInteractionEnabled = true
        
        let saveTap = UITapGestureRecognizer(target: self, action: #selector(saveLblTapped))
        saveTap.numberOfTapsRequired = 1
        saveLbl.addGestureRecognizer(saveTap)
        
        let publicTap = UITapGestureRecognizer(target: self, action: #selector(publicLblTapped))
        publicTap.numberOfTapsRequired = 1
        publicLbl.addGestureRecognizer(publicTap)
        
        let completeTap = UITapGestureRecognizer(target: self, action: #selector(progressLblTapped))
        completeTap.numberOfTapsRequired = 1
        progressLbl.addGestureRecognizer(completeTap)
        
        
    }
    
    func resetCellLabelsUI(){
        
        publicLbl.layer.borderWidth = 0
        publicLbl.textColor = UIColor.white
        publicLbl.backgroundColor = PRIMARY_UICOLOR
        publicLbl.isUserInteractionEnabled = false
        
        progressLbl.layer.borderWidth = 0
        progressLbl.textColor = UIColor.white
        progressLbl.backgroundColor = PRIMARY_UICOLOR
        progressLbl.isUserInteractionEnabled = false
        
        descriptionText.layer.borderWidth = 0
        descriptionText.isEditable = false
        
        saveLbl.isUserInteractionEnabled = false
        saveLbl.isHidden = true
        
        
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
