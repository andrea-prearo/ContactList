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
    typealias W
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

// Extension to support a more functional approach to array handling

extension Array {
    
    func filterElement(index: Int) -> [Element] {
        var result = [Element]()
        for (var i=0; i < count; i++) {
            if i != index {
                result.append(self[i])
            }
        }
        return result
    }

    func dropAtIndex(index: Int) -> [Element] {
        return filterElement(index)
    }
    
}
