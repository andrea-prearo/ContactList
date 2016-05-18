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
    @IBOutlet weak var address: UILabel!

    private var viewModel: ContactCellViewModel?

    func configure(viewModel: ContactCellViewModel) {
        self.viewModel = viewModel

        if let url = viewModel.avatarUrl {
            avatar.downloadImageFromUrl(url)
        }
        username.text = viewModel.username
        address.text = viewModel.address
    }

}
