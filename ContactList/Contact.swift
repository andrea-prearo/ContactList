//
//  Contact.swift
//  ContactList
//
//  Created by Prearo, Andrea on 3/5/16.
//  Copyright © 2016 Prearo, Andrea. All rights reserved.
//

import Foundation
import Alamofire

class Contact {
    
    let avatar: String
    let firstName: String
    let lastName: String
    let company: String
    let phone: Int
    let email: [String]
    let address: String
    let city: String
    let state: String
    let country: String
    let zipCode: Int

    init(avatar: String,
        firstName: String,
        lastName: String,
        company: String,
        phone: Int,
        email: [String],
        address: String,
        city: String,
        state: String,
        country: String,
        let zipCode: Int) {
        self.avatar = avatar
        self.firstName = firstName
        self.lastName = lastName
        self.company = company
        self.phone = phone
        self.email = email
        self.address = address
        self.city = city
        self.state = state
        self.country = country
        self.zipCode = zipCode
    }
    
    class func getAll(completionHandler: [Contact]) {
        Alamofire.request(
            .GET,
            "http://hidden-garden-53580.herokuapp.com/")
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching colors: \(response.result.error)")
                    //                    completion([PhotoColor]())
                    return
                }
                
                // 3.
                guard let responseJSON = response.result.value as? [String: AnyObject] else {
                    return
                }
                print(responseJSON)
                //                        completion([PhotoColor]())
                return
        }
    }

}