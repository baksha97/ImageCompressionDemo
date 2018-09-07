# ImageCompressionDemo

Custom Image Picker Controller - singular object prevents pollution in a UIViewController.
> Use this custom object to delegate, compress quality, and perform an action with images in iOS.
> Comments in code can be used to understand how things are done. 

# Example usage:
Addition of an compression quality enum:
```Swift
enum JPEGCompressionQualityRate: CGFloat {
    case lowest  = 0
    case low     = 0.25
    case medium  = 0.5
    case high    = 0.75
    case highest = 1
    
    case profilePicture = 0.2 // an example of a default compression setting that may be applicable.
}
```

Configuring each picker:

```Swift
picker1 = ImageCompressionPicker(for: self, compressionQualityRate: .lowest, action: { (image) in
            
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
```
-------------------------------------   
```Swift
picker2 = ImageCompressionPicker(for: self, compressionQualityRate: .lowest, action: { (image) in

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
```

Presenting:
```Swift
//example of a request to change picture through the user interface.
@IBAction func button1DidTap(_ sender: Any) {
            if let picker = picker1{
              picker.presentAlert()
            } else{
                         //error handeling
                        //fatalAsset() ---> because init(){} must be used.
            }
}
```
