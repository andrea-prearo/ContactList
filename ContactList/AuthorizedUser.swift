//
//  AuthorizedUser.swift
//  ContactList
//
//  Created by Andrea Prearo on 3/9/16.
//  Copyright © 2016 Andrea Prearo
//

import Foundation
import Locksmith
import Alamofire

class AuthorizedUser: ReadableSecureStorable, CreateableSecureStorable, DeleteableSecureStorable, GenericPasswordSecureStorable {

    class var StoreKey: String { return "AuthorizedUserKey" }

    let email: String?
    let password: String?
    let token: String?

    init?(email: String?, password: String?, token: String?) {
        self.email = email
        self.password = password
        self.token = token
    }

    // MARK: CreateableSecureStorable protocol methods

    var data: [String: Any] {
        let email: String
        if let unwrapped = self.email {
            email = unwrapped
        } else {
            email = ""
        }
        let password: String
        if let unwrapped = self.password {
            password = unwrapped
        } else {
            password = ""
        }
        let token: String
        if let unwrapped = self.token {
            token = unwrapped
        } else {
            token = ""
        }
        return [ "email": email as AnyObject, "password": password as AnyObject, "token": token as AnyObject ]
    }

    // MARK: GenericPasswordSecureStorable protocol methods

    let service = "ContactList"
    var account: String {
        if let email = email {
            return email
        } else {
            return ""
        }
    }
    
}

extension AuthorizedUser {
    
    static func decode(_ json: [String: AnyObject]) -> AuthorizedUser? {
        let email = json["email"] as? String
        let password = json["password"] as? String
        let token = json["token"] as? String
        return AuthorizedUser(email: email, password: password, token: token)
    }

    static func loadFromStore() -> Result<AuthorizedUser>  {
        if let accountData = Locksmith.loadDataForUserAccount(userAccount: AuthorizedUser.StoreKey),
            let account = AuthorizedUser.decode(accountData as [String : AnyObject]) {
            return .success(account)
        }

        return .failure(ErrorCodes.InvalidAuthorizedUser())
    }
        
}
