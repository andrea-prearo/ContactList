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

        setUpStyle()

        WebService.ping { [weak self] (success, error) -> () in
            if !success {
                dispatch_async(dispatch_get_main_queue()) {
                    let title = "Server Error"
                    if let error = error {
                        self?.showError(title, message: error.localizedDescription)
                    } else {
                        self?.showError(title, message:  NSLocalizedString("Connection failed.", comment: "Connection failed."))
                    }
                }
            }
        }
    }

    func setUpStyle() {
        view.backgroundColor = UIColor.defaultGradientBackgroundColor()

        submitButton.layer.cornerRadius = CGFloat(2.5)
        submitButton.clipsToBounds = true
        submitButton.setBackgroundImage(UIImage.imageWithColor(UIColor.clearColor()), forState: .Normal)
        let selectedImage = UIImage.imageWithColor(UIColor.flatWhiteColor())
        submitButton.setBackgroundImage(selectedImage, forState: .Highlighted)
        submitButton.setBackgroundImage(selectedImage, forState: .Selected)
        let titleColor = UIColor.flatBlackColorDark()
        submitButton.setTitleColor(UIColor.flatGrayColorDark(), forState: .Normal)
        submitButton.setTitleColor(titleColor, forState: .Highlighted)
        submitButton.setTitleColor(titleColor, forState: .Selected)
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
                                self?.showError(title, message: NSLocalizedString("Invalid authorization.", comment: "Invalid authorization."))
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
                                self?.showError(title, message: NSLocalizedString("Authentication failed.", comment: "Authentication failed."))
                            }
                        }
                    }
                }
        } else {
            let alertController = UIAlertController(
                title: NSLocalizedString("Input Error", comment: "Input Error"),
                message: NSLocalizedString("Please, enter email and password", comment: "Please, enter email and password"),
                preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .Default, handler: nil)
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }

}
