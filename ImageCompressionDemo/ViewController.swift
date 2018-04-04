//
//  ViewController.swift
//  ImageCompressionDemo
//
//  Created by Loaner on 4/3/18.
//  Copyright © 2018 baksha97. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: Image Picker Controller
    //Image picker will be used to visualize choosing image.
    let imagePicker = UIImagePickerController()
    /*
     If you are having an error output of:
        {Error Domain=PlugInKit Code=13 "query cancelled" UserInfo={NSLocalizedDescription=query cancelled}"}
     - Please ensure that you have included the proper properties in the Info.plist to access your device's components.
     
     -Go to:
        Product > Scheme > Edit Scheme > Environment Variables ---SET---> OS_ACTIVITY_MODE: disable
     ---- Known problem; seems to be due to the update to Swift 4 from Swift 3.
     */
    
    //MARK: UI Components
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var menuButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //initialize delegation for the image picker
        imagePicker.delegate = self
        //set fit for view controller image view
        imageView.contentMode = .scaleAspectFit
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func menuDidTap(_ sender: Any) {
        openMenu()
    }

    func openMenu(){
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
        
        // Present Alert
        self.present(alertController, animated: true, completion:nil)
    }

}

//Seperation of methods for this ViewController's protocols of UIImagePickerControllerDelegate & UINavigationControllerDelegate.
//Allows use to increase readability of our view and allows reuse by simply refactoring the extension name to the specified view.
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //parameter allows method to be reused with multiple sources.
    func selectPhoto(from type: UIImagePickerControllerSourceType){
        //crops photo to square to fit certain constraints; set to false if not prefered.
        imagePicker.allowsEditing = true
        imagePicker.sourceType = type
        present(imagePicker, animated: true, completion: nil)
    }
    
    //Swift 3 -> 4 changes require @objc in function header for this selector.
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //if we wanted to use the image without being cropped to a square
        //let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        //image that we have cropped
        let chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        //We will be running a debug test with our initial image to check compression & size reduction...
        if let chosenImageData = chosenImage.jpegData(compressed: .highest){ //used highest to keep original size
            print("initial image debug:")
            print(chosenImageData.debugDescription)
        }
        ///^This test can be removed during implementation.
        
        
        //Check/test to see if compressed image has been correctly compressed and does not equal nil (null)
        //lowest to show the most change in compression
        if let compressedImageData = chosenImage.jpegData(compressed: .lowest), let compressedImage = UIImage(data: compressedImageData) {
            print("compressed image debug:")
            print(compressedImageData.debugDescription)
            imageView.image = compressedImage
            /*
             IMPORTANT: In here, we would begin to perform any type of transaction for the image.
             Example: Uploading it to a server or storing on a device.
                When we store these types of data, we have the option of uploading the ImageData object itself, or we may convert it to a UIImage and then proceed.
                */
        }else{
            //Possible because: The image has no data or if the CGImageRef bitmap format isn't supported.
            print("The image has no data or if the CGImageRef bitmap format isn't supported.")
            //We can display a dialog of error if needed. 
        }

        dismiss(animated: true, completion: nil)
    }
    
    //Optional but expected in documentation
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
}

