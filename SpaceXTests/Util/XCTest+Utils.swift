//
//  XCTest+Utils.swift
//  SpaceXTests
//
//  Created by Otávio Zabaleta on 22/12/2021.
//

import Foundation
import XCTest

extension XCTestCase {
    static var defaultTimeout: TimeInterval { 5 }

    func waitForExpectations(handler: XCWaitCompletionHandler? = nil) {
        waitForExpectations(timeout: Self.defaultTimeout, handler: handler)
    }
}
