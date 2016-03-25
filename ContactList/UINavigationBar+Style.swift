//
//  UINavigationBar+Style.swift
//  ContactList
//
//  Created by Prearo, Andrea on 3/24/16.
//  Copyright © 2016 Prearo, Andrea. All rights reserved.
//

import UIKit

extension UINavigationController {

    func defaultNavigationBarStyle() {
        let image = UINavigationBar.appearance().backgroundImageForBarMetrics(UIBarMetrics.Default)
        navigationBar.setBackgroundImage(image, forBarMetrics:UIBarMetrics.Default)
        navigationBar.translucent = UINavigationBar.appearance().translucent
        navigationBar.shadowImage = UINavigationBar.appearance().shadowImage
        navigationBar.tintColor = UINavigationBar.appearance().tintColor
        view.backgroundColor = UINavigationBar.appearance().backgroundColor
        navigationBar.titleTextAttributes = UINavigationBar.appearance().titleTextAttributes
    }

    func transparentNavigationBarStyle() {
        navigationBar.setBackgroundImage(UIImage(), forBarMetrics:UIBarMetrics.Default)
        navigationBar.translucent = true
        navigationBar.shadowImage = UIImage()
        navigationBar.tintColor = UIColor.whiteColor()
        view.backgroundColor = UIColor.clearColor()
    }
    
    func semiTransparentNavigationBarStyle() {
        let image = UIImage.imageWithColor(UIColor.defaultBackgroundColor())
        navigationBar.setBackgroundImage(image, forBarMetrics:UIBarMetrics.Default)
        navigationBar.tintColor = UIColor.whiteColor()
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
    }

}
