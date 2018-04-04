//
//  ViewController.swift
//  ImageCompressionDemo
//
//  Created by Loaner on 4/3/18.
//  Copyright © 2018 baksha97. All rights reserved.
//

/*
 If you are having an error output of:
 {Error Domain=PlugInKit Code=13 "query cancelled" UserInfo={NSLocalizedDescription=query cancelled}"}
 - Please ensure that you have included the proper properties in the Info.plist to access your device's components.
 
 -Go to:
 Product > Scheme > Edit Scheme > Environment Variables ---SET---> OS_ACTIVITY_MODE: disable
 ---- Known problem; seems to be due to the update to Swift 4 from Swift 3.
 */

import UIKit

class ViewController: UIViewController{

    //MARK: Custom Image Picker Controller - singular object prevents pollution in a UIViewController
    var picker1: ImagePickerController?
    var picker2: ImagePickerController?
    
    //MARK: UI Components
    @IBOutlet weak var imageView: UIImageView! //Image view will be used to visualize choosing image.    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set fit for view controller image view
        imageView.contentMode = .scaleAspectFit
        configurePickers()
    }
    
    func configurePickers(){
        picker1 = ImagePickerController(for: self, action: { (image) in
            
            /*
             IMPORTANT: In here ^^^, we would begin to perform any type of transaction for the image.
             Example: Uploading it to a server or storing on a device.
             When we store these types of data, we have the option of uploading the ImageData object itself, or we may convert it to a UIImage and then proceed.
             --- We would just need to change the ImagePickerAction handle.
            */
            
            print("action for picker 1")
            self.imageView.image = image
            print(image.debugDescription)
        })
        
        picker2 = ImagePickerController(for: self, action: { (image) in
            
            /*
             IMPORTANT: In here ^^^, we would begin to perform any type of transaction for the image.
             Example: Uploading it to a server or storing on a device.
             When we store these types of data, we have the option of uploading the ImageData object itself, or we may convert it to a UIImage and then proceed.
             --- We would just need to change the ImagePickerAction handle.
            */
            
            print("action for picker 2")
            self.imageView.image = image
            print(image.debugDescription)
        })
    }

    //example of a request to change picture through the user interface.
    @IBAction func button1DidTap(_ sender: Any) {
        if let picker = picker1{
            picker.presentAlert()
        } else{
            //error handeling
            //fatalAsset() ---> because init(){} must be used.
        }
    }
    
    @IBAction func button2DidTap(_ sender: Any) {
        if let picker = picker2{
            picker.presentAlert()
        } else{
            //error handeling
            //fatalAsset() ---> because init(){} must be used.
        }
    }


}

