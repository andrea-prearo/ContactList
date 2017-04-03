//
//  ErrorCodes.swift
//  ContactList
//
//  Created by Andrea Prearo on 3/9/16.
//  Copyright © 2016 Andrea Prearo
//

import Foundation

class ErrorCodes {
    static func InvalidAuthorizedUser() -> NSError {
        let userInfo = [ NSLocalizedDescriptionKey: "Invalid authorized user" ]
        return NSError.init(domain: "com.aprearo.ContactList", code: 1, userInfo: userInfo)
    }

    static func InvalidToken() -> NSError {
        let userInfo = [ NSLocalizedDescriptionKey: "Invalid token" ]
        return NSError.init(domain: "com.aprearo.ContactList", code: 2, userInfo: userInfo)
    }
}
