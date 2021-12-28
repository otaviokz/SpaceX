//
//  LaunchTests.swift
//  SpaceX_Tests
//
//  Created by Otávio Zabaleta on 22/12/2021.
//

import XCTest
@testable import SpaceX

class LaunchTests: XCTestCase {
    func testDecodeJson() throws {
        let rockets = try JsonLoader.rockets()
        let launches = try JsonLoader.launches().sorted()
        
        XCTAssertEqual(launches.map { $0.missionName }, ["FalconSat", "DemoSat", "Falcon 9 Test Flight"])
        XCTAssertEqual(launches.map { $0.success }, [false, false, true])
        XCTAssertEqual(launches.map { $0.dateUTC }, ["2006-03-24T22:30:00.000Z", "2007-03-21T01:10:00.000Z", "2010-06-04T18:45:00.000Z"])
        XCTAssertEqual(launches.map { $0.dateIsTBD }, [false, false, false])
        XCTAssertEqual(launches.map { $0.rocket }, rockets)
    }
}
