//
//  View+Accessibility.swift
//  SpaceX
//
//  Created by Otávio Zabaleta on 28/12/2021.
//

import SwiftUI

extension Text {
    init(_ key: LocalizationKey) {
        self.init(localize(key))
    }
}

extension View {
    func identifierKey(_ key: LocalizationKey) -> some View {
        accessibilityIdentifier(localize(key))
    }
}
