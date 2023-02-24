//
//  Array+Utils.swift
//  SpaceX
//
//  Created by Otávio Zabaleta on 23/02/2023.
//

import Foundation

extension Array where Element: Hashable {
    var uniqueElements: [Element] {
        Array(Set(self))
    }
    
    func count(for element: Element) -> Int {
        guard contains(element) else { return 0 }
        return filter { $0 == element}.count
    }
}
