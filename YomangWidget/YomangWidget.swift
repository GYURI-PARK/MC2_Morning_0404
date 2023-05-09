//
//  YomangWidget.swift
//  YomangWidget
//
//  Created by 제나 on 2023/05/09.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), image: UIImage(named: "preview") ?? UIImage())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), image: UIImage(named: "preview") ?? UIImage())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, image: UIImage(named: "preview") ?? UIImage())
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let image: UIImage
}

struct YomangWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Image(uiImage: entry.image)
                .resizable()
                .scaledToFill()
            Text(entry.date, style: .time)
        }
    }
}

struct YomangWidget: Widget {
    let kind: String = "YomangWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            YomangWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Yomang Widget")
        .description("요망이들을 위한 위젯입니다 👀")
        .supportedFamilies([.systemSmall, .systemLarge])
    }
}

struct YomangWidget_Previews: PreviewProvider {
    static var previews: some View {
        YomangWidgetEntryView(entry: SimpleEntry(date: Date(), image: UIImage(named: "preview") ?? UIImage()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

// - MARK: Extension - UserDefaults
extension UserDefaults {
    static var shared: UserDefaults {
            let appGroupID = "group.youngsa.Yomang"
            return UserDefaults(suiteName: appGroupID)!
        }
}
