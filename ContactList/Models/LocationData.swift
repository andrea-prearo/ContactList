//
//  LocationData.swift
//  ContactList
//
//  Created by Andrea Prearo on 3/19/16.
//  Copyright © 2016 Andrea Prearo
//

import Foundation
import Marshal

struct LocationData {
    
    let address: String?
    let city: String?
    let state: String?
    let country: String?
    let zipCode: String?
    
    init(address: String?,
        city: String?,
        state: String?,
        country: String?,
        zipCode: String?) {
        self.address = address
        self.city = city
        self.state = state
        self.country = country
        self.zipCode = zipCode
    }
    
}

extension LocationData: Unmarshaling {
    
    init(object: MarshaledObject) {
        address = try? object.value(for: "address")
        city = try? object.value(for: "city")
        state = try? object.value(for: "state")
        country = try? object.value(for: "country")
        zipCode = try? object.value(for: "zipCode")
    }
    
}

extension LocationData: Equatable {}

func ==(lhs: LocationData, rhs: LocationData) -> Bool {
    return lhs.address == rhs.address &&
        lhs.city == rhs.city &&
        lhs.state == rhs.state &&
        lhs.country == rhs.country &&
        lhs.zipCode == rhs.zipCode
}
