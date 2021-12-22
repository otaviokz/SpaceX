//
//  RocketTests.swift
//  SpaceX_Tests
//
//  Created by Otávio Zabaleta on 22/12/2021.
//

import XCTest
@testable import SpaceX

class RocketTests: XCTestCase {
    func testDecodeJson() throws {
        let rockets = try JsonLoader.rockets()
        
        XCTAssertEqual(rockets.map { $0.name }, ["Falcon 1", "Falcon 1", "Falcon 9"])
        XCTAssertEqual(rockets.map { $0.type }, ["rocket", "rocket", "rocket"])
    }
}
