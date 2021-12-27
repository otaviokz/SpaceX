//
//  ImageCache.swift
//  SpaceX
//
//  Created by Otávio Zabaleta on 27/12/2021.
//

import Combine
import Foundation
import SwiftUI

protocol ImageCaching {
    subscript(_ url: URL?) -> Image? { get set }
}

final class ImageCache {
    static let shared = ImageCache()

    private var cache = ThreadSafeCache<URL, Image>()
    private var cancellables = Set<AnyCancellable>()
}

extension ImageCache: ImageCaching {
    subscript(url: URL?) -> Image? {
        get {
            guard let url = url else { return nil }
            return cache[url]
        }
        set {
            guard let url = url else { return }
            cache[url] = newValue
        }
    }
}
