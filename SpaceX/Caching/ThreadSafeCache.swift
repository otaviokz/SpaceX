//
//  ThreadSafeCache.swift
//  SpaceX
//
//  Created by Otávio Zabaleta on 27/12/2021.
//

import Foundation

class ThreadSafeCache<Key: Hashable, Value> {
    private var cache = [Key: Value]()
    private lazy var queue = DispatchQueue(label: String(describing: cache), qos: .userInteractive, attributes: .concurrent)

    subscript(key: Key) -> Value? {
        get {
            queue.sync { cache[key] }
        }
        set(value) {
            queue.async(flags: .barrier) { self.cache[key] = value }
        }
    }
}

