//
//  Auth.swift
//  ContactList
//
//  Created by Prearo, Andrea on 3/6/16.
//  Copyright © 2016 Prearo, Andrea. All rights reserved.
//

import Foundation
import Alamofire

typealias WebServiceAuthCompletionBlock = ((success: Bool, token: String?, error: NSError?) -> ())
typealias AuthResponse = Response<AnyObject, NSError>

class Auth {

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

    class func login(email email: String, password: String, completionBlock: WebServiceAuthCompletionBlock) {
        let parameters = [
            "email": email,
            "password": password
        ]

        Alamofire.request(
            .POST,
            WebServiceConstants.LogIn,
            parameters: parameters,
            encoding: .JSON)
        .responseJSON { response in
            if let error = verifyAuthenticationErrors(response) {
                completionBlock(success: false, token: nil, error: error)
                return
            }

            guard response.result.isSuccess else {
                if let error = response.result.error {
                    completionBlock(success: false, token: nil, error: error)
                } else {
                    completionBlock(success: false, token: nil, error: nil)
                }
                return
            }
            
            guard let jsonResponse = response.result.value as? [String: AnyObject] else {
                completionBlock(success: false, token: nil, error: nil)
                return
            }
            
            guard let token = jsonResponse["token"] as? String else {
                completionBlock(success: false, token: nil, error: nil)
                return
            }

            completionBlock(success: true, token: token, error: nil)
        }
    }

    class func register() {
    }

}
