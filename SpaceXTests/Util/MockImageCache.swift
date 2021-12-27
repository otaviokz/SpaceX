//
//  MockImageCache.swift
//  SpaceXTests
//
//  Created by Otávio Zabaleta on 27/12/2021.
//

import SwiftUI

final class MockImageCache: ImageCaching {
    subscript(url: URL?) -> Image? {
        get { Image("") }
        set { }
    }
}
