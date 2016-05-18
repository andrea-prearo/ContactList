//
//  Location.swift
//  ContactList
//
//  Created by Andrea Prearo on 3/19/16.
//  Copyright © 2016 Andrea Prearo
//

import Foundation
import LiteJSONConvertible

struct Location {
    
    let label: String?
    let data: LocationData?
    
    init(label: String?,
        data: LocationData?) {
        self.label = label
        self.data = data
    }
    
}

extension Location: JSONDecodable {
    
    static func decode(json: JSON) -> Location? {
        return Location(
            label: json <| "label",
            data: json <| "data" >>> LocationData.decode)
    }
    
}

extension Location: Equatable {}

func ==(lhs: Location, rhs: Location) -> Bool {
    return lhs.label == rhs.label &&
        lhs.data == rhs.data
}
