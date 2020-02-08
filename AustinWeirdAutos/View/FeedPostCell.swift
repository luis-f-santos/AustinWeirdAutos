//
//  FeedPostCell.swift
//  AustinWeirdAutos
//
//  Created by Luis Santos on 11/2/19.
//  Copyright © 2019 Luis Santos. All rights reserved.
//

import UIKit
import Firebase

class FeedPostCell: UITableViewCell, UIScrollViewDelegate {
    
    
    @IBOutlet weak var makeImage: UIImageView!
    
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var vehicleLbl: UILabel!
    @IBOutlet weak var dateCreatedLbl: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var numLikesLbl: UILabel!
    @IBOutlet weak var likesImg: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    var post: Post!
    var likesRef: DatabaseReference!
    
    var defaultImageView: UIImageView!
    var scrollViewAI: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        scrollView.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likesImg.addGestureRecognizer(tap)
        likesImg.isUserInteractionEnabled = true
    }
    
//    func prepareForReuse() {
//        <#code#>
//    }

    func configureFeedCell(post: Post) {
        
        self.post =  post
        vehicleLbl.text  = "\(post.year) \(post.make) \(post.model)"
        dateCreatedLbl.text = post.dateCreated
        descriptionTextView.text = post.description
        numLikesLbl.text = "\(post.likes)"
        postImage.image = UIImage (named: "red_tesla")  //Default image
        makeImage.image = UIImage(named: post.make)
        
        likesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postID)
        
        likesRef.observeSingleEvent(of: .value) { (snapshot) in
            
            if let _ = snapshot.value as? NSNull {
                self.likesImg.image = UIImage(named: "empty-heart")
                
            } else {
                self.likesImg.image = UIImage(named: "filled-heart")
                self.likesImg.tintColor = PRIMARY_UICOLOR
            }
        }
        
        //scrollView = UIScrollView()
        var defaultImageFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
        defaultImageFrame.size = scrollView.frame.size
        defaultImageView = UIImageView(frame: defaultImageFrame)
        defaultImageView.contentMode = UIViewContentMode.scaleToFill
        defaultImageView.clipsToBounds = true
        defaultImageView.image = UIImage(named: "red_tesla")
        
        //scrollView.addSubview(defaultImageView)

        //reset resuseable cell
        pageControl.currentPage = 0
        pageControl.numberOfPages = 0
        
        let subviews = self.scrollView.subviews
        for subview in subviews{
            subview.removeFromSuperview()
        }
     
        if post.imageURLs.count > 0 {
            
            pageControl.numberOfPages = post.imageURLs.count

            
            if(post.imageURLs.count == 1){
                pageControl.isHidden = true
            }
            else {
                pageControl.isHidden = false
            }
            
            self.scrollView.contentSize.width = scrollView.frame.size.width*CGFloat(post.imageURLs.count)
            
            for index in 0..<post.imageURLs.count {
                
            
                if let img = FeedViewController.imageCache.object(forKey: post.imageURLs[index] as NSString) {
                    
                    print("Using imgage from Cache: \(post.imageURLs[index])")
                    
                    let imageView = UIImageView()
                    imageView.contentMode = .scaleAspectFit
                    imageView.clipsToBounds = true
                    imageView.image = img
                    
                    let xPos = CGFloat(index) * UIScreen.main.bounds.width
                    
                    imageView.frame = CGRect(x: xPos, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
                    
                    imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    scrollView.autoresizesSubviews = true
                    scrollView.contentSize.width = UIScreen.main.bounds.width * CGFloat(index + 1)
                    
                    scrollView.addSubview(imageView)
                    //self.postImage.image = img
                    
                } else {
                    
                    addActivityIndicator(pageIndex: index)
                    
                    print("url to download: \(post.imageURLs[index])")
                    let ref = Storage.storage().reference(forURL: post.imageURLs[index])
                
                    //maxSize = 1Mb
                    ref.getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
                        
                        if error != nil {
                            print("LUIS: Unable to download image from FirebaseStorage")
                        } else {
                            print("LUIS: Successfull Downloaded from firebase storage")
                            
                            if let imgData = data {
                                if let img = UIImage(data: imgData){
                                    
                                    self.scrollViewAI.stopAnimating()
                                    let imageView = UIImageView()
                                    imageView.contentMode = .scaleAspectFit
                                    imageView.clipsToBounds = true
                                    imageView.image = img
                                    
                                    let xPos = CGFloat(index) * UIScreen.main.bounds.width
                                    
                                    imageView.frame = CGRect(x: xPos, y: 0, width: self.scrollView.frame.size.width, height: self.scrollView.frame.size.height)
                                    
                                    self.scrollView.addSubview(imageView)
                                    
                                    
                                    //self.postImage.image = img
                                    FeedViewController.imageCache.setObject(img, forKey: post.imageURLs[index] as NSString)
                                }
                            }
                        }
                    })
                    
                }
            }
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page  = scrollView.contentOffset.x/scrollView.frame.size.width
        pageControl.currentPage = Int(page)
        
        
    }
    
    func addActivityIndicator (pageIndex: Int) {
        let aView = UIView()
        aView.backgroundColor = UIColor.clear
        let xPos = CGFloat(pageIndex) * UIScreen.main.bounds.width
        aView.frame = CGRect(x: xPos, y: 0, width: self.scrollView.frame.size.width, height: self.scrollView.frame.size.height)
        scrollViewAI = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        scrollViewAI.center = aView.center
        scrollViewAI.startAnimating()
        aView.addSubview(scrollViewAI)
        scrollView.addSubview(aView)
        
    }
    
    @objc func likeTapped(sender: UITapGestureRecognizer) {
        
        likesRef.observeSingleEvent(of: .value) { (snapshot) in
            
            if let _ = snapshot.value as? NSNull {
                
                self.likesImg.image = UIImage(named: "filled-heart")
                self.likesImg.tintColor = PRIMARY_UICOLOR
                self.post.adjustLikes(addLike: true)
                self.likesRef.setValue(true)
            } else {
                
                self.likesImg.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(addLike: false)
                self.likesRef.removeValue()
            }
        }
        
    }
//9D5BAB5C-176D-4035-B235-10BC854AAC0D
//    "gs://austin-weird-autos.appspot.com/weird-pics/9D5BAB5C-176D-4035-B235-10BC854AAC0D"

}
