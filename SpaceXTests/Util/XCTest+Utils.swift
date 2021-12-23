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

    func waitForExpectations() {
        waitForExpectations(timeout: Self.defaultTimeout, handler: nil)
    }

    func waitForExpectationWithPredicate(timeout: TimeInterval = defaultTimeout, evaluation: @escaping () -> Bool) {
        let predicate = NSPredicate { _, _ in evaluation() }

        // Try to attempt a sync evaluation before waiting
        if evaluation() { return }
        wait(for: [expectationFor(predicate)], timeout: timeout)
    }

    func expectationFor(_ predicate: NSPredicate, evaluatedWith: Any? = NSObject()) -> XCTestExpectation {
        expectation(for: predicate, evaluatedWith: evaluatedWith, handler: nil)
    }
}
