//
//  Email.swift
//  ContactList
//
//  Created by Andrea Prearo on 3/19/16.
//  Copyright © 2016 Andrea Prearo
//

import Foundation
import Marshal

struct Email {
    
    let label: String?
    let address: String?
    
    init(label: String?,
        address: String?) {
        self.label = label
        self.address = address
    }
    
}

extension Email: Unmarshaling {
    
    init(object: MarshaledObject) {
        label = try? object.value(for: "label")
        address = try? object.value(for: "address")
    }
    
}

extension Email: Equatable {}

func ==(lhs: Email, rhs: Email) -> Bool {
    return lhs.label == rhs.label &&
        lhs.address == rhs.address
}
