//
//  ContactDetailViewModel.swift
//  ContactList
//
//  Created by Andrea Prearo on 3/19/16.
//  Copyright © 2016 Andrea Prearo
//

import Foundation

class ContactDetailViewModel {
    
    let avatarUrl: String?
    let username: String
    let company: String
    let address: String
    
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
        company = String.emptyForNilOptional(contact.company)
        
        // Address
        address = contact.address
    }
    
}
