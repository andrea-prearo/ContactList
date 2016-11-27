//
//  Phone.swift
//  ContactList
//
//  Created by Andrea Prearo on 3/19/16.
//  Copyright © 2016 Andrea Prearo
//

import Foundation
import Marshal

struct Phone {
    
    let label: String?
    let number: String?
    
    init(label: String?,
        number: String?) {
        self.label = label
        self.number = number
    }
    
}

extension Phone: Unmarshaling {
    
    init(object: MarshaledObject) {
        label = try? object.value(for: "label")
        number = try? object.value(for: "number")
    }
    
}

extension Phone: Equatable {}

func ==(lhs: Phone, rhs: Phone) -> Bool {
    return lhs.label == rhs.label &&
        lhs.number == rhs.number
}
