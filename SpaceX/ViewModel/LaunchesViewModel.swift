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

    func onAppear()
}

final class LaunchesViewModel {
    // MARK: - Properties

    private let api: SpaceXAPIClientType
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Published Properties

    @Published private(set) var company: Company?
    @Published private(set) var launches: [Launch]?
    @Published private(set) var errorWarning: ErrorWaring?

    init(api: SpaceXAPIClientType = SpaceXAPIClient()) {
        self.api = api
    }
}

extension LaunchesViewModel: LaunchesViewModeling {
    func onAppear() {
        api.company()
            .sink(receiveCompletion: handleCompletion, receiveValue: receiveCompany)
            .store(in: &self.cancellables)

        api.launches(page: 0, limit: 200)
            .sink(receiveCompletion: handleCompletion, receiveValue: receiveLaunches)
            .store(in: &self.cancellables)
    }
}

private extension LaunchesViewModel {
    func receiveCompany(company: Company) {
        self.company = company
    }

    func receiveLaunches(query: QueryResult<[Launch]>) {
        self.launches = query.results
    }

    func handleCompletion(completion: Subscribers.Completion<HTTPError>) {
        if case .failure(_) = completion, errorWarning == nil {
            errorWarning = ErrorWaring(title: localize(.list_error_title), body: localize(.list_error_body))
        }
    }
}
