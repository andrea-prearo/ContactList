//
//  Auth.swift
//  ContactList
//
//  Created by Andrea Prearo on 3/6/16.
//  Copyright © 2016 Andrea Prearo
//

import Foundation
import Alamofire

typealias WebServiceAuthCompletionBlock = ((_ success: Bool, _ token: String?, _ error: NSError?) -> ())
typealias AuthResponse = Response<AnyObject, NSError>

class Auth {

    static func login(email: String, password: String, completionBlock: @escaping WebServiceAuthCompletionBlock) {
        authorize(email: email, password: password, path: WebServiceConstants.LogIn, completionBlock: completionBlock)
    }

    static func register(email: String, password: String, completionBlock: @escaping WebServiceAuthCompletionBlock) {
        authorize(email: email, password: password, path: WebServiceConstants.SignUp, completionBlock: completionBlock)
    }

}

private extension Auth {

    static func authorize(email: String,
        password: String,
        path: String,
        completionBlock: @escaping WebServiceAuthCompletionBlock) {
        let parameters = [
            "email": email,
            "password": password
        ]
        
        Alamofire.request(
            .POST,
            path,
            parameters: parameters,
            encoding: .JSON)
            .responseJSON { response in
                if let error = WebService.verifyAuthenticationErrors(response) {
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
    
}
