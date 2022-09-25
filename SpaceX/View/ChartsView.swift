//
//  ChartsView.swift
//  SpaceX
//
//  Created by Otávio Zabaleta on 24/09/2022.
//

import SwiftUI
import SwiftUICharts

struct ChartsView<ViewModel: LaunchesViewModeling & ObservableObject>: View {
    @ObservedObject private(set) var viewModel: ViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Button(Text(.filter_done)) { dismiss() }
            
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        if let tuples = chartData {
                            ForEach(tuples, id: \.title) { data, title in
                                SCDonutChartView(data, title: title, formatter: formatter)
                                Divider().frame(height: 2).background(Color.gray)
                            }
                        }
                    }
                }
        }
        
    }
    
    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
    
    private let formatter = NumberFormatter().fixedFraction(digits: 0)
    
    private var chartData: [(data: [SCDataPoint], title: String)] {
        var result: [([SCDataPoint], String)] = []
        if let successData = successData {
            result.append((successData, "Success"))
        }
        if let rocketData = rocketData {
            result.append((rocketData, "Rockets"))
        }
        return result
    }
    
    private var successData: [SCDataPoint]? {
        let now = Date()
        guard let launches = viewModel.launches else { return nil }
        let successCount = launches.filter { $0.success == true }.count
        let failCount = launches.filter { $0.success == false }.count
        let unknownCount = launches.filter { $0.success == nil && $0.localDate < now}.count
        
        return [
            SCDataPoint("Success", value: Double(successCount), color: .red),
            SCDataPoint("Failure", value: Double(failCount), color: .red),
            SCDataPoint("Unknown", value: Double(unknownCount), color: .red)
        ]
    }
    
    private var rocketData: [SCDataPoint]? {
        guard let launches = viewModel.launches else { return nil }
        
        let rocketNames: [String] = launches.reduce([String]()) {
            guard !$0.containsCaseInsensitive($1.rocket.name) else { return $0 }
            return $0 + [$1.rocket.name]
        }

        return rocketNames.map { name in
            let count = launches.filter { $0.rocket.name.noCaseEquals(name) }.count
            return SCDataPoint(name, value: Double(count), color: .clear)
        }
    }
}

extension String {
    func noCaseEquals(_ other: String) -> Bool {
        uppercased() == other.uppercased()
    }
}

extension Array where Element == String {
    func containsCaseInsensitive(_ string: String) -> Bool {
        first { $0.noCaseEquals(string) } != nil
    }
}
//
//let missionName: String
//let success: Bool?
//let dateUTC: String
//let dateIsTBD: Bool
//let rocket: Rocket
//let links: Links
//let localDate: Date
