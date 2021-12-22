//
//  Links.swift
//  SpaceX
//
//  Created by Otávio Zabaleta on 22/12/2021.
//

import Foundation

struct Links: Codable, Equatable {
    let patch: Patch
    let webcast: URL?
    let article: URL?
    let wikipedia: URL?
    
    var hasInfo: Bool {
        webcast != nil && article != nil && wikipedia != nil
    }
    
    private var allInfoLinks: [(LocalizationKey, URL?)] {
        [(.main_wiki, wikipedia), (.main_webcast, webcast), (.main_article, article)]
    }
    
    var infoLinks: [(LocalizationKey, URL)] {
        allInfoLinks.compactMap {
            guard let url = $0.1 else { return nil }
            return ($0.0, url)
        }
    }
}
