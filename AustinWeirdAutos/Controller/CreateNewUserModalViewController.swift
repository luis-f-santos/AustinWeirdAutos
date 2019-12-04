//
//  CreateNewUserModalViewController.swift
//  AustinWeirdAutos
//
//  Created by Luis Santos on 12/4/19.
//  Copyright © 2019 Luis Santos. All rights reserved.
//

import UIKit

class CreateNewUserModalViewController: UIViewController {

    @IBOutlet weak var passwordTextView: UITextField!
    
    @IBOutlet weak var firstNameTextView: UITextField!
    
    @IBOutlet weak var lastNameTextView: UITextField!
    
    @IBOutlet weak var phoneNumberTextView: UITextField!
    
    var originalPassword: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTextView.text = originalPassword
        // Do any additional setup after loading the view.
    }

    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtnTapped(_ sender: Any) {
        
        
    }
    @IBAction func backgroundBtnTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }


    


}
