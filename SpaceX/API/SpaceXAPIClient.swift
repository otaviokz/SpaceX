//
//  SpaceXAPIClient.swift
//  SpaceX
//
//  Created by Otávio Zabaleta on 22/12/2021.
//

import Foundation

protocol SpaceXAPIClientType {
    func company() async throws -> Company
    func launches() async throws -> QueryResult<[Launch]>
    func launches(page: Int, limit: Int) async throws -> QueryResult<[Launch]>
}

final class SpaceXAPIClient {
    private let httpClient: HTTPClientType
    private let baseURL: URL
    private var launchesURL: URL { baseURL.appendingPathComponent("launches/query") }
    private var companyURL: URL { baseURL.appendingPathComponent("company") }

    init(baseURL: String = "https://api.spacexdata.com/v4", httpClient: HTTPClientType = HTTPClient.shared) {
        guard let url = URL(string: baseURL) else {
            fatalError("Invalid url string \(baseURL)")
        }

        self.baseURL = url
        self.httpClient = httpClient
    }
}

extension SpaceXAPIClient: SpaceXAPIClientType {
    func company() async throws -> Company {
        try await httpClient.get(companyURL)
    }

    func launches() async throws -> QueryResult<[Launch]> {
        try await launches(page: 0, limit: 200)
    }

    func launches(page: Int = 0, limit: Int = 200) async throws -> QueryResult<[Launch]> {
        try await httpClient.postJSON(self.launchesURL, body: try self.launchQuery().json())
    }
}

private extension SpaceXAPIClient {
    func launchQuery(page: Int = 0, limit: Int = 200) -> [String: Any] {
        [
            "options": [
                "populate": [
                    "path": "rocket",
                    "select": [
                        "name": 1,
                        "type" : 1
                    ]
                ],
                "limit": limit,
                "page": page,
                "sort": ["date_utc": "desc"],
                "select": [
                    "name", "date_utc", "tbd", "success", "rocket", "links.patch", "links.wikipedia", "links.webcast", "links.article"
                ]
            ]
        ]
    }
}

private extension Dictionary where Key == String {
    func json() throws -> Data {
        try JSONSerialization.data(withJSONObject: self)
    }
}
