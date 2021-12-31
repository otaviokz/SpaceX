//
//  LaunchesViewModel+Model.swift
//  SpaceX
//
//  Created by Otávio Zabaleta on 22/12/2021.
//

import Foundation

extension LaunchesViewModel {
    struct ErrorWaring {
        let title: String
        let body: String
    }

    struct FilterOptions {
        let showSuccessOnly: Bool
        let checkedYears: Set<Int>

        init(_ showSuccessOnly: Bool = false, checkedYears: Set<Int> = []) {
            self.showSuccessOnly = showSuccessOnly
            self.checkedYears = checkedYears
        }
    }
}
