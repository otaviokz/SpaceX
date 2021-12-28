//
//  LaunchRowView.swift
//  SpaceX
//
//  Created by Otávio Zabaleta on 23/12/2021.
//

import SwiftUI

struct LaunchRowView: View {
    private let launch: Launch
    @State private var imageCache: ImageCaching = RuntimeService.imageCache
    @State private var infoLinks: InfoLinks?

    init(launch: Launch) {
        self.launch = launch
    }

    var body: some View {
        HStack(alignment: .top, spacing: Metric.smallSpacing) {
            if let image = imageCache[launch.links.patch.small] {
                iconView(image)
                    .padding(.leading, -Metric.smallSpacing)
            } else {
                AsyncImage(url: launch.links.patch.small) { phase in
                    switch phase {
                    case .success(let image):
                        iconView(image, url: launch.links.patch.small)
                            .padding(.leading, -Metric.smallSpacing)
                    default: iconView()
                            .padding(.leading, -Metric.smallSpacing)
                    }
                }
            }

            VStack(alignment: .leading, spacing: Metric.verticalSpacing) {
                infoRow(label: localize(.launch_mission), value: launch.missionName)
                infoRow(label: localize(.launch_date), value: DateFormatting.local.string(from: launch.localDate))
                infoRow(label: localize(.launch_rocket), value: "\(launch.rocket.name) / \(launch.rocket.type)")
                infoRow(label: daysLabel, value: daysValue)
            }
            .frame(maxWidth: .infinity)

            VStack {
                iconView(Asset.statusImage(launch.success))
                    .foregroundColor(.gray)
                if launch.links.hasInfo {
                    Spacer()
                    iconView(Asset.info)
                        .foregroundColor(.blue)
                        .identifierKey(.launch_links)
                        .onTapGesture { infoLinks = InfoLinks(pairs: launch.links.infoLinks) }
                }
            }
            .padding(.vertical, Metric.smallSpacing)
            .padding(.trailing, -Metric.smallSpacing)
        }
        .actionSheet(item: $infoLinks) { links in
            ActionSheet(title: Text(.launch_links), message: nil, buttons: links.actions)
        }
    }
}

private extension LaunchRowView {
    struct InfoLinks: Identifiable {
        let id = UUID()
        let pairs: [(LocalizationKey, URL)]

        var actions: [ActionSheet.Button] {
            pairs.map({ key, url in .url(Text(key), url: url) }) + [.cancel(Text(.launch_cancel))]
        }
    }

    func iconView(_ image: Image? = nil, url: URL? = nil) -> some View {
        if let image = image, let url = url { imageCache[url] = image }
        
        return (image ?? Image(""))
            .resizable()
            .scaledToFit()
            .frame(width: Metric.iconSize, height: Metric.iconSize)
    }

    var daysLabel: String {
        localize(launch.localDate <= Date() ? .launch_days_since : .launch_days_from)
    }

    var daysValue: String {
        guard let days = days(from: launch.localDate) else { return "" }
        return "\(days)"
    }

    func infoRow(label: String, value: String) -> some View {
        HStack(spacing: Metric.smallSpacing) {
            Group {
                labelText(label)
                valueText(value)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    func labelText(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 17))
            .foregroundColor(.gray)
            .multilineTextAlignment(.leading)
    }

    func valueText(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 17))
            .foregroundColor(.primary)
            .multilineTextAlignment(.leading)
    }

    func days(from: Date) -> Int? {
        let now = Date()
        return Calendar.current.dateComponents([.day], from: min(now, from), to: max(now, from)).day
    }

    struct Metric {
        static var smallSpacing: CGFloat { 4 }
        static var verticalSpacing: CGFloat { 8 }
        static var iconSize: CGFloat { 20 }
    }

    struct Asset {
        static var info: Image { Image("info") }
        static var badgePlacehoder: Image { Image("badge_placeholder") }
        static func statusImage(_ successful: Bool?) -> Image {
            guard let successful = successful else { return Image("") }
            return successful ? success : failure
        }
        private static var success: Image { Image("success") }
        private static var failure: Image { Image("failure") }
    }

    struct DateFormatting {
        static var local: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = localize(.launch_dateTimeFormat)
            return formatter
        }
    }
}
