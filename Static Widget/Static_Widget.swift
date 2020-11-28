//

import WidgetKit
import SwiftUI

struct ConfigurableProvider: IntentTimelineProvider {

    typealias Entry = SimpleEntry

    typealias Intent = CityNamesIntent

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(for configuration: CityNamesIntent, in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(for configuration: CityNamesIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct Static_WidgetEntryView : View {
    var entry: Provider.Entry

    @Environment(\.widgetFamily) var family

    @ViewBuilder
    var body: some View {

        switch family {
        case .systemSmall:
            ViewForSystemSmall(entry: entry)
        case .systemMedium:
            ViewForSystemMedium(entry: entry)
        case .systemLarge:
            ViewForSystemLarge(entry: entry)
        @unknown default:
            fatalError()
        }
    }
}

struct ViewForSystemSmall: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            Text("Current Time").foregroundColor(.white)
            Text(entry.date, style: .time).foregroundColor(.white)
        }.padding()
    }
}

struct ViewForSystemMedium: View {
    var entry: Provider.Entry

    var body: some View {
        Text("")
    }
}

struct ViewForSystemLarge: View {
    var entry: Provider.Entry

    var body: some View {
        Text("")
    }
}

@main
struct Static_Widget: Widget {
    let kind: String = "Static_Widget"

    var body: some WidgetConfiguration {
//        StaticConfiguration(kind: kind, provider: Provider()) { entry in
//            Static_WidgetEntryView(entry: entry)
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .background(Color.black)
//        }
//        .configurationDisplayName("My Widget")
//        .description("This is an example widget.")
//        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])

        IntentConfiguration(kind: kind,
                            intent: CityNamesIntent.self,
                            provider: ConfigurableProvider(),
                            content: { entry in
                                Static_WidgetEntryView(entry: entry)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color.black)
                            })
            .configurationDisplayName("My Widget")
            .description("This is an example widget.")
            .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct Static_Widget_Previews: PreviewProvider {
    static var previews: some View {
        Static_WidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
