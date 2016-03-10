//
//  LoginViewController.swift
//  ContactList
//
//  Created by Prearo, Andrea on 3/5/16.
//  Copyright © 2016 Prearo, Andrea. All rights reserved.
//

import UIKit
import Alamofire
import Locksmith

typealias CompletionBlock = (Response<AnyObject, NSError> -> ())

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Debug
        usernameTextField.text = "user001@hidden-garden-53580.com"
        passwordTextField.text = "user001-1234"
        
        WebService.ping { [weak self] (success, error) -> () in
            if !success {
                dispatch_async(dispatch_get_main_queue()) {
                    let title = "Server Error"
                    if let error = error {
                        self?.showError(title, message: error.localizedDescription)
                    } else {
                        self?.showError(title, message: "Connection failed.")
                    }
                }
            }
        }
    }
    
    @IBAction func submitButtonTapped(sender: AnyObject) {
        if let username = usernameTextField.text,
            let password = passwordTextField.text
            where !username.isEmpty && !password.isEmpty {
                SpinnerOverlay.sharedInstance.show(view)
                Auth.login(email: username, password: password) { [weak self] (success, token, error) -> () in
                    SpinnerOverlay.sharedInstance.hide()
                    let title = "Authentication Error"
                    if let token = token where success {
                        guard let account = AuthorizedUser.init(email: username, password: password, token: token) else {
                            dispatch_async(dispatch_get_main_queue()) {
                                self?.showError(title, message: "Invalid authorization.")
                            }
                            return
                        }
                        let _ = try? account.deleteFromSecureStore()
                        let _ = try? account.createInSecureStore()
                        let _ = try? Locksmith.deleteDataForUserAccount(AuthorizedUser.StoreKey)
                        let _ = try? Locksmith.saveData(account.data, forUserAccount: AuthorizedUser.StoreKey)
                        self?.performSegueWithIdentifier(SegueIdentifiers.AuthToContactsSegue.rawValue, sender: self)
                    } else {
                        dispatch_async(dispatch_get_main_queue()) {
                            if let error = error {
                                self?.showError(title, message: error.localizedDescription)
                            } else {
                                self?.showError(title, message: "Authentication failed.")
                            }
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

}
