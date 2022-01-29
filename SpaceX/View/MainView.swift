//
//  MainView.swift
//  SpaceX
//
//  Created by Otávio Zabaleta on 22/12/2021.
//

import SwiftUI

struct MainView<ViewModel: LaunchesViewModeling & ObservableObject>: View {
    @ObservedObject private(set) var viewModel: ViewModel
    @State private var showFilter = false

    var body: some View {
        NavigationView {
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
            .refreshable {
                viewModel.onAppear()
            }
            .onAppear {
                viewModel.onAppear()
            }
            .navigationBarHidden(false)
            .navigationTitle(localize(.main_spacex))
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    HStack {
                        Button(barButtonIcon(Asset.sort)) { viewModel.newestFirst.toggle() }
                        Button(barButtonIcon(Asset.filter)) { showFilter = true }
                    }
                    .sheet(isPresented: $showFilter) { FilterView(viewModel: viewModel) }
                    .frame(alignment: .trailing)
                }
            }
        }
    }
}

// MARK: - UI

private extension MainView {
    func barButtonIcon(_ image: Image) -> some View {
        image
            .resizable()
            .scaledToFit()
            .frame(height: Metric.iconSize)
            .foregroundColor(.blue)
    }

    struct Metric {
        static var top: CGFloat { 20 }
        static var horizontalSpacing: CGFloat { 16 }
        static var iconSize: CGFloat { 28 }
    }

    struct Asset {
        static var filter: Image { Image("filter") }
        static var sort: Image { Image("sort") }
    }
}
