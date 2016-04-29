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
        username = contact.fullName
        
        // Address
        if let firstLocation = contact.location?.first,
            location = firstLocation,
            data = location.data {
            let city = String.emptyForNilOptional(data.city)
            let state = String.emptyForNilOptional(data.state)
            address = "\(city), \(state)"
        } else {
            address = ", "
        }
    }
    
}
