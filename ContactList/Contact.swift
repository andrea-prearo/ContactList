//
//  Contact.swift
//  ContactList
//
//  Created by Andrea Prearo on 3/5/16.
//  Copyright © 2016 Andrea Prearo
//

import Foundation
import Alamofire
import Locksmith
import LiteJSONConvertible

struct Contact {
    
    let avatar: String?
    let firstName: String?
    let lastName: String?
    let company: String?
    let phone: [Phone?]?
    let email: [Email?]?
    let location: [Location?]?
    
    init(avatar: String?,
        firstName: String?,
        lastName: String?,
        company: String?,
        phone: [Phone?]?,
        email: [Email?]?,
        location: [Location?]?) {
        self.avatar = avatar
        self.firstName = firstName
        self.lastName = lastName
        self.company = company
        self.phone = phone
        self.email = email
        self.location = location
    }
    
    static func getAll(completionBlock: (success: Bool, contacts: [Contact?]?, error: NSError?) -> ()) {
        let account = AuthorizedUser.loadFromStore()
        if account.isFailure {
            completionBlock(success: false, contacts: nil, error: account.error)
            return
        }

        guard let token = account.value?.token else {
            completionBlock(success: false, contacts: nil, error: ErrorCodes.InvalidToken())
            return
        }

        Alamofire.request(
            .GET,
            WebServiceConstants.Contacts,
            headers: [WebServiceConstants.TokenHeader: token])
        .responseJSON { response in
            if let error = WebService.verifyAuthenticationErrors(response) {
                completionBlock(success: false, contacts: nil, error: error)
                return
            }
            
            guard response.result.isSuccess else {
                if let error = response.result.error {
                    completionBlock(success: false, contacts: nil, error: error)
                } else {
                    completionBlock(success: false, contacts: nil, error: nil)
                }
                return
            }

            guard let jsonResponse = response.result.value as? [JSON] else {
                completionBlock(success: false, contacts: nil, error: nil)
                return
            }

            let contacts = jsonResponse.map(Contact.decode)

            completionBlock(success: true, contacts: contacts, error: nil)
        }
    }
    
}

extension Contact: JSONDecodable {

    var fullName: String {
        let first = String.emptyForNilOptional(firstName)
        let last = String.emptyForNilOptional(lastName)
        return "\(first) \(last)"
    }

    static func decode(json: JSON) -> Contact? {
        return Contact(
            avatar: json <| "avatar",
            firstName: json <| "firstName",
            lastName: json <| "lastName",
            company: json <| "company",
            phone: json <|| "phone" >>> Phone.decode,
            email: json <|| "email" >>> Email.decode,
            location: json <|| "location" >>> Location.decode)
    }
    
}

extension Contact: Equatable {}

func ==(lhs: Contact, rhs: Contact) -> Bool {
    return lhs.avatar == rhs.avatar &&
        lhs.firstName == rhs.firstName &&
        lhs.lastName == rhs.lastName &&
        lhs.company == rhs.company &&
        lhs.phone == rhs.phone &&
        lhs.email == rhs.email &&
        lhs.location == rhs.location
}
