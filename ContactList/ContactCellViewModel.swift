//
//  ContactCellViewModel.swift
//  ContactList
//
//  Created by Prearo, Andrea on 3/10/16.
//  Copyright © 2016 Prearo, Andrea. All rights reserved.
//

import Foundation

class ContactCellViewModel {

    let avatarUrl: String?
    let username: String
    let address: String

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
        let firstName = String.emptyForNilOptional(contact.firstName)
        let lastName = String.emptyForNilOptional(contact.lastName)
        username = "\(firstName) \(lastName)"
        
        // Address
        let city = String.emptyForNilOptional(contact.city)
        let state = String.emptyForNilOptional(contact.state)
        address = "\(city), \(state)"
    }
    
}