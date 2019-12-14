//
//  CreatePostViewController.swift
//  AustinWeirdAutos
//
//  Created by Luis Santos on 10/31/19.
//  Copyright © 2019 Luis Santos. All rights reserved.
//

import UIKit
import Firebase


class CreatePostViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var picker: UIPickerView!
    
    @IBOutlet weak var modelYearTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var addedImage: UIImageView!
    @IBOutlet weak var createBtn: UIButton!
    
    var pickerMakers: [String] = [String]()
    var imagePicker: UIImagePickerController!
    
    var userAddedImage = false
    var currentUser: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self
        picker.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        modelYearTextField.keyboardType = UIKeyboardType.decimalPad
        
        pickerMakers = ["Acura", "Audi", "BMW", "Buick", "Cadillac", "Chevrolet", "Chrysler", "Dodge", "Ferrari", "Fiat", "Ford", "GMC", "Honda", "Hyundai", "Infiniti", "Jaguar", "Jeep", "Kia", "Lamborghini", "Land Rover", "Lexus", "Lincoln", "Mazda", "Mercedes-Benz", "Mini", "Mitsubishi", "Nissan", "Porsche", "Ram", "Scion", "Smart", "Subaru", "Tesla", "Toyota", "Volkswagen", "Volvo"]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerMakers[row]
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerMakers.count
    }
    
    
    @IBAction func addImageTapped(_ sender: Any) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            userAddedImage = true
            addedImage.image = img
        }
        
        imagePicker.dismiss(animated: true, completion: nil )
        
    }
    
    @IBAction func createBtnTapped(_ sender: Any) {
        
        guard let year = modelYearTextField.text, year.count > 3 && year.count < 5 else {
            
            //TODO: In your app alert user why they can't post
            print("LUIS: Model Year must be entered. Also checking if it is 4 digit")
            return
        }
        
        guard let model = modelTextField.text, model != "" else{
            
            //TODO: Show alert for bad model inserted
            print("LUIS: Model must be entered")
            return
        }
        
        guard let image = addedImage.image, userAddedImage == true else {
            
            print("LUIS: An image must be selected")
            return
        }
        
        if let imageData = UIImageJPEGRepresentation(image, 0.2) {
            
            let imageUid = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            self.showSpinner()
            
            DataService.ds.REF_WEIRD_IMAGES.child(imageUid).putData(imageData, metadata: metadata, completion: { (metadata, error) in
                
                if error != nil {
                    self.removeSpinner()
                    print("LUIS: Unable to upload image to firebase")
                } else {
                    
                    print("LUIS: Successfully uploaded image to firebase storage")
                    print("LUIS: Storage Base URL = \(DataService.ds.REF_WEIRD_IMAGES)")
                    
                    
                    if let name = metadata?.name {
                        print("LUIS: metadata.name = \(name)")
                        let forwardSlash = "/"
                        let url = "\(DataService.ds.REF_WEIRD_IMAGES)" + forwardSlash + name
                        
                        self.postToFirebase(imageUrl: url, imageUID: imageUid)
                    }
                }
            })
      
        }
        
        
    }
    
    func postToFirebase (imageUrl: String, imageUID: String) {
        
        let falseBool = false
        var picURLsDict: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
        picURLsDict[imageUID] = imageUrl as AnyObject
        
        let post: Dictionary<String, AnyObject> = [
            "description": "Need to add description" as AnyObject,
            "imageURLs": picURLsDict as AnyObject,
            "isComplete": falseBool as AnyObject,
            "isPublic": falseBool as AnyObject,
            "make": pickerMakers[picker.selectedRow(inComponent: 0)] as AnyObject,
            "model": modelTextField.text as AnyObject,
            "year": modelYearTextField.text as AnyObject,
            "userID": currentUser.userID as AnyObject,
            "likes": 0 as AnyObject
        ]
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        self.removeSpinner()
        
        dismiss(animated: true, completion: nil )
        
        print("Luis: new post \(post)")
    }
    
    
    @IBAction func backBtnTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil )
        
    }
    
}
