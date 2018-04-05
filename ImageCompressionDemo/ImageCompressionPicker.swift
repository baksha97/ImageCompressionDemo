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
class ImageCompressionPicker: NSObject{
    
    //MARK: Components
    private lazy var imagePicker = UIImagePickerController() //lazy init for memory - will not initialize until first accessed
    //non opinional values used due to no possibility of initializing class with nil values
    private var alertController: UIAlertController!
    private var viewController: UIViewController!
    private var compressionQualityRate: JPEGCompressionQualityRate!
    //saving the action to be completed
    //allows for multiple instances in on view controller to perform different actions.
    private var action: ImagePickerAction
    
    
    //usage of specific paramaters to guarantee that this UIViewController also conforms to the delegate protocol.
    init(for viewController: UIViewController, compressionQualityRate: JPEGCompressionQualityRate, action: @escaping ImagePickerAction){
        self.viewController = viewController
        self.compressionQualityRate = compressionQualityRate
        self.action = action
        super.init()
        // instance variables should be configured prior to super.init(), but we cannot call self functions until after.
        self.configureAlertController()
        // we may only use this customization function after super.init().
    }
    
    //public function to present alert
    public func presentAlert(){
        viewController.present(alertController, animated: true)
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
extension ImageCompressionPicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
//MARK: Delegation methods
    
    //parameter allows method to be reused with multiple sources.
    private func selectPhoto(from type: UIImagePickerControllerSourceType){
        if UIImagePickerController.isSourceTypeAvailable(type){
            imagePicker.delegate = self
            imagePicker.allowsEditing = true //crops photo to square to fit certain constraints; set to false if not prefered.
            imagePicker.sourceType = type
            self.viewController.present(imagePicker, animated: true, completion: nil)
        }else{
            //May implement an ask dialog to ask for specific type settings.
            print("Unable to access data for type: \(type)")
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
        if let compressedImageData = chosenImage.jpegData(compressed: compressionQualityRate), let compressedImage = UIImage(data: compressedImageData) {
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
