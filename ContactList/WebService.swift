//
//  WebService.swift
//  ContactList
//
//  Created by Prearo, Andrea on 3/5/16.
//  Copyright © 2016 Prearo, Andrea. All rights reserved.
//

import Foundation
import Alamofire

typealias WebServicePingCompletionBlock = ((success: Bool, error: NSError?) -> ())

class WebServiceConstants {
    
    // Host
    class var HostAddress: String { return "http://hidden-garden-53580.herokuapp.com" }
    
    // Auth
    class var LogIn: String { return HostAddress + "/auth/login" }
    class var SignUp: String { return HostAddress + "/auth/register" }
    
    // Contacts
    class var Contacts: String { return HostAddress + "/contacts" }

}

class WebService {

    class func ping(completionBlock: WebServicePingCompletionBlock) {
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
