//
//  UIColor+Style.swift
//  ContactList
//
//  Created by Prearo, Andrea on 3/25/16.
//  Copyright © 2016 Prearo, Andrea. All rights reserved.
//

import UIKit
import ChameleonFramework

extension UIColor {

    class func defaultGradientBackgroundColor() -> UIColor {
        let colors:[UIColor] = [
            UIColor.flatBlueColorDark(),
            UIColor.flatWhiteColor()
        ]
        return GradientColor(.TopToBottom, frame: UIScreen.mainScreen().bounds, colors: colors)
    }

    class func defaultBackgroundColor() -> UIColor {
        return UIColor.flatPowderBlueColorDark()
    }
    
    class func defaultContourColor() -> UIColor {
        return UIColor.flatGrayColor()
    }
    
}