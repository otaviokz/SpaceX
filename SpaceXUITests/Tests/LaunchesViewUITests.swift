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
        // Then
        XCTAssertTrue(app.staticTexts[companyDescription].waitForExistence(timeout: 10))

        XCTAssertEqual(app.tables.firstMatch.cells.count, 4)

        XCTAssertEqual(app.cell(row: 1)?.contains(staticText: "Falcon 9 Test Flight"), true)
        XCTAssertEqual(app.cell(row: 1)?.contains(staticText: "Date/Time:"), true)
        XCTAssertEqual(app.cell(row: 1)?.contains(staticText: "06/04/10 at 19:45"), true)
        XCTAssertEqual(app.cell(row: 1)?.contains(staticText: "Rocket:"), true)
        XCTAssertEqual(app.cell(row: 1)?.contains(staticText: "Falcon 9 / rocket"), true)
        XCTAssertEqual(app.cell(row: 1)?.contains(staticText: "Days since now:"), true)
        XCTAssertEqual(app.cell(row: 1)?.images["success"].exists, true)

        XCTAssertEqual(app.cell(row: 2)?.images["failure"].exists, true)
        XCTAssertEqual(app.cell(row: 3)?.images["failure"].exists, true)
    }
}

private extension LaunchesViewUITests {
    var companyDescription: String {
        "SpaceX was founded by Elon Musk in 2002. It has now 9500 employees, 3 launch sites, and is valued at USD 74000000000."
    }
}
