//
//  Email.swift
//  ContactList
//
//  Created by Prearo, Andrea on 3/19/16.
//  Copyright © 2016 Prearo, Andrea. All rights reserved.
//

import Foundation

class Email: Decodable {

    let label: String?
    let address: String?

    init?(label: String?,
        address: String?) {
        self.label = label
        self.address = address
    }

}

extension Email {

    static func decode(json: [String: AnyObject]) -> Email? {
        let label = json["label"] as? String
        let address = json["address"] as? String
        return Email(label: label,
            address: address)
    }

}

extension Email: Equatable {}

func ==(lhs: Email, rhs: Email) -> Bool {
    return lhs.label == rhs.label &&
        lhs.address == rhs.address
}
