//
//  LaunchesViewModel.swift
//  SpaceX
//
//  Created by Otávio Zabaleta on 22/12/2021.
//

import Foundation

protocol LaunchesViewModeling {
    var company: Company? { get }
    var launches: [Launch]? { get }
    var errorWarning: LaunchesViewModel.ErrorWaring? { get }
    var allYears: [Int] { get }
    var filterOptions: LaunchesViewModel.FilterOptions { get }

    func onAppear()
    func sort(newestFirst: Bool)
    func updateFilter(_ filterOptions: LaunchesViewModel.FilterOptions)
}

final class LaunchesViewModel: ObservableObject {
    // MARK: - Properties

    private let api: SpaceXAPIClientType
    private var allLaunches: [Launch]?
    private(set) var successOnlyEnabled = false
    private(set) var allYears = [Int]()
    private(set) var filterOptions = FilterOptions()
    private var newestFirst = true
    
    // MARK: - Published Properties

    @Published private(set) var company: Company?
    @Published private(set) var launches: [Launch]?
    @Published private(set) var errorWarning: ErrorWaring?
    @Published var checkedYears = Set<Int>()

    init(api: SpaceXAPIClientType = SpaceXAPIClient()) {
        self.api = api
    }
}

extension LaunchesViewModel: LaunchesViewModeling {
    func sort(newestFirst: Bool) {
        self.newestFirst = newestFirst
        launches = newestFirst ? launches?.newestFirst : launches?.oldestFirst
    }

    func updateFilter(_ filterOptions: FilterOptions) {
        self.filterOptions = filterOptions
        filterLaunches()
    }

    func filterLaunches() {
        guard var result = allLaunches else {
            launches = nil
            return
        }

        if filterOptions.showSuccessOnly {
            result = result.filter { $0.success == true }
        }

        if filterOptions.checkedYears.count > 0 {
            result = result.filter { filterOptions.checkedYears.contains($0.launchYear) }
        }

        launches = newestFirst ? result.newestFirst : result.oldestFirst
    }

    func onAppear() {
        Task {
            do {
                let company = try await api.company()
                DispatchQueue.main.async { [weak self] in self?.company = company }
            } catch {
                handle(error: .map(error))
            }
        }

        Task {
            do {
                let query = try await api.launches()
                allLaunches = query.results
                allYears = Set((allLaunches ?? []).map { $0.launchYear }).sorted()
                DispatchQueue.main.async { [weak self] in self?.launches = self?.allLaunches }
            } catch {
                handle(error: .map(error))
            }
        }
    }
}

private extension LaunchesViewModel {
    func handle(error: HTTPError) {
        DispatchQueue.main.async { [unowned self] in
            guard errorWarning == nil else { return }
            errorWarning = ErrorWaring(.list_error_title, bodyKey: .list_error_body)
        }
    }
}
