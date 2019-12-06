//
//  ContactViewController.swift
//  AustinWeirdAutos
//
//  Created by Luis Santos on 12/5/19.
//  Copyright © 2019 Luis Santos. All rights reserved.
//

import UIKit
import MapKit
import SwiftKeychainWrapper
import Firebase


class ContactViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(COMPANY_ADDRESS) { (placemarks, error) in
            
            if let placemark = placemarks?.first, let location = placemark.location {
                
                let mark = MKPointAnnotation()//(coordinate: location.coordinate)
                mark.coordinate = location.coordinate
                mark.title = COMPANY_NAME
                let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000)
                self.mapView.setRegion(coordinateRegion, animated: true)
                self.mapView.addAnnotation(mark)
            }
        }

        // Do any additional setup after loading the view.
    }

    @IBAction func signOutTapped(_ sender: Any) {
        
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("LUIS: ID removed from keychain \(keychainResult)")
        try! Auth.auth().signOut()
        dismiss(animated: true, completion: nil)
    }
    
}
