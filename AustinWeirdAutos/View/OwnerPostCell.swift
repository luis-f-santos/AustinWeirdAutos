//
//  OwnerPostCell.swift
//  AustinWeirdAutos
//
//  Created by Luis Santos on 10/28/19.
//  Copyright © 2019 Luis Santos. All rights reserved.
//

import UIKit

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
        
        //TODO: add logic for publicLbl and ProgressLbl
        
        
        
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
