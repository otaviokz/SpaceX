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

    func waitForExpectationWithPredicate(timeout: TimeInterval = 10.0, file _: StaticString = #file, line _: UInt = #line, evaluation: @escaping () -> Bool) {
        let predicate = NSPredicate { _, _ -> Bool in
            evaluation()
        }

        // Try to attempt a sync evaluation before waiting
        if evaluation() {
            return
        }
        let expectation = self.expectation(for: predicate, evaluatedWith: NSObject())
        self.wait(for: [expectation], timeout: timeout)
    }
}
