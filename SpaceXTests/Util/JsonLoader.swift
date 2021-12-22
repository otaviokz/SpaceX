//
//  JsonLoader.swift
//  SpaceXTests
//
//  Created by Otávio Zabaleta on 22/12/2021.
//

import Foundation
@testable import SpaceX

class JsonLoader {
    static func loadJson<T: Decodable>(_ filename: String) throws -> T {
        guard let file = Bundle(for: Self.self).url(forResource: filename, withExtension: "json") else {
            fatalError("Couldn't find \(filename) in test bundle.")
        }

        return try JSONDecoder().decode(T.self, from: try Data(contentsOf: file))
    }

    static func launches() throws -> [Launch] { try loadJson("TestLaunches_PopulatedRockets_v4") }
    static func rockets() throws -> [Rocket] { try loadJson("TestRockets_v4") }
    static func links() throws -> [Links] { try loadJson("TestLinks_v4") }
    static func patches() throws -> [Patch] { try loadJson("TestPatches_v4") }
    static func company() throws -> Company { try loadJson("TestCompanyInfo_v4") }
}
