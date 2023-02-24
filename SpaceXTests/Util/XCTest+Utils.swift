//
//  XCTest+Utils.swift
//  SpaceXTests
//
//  Created by Otávio Zabaleta on 22/12/2021.
//

import Foundation
import XCTest
import SwiftTestNiceties

extension XCTestCase {
//    static var defaultTimeout: TimeInterval { 10 }

    func waitForExpectations() {
        waitForExpectations(timeout: Self.defaultTimeout, handler: nil)
    }

    func runAsyncTest(
        named testName: String = #function,
        in file: StaticString = #file,
        at line: UInt = #line,
        withTimeout timeout: TimeInterval = defaultTimeout,
        test: @escaping () async throws -> Void
    ) {
        var thrownError: Error?
        let errorHandler = { thrownError = $0 }
        let expectation = expectation(description: testName)

        Task {
            do {
                try await test()
            } catch {
                errorHandler(error)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)

        if let error = thrownError {
            XCTFail("Async error thrown: \(error)", file: file, line: line)
        }
    }
}
