//
//  CompanyView.swift
//  SpaceX
//
//  Created by Otávio Zabaleta on 22/12/2021.
//

import SwiftUI

struct CompanyView: View {
    let company: Company
    
    var body: some View {
        HStack {
            Text(company.name)
                .font(Style.titleFont)
                .foregroundColor(.primary)
                .padding(.vertical, Metric.titleSpacing)
        }
    }
}

private extension CompanyView {
    struct Metric {
        static var titleSpacing: CGFloat { 4 }
    }

    struct Style {
        static var titleFont: Font { .system(size: 24, weight: .semibold) }
    }
}
