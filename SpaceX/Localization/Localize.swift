//
//  Localize.swift
//  SpaceX
//
//  Created by Otávio Zabaleta on 22/12/2021.
//

import Foundation

func localize(_ key: LocalizationKey, bundle: Bundle = Bundle.main) -> String {
    NSLocalizedString(key.rawValue, bundle: bundle, comment: "")
}

func localize(_ key: FormatedLocalizationKey, _ args: [String], bundle: Bundle = Bundle.main) -> String {
    var result = NSLocalizedString(key.rawValue, bundle: bundle, comment: "")
    for index in 0..<args.count {
        result = result.replacingOccurrences(of: "[$\(index)]", with: args[index])
    }
    return result
}

enum LocalizationKey: String {
    case main_company = "main_company_section_title"
    case main_launches = "main_launches_section_title"
    case main_mission = "main_label_mission"
    case main_date = "main_label_date"
    case main_rocket = "main_label_rocket"
    case main_days_since = "main_label_days_since"
    case main_days_from = "main_label_days_from"
    case main_dateTimeFormat = "main_date_time_format"
    case main_cancel
    case main_wiki
    case main_webcast
    case main_article
    case filter_title
    case filter_years
    case filter_status
    case filter_success
}

enum FormatedLocalizationKey: String {
    case company_info = "main_company_description"
}
