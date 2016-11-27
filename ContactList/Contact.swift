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
import Marshal

struct Contact {
    
    let avatar: String?
    let firstName: String?
    let lastName: String?
    let company: String?
    let phone: [Phone]?
    let email: [Email]?
    let location: [Location]?
    
    init(avatar: String?,
        firstName: String?,
        lastName: String?,
        company: String?,
        phone: [Phone]?,
        email: [Email]?,
        location: [Location]?) {
        self.avatar = avatar
        self.firstName = firstName
        self.lastName = lastName
        self.company = company
        self.phone = phone
        self.email = email
        self.location = location
    }
    
    static func getAll(_ completionBlock: @escaping (_ success: Bool, _ contacts: [Contact?]?, _ error: Error?) -> ()) {
        let account = AuthorizedUser.loadFromStore()
        if account.isFailure {
            completionBlock(false, nil, account.error)
            return
        }

        guard let token = account.value?.token else {
            completionBlock(false, nil, ErrorCodes.InvalidToken())
            return
        }

        Alamofire.request(
            WebServiceConstants.Contacts,
            headers: [WebServiceConstants.TokenHeader: token])
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

            guard let json = response.result.value as? [String: Any] else {
                completionBlock(false, nil, nil)
                return
            }

            let contacts: [Contact]? = try? json.value(for: "contacts")
            completionBlock(true, contacts, nil)
        }
    }
    
}

extension Contact: Unmarshaling {

    var fullName: String {
        let first = String.emptyForNilOptional(firstName)
        let last = String.emptyForNilOptional(lastName)
        return "\(first) \(last)"
    }

    var address: String {
        let firstLocation = location?.first
        if let location = firstLocation,
            let data = location.data {
            let city = String.emptyForNilOptional(data.city)
            let state = String.emptyForNilOptional(data.state)
            return "\(city), \(state)"
        } else {
            return ", "
        }
    }
    
    init(object: MarshaledObject) {
        avatar = try? object.value(for: "avatar")
        firstName = try? object.value(for: "firstName")
        lastName = try? object.value(for: "lastName")
        company = try? object.value(for: "company")
        phone = try? object.value(for: "phone")
        email = try? object.value(for: "email")
        location = try? object.value(for: "location")
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
