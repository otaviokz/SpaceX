//
//  AlertButton+URL.swift
//  SpaceX
//
//  Created by Otávio Zabaleta on 28/12/2021.
//

import SwiftUI

extension Alert.Button {
    public static func url(_ label: Text, url: URL) -> Alert.Button {
        .default(label) { UIApplication.shared.open(url) }
    }
}
