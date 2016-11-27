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
            UIColor.flatBlueDark,
            UIColor.flatWhite
        ]
        return GradientColor(.topToBottom, frame: UIScreen.main.bounds, colors: colors)
    }

    static func defaultBackgroundColor() -> UIColor {
        return UIColor.flatPowderBlueDark
    }

}
