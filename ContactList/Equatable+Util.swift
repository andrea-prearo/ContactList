//
//  Array+Equatable.swift
//  ContactList
//
//  Created by Andrea Prearo on 4/29/16.
//  Copyright © 2016 Andrea Prearo
//

import Foundation

// MARK: Array comparison methods
// These methods couldn't put into an Array extension
// because of a current limitation of the type system
// https://forums.developer.apple.com/thread/7172

func ==<T: Equatable>(lhs: [T]?, rhs: [T]?) -> Bool {
    switch (lhs,rhs) {
    case (.Some(let lhs), .Some(let rhs)):
        return lhs == rhs
    case (.None, .None):
        return true
    default:
        return false
    }
}

func ==<T: Equatable>(lhs: [T?]?, rhs: [T?]?) -> Bool {
    switch (lhs,rhs) {
    case (.Some(let lhs), .Some(let rhs)):
        if let lhsNonNil = lhs.unwrap(),
            rhsNonNil = rhs.unwrap()
            where lhsNonNil.count == rhsNonNil.count {
            return lhsNonNil == rhsNonNil
        } else {
            return false
        }
    case (.None, .None):
        return true
    default:
        return false
    }
}
