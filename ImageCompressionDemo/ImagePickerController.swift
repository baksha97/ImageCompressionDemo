//
//  ImagePickerController.swift
//  ImageCompressionDemo
//
//  Created by Loaner on 4/3/18.
//  Copyright © 2018 baksha97. All rights reserved.
//

import UIKit

//Modular approach

typealias ImagePickerAction = (UIImage) -> Void


//Single class may be used for clean reuse of code and to prevent pollution of a UIViewController.
class ImagePickerController: NSObject{
    
    //MARK: Components
    lazy var imagePicker = UIImagePickerController() //lazy init for memory - will not initialize until first accessed
    //opinional values used due to the possibility of initializing class with nil values
    var alertController: UIAlertController!
    var viewController: UIViewController!
    
    //saving the action to be completed
    var action: ImagePickerAction
    
    
    //usage of specific paramaters to guarantee that this UIViewController also conforms to the delegate protocol.
    init(for viewController: UIViewController, action: @escaping ImagePickerAction){
        self.viewController = viewController
        self.action = action
        super.init()
        self.configureAlertController()
    }
    
    //public method, will not proceed with presentation if view controller has not been set due to opinional value
    func presentAlert(){
        viewController.present(alertController!, animated: true)
    }
    
    //configure generic alert contorller
    private func configureAlertController(){
        // Create alert of type .alert
        // If preferred, we may change to action sheet for a different type of interface view.
        let alertController = UIAlertController(title: "Select Image",
                                                message: "Choose Location of Image",
                                                preferredStyle: .alert)
        
        
        // Open Camera
        let cameraAction = UIAlertAction(title: "Open Camera",
                                         style: .default,
                                         handler: { (action:UIAlertAction!) in
                                            print ("Selecting photo from camera")
                                            self.selectPhoto(from: .camera)
        })
        //Open Gallery
        let galleryAction = UIAlertAction(title: "Choose Image From Gallery",
                                          style: .default,
                                          handler: { (action:UIAlertAction!) in
                                            print ("Selecting photo from library")
                                            self.selectPhoto(from: .photoLibrary)
        })
        
        //Add actions to menu
        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        
        // Cancel action
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: { (action:UIAlertAction!) in
                                            print ("Cancel")
        })
        alertController.addAction(cancelAction)
        self.alertController = alertController
    }

}



//Seperation of methods for this OBJECT'S protocols of UIImagePickerControllerDelegate & UINavigationControllerDelegate.
//Allows use to increase readability of our view and allows reuse by simply refactoring the extension name - if needed.
extension ImagePickerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
//MARK: Delegation methods
    
    //parameter allows method to be reused with multiple sources.
    private func selectPhoto(from type: UIImagePickerControllerSourceType){
        //crops photo to square to fit certain constraints; set to false if not prefered.
        if UIImagePickerController.isSourceTypeAvailable(type){
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = type
            self.viewController.present(imagePicker, animated: true, completion: nil)
        }else{
            print("access not allowed")
        }
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //if we wanted to use the image without being cropped to a square
        //let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        //image that we have cropped
        let chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        //We will be running a debug test with our initial image to check compression & size reduction...
        if let chosenImageData = chosenImage.jpegData(compressed: .highest){ //used highest to keep original size to show comparison
            print("initial image debug:")
            print(chosenImageData.debugDescription)
        }
        ///^This test can be removed during implementation.
        
        
        //Check/test to see if compressed image has been correctly compressed and does not equal nil (null)
        //lowest to show the most change in compression
        if let compressedImageData = chosenImage.jpegData(compressed: .lowest), let compressedImage = UIImage(data: compressedImageData) {
            print("compressed image debug:")
            print(compressedImageData.debugDescription)
            
            //an action may not be set, we can use an if-let for a more intuitive error checking
            action(compressedImage)
            
    
        }else{
            //Possible because: The image has no data or if the CGImageRef bitmap format isn't supported.
            print("The image has no data or if the CGImageRef bitmap format isn't supported.")
            //We can display a dialog of error if needed.
            //fatalError() if closing application is more relevant to context of usage.
        }
        
        self.viewController.dismiss(animated: true, completion: nil)
    }
    
    //Optional but expected in documentation
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.viewController.dismiss(animated: true, completion:nil)
    }
}
