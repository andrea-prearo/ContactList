//
//  Location.swift
//  ContactList
//
//  Created by Prearo, Andrea on 3/19/16.
//  Copyright © 2016 Prearo, Andrea. All rights reserved.
//

import Foundation

class Location: Decodable {

    let label: String?
    let data: LocationData?

    init?(label: String?,
        data: LocationData?) {
        self.label = label
        self.data = data
    }

}

extension Location {

    static func decode(json: [String: AnyObject]) -> Location? {
        let label = json["label"] as? String
        let data = LocationData.decode(json["data"] as? [String: AnyObject])
        return Location(label: label,
            data: data)
    }

}
