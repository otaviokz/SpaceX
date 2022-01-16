//
//  SpaceXAPIClientTests.swift
//  SpaceXTests
//
//  Created by Otávio Zabaleta on 22/12/2021.
//

@testable import SpaceX
import XCTest


final class SpaceXAPIClientTests: XCTestCase {
    func testGetCompany() {
        // Given
        let (sut, httpClient) = makeSUT()
        httpClient.company = try! JsonLoader.company()

        runAsyncTest {
            // When
            let company = try await sut.company()

            // Then
            XCTAssertNotNil(company)
        }
    }

    func testGetCompanyFailure() {
        // Given
        let (sut, httpClient) = makeSUT()
        httpClient.stubGetError = .unknown
        let failure = expectation(description: "Company error received")

        // When
        Task {
            do {
                let _ = try await sut.company()
            } catch {
                XCTAssertNotNil(error)
                failure.fulfill()
            }
        }

        // Then
        waitForExpectations()
    }

    func testGetLaunches() {
        // Given
        let (sut, httpClient) = makeSUT()
        httpClient.launches = try! JsonLoader.launches()

        runAsyncTest {
            // When
            let launches = try? await sut.launches()

            // Then
            XCTAssertNotNil(launches)
        }
    }

    func testGetLaunchesFailure() {
        // Given
        let (sut, httpClient) = makeSUT()
        httpClient.stubPostError = .unknown
        let failure = expectation(description: "Launches error received")

        // When
        Task {
            do {
                let _ = try await sut.launches()
                XCTFail()
            } catch {
                XCTAssertNotNil(error)
                failure.fulfill()
            }
        }

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
