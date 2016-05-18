//
//  UIViewController+Util.swift
//  ContactList
//
//  Created by Andrea Prearo on 3/6/16.
//  Copyright © 2016 Andrea Prearo
//

import UIKit

extension UIViewController {

    func showError(title: String, message: String) {
        let alertController = UIAlertController(title: title,
            message: message,
            preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(OKAction)
        presentViewController(alertController, animated: true, completion: nil)
    }

}
