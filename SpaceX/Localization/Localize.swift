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
    case launch_mission = "launch_label_mission"
    case launch_date = "launch_label_date"
    case launch_rocket = "launch_label_rocket"
    case launch_days_since = "launch_label_days_since"
    case launch_days_from = "launch_label_days_from"
    case launch_dateTimeFormat = "launch_date_time_format"
    case launch_cancel
    case launch_wiki
    case launch_webcast
    case launch_article
    case filter_title
    case filter_years
    case filter_status
    case filter_success
    case list_error_title
    case list_error_body
}

enum FormatedLocalizationKey: String {
    case company_info = "company_description"
}
