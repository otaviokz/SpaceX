//
//  SpaceXAPIClientTests.swift
//  SpaceXTests
//
//  Created by Otávio Zabaleta on 22/12/2021.
//

import Combine
@testable import SpaceX
import XCTest


final class SpaceXAPIClientTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()

    override func setUp() {
        cancellables = []
    }

    func testGetCompany() {
        // Given
        let (sut, httpClient) = makeSUT()
        httpClient.company = try! JsonLoader.company()
        let valueReceived = expectation(description: "Company data received")

        // When
        sut.company()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { _ in valueReceived.fulfill() }
            )
            .store(in: &cancellables)

        // Then
        waitForExpectations()
    }

    func testGetCompanyFailure() {
        // Given
        let (sut, httpClient) = makeSUT()
        httpClient.stubGetError = .unknown
        let failure = expectation(description: "Company error received")

        // When
        sut.company()
            .sink(
                receiveCompletion: {
                    if case .failure(.unknown) = $0 { failure.fulfill() }
                },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)

        // Then
        waitForExpectations()
    }

    func testGetLaunches() {
        // Given
        let (sut, httpClient) = makeSUT()
        httpClient.launches = try! JsonLoader.launches()
        let valueReceived = expectation(description: "Launches data received")

        // When
        sut.launches()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { _ in valueReceived.fulfill() }
            )
            .store(in: &cancellables)

        // Then
        waitForExpectations()
    }

    func testGetLaunchesFailure() {
        // Given
        let (sut, httpClient) = makeSUT()
        httpClient.stubPostError = .unknown
        let failure = expectation(description: "Launches error received")

        // When
        sut.launches()
            .sink(
                receiveCompletion: {
                    if case .failure(.unknown) = $0 { failure.fulfill() }
                },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)

        // Then
        waitForExpectations()
    }
}

private extension SpaceXAPIClientTests {
    func makeSUT() -> (SpaceXAPIClient, MockHTTPClient) {
        let httpClient = MockHTTPClient()
        let sut = SpaceXAPIClient(httpClient: httpClient)
        return (sut, httpClient)
    }
}

private final class MockHTTPClient: HTTPClientType {
    var stubGetError: HTTPError?
    func get<T: Decodable>(_ url: URL) -> AnyPublisher<T, HTTPError> {
        guard let data = company as? T else {
            return Fail(error: stubGetError ?? .unknown).eraseToAnyPublisher()
        }

        return Just(data).setFailureType(to: HTTPError.self).eraseToAnyPublisher()
    }

    var stubPostError: HTTPError?
    func postJSON<T: Decodable>(_ url: URL, body: Data) -> AnyPublisher<T, HTTPError> {
        guard  let data = launchesQuery as? T else {
            return Fail(error: stubPostError ?? .unknown).eraseToAnyPublisher()
        }

        return Just(data).setFailureType(to: HTTPError.self).eraseToAnyPublisher()
    }

    var company: Company?
    var launches: [Launch]?
    var launchesQuery: QueryResult<[Launch]>? {
        guard let launches = launches else { return nil }
        return QueryResult(launches)
    }
}
