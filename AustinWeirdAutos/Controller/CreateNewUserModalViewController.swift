//
//  CreateNewUserModalViewController.swift
//  AustinWeirdAutos
//
//  Created by Luis Santos on 12/4/19.
//  Copyright © 2019 Luis Santos. All rights reserved.
//

import UIKit

class CreateNewUserModalViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var passwordTextView: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var firstNameTextView: UITextField!
    
    @IBOutlet weak var lastNameTextView: UITextField!
    
    @IBOutlet weak var phoneNumberTextView: UITextField!
    
    var originalPassword: String!
    var activeField: UITextField?
    
    var onSave: ((_ data: Dictionary<String, AnyObject>) -> ())?
    var onCancel: (() -> ())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTextView.delegate = self
        firstNameTextView.delegate = self
        lastNameTextView.delegate = self
        phoneNumberTextView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(CreateNewUserModalViewController.keyboardWillAppear), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CreateNewUserModalViewController.keyboardWillDisappear), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    deinit {
        //Stop listening for keyboard hide/show events
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    @objc func keyboardWillAppear(notification: Notification){
        
        guard let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size else {
            return
        }
        
        if let activeField = self.activeField {
            
            let superPoint = getConvertedPoint(self.view, baseView: activeField)
            let maxYpostition = (superPoint.y - activeField.frame.height) * -1
            let keyboardYposition = self.view.frame.height - keyboardSize.height

            if (maxYpostition > keyboardYposition){
                let yAxisMove = Int(maxYpostition) - Int(keyboardYposition)
                self.view.frame.origin.y =  -CGFloat(yAxisMove+10)
            }
        }
    }
    
    @objc func keyboardWillDisappear(notification: Notification){
        
        self.view.frame.origin.y = 0
    }

    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        
        onCancel?()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtnTapped(_ sender: Any) {
        
        if let firstName = firstNameTextView.text, firstName.count < 1 {
            firstNameTextView.layer.borderWidth = 1
            firstNameTextView.layer.borderColor = UIColor.red.cgColor
        }
        
        if let lastName = lastNameTextView.text, lastName.count < 1 {
            lastNameTextView.layer.borderWidth = 1
            lastNameTextView.layer.borderColor = UIColor.red.cgColor
        }
        
        if let pw = passwordTextView.text, pw != originalPassword || !pw.isEmpty {
            passwordTextView.layer.borderWidth = 1
            passwordTextView.layer.borderColor = UIColor.red.cgColor
            
            passwordLabel.text = "Wrong Password!"
            passwordLabel.font = UIFont.boldSystemFont(ofSize: 17)
            //passwordLabel.textColor = UIColor.red
        }
            
        else {
        
            let userData: Dictionary<String, AnyObject> = [
                "firstName": firstNameTextView.text! as AnyObject,
                "lastName": lastNameTextView.text! as AnyObject,
                "phoneNumber": phoneNumberTextView.text! as AnyObject
            ]
            
            dismiss(animated: true, completion: nil)
            onSave?(userData)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        activeField = textField
    }

    func textFieldDidEndEditing(_ textField: UITextField)
    {
        activeField = nil
    }



    


}
