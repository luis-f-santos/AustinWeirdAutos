//
//  User.swift
//  AustinWeirdAutos
//
//  Created by Luis Santos on 10/26/19.
//  Copyright © 2019 Luis Santos. All rights reserved.
//

import Foundation

class User {
    
    private var _firstName: String!
    private var _lastName: String!
    private var _phoneNumber: String!
    private var _userID: String!
    
    
    
    var firstName: String {
        return _firstName
    }
    
    var lastName: String {
        return _lastName
    }
    
    var phoneNumber: String  {
        return _phoneNumber
    }
    
    var userID: String {
        return _userID
    }
    
    
    init(firstName: String, lastName: String, phoneNumber: String) {
        
        _firstName =  firstName
        _lastName = lastName
        _phoneNumber = phoneNumber
    }
    
    init(userKey: String, postData: Dictionary<String, AnyObject>) {
        
        _userID = userKey
        
        if let firstName = postData["firstName"] as? String{
            _firstName = firstName
        } else {
            _firstName = "Unknown"
        }
        
        if let lastName = postData["lastName"] as? String{
            _lastName = lastName
        } else {
            _lastName = "Unknown"
        }
        
        if let phoneNumber = postData["phoneNumber"] as? Int{
            _phoneNumber = "\(phoneNumber)"
        } else {
            _phoneNumber = "Unknown"
        }
        
        
    }
    
    
    
}
