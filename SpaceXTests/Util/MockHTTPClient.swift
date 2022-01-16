//
//  MockHTTPClient.swift
//  SpaceXTests
//
//  Created by Otávio Zabaleta on 23/12/2021.
//

import Foundation

final class MockHTTPClient: HTTPClientType {
    static let shared = MockHTTPClient()

    @inlinable func populate() -> MockHTTPClient {
        company = try? JsonLoader.company()
        launches = try? JsonLoader.launches()
        return self
    }

    var stubGetError: HTTPError?
    func get<T>(_ url: URL) async throws -> T where T : Decodable {
        guard let data = company as? T else { throw stubPostError ?? .unknown }
        return data
    }


    var stubPostError: HTTPError?
    func postJSON<T>(_ url: URL, body: Data) async throws -> T where T : Decodable {
        guard let data = launchesQuery as? T else { throw stubPostError ?? .unknown }
        return data
    }

    var company: Company?
    var launches: [Launch]?
    var launchesQuery: QueryResult<[Launch]>? {
        guard let launches = launches else { return nil }
        return QueryResult(launches)
    }
}
