//
//  LaunchesQueryResult.swift
//  SpaceX
//
//  Created by Otávio Zabaleta on 22/12/2021.
//

import Foundation

struct QueryResult<T: Decodable>: Decodable {
    let results: T
    let totalResults: Int
    let limit: Int
    let totalPages: Int
    let page: Int
    let nextPage: Int?

    init(_ documents: T) {
        self.results = documents
        totalResults = 0
        limit = 0
        totalPages = 0
        page = 0
        nextPage = nil
    }

    enum CodingKeys: String, CodingKey {
        case limit, totalPages, page, nextPage
        case results = "docs"
        case totalResults = "totalDocs"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: QueryResult.CodingKeys.self)
        results = try container.decode(T.self, forKey: .results)
        totalResults = try container.decode(Int.self, forKey: .totalResults)
        limit = try container.decode(Int.self, forKey: .limit)
        totalPages = try container.decode(Int.self, forKey: .totalPages)
        page = try container.decode(Int.self, forKey: .page)
        nextPage = try container.decodeIfPresent(Int.self, forKey: .nextPage)
    }
}
