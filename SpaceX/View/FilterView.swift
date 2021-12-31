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
    @State var showSuccessOnly = false
    @State var showYears = false
    @State var checkedYears = Set<Int>()

    var body: some View {
        VStack() {
            Text(.filter_title)
                .font(Style.titleFont)
                .padding(.top, Metric.spacing)

            List {
                Section(localize(.filter_status)) {
                    Button(action: { showSuccessOnly.toggle() }) {
                        HStack {
                            Text(.filter_success)
                            Spacer()
                            Asset
                                .checkbox(showSuccessOnly)
                                .frame(height: Metric.check)
                        }
                    }
                }

                Section(
                    content: {
                        if showYears {
                            ForEach(viewModel.allYears, id: \.self) { year in
                                Button(action: { toggleChecked(year) }) {
                                    HStack {
                                        Text("\(year)")
                                        Spacer()
                                        Asset
                                            .checkbox(checkedYears.contains(year))
                                            .frame(height: Metric.check)
                                    }
                                }
                            }
                        }
                    },
                    header: {
                        Toggle(isOn: $showYears) { Text(.filter_years) }
                    }
                )

            }
            .font(Style.itemFont)
            .listStyle(.plain)
            .padding(.bottom, Metric.spacing)

            Spacer()

            HStack {
                Spacer()
                Button(Text(.filter_clear)) { dismiss(andClear: true) }
                Spacer()
                Button(Text(.filter_done)) { dismiss() }
                Spacer()
            }
        }
        .onAppear {
            showSuccessOnly = viewModel.filterOptions.showSuccessOnly
            checkedYears = viewModel.filterOptions.checkedYears
            showYears = !checkedYears.isEmpty
        }
        .animation(Style.animation, value: showYears)
    }
}

// MARK: - Private methods

private extension FilterView {
    typealias FilterOptions = LaunchesViewModel.FilterOptions
    func toggleChecked(_ year: Int) {
        if checkedYears.contains(year) {
            checkedYears.remove(year)
        } else {
            checkedYears = checkedYears.union([year])
        }
    }

    func dismiss(andClear: Bool = false) {
        var filterOptions: FilterOptions
        if andClear {
            filterOptions = FilterOptions()
        } else {
            filterOptions = FilterOptions(showSuccessOnly, checkedYears: showYears ? checkedYears : [])
        }
        viewModel.updateFilter(filterOptions)
        presentationMode.wrappedValue.dismiss()
    }
}

// MARK: - UI

private extension FilterView {
    struct Asset {
        static var checkmark: Image { Image(systemName: "checkmark.square") }
        static var square: Image { Image(systemName: "square") }
        static func checkbox(_ checked: Bool) -> Image {
            checked ? checkmark : square
        }
    }

    struct Metric {
        static var spacing: CGFloat { 16 }
        static var check: CGFloat { 16 }
    }

    struct Style {
        static var titleFont: Font { .system(size: 17, weight: .semibold) }
        static var itemFont: Font { .system(size: 16, weight: .medium) }
        static var animation: Animation { .easeInOut(duration: 0.2) }
    }
}
