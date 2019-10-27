//
//  UsersCell.swift
//  AustinWeirdAutos
//
//  Created by Luis Santos on 10/26/19.
//  Copyright © 2019 Luis Santos. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var lastNameLbl: UILabel!
    @IBOutlet weak var phoneNumberLbl: UILabel!
    
    
    var user: User!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureUserCell (user: User) {
        
        self.user = user
        self.firstNameLbl.text = user.firstName
        self.lastNameLbl.text = user.lastName
        self.phoneNumberLbl.text = user.phoneNumber
        
        
        
        
        
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
