//
//  FeedPostCell.swift
//  AustinWeirdAutos
//
//  Created by Luis Santos on 11/2/19.
//  Copyright © 2019 Luis Santos. All rights reserved.
//

import UIKit
import Firebase

class FeedPostCell: UITableViewCell {
    
    
    @IBOutlet weak var makeImage: UIImageView!
    
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var vehicleLbl: UILabel!
    @IBOutlet weak var dateCreatedLbl: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var numLikesLbl: UILabel!
    
    var post: Post!
    
    var scrollView: UIScrollView!
    
    
    func configureFeedCell(post: Post) {
        
        scrollView.add
        
        self.post =  post
        vehicleLbl.text  = "\(post.year) \(post.make) \(post.model)"
        dateCreatedLbl.text = post.dateCreated
        descriptionTextView.text = post.description
        numLikesLbl.text = "\(post.likes)"
        postImage.image = UIImage (named: "red_tesla")  //Default image
     
        //URLSession.shared.downloadTask(with: URL(string: post.imageURLs[0] )!, completionHandler: <#T##(URL?, URLResponse?, Error?) -> Void#>)
        
        if post.imageURLs.count > 0 {
            
            if let img = FeedViewController.imageCache.object(forKey: post.imageURLs[0] as NSString) {
                
                print("Using imgage from Cache: \(post.imageURLs[0])")
                self.postImage.image = img
                
            } else {
            
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
                                self.postImage.image = img
                                FeedViewController.imageCache.setObject(img, forKey: post.imageURLs[0] as NSString)
                            }
                        }
                    }
                })
            }
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
