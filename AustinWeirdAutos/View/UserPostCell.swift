//
//  UserPostCell.swift
//  AustinWeirdAutos
//
//  Created by Luis Santos on 11/2/19.
//  Copyright © 2019 Luis Santos. All rights reserved.
//

import UIKit
import Firebase

class UserPostCell: UITableViewCell {
    
    @IBOutlet weak var makeImage: UIImageView!
    
    @IBOutlet weak var previewImage: UIImageView!
    
    @IBOutlet weak var makeLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var dateCreatedLabel: UILabel!
    @IBOutlet weak var currentProgressLabel: UILabel!
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureUserPostCell(post: Post) {
        
        self.post =  post
        yearLabel.text  = post.year
        makeLabel.text = post.make
        modelLabel.text = post.model
        dateCreatedLabel.text = post.dateCreated
        
        if (post.isComplete) {
            currentProgressLabel.text = "Completed"
        }else {
            currentProgressLabel.text = "In Progress..."
        }
        
        
        //Now only checking if the imageURLs array even exists
        if post.imageURLs.count > 0 {

            print("url to download: \(post.imageURLs[0])")
            let ref = Storage.storage().reference(forURL: post.imageURLs[0])

            //maxSize = 2Mb
            ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in

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
        
        //TODO: add logic for publicLbl and ProgressLbl
        
        
        
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
