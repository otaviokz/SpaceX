//
//  Launch.swift
//  SpaceX
//
//  Created by Otávio Zabaleta on 22/12/2021.
//

import Foundation

struct Launch: Codable {
    let missionName: String
    let success: Bool?
    let dateUTC: String
    let dateIsTBD: Bool
    let rocket: Rocket
    let links: Links
    let localDate: Date
    
    enum CodingKeys: String, CodingKey {
        case success, rocket, links
        case missionName = "name"
        case dateUTC = "date_utc"
        case dateIsTBD = "tbd"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Launch.CodingKeys.self)
        missionName = try container.decode(String.self, forKey: .missionName)
        success = try container.decodeIfPresent(Bool.self, forKey: .success)
        dateUTC = try container.decode(String.self, forKey: .dateUTC)
        localDate = DateFormatting.utc.date(from: dateUTC)!
        dateIsTBD = try container.decode(Bool.self, forKey: .dateIsTBD)
        rocket = try container.decode(Rocket.self, forKey: .rocket)
        links = try container.decode(Links.self, forKey: .links)
    }
    
    var launchYear: Int {
        Calendar.current.component(.year, from: localDate)
    }
}

extension Launch: Comparable {
    static func < (lhs: Launch, rhs: Launch) -> Bool {
        lhs.localDate < rhs.localDate
    }
}

extension Launch: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(missionName)
    }
}

private extension Launch {
    struct DateFormatting {
        static var utc: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            return formatter
        }
    }
}

extension Array where Element == Launch {
    func sorted(_ newestFirst: Bool) -> [Launch] {
        sorted { newestFirst ? $0.localDate > $1.localDate : $0.localDate < $1.localDate }
    }
}
