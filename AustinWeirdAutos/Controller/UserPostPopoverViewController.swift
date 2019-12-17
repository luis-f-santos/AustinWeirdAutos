//
//  UserPostPopoverViewController.swift
//  AustinWeirdAutos
//
//  Created by Luis Santos on 12/14/19.
//  Copyright © 2019 Luis Santos. All rights reserved.
//

import UIKit
import Firebase

class UserPostPopoverViewController: UIViewController, UIScrollViewDelegate {
    
    
    
    @IBOutlet weak var userImagesHolderView: UIView!
    @IBOutlet weak var initialImageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var postDescriptionLbl: UILabel!
    
    @IBOutlet weak var askUserToShareLbl: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var selectedPost: Post!
    var initialImage = UIImage()
    var scrollView = UIScrollView()
    let myDispatchGroup = DispatchGroup()
    var numAsyncTasks = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true

        initialImageView.image = initialImage
        
        
        //Hide storyboard UI / Setup
        pageControl.isHidden = true
        postDescriptionLbl.isHidden = true
        askUserToShareLbl.isHidden = true
        shareButton.isHidden = true
        activityIndicatorView.isHidden = true
        
        //SetupScrollView
        scrollView = UIScrollView(frame: userImagesHolderView.bounds)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = UIColor.clear
        scrollView.delegate = self
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        userImagesHolderView.autoresizesSubviews = true
        
        self.userImagesHolderView.addSubview(self.scrollView)
        self.userImagesHolderView.bringSubview(toFront: self.pageControl)
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page  = scrollView.contentOffset.x/scrollView.frame.size.width
        pageControl.currentPage = Int(page)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let post = selectedPost {
            
            if post.imageURLs.count > 0 {
                
                pageControl.numberOfPages = post.imageURLs.count
                
                
                for index in 0..<post.imageURLs.count {
                    
                    
                    if let img = UserPostsViewController.imageCache.object(forKey: post.imageURLs[index] as NSString) {
                        
                        print("Using imgage from Cache: \(post.imageURLs[index])")
                        
                        let imageView = UIImageView()
                        imageView.contentMode = .scaleAspectFill
                        imageView.clipsToBounds = true
                        imageView.image = img
                        
                        let xPos = CGFloat(index) * UIScreen.main.bounds.width
                        print("scrollview: Using CacheImage, for index: \(index), HolderView width = \(self.userImagesHolderView.bounds.size.width)")
                        imageView.frame = CGRect(x: xPos, y: 0, width: self.userImagesHolderView.frame.size.width, height: self.userImagesHolderView.frame.size.height)
                        
                        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                        scrollView.autoresizesSubviews = true
                        scrollView.contentSize.width = UIScreen.main.bounds.width * CGFloat(index +  1)
                        
                        scrollView.addSubview(imageView)
                        //self.postImage.image = img
                        
                    } else {
                        
                        myDispatchGroup.enter()
                        numAsyncTasks = numAsyncTasks + 1
                        activityIndicatorView.isHidden = false
                        activityIndicatorView.startAnimating()
                        
                        
                        print("url to download: \(post.imageURLs[index])")
                        let ref = Storage.storage().reference(forURL: post.imageURLs[index])
                        
                        //maxSize = 2Mb
                        ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                            
                            self.myDispatchGroup.leave()
                            self.numAsyncTasks = self.numAsyncTasks - 1
                            if error != nil {
                                print("LUIS: Unable to download image from FirebaseStorage")
                            } else {
                                print("LUIS: Successfull Downloaded from firebase storage")
                                
                                if let imgData = data {
                                    if let img = UIImage(data: imgData){
                                        
                                        let imageView = UIImageView()
                                        imageView.contentMode = .scaleAspectFill
                                        imageView.clipsToBounds = true
                                        imageView.image = img
                                        
                                        let xPos = CGFloat(index) * UIScreen.main.bounds.width
                                        print("scrollview: Using DownloadedImage, for index: \(index), HolderView width = \(self.userImagesHolderView.bounds.size.width)")
                                        imageView.frame = CGRect(x: xPos, y: 0, width: self.userImagesHolderView.frame.size.width, height: self.userImagesHolderView.frame.size.height)
                                        
                                        self.scrollView.addSubview(imageView)
                                        //self.postImage.image = img
                                        UserPostsViewController.imageCache.setObject(img, forKey: post.imageURLs[index] as NSString)
                                    }
                                }
                            }
                            
                            self.myDispatchGroup.notify(queue: .main, work: DispatchWorkItem(block: {
                                
                                // present fetchedContent
                                self.presentPostData()
                                self.scrollView.contentSize.width = self.userImagesHolderView.frame.size.width * CGFloat(self.selectedPost.imageURLs.count)
                                
                                
                            }))
                            
                        })
                    }
                } //end of while loop
                
                scrollView.contentOffset.x = (CGFloat)(post.imageURLs.count - 1 ) * UIScreen.main.bounds.width
                pageControl.currentPage = post.imageURLs.count - 1
                
                if (numAsyncTasks == 0) {
                    presentPostData()
                }
                
            }
        }
        
        
    }
    
    func presentPostData(){
        
        self.pageControl.isHidden = false
        self.postDescriptionLbl.isHidden = false
        self.activityIndicatorView.stopAnimating()
        self.activityIndicatorView.isHidden = true
        self.initialImageView.removeFromSuperview()
        
        if(!selectedPost.isPublic){
            self.askUserToShareLbl.isHidden = false
            self.shareButton.isHidden = false
        }
    }

    
    @IBAction func shareBtnTouched(_ sender: UIButton) {
        
        selectedPost.savePublicStatus(status: true)
        shareButton.titleLabel?.text = "Thanks for Sharing!"
        shareButton.isUserInteractionEnabled = false
    }
    
    @IBAction func touchedBackButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    

}
