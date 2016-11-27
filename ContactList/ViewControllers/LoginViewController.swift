//
//  LoginViewController.swift
//  ContactList
//
//  Created by Andrea Prearo on 3/5/16.
//  Copyright © 2016 Andrea Prearo
//

import UIKit
import Alamofire
import Locksmith
import SVProgressHUD

typealias CompletionBlock = ((DataResponse<AnyObject>) -> ())

enum LoginViewControllerSegmentIndex: Int {
    case logIn = 0
    case signUp = 1
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpStyle()

        // Debug
        usernameTextField.text = "user001@hidden-garden-53580.com"
        passwordTextField.text = "user001-1234"
        
        WebService.ping { [weak self] (success, error) -> () in
            if !success {
                DispatchQueue.main.async {
                    guard let strongSelf = self else { return }
                    let title = NSLocalizedString("Server Error", comment: "Server Error")
                    if let error = error {
                        strongSelf.showError(title, message: error.localizedDescription)
                    } else {
                        strongSelf.showError(title, message: NSLocalizedString("Connection failed.", comment: "Connection failed."))
                    }
                }
            }
        }
    }

}

// MARK: Private Methods

private extension LoginViewController {

    func setUpStyle() {
        view.backgroundColor = UIColor.defaultGradientBackgroundColor()
        navigationController?.defaultNavigationBarStyle()

        submitButton.layer.cornerRadius = CGFloat(2.5)
        submitButton.clipsToBounds = true
        submitButton.setBackgroundImage(UIImage.imageWithColor(UIColor.clear), for: UIControlState())
        let selectedImage = UIImage.imageWithColor(UIColor.flatWhite)
        submitButton.setBackgroundImage(selectedImage, for: .highlighted)
        submitButton.setBackgroundImage(selectedImage, for: .selected)
        let titleColor = UIColor.flatBlackDark
        submitButton.setTitleColor(UIColor.flatGrayDark, for: .normal)
        submitButton.setTitleColor(titleColor, for: .highlighted)
        submitButton.setTitleColor(titleColor, for: .selected)
    }

    @IBAction func submitButtonTapped(_ sender: AnyObject) {
        if let username = usernameTextField.text,
            let password = passwordTextField.text
            , !username.isEmpty && !password.isEmpty {
            SVProgressHUD.show()
            let completionBlock: WebServiceAuthCompletionBlock = {
                [weak self] (success, token, error) -> () in
                SVProgressHUD.dismiss()
                let title = NSLocalizedString("Authentication Error", comment: "Authentication Error")
                guard let strongSelf = self else { return }
                if let token = token , success {
                    guard let account = AuthorizedUser.init(email: username, password: password, token: token) else {
                        DispatchQueue.main.async {
                            strongSelf.showError(title, message: NSLocalizedString("Invalid authorization.", comment: "Invalid authorization."))
                        }
                        return
                    }
                    let _ = try? account.deleteFromSecureStore()
                    let _ = try? account.createInSecureStore()
                    let _ = try? Locksmith.deleteDataForUserAccount(userAccount: AuthorizedUser.StoreKey)
                    let _ = try? Locksmith.saveData(data: account.data, forUserAccount: AuthorizedUser.StoreKey)
                    strongSelf.performSegue(withIdentifier: SegueIdentifiers.AuthToContactsSegue.rawValue, sender: self)
                } else {
                    DispatchQueue.main.async {
                        if let error = error {
                            strongSelf.showError(title, message: error.localizedDescription)
                        } else {
                            strongSelf.showError(title, message: NSLocalizedString("Authentication failed.", comment: "Authentication failed."))
                        }
                    }
                }
            }
            if segmentedControl.selectedSegmentIndex == LoginViewControllerSegmentIndex.logIn.rawValue {
                Auth.login(email: username, password: password, completionBlock: completionBlock)
            } else if segmentedControl.selectedSegmentIndex == LoginViewControllerSegmentIndex.signUp.rawValue {
                Auth.register(email: username, password: password, completionBlock: completionBlock)
            }
        } else {
            let alertController = UIAlertController(
                title: NSLocalizedString("Input Error", comment: "Input Error"),
                message: NSLocalizedString("Please, enter email and password", comment: "Please, enter email and password"),
                preferredStyle: .alert)
            let OKAction = UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

}
