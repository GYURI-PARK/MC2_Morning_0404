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
        let entryDate = Date()
        var entry: SimpleEntry
        if let widgetImageData = UserDefaults(suiteName: "group.youngsa.Yomang")?.data(forKey: "widgetImage"),
           let widgetImage = UIImage(data: widgetImageData) {
            entry = SimpleEntry(date: entryDate, image: widgetImage)
        } else {
            entry = SimpleEntry(date: entryDate, image: UIImage(named: "preview") ?? UIImage())
        }

        // 현재 날짜 및 시간 가져오기
        let components = Calendar.current.dateComponents(in: TimeZone(identifier: "Asia/Seoul")!, from: Date())

        // 매일 오전 5시로 설정
        var targetComponents = DateComponents()
        targetComponents.year = components.year
        targetComponents.month = components.month
        targetComponents.day = components.day
        targetComponents.hour = 5
        targetComponents.minute = 0
        targetComponents.second = 0
        targetComponents.timeZone = TimeZone(identifier: "Asia/Seoul")!

        let targetDate = Calendar.current.date(from: targetComponents)!
//        let nextRefresh = Calendar.current.date(byAdding: .day, value: 1, to: targetDate)!
        
        // MARK: 데모용 위젯 리프레시 타임을 1분으로 줄이는 코드
        let nextRefresh = Calendar.current.date(byAdding: .minute, value: 1, to: targetDate)!
        let timeline = Timeline(entries: [entry], policy: .after(nextRefresh))
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
//            Text(entry.date, style: .time)
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
