//
//  MainView.swift
//  SpaceX
//
//  Created by Otávio Zabaleta on 22/12/2021.
//

import SwiftUI

struct MainView<ViewModel: LaunchesViewModeling & ObservableObject>: View {
    @ObservedObject private(set) var viewModel: ViewModel

    var body: some View {
        VStack(spacing: 0) {
            List {
                if let company = viewModel.company {
                    Section(localize(.main_company)) {
                        CompanyRowView(company: company)
                    }
                }

                if let launches = viewModel.launches {
                    Section(localize(.main_launches)) {
                        ForEach(launches, id: \.self) { launch in
                            LaunchRowView(launch: launch)
                        }
                    }
                }
            }
            .listStyle(.grouped)
            .frame(maxWidth: .infinity)
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}

private extension MainView {
    struct Metric {
        static var top: CGFloat { 20 }
        static var horizontalSpacing: CGFloat { 16 }
    }
}

