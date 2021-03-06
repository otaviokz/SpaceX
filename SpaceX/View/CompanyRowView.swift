//
//  CompanyRowView.swift
//  SpaceX
//
//  Created by Otávio Zabaleta on 22/12/2021.
//

import SwiftUI

struct CompanyRowView: View {
    let company: Company
    
    var body: some View {
            Text(company.localizedDescription)
                .font(Style.font)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, Metric.spacing)
    }
}

// MARK: - UI

private extension CompanyRowView {
    struct Metric {
        static var spacing: CGFloat { 16 }
    }

    struct Style {
        static var font: Font { .system(size: 17) }
    }
}

private extension Company {
    var localizedDescription: String {
        localize(.company_info, [name, founder, "\(foundationYear)", "\(employees)", "\(launchSites)", "\(valuationUSD)"])
    }
}
