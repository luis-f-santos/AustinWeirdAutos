//
//  UserPostPopoverViewController.swift
//  AustinWeirdAutos
//
//  Created by Luis Santos on 12/14/19.
//  Copyright © 2019 Luis Santos. All rights reserved.
//

import UIKit

class UserPostPopoverViewController: UIViewController {
    
    
    
    @IBOutlet weak var userImagesHolderView: UIView!
    @IBOutlet weak var initialImageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var postDescriptionLbl: UILabel!
    
    @IBOutlet weak var askUserToShareLbl: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    
    var selectedPost: Post!
    var initialImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true

        initialImageView.image = initialImage
        // Do any additional setup after loading the view.
    }

    
    
    @IBAction func touchedBackButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    

}
