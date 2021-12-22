//
//  URLRequest+Utils.swift
//  SpaceX
//
//  Created by Otávio Zabaleta on 22/12/2021.
//

import Foundation

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
}

extension URLRequest {
    private func method(_ method: HTTPMethod) -> URLRequest {
        var request = self
        request.httpMethod = method.rawValue
        return request
    }

    func body(_ body: Data) -> URLRequest {
        var request = self
        request.httpBody = body
        return request
    }

    static func post(_ body: Data, to url: URL) -> URLRequest {
        URLRequest(url: url).method(.post).body(body)
    }

    static func postJSON(_ body: Data, to url: URL) -> URLRequest {
        var request = URLRequest.post(body, to: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }

    static func get(_ url: URL, cachePolicy: CachePolicy = .useProtocolCachePolicy) -> URLRequest {
        URLRequest(url: url, cachePolicy: cachePolicy).method(.get)
    }
}
