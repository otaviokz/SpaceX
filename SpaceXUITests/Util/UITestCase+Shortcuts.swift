//
//  UITestCase+Shortcuts.swift
//  SpaceXUITests
//
//  Created by Otávio Zabaleta on 27/12/2021.
//

import XCTest

extension XCUIElement {
    func contains(staticText: String) -> Bool {
        staticTexts.containing(.staticText, identifier: staticText).element.exists
    }
}

extension XCUIElementQuery {
    func cells(containing: String) -> XCUIElementQuery {
        cells.containing(.staticText, identifier: containing)
    }
}

extension XCUIApplication {
    func cell(table: Int = 0, row: Int) -> XCUIElement? {
        tables.element(boundBy: table).cells.element(boundBy: row)
    }

    func tableRows(containing: String) -> XCUIElementQuery {
        tables.cells(containing: containing)
    }
}

func XCTAssertExists(_ element: XCUIElement?, _ message: @autoclosure () -> String = "", file: StaticString = #filePath, line: UInt = #line) {
    guard let element = element else {
        XCTFail(message())
        return
    }

    XCTAssertTrue(element.exists)
}

func XCTAssertNotFound(_ element: XCUIElement?, _ message: @autoclosure () -> String = "", file: StaticString = #filePath, line: UInt = #line) {
    guard let element = element else {
        XCTFail(message())
        return
    }
    
    XCTAssertFalse(element.exists)
}
