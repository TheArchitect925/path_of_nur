import SwiftUI
import WidgetKit

struct ComplicationEntry: TimelineEntry {
    let date: Date
    let glance: WatchGlanceData
}

struct ComplicationTimelineProvider: TimelineProvider {
    private let glanceProvider = WatchGlanceDataProvider()

    func placeholder(in context: Context) -> ComplicationEntry {
        ComplicationEntry(
            date: Date(),
            glance: WatchGlanceData(
                nextPrayerName: "Asr",
                nextPrayerTime: nil,
                nextPrayerCountdown: "42m",
                todayPrayerProgress: "3/5",
                dhikrToday: 67,
                streakDays: 12,
                xpToday: 4,
                oceanDropsToday: 2,
                lastSyncAt: Date()
            )
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (ComplicationEntry) -> Void) {
        completion(ComplicationEntry(date: Date(), glance: glanceProvider.data()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<ComplicationEntry>) -> Void) {
        let now = Date()
        let entries = stride(from: 0, through: 60, by: 15).map { offset -> ComplicationEntry in
            let entryDate = Calendar.current.date(byAdding: .minute, value: offset, to: now) ?? now
            return ComplicationEntry(date: entryDate, glance: glanceProvider.data(now: entryDate))
        }
        let nextRefresh = Calendar.current.date(byAdding: .minute, value: 15, to: now) ?? now.addingTimeInterval(900)
        completion(Timeline(entries: entries, policy: .after(nextRefresh)))
    }
}

struct NextPrayerComplicationView: View {
    let entry: ComplicationEntry

    var body: some View {
        Text(entry.glance.nextPrayerName)
    }

    @ViewBuilder
    func rectangularView() -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Next Prayer")
                .font(.caption2)
                .foregroundStyle(.secondary)
            HStack(alignment: .firstTextBaseline) {
                Text(entry.glance.nextPrayerName)
                    .font(.headline)
                Spacer()
                Text(entry.glance.nextPrayerCountdown)
                    .font(.headline.monospacedDigit())
            }
        }
        .widgetURL(WatchSharedConstants.routeURL(.today))
    }
}

struct PrayerProgressComplicationView: View {
    let entry: ComplicationEntry

    var body: some View {
        Text(entry.glance.todayPrayerProgress)
    }
}

struct DhikrComplicationView: View {
    let entry: ComplicationEntry

    var body: some View {
        Text("\(entry.glance.dhikrToday)")
    }
}

struct StreakComplicationView: View {
    let entry: ComplicationEntry

    var body: some View {
        Text("\(entry.glance.streakDays)")
    }
}

struct NextPrayerComplication: Widget {
    let kind = "PathOfNurNextPrayerComplication"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ComplicationTimelineProvider()) { entry in
            NextPrayerComplicationBody(entry: entry)
        }
        .configurationDisplayName("Next Prayer")
        .description("Shows the next prayer at a glance.")
        .supportedFamilies([.accessoryCircular, .accessoryCorner, .accessoryInline, .accessoryRectangular])
    }
}

struct PrayerProgressComplication: Widget {
    let kind = "PathOfNurPrayerProgressComplication"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ComplicationTimelineProvider()) { entry in
            PrayerProgressComplicationBody(entry: entry)
        }
        .configurationDisplayName("Prayer Progress")
        .description("Shows completed prayers for today.")
        .supportedFamilies([.accessoryCircular, .accessoryCorner, .accessoryInline, .accessoryRectangular])
    }
}

struct DhikrComplication: Widget {
    let kind = "PathOfNurDhikrComplication"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ComplicationTimelineProvider()) { entry in
            DhikrComplicationBody(entry: entry)
        }
        .configurationDisplayName("Dhikr")
        .description("Shows today's dhikr count.")
        .supportedFamilies([.accessoryCircular, .accessoryCorner, .accessoryInline, .accessoryRectangular])
    }
}

struct StreakComplication: Widget {
    let kind = "PathOfNurStreakComplication"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ComplicationTimelineProvider()) { entry in
            StreakComplicationBody(entry: entry)
        }
        .configurationDisplayName("Streak")
        .description("Shows the current streak.")
        .supportedFamilies([.accessoryCircular, .accessoryCorner, .accessoryInline, .accessoryRectangular])
    }
}

@main
struct PathOfNurWatchComplications: WidgetBundle {
    var body: some Widget {
        NextPrayerComplication()
        PrayerProgressComplication()
        DhikrComplication()
        StreakComplication()
    }
}

private struct NextPrayerComplicationBody: View {
    @Environment(\.widgetFamily) private var family
    let entry: ComplicationEntry

    var body: some View {
        switch family {
        case .accessoryCircular:
            ZStack {
                AccessoryWidgetBackground()
                VStack(spacing: 1) {
                    Text(entry.glance.nextPrayerName.prefix(1))
                        .font(.headline)
                    Text(entry.glance.nextPrayerCountdown)
                        .font(.caption2.monospacedDigit())
                }
            }
            .widgetURL(WatchSharedConstants.routeURL(.today))
        case .accessoryCorner:
            Text("\(entry.glance.nextPrayerName) \(entry.glance.nextPrayerCountdown)")
                .widgetCurvesContent()
                .widgetURL(WatchSharedConstants.routeURL(.today))
        case .accessoryInline:
            Text("\(entry.glance.nextPrayerName) in \(entry.glance.nextPrayerCountdown)")
                .widgetURL(WatchSharedConstants.routeURL(.today))
        default:
            VStack(alignment: .leading, spacing: 2) {
                Text("Next Prayer")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                HStack {
                    Text(entry.glance.nextPrayerName)
                        .font(.headline)
                    Spacer()
                    Text(entry.glance.nextPrayerCountdown)
                        .font(.headline.monospacedDigit())
                }
                if let nextTime = entry.glance.nextPrayerTime {
                    Text(nextTime, style: .time)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .widgetURL(WatchSharedConstants.routeURL(.today))
        }
    }
}

private struct PrayerProgressComplicationBody: View {
    @Environment(\.widgetFamily) private var family
    let entry: ComplicationEntry

    var body: some View {
        switch family {
        case .accessoryCircular:
            ZStack {
                AccessoryWidgetBackground()
                VStack(spacing: 1) {
                    Text("Prayers")
                        .font(.system(size: 8))
                    Text(entry.glance.todayPrayerProgress)
                        .font(.caption2.monospacedDigit())
                }
            }
            .widgetURL(WatchSharedConstants.routeURL(.prayers))
        case .accessoryCorner:
            Text("Prayers \(entry.glance.todayPrayerProgress)")
                .widgetCurvesContent()
                .widgetURL(WatchSharedConstants.routeURL(.prayers))
        case .accessoryInline:
            Text("Prayers \(entry.glance.todayPrayerProgress)")
                .widgetURL(WatchSharedConstants.routeURL(.prayers))
        default:
            VStack(alignment: .leading, spacing: 2) {
                Text("Today's Prayers")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text("\(entry.glance.todayPrayerProgress) Completed")
                    .font(.headline.monospacedDigit())
            }
            .widgetURL(WatchSharedConstants.routeURL(.prayers))
        }
    }
}

private struct DhikrComplicationBody: View {
    @Environment(\.widgetFamily) private var family
    let entry: ComplicationEntry

    var body: some View {
        switch family {
        case .accessoryCircular:
            ZStack {
                AccessoryWidgetBackground()
                VStack(spacing: 1) {
                    Text("Dhikr")
                        .font(.system(size: 8))
                    Text("\(entry.glance.dhikrToday)")
                        .font(.caption2.monospacedDigit())
                }
            }
            .widgetURL(WatchSharedConstants.routeURL(.dhikr))
        case .accessoryCorner:
            Text("Dhikr \(entry.glance.dhikrToday)")
                .widgetCurvesContent()
                .widgetURL(WatchSharedConstants.routeURL(.dhikr))
        case .accessoryInline:
            Text("Dhikr \(entry.glance.dhikrToday)")
                .widgetURL(WatchSharedConstants.routeURL(.dhikr))
        default:
            VStack(alignment: .leading, spacing: 2) {
                Text("Dhikr")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text("\(entry.glance.dhikrToday)")
                    .font(.headline.monospacedDigit())
            }
            .widgetURL(WatchSharedConstants.routeURL(.dhikr))
        }
    }
}

private struct StreakComplicationBody: View {
    @Environment(\.widgetFamily) private var family
    let entry: ComplicationEntry

    var body: some View {
        switch family {
        case .accessoryCircular:
            ZStack {
                AccessoryWidgetBackground()
                VStack(spacing: 1) {
                    Text("Streak")
                        .font(.system(size: 8))
                    Text("\(entry.glance.streakDays)")
                        .font(.caption2.monospacedDigit())
                }
            }
            .widgetURL(WatchSharedConstants.routeURL(.progress))
        case .accessoryCorner:
            Text("Streak \(entry.glance.streakDays)")
                .widgetCurvesContent()
                .widgetURL(WatchSharedConstants.routeURL(.progress))
        case .accessoryInline:
            Text("Streak \(entry.glance.streakDays)d")
                .widgetURL(WatchSharedConstants.routeURL(.progress))
        default:
            VStack(alignment: .leading, spacing: 2) {
                Text("Streak")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text("\(entry.glance.streakDays) days")
                    .font(.headline.monospacedDigit())
            }
            .widgetURL(WatchSharedConstants.routeURL(.progress))
        }
    }
}
