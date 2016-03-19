//
//  ContactDetailViewController.swift
//  ContactList
//
//  Created by Prearo, Andrea on 3/19/16.
//  Copyright © 2016 Prearo, Andrea. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {

    var contact: Contact?
    
    private var viewModel: ContactDetailViewControllerViewModel?

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var company: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
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
