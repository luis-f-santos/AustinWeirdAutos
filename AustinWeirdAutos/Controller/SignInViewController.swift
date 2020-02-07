//
//  ViewController.swift
//  AustinWeirdAutos
//
//  Created by Luis Santos on 10/11/19.
//  Copyright © 2019 Luis Santos. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var bottomBannerLbl: UILabel!
    
    var userData = Dictionary<String, AnyObject>();
    var activeField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(SignInViewController.keyboardWillAppear), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SignInViewController.keyboardWillDisappear), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
        
    deinit {
            //Stop listening for keyboard hide/show events
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }

    override func viewDidAppear(_ animated: Bool) {

        if let uid = KeychainWrapper.standard.string(forKey: KEY_UID) {

            if (DataService.ds.REF_MASTER_UID == uid) {
                performSegue(withIdentifier: "toCustomTabController", sender: nil)
            }
            else {
                
                performSegue(withIdentifier: "toCustomTabController", sender: uid)
            }
        }

    }
    
    @objc func keyboardWillAppear(notification: Notification){
        
        guard let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size else {
            return
        }
        
        if let activeField = self.activeField {
            
            let superPoint = SignInViewController.getConvertedPoint(self.view, baseView: activeField)
            let maxYpostition = (superPoint.y - activeField.frame.height) * -1
            let keyboardYposition = self.view.frame.height - keyboardSize.height

            if (maxYpostition > keyboardYposition){
                let yAxisMove = Int(maxYpostition) - Int(keyboardYposition)
                self.view.frame.origin.y =  -CGFloat(yAxisMove)
            }
        }
    }
    
    @objc func keyboardWillDisappear(notification: Notification){
        
        self.view.frame.origin.y = 0
    }

    @IBAction func loginTapped(_ sender: Any) {
        
        // if one or the other are empty we're just doing nothing
        if let email = emailTextField.text, let password = passwordTextField.text , (email.characters.count > 0 && password.characters.count > 0){
            
            AuthService.instance.login(email: email, password: password, onComplete: { (errMsg, data, isNewUser) in
                
                
                if(isNewUser! == true) {
                    
                    self.performSegue(withIdentifier: "toCreateNewUser", sender: password)
                    
                } else {
        
                    guard errMsg == nil else {
                    let alert = UIAlertController(title: "Error Authentication", message: errMsg, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                    }
                    
                    //Message is empty so login must've been
                    if let authData = data {
                        
                        self.userData["provider"] = authData.user.providerID as AnyObject
                        self.userData["email"] = email as AnyObject
                        self.userData["password"] = password as AnyObject
                        
                        self.completeSignIn(id: authData.user.uid, userData: self.userData)
                    }
                
                }
            })
            
//
        }
        else {
            //Email and password are blank... update bottom banner to show to user
            bottomBannerLbl.text = EMPTY_LOGIN_TEXT
            
        }
        
    }
    
    func createNewUser(_ data: Dictionary<String, AnyObject>) -> () {
        
        if let _ = data["firstName"] as? String, let _ = data["lastName"] as? String, let _ = data["phoneNumber"] as? String {
            
            self.userData = data
            
            if let email = emailTextField.text, let password = passwordTextField.text {
                
                AuthService.instance.createNewUser(email: email, password: password, onComplete: { (errMsg, data, isNewUser) in
                    
                    
                    guard errMsg == nil else {
                        let alert = UIAlertController(title: "Error Authentication", message: errMsg, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    
                    //Message is empty so login must've been successfull
                    print("LUIS: \(email) user authenticated with Firebase")
                    
                    if let authData = data {
                        
                        self.userData["provider"] = authData.user.providerID as AnyObject
                        self.userData["email"] = email as AnyObject
                        self.userData["password"] = password as AnyObject
                        
                        self.completeSignIn(id: authData.user.uid, userData: self.userData)
                    }
                    
                })
                
            }
            
        }
    
    }
    
    
    func completeSignIn(id: String, userData: Dictionary<String, AnyObject>){
        
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        KeychainWrapper.standard.set(id, forKey: KEY_UID)
        
        passwordTextField.text = ""
        self.userData = [:]
        
        if (DataService.ds.REF_MASTER_UID == id) {
            performSegue(withIdentifier: "toCustomTabController", sender: nil)
        }
        else {
            performSegue(withIdentifier: "toCustomTabController", sender: id)
        }
        
    }
    
    func cancelCreatingNewAccount() -> () {
        passwordTextField.text = ""
        emailTextField.text = ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toCreateNewUser" {
            if let createNewUserVC = segue.destination as? CreateNewUserModalViewController {
                if let password = sender as? String {
                    createNewUserVC.originalPassword = password
                    createNewUserVC.onSave = createNewUser
                    createNewUserVC.onCancel = cancelCreatingNewAccount
                }
            }
        }
        if segue.identifier == "toCustomTabController" {
            if let customTabVC = segue.destination as? CustomTabController {
                if let userID = sender as? String {
                    customTabVC.userID = userID
                }
            }
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
    
    static func getConvertedPoint(_ targetView: UIView, baseView: UIView)->CGPoint{
        var pnt = targetView.frame.origin
        if nil == targetView.superview{
            return pnt
        }
        var superView = targetView.superview
        while superView != baseView{
            pnt = superView!.convert(pnt, to: superView!.superview)
            if nil == superView!.superview{
                break
            }else{
                superView = superView!.superview
            }
        }
        return superView!.convert(pnt, to: baseView)
    }
        
    
}

