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

class SignInViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

//    override func viewDidAppear(_ animated: Bool) {
//
//        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
//
//            performSegue(withIdentifier: "toFeedVC", sender: nil)
//        }
//
//    }

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
                
                }
            })
            
//            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
//
//                if error != nil {  // Can't signIn, need to create user or handle error
//
//                    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
//
//                        if error != nil { //Couldn't create a new user due to badpassword, bad email, etc...
//
//                            //TODO: check error and display them to user
//                            print("LUIS: Unable to Authinticate with FireBase")
//
//
//                        } else { // Sucessfully created a new user
//
//                            print("LUIS: Successfully authenticated with Firebase")
//
//                            if let authData = user {
//
//                                let userData = ["provider": authData.user.providerID]
//                                self.completeSignIn(id: authData.user.uid, userData: userData)
//                            }
//                        }
//                    })
//
//
//                } else { // Successfully Authenticated with Firebase
//
//                    //NO errors, email and password match with firebase
//                    print("LUIS: Email user authenticated with Firebase")
//
//                    if let authData = user {
//                        let userData = ["provider": authData.user.providerID]
//                        self.completeSignIn(id: authData.user.uid, userData: userData)
//                    }
//                }
//            })
        }
        else {
            //Email and password are blank... update bottom banner to show to user
            
        }
        
    }
    
    
    func completeSignIn(id: String, userData: Dictionary<String, String>){
        
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        
        KeychainWrapper.standard.set(id, forKey: "uid")
        
        passwordTextField.text = ""
        
        performSegue(withIdentifier: "toUserList", sender: nil/*"exampleUser"*//*id*/)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "toCreateNewUser" {
            if let createNewUserVC = segue.destination as? CreateNewUserModalViewController {
                if let password = sender as? String {
                    createNewUserVC.originalPassword = password
                    
                }
            }
        }
        if segue.identifier == "toUserPostsVC" {
            if let userPostsListVC = segue.destination as? UserPostsViewController {
                if let userID = sender as? String {
                    userPostsListVC.userID = userID
                    
                }
            }
        }
        
        if segue.identifier == "toUserList" {
//            if let userListVC = segue.destination as? UserListViewController {
//                if let userID = sender as? String {
//                    userPostsListVC.userID = userID
//
//                }
//            }
        }
    }
        
    
}

