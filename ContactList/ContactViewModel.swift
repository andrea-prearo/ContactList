//
//  ContactViewModel.swift
//  ContactList
//
//  Created by Andrea Prearo on 3/10/16.
//  Copyright © 2016 Andrea Prearo
//

import Foundation

class ContactViewModel {

    let avatarUrl: String?
    let username: String
    let company: String

    init(contact: Contact) {
        // Avatar
        if let url = contact.avatar {
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
