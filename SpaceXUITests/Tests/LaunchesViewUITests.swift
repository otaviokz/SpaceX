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
        XCTAssertExists(app.staticTexts[companyDescription])

        XCTAssertEqual(app.tables.firstMatch.cells.count, 4)

        XCTAssertEqual(app.cell(row: 1)?.contains(staticText: "Falcon 9 Test Flight"), true)
        XCTAssertEqual(app.cell(row: 1)?.contains(staticText: "Date/Time:"), true)
        XCTAssertEqual(app.cell(row: 1)?.contains(staticText: "06/04/10 at 19:45"), true)
        XCTAssertEqual(app.cell(row: 1)?.contains(staticText: "Rocket:"), true)
        XCTAssertEqual(app.cell(row: 1)?.contains(staticText: "Falcon 9 / rocket"), true)
        XCTAssertEqual(app.cell(row: 1)?.contains(staticText: "Days since now:"), true)
        XCTAssertExists(app.cell(row: 1)?.images["success"])
        XCTAssertExists(app.cell(row: 1)?.images["Links"])

        XCTAssertEqual(app.cell(row: 2)?.contains(staticText: "DemoSat"), true)
        XCTAssertExists(app.cell(row: 2)?.images["failure"])
        XCTAssertExists(app.cell(row: 2)?.images["Links"])

        XCTAssertEqual(app.cell(row: 3)?.contains(staticText: "FalconSat"), true)
        XCTAssertExists(app.cell(row: 3)?.images["failure"])
        XCTAssertNotFound(app.cell(row: 3)?.images["Links"])

        XCTAssertExists(app.navigationBars.firstMatch.buttons["sort"])
        XCTAssertExists(app.navigationBars.firstMatch.buttons["filter"])
    }

    func testShowLinks() throws {
        // When
        app.tables.cells.element(boundBy: 1).images["Links"].tap()

        //Then
        XCTAssertEqual(app.sheets.buttons.count, 4)
        XCTAssertExists(app.sheets.buttons["Wikipedia"])
        XCTAssertExists(app.sheets.buttons["Webcast"])
        XCTAssertExists(app.sheets.buttons["Article"])
        XCTAssertExists(app.sheets.buttons["Cancel"])

        // When
        app.sheets.buttons["Cancel"].tap()
        app.tables.cells.element(boundBy: 2).images["Links"].tap()

        //Then
        XCTAssertEqual(app.sheets.buttons.count, 2)
        XCTAssertNotFound(app.sheets.buttons["Wikipedia"])
        XCTAssertNotFound(app.sheets.buttons["Article"])
        XCTAssertExists(app.sheets.buttons["Webcast"])
        XCTAssertExists(app.sheets.buttons["Cancel"])
    }

    func testSort() {
        // When
        app.navigationBars.firstMatch.buttons["sort"].tap()

        // Then
        XCTAssertEqual(app.cell(row: 1)?.contains(staticText: "FalconSat"), true)
        XCTAssertEqual(app.cell(row: 2)?.contains(staticText: "DemoSat"), true)
        XCTAssertEqual(app.cell(row: 3)?.contains(staticText: "Falcon 9 Test Flight"), true)
    }

    func testFilter() {
        // When
        app.navigationBars.firstMatch.buttons["filter"].tap()

        // Then
        XCTAssertExists(app.staticTexts["Filter by:"])

        XCTAssertEqual(app.tables.firstMatch.cells.count, 4)

        XCTAssertExists(app.tables.cells["Successfull landings only"])
        XCTAssertExists(app.tables.cells["2,006"])
        XCTAssertExists(app.tables.cells["2,007"])
        XCTAssertExists(app.tables.cells["2,010"])
        XCTAssertNotFound(app.cell(row: 0)?.images["success"])
        XCTAssertNotFound(app.cell(row: 1)?.images["success"])
        XCTAssertNotFound(app.cell(row: 2)?.images["success"])
        XCTAssertNotFound(app.cell(row: 3)?.images["success"])

        // When
        app.tables.cells["Successfull landings only"].tap()
        app.tables.cells["2,006"].tap()

        // Then
        XCTAssertExists(app.cell(row: 0)?.images["success"])
        XCTAssertExists(app.cell(row: 1)?.images["success"])

        // When
        app.buttons["Done"].tap()

        // Then
        XCTAssertEqual(app.tables.firstMatch.cells.count, 1)

        // When
        app.navigationBars.firstMatch.buttons["filter"].tap()
        app.tables.cells["Successfull landings only"].tap()
        app.buttons["Done"].tap()

        // Then
        XCTAssertEqual(app.tables.firstMatch.cells.count, 2)

        // When
        app.navigationBars.firstMatch.buttons["filter"].tap()
        app.buttons["Clear"].tap()

        // Then
        XCTAssertEqual(app.tables.firstMatch.cells.count, 4)
    }
}

private extension LaunchesViewUITests {
    var companyDescription: String {
        "SpaceX was founded by Elon Musk in 2002. It has now 9500 employees, 3 launch sites, and is valued at USD 74000000000."
    }
}
