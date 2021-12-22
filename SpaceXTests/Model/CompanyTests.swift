//
//  CompanyTests.swift
//  SpaceX_Tests
//
//  Created by Otávio Zabaleta on 22/12/2021.
//

import XCTest
@testable import SpaceX

class CompanyTests: XCTestCase {
    func testDecodeJson() throws {
        let company = try JsonLoader.company()
        
        XCTAssertEqual(company.name, "SpaceX")
        XCTAssertEqual(company.founder, "Elon Musk")
        XCTAssertEqual(company.foundationYear, 2002)
        XCTAssertEqual(company.employees, 9500)
        XCTAssertEqual(company.launchSites, 3)
        XCTAssertEqual(company.valuationUSD, 74000000000)
    }
}
