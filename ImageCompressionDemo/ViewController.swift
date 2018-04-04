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

class ViewController: UIViewController, ImagePickerControllerDelegate{
    

    //MARK: Custom Image Picker Controller - singular object prevents pollution in a UIViewController
    var picker: ImagePickerController?
    
    //MARK: UI Components
    @IBOutlet weak var imageView: UIImageView! //Image view will be used to visualize choosing image.
    @IBOutlet weak var menuButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        //REQUIRED TO USE CONVIENIENCE INIT TO SET THE VIEW CONTROLLER.
        picker = ImagePickerController(for: self)
        //set fit for view controller image view
        imageView.contentMode = .scaleAspectFit
    }

    //example of a "open menu button"
    @IBAction func menuDidTap(_ sender: Any) {
        if let picker = picker{
            picker.presentAlert()
        } else{
            //error handeling
            //fatalAsset() ---> because convienience init(){} must be used. 
        }
    }
    
    //required delegation method
    func imagePicker(picker: ImagePickerController, didSelectImage image: UIImage) {
        imageView.image = image
    }


}

