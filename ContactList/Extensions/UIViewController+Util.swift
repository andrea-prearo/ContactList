//
//  UIViewController+Util.swift
//  ContactList
//
//  Created by Andrea Prearo on 3/6/16.
//  Copyright © 2016 Andrea Prearo
//

import UIKit

extension UIViewController {

    func showError(_ title: String, message: String) {
        let alertController = UIAlertController(title: title,
            message: message,
            preferredStyle: .alert)
        let OKString = NSLocalizedString("OK", comment: "OK")
        let OKAction = UIAlertAction(title: OKString, style: .default, handler: nil)
        alertController.addAction(OKAction)
        present(alertController, animated: true, completion: nil)
    }

}
