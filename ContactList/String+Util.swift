//
//  String+Util.swift
//  ContactList
//
//  Created by Prearo, Andrea on 3/9/16.
//  Copyright © 2016 Prearo, Andrea. All rights reserved.
//

import Foundation

extension String {

    static func emptyForNilOptional(optionalString: String?) -> String {
        let string: String
        if let unwrapped = optionalString {
            string = unwrapped
        } else {
            string = "?"
        }
        return string
    }

}
