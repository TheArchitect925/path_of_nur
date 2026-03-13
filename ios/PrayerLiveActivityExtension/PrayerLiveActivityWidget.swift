import ActivityKit
import SwiftUI
import WidgetKit

struct PrayerCountdownAttributes: ActivityAttributes {
  public struct ContentState: Codable, Hashable {
    var showCurrentPrayer: Bool
    var currentPrayerId: String?
    var currentPrayerName: String?
    var currentPrayerArabicName: String?
    var currentRemainingSeconds: Int?
    var showRamadanCountdown: Bool
    var ramadanPrayerId: String?
    var ramadanPrayerName: String?
    var ramadanPrayerArabicName: String?
    var ramadanRemainingSeconds: Int?
    var ramadanTargetAtEpoch: Int?
    var nextPrayerId: String
    var nextPrayerName: String
    var nextPrayerArabicName: String
    var nextRemainingSeconds: Int
    var nextTargetAtEpoch: Int
  }

  var nextPrayerId: String
  var nextPrayerName: String
}

struct QuranPlaybackAttributes: ActivityAttributes {
  public struct ContentState: Codable, Hashable {
    var surahNumber: Int
    var surahName: String
    var surahArabicName: String
    var ayahNumber: Int
    var reciterName: String
    var isPlaying: Bool
    var elapsedSeconds: Int
    var totalSeconds: Int
  }

  var sessionId: String
}

struct PrayerLiveActivityWidget: Widget {
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: PrayerCountdownAttributes.self) { context in
      PrayerLiveLockscreenCard(state: context.state)
        .activityBackgroundTint(Color(hex: 0x0D2030, alpha: 0.92))
        .activitySystemActionForegroundColor(Color(hex: 0xD8C49A))
    } dynamicIsland: { context in
      DynamicIsland {
        DynamicIslandExpandedRegion(.leading) {
          Text(primaryPrayerName(context.state))
            .font(.headline)
            .foregroundStyle(Color(hex: 0xF3EEE5))
        }
        DynamicIslandExpandedRegion(.trailing) {
          countdownText(
            seconds: primaryRemainingSeconds(context.state),
            targetEpoch: primaryTargetEpoch(context.state),
            font: .headline
          )
            .foregroundStyle(Color(hex: 0xF3EEE5))
        }
        DynamicIslandExpandedRegion(.bottom) {
          VStack(spacing: 6) {
            if context.state.showRamadanCountdown,
               let ramadanName = context.state.ramadanPrayerName,
               let ramadanArabic = context.state.ramadanPrayerArabicName,
               let ramadanRemaining = context.state.ramadanRemainingSeconds {
              _DynamicRow(
                label: "Ramadan",
                name: "Open Fast",
                arabicName: ramadanArabic.isEmpty ? ramadanName : ramadanArabic,
                valueLabel: "Time to iftar",
                seconds: ramadanRemaining,
                targetEpoch: context.state.ramadanTargetAtEpoch
              )
            }
            if context.state.showCurrentPrayer,
               let currentName = context.state.currentPrayerName,
               let currentArabic = context.state.currentPrayerArabicName,
               let currentRemaining = context.state.currentRemainingSeconds {
              _DynamicRow(
                label: "Current Prayer",
                name: currentName,
                arabicName: currentArabic,
                valueLabel: "Remaining time",
                seconds: currentRemaining,
                targetEpoch: context.state.nextTargetAtEpoch
              )
            }
            _DynamicRow(
              label: "Next Prayer",
              name: context.state.nextPrayerName,
              arabicName: context.state.nextPrayerArabicName,
              valueLabel: "Starts in",
              seconds: context.state.nextRemainingSeconds,
              targetEpoch: context.state.nextTargetAtEpoch
            )
          }
        }
      } compactLeading: {
        Text(shortPrayerLabel(primaryPrayerName(context.state)))
          .font(.caption2)
          .foregroundStyle(Color(hex: 0xE8D9C0))
      } compactTrailing: {
        countdownText(
          seconds: primaryRemainingSeconds(context.state),
          targetEpoch: primaryTargetEpoch(context.state),
          font: .caption2,
          compact: true
        )
          .foregroundStyle(Color(hex: 0xE8D9C0))
      } minimal: {
        Image(systemName: "moon.stars.fill")
          .foregroundStyle(Color(hex: 0xC6A978))
      }
    }
  }
}

private struct PrayerLiveLockscreenCard: View {
  let state: PrayerCountdownAttributes.ContentState

  var body: some View {
    ViewThatFits(in: .vertical) {
      fullLayout
      compactLayout
    }
  }

  private var fullLayout: some View {
    ZStack {
      cardBackground
      VStack(spacing: 10) {
        if state.showRamadanCountdown,
           let ramadanName = state.ramadanPrayerName,
           let ramadanArabic = state.ramadanPrayerArabicName,
           let ramadanRemaining = state.ramadanRemainingSeconds {
          _PrayerSection(
            sectionLabel: "Ramadan",
            prayerName: "Open Fast",
            prayerArabicName: ramadanArabic.isEmpty ? ramadanName : ramadanArabic,
            metricLabel: "Time to iftar",
            seconds: ramadanRemaining,
            targetEpoch: state.ramadanTargetAtEpoch,
            prominent: true
          )
          Divider()
            .overlay(Color.white.opacity(0.14))
            .padding(.horizontal, 8)
        }
        if state.showCurrentPrayer,
           let currentName = state.currentPrayerName,
           let currentArabic = state.currentPrayerArabicName,
           let currentRemaining = state.currentRemainingSeconds {
          _PrayerSection(
            sectionLabel: "Current Prayer",
            prayerName: currentName,
            prayerArabicName: currentArabic,
            metricLabel: "Remaining time",
            seconds: currentRemaining,
            targetEpoch: state.nextTargetAtEpoch,
            prominent: true
          )
          Divider()
            .overlay(Color.white.opacity(0.14))
            .padding(.horizontal, 8)
        }

        _PrayerSection(
          sectionLabel: "Next Prayer",
          prayerName: state.nextPrayerName,
          prayerArabicName: state.nextPrayerArabicName,
          metricLabel: "Starts in",
          seconds: state.nextRemainingSeconds,
          targetEpoch: state.nextTargetAtEpoch,
          prominent: false
        )
      }
      .padding(.vertical, 12)
      .padding(.horizontal, 12)
    }
  }

  private var compactLayout: some View {
    ZStack {
      cardBackground
      VStack(spacing: 8) {
        if state.showRamadanCountdown,
           let ramadanName = state.ramadanPrayerName,
           let ramadanArabic = state.ramadanPrayerArabicName,
           let ramadanRemaining = state.ramadanRemainingSeconds {
          _PrayerSection(
            sectionLabel: "Ramadan",
            prayerName: "Open Fast",
            prayerArabicName: ramadanArabic.isEmpty ? ramadanName : ramadanArabic,
            metricLabel: "Time to iftar",
            seconds: ramadanRemaining,
            targetEpoch: state.ramadanTargetAtEpoch,
            prominent: true,
            compact: true
          )
        }
        if state.showCurrentPrayer,
           let currentName = state.currentPrayerName,
           let currentArabic = state.currentPrayerArabicName,
           let currentRemaining = state.currentRemainingSeconds {
          _PrayerSection(
            sectionLabel: "Current Prayer",
            prayerName: currentName,
            prayerArabicName: currentArabic,
            metricLabel: "Remaining time",
            seconds: currentRemaining,
            targetEpoch: state.nextTargetAtEpoch,
            prominent: false,
            compact: true
          )
        }

        _PrayerSection(
          sectionLabel: "Next Prayer",
          prayerName: state.nextPrayerName,
          prayerArabicName: state.nextPrayerArabicName,
          metricLabel: "Starts in",
          seconds: state.nextRemainingSeconds,
          targetEpoch: state.nextTargetAtEpoch,
          prominent: false,
          compact: true
        )
      }
      .padding(.vertical, 10)
      .padding(.horizontal, 12)
    }
  }

  private var cardBackground: some View {
    RoundedRectangle(cornerRadius: 18, style: .continuous)
      .fill(
        LinearGradient(
          colors: [
            Color(hex: 0x0B1D2A, alpha: 0.86),
            Color(hex: 0x10313D, alpha: 0.82),
            Color(hex: 0x112939, alpha: 0.80),
          ],
          startPoint: .topLeading,
          endPoint: .bottomTrailing
        )
      )
      .overlay(
        RoundedRectangle(cornerRadius: 18, style: .continuous)
          .stroke(Color(hex: 0x8CC4BF, alpha: 0.18), lineWidth: 1)
      )
  }
}

private struct _PrayerSection: View {
  let sectionLabel: String
  let prayerName: String
  let prayerArabicName: String
  let metricLabel: String
  let seconds: Int
  let targetEpoch: Int?
  let prominent: Bool
  let compact: Bool

  init(
    sectionLabel: String,
    prayerName: String,
    prayerArabicName: String,
    metricLabel: String,
    seconds: Int,
    targetEpoch: Int? = nil,
    prominent: Bool,
    compact: Bool = false
  ) {
    self.sectionLabel = sectionLabel
    self.prayerName = prayerName
    self.prayerArabicName = prayerArabicName
    self.metricLabel = metricLabel
    self.seconds = seconds
    self.targetEpoch = targetEpoch
    self.prominent = prominent
    self.compact = compact
  }

  var body: some View {
    VStack(spacing: compact ? 2 : 4) {
      Text(sectionLabel)
        .font(.caption2)
        .foregroundStyle(Color(hex: 0xA7B9C4))
      Text(prayerName)
        .font(prominent ? .title3.weight(.semibold) : .headline.weight(.semibold))
        .foregroundStyle(Color(hex: 0xF3EEE5))
        .lineLimit(1)
        .minimumScaleFactor(0.82)
      if !prayerArabicName.isEmpty {
        Text(prayerArabicName)
          .font(compact ? .subheadline.weight(.medium) : .title3.weight(.medium))
          .foregroundStyle(Color(hex: 0xD8E6EA))
          .lineLimit(1)
          .minimumScaleFactor(0.82)
      }
      HStack(spacing: 4) {
        Text(metricLabel)
          .font(.caption2)
          .foregroundStyle(Color(hex: 0xA7B9C4))
        countdownText(
          seconds: seconds,
          targetEpoch: targetEpoch,
          font: compact ? .caption.weight(.semibold) : .subheadline.weight(.semibold)
        )
          .foregroundStyle(Color(hex: 0xE8D9C0))
      }
    }
    .frame(maxWidth: .infinity)
    .multilineTextAlignment(.center)
  }
}

private struct _DynamicRow: View {
  let label: String
  let name: String
  let arabicName: String
  let valueLabel: String
  let seconds: Int
  let targetEpoch: Int?

  var body: some View {
    VStack(spacing: 2) {
      Text(label)
        .font(.caption2)
        .foregroundStyle(Color(hex: 0xA7B9C4))
      Text("\(name) \(arabicName)")
        .font(.caption.weight(.semibold))
        .foregroundStyle(Color(hex: 0xF3EEE5))
        .lineLimit(1)
        .minimumScaleFactor(0.82)
      HStack(spacing: 3) {
        Text("\(valueLabel):")
          .font(.caption2)
        countdownText(seconds: seconds, targetEpoch: targetEpoch, font: .caption2)
      }
        .foregroundStyle(Color(hex: 0xD8E6EA))
    }
    .frame(maxWidth: .infinity)
    .multilineTextAlignment(.center)
  }
}

@main
struct PrayerLiveActivityBundle: WidgetBundle {
  var body: some Widget {
    PrayerLiveActivityWidget()
    QuranPlaybackLiveActivityWidget()
  }
}

struct QuranPlaybackLiveActivityWidget: Widget {
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: QuranPlaybackAttributes.self) { context in
      QuranPlaybackLockscreenCard(state: context.state)
        .activityBackgroundTint(Color.black.opacity(0.20))
        .activitySystemActionForegroundColor(Color(hex: 0xD8C49A))
    } dynamicIsland: { context in
      DynamicIsland {
        DynamicIslandExpandedRegion(.leading) {
          VStack(alignment: .leading, spacing: 2) {
            Text("Qur’an")
              .font(.caption2.weight(.semibold))
              .foregroundStyle(Color(hex: 0xA7B9C4))
            Text(shortPrayerLabel(context.state.surahName))
              .font(.headline)
              .lineLimit(1)
              .foregroundStyle(Color(hex: 0xF3EEE5))
          }
        }
        DynamicIslandExpandedRegion(.trailing) {
          Text(quranTimerText(state: context.state))
            .font(.headline)
            .monospacedDigit()
            .foregroundStyle(Color(hex: 0xE8D9C0))
        }
        DynamicIslandExpandedRegion(.bottom) {
          HStack(spacing: 14) {
            _QuranControlPill(icon: "gobackward.15")
            _QuranControlPill(
              icon: context.state.isPlaying ? "pause.fill" : "play.fill",
              prominent: true
            )
            _QuranControlPill(icon: "goforward.15")
          }
        }
      } compactLeading: {
        Image(systemName: context.state.isPlaying ? "pause.circle.fill" : "play.circle.fill")
          .foregroundStyle(Color(hex: 0xE8D9C0))
      } compactTrailing: {
        Text(compactQuranTimerText(state: context.state))
          .font(.caption2)
          .monospacedDigit()
          .foregroundStyle(Color(hex: 0xE8D9C0))
      } minimal: {
        Image(systemName: context.state.isPlaying ? "pause.circle.fill" : "play.circle.fill")
          .foregroundStyle(Color(hex: 0xE8D9C0))
      }
    }
  }
}


private struct QuranPlaybackLockscreenCard: View {
  let state: QuranPlaybackAttributes.ContentState

  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 18, style: .continuous)
        .fill(
          LinearGradient(
            colors: [
              Color(hex: 0x0B1D2A, alpha: 0.86),
              Color(hex: 0x10313D, alpha: 0.82),
              Color(hex: 0x112939, alpha: 0.80),
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          )
        )
        .overlay(
          RoundedRectangle(cornerRadius: 18, style: .continuous)
            .stroke(Color(hex: 0x8CC4BF, alpha: 0.18), lineWidth: 1)
        )

      VStack(spacing: 8) {
        Text("Qur’an Playback")
          .font(.caption2.weight(.semibold))
          .foregroundStyle(Color(hex: 0xA7B9C4))
        Text("\(state.surahName) \(state.surahNumber):\(state.ayahNumber)")
          .font(.headline.weight(.semibold))
          .lineLimit(1)
          .minimumScaleFactor(0.82)
          .foregroundStyle(Color(hex: 0xF3EEE5))
        if !state.surahArabicName.isEmpty {
          Text(state.surahArabicName)
            .font(.title3.weight(.medium))
            .lineLimit(1)
            .minimumScaleFactor(0.82)
            .foregroundStyle(Color(hex: 0xD8E6EA))
        }
        Text(state.reciterName)
          .font(.caption)
          .lineLimit(1)
          .foregroundStyle(Color(hex: 0xA7B9C4))
        Text(quranTimerText(state: state))
          .font(.subheadline.weight(.semibold))
          .monospacedDigit()
          .foregroundStyle(Color(hex: 0xE8D9C0))
        ProgressView(
          value: quranProgressValue(state: state),
          total: 1.0
        )
        .tint(Color(hex: 0x8CC4BF))
        .padding(.horizontal, 12)

        HStack(spacing: 14) {
          _QuranControlPill(icon: "gobackward.15")
          _QuranControlPill(
            icon: state.isPlaying ? "pause.fill" : "play.fill",
            prominent: true
          )
          _QuranControlPill(icon: "goforward.15")
        }
        .padding(.top, 2)
      }
      .padding(.vertical, 12)
      .padding(.horizontal, 12)
    }
  }
}

private struct _QuranControlPill: View {
  let icon: String
  var prominent: Bool = false

  var body: some View {
    Image(systemName: icon)
      .font(prominent ? .headline.weight(.semibold) : .subheadline.weight(.semibold))
      .foregroundStyle(Color(hex: 0xF3EEE5))
      .frame(width: prominent ? 32 : 28, height: prominent ? 32 : 28)
      .background(
        Circle().fill(
          prominent
            ? Color(hex: 0xD8C49A, alpha: 0.28)
            : Color(hex: 0xD8C49A, alpha: 0.16)
        )
      )
  }
}

private func primaryPrayerName(_ state: PrayerCountdownAttributes.ContentState) -> String {
  if state.showRamadanCountdown {
    return "Iftar"
  }
  if state.showCurrentPrayer, let current = state.currentPrayerName, !current.isEmpty {
    return current
  }
  return state.nextPrayerName
}

private func primaryRemainingSeconds(_ state: PrayerCountdownAttributes.ContentState) -> Int {
  if state.showRamadanCountdown, let ramadanSeconds = state.ramadanRemainingSeconds {
    return max(0, ramadanSeconds)
  }
  if state.showCurrentPrayer, let currentSeconds = state.currentRemainingSeconds {
    return max(0, currentSeconds)
  }
  return max(0, state.nextRemainingSeconds)
}

private func primaryTargetEpoch(_ state: PrayerCountdownAttributes.ContentState) -> Int? {
  if state.showRamadanCountdown {
    return state.ramadanTargetAtEpoch
  }
  return state.nextTargetAtEpoch
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

@ViewBuilder
private func countdownText(
  seconds: Int,
  targetEpoch: Int?,
  font: Font,
  compact: Bool = false
) -> some View {
  if let targetEpoch {
    let endDate = Date(timeIntervalSince1970: TimeInterval(targetEpoch))
    Text(timerInterval: Date()...endDate, countsDown: true)
      .font(font)
      .monospacedDigit()
      .multilineTextAlignment(.trailing)
  } else {
    Text(compact ? compactTimeLeft(seconds) : timeLeftText(seconds))
      .font(font)
      .monospacedDigit()
  }
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
  case "tahajjud":
    return "Thj"
  default:
    return "Pr"
  }
}

private func quranProgressValue(state: QuranPlaybackAttributes.ContentState) -> Double {
  guard state.totalSeconds > 0 else { return 0 }
  let value = Double(max(0, state.elapsedSeconds)) / Double(state.totalSeconds)
  return min(max(value, 0), 1)
}

private func quranTimerText(state: QuranPlaybackAttributes.ContentState) -> String {
  let elapsed = max(0, state.elapsedSeconds)
  let total = max(0, state.totalSeconds)
  if total <= 0 {
    return "Elapsed \(compactTimeLeft(elapsed))"
  }
  return "\(compactTimeLeft(elapsed)) / \(compactTimeLeft(total))"
}

private func compactQuranTimerText(state: QuranPlaybackAttributes.ContentState) -> String {
  let total = max(0, state.totalSeconds)
  if total <= 0 {
    return compactTimeLeft(max(0, state.elapsedSeconds))
  }
  return compactTimeLeft(total - min(total, max(0, state.elapsedSeconds)))
}

private extension Color {
  init(hex: UInt, alpha: Double = 1.0) {
    let red = Double((hex >> 16) & 0xFF) / 255.0
    let green = Double((hex >> 8) & 0xFF) / 255.0
    let blue = Double(hex & 0xFF) / 255.0
    self.init(red: red, green: green, blue: blue, opacity: alpha)
  }
}
