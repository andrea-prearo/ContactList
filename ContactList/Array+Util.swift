//
//  Array+Util.swift
//  ContactList
//
//  Created by Andrea Prearo on 4/29/16.
//  Copyright © 2016 Andrea Prearo
//

// Array extension to unwrap optional elements
// http://stackoverflow.com/questions/33138712/function-arrayoptionalt-optionalarrayt

import Foundation

protocol OptionalType {
    associatedtype W
    var optional: W? { get }
}

extension Optional: OptionalType {
    typealias W = Wrapped

    var optional: W? { return self }
}

extension Array where Element: OptionalType {

    func unwrap() -> [Element.W]? {
        return reduce(Optional<[Element.W]>([])) {
            acc, e in
                acc.flatMap { a in
                    e.optional.map { a + [$0] }
            }
        }
    }

}

// Extensions to support a more functional approach to array handling

extension Array {
    
    func dropAtIndex(index: Int) -> [Element] {
        var copy = self
        copy.removeAtIndex(index)
        return copy
    }
    
}

extension Array where Element: Equatable {
    
    func drop(element: Element) -> [Element] {
        return filter({ $0 != element })
    }
    
}
