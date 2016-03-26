//
//  LocationData.swift
//  ContactList
//
//  Created by Prearo, Andrea on 3/19/16.
//  Copyright © 2016 Prearo, Andrea. All rights reserved.
//

import Foundation

class LocationData: Decodable {
    
    let address: String?
    let city: String?
    let state: String?
    let country: String?
    let zipCode: String?
    
    init?(address: String?,
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

extension LocationData {
    
    static func decode(json: [String: AnyObject]) -> LocationData? {
        let address = json["address"] as? String
        let city = json["city"] as? String
        let state = json["state"] as? String
        let country = json["country"] as? String
        let zipCode = json["zipCode"] as? String
        return LocationData(address: address,
            city: city,
            state: state,
            country: country,
            zipCode: zipCode)
    }
    
}
