//
//  Post.swift
//  AustinWeirdAutos
//
//  Created by Luis Santos on 10/27/19.
//  Copyright © 2019 Luis Santos. All rights reserved.
//

import Foundation

class Post {
    
    private var _year: String!
    private var _make: String!
    private var _model: String!
    private var _description: String!
    private var _isComplete: Bool!
    private var _isPublic: Bool!
    private var _imageURLs: [String]!
    private var _postID: String!
    
    
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
    
    var imageURLs: [String] {
        return _imageURLs
    }
    
    var postID: String {
        return _postID
    }
    
    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        
        _imageURLs = [String]()
        _postID = postKey
        
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
        if let year = postData["year"] as? String{
            _year = year
        }
        if let imageURLs = postData["imageURLs"] as? [String]{
            
            for url in imageURLs {
                _imageURLs.append(url)
            }
        }
        
        
        
    }
    
    
    
}
