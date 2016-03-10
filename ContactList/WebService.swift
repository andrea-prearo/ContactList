//
//  WebService.swift
//  ContactList
//
//  Created by Prearo, Andrea on 3/5/16.
//  Copyright © 2016 Prearo, Andrea. All rights reserved.
//

import Foundation
import Alamofire

class WebServiceConstants {

    // Token Header
    class var TokenHeader: String { return "x-access-token" }
    
    // Host
    class var HostAddress: String { return "http://hidden-garden-53580.herokuapp.com" }
    
    // Auth
    class var LogIn: String { return HostAddress + "/auth/login" }
    class var SignUp: String { return HostAddress + "/auth/register" }
    
    // Contacts
    class var Contacts: String { return HostAddress + "/api/contacts" }

}

class WebService {

    // Use custom error message instead of the defaule one provided by Alamofire's validate()
    class func verifyAuthenticationErrors(response: AuthResponse) -> NSError? {
        if let urlResponse = response.response,
            jsonResponse = response.result.value as? [String: AnyObject],
            message = jsonResponse["message"] {
                let authErrorCodes: Range<Int> = 400..<500
                if authErrorCodes.contains(urlResponse.statusCode) {
                    let userInfo = [ NSLocalizedDescriptionKey: message ]
                    return NSError.init(domain: "com.aprearo.ContactList", code: urlResponse.statusCode, userInfo: userInfo)
                }
        }
        return nil
    }
    
    class func ping(completionBlock: (success: Bool, error: NSError?) -> ()) {
        Alamofire.request(
            .GET,
            WebServiceConstants.HostAddress)
        .responseJSON { response in
            guard response.result.isSuccess else {
                if let error = response.result.error {
                    completionBlock(success: false, error: error)
                } else {
                    completionBlock(success: false, error: nil)
                }
                return
            }
            
            guard let jsonResponse = response.result.value as? [String: AnyObject] else {
                completionBlock(success: false, error: nil)
                return
            }
            
            guard let success = jsonResponse["success"] as? Bool else {
                completionBlock(success: false, error: nil)
                return
            }
            
            if !success {
                completionBlock(success: false, error: nil)
            }

            completionBlock(success: true, error: nil)
        }
    }
    
}
