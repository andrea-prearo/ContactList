//
//  UIColor+Style.swift
//  ContactList
//
//  Created by Andrea Prearo on 3/25/16.
//  Copyright © 2016 Andrea Prearo
//

import UIKit
import ChameleonFramework

extension UIColor {

    static func defaultGradientBackgroundColor() -> UIColor {
        let colors:[UIColor] = [
            UIColor.flatBlueColorDark(),
            UIColor.flatWhiteColor()
        ]
        return GradientColor(.TopToBottom, frame: UIScreen.mainScreen().bounds, colors: colors)
    }

    static func defaultBackgroundColor() -> UIColor {
        return UIColor.flatPowderBlueColorDark()
    }

}
