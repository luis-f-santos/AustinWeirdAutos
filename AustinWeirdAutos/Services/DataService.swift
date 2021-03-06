//
//  DataService.swift
//  AustinWeirdAutos
//
//  Created by Luis Santos on 10/22/19.
//  Copyright © 2019 Luis Santos. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

let DB_BASE = Database.database().reference()
let STORAGE_BASE = Storage.storage().reference()
let MASTER_UID = "nJJEHE62dfUhbzKhZ2LsZRc4nqY2"

class DataService {
    
    static let ds = DataService()
    
    //DB references
    private var _REF_MASTER_UID = MASTER_UID
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    //Storage reference
    private var _REF_WEIRD_IMAGES = STORAGE_BASE.child("weird-pics")
    
    var REF_MASTER_UID: String {
        return _REF_MASTER_UID
    }
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    var REF_POSTS: DatabaseReference {
        return _REF_POSTS
    }
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_USER_CURRENT: DatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let user = REF_USERS.child(uid!)
        return user
    }
    
    var REF_WEIRD_IMAGES: StorageReference {
        return _REF_WEIRD_IMAGES
    }
    
    
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, AnyObject>) {
        
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    
    
}
