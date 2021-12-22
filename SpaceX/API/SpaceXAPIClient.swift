//
//  SpaceXAPIClient.swift
//  SpaceX
//
//  Created by Otávio Zabaleta on 22/12/2021.
//

import Combine
import Foundation

protocol SpaceXAPIClientType {
    func company() -> Future<Company, HTTPError>
    func launches(page: Int, limit: Int) -> Future<QueryResult<[Launch]>, HTTPError>
}

final class SpaceXAPIClient {
    private let httpClient: HTTPClientType
    private let baseURL: URL
    private var launchesURL: URL { baseURL.appendingPathComponent("launches/query") }
    private var companyURL: URL { baseURL.appendingPathComponent("company") }
    private var cancellables = Set<AnyCancellable>()

    init(baseURL: String = "https://api.spacexdata.com/v4", httpClient: HTTPClientType = HTTPClient.shared) {
        guard let url = URL(string: baseURL) else {
            fatalError("Invalid url string \(baseURL)")
        }

        self.baseURL = url
        self.httpClient = httpClient
    }
}

extension SpaceXAPIClient: SpaceXAPIClientType {
    func company() -> Future<Company, HTTPError> {
        Future { [weak self] promise in
            guard let self = self else { return }

            self.httpClient
                .get(self.companyURL)
                .sink(
                    receiveCompletion: {
                        if case let .failure(error) = $0 { promise(.failure(error)) }
                    },
                    receiveValue: { promise(.success($0)) }
                )
                .store(in: &self.cancellables)
        }
    }

    func launches(page: Int = 0, limit: Int = 200) -> Future<QueryResult<[Launch]>, HTTPError>  {
        Future { [weak self] promise in
            guard let self = self else { return }
            do {
                self.httpClient
                    .postJSON(self.launchesURL, body: try self.launchQuery().json())
                    .sink(
                        receiveCompletion: {
                            if case let .failure(error) = $0 { promise(.failure(error)) }
                        },
                        receiveValue: { promise(.success($0)) }
                    )
                    .store(in: &self.cancellables)
            } catch {
                promise(.failure(.map(error)))
            }
        }
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
