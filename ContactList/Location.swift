//
//  Location.swift
//  ContactList
//
//  Created by Prearo, Andrea on 3/19/16.
//  Copyright © 2016 Prearo, Andrea. All rights reserved.
//

import Foundation

class Location {

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
    
    static func decode(json: [[String: AnyObject]]) -> [Location?] {
        return json.map({
            return Location.decode($0)
        })
    }
    
    static func decode(json: [[String: AnyObject]]?) -> [Location?] {
        if let items = json {
            return Location.decode(items)
        } else {
            return []
        }
    }

}
