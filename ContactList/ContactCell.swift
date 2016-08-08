//
//  ContactCell.swift
//  ContactList
//
//  Created by Andrea Prearo on 3/9/16.
//  Copyright © 2016 Andrea Prearo
//

import UIKit

class ContactCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var company: UILabel!

    func configure(viewModel: ContactViewModel) {
        if let url = viewModel.avatarUrl {
            avatar.downloadImageFromUrl(url)
        }
        username.text = viewModel.username
        company.text = viewModel.company
    }

}
