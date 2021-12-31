//
//  LaunchesViewModelTests.swift
//  SpaceXTests
//
//  Created by Otávio Zabaleta on 22/12/2021.
//

import Combine
@testable import SpaceX
import XCTest

final class LaunchesViewModelTests: XCTestCase {
    func testOnAppear() {
        // Given
        let (sut, api) = makeSUT()

        // When
        sut.onAppear()
        api.companyPromise?(.success(try! JsonLoader.company()))
        api.launchesPromise?(.success(launchesQuery))

        // Then
        waitForExpectationWithPredicate { sut.company != nil && sut.launches != nil }
        XCTAssertEqual(sut.launches?.count, 3)
    }

    func testOnAppearError() {
        // Given
        let (sut, api) = makeSUT()

        // When
        sut.onAppear()
        api.companyPromise?(.failure(.unknown))

        // Then
        waitForExpectationWithPredicate { sut.errorWarning != nil }
        XCTAssertEqual(sut.errorWarning?.title, "Error")
        XCTAssertEqual(sut.errorWarning?.body, "Unable to load data. Please check your network connection or try again later")
    }
}

private extension LaunchesViewModelTests {
    func makeSUT() -> (LaunchesViewModel, MockSpaceXAPIClient) {
        let apiClient = MockSpaceXAPIClient()
        let sut = LaunchesViewModel(api: apiClient)
        return (sut, apiClient)
    }

    var launchesQuery: QueryResult<[Launch]> {
        guard let launches = try? JsonLoader.launches() else { fatalError() }
        return QueryResult(launches)
    }
}

private final class MockSpaceXAPIClient: SpaceXAPIClientType {
    var companyPromise: ((Result<Company, HTTPError>) -> Void)?
    func company() -> Future<Company, HTTPError> {
        Future { [weak self] in self?.companyPromise = $0 }
    }

    func launches() -> Future<QueryResult<[Launch]>, HTTPError> {
        launches(page: 0, limit: 200)
    }

    var launchesPromise: ((Result<QueryResult<[Launch]>, HTTPError>) -> Void)?
    func launches(page: Int, limit: Int) -> Future<QueryResult<[Launch]>, HTTPError> {
        Future { [weak self] in self?.launchesPromise = $0 }
    }
}
