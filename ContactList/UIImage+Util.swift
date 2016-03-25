//
//  UIImage+Util.swift
//  ContactList
//
//  Created by Prearo, Andrea on 3/25/16.
//  Copyright © 2016 Prearo, Andrea. All rights reserved.
//

import UIKit
import CoreGraphics

extension UIImage {

    class func imageWithColor(colour: UIColor) -> UIImage {
        let rect = CGRectMake(0, 0, 1, 1)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        colour.setFill()
        UIRectFill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }

}