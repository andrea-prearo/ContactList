//
//  ContactCellViewModel.swift
//  ContactList
//
//  Created by Andrea Prearo on 3/10/16.
//  Copyright © 2016 Andrea Prearo
//

import Foundation

class ContactCellViewModel {

    let avatarUrl: String?
    let username: String
    let company: String

    private let contact: Contact

    init(contact: Contact) {
        self.contact = contact

        // Avatar
        if let url = self.contact.avatar {
            avatarUrl = url
        } else {
            avatarUrl = nil
        }
        
        // Username
        username = contact.fullName
        
        // Company
        company = contact.company ?? ""
    }
    
}
