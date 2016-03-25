//
//  Email.swift
//  ContactList
//
//  Created by Prearo, Andrea on 3/19/16.
//  Copyright © 2016 Prearo, Andrea. All rights reserved.
//

import Foundation

class Email {

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

    static func decode(json: [[String: AnyObject]]) -> [Email?] {
        return json.map({
            return Email.decode($0)
        })
    }

    static func decode(json: [[String: AnyObject]]?) -> [Email?] {
        if let items = json {
            return Email.decode(items)
        } else {
            return []
        }
    }

}