//
//  HTTPClient.swift
//  SpaceX
//
//  Created by Otávio Zabaleta on 22/12/2021.
//

import UIKit

enum HTTPError: Error {
    case other(Error)
    case withCode(Int)
    case unknown

    static func map(_ error: Error) -> HTTPError {
        (error as? HTTPError) ?? .other(error)
    }

    static func map(_ code: Int?) -> HTTPError {
        guard let code = code else { return .unknown }
        return .withCode(code)
    }
}

protocol HTTPClientType {
    func get<T: Decodable>(_ url: URL) async throws -> T
    func postJSON<T: Decodable>(_ url: URL, body: Data) async throws -> T
}

struct HTTPClient: HTTPClientType {
    static let shared = HTTPClient()

    private init() {}

    func get<T: Decodable>(_ url: URL) async throws -> T {
        try await connect(.get(url))
    }

    func postJSON<T: Decodable>(_ url: URL, body: Data) async throws -> T {
        try await connect(.postJSON(body, to: url))
    }
}

private extension HTTPClient {
    func connect<T: Decodable>(_ request: URLRequest) async throws -> T {
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw HTTPError.unknown }
        return try JSONDecoder().decode(T.self, from: data)
    }
}
