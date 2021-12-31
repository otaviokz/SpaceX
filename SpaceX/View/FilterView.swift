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
    @State var showYears = false

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
                            Asset
                                .checkbox(viewModel.successOnlyEnabled)
                                .frame(height: Metric.check)
                        }
                    }
                }

                Section(
                    content: {
                        if showYears {
                            ForEach(viewModel.allYears, id: \.self) { year in
                                Button(action: { viewModel.toggleChecked(year) }) {
                                    HStack {
                                        Text("\(year)")
                                        Spacer()
                                        Asset
                                            .checkbox(viewModel.checkedYears.contains(year))
                                            .frame(height: Metric.check)
                                    }
                                }
                            }
                        }
                    },
                    header: {
                        Toggle.init(isOn: $showYears) { Text(.filter_years) }
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
            showYears = !viewModel.checkedYears.isEmpty
        }
        .animation(Style.animation, value: showYears)
    }
}

// MARK: - Private methods

private extension FilterView {
    func dismiss(andClear: Bool = false) {
        if andClear { viewModel.clearFilter() }
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
