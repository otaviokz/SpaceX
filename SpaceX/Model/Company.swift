//
//  Company.swift
//  SpaceX
//
//  Created by Otávio Zabaleta on 22/12/2021.
//

import Foundation

struct Company: Codable {
    let name: String
    let founder: String
    let foundationYear: Int
    let employees: Int
    let launchSites: Int
    let valuationUSD: Int
    
    enum CodingKeys: String, CodingKey {
        case name, founder, employees
        case foundationYear = "founded"
        case launchSites = "launch_sites"
        case valuationUSD = "valuation"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Company.CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        founder = try container.decode(String.self, forKey: .founder)
        foundationYear = try container.decode(Int.self, forKey: .foundationYear)
        employees = try container.decode(Int.self, forKey: .employees)
        launchSites = try container.decode(Int.self, forKey: .launchSites)
        valuationUSD = try container.decode(Int.self, forKey: .valuationUSD)
    }
}
