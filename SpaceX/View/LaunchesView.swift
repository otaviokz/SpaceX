//
//  LaunchesView.swift
//  SpaceX
//
//  Created by Otávio Zabaleta on 22/12/2021.
//

import SwiftUI

struct LaunchesView<ViewModel: LaunchesViewModeling & ObservableObject>: View {
    @ObservedObject private(set) var viewModel: ViewModel

    var body: some View {
        VStack(spacing: 0) {
            if let company = viewModel.company {
                CompanyView(company: company)
            }

            if let launches = viewModel.launches {
                List {
                    ForEach(launches, id: \.self) { launch in
                        Text(launch.missionName)
                    }
                }
                .listStyle(.grouped)
            }
        }
        .padding(.top, Metric.top)
        .onAppear {
            viewModel.onAppear()
        }
    }
}

private extension LaunchesView {
    struct Metric {
        static var top: CGFloat { 20 }
    }
}

