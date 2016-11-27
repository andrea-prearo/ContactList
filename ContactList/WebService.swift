//
//  WebService.swift
//  ContactList
//
//  Created by Andrea Prearo on 3/5/16.
//  Copyright © 2016 Andrea Prearo
//

import Foundation
import Alamofire

class WebServiceConstants {

    private static var __once: () = { () -> Void in
            if let plistpath = Bundle.main.path(forResource: "APIEnvironments", ofType: "plist"),
                let plist = NSDictionary(contentsOfFile: plistpath) {
                dictionary = plist
            } else {
                dictionary = nil
            }
        }()

    fileprivate static var token: Int = 0
    fileprivate static var dictionary: NSDictionary?

    class var APIEnvironments: NSDictionary? {
        _ = WebServiceConstants.__once
        return dictionary
    }
    
    // Token Header
    class var TokenHeader: String { return "x-access-token" }
    
    // Host
    class var HostAddress: String {
        if let environments = WebServiceConstants.APIEnvironments,
            let selectedEnvironment = UserDefaults.standard.string(forKey: "environment"),
            let environmentDict = environments[selectedEnvironment] as? [String:String],
            let environment = environmentDict["HostAddress"] {
            return environment
        }
        return "http://hidden-garden-53580.herokuapp.com"
    }
    
    // Auth
    class var LogIn: String { return HostAddress + "/auth/login" }
    class var SignUp: String { return HostAddress + "/auth/register" }
    
    // Contacts
    class var Contacts: String { return HostAddress + "/api/contacts" }

}

class WebService {
    
    // Use custom error message instead of the default one provided by Alamofire's validate()
    static func verifyAuthenticationErrors(_ response: AuthResponse) -> Error? {
        if let urlResponse = response.response,
            let jsonResponse = response.result.value as? [String: AnyObject],
            let message = jsonResponse["message"] {
                let authErrorCodes: CountableRange<Int> = 400..<500
                if authErrorCodes.contains(urlResponse.statusCode) {
                    let userInfo = [ NSLocalizedDescriptionKey: message ]
                    return NSError.init(domain: "com.aprearo.ContactList", code: urlResponse.statusCode, userInfo: userInfo)
                }
        }
        return nil
    }
    
    static func ping(_ completionBlock: @escaping (_ success: Bool, _ error: Error?) -> ()) {
        Alamofire.request(WebServiceConstants.HostAddress)
        .responseJSON { response in
            guard response.result.isSuccess else {
                if let error = response.result.error {
                    completionBlock(false, error)
                } else {
                    completionBlock(false, nil)
                }
                return
            }
            
            guard let jsonResponse = response.result.value as? [String: AnyObject] else {
                completionBlock(false, nil)
                return
            }
            
            guard let success = jsonResponse["success"] as? Bool else {
                completionBlock(false, nil)
                return
            }
            
            if !success {
                completionBlock(false, nil)
            }

            completionBlock(true, nil)
        }
    }
    
}
