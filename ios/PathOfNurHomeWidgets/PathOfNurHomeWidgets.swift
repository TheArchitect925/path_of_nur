import SwiftUI
import WidgetKit

private let widgetAppGroupId = "group.com.pathofnur.watch"
private let nextPrayerStorageKey = "path_of_nur.iphone_widget.next_prayer.v1"
private let prayerOverviewStorageKey = "path_of_nur.iphone_widget.prayer_overview.v1"
private let dhikrStorageKey = "path_of_nur.iphone_widget.dhikr.v1"
private let journeyStorageKey = "path_of_nur.iphone_widget.journey.v1"
private let duaStorageKey = "path_of_nur.iphone_widget.dua.v1"
private let hadithStorageKey = "path_of_nur.iphone_widget.hadith.v1"
private let ayahStorageKey = "path_of_nur.iphone_widget.ayah.v1"
private let reflectionStorageKey = "path_of_nur.iphone_widget.reflection.v1"
private let nameOfAllahStorageKey = "path_of_nur.iphone_widget.name_of_allah.v1"

private let nextPrayerWidgetKind = "PathOfNurNextPrayerWidget"
private let prayerOverviewWidgetKind = "PathOfNurPrayerOverviewWidget"
private let dhikrWidgetKind = "PathOfNurDhikrWidget"
private let journeyWidgetKind = "PathOfNurJourneyWidget"
private let duaWidgetKind = "PathOfNurDuaWidget"
private let hadithWidgetKind = "PathOfNurHadithWidget"
private let ayahWidgetKind = "PathOfNurAyahWidget"
private let reflectionWidgetKind = "PathOfNurReflectionWidget"
private let nameOfAllahWidgetKind = "PathOfNurNameOfAllahWidget"

private let iso8601Formatter: ISO8601DateFormatter = {
  let formatter = ISO8601DateFormatter()
  formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
  return formatter
}()

private let iso8601FallbackFormatter: ISO8601DateFormatter = {
  let formatter = ISO8601DateFormatter()
  formatter.formatOptions = [.withInternetDateTime]
  return formatter
}()

private struct PathOfNurWidgetEntry: TimelineEntry {
  let date: Date
  let nextPrayer: NextPrayerPayload?
  let prayerOverview: PrayerOverviewPayload?
  let dhikr: DhikrPayload?
  let journey: JourneyPayload?
  let dua: SpiritualPayload?
  let hadith: SpiritualPayload?
  let ayah: SpiritualPayload?
  let reflection: SpiritualPayload?
  let nameOfAllah: SpiritualPayload?
}

private struct PrayerItemPayload: Codable {
  let id: String
  let name: String
  let arabicName: String
  let timeIso: String
  let timeLabel: String
  let isCompleted: Bool
  let isCurrent: Bool
  let isNext: Bool

  var scheduledTime: Date? {
    decodeDate(timeIso)
  }
}

private struct NextPrayerPayload: Codable {
  let schemaVersion: Int
  let updatedAtIso: String
  let title: String
  let dateLine: String
  let currentPrayerName: String?
  let currentPrayerArabicName: String?
  let currentPrayerLabel: String
  let nextPrayerName: String?
  let nextPrayerArabicName: String?
  let nextPrayerTimeIso: String?
  let nextPrayerTimeLabel: String?
  let nextPrayerCountdownLabel: String
  let nextPrayerLabel: String
  let deepLinkUrl: String
  let fallbackTitle: String
  let fallbackBody: String

  var nextPrayerTime: Date? {
    guard let nextPrayerTimeIso else { return nil }
    return decodeDate(nextPrayerTimeIso)
  }
}

private struct PrayerOverviewPayload: Codable {
  let schemaVersion: Int
  let updatedAtIso: String
  let title: String
  let dateLine: String
  let completedPrayerCount: Int
  let totalPrayerCount: Int
  let phaseProgressPercent: Int
  let deepLinkUrl: String
  let items: [PrayerItemPayload]
}

private struct DhikrPayload: Codable {
  let schemaVersion: Int
  let updatedAtIso: String
  let title: String
  let dateLine: String
  let todayCount: Int
  let targetCount: Int
  let progressPercent: Int
  let todayLabel: String
  let targetLabel: String
  let deepLinkUrl: String
}

private struct JourneyPayload: Codable {
  let schemaVersion: Int
  let updatedAtIso: String
  let title: String
  let dateLine: String
  let currentStreakDays: Int
  let currentLevel: Int
  let totalXp: Int
  let todayXp: Int
  let xpProgressPercent: Int
  let streakLabel: String
  let levelLabel: String
  let todayXpLabel: String
  let deepLinkUrl: String
}

private struct SpiritualPayload: Codable {
  let schemaVersion: Int
  let updatedAtIso: String
  let title: String
  let dateLine: String
  let headline: String
  let supportingText: String
  let footerText: String
  let arabicText: String?
  let transliterationText: String?
  let accentText: String?
  let deepLinkUrl: String
  let accessoryInlineText: String
  let accessoryCircularText: String
  let accessoryRectangularTitle: String
  let accessoryRectangularBody: String
  let fallbackTitle: String
  let fallbackBody: String
}

private final class PathOfNurWidgetStore {
  private let defaults = UserDefaults(suiteName: widgetAppGroupId) ?? .standard

  func loadNextPrayer() -> NextPrayerPayload? {
    decodePayload(forKey: nextPrayerStorageKey, as: NextPrayerPayload.self)
  }

  func loadPrayerOverview() -> PrayerOverviewPayload? {
    decodePayload(forKey: prayerOverviewStorageKey, as: PrayerOverviewPayload.self)
  }

  func loadDhikr() -> DhikrPayload? {
    decodePayload(forKey: dhikrStorageKey, as: DhikrPayload.self)
  }

  func loadJourney() -> JourneyPayload? {
    decodePayload(forKey: journeyStorageKey, as: JourneyPayload.self)
  }

  func loadDua() -> SpiritualPayload? {
    decodePayload(forKey: duaStorageKey, as: SpiritualPayload.self)
  }

  func loadHadith() -> SpiritualPayload? {
    decodePayload(forKey: hadithStorageKey, as: SpiritualPayload.self)
  }

  func loadAyah() -> SpiritualPayload? {
    decodePayload(forKey: ayahStorageKey, as: SpiritualPayload.self)
  }

  func loadReflection() -> SpiritualPayload? {
    decodePayload(forKey: reflectionStorageKey, as: SpiritualPayload.self)
  }

  func loadNameOfAllah() -> SpiritualPayload? {
    decodePayload(forKey: nameOfAllahStorageKey, as: SpiritualPayload.self)
  }

  private func decodePayload<T: Decodable>(forKey key: String, as type: T.Type) -> T? {
    guard let raw = defaults.string(forKey: key), let data = raw.data(using: .utf8) else {
      return nil
    }
    return try? JSONDecoder().decode(T.self, from: data)
  }
}

private struct PathOfNurWidgetProvider: TimelineProvider {
  private let store = PathOfNurWidgetStore()

  func placeholder(in context: Context) -> PathOfNurWidgetEntry {
    demoEntry(at: Date())
  }

  func getSnapshot(in context: Context, completion: @escaping (PathOfNurWidgetEntry) -> Void) {
    completion(entry(at: Date()))
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<PathOfNurWidgetEntry>) -> Void) {
    let now = Date()
    let currentEntry = entry(at: now)
    let refreshDates = timelineDates(from: currentEntry, now: now)
    let entries = refreshDates.map { entry(at: $0) }
    completion(
      Timeline(
        entries: entries,
        policy: .after(refreshDates.last ?? Calendar.current.date(byAdding: .minute, value: 30, to: now) ?? now)
      )
    )
  }

  private func entry(at date: Date) -> PathOfNurWidgetEntry {
    PathOfNurWidgetEntry(
      date: date,
      nextPrayer: store.loadNextPrayer(),
      prayerOverview: store.loadPrayerOverview(),
      dhikr: store.loadDhikr(),
      journey: store.loadJourney(),
      dua: store.loadDua(),
      hadith: store.loadHadith(),
      ayah: store.loadAyah(),
      reflection: store.loadReflection(),
      nameOfAllah: store.loadNameOfAllah()
    )
  }

  private func demoEntry(at date: Date) -> PathOfNurWidgetEntry {
    PathOfNurWidgetEntry(
      date: date,
      nextPrayer: NextPrayerPayload(
        schemaVersion: 1,
        updatedAtIso: date.toISO8601String(),
        title: "Next Prayer",
        dateLine: "Fri, Apr 10 • 12 Ramadan",
        currentPrayerName: "Dhuhr",
        currentPrayerArabicName: "الظهر",
        currentPrayerLabel: "Current prayer",
        nextPrayerName: "Asr",
        nextPrayerArabicName: "العصر",
        nextPrayerTimeIso: Calendar.current.date(byAdding: .minute, value: 76, to: date)?.toISO8601String(),
        nextPrayerTimeLabel: "4:24 PM",
        nextPrayerCountdownLabel: "in 1h 16m",
        nextPrayerLabel: "Next prayer",
        deepLinkUrl: "pathofnur://worship/prayer",
        fallbackTitle: "Prayer times unavailable",
        fallbackBody: "Open Path of Nūr to refresh prayer times for today."
      ),
      prayerOverview: PrayerOverviewPayload(
        schemaVersion: 1,
        updatedAtIso: date.toISO8601String(),
        title: "Prayer Overview",
        dateLine: "Fri, Apr 10 • 12 Ramadan",
        completedPrayerCount: 2,
        totalPrayerCount: 5,
        phaseProgressPercent: 58,
        deepLinkUrl: "pathofnur://worship/prayer",
        items: [
          PrayerItemPayload(id: "fajr", name: "Fajr", arabicName: "الفجر", timeIso: date.toISO8601String(), timeLabel: "5:11 AM", isCompleted: true, isCurrent: false, isNext: false),
          PrayerItemPayload(id: "dhuhr", name: "Dhuhr", arabicName: "الظهر", timeIso: date.toISO8601String(), timeLabel: "1:18 PM", isCompleted: true, isCurrent: true, isNext: false),
          PrayerItemPayload(id: "asr", name: "Asr", arabicName: "العصر", timeIso: date.toISO8601String(), timeLabel: "4:24 PM", isCompleted: false, isCurrent: false, isNext: true),
          PrayerItemPayload(id: "maghrib", name: "Maghrib", arabicName: "المغرب", timeIso: date.toISO8601String(), timeLabel: "7:58 PM", isCompleted: false, isCurrent: false, isNext: false),
          PrayerItemPayload(id: "isha", name: "Isha", arabicName: "العشاء", timeIso: date.toISO8601String(), timeLabel: "9:22 PM", isCompleted: false, isCurrent: false, isNext: false)
        ]
      ),
      dhikr: DhikrPayload(
        schemaVersion: 1,
        updatedAtIso: date.toISO8601String(),
        title: "Daily Dhikr",
        dateLine: "Fri, Apr 10 • 12 Ramadan",
        todayCount: 24,
        targetCount: 33,
        progressPercent: 73,
        todayLabel: "Today",
        targetLabel: "Target",
        deepLinkUrl: "pathofnur://worship/dhikr"
      ),
      journey: JourneyPayload(
        schemaVersion: 1,
        updatedAtIso: date.toISO8601String(),
        title: "Journey Progress",
        dateLine: "Fri, Apr 10 • 12 Ramadan",
        currentStreakDays: 7,
        currentLevel: 4,
        totalXp: 1280,
        todayXp: 45,
        xpProgressPercent: 62,
        streakLabel: "Streak",
        levelLabel: "Level",
        todayXpLabel: "Today XP",
        deepLinkUrl: "pathofnur://journey/progress"
      ),
      dua: SpiritualPayload(
        schemaVersion: 1,
        updatedAtIso: date.toISO8601String(),
        title: "Daily Dua",
        dateLine: "Fri, Apr 10 • 12 Ramadan",
        headline: "Before Sleep",
        supportingText: "In Your name, O Allah, I die and I live.",
        footerText: "Before resting for the night",
        arabicText: "بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا",
        transliterationText: "Bismika Allahumma amutu wa ahya",
        accentText: nil,
        deepLinkUrl: "pathofnur://worship/duas",
        accessoryInlineText: "Night dua ready",
        accessoryCircularText: "D",
        accessoryRectangularTitle: "Dua",
        accessoryRectangularBody: "Before Sleep",
        fallbackTitle: "Dua unavailable",
        fallbackBody: "Open Path of Nūr to refresh today’s dua."
      ),
      hadith: SpiritualPayload(
        schemaVersion: 1,
        updatedAtIso: date.toISO8601String(),
        title: "Hadith",
        dateLine: "Fri, Apr 10 • 12 Ramadan",
        headline: "Mercy and gentleness",
        supportingText: "Allah is gentle and loves gentleness in all matters.",
        footerText: "Sahih al-Bukhari",
        arabicText: nil,
        transliterationText: nil,
        accentText: nil,
        deepLinkUrl: "pathofnur://learn/hadith",
        accessoryInlineText: "Hadith today",
        accessoryCircularText: "H",
        accessoryRectangularTitle: "Hadith",
        accessoryRectangularBody: "Mercy and gentleness",
        fallbackTitle: "Hadith unavailable",
        fallbackBody: "Open Path of Nūr to refresh today’s hadith."
      ),
      ayah: SpiritualPayload(
        schemaVersion: 1,
        updatedAtIso: date.toISO8601String(),
        title: "Ayah",
        dateLine: "Fri, Apr 10 • 12 Ramadan",
        headline: "Surah Ad-Duhaa",
        supportingText: "And your Lord is going to give you, and you will be satisfied.",
        footerText: "93:5",
        arabicText: "وَلَسَوْفَ يُعْطِيكَ رَبُّكَ فَتَرْضَىٰ",
        transliterationText: nil,
        accentText: "93:5",
        deepLinkUrl: "pathofnur://quran/daily",
        accessoryInlineText: "Ayah today",
        accessoryCircularText: "A",
        accessoryRectangularTitle: "Ayah",
        accessoryRectangularBody: "Surah Ad-Duhaa 93:5",
        fallbackTitle: "Ayah unavailable",
        fallbackBody: "Open Path of Nūr to refresh today’s ayah."
      ),
      reflection: SpiritualPayload(
        schemaVersion: 1,
        updatedAtIso: date.toISO8601String(),
        title: "Reflection",
        dateLine: "Fri, Apr 10 • 12 Ramadan",
        headline: "Walk with intention",
        supportingText: "A small act done with sincerity can transform an entire day.",
        footerText: "Daily reflection",
        arabicText: nil,
        transliterationText: nil,
        accentText: nil,
        deepLinkUrl: "pathofnur://quran/daily",
        accessoryInlineText: "Reflection today",
        accessoryCircularText: "R",
        accessoryRectangularTitle: "Reflection",
        accessoryRectangularBody: "Walk with intention",
        fallbackTitle: "Reflection unavailable",
        fallbackBody: "Open Path of Nūr to refresh today’s reflection."
      ),
      nameOfAllah: SpiritualPayload(
        schemaVersion: 1,
        updatedAtIso: date.toISO8601String(),
        title: "Name of Allah",
        dateLine: "Fri, Apr 10 • 12 Ramadan",
        headline: "Ar-Rahman",
        supportingText: "The Entirely Merciful",
        footerText: "Mercy that reaches all creation",
        arabicText: "ٱلرَّحْمَٰنُ",
        transliterationText: "Ar-Rahman",
        accentText: "Mercy",
        deepLinkUrl: "pathofnur://quran/names-of-allah",
        accessoryInlineText: "Name of Allah",
        accessoryCircularText: "99",
        accessoryRectangularTitle: "Name of Allah",
        accessoryRectangularBody: "Ar-Rahman",
        fallbackTitle: "Name unavailable",
        fallbackBody: "Open Path of Nūr to refresh today’s Name of Allah."
      )
    )
  }

  private func timelineDates(from entry: PathOfNurWidgetEntry, now: Date) -> [Date] {
    var dates: [Date] = [now]
    let calendar = Calendar.current

    if let nextPrayerDate = entry.nextPrayer?.nextPrayerTime {
      dates.append(nextPrayerDate)
      dates.append(calendar.date(byAdding: .minute, value: -20, to: nextPrayerDate) ?? nextPrayerDate)
      dates.append(calendar.date(byAdding: .minute, value: 5, to: nextPrayerDate) ?? nextPrayerDate)
    }

    if let midnight = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: now)) {
      dates.append(calendar.date(byAdding: .minute, value: 1, to: midnight) ?? midnight)
    }

    dates.append(calendar.date(byAdding: .minute, value: 15, to: now) ?? now)
    dates.append(calendar.date(byAdding: .minute, value: 30, to: now) ?? now)

    return Array(Set(dates.filter { $0 >= now }.map(\.timeIntervalSince1970)))
      .sorted()
      .map(Date.init(timeIntervalSince1970:))
  }
}

struct PathOfNurNextPrayerWidget: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: nextPrayerWidgetKind, provider: PathOfNurWidgetProvider()) { entry in
      NextPrayerWidgetView(entry: entry)
    }
    .configurationDisplayName(widgetString("widget_next_prayer_display_name"))
    .description(widgetString("widget_next_prayer_description"))
    .supportedFamilies([.systemSmall, .accessoryInline, .accessoryCircular, .accessoryRectangular])
  }
}

struct PathOfNurPrayerOverviewWidget: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: prayerOverviewWidgetKind, provider: PathOfNurWidgetProvider()) { entry in
      PrayerOverviewWidgetView(entry: entry)
    }
    .configurationDisplayName(widgetString("widget_prayer_overview_display_name"))
    .description(widgetString("widget_prayer_overview_description"))
    .supportedFamilies([.systemMedium])
  }
}

struct PathOfNurDhikrWidget: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: dhikrWidgetKind, provider: PathOfNurWidgetProvider()) { entry in
      DhikrWidgetView(entry: entry)
    }
    .configurationDisplayName(widgetString("widget_dhikr_display_name"))
    .description(widgetString("widget_dhikr_description"))
    .supportedFamilies([.systemSmall, .systemMedium, .accessoryInline, .accessoryCircular, .accessoryRectangular])
  }
}

struct PathOfNurJourneyWidget: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: journeyWidgetKind, provider: PathOfNurWidgetProvider()) { entry in
      JourneyWidgetView(entry: entry)
    }
    .configurationDisplayName(widgetString("widget_journey_display_name"))
    .description(widgetString("widget_journey_description"))
    .supportedFamilies([.systemSmall])
  }
}

struct PathOfNurDuaWidget: Widget {
  var body: some WidgetConfiguration {
    spiritualConfiguration(
      kind: duaWidgetKind,
      displayNameKey: "widget_dua_display_name",
      descriptionKey: "widget_dua_description"
    ) { entry in
      SpiritualWidgetView(payload: entry.dua)
    }
  }
}

struct PathOfNurHadithWidget: Widget {
  var body: some WidgetConfiguration {
    spiritualConfiguration(
      kind: hadithWidgetKind,
      displayNameKey: "widget_hadith_display_name",
      descriptionKey: "widget_hadith_description"
    ) { entry in
      SpiritualWidgetView(payload: entry.hadith)
    }
  }
}

struct PathOfNurAyahWidget: Widget {
  var body: some WidgetConfiguration {
    spiritualConfiguration(
      kind: ayahWidgetKind,
      displayNameKey: "widget_ayah_display_name",
      descriptionKey: "widget_ayah_description"
    ) { entry in
      SpiritualWidgetView(payload: entry.ayah)
    }
  }
}

struct PathOfNurReflectionWidget: Widget {
  var body: some WidgetConfiguration {
    spiritualConfiguration(
      kind: reflectionWidgetKind,
      displayNameKey: "widget_reflection_display_name",
      descriptionKey: "widget_reflection_description"
    ) { entry in
      SpiritualWidgetView(payload: entry.reflection)
    }
  }
}

struct PathOfNurNameOfAllahWidget: Widget {
  var body: some WidgetConfiguration {
    spiritualConfiguration(
      kind: nameOfAllahWidgetKind,
      displayNameKey: "widget_name_of_allah_display_name",
      descriptionKey: "widget_name_of_allah_description"
    ) { entry in
      SpiritualWidgetView(payload: entry.nameOfAllah)
    }
  }
}

@main
struct PathOfNurHomeWidgets: WidgetBundle {
  @WidgetBundleBuilder
  var body: some Widget {
    PathOfNurNextPrayerWidget()
    PathOfNurPrayerOverviewWidget()
    PathOfNurDhikrWidget()
    PathOfNurJourneyWidget()
    PathOfNurDuaWidget()
    PathOfNurHadithWidget()
    PathOfNurAyahWidget()
    PathOfNurReflectionWidget()
    PathOfNurNameOfAllahWidget()
  }
}

private struct NextPrayerWidgetView: View {
  @Environment(\.widgetFamily) private var family
  let entry: PathOfNurWidgetEntry

  var body: some View {
    if let payload = entry.nextPrayer {
      Group {
        switch family {
        case .accessoryInline:
          NextPrayerInlineAccessoryView(payload: payload)
        case .accessoryCircular:
          NextPrayerCircularAccessoryView(payload: payload)
        case .accessoryRectangular:
          NextPrayerRectangularAccessoryView(payload: payload)
        default:
          WidgetCard {
            VStack(alignment: .leading, spacing: 10) {
              WidgetHeader(title: payload.title, subtitle: payload.dateLine)
              Spacer(minLength: 0)
              if let currentPrayerName = payload.currentPrayerName {
                VStack(alignment: .leading, spacing: 2) {
                  Text(payload.currentPrayerLabel.uppercased())
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                    .foregroundStyle(.secondary)
                  Text(currentPrayerName)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                  if let currentPrayerArabicName = payload.currentPrayerArabicName {
                    Text(currentPrayerArabicName)
                      .font(.system(size: 12, weight: .medium, design: .rounded))
                      .foregroundStyle(.secondary)
                      .frame(maxWidth: .infinity, alignment: .trailing)
                  }
                }
              }
              VStack(alignment: .leading, spacing: 4) {
                Text(payload.nextPrayerLabel.uppercased())
                  .font(.system(size: 10, weight: .semibold, design: .rounded))
                  .foregroundStyle(.secondary)
                if let nextPrayerName = payload.nextPrayerName {
                  Text(nextPrayerName)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .lineLimit(1)
                } else {
                  Text(payload.fallbackTitle)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .lineLimit(2)
                }
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                  if let nextPrayerTime = payload.nextPrayerTime {
                    Text(nextPrayerTime, style: .timer)
                      .font(.system(size: 13, weight: .semibold, design: .rounded))
                      .foregroundStyle(PathOfNurWidgetPalette.accent)
                      .lineLimit(1)
                  } else {
                    Text(payload.fallbackBody)
                      .font(.system(size: 11, weight: .medium, design: .rounded))
                      .foregroundStyle(.secondary)
                      .lineLimit(2)
                  }
                  Spacer(minLength: 0)
                  if let nextPrayerTimeLabel = payload.nextPrayerTimeLabel {
                    Text(nextPrayerTimeLabel)
                      .font(.system(size: 11, weight: .medium, design: .rounded))
                      .foregroundStyle(.secondary)
                      .lineLimit(1)
                  }
                }
              }
            }
          }
        }
      }
      .widgetURL(URL(string: payload.deepLinkUrl))
    } else {
      WidgetFallbackView(
        title: "Next Prayer",
        message: "Open Path of Nūr to load your prayer snapshot."
      )
    }
  }
}

private struct PrayerOverviewWidgetView: View {
  let entry: PathOfNurWidgetEntry

  var body: some View {
    if let payload = entry.prayerOverview {
      WidgetCard {
        VStack(alignment: .leading, spacing: 10) {
          HStack(alignment: .top) {
            WidgetHeader(title: payload.title, subtitle: payload.dateLine)
            Spacer(minLength: 8)
            VStack(alignment: .trailing, spacing: 4) {
              Text("\(payload.completedPrayerCount)/\(max(payload.totalPrayerCount, 1))")
                .font(.system(size: 18, weight: .bold, design: .rounded))
              Text("\(payload.phaseProgressPercent)%")
                .font(.system(size: 11, weight: .semibold, design: .rounded))
                .foregroundStyle(.secondary)
            }
          }
          ProgressView(value: Double(payload.phaseProgressPercent), total: 100)
            .tint(PathOfNurWidgetPalette.accent)
          HStack(spacing: 8) {
            ForEach(payload.items, id: \.id) { item in
              PrayerOverviewColumn(item: item)
            }
          }
        }
      }
      .widgetURL(URL(string: payload.deepLinkUrl))
    } else {
      WidgetFallbackView(
        title: "Prayer Overview",
        message: "Open Path of Nūr to refresh today’s prayer schedule."
      )
    }
  }
}

private struct PrayerOverviewColumn: View {
  let item: PrayerItemPayload

  var body: some View {
    VStack(spacing: 6) {
      ZStack {
        RoundedRectangle(cornerRadius: 14, style: .continuous)
          .fill(backgroundColor)
        VStack(spacing: 4) {
          Text(item.name)
            .font(.system(size: 12, weight: .bold, design: .rounded))
            .lineLimit(1)
          Text(item.timeLabel)
            .font(.system(size: 11, weight: .medium, design: .rounded))
            .foregroundStyle(.secondary)
            .lineLimit(1)
          Text(item.arabicName)
            .font(.system(size: 11, weight: .medium, design: .rounded))
            .foregroundStyle(.secondary)
            .lineLimit(1)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 6)
      }
      .overlay(
        RoundedRectangle(cornerRadius: 14, style: .continuous)
          .stroke(borderColor, lineWidth: item.isCurrent || item.isNext ? 1.2 : 0.6)
      )
    }
    .frame(maxWidth: .infinity)
  }

  private var backgroundColor: LinearGradient {
    if item.isCurrent {
      return PathOfNurWidgetPalette.currentGradient
    }
    if item.isNext {
      return PathOfNurWidgetPalette.nextGradient
    }
    if item.isCompleted {
      return LinearGradient(
        colors: [Color.white.opacity(0.18), Color.white.opacity(0.08)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
    }
    return PathOfNurWidgetPalette.baseGradient
  }

  private var borderColor: Color {
    if item.isCurrent {
      return PathOfNurWidgetPalette.currentBorder
    }
    if item.isNext {
      return PathOfNurWidgetPalette.accent
    }
    return Color.white.opacity(0.12)
  }
}

private struct DhikrWidgetView: View {
  @Environment(\.widgetFamily) private var family
  let entry: PathOfNurWidgetEntry

  var body: some View {
    if let payload = entry.dhikr {
      Group {
        switch family {
        case .accessoryInline:
          DhikrInlineAccessoryView(payload: payload)
        case .accessoryCircular:
          DhikrCircularAccessoryView(payload: payload)
        case .accessoryRectangular:
          DhikrRectangularAccessoryView(payload: payload)
        case .systemSmall:
          WidgetCard {
            VStack(alignment: .leading, spacing: 10) {
              WidgetHeader(title: payload.title, subtitle: payload.dateLine)
              Spacer(minLength: 0)
              HStack(alignment: .center, spacing: 12) {
                ProgressRing(progressPercent: payload.progressPercent)
                  .frame(width: 56, height: 56)
                VStack(alignment: .leading, spacing: 4) {
                  Text("\(payload.todayCount)")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                  Text("\(payload.todayLabel) · \(payload.targetCount) \(payload.targetLabel.lowercased())")
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                }
              }
            }
          }
        default:
          WidgetCard {
            HStack(spacing: 16) {
              VStack(alignment: .leading, spacing: 10) {
                WidgetHeader(title: payload.title, subtitle: payload.dateLine)
                Spacer(minLength: 0)
                HStack(spacing: 18) {
                  StatBlock(label: payload.todayLabel, value: "\(payload.todayCount)")
                  StatBlock(label: payload.targetLabel, value: "\(payload.targetCount)")
                }
              }
              Spacer(minLength: 0)
              ProgressRing(progressPercent: payload.progressPercent)
                .frame(width: 78, height: 78)
            }
          }
        }
      }
      .widgetURL(URL(string: payload.deepLinkUrl))
    } else {
      WidgetFallbackView(
        title: "Daily Dhikr",
        message: "Open Path of Nūr to load your dhikr progress."
      )
    }
  }
}

private struct JourneyWidgetView: View {
  let entry: PathOfNurWidgetEntry

  var body: some View {
    if let payload = entry.journey {
      WidgetCard {
        VStack(alignment: .leading, spacing: 10) {
          WidgetHeader(title: payload.title, subtitle: payload.dateLine)
          Spacer(minLength: 0)
          HStack(alignment: .top, spacing: 10) {
            VStack(alignment: .leading, spacing: 4) {
              Text("\(payload.currentStreakDays)")
                .font(.system(size: 28, weight: .bold, design: .rounded))
              Text(payload.streakLabel)
                .font(.system(size: 11, weight: .semibold, design: .rounded))
                .foregroundStyle(.secondary)
            }
            Spacer(minLength: 0)
            VStack(alignment: .trailing, spacing: 4) {
              Text("\(payload.levelLabel) \(payload.currentLevel)")
                .font(.system(size: 13, weight: .bold, design: .rounded))
              Text("\(payload.todayXpLabel) \(payload.todayXp)")
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundStyle(.secondary)
            }
          }
          ProgressView(value: Double(payload.xpProgressPercent), total: 100)
            .tint(PathOfNurWidgetPalette.accent)
          Text("\(payload.totalXp) XP")
            .font(.system(size: 12, weight: .semibold, design: .rounded))
            .foregroundStyle(.secondary)
        }
      }
      .widgetURL(URL(string: payload.deepLinkUrl))
    } else {
      WidgetFallbackView(
        title: "Journey Progress",
        message: "Open Path of Nūr to refresh your progress snapshot."
      )
    }
  }
}

private struct SpiritualWidgetView: View {
  @Environment(\.widgetFamily) private var family
  let payload: SpiritualPayload?

  var body: some View {
    if let payload {
      Group {
        switch family {
        case .accessoryInline:
          SpiritualInlineAccessoryView(payload: payload)
        case .accessoryCircular:
          SpiritualCircularAccessoryView(payload: payload)
        case .accessoryRectangular:
          SpiritualRectangularAccessoryView(payload: payload)
        case .systemSmall:
          SpiritualSmallWidgetView(payload: payload)
        default:
          SpiritualMediumWidgetView(payload: payload)
        }
      }
      .widgetURL(URL(string: payload.deepLinkUrl))
    } else {
      WidgetFallbackView(
        title: widgetString("widget_spiritual_fallback_title"),
        message: widgetString("widget_spiritual_fallback_body")
      )
    }
  }
}

private struct SpiritualSmallWidgetView: View {
  let payload: SpiritualPayload

  var body: some View {
    WidgetCard {
      VStack(alignment: .leading, spacing: 10) {
        WidgetHeader(title: payload.title, subtitle: payload.dateLine)
        Spacer(minLength: 0)
        Text(payload.headline)
          .font(.system(size: 18, weight: .bold, design: .rounded))
          .lineLimit(2)
        if let arabicText = payload.arabicText, !arabicText.isEmpty {
          Text(arabicText)
            .font(.system(size: 15, weight: .semibold, design: .rounded))
            .lineLimit(2)
            .frame(maxWidth: .infinity, alignment: .trailing)
        } else {
          Text(payload.supportingText)
            .font(.system(size: 11, weight: .medium, design: .rounded))
            .foregroundStyle(.secondary)
            .lineLimit(3)
        }
        if let accentText = payload.accentText, !accentText.isEmpty {
          Text(accentText.uppercased())
            .font(.system(size: 10, weight: .semibold, design: .rounded))
            .foregroundStyle(PathOfNurWidgetPalette.accent)
            .lineLimit(1)
        } else {
          Text(payload.footerText)
            .font(.system(size: 10, weight: .medium, design: .rounded))
            .foregroundStyle(.secondary)
            .lineLimit(1)
        }
      }
    }
  }
}

private struct SpiritualMediumWidgetView: View {
  let payload: SpiritualPayload

  var body: some View {
    WidgetCard {
      HStack(alignment: .top, spacing: 14) {
        VStack(alignment: .leading, spacing: 8) {
          WidgetHeader(title: payload.title, subtitle: payload.dateLine)
          Text(payload.headline)
            .font(.system(size: 20, weight: .bold, design: .rounded))
            .lineLimit(2)
          Text(payload.supportingText)
            .font(.system(size: 12, weight: .medium, design: .rounded))
            .foregroundStyle(.secondary)
            .lineLimit(4)
          footerLine
        }
        Spacer(minLength: 0)
        VStack(alignment: .trailing, spacing: 8) {
          if let arabicText = payload.arabicText, !arabicText.isEmpty {
            Text(arabicText)
              .font(.system(size: 17, weight: .semibold, design: .rounded))
              .multilineTextAlignment(.trailing)
              .lineLimit(3)
          }
          if let transliterationText = payload.transliterationText, !transliterationText.isEmpty {
            Text(transliterationText)
              .font(.system(size: 10, weight: .medium, design: .rounded))
              .foregroundStyle(.secondary)
              .multilineTextAlignment(.trailing)
              .lineLimit(3)
          }
          Spacer(minLength: 0)
        }
        .frame(maxWidth: 120, alignment: .trailing)
      }
    }
  }

  @ViewBuilder
  private var footerLine: some View {
    if let accentText = payload.accentText, !accentText.isEmpty {
      Text(accentText)
        .font(.system(size: 11, weight: .semibold, design: .rounded))
        .foregroundStyle(PathOfNurWidgetPalette.accent)
        .lineLimit(1)
    } else {
      Text(payload.footerText)
        .font(.system(size: 11, weight: .medium, design: .rounded))
        .foregroundStyle(.secondary)
        .lineLimit(2)
    }
  }
}

private struct SpiritualInlineAccessoryView: View {
  let payload: SpiritualPayload

  var body: some View {
    Text(payload.accessoryInlineText)
  }
}

private struct SpiritualCircularAccessoryView: View {
  let payload: SpiritualPayload

  var body: some View {
    ZStack {
      AccessoryCircularBackground()
      VStack(spacing: 2) {
        Text(payload.accessoryCircularText)
          .font(.system(size: 11, weight: .bold, design: .rounded))
          .lineLimit(1)
        Text(compactCaption)
          .font(.system(size: 7, weight: .medium, design: .rounded))
          .foregroundStyle(.secondary)
          .lineLimit(1)
      }
    }
    .widgetURL(URL(string: payload.deepLinkUrl))
  }

  private var compactCaption: String {
    String(payload.title.prefix(4))
  }
}

private struct SpiritualRectangularAccessoryView: View {
  let payload: SpiritualPayload

  var body: some View {
    VStack(alignment: .leading, spacing: 2) {
      Text(payload.accessoryRectangularTitle)
        .font(.caption2)
        .foregroundStyle(.secondary)
        .lineLimit(1)
      Text(payload.accessoryRectangularBody)
        .font(.headline)
        .lineLimit(2)
      Text(payload.footerText)
        .font(.caption)
        .foregroundStyle(.secondary)
        .lineLimit(1)
    }
    .widgetURL(URL(string: payload.deepLinkUrl))
  }
}

private struct NextPrayerInlineAccessoryView: View {
  let payload: NextPrayerPayload

  var body: some View {
    if let nextPrayerName = payload.nextPrayerName {
      HStack(spacing: 4) {
        Text(nextPrayerName)
          .fontWeight(.semibold)
        if let nextPrayerTime = payload.nextPrayerTime {
          Text(nextPrayerTime, style: .timer)
        } else if let nextPrayerTimeLabel = payload.nextPrayerTimeLabel {
          Text(nextPrayerTimeLabel)
        } else {
          Text(payload.nextPrayerCountdownLabel)
        }
      }
    } else {
      Text(payload.fallbackTitle)
    }
  }
}

private struct NextPrayerCircularAccessoryView: View {
  let payload: NextPrayerPayload

  var body: some View {
    Gauge(value: progressValue) {
      Image(systemName: "moon.stars.fill")
    } currentValueLabel: {
      VStack(spacing: 1) {
        Text(shortPrayerName)
          .font(.system(size: 12, weight: .bold, design: .rounded))
        if let nextPrayerTime = payload.nextPrayerTime {
          Text(nextPrayerTime, style: .timer)
            .font(.system(size: 8, weight: .medium, design: .rounded))
        } else {
          Text(payload.nextPrayerCountdownLabel)
            .font(.system(size: 8, weight: .medium, design: .rounded))
        }
      }
    }
    .gaugeStyle(.accessoryCircularCapacity)
    .tint(PathOfNurWidgetPalette.accent)
    .widgetURL(URL(string: payload.deepLinkUrl))
  }

  private var shortPrayerName: String {
    guard let nextPrayerName = payload.nextPrayerName, let first = nextPrayerName.first else {
      return "•"
    }
    return String(first)
  }

  private var progressValue: Double {
    guard let nextPrayerTime = payload.nextPrayerTime else { return 0.0 }
    let interval = nextPrayerTime.timeIntervalSinceNow
    if interval <= 0 { return 1.0 }
    let capped = min(max(interval / (4 * 60 * 60), 0.0), 1.0)
    return 1.0 - capped
  }
}

private struct NextPrayerRectangularAccessoryView: View {
  let payload: NextPrayerPayload

  var body: some View {
    VStack(alignment: .leading, spacing: 2) {
      Text(payload.title)
        .font(.caption2)
        .foregroundStyle(.secondary)
      if let nextPrayerName = payload.nextPrayerName {
        Text(nextPrayerNameLine(nextPrayerName))
          .font(.headline)
          .lineLimit(1)
      } else {
        Text(payload.fallbackTitle)
          .font(.headline)
          .lineLimit(1)
      }
      if let nextPrayerTime = payload.nextPrayerTime {
        Text(nextPrayerTime, style: .timer)
          .font(.caption)
          .foregroundStyle(.secondary)
      } else if let nextPrayerTimeLabel = payload.nextPrayerTimeLabel {
        Text(nextPrayerTimeLabel)
          .font(.caption)
          .foregroundStyle(.secondary)
      } else {
        Text(payload.nextPrayerCountdownLabel)
          .font(.caption)
          .foregroundStyle(.secondary)
      }
    }
    .widgetURL(URL(string: payload.deepLinkUrl))
  }

  private func nextPrayerNameLine(_ nextPrayerName: String) -> String {
    if let nextPrayerTimeLabel = payload.nextPrayerTimeLabel {
      return "\(nextPrayerName) · \(nextPrayerTimeLabel)"
    }
    return nextPrayerName
  }
}

private struct DhikrInlineAccessoryView: View {
  let payload: DhikrPayload

  var body: some View {
    Text("Dhikr \(payload.todayCount)/\(max(payload.targetCount, 1))")
  }
}

private struct DhikrCircularAccessoryView: View {
  let payload: DhikrPayload

  var body: some View {
    Gauge(value: Double(payload.progressPercent), in: 0...100) {
      Image(systemName: "circle.grid.2x2.fill")
    } currentValueLabel: {
      Text("\(payload.todayCount)")
        .font(.system(size: 10, weight: .bold, design: .rounded))
    }
    .gaugeStyle(.accessoryCircularCapacity)
    .tint(PathOfNurWidgetPalette.accent)
    .widgetURL(URL(string: payload.deepLinkUrl))
  }
}

private struct DhikrRectangularAccessoryView: View {
  let payload: DhikrPayload

  var body: some View {
    VStack(alignment: .leading, spacing: 2) {
      Text(payload.title)
        .font(.caption2)
        .foregroundStyle(.secondary)
      Text("\(payload.todayCount) / \(max(payload.targetCount, 1))")
        .font(.headline)
      Text("\(payload.progressPercent)%")
        .font(.caption)
        .foregroundStyle(.secondary)
    }
    .widgetURL(URL(string: payload.deepLinkUrl))
  }
}

private struct WidgetHeader: View {
  let title: String
  let subtitle: String

  var body: some View {
    VStack(alignment: .leading, spacing: 3) {
      Text(title)
        .font(.system(size: 14, weight: .bold, design: .rounded))
        .lineLimit(1)
      Text(subtitle)
        .font(.system(size: 10, weight: .medium, design: .rounded))
        .foregroundStyle(.secondary)
        .lineLimit(1)
    }
  }
}

private struct ProgressRing: View {
  let progressPercent: Int

  var body: some View {
    ZStack {
      Circle()
        .stroke(Color.white.opacity(0.12), lineWidth: 8)
      Circle()
        .trim(from: 0, to: CGFloat(max(0, min(progressPercent, 100))) / 100.0)
        .stroke(
          PathOfNurWidgetPalette.accentGradient,
          style: StrokeStyle(lineWidth: 8, lineCap: .round)
        )
        .rotationEffect(.degrees(-90))
      Text("\(progressPercent)%")
        .font(.system(size: 12, weight: .bold, design: .rounded))
    }
  }
}

private struct StatBlock: View {
  let label: String
  let value: String

  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(value)
        .font(.system(size: 24, weight: .bold, design: .rounded))
      Text(label)
        .font(.system(size: 11, weight: .medium, design: .rounded))
        .foregroundStyle(.secondary)
    }
  }
}

private struct AccessoryCircularBackground: View {
  var body: some View {
    Circle()
      .fill(
        LinearGradient(
          colors: [Color.white.opacity(0.14), Color.white.opacity(0.05)],
          startPoint: .topLeading,
          endPoint: .bottomTrailing
        )
      )
      .overlay(
        Circle()
          .stroke(Color.white.opacity(0.12), lineWidth: 0.8)
      )
  }
}

private struct WidgetFallbackView: View {
  let title: String
  let message: String

  var body: some View {
    WidgetCard {
      VStack(alignment: .leading, spacing: 8) {
        Text(title)
          .font(.system(size: 16, weight: .bold, design: .rounded))
        Text(message)
          .font(.system(size: 12, weight: .medium, design: .rounded))
          .foregroundStyle(.secondary)
          .lineLimit(3)
      }
    }
  }
}

private struct WidgetCard<Content: View>: View {
  @ViewBuilder let content: Content

  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 24, style: .continuous)
        .fill(PathOfNurWidgetPalette.backgroundGradient)
      RoundedRectangle(cornerRadius: 24, style: .continuous)
        .stroke(Color.white.opacity(0.14), lineWidth: 0.8)
      content
        .padding(16)
    }
    .modifier(WidgetBackgroundModifier())
  }
}

private struct WidgetBackgroundModifier: ViewModifier {
  func body(content: Content) -> some View {
    if #available(iOSApplicationExtension 17.0, *) {
      content.containerBackground(for: .widget) {
        PathOfNurWidgetPalette.backgroundGradient
      }
    } else {
      content.background(PathOfNurWidgetPalette.backgroundGradient)
    }
  }
}

private enum PathOfNurWidgetPalette {
  static let accent = Color(red: 0.95, green: 0.81, blue: 0.55)
  static let currentBorder = Color(red: 0.77, green: 0.90, blue: 0.92)

  static let backgroundGradient = LinearGradient(
    colors: [
      Color(red: 0.12, green: 0.17, blue: 0.22),
      Color(red: 0.08, green: 0.12, blue: 0.17)
    ],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
  )

  static let baseGradient = LinearGradient(
    colors: [Color.white.opacity(0.08), Color.white.opacity(0.03)],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
  )

  static let accentGradient = LinearGradient(
    colors: [
      Color(red: 0.93, green: 0.83, blue: 0.60),
      Color(red: 0.70, green: 0.86, blue: 0.86)
    ],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
  )

  static let currentGradient = LinearGradient(
    colors: [
      Color(red: 0.38, green: 0.58, blue: 0.60).opacity(0.32),
      Color(red: 0.16, green: 0.24, blue: 0.28).opacity(0.42)
    ],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
  )

  static let nextGradient = LinearGradient(
    colors: [
      Color(red: 0.80, green: 0.66, blue: 0.42).opacity(0.24),
      Color(red: 0.18, green: 0.22, blue: 0.28).opacity(0.40)
    ],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
  )
}

private func spiritualConfiguration<Content: View>(
  kind: String,
  displayNameKey: String,
  descriptionKey: String,
  @ViewBuilder content: @escaping (PathOfNurWidgetEntry) -> Content
) -> some WidgetConfiguration {
  StaticConfiguration(kind: kind, provider: PathOfNurWidgetProvider(), content: content)
    .configurationDisplayName(widgetString(displayNameKey))
    .description(widgetString(descriptionKey))
    .supportedFamilies([.systemSmall, .systemMedium, .accessoryInline, .accessoryCircular, .accessoryRectangular])
}

private func widgetString(_ key: String) -> String {
  NSLocalizedString(key, comment: "")
}

private func decodeDate(_ value: String) -> Date? {
  iso8601Formatter.date(from: value) ?? iso8601FallbackFormatter.date(from: value)
}

private extension Date {
  func toISO8601String() -> String {
    iso8601Formatter.string(from: self)
  }
}
