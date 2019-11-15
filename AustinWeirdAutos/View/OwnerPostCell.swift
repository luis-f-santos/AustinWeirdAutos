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