//
//  Phone.swift
//  ContactList
//
//  Created by Andrea Prearo on 3/19/16.
//  Copyright © 2016 Andrea Prearo
//

import Foundation
import LiteJSONConvertible

struct Phone {
    
    let label: String?
    let number: String?
    
    init(label: String?,
        number: String?) {
        self.label = label
        self.number = number
    }
    
}

extension Phone: JSONDecodable {
    
    static func decode(json: JSON) -> Phone? {
        return Phone(
            label: json <| "label",
            number: json <| "number")
    }
    
}

extension Phone: Equatable {}

func ==(lhs: Phone, rhs: Phone) -> Bool {
    return lhs.label == rhs.label &&
        lhs.number == rhs.number
}
