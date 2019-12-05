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
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var firstNameTextView: UITextField!
    
    @IBOutlet weak var lastNameTextView: UITextField!
    
    @IBOutlet weak var phoneNumberTextView: UITextField!
    
    var originalPassword: String!
    
    var onSave: ((_ data: Dictionary<String, AnyObject>) -> ())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtnTapped(_ sender: Any) {
        
        
        
        if let firstName = firstNameTextView.text, firstName.characters.count < 1 {
            firstNameTextView.layer.borderWidth = 1
            firstNameTextView.layer.borderColor = UIColor.red.cgColor
            return
        }
        
        if let lastName = lastNameTextView.text, lastName.characters.count < 1 {
            lastNameTextView.layer.borderWidth = 1
            lastNameTextView.layer.borderColor = UIColor.red.cgColor
            return
            
        }
        
        if(passwordTextView.text != originalPassword){
            passwordTextView.layer.borderWidth = 1
            passwordTextView.layer.borderColor = UIColor.red.cgColor
            
            passwordLabel.text = "Wrong Password"
            passwordLabel.textColor = UIColor.red
        }
        else { //}(passwordTextView.text == originalPassword){
        
            let userData: Dictionary<String, AnyObject> = [
                "firstName": firstNameTextView.text! as AnyObject,
                "lastName": lastNameTextView.text! as AnyObject,
                "phoneNumber": phoneNumberTextView.text! as AnyObject
            ]
            
            dismiss(animated: true, completion: nil)
            
            onSave?(userData)
        }
    }
    @IBAction func backgroundBtnTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }


    


}
