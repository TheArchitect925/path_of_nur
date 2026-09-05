import SwiftUI
import WidgetKit

struct WatchComplicationTimelineEntry: TimelineEntry {
  let date: Date
  let snapshot: WatchDailySnapshotPayload?
  let hasAutoDhikrPreferences: Bool
  let autoDhikrPreferences: WatchAutoDhikrPreferences
  let autoDhikrSession: WatchAutoDhikrSessionState?
  let palette: WatchPalette
}

struct WatchComplicationProvider: TimelineProvider {
  private let cacheStore = WatchCacheStore()

  private func entry(at date: Date) -> WatchComplicationTimelineEntry {
    WatchComplicationTimelineEntry(
      date: date,
      snapshot: cacheStore.loadSnapshot(),
      hasAutoDhikrPreferences: cacheStore.hasAutoDhikrPreferences(),
      autoDhikrPreferences: cacheStore.loadAutoDhikrPreferences(),
      autoDhikrSession: cacheStore.loadAutoDhikrSession(),
      palette: WatchPalette.palette(
        forPhoneThemeMode: cacheStore.loadSettings()?.watchThemeMode
      )
    )
  }

  func placeholder(in context: Context) -> WatchComplicationTimelineEntry {
    entry(at: Date())
  }

  func getSnapshot(
    in context: Context,
    completion: @escaping (WatchComplicationTimelineEntry) -> Void
  ) {
    completion(entry(at: Date()))
  }

  func getTimeline(
    in context: Context,
    completion: @escaping (Timeline<WatchComplicationTimelineEntry>) -> Void
  ) {
    let now = Date()
    let snapshot = cacheStore.loadSnapshot()
    let hasAutoDhikrPreferences = cacheStore.hasAutoDhikrPreferences()
    let autoDhikrPreferences = cacheStore.loadAutoDhikrPreferences()
    let autoDhikrSession = cacheStore.loadAutoDhikrSession()
    let palette = WatchPalette.palette(
      forPhoneThemeMode: cacheStore.loadSettings()?.watchThemeMode
    )
    let dates = refreshDates(from: snapshot, now: now)
    let entries = dates.map {
      WatchComplicationTimelineEntry(
        date: $0,
        snapshot: snapshot,
        hasAutoDhikrPreferences: hasAutoDhikrPreferences,
        autoDhikrPreferences: autoDhikrPreferences,
        autoDhikrSession: autoDhikrSession,
        palette: palette
      )
    }
    completion(
      Timeline(
        entries: entries,
        policy: .after(dates.last ?? Calendar.current.date(byAdding: .minute, value: 20, to: now) ?? now)
      )
    )
  }

  private func refreshDates(from snapshot: WatchDailySnapshotPayload?, now: Date) -> [Date] {
    var dates: [Date] = [now]
    let calendar = Calendar.current

    if let snapshot {
      if let nextPrayer = snapshot.resolvedNextPrayer(now: now) {
        let soon = calendar.date(byAdding: .minute, value: -20, to: nextPrayer.scheduledTime)
        let due = nextPrayer.scheduledTime
        let shortlyAfterDue = calendar.date(byAdding: .minute, value: 2, to: nextPrayer.scheduledTime)
        let settle = calendar.date(byAdding: .minute, value: 10, to: nextPrayer.scheduledTime)
        dates.append(contentsOf: [soon, due, shortlyAfterDue, settle].compactMap { $0 })
      }
    }

    if let tomorrow = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: now)),
       let rollover = calendar.date(byAdding: .minute, value: 1, to: tomorrow) {
      dates.append(rollover)
    }
    dates.append(calendar.date(byAdding: .minute, value: 10, to: now) ?? now)

    return Array(
      Set(dates.filter { $0 >= now }.map { $0.timeIntervalSince1970 })
    )
    .sorted()
    .compactMap(Date.init(timeIntervalSince1970:))
  }
}

struct NextPrayerComplication: Widget {
  let kind = "PathOfNurWatchNextPrayer"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: WatchComplicationProvider()) { entry in
      NextPrayerComplicationView(entry: entry)
    }
    .configurationDisplayName(WatchStrings.nextPrayerTitle)
    .description(WatchStrings.complicationNextPrayerDescription)
    .supportedFamilies([.accessoryCircular, .accessoryRectangular, .accessoryInline])
  }
}

struct DailyProgressComplication: Widget {
  let kind = "PathOfNurWatchDailyProgress"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: WatchComplicationProvider()) { entry in
      DailyProgressComplicationView(entry: entry)
    }
    .configurationDisplayName(WatchStrings.complicationPrayerProgressTitle)
    .description(WatchStrings.complicationDailyProgressDescription)
    .supportedFamilies([.accessoryCircular, .accessoryRectangular])
  }
}

struct AutoDhikrComplication: Widget {
  let kind = "PathOfNurWatchAutoDhikr"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: WatchComplicationProvider()) { entry in
      AutoDhikrComplicationView(entry: entry)
    }
    .configurationDisplayName(WatchStrings.autoDhikrTitle)
    .description(WatchStrings.complicationAutoDhikrDescription)
    .supportedFamilies([.accessoryInline, .accessoryRectangular])
  }
}

struct NameOfDayComplication: Widget {
  let kind = "PathOfNurWatchNameOfDay"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: WatchComplicationProvider()) { entry in
      NameOfDayComplicationView(entry: entry)
    }
    .configurationDisplayName(WatchStrings.complicationNameOfDayTitle)
    .description(WatchStrings.complicationNameOfDayDescription)
    .supportedFamilies([.accessoryInline, .accessoryRectangular])
  }
}

struct NameOfDayComplicationView: View {
  @Environment(\.widgetFamily) private var family
  let entry: WatchComplicationTimelineEntry
  private var name: WatchNameOfAllah {
    WatchNamesOfAllahData.nameOfTheDay(for: entry.date)
  }

  var body: some View {
    Group {
      switch family {
      case .accessoryInline:
        Text(name.transliteration)
      default:
        VStack(alignment: .leading, spacing: 2) {
          Text(WatchStrings.complicationNameOfDayTitle)
            .font(.caption2)
            .foregroundStyle(.secondary)
          Text(name.transliteration)
            .font(.headline)
            .foregroundStyle(entry.palette.accent)
            .minimumScaleFactor(0.8)
            .lineLimit(1)
          Text(name.meaning)
            .font(.caption2)
            .foregroundStyle(.secondary)
            .minimumScaleFactor(0.75)
            .lineLimit(1)
        }
      }
    }
    .widgetURL(URL(string: "pathofnurwatch://names"))
  }
}

struct SpiritualPromptComplication: Widget {
  let kind = "PathOfNurWatchSpiritualPrompt"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: WatchComplicationProvider()) { entry in
      SpiritualPromptComplicationView(entry: entry)
    }
    .configurationDisplayName(WatchStrings.complicationSpiritualPromptTitle)
    .description(WatchStrings.complicationSpiritualPromptDescription)
    .supportedFamilies([.accessoryInline, .accessoryCircular, .accessoryRectangular])
  }
}

struct NextPrayerComplicationView: View {
  @Environment(\.widgetFamily) private var family
  let entry: WatchComplicationTimelineEntry
  private var presentation: NextPrayerPresentation {
    NextPrayerPresentation(snapshot: entry.snapshot, now: entry.date, palette: entry.palette)
  }
  private var destinationURL: URL? {
    guard let prayerId = presentation.prayerId else {
      return URL(string: "pathofnurwatch://prayer")
    }
    return URL(string: "pathofnurwatch://prayer?prayerId=\(prayerId)")
  }

  var body: some View {
    Group {
      switch family {
      case .accessoryCircular:
        ZStack {
          AccessoryWidgetBackground()
          VStack(spacing: 1) {
            Text(presentation.shortName)
              .font(.system(size: 13, weight: .bold, design: .rounded))
            Text(presentation.circularDetail)
              .font(.system(size: 10, weight: .semibold, design: .rounded))
              .minimumScaleFactor(0.8)
          }
          .foregroundStyle(presentation.tint)
        }
      case .accessoryInline:
        Text(presentation.inlineText)
      default:
        VStack(alignment: .leading, spacing: 2) {
          Text(WatchStrings.nextPrayerTitle)
            .font(.caption2)
            .foregroundStyle(.secondary)
          Text(presentation.primaryText)
            .font(.headline)
          Text(presentation.secondaryText)
            .font(.caption)
            .foregroundStyle(presentation.isStale ? AnyShapeStyle(entry.palette.warning) : AnyShapeStyle(.secondary))
        }
      }
    }
    .widgetURL(destinationURL)
  }
}

struct DailyProgressComplicationView: View {
  @Environment(\.widgetFamily) private var family
  let entry: WatchComplicationTimelineEntry
  private var progressSummary: DailyProgressPresentation {
    DailyProgressPresentation(snapshot: entry.snapshot, now: entry.date, palette: entry.palette)
  }

  var body: some View {
    Group {
      if family == .accessoryCircular {
        Gauge(value: progressSummary.progress) {
          Text("P")
        } currentValueLabel: {
          Text(progressSummary.summary)
            .font(.system(size: 8, weight: .semibold, design: .rounded))
        }
        .gaugeStyle(.accessoryCircularCapacity)
        .tint(progressSummary.tint)
      } else {
        VStack(alignment: .leading, spacing: 2) {
          Text(WatchStrings.complicationPrayerProgressTitle)
            .font(.caption2)
            .foregroundStyle(.secondary)
          Text(progressSummary.summary)
            .font(.headline)
          Text(progressSummary.secondaryText)
            .font(.caption)
            .foregroundStyle(progressSummary.isStale ? AnyShapeStyle(entry.palette.warning) : AnyShapeStyle(.secondary))
        }
      }
    }
    .widgetURL(URL(string: "pathofnurwatch://progress"))
  }
}

struct AutoDhikrComplicationView: View {
  @Environment(\.widgetFamily) private var family
  let entry: WatchComplicationTimelineEntry
  private var presentation: AutoDhikrPresentation {
    AutoDhikrPresentation(
      hasSavedPreferences: entry.hasAutoDhikrPreferences,
      preferences: entry.autoDhikrPreferences,
      session: entry.autoDhikrSession
    )
  }

  var body: some View {
    Group {
      switch family {
      case .accessoryInline:
        Text(presentation.inlineText)
      default:
        VStack(alignment: .leading, spacing: 2) {
          Text(WatchStrings.autoDhikrTitle)
            .font(.caption2)
            .foregroundStyle(.secondary)
          Text(presentation.primaryText)
            .font(.headline)
            .minimumScaleFactor(0.8)
          Text(presentation.secondaryText)
            .font(.caption2)
            .foregroundStyle(.secondary)
            .minimumScaleFactor(0.8)
        }
      }
    }
    .widgetURL(URL(string: "pathofnurwatch://dhikr?mode=auto"))
  }
}

struct SpiritualPromptComplicationView: View {
  @Environment(\.widgetFamily) private var family
  let entry: WatchComplicationTimelineEntry
  private var presentation: SpiritualPromptPresentation {
    SpiritualPromptPresentation(snapshot: entry.snapshot, palette: entry.palette)
  }

  var body: some View {
    Group {
      switch family {
      case .accessoryInline:
        Text(presentation.inlineText)
      case .accessoryCircular:
        ZStack {
          AccessoryWidgetBackground()
          Text(presentation.circularText)
            .font(.system(size: 13, weight: .bold, design: .rounded))
            .foregroundStyle(presentation.tint)
        }
      default:
        VStack(alignment: .leading, spacing: 2) {
          Text(presentation.title)
            .font(.caption2)
            .foregroundStyle(.secondary)
          Text(presentation.bodyText)
            .font(.headline)
            .minimumScaleFactor(0.75)
          Text(presentation.secondaryText)
            .font(.caption2)
            .foregroundStyle(.secondary)
            .minimumScaleFactor(0.75)
        }
      }
    }
    .widgetURL(URL(string: "pathofnurwatch://home"))
  }
}

private struct NextPrayerPresentation {
  let prayerId: String?
  let primaryText: String
  let secondaryText: String
  let inlineText: String
  let shortName: String
  let circularDetail: String
  let progress: Double
  let tint: Color
  let isStale: Bool

  init(snapshot: WatchDailySnapshotPayload?, now: Date, palette: WatchPalette) {
    guard let snapshot else {
      prayerId = nil
      primaryText = WatchStrings.complicationNoData
      secondaryText = WatchStrings.complicationNeedsSync
      inlineText = WatchStrings.complicationNoData
      shortName = "?"
      circularDetail = "--"
      progress = 0
      tint = .gray
      isStale = true
      return
    }

    if Self.requiresFreshDaySnapshot(snapshot: snapshot, now: now) {
      prayerId = nil
      primaryText = WatchStrings.complicationNoData
      secondaryText = WatchStrings.complicationNeedsSync
      inlineText = WatchStrings.complicationNoData
      shortName = "?"
      circularDetail = "--"
      progress = 0
      tint = .gray
      isStale = true
      return
    }

    let stale = Self.isStale(snapshot: snapshot, now: now)
    isStale = stale

    if snapshot.completedPrayerCount >= snapshot.totalPrayerCount {
      prayerId = nil
      primaryText = WatchStrings.complicationAllSet
      secondaryText = "\(snapshot.completedPrayerCount)/\(snapshot.totalPrayerCount)"
      inlineText = WatchStrings.complicationAllSet
      shortName = "ALL"
      circularDetail = "OK"
      progress = 1
      tint = palette.success
      return
    }

    guard let prayer = snapshot.resolvedNextPrayer(now: now) else {
      prayerId = nil
      primaryText = WatchStrings.complicationNeedsSync
      secondaryText = stale ? WatchStrings.complicationNeedsSync : WatchStrings.complicationNoData
      inlineText = WatchStrings.complicationNeedsSync
      shortName = "?"
      circularDetail = "--"
      progress = 0
      tint = palette.warning
      return
    }

    prayerId = prayer.prayerId
    let minutesUntil = Int(prayer.scheduledTime.timeIntervalSince(now) / 60)
    let timingText: String
    if minutesUntil <= 0 && abs(minutesUntil) <= 45 {
      timingText = WatchStrings.complicationDueNow
    } else if minutesUntil > 0 && minutesUntil <= 30 {
      timingText = "\(WatchStrings.complicationSoon) \(Self.relativeString(for: prayer.scheduledTime, now: now))"
    } else {
      timingText = prayer.scheduledTime.formatted(date: .omitted, time: .shortened)
    }

    let timeText = prayer.scheduledTime.formatted(date: .omitted, time: .shortened)
    primaryText = "\(prayer.displayName) • \(timeText)"
    secondaryText = stale ? WatchStrings.complicationNeedsSync : timingText
    inlineText = "\(Self.shortPrayerLabel(for: prayer)) \(stale ? WatchStrings.complicationNeedsSync : Self.compactInlineText(for: prayer.scheduledTime, now: now))"
    shortName = Self.shortPrayerLabel(for: prayer)
    circularDetail = Self.circularTimeText(for: prayer.scheduledTime, now: now)
    progress = min(Double(snapshot.completedPrayerCount) / Double(max(snapshot.totalPrayerCount, 1)), 1)
    tint = stale ? palette.warning : palette.accent
  }

  static func isStale(snapshot: WatchDailySnapshotPayload, now: Date) -> Bool {
    if requiresFreshDaySnapshot(snapshot: snapshot, now: now) {
      return true
    }
    return now.timeIntervalSince(snapshot.generatedAt) > 60 * 90
  }

  static func requiresFreshDaySnapshot(snapshot: WatchDailySnapshotPayload, now: Date) -> Bool {
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .gregorian)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: now) != snapshot.date
  }

  private static func relativeString(for date: Date, now: Date) -> String {
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .short
    return formatter.localizedString(for: date, relativeTo: now)
  }

  private static func compactInlineText(for date: Date, now: Date) -> String {
    let minutesUntil = Int(date.timeIntervalSince(now) / 60)
    if minutesUntil <= 0 && abs(minutesUntil) <= 45 {
      return WatchStrings.complicationDueNow
    }
    if minutesUntil > 0 && minutesUntil <= 30 {
      return relativeString(for: date, now: now)
    }
    return date.formatted(date: .omitted, time: .shortened)
  }

  private static func circularTimeText(for date: Date, now: Date) -> String {
    let minutesUntil = Int(date.timeIntervalSince(now) / 60)
    if minutesUntil <= 0 && abs(minutesUntil) <= 45 {
      return WatchStrings.complicationDueNow
    }
    let formatted = date.formatted(date: .omitted, time: .shortened)
    return formatted.replacingOccurrences(of: " ", with: "")
  }

  private static func shortPrayerLabel(for prayer: WatchPrayerPayload) -> String {
    let compact = prayer.displayName
      .replacingOccurrences(of: " ", with: "")
      .uppercased()
    return String(compact.prefix(3))
  }
}

private struct DailyProgressPresentation {
  let summary: String
  let secondaryText: String
  let progress: Double
  let tint: Color
  let isStale: Bool

  init(snapshot: WatchDailySnapshotPayload?, now: Date, palette: WatchPalette) {
    guard let snapshot else {
      summary = "--"
      secondaryText = WatchStrings.complicationNeedsSync
      progress = 0
      tint = .gray
      isStale = true
      return
    }

    if NextPrayerPresentation.requiresFreshDaySnapshot(snapshot: snapshot, now: now) {
      summary = "--"
      secondaryText = WatchStrings.complicationNeedsSync
      progress = 0
      tint = .gray
      isStale = true
      return
    }

    summary = "\(snapshot.completedPrayerCount)/\(snapshot.totalPrayerCount)"
    let stale = NextPrayerPresentation.isStale(snapshot: snapshot, now: now)
    isStale = stale
    if snapshot.completedPrayerCount >= snapshot.totalPrayerCount {
      secondaryText = stale ? WatchStrings.complicationNeedsSync : WatchStrings.complicationPrayerProgressDone
    } else {
      secondaryText = stale
        ? WatchStrings.complicationNeedsSync
        : WatchStrings.complicationPrayerProgressCompleted(snapshot.completedPrayerCount, snapshot.totalPrayerCount)
    }
    progress = min(Double(snapshot.completedPrayerCount) / Double(max(snapshot.totalPrayerCount, 1)), 1)
    tint = snapshot.completedPrayerCount >= snapshot.totalPrayerCount ? palette.success : palette.accent
  }
}

private struct AutoDhikrPresentation {
  let primaryText: String
  let secondaryText: String
  let inlineText: String

  init(
    hasSavedPreferences: Bool,
    preferences: WatchAutoDhikrPreferences,
    session: WatchAutoDhikrSessionState?
  ) {
    if let session, session.isActive {
      primaryText = session.phrase.title
      secondaryText = WatchStrings.complicationAutoDhikrRunning(
        min(session.count, session.target),
        session.target,
        session.intervalDisplay
      )
      inlineText = WatchStrings.autoDhikrTitle
      return
    }

    if hasSavedPreferences {
      primaryText = preferences.phrase.title
      secondaryText = WatchStrings.complicationAutoDhikrSummary(
        preferences.target,
        String(format: "%.1fs", preferences.intervalSeconds)
      )
      inlineText = WatchStrings.autoDhikrTitle
      return
    }

    primaryText = WatchStrings.autoDhikrTitle
    secondaryText = WatchStrings.complicationStartSession
    inlineText = WatchStrings.autoDhikrTitle
  }
}

private struct SpiritualPromptPresentation {
  let title: String
  let bodyText: String
  let secondaryText: String
  let inlineText: String
  let circularText: String
  let tint: Color

  init(snapshot: WatchDailySnapshotPayload?, palette: WatchPalette) {
    guard let prompt = snapshot?.spiritualPrompt else {
      title = WatchStrings.complicationSpiritualPromptTitle
      bodyText = WatchStrings.complicationNeedsSync
      secondaryText = WatchStrings.complicationNoData
      inlineText = WatchStrings.complicationSpiritualPromptTitle
      circularText = "S"
      tint = palette.accent
      return
    }

    title = prompt.title
    bodyText = prompt.shortText
    secondaryText = WatchStrings.complicationOpenApp
    inlineText = prompt.inlineText
    circularText = prompt.circularText
    tint = palette.accent
  }
}

@main
struct PathOfNurWatchComplications: WidgetBundle {
  var body: some Widget {
    NextPrayerComplication()
    DailyProgressComplication()
    AutoDhikrComplication()
    NameOfDayComplication()
    SpiritualPromptComplication()
  }
}
