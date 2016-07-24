//
//  String+Util.swift
//  ContactList
//
//  Created by Andrea Prearo on 3/9/16.
//  Copyright © 2016 Andrea Prearo
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

    static func caseInsensitiveContains(optionalString: String?, searchText: String) -> Bool {
        guard let sourceString = optionalString else { return false }
        return sourceString.lowercaseString.containsString(searchText.lowercaseString)
    }
    
}
