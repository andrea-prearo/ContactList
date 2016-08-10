//
//  UIImage+Util.swift
//  ContactList
//
//  Created by Andrea Prearo on 3/25/16.
//  Copyright © 2016 Andrea Prearo
//

import UIKit
import CoreGraphics

extension UIImage {

    static func imageWithColor(colour: UIColor) -> UIImage {
        let rect = CGRectMake(0, 0, 1, 1)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        colour.setFill()
        UIRectFill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }

}