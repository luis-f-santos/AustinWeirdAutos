//
//  util.swift
//  AustinWeirdAutos
//
//  Created by Luis Santos on 12/13/19.
//  Copyright © 2019 Luis Santos. All rights reserved.
//

import UIKit

fileprivate var aView : UIView?
var scrollView: UIScrollView?

extension UIViewController {
    
    func showSpinner() {
        
        aView = UIView(frame: self.view.bounds)
        aView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        ai.center = aView!.center
        ai.startAnimating()
        aView?.addSubview(ai)
        self.view.addSubview(aView!)
        
    }
    
    func removeSpinner() {
        aView?.removeFromSuperview()
        aView = nil
        
    }
    
}
