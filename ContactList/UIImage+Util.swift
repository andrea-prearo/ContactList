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

    static func defaultAvatarImage() -> UIImage? {
        return UIImage(named: "Avatar")
    }

    static func imageWithColor(_ colour: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        colour.setFill()
        UIRectFill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }

}
