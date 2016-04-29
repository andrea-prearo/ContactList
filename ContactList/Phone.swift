//
//  Phone.swift
//  ContactList
//
//  Created by Prearo, Andrea on 3/19/16.
//  Copyright © 2016 Prearo, Andrea. All rights reserved.
//

import Foundation

class Phone: Decodable {
    
    let label: String?
    let number: String?
    
    init?(label: String?,
        number: String?) {
        self.label = label
        self.number = number
    }
    
}

extension Phone {
    
    static func decode(json: [String: AnyObject]) -> Phone? {
        let label = json["label"] as? String
        let number = json["number"] as? String
        return Phone(label: label,
            number: number)
    }

}

extension Phone: Equatable {}

func ==(lhs: Phone, rhs: Phone) -> Bool {
    return lhs.label == rhs.label &&
        lhs.number == rhs.number
}
