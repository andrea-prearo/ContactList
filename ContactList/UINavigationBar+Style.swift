//
//  UINavigationBar+Style.swift
//  ContactList
//
//  Created by Andrea Prearo on 3/24/16.
//  Copyright © 2016 Andrea Prearo
//

import UIKit

extension UINavigationController {

    func defaultNavigationBarStyle() {
        let image = UINavigationBar.appearance().backgroundImage(for: UIBarMetrics.default)
        navigationBar.setBackgroundImage(image, for:UIBarMetrics.default)
        navigationBar.isTranslucent = UINavigationBar.appearance().isTranslucent
        navigationBar.shadowImage = UINavigationBar.appearance().shadowImage
        navigationBar.tintColor = UINavigationBar.appearance().tintColor
        view.backgroundColor = UINavigationBar.appearance().backgroundColor
        navigationBar.titleTextAttributes = UINavigationBar.appearance().titleTextAttributes
    }

    func transparentNavigationBarStyle() {
        navigationBar.setBackgroundImage(UIImage(), for:UIBarMetrics.default)
        navigationBar.isTranslucent = true
        navigationBar.shadowImage = UIImage()
        navigationBar.tintColor = UIColor.white
        view.backgroundColor = UIColor.clear
    }
    
    func semiTransparentNavigationBarStyle() {
        let image = UIImage.imageWithColor(UIColor.defaultBackgroundColor())
        navigationBar.setBackgroundImage(image, for:UIBarMetrics.default)
        navigationBar.tintColor = UIColor.white
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    }

}
