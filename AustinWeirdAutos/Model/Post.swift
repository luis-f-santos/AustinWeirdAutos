//
//  Post.swift
//  AustinWeirdAutos
//
//  Created by Luis Santos on 10/27/19.
//  Copyright © 2019 Luis Santos. All rights reserved.
//

import Foundation
import Firebase


class Post {
    
    
    private var _year: String!
    private var _make: String!
    private var _model: String!
    private var _description: String!
    private var _isComplete: Bool!
    private var _isPublic: Bool!
    private var _likes: Int!
    private var _imageURLs: [String]!
    private var _imageURLDict: Dictionary<String, AnyObject>!
    private var _postID: String!
    private var _userID: String!
    private var _dateCreated: String!
    
    private var _postRef: DatabaseReference!
    
    
    var year: String {
        return _year
    }
    
    var make: String  {
        return _make
    }
    
    var model: String {
        return _model
    }
    var description: String {
        return _description
    }
    
    var isComplete: Bool {
        return _isComplete
    }
    
    var isPublic: Bool  {
        return _isPublic
    }
    
    var likes: Int {
        return _likes
    }
    
    var imageURLs: [String] {
        return _imageURLs
    }
    
    var postID: String {
        return _postID
    }
    var userID: String {
        return _userID
    }
    
    var dateCreated: String {
        return _dateCreated
    }
    
    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        
        _imageURLs = [String]()
        _postID = postKey
        _postRef = DataService.ds.REF_POSTS.child(_postID)
        
        
        if let dateCreated = postData["dateCreated"] as? String{
            _dateCreated = dateCreated
        }else{
            _dateCreated = ""
        }
        if let description = postData["description"] as? String{
            _description = description
        }
        if let isComplete = postData["isComplete"] as? Bool{
            _isComplete = isComplete
        }
        if let isPublic = postData["isPublic"] as? Bool{
            _isPublic = isPublic
        }
        if let make = postData["make"] as? String{
            _make = make
        }
        if let model = postData["model"] as? String{
            _model = model
        }
        if let year = postData["year"] as? Int{
            _year = "\(year)"
        }else {
            let year = postData["year"] as? String
            _year = year
        }
        if let likes = postData["likes"] as? Int {
            _likes = likes
        }
        if let userID = postData["userID"] as? String{
            _userID  = userID
        }
        if let imageURLs = postData["imageURLs"] as? Dictionary<String, AnyObject> {
            
            _imageURLDict = imageURLs
            
            
            for (k,v) in (Array(imageURLs).sorted {$0.key < $1.key}) {
                
                _imageURLs.append(v as! String)
                print("sorted keys: \(k)")
            }
//            for url in imageURLs {
//                _imageURLs.append(url.value as! String)
//            }
        }

    }

    
    func saveNewDescription(newDescription: String){
        
        _description = newDescription
        _postRef.child("description").setValue(_description)
    }
    
    func savePublicStatus(status: Bool){
        
        _isPublic = status
        _postRef.child("isPublic").setValue(_isPublic)
    }
    
    func saveProgressStatus(status: Bool){
        
        _isComplete = status
        _postRef.child("isComplete").setValue(_isComplete)
    }
    
    func saveNewImageURL(imageUrl: String, imageUID: String) {
        
        _imageURLDict[imageUID] = imageUrl as AnyObject
        _postRef.child("imageURLs").setValue(_imageURLDict)
    }
    
    
}
