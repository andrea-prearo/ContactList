//
//  Email.swift
//  ContactList
//
//  Created by Prearo, Andrea on 3/19/16.
//  Copyright © 2016 Prearo, Andrea. All rights reserved.
//

import Foundation
import LiteJSONConvertible

struct Email {
    
    let label: String?
    let address: String?
    
    init(label: String?,
        address: String?) {
        self.label = label
        self.address = address
    }
    
}

extension Email: JSONDecodable {
    
    static func decode(json: JSON) -> Email? {
        return Email(
            label: json <| "label",
            address: json <| "address")
    }
    
}

extension Email: Equatable {}

func ==(lhs: Email, rhs: Email) -> Bool {
    return lhs.label == rhs.label &&
        lhs.address == rhs.address
}
