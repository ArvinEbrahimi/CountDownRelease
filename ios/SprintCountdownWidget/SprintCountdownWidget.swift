import SwiftUI
import WidgetKit

/// App Group shared with the main Runner app. Must match
/// `AppConfig.widgetAppGroupId` in the Flutter code and the entitlements
/// on both the Runner and this extension target.
private let appGroupId = "group.com.sprint.countdown"
private let targetEpochMsKey = "target_epoch_ms"

struct CountdownEntry: TimelineEntry {
    let date: Date
    let targetDate: Date?
}

struct CountdownProvider: TimelineProvider {
    func placeholder(in context: Context) -> CountdownEntry {
        CountdownEntry(date: Date(), targetDate: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (CountdownEntry) -> Void) {
        completion(CountdownEntry(date: Date(), targetDate: readTargetDate()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CountdownEntry>) -> Void) {
        let target = readTargetDate()
        let now = Date()

        // One entry per minute for the next few hours keeps the widget fresh
        // without exceeding WidgetKit's refresh budget.
        var entries: [CountdownEntry] = []
        for minuteOffset in stride(from: 0, to: 180, by: 1) {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: now)!
            entries.append(CountdownEntry(date: entryDate, targetDate: target))
        }

        completion(Timeline(entries: entries, policy: .after(entries.last!.date)))
    }

    private func readTargetDate() -> Date? {
        guard let defaults = UserDefaults(suiteName: appGroupId) else { return nil }
        let epochMs = defaults.double(forKey: targetEpochMsKey)
        guard epochMs > 0 else { return nil }
        return Date(timeIntervalSince1970: epochMs / 1000)
    }
}

struct SprintCountdownWidgetView: View {
    var entry: CountdownEntry

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.02, green: 0.03, blue: 0.05), Color(red: 0.05, green: 0.04, blue: 0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VStack(alignment: .leading, spacing: 4) {
                Text("SPRINT LAUNCH")
                    .font(.caption2.weight(.semibold))
                    .foregroundColor(Color(red: 0.2, green: 0.9, blue: 0.9))

                if let target = entry.targetDate {
                    Text(target, style: .relative)
                        .font(.title3.weight(.bold))
                        .foregroundColor(.white)
                        .minimumScaleFactor(0.6)
                } else {
                    Text("Set a target in the app")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            .padding()
        }
    }
}

struct SprintCountdownWidget: Widget {
    let kind: String = "SprintCountdownWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CountdownProvider()) { entry in
            SprintCountdownWidgetView(entry: entry)
        }
        .configurationDisplayName("Sprint Countdown")
        .description("Shows the time remaining until launch.")
        .supportedFamilies([.systemSmall, .systemMedium, .accessoryRectangular])
    }
}
