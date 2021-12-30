//
//  LaunchesViewModel.swift
//  SpaceX
//
//  Created by Otávio Zabaleta on 22/12/2021.
//

import Combine
import Foundation

protocol LaunchesViewModeling {
    var company: Company? { get }
    var launches: [Launch]? { get }
    var errorWarning: LaunchesViewModel.ErrorWaring? { get }
    var successOnlyEnabled: Bool { get }
    var checkedYears: Set<Int> { get set }
    var allYears: [Int] { get }

    func onAppear()
    func sort(newestFirst: Bool)
    func showSuccessOnly(_ successOnly: Bool)
    func toggleChecked(_ year: Int)
    func toggleSuccessOnlyChecked()
    func clearFilter()
}

final class LaunchesViewModel: ObservableObject {
    // MARK: - Properties

    private let api: SpaceXAPIClientType
    private var cancellables = Set<AnyCancellable>()
    private var allLaunches: [Launch]?
    private(set) var successOnlyEnabled = false
    private(set) var allYears = [Int]()

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
        launches = launches?.sorted {
            newestFirst ? $0.localDate < $1.localDate : $1.localDate < $0.localDate
        }
    }

    func toggleSuccessOnlyChecked() {
        successOnlyEnabled.toggle()
        filterLaunches()
    }

    func showSuccessOnly(_ successOnly: Bool) {
        self.successOnlyEnabled = successOnly
        filterLaunches()
    }

    func toggleChecked(_ year: Int) {
        if checkedYears.contains(year) {
            checkedYears.remove(year)
        } else {
            checkedYears = checkedYears.union([year])
        }
        filterLaunches()
    }

    func filterLaunches() {
        guard var result = allLaunches else {
            launches = nil
            return
        }

        if successOnlyEnabled {
            result = result.filter { $0.success == true }
        }

        if checkedYears.count > 0 {
            result = result.filter { checkedYears.contains($0.launchYear) }
        }

        launches = result
    }

    func clearFilter() {
        checkedYears = []
        successOnlyEnabled = false
        filterLaunches()
    }

    func onAppear() {
        api.company()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: handleCompletion, receiveValue: receiveCompany)
            .store(in: &self.cancellables)

        api.launches(page: 0, limit: 200)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: handleCompletion, receiveValue: receiveLaunches)
            .store(in: &self.cancellables)
    }
}

private extension LaunchesViewModel {
    func receiveCompany(company: Company) {
        self.company = company
    }

    func receiveLaunches(query: QueryResult<[Launch]>) {
        allLaunches = query.results
        allYears = Set((allLaunches ?? []).map { $0.launchYear }).sorted()
        launches = allLaunches
    }

    func handleCompletion(completion: Subscribers.Completion<HTTPError>) {
        if case .failure(_) = completion, errorWarning == nil {
            errorWarning = ErrorWaring(title: localize(.list_error_title), body: localize(.list_error_body))
        }
    }
}
