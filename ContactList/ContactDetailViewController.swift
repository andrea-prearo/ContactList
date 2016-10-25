//
//  ContactDetailViewController.swift
//  ContactList
//
//  Created by Andrea Prearo on 3/19/16.
//  Copyright © 2016 Andrea Prearo
//

import UIKit
import AlamofireImage

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
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
        let screenSize = UIScreen.main.bounds
        scrollView.contentSize = CGSize(width: screenSize.width, height: screenSize.height + 1)
    }

    func setUpStyle() {
        view.backgroundColor = UIColor.defaultGradientBackgroundColor()

        mainInfoView.layer.cornerRadius = CGFloat(2.5)

        automaticallyAdjustsScrollViewInsets = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
    }

}

// MARK: Private Methods

private extension ContactDetailViewController {

    func configure() {
        guard let contact = contact
        else {
            return
        }

        let viewModel = ContactDetailViewModel(contact: contact)

        if let urlString = viewModel.avatarUrl, let url = URL(string: urlString) {
            let filter = RoundedCornersFilter(radius: avatar.frame.size.width * 0.5)
            avatar.af_setImageWithURL(url,
                                      placeholderImage: UIImage.defaultAvatarImage(),
                                      filter: filter)
        }
        username.text = viewModel.username
        company.text = viewModel.company
        address.text = viewModel.address
    }
    
}
