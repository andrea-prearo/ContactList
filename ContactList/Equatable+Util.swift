//
//  Array+Equatable.swift
//  ContactList
//
//  Created by Prearo, Andrea on 4/29/16.
//  Copyright © 2016 Prearo, Andrea. All rights reserved.
//

import Foundation

// MARK: Array comparison methods
// These methods couldn't put into an Array extension
// because of a current limitation of the type system
// https://forums.developer.apple.com/thread/7172

func ==<T: Equatable>(lhs: [T]?, rhs: [T]?) -> Bool {
    if let lhs = lhs,
        rhs = rhs {
            return lhs == rhs
    } else {
        return false
    }
}

func ==<T: Equatable>(lhs: [T?]?, rhs: [T?]?) -> Bool {
    if let lhs = lhs,
        rhs = rhs {
        if let lhsNonNil = lhs.unwrap(),
            rhsNonNil = rhs.unwrap()
        where lhsNonNil.count == rhsNonNil.count {
            return lhsNonNil == rhsNonNil
        } else {
            return false
        }
    } else {
        return false
    }
}
