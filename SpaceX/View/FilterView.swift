//
//  FilterView.swift
//  SpaceX
//
//  Created by Otávio Zabaleta on 28/12/2021.
//

import SwiftUI

struct FilterView<ViewModel: LaunchesViewModeling & ObservableObject>: View {
    @ObservedObject private(set) var viewModel: ViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack() {
            Text(.filter_title)
                .font(Style.titleFont)
                .padding(.top, Metric.spacing)

            List {
                Section(localize(.filter_status)) {
                    Button(action: { viewModel.toggleSuccessOnlyChecked() }) {
                        HStack {
                            Text(.filter_success)
                            Spacer()
                            if viewModel.successOnlyEnabled {
                                Asset.check.frame(height: Metric.check)
                            }
                        }
                    }
                }

                Section(localize(.filter_years)) {
                    ForEach(viewModel.allYears, id: \.self) { year in
                        Button(action: { viewModel.toggleChecked(year) }) {
                            HStack {
                                Text("\(year)")
                                Spacer()
                                if viewModel.checkedYears.contains(year) {
                                    Asset.check.frame(height: Metric.check)
                                }
                            }
                        }
                    }
                }
            }
            .font(Style.itemFont)
            .listStyle(.plain)
            .padding(.bottom, Metric.spacing)

            Spacer()

            HStack {
                Spacer()
                Button(Text(.filter_clear)) {
                    viewModel.clearFilter()
                    presentationMode.wrappedValue.dismiss()
                }
                Spacer()
                Button(Text(.filter_done)) {
                    presentationMode.wrappedValue.dismiss()
                }
                Spacer()
            }

        }
    }
}

private extension FilterView {
    struct Asset {
        static var check: Image { Image("success") }
    }

    struct Metric {
        static var spacing: CGFloat { 16 }
        static var check: CGFloat { 16 }
    }

    struct Style {
        static var titleFont: Font { .system(size: 17, weight: .semibold) }
        static var itemFont: Font { .system(size: 16, weight: .medium) }
    }
}
