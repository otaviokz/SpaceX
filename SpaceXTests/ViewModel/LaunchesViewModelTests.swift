//
//  LaunchesViewModelTests.swift
//  SpaceXTests
//
//  Created by Otávio Zabaleta on 22/12/2021.
//

@testable import SpaceX
import XCTest

final class LaunchesViewModelTests: XCTestCase {
    func testOnAppear() {
        // Given
        let (sut, api) = makeSUT()
        api.stubCompanyResponse = try! JsonLoader.company()
        api.stubLaunchesResponse = launchesQuery

        // When
        sut.onAppear()

        // Then
        waitForExpectationWithPredicate { sut.company != nil && sut.launches != nil }
        XCTAssertEqual(sut.launches?.count, 3)
    }

    func testOnAppearError() {
        // Given
        let (sut, _) = makeSUT()

        // When
        sut.onAppear()

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
    var stubCompanyResponse: Company?
    var stubCompanyError: HTTPError?
    func company() async throws -> Company {
        guard let company = stubCompanyResponse else { throw stubCompanyError ?? .unknown }
        return company
    }

    var stubLaunchesResponse: QueryResult<[Launch]>?
    var stubLaunchesError: HTTPError?
    func launches() async throws -> QueryResult<[Launch]> {
        try await launches(page: 0, limit: 200)
    }

    func launches(page: Int, limit: Int) async throws -> QueryResult<[Launch]> {
        guard let query = stubLaunchesResponse else { throw stubLaunchesError ?? .unknown }
        return query
    }
}
