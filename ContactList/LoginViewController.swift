//
//  LoginViewController.swift
//  ContactList
//
//  Created by Prearo, Andrea on 3/5/16.
//  Copyright © 2016 Prearo, Andrea. All rights reserved.
//

import UIKit
import Alamofire

typealias CompletionBlock = (Response<AnyObject, NSError> -> ())

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!

    var token: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        WebService.ping { (success, error) -> () in
            if !success {
                let title = "Server Error"
                if let error = error {
                    self.showError(title, message: error.localizedDescription)
                } else {
                    self.showError(title, message: "Connection failed.")
                }
            }
        }
    }
    
    @IBAction func submitButtonTapped(sender: AnyObject) {
        if let username = usernameTextField.text,
            let password = passwordTextField.text
            where !username.isEmpty && !password.isEmpty {
                Auth.login(email: username, password: password) { (success, token, error) -> () in
                    if let token = token where success {
                        self.token = token
                        self.performSegueWithIdentifier(SegueIdentifiers.AuthToContactsSegue.rawValue, sender: self)
                    } else {
                        let title = "Authentication Error"
                        if let error = error {
                            self.showError(title, message: error.localizedDescription)
                        } else {
                            self.showError(title, message: "Authentication failed.")
                        }
                    }
                }
        } else {
            let alertController = UIAlertController(title: "Input Error",
                message: "Please, enter email and password",
                preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier else {
            return
        }

        if identifier == SegueIdentifiers.AuthToContactsSegue.rawValue {
            if let contactsTableViewController = segue.destinationViewController as? ContactsTableViewController {
                contactsTableViewController.token = token
            }
        }
    }

}
