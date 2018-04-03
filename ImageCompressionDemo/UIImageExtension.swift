//
//  UIImageExtension.swift
//  ImageCompressionDemo
//
//  Created by Loaner on 4/3/18.
//  Copyright © 2018 baksha97. All rights reserved.
//

import UIKit

extension UIImage {
    
    //  The compression quality Enum allows us to keep our code clean rather than hard coding specific Float.
    //  Layering our code in such a way allows us to spot errors early on when changes are made that could lead to inconsistencies.
    enum JPEGCompressionQualityRate: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    //  We will return an image data object in JPEG format because UIImageJPEGRepresentation allows us to conveniently compress our objects with a Float that is less than 1, but more than 0.
    //  If a specific compression rate is consistently preferred, we can remove the enum and replace the parameter.
    
    func jpegData(compressed rate: JPEGCompressionQualityRate) -> Data? {
        return UIImageJPEGRepresentation(self, rate.rawValue)
    }
}
