//
//  ErrorCodes.swift
//  ContactList
//
//  Created by Prearo, Andrea on 3/9/16.
//  Copyright © 2016 Prearo, Andrea. All rights reserved.
//

import Foundation

class ErrorCodes {

    class func InvalidAuthorizedUser() -> NSError {
        let userInfo = [ NSLocalizedDescriptionKey: "Invalid authorized user" ]
        return NSError.init(domain: "com.aprearo.ContactList", code: 1, userInfo: userInfo)
    }

    class func InvalidToken() -> NSError {
        let userInfo = [ NSLocalizedDescriptionKey: "Invalid token" ]
        return NSError.init(domain: "com.aprearo.ContactList", code: 2, userInfo: userInfo)
    }

}
