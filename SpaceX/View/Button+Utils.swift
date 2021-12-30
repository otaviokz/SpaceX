//
//  Button+Utils.swift
//  SpaceX
//
//  Created by Otávio Zabaleta on 30/12/2021.
//

import SwiftUI

extension Button {
    init(_ label: Label, action: @escaping () -> Void) {
        self.init(action: action, label: { label })
    }
}
