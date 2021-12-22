//
//  HTTPClient.swift
//  SpaceX
//
//  Created by Otávio Zabaleta on 22/12/2021.
//

import Combine
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
    func get<T: Decodable>(_ url: URL) -> AnyPublisher<T, HTTPError>
    func postJSON<T: Decodable>(_ url: URL, body: Data) -> AnyPublisher<T, HTTPError>
}

struct HTTPClient: HTTPClientType {
    static let shared = HTTPClient()
    private init() {}

    func get<T: Decodable>(_ url: URL) -> AnyPublisher<T, HTTPError> {
        connect(.get(url))
    }

    func postJSON<T: Decodable>(_ url: URL, body: Data) -> AnyPublisher<T, HTTPError> {
        connect(.postJSON(body, to: url))
    }
}

private extension HTTPClient {
    func connect<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, HTTPError> {
        URLSession
            .shared
            .dataTaskPublisher(for: request)
            .tryMap {
                let statusCode = ($0.response as? HTTPURLResponse)?.statusCode
                guard statusCode == 200 else { throw HTTPError.map(statusCode) }
                return $0.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { .map($0) }
            .eraseToAnyPublisher()
    }
}

