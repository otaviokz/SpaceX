//
//  LaunchesViewUITests.swift
//  SpaceXUITests
//
//  Created by Otávio Zabaleta on 23/12/2021.
//

@testable import SpaceX
import XCTest

class LaunchesViewUITests: BaseUITestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBasics() throws {
        XCTAssertTrue(app.staticTexts["SpaceX"].waitForExistence(timeout: 10))
        XCTAssertEqual(app.tables.firstMatch.cells.count, 3)
        XCTAssertTrue(app.tables.firstMatch.cells["Falcon 9 Test Flight"].exists)
        XCTAssertTrue(app.tables.firstMatch.cells["DemoSat"].exists)
        XCTAssertTrue(app.tables.firstMatch.cells["FalconSat"].exists)
    }
}
