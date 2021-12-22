//
//  MockHTTPClient.swift
//  SpaceXTests
//
//  Created by Otávio Zabaleta on 23/12/2021.
//

import Combine
import Foundation

final class MockHTTPClient: HTTPClientType {
    static let shared = MockHTTPClient()
    var stubGetError: HTTPError?

    @inlinable func populate() -> MockHTTPClient {
        company = try? JsonLoader.company()
        launches = try? JsonLoader.launches()
        return self
    }

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
