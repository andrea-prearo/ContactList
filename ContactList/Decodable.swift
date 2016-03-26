//
//  Decodable.swift
//  ContactList
//
//  Created by Prearo, Andrea on 3/25/16.
//  Copyright © 2016 Prearo, Andrea. All rights reserved.
//

import Foundation

protocol Decodable {
    typealias DecodableType

    static func decode(json: [String: AnyObject]) -> DecodableType?
    static func decode(json: [String: AnyObject]?) -> DecodableType?
    static func decode(json: [[String: AnyObject]]) -> [DecodableType?]
    static func decode(json: [[String: AnyObject]]?) -> [DecodableType?]
}

extension Decodable {

    static func decode(json: [String: AnyObject]?) -> DecodableType? {
        if let item = json {
            return decode(item)
        } else {
            return nil
        }
    }
    
    static func decode(json: [[String: AnyObject]]) -> [DecodableType?] {
        return json.map({
            return decode($0)
        })
    }
    
    static func decode(json: [[String: AnyObject]]?) -> [DecodableType?] {
        if let items = json {
            return decode(items)
        } else {
            return []
        }
    }

}
