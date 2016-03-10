//
//  ContactCell.swift
//  ContactList
//
//  Created by Prearo, Andrea on 3/9/16.
//  Copyright © 2016 Prearo, Andrea. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var address: UILabel!

    private var viewModel: ContactCellViewModel?

    func configure(viewModel: ContactCellViewModel) {
        self.viewModel = viewModel

        username.text = viewModel.username
        address.text = viewModel.address
        if let url = viewModel.avatarUrl {
            avatar.downloadImageFromUrl(url)
        }
    }

}
