//
//  ContactDetailViewController.swift
//  ContactList
//
//  Created by Andrea Prearo on 3/19/16.
//  Copyright © 2016 Andrea Prearo
//

import UIKit

class ContactDetailViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!

    var contact: Contact?

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var customBackgroundView: UIView!
    @IBOutlet weak var mainInfoView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpStyle()
        configure()
    }

    override func viewWillLayoutSubviews() {
        scrollView.contentOffset = CGPointMake(0, 0)
        let screenSize = UIScreen.mainScreen().bounds
        scrollView.contentSize = CGSizeMake(screenSize.width, screenSize.height + 1)
    }

    func setUpStyle() {
        view.backgroundColor = UIColor.defaultGradientBackgroundColor()

        mainInfoView.layer.cornerRadius = CGFloat(2.5)

        automaticallyAdjustsScrollViewInsets = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
    }

    func configure() {
        guard let contact = contact
        else {
            return
        }

        let viewModel = ContactDetailViewModel(contact: contact)

        if let url = viewModel.avatarUrl {
            avatar.downloadImageFromUrl(url)
        }
        username.text = viewModel.username
        company.text = viewModel.company
        address.text = viewModel.address
    }
    
}
