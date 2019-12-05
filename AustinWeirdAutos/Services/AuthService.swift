//
//  AuthService.swift
//  AustinWeirdAutos
//
//  Created by Luis Santos on 11/14/19.
//  Copyright © 2019 Luis Santos. All rights reserved.
//

import Foundation
import Firebase

typealias Completion = (_ errMsg: String?, _ data: AnyObject?, _ creatingNewUser: Bool?) -> Void

class AuthService {
    private static let _instance = AuthService()
    
    static var instance: AuthService {
        return _instance
    }
    
    func createNewUser(email: String, password: String, onComplete: Completion?) {
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                //Show error to user
                self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
            } else {
                if user?.user.uid != nil { // Firebase User ID created and exists now so Sign-in
                    Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                        
                        if error != nil {
                            //Show error to user
                            self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                        } else {
                            //SignIn successfull
                            onComplete?(nil, user, false)
                        }
                    })
                }
            }
        })
 
    }
    
    func login(email: String, password: String, onComplete: Completion?) {
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                if let errorCode = AuthErrorCode(rawValue: error!._code) {
                    
                    if errorCode == AuthErrorCode.userNotFound {
                        
                        //Prompt user to comfirm password to create new user
                        onComplete?(nil, user, true)

                    } else {
                        // Handle all other errors
                        self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                        
                    }
                }
            } else {
                //Successfully Signed in
                onComplete?(nil, user, false)
            }
        })
    }
    
    
    func handleFirebaseError(error: NSError, onComplete: Completion?) {
        print(error.debugDescription)
        if let errorCode = AuthErrorCode(rawValue: error.code) {
            switch (errorCode) {
            case AuthErrorCode.invalidEmail://.errorCodeInvalidEmail:
                onComplete?("Invalid email address", nil,  false)
                break
            case AuthErrorCode.wrongPassword://.errorCodeWrongPassword:
                onComplete?("Invalid password", nil, false)
                break
            case AuthErrorCode.tooManyRequests:
                onComplete?("Too many unsuccessful login attempts. Please try again later", nil, false)
                break
            case AuthErrorCode.emailAlreadyInUse/*.errorCodeEmailAlreadyInUse*/, AuthErrorCode.accountExistsWithDifferentCredential://.errorCodeAccountExistsWithDifferentCredential:
                onComplete?("Could not create account. Email already in use", nil, false)
                break
            default:
                onComplete?("There was a problem authenticating. Try again.", nil, false)
            }
        }
    }
    
    
    
}
