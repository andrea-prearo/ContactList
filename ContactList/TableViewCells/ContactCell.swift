//
//  ContactCell.swift
//  ContactList
//
//  Created by Andrea Prearo on 3/9/16.
//  Copyright © 2016 Andrea Prearo
//

import UIKit
import AlamofireImage

class ContactCell: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var company: UILabel!

    func configure(_ viewModel: ContactViewModel) {
        if let urlString = viewModel.avatarUrl, let url = URL(string: urlString) {
            let filter = RoundedCornersFilter(radius: avatar.frame.size.width * 0.5)
            avatar.af_setImage(withURL: url,
                               placeholderImage: UIImage.defaultAvatarImage(),
                               filter: filter)
        }
        username.text = viewModel.username
        company.text = viewModel.company
    }
}
