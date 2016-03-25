//
//  ContactDetailViewController.swift
//  ContactList
//
//  Created by Prearo, Andrea on 3/19/16.
//  Copyright © 2016 Prearo, Andrea. All rights reserved.
//

import UIKit
import ChameleonFramework

class ContactDetailViewController: UIViewController {

    var contact: Contact?
    
    private var viewModel: ContactDetailViewControllerViewModel?

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var company: UILabel!
    
    @IBOutlet weak var customBackgroundView: UIView!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setBackgroundColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }

    func setBackgroundColor() {
//        if let navigationController = navigationController {
//            navigationController.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
//            navigationController.navigationBar.shadowImage = UIImage()
//            navigationController.navigationBar.translucent = true
//            navigationController.view.backgroundColor = UIColor.clearColor()
//            navigationController.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
//            navigationController.navigationBar.shadowImage = UIImage()
//            navigationController.navigationBar.translucent = true
//            navigationController.navigationBar.opaque = false
//            navigationController.view.backgroundColor = UIColor.clearColor()
//        }
//        navigationController?.navigationBar.setup()
//        navigationController?.presentTransparentNavigationBar()

        let colors:[UIColor] = [
            UIColor.flatBlueColorDark(),
            UIColor.flatWhiteColor()
        ]
        customBackgroundView.backgroundColor = GradientColor(.TopToBottom, frame: customBackgroundView.frame, colors: colors)
    }
    
    func configure() {
        guard let contact = contact
        else {
            return
        }

        viewModel = ContactDetailViewControllerViewModel(contact: contact)
        guard let viewModel = viewModel
            else {
                return
        }

        if let url = viewModel.avatarUrl {
            avatar.downloadImageFromUrl(url)
        }
        username.text = viewModel.username
        company.text = viewModel.company
    }
    
}
