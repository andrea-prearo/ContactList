//
//  Auth.swift
//  ContactList
//
//  Created by Andrea Prearo on 3/6/16.
//  Copyright © 2016 Andrea Prearo
//

import Foundation
import Alamofire

typealias WebServiceAuthCompletionBlock = ((_ success: Bool, _ token: String?, _ error: Error?) -> ())
typealias AuthResponse = DataResponse<Any>

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
            path,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default)
            .responseJSON { response in
                if let error = WebService.verifyAuthenticationErrors(response) {
                    completionBlock(false, nil, error)
                    return
                }
                
                guard response.result.isSuccess else {
                    if let error = response.result.error {
                        completionBlock(false, nil, error)
                    } else {
                        completionBlock(false, nil, nil)
                    }
                    return
                }
                
                guard let jsonResponse = response.result.value as? [String: AnyObject] else {
                    completionBlock(false, nil, nil)
                    return
                }
                
                guard let token = jsonResponse["token"] as? String else {
                    completionBlock(false, nil, nil)
                    return
                }
                
                completionBlock(true, token, nil)
        }
    }
    
}
