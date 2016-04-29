//
//  Array+Equatable.swift
//  ContactList
//
//  Created by Prearo, Andrea on 4/29/16.
//  Copyright © 2016 Prearo, Andrea. All rights reserved.
//

import Foundation

//extension Array {
//
//    public func compare<T: CollectionType where T: Equatable>(lhs: T?, rhs: T?) -> Bool {
//        if let lhs = lhs,
//            rhs = rhs {
//            return lhs == rhs
//        } else {
//            return false
//        }
//    }
//
//}

//extension Array: Equatable { }

//func ==<T: Equatable>(lhs: T?, rhs: T?) -> Bool {
//    return false
//}
//
func ==<T: Equatable>(lhs: [T]?, rhs: [T]?) -> Bool {
    return false
}

func ==<T: Equatable>(lhs: [T?]?, rhs: [T?]?) -> Bool {
    return false
}
