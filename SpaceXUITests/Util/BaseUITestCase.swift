//
//  BaseUITestCase.swift
//  SpaceXUITests
//
//  Created by Otávio Zabaleta on 23/12/2021.
//

import XCTest

class BaseUITestCase: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        app.launchEnvironment.updateValue("YES", forKey: "UITesting")
        app.launchArguments += ProcessInfo().arguments
        app.launchArguments += ["-AppleLanguages", "(en)"]
        app.launchArguments += ["-AppleLocale", "en_GB"]
        app.launch()
    }
}

