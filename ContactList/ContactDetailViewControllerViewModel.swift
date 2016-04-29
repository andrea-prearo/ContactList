//
//  ContactDetailViewControllerViewModel.swift
//  ContactList
//
//  Created by Prearo, Andrea on 3/19/16.
//  Copyright © 2016 Prearo, Andrea. All rights reserved.
//

import Foundation

class ContactDetailViewControllerViewModel {
    
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
        company = String.emptyForNilOptional(contact.company)
    }
    
}
