import ActivityKit
import SwiftUI
import WidgetKit

struct PrayerCountdownAttributes: ActivityAttributes {
  public struct ContentState: Codable, Hashable {
    var prayerId: String
    var prayerName: String
    var prayerArabicName: String
    var remainingSeconds: Int
    var endAtEpoch: Int
  }

  var prayerId: String
  var prayerName: String
}

struct PrayerLiveActivityWidget: Widget {
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: PrayerCountdownAttributes.self) { context in
      VStack(alignment: .leading, spacing: 8) {
        Text("Path of Nūr")
          .font(.caption)
          .foregroundStyle(.secondary)
        Text(context.state.prayerName)
          .font(.headline)
        if !context.state.prayerArabicName.isEmpty {
          Text(context.state.prayerArabicName)
            .font(.title3)
        }
        HStack {
          Image(systemName: "clock")
          Text(timeLeftText(context.state.remainingSeconds))
            .fontWeight(.semibold)
        }
      }
      .padding()
      .activityBackgroundTint(Color(.systemBackground))
      .activitySystemActionForegroundColor(Color.accentColor)
    } dynamicIsland: { context in
      DynamicIsland {
        DynamicIslandExpandedRegion(.leading) {
          Text(context.state.prayerName)
            .font(.headline)
        }
        DynamicIslandExpandedRegion(.trailing) {
          Text(timeLeftText(context.state.remainingSeconds))
            .font(.headline)
        }
        DynamicIslandExpandedRegion(.bottom) {
          VStack(spacing: 4) {
            if !context.state.prayerArabicName.isEmpty {
              Text(context.state.prayerArabicName)
                .font(.title3)
            }
            Text("Next prayer in \(timeLeftText(context.state.remainingSeconds))")
              .font(.caption)
              .foregroundStyle(.secondary)
          }
        }
      } compactLeading: {
        Text(shortPrayerLabel(context.state.prayerName))
          .font(.caption2)
      } compactTrailing: {
        Text(compactTimeLeft(context.state.remainingSeconds))
          .font(.caption2)
      } minimal: {
        Image(systemName: "moon.stars.fill")
      }
    }
  }
}

@main
struct PrayerLiveActivityBundle: WidgetBundle {
  var body: some Widget {
    PrayerLiveActivityWidget()
  }
}

private func timeLeftText(_ seconds: Int) -> String {
  let clamped = max(0, seconds)
  let hours = clamped / 3600
  let minutes = (clamped % 3600) / 60
  if hours > 0 {
    return "\(hours)h \(minutes)m"
  }
  return "\(minutes)m"
}

private func compactTimeLeft(_ seconds: Int) -> String {
  let clamped = max(0, seconds)
  let minutes = clamped / 60
  return "\(minutes)m"
}

private func shortPrayerLabel(_ value: String) -> String {
  switch value.lowercased() {
  case "fajr":
    return "Fjr"
  case "dhuhr":
    return "Dhr"
  case "asr":
    return "Asr"
  case "maghrib":
    return "Mgr"
  case "isha":
    return "Ish"
  default:
    return "Pr"
  }
}

